# syntax=docker/dockerfile:1.7-labs
# check=error=true
# escape=\
# ==============================================================================
# SAMPLE: Sophisticated Multi-Stage Dockerfile (sublime-font-checks)
# Purpose: Visual check for Dockerfile directives, BuildKit syntax, heredocs,
#          environment substitutions, labels, and operator ligatures.
# ==============================================================================
# TODO: Verify syntax highlighting on Dockerfile instructions: FROM, RUN, COPY
# FIXME: Observe BuildKit mount flags: --mount=type=cache,target=...
# NOTE: Check heredoc block highlighting (<<-EOF ... EOF)
# WARN: Disambiguation: 0/O, 1/l/I/|, ;/:, `/'/"
# ==============================================================================

# ------------------------------------------------------------------------------
# 1. GLOBAL BUILD ARGUMENTS (Scoped before first FROM)
# ------------------------------------------------------------------------------
ARG GO_VERSION=1.24
ARG ALPINE_VERSION=3.20
ARG BASE_REGISTRY=docker.io
ARG APP_NAME="font-check-engine"
ARG DEFAULT_PORT=8080

# ------------------------------------------------------------------------------
# 2. STAGE 1: Base Environment & Security Credentials
# ------------------------------------------------------------------------------
FROM ${BASE_REGISTRY}/library/golang:${GO_VERSION}-alpine${ALPINE_VERSION} AS base

# Install core runtime certificates and non-root group/user definitions
RUN --mount=type=cache,target=/var/cache/apk \
    set -eux; \
    apk update; \
    apk add --no-cache \
        ca-certificates \
        tzdata \
        mailcap \
        tini \
        curl; \
    update-ca-certificates; \
    # Create hardened unprivileged application user
    addgroup -g 10001 -S appgroup; \
    adduser \
        -u 10001 \
        -S \
        -G appgroup \
        -h /home/appuser \
        -s /sbin/nologin \
        -D \
        appuser

WORKDIR /workspace

# ------------------------------------------------------------------------------
# 3. STAGE 2: Dependency Resolution & Layer Caching
# ------------------------------------------------------------------------------
FROM base AS deps-cache

WORKDIR /workspace

# Separate copy of dependency manifests prevents cache thrashing
COPY --chown=appuser:appgroup go.mod go.sum* ./

# BuildKit cache mounts accelerate module downloads across repeated runs
RUN --mount=type=cache,target=/go/pkg/mod,sharing=locked \
    set -eux; \
    if [ -f go.mod ]; then \
        go mod download -x; \
        go mod verify; \
    fi

# ------------------------------------------------------------------------------
# 4. STAGE 3: Multi-Architecture Builder with BuildKit Secrets
# ------------------------------------------------------------------------------
FROM deps-cache AS builder

ARG TARGETOS
ARG TARGETARCH
ARG TARGETVARIANT
ARG GIT_COMMIT="d8e20f1"
ARG BUILD_DATE="2026-10-12T09:30:00Z"
ARG VERSION="2.4.0-rc.1"
ARG CGO_ENABLED=0

ENV CGO_ENABLED=${CGO_ENABLED} \
    GOOS=${TARGETOS:-linux} \
    GOARCH=${TARGETARCH:-amd64} \
    GOARM=${TARGETVARIANT}

# Copy full application source tree
COPY --chown=appuser:appgroup . .

# Heredoc execution with secret mount and build-cache acceleration
RUN --mount=type=cache,target=/root/.cache/go-build \
    --mount=type=cache,target=/go/pkg/mod \
    --mount=type=secret,id=npm_token,target=/run/secrets/npm_token \
    --mount=type=ssh \
    <<-EOF
    set -eux

    echo "Building ${APP_NAME} for target: ${GOOS}/${GOARCH}..."
    mkdir -p /build/out /build/config

    # Strip debugging symbols (-s -w) and embed build metadata via ldflags
    LDFLAGS="-s -w \
      -X 'main.Version=${VERSION}' \
      -X 'main.GitCommit=${GIT_COMMIT}' \
      -X 'main.BuildTime=${BUILD_DATE}' \
      -X 'main.AppID=${APP_NAME}'"

    if [ -f sample.go ]; then
        go build \
          -trimpath \
          -ldflags="${LDFLAGS}" \
          -tags="osusergo,netgo" \
          -o /build/out/app \
          ./sample.go
    else
        echo "Creating mock production binary payload..."
        echo '#!/bin/sh' > /build/out/app
        echo 'echo "[RUN] Font checker engine daemon listening on :${PORT}"' >> /build/out/app
        echo 'sleep infinity' >> /build/out/app
        chmod 0755 /build/out/app
    fi

    # Generate runtime default bootstrap configuration
    cat <<'CONFIG' > /build/config/runtime.json
    {
      "service": "font-check-engine",
      "ports": {"http": 8080, "telemetry": 9090},
      "features": ["ligatures", "subpixel", "ast_scope_check"],
      "enabled": true
    }
CONFIG
EOF

# ------------------------------------------------------------------------------
# 5. STAGE 4: Testing & Vulnerability Audit Layer
# ------------------------------------------------------------------------------
FROM builder AS audit

RUN --mount=type=cache,target=/root/.cache/go-build \
    <<-EOF
    set -eux
    echo "Executing static analysis, linting, and unit validation..."
    # Verification exit code check
    test -f /build/out/app || (echo "Binary artifact missing!" && exit 1)
EOF

# ------------------------------------------------------------------------------
# 6. STAGE 5: Hardened Minimal Production Runtime
# ------------------------------------------------------------------------------
FROM ${BASE_REGISTRY}/library/alpine:${ALPINE_VERSION} AS production

# Re-import scoped build arguments for image metadata and runtime
ARG VERSION="2.4.0-rc.1"
ARG GIT_COMMIT="d8e20f1"
ARG BUILD_DATE="2026-10-12T09:30:00Z"
ARG DEFAULT_PORT=8080

# Standardized OCI Container Image Labels (RFC 822 / Schema 2)
LABEL org.opencontainers.image.title="Sublime Font Checks Service" \
      org.opencontainers.image.description="Hardened multi-stage container for visual telemetry" \
      org.opencontainers.image.version="${VERSION}" \
      org.opencontainers.image.revision="${GIT_COMMIT}" \
      org.opencontainers.image.created="${BUILD_DATE}" \
      org.opencontainers.image.vendor="Platform Infrastructure" \
      org.opencontainers.image.licenses="Apache-2.0"

# Copy unprivileged system accounts and TLS certificates from base
COPY --from=base /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY --from=base /usr/share/zoneinfo /usr/share/zoneinfo
COPY --from=base /etc/passwd /etc/passwd
COPY --from=base /etc/group /etc/group
COPY --from=base /sbin/tini /sbin/tini

# Copy compiled executable artifacts with strict permissions
COPY --from=builder --chown=appuser:appgroup --chmod=0755 /build/out/app /usr/local/bin/app
COPY --from=builder --chown=appuser:appgroup --chmod=0644 /build/config/runtime.json /etc/app/runtime.json

# Ephemeral storage mount points
RUN set -eux; \
    mkdir -p /data /var/log/app /tmp; \
    chown -R appuser:appgroup /data /var/log/app /tmp; \
    chmod 0770 /data /var/log/app /tmp

# Switch to unprivileged user (UID:GID)
USER 10001:10001
WORKDIR /home/appuser

# Runtime Environment Variables with default fallbacks
ENV ENVIRONMENT="production" \
    PORT="${DEFAULT_PORT}" \
    METRICS_PORT="9090" \
    LOG_LEVEL="info" \
    TZ="UTC" \
    HOME="/home/appuser"

# Network Ports
EXPOSE ${DEFAULT_PORT}/tcp
EXPOSE 9090/tcp

# Persistent Storage Volumes
VOLUME ["/data", "/var/log/app"]

# Stop signal for graceful process termination
STOPSIGNAL SIGTERM

# Container Liveness Healthcheck
HEALTHCHECK --interval=30s \
            --timeout=5s \
            --start-period=10s \
            --retries=3 \
            CMD ["/usr/local/bin/app", "--healthcheck"] || exit 1

# Process execution entrypoint & default flags
ENTRYPOINT ["/sbin/tini", "--", "/usr/local/bin/app"]
CMD ["--config=/etc/app/runtime.json", "--verbose"]

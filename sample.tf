# ==============================================================================
# SAMPLE: Terraform Configuration (sublime-font-checks)
# Purpose: Visual check for HCL syntax, block declarations, types, & ligatures
# ==============================================================================
// TODO: Check HCL keyword colors (terraform, provider, resource, variable, locals)
/* FIXME: Verify contrast for block labels, attribute keys, and strings
   Ligatures to observe: != == <= >= => -> := && || .. ...
*/
# NOTE: Check embedded string interpolation syntax highlight: "${...}" and "%{...}"
# ==============================================================================

terraform {
  required_version = ">= 1.7.0, < 2.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.40.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.26.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6.0"
    }
  }

  backend "s3" {
    bucket         = "production-terraform-state-01a"
    key            = "platform/core/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-state-lock-v1"
  }
}

# ------------------------------------------------------------------------------
# 1. PROVIDER CONFIGURATIONS
# ------------------------------------------------------------------------------
provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Environment = var.environment
      ManagedBy   = "Terraform"
      Project     = "FontPurity"
      Repository  = "github.com/org/sublime-font-checks"
      Owner       = "platform-team@company.internal"
    }
  }
}

provider "aws" {
  alias  = "west"
  region = "us-west-2"
}

# ------------------------------------------------------------------------------
# 2. INPUT VARIABLES & TYPE CONSTRAINTS
# ------------------------------------------------------------------------------
variable "aws_region" {
  type        = string
  description = "Primary AWS deployment region (e.g., us-east-1, eu-west-1)"
  default     = "us-east-1"

  validation {
    condition     = can(regex("^[a-z]{2}-[a-z]+-[0-9]{1}$", var.aws_region))
    error_message = "Variable 'aws_region' must be a valid AWS region identifier."
  }
}

variable "environment" {
  type        = string
  description = "Target runtime environment tier"
  default     = "production"

  validation {
    condition     = contains(["development", "staging", "production"], var.environment)
    error_message = "Allowed values are: development, staging, production."
  }
}

variable "cluster_config" {
  type = object({
    cluster_name      = string
    node_min_count    = number
    node_max_count    = number
    desired_capacity  = number
    instance_types    = list(string)
    enable_monitoring = bool
    retention_days    = optional(number, 30)
    extra_features    = map(bool)
  })
  description = "Structured configuration schema for EKS managed node groups"
  default = {
    cluster_name      = "primary-alpha-k8s"
    node_min_count    = 2
    node_max_count    = 10
    desired_capacity  = 4
    instance_types    = ["m6i.xlarge", "m6a.xlarge", "c6i.2xlarge"]
    enable_monitoring = true
    retention_days    = 90
    extra_features = {
      ebs_csi_driver = true
      core_dns_cache = true
      karpenter_v1   = false
    }
  }
}

variable "subnet_cidr_map" {
  type        = map(string)
  description = "Mapping of AZ suffix to CIDR allocation"
  default = {
    "a" = "10.100.1.0/24"
    "b" = "10.100.2.0/24"
    "c" = "10.100.3.0/24"
  }
}

variable "database_password" {
  type        = string
  description = "Database master credentials (sensitive token)"
  sensitive   = true
  default     = "Sup3r!S3cr3t#P@ssw0rd$2026&"
}

# ------------------------------------------------------------------------------
# 3. LOCAL VALUES, COMPREHENSIONS, & BUILT-IN FUNCTIONS
# ------------------------------------------------------------------------------
locals {
  is_production     = var.environment == "production"
  name_prefix       = "${var.environment}-${var.cluster_config.cluster_name}"
  vpc_base_cidr     = "10.100.0.0/16"
  base_port         = 8080
  allocated_subnets = length(var.subnet_cidr_map)

  # For expression over map with conditional filtering
  active_features = [
    for feat_name, enabled in var.cluster_config.extra_features :
    upper(feat_name) if enabled != false
  ]

  # Map comprehension with key/value transformation
  formatted_subnets = {
    for az, cidr in var.subnet_cidr_map :
    "${var.aws_region}${az}" => {
      cidr_block = cidr
      tier       = "private"
      mask       = element(split("/", cidr), 1)
    }
  }

  # Multi-line template string with indent-stripping heredoc
  user_data_template = <<-EOT
    #!/usr/bin/env bash
    set -euo pipefail
    echo "Configuring Node for cluster: ${local.name_prefix}"
    echo "Is Production: ${local.is_production ? "YES" : "NO"}"
    cat <<EOF > /etc/node-config.json
    ${jsonencode({
  cluster   = var.cluster_config.cluster_name
  timestamp = timestamp()
  features  = local.active_features
  version   = 42
})}
    EOF
  EOT
}

# ------------------------------------------------------------------------------
# 4. DATA SOURCES
# ------------------------------------------------------------------------------
data "aws_ami" "amazon_linux_2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

data "aws_caller_identity" "current" {}

# ------------------------------------------------------------------------------
# 5. MANAGED RESOURCES
# ------------------------------------------------------------------------------
resource "aws_vpc" "main" {
  cidr_block           = local.vpc_base_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "${local.name_prefix}-vpc"
    Type = "CoreNetworking"
  }

  lifecycle {
    prevent_destroy = false
  }
}

resource "aws_subnet" "managed" {
  for_each = local.formatted_subnets

  vpc_id            = aws_vpc.main.id
  cidr_block        = each.value.cidr_block
  availability_zone = each.key

  tags = {
    Name = "${local.name_prefix}-subnet-${each.key}"
    Tier = each.value.tier
  }
}

resource "aws_security_group" "service_mesh" {
  name_prefix = "${local.name_prefix}-mesh-"
  description = "Traffic rules for service mesh ingress/egress"
  vpc_id      = aws_vpc.main.id

  # Dynamic block iteration
  dynamic "ingress" {
    for_each = [80, 443, 8443, 9090]
    content {
      description = "Allow inbound port ${ingress.value}"
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = [aws_vpc.main.cidr_block]
    }
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  lifecycle {
    create_before_destroy = true
  }
}

# Conditional resource creation using count
resource "aws_sns_topic" "alerts" {
  count = local.is_production ? 1 : 0
  name  = "${local.name_prefix}-critical-alerts"

  tags = {
    Severity = "Critical"
    RouteTo  = "PagerDuty"
  }
}

# ------------------------------------------------------------------------------
# 6. OUTPUT VALUES & SPLAT OPERATORS
# ------------------------------------------------------------------------------
output "vpc_identifier" {
  description = "Unique AWS resource ID of the created VPC"
  value       = aws_vpc.main.id
}

output "subnet_ids" {
  description = "List of generated subnet IDs via splat/values expression"
  value       = [for s in aws_subnet.managed : s.id]
}

output "security_group_arn" {
  description = "Amazon Resource Name of the mesh security group"
  value       = aws_security_group.service_mesh.arn
}

output "database_connection_string" {
  description = "Sensitive database connection string with credentials"
  value       = "postgres://admin:${var.database_password}@${aws_vpc.main.id}.internal:5432/platform"
  sensitive   = true
}

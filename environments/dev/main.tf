# main.tf in environments/dev

# Configure AWS Provider
provider "aws" {
  region = var.aws_region
}

# Configure GCP Provider
provider "google" {
  project = var.gcp_project_id
  region  = var.gcp_region
}

# -----------------------------------------------------------------------------
# Monitoring Stack Modules
# These modules will encapsulate the deployment of Prometheus, Grafana, Loki,
# and various exporters. They should be designed to be cloud-agnostic where
# possible, or to abstract cloud-specific implementations.
# -----------------------------------------------------------------------------

# Prometheus Module
# This module will deploy and configure Prometheus.
# It should support deployment on both VM (EC2/GCE) and Kubernetes.
module "prometheus" {
  source = "../../modules/prometheus"

  # Common configuration
  environment = var.environment
  tags        = var.common_tags

  # Cloud-specific configurations (example - adjust as per actual module design)
  aws_enabled = var.aws_enabled
  gcp_enabled = var.gcp_enabled

  # Example: VM deployment
  instance_type = var.prometheus_instance_type
  disk_size     = var.prometheus_disk_size

  # Example: Kubernetes deployment
  kubernetes_namespace = var.kubernetes_namespace
  kubernetes_context   = var.kubernetes_context

  # Integrations
  remote_write_url = var.prometheus_remote_write_url
}

# Grafana Module
# This module will deploy and configure Grafana, including dashboard imports.
module "grafana" {
  source = "../../modules/grafana"

  environment = var.environment
  tags        = var.common_tags

  aws_enabled = var.aws_enabled
  gcp_enabled = var.gcp_enabled

  instance_type = var.grafana_instance_type
  disk_size     = var.grafana_disk_size

  kubernetes_namespace = var.kubernetes_namespace
  kubernetes_context   = var.kubernetes_context

  admin_user     = var.grafana_admin_user
  admin_password = var.grafana_admin_password
  oauth_config   = var.grafana_oauth_config # Example: map for OAuth configuration

  # Dashboards and data sources
  dashboards_config = var.grafana_dashboards_config # Example: list of dashboard definitions
}

# Loki Module
# This module will deploy and configure Loki for log aggregation.
module "loki" {
  source = "../../modules/loki"

  environment = var.environment
  tags        = var.common_tags

  aws_enabled = var.aws_enabled
  gcp_enabled = var.gcp_enabled

  instance_type = var.loki_instance_type
  disk_size     = var.loki_disk_size

  kubernetes_namespace = var.kubernetes_namespace
  kubernetes_context   = var.kubernetes_context
}

# Exporters Module
# This module will deploy various exporters (Node, Blackbox, Cloud-specific).
module "exporters" {
  source = "../../modules/exporters"

  environment = var.environment
  tags        = var.common_tags

  aws_enabled = var.aws_enabled
  gcp_enabled = var.gcp_enabled

  # Node Exporter configuration
  node_exporter_enabled = var.node_exporter_enabled
  node_exporter_targets = var.node_exporter_targets # Example: list of IPs/hostnames

  # Blackbox Exporter configuration
  blackbox_exporter_enabled = var.blackbox_exporter_enabled
  blackbox_exporter_targets = var.blackbox_exporter_targets # Example: list of URLs

  # Cloud-specific exporters (e.g., AWS CloudWatch Exporter, GCP Stackdriver Exporter)
  aws_cloudwatch_exporter_enabled = var.aws_cloudwatch_exporter_enabled
  gcp_stackdriver_exporter_enabled = var.gcp_stackdriver_exporter_enabled
}

# -----------------------------------------------------------------------------
# Infra-Core Integration (Example)
# Assuming infra-core provides modules for basic infrastructure components
# like VPCs, subnets, security groups, or even base VM images.
# -----------------------------------------------------------------------------

# Example: Using an infra-core module for network setup
# module "infra_network" {
#   source = "git::https://github.com/v-grand/infra-core.git//modules/network?ref=main"
#   # ... network configuration variables ...
#   aws_region = var.aws_region
#   gcp_project_id = var.gcp_project_id
# }

# Example: Using infra-core for base VM instances
# module "base_vm_aws" {
#   source = "git::https://github.com/v-grand/infra-core.git//modules/aws-vm?ref=main"
#   count = var.aws_enabled ? 1 : 0
#   # ... VM configuration ...
# }

# module "base_vm_gcp" {
#   source = "git::https://github.com/v-grand/infra-core.git//modules/gcp-vm?ref=main"
#   count = var.gcp_enabled ? 1 : 0
#   # ... VM configuration ...
# }

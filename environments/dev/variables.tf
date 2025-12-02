# variables.tf in environments/dev

variable "environment" {
  description = "The deployment environment (e.g., dev, prod)"
  type        = string
  default     = "dev"
}

variable "common_tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
  default = {
    Project     = "InfraMonitoring"
    Environment = "dev"
  }
}

# AWS Configuration
variable "aws_enabled" {
  description = "Enable/disable AWS deployments"
  type        = bool
  default     = false
}

variable "aws_region" {
  description = "AWS region for deployments"
  type        = string
  default     = "us-east-1"
}

# GCP Configuration
variable "gcp_enabled" {
  description = "Enable/disable GCP deployments"
  type        = bool
  default     = false
}

variable "gcp_project_id" {
  description = "GCP Project ID for deployments"
  type        = string
  default     = "your-gcp-project-id" # REPLACE WITH YOUR GCP PROJECT ID
}

variable "gcp_region" {
  description = "GCP region for deployments"
  type        = string
  default     = "us-central1"
}

# Kubernetes Configuration
variable "kubernetes_namespace" {
  description = "Kubernetes namespace for deployments"
  type        = string
  default     = "monitoring"
}

variable "kubernetes_context" {
  description = "Kubernetes context to use for deployments (if deploying to existing cluster)"
  type        = string
  default     = null # Set to your Kubernetes context name if needed
}

# Prometheus Variables
variable "prometheus_instance_type" {
  description = "Instance type for Prometheus VM (e.g., t3.medium for AWS, e2-medium for GCP)"
  type        = string
  default     = "t3.medium"
}

variable "prometheus_disk_size" {
  description = "Disk size in GB for Prometheus VM"
  type        = number
  default     = 50
}

variable "prometheus_remote_write_url" {
  description = "URL for Prometheus remote write (e.g., Grafana Cloud)"
  type        = string
  default     = null
}

# Grafana Variables
variable "grafana_instance_type" {
  description = "Instance type for Grafana VM"
  type        = string
  default     = "t3.medium"
}

variable "grafana_disk_size" {
  description = "Disk size in GB for Grafana VM"
  type        = number
  default     = 20
}

variable "grafana_admin_user" {
  description = "Grafana admin username"
  type        = string
  default     = "admin"
}

variable "grafana_admin_password" {
  description = "Grafana admin password (sensitive, use secrets management)"
  type        = string
  sensitive   = true
}

variable "grafana_oauth_config" {
  description = "Map of OAuth configuration for Grafana (e.g., GitHub, Google)"
  type        = map(string)
  default     = {}
}

variable "grafana_dashboards_config" {
  description = "List of dashboard definitions (e.g., file paths, URLs, JSON content)"
  type        = list(string)
  default     = []
}

# Loki Variables
variable "loki_instance_type" {
  description = "Instance type for Loki VM"
  type        = string
  default     = "t3.medium"
}

variable "loki_disk_size" {
  description = "Disk size in GB for Loki VM"
  type        = number
  default     = 100
}

# Exporters Variables
variable "node_exporter_enabled" {
  description = "Enable/disable Node Exporter deployment"
  type        = bool
  default     = true
}

variable "node_exporter_targets" {
  description = "List of target IPs/hostnames for Node Exporter"
  type        = list(string)
  default     = []
}

variable "blackbox_exporter_enabled" {
  description = "Enable/disable Blackbox Exporter deployment"
  type        = bool
  default     = false
}

variable "blackbox_exporter_targets" {
  description = "List of target URLs for Blackbox Exporter"
  type        = list(string)
  default     = []
}

variable "aws_cloudwatch_exporter_enabled" {
  description = "Enable/disable AWS CloudWatch Exporter deployment"
  type        = bool
  default     = false
}

variable "gcp_stackdriver_exporter_enabled" {
  description = "Enable/disable GCP Stackdriver Exporter deployment"
  type        = bool
  default     = false
}

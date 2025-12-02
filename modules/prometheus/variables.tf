# variables.tf for Prometheus module

variable "environment" {
  description = "The deployment environment (e.g., dev, prod)"
  type        = string
}

variable "tags" {
  description = "A map of tags to apply to resources"
  type        = map(string)
  default     = {}
}

# Deployment Target Configuration
variable "aws_enabled" {
  description = "Set to true to enable AWS EC2 deployment for Prometheus"
  type        = bool
  default     = false
}

variable "gcp_enabled" {
  description = "Set to true to enable GCP GCE deployment for Prometheus"
  type        = bool
  default     = false
}

variable "kubernetes_enabled" {
  description = "Set to true to enable Kubernetes deployment for Prometheus"
  type        = bool
  default     = false
}

# Common VM Variables
variable "instance_type" {
  description = "Instance type for the Prometheus VM"
  type        = string
}

variable "disk_size" {
  description = "Disk size in GB for the Prometheus VM"
  type        = number
}

# AWS Specific Variables
variable "aws_region" {
  description = "AWS region for EC2 deployment"
  type        = string
  default     = "us-east-1"
}

variable "aws_ami_id" {
  description = "AMI ID for the Prometheus EC2 instance"
  type        = string
  default     = "ami-0abcdef1234567890" # REPLACE with a valid AMI ID
}

variable "aws_key_name" {
  description = "Key pair name for SSH access to EC2 instance"
  type        = string
  default     = ""
}

variable "aws_subnet_id" {
  description = "Subnet ID for the EC2 instance"
  type        = string
  default     = ""
}

variable "aws_security_group_id" {
  description = "Security Group ID for the EC2 instance"
  type        = string
  default     = ""
}

# GCP Specific Variables
variable "gcp_project_id" {
  description = "GCP Project ID for GCE deployment"
  type        = string
  default     = ""
}

variable "gcp_zone" {
  description = "GCP Zone for GCE deployment"
  type        = string
  default     = "us-central1-a"
}

variable "gcp_image" {
  description = "GCP Image for the Prometheus GCE instance"
  type        = string
  default     = "debian-cloud/debian-11"
}

variable "gcp_network" {
  description = "GCP Network for the GCE instance"
  type        = string
  default     = "default"
}

# Kubernetes Specific Variables
variable "kubernetes_namespace" {
  description = "Kubernetes namespace for Prometheus deployment"
  type        = list(string)
  default     = ["monitoring"]
}

variable "prometheus_helm_chart_version" {
  description = "Version of the Prometheus Helm chart to deploy"
  type        = string
  default     = "15.15.0" # Example version, check latest stable
}

# Prometheus Configuration Variables
variable "remote_write_url" {
  description = "URL for Prometheus remote write (e.g., Grafana Cloud)"
  type        = string
  default     = null
}

variable "prometheus_targets" {
  description = "List of Prometheus scrape targets (e.g., 'host:port')"
  type        = list(string)
  default     = []
}

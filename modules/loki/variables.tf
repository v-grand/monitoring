# variables.tf for Loki module

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
  description = "Set to true to enable AWS EC2 deployment for Loki"
  type        = bool
  default     = false
}

variable "gcp_enabled" {
  description = "Set to true to enable GCP GCE deployment for Loki"
  type        = bool
  default     = false
}

variable "kubernetes_enabled" {
  description = "Set to true to enable Kubernetes deployment for Loki"
  type        = bool
  default     = false
}

# Common VM Variables
variable "instance_type" {
  description = "Instance type for the Loki VM"
  type        = string
}

variable "disk_size" {
  description = "Disk size in GB for the Loki VM"
  type        = number
}

# AWS Specific Variables
variable "aws_region" {
  description = "AWS region for EC2 deployment"
  type        = string
  default     = "us-east-1"
}

variable "aws_ami_id" {
  description = "AMI ID for the Loki EC2 instance"
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
  description = "GCP Image for the Loki GCE instance"
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
  description = "Kubernetes namespace for Loki deployment"
  type        = list(string)
  default     = ["monitoring"]
}

variable "loki_helm_chart_version" {
  description = "Version of the Loki Helm chart to deploy"
  type        = string
  default     = "5.33.0" # Example version, check latest stable
}

variable "promtail_helm_chart_version" {
  description = "Version of the Promtail Helm chart to deploy"
  type        = string
  default     = "6.10.0" # Example version, check latest stable
}

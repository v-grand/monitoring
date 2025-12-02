# variables.tf for Exporters module

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
  description = "Set to true to enable AWS EC2 deployment for exporters"
  type        = bool
  default     = false
}

variable "gcp_enabled" {
  description = "Set to true to enable GCP GCE deployment for exporters"
  type        = bool
  default     = false
}

variable "kubernetes_enabled" {
  description = "Set to true to enable Kubernetes deployment for exporters"
  type        = bool
  default     = false
}

# Common VM Variables (for exporters deployed on dedicated VMs)
variable "instance_type" {
  description = "Instance type for exporter VMs"
  type        = string
  default     = "t3.micro"
}

variable "disk_size" {
  description = "Disk size in GB for exporter VMs"
  type        = number
  default     = 10
}

# AWS Specific Variables
variable "aws_region" {
  description = "AWS region for EC2 deployment"
  type        = string
  default     = "us-east-1"
}

variable "aws_ami_id" {
  description = "AMI ID for the EC2 instances"
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
  description = "GCP Image for the GCE instances"
  type        = string
  default     = "debian-cloud/debian-11"
}

variable "gcp_network" {
  description = "GCP Network for the GCE instances"
  type        = string
  default     = "default"
}

# Kubernetes Specific Variables
variable "kubernetes_namespace" {
  description = "Kubernetes namespace for exporters deployment"
  type        = list(string)
  default     = ["monitoring"]
}

# Node Exporter Variables
variable "node_exporter_enabled" {
  description = "Enable/disable Node Exporter deployment"
  type        = bool
  default     = true
}

variable "node_exporter_targets" {
  description = "List of target IPs/hostnames for Node Exporter (for VM deployment)"
  type        = list(string)
  default     = []
}

variable "node_exporter_helm_chart_version" {
  description = "Version of the Prometheus Node Exporter Helm chart to deploy"
  type        = string
  default     = "4.24.0" # Example version, check latest stable
}

# Blackbox Exporter Variables
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

variable "blackbox_exporter_helm_chart_version" {
  description = "Version of the Prometheus Blackbox Exporter Helm chart to deploy"
  type        = string
  default     = "6.0.0" # Example version, check latest stable
}

# Cloud-Specific Exporters Variables
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

# main.tf for Exporters module

# This module will deploy various exporters on either VMs or Kubernetes.

# -----------------------------------------------------------------------------
# Node Exporter Deployment
# -----------------------------------------------------------------------------

# AWS EC2 Deployment for Node Exporter
resource "aws_instance" "node_exporter_vm_aws" {
  count = var.aws_enabled && var.node_exporter_enabled && !var.kubernetes_enabled ? length(var.node_exporter_targets) : 0

  ami           = var.aws_ami_id
  instance_type = var.instance_type
  key_name      = var.aws_key_name
  subnet_id     = var.aws_subnet_id
  vpc_security_group_ids = [var.aws_security_group_id]

  root_block_device {
    volume_size = var.disk_size
    volume_type = "gp2"
  }

  tags = merge(var.tags, {
    Name        = "${var.environment}-node-exporter-${count.index}"
    Service     = "NodeExporter"
    Environment = var.environment
  })

  # User data to install and configure Node Exporter
  user_data = <<-EOF
              #!/bin/bash
              echo "Installing Node Exporter on AWS EC2..."
              # Add installation and configuration steps here
              EOF
}

# GCP GCE Deployment for Node Exporter
resource "google_compute_instance" "node_exporter_vm_gcp" {
  count = var.gcp_enabled && var.node_exporter_enabled && !var.kubernetes_enabled ? length(var.node_exporter_targets) : 0

  project      = var.gcp_project_id
  zone         = var.gcp_zone
  machine_type = var.instance_type
  boot_disk {
    initialize_params {
      image = var.gcp_image
      size  = var.disk_size
    }
  }
  network_interface {
    network = var.gcp_network
    access_config {
      # Ephemeral IP
    }
  }

  metadata_startup_script = <<-EOF
                              #!/bin/bash
                              echo "Installing Node Exporter on GCP GCE..."
                              # Add installation and configuration steps here
                              EOF

  labels = merge(var.tags, {
    name        = "${var.environment}-node-exporter-${count.index}"
    service     = "node-exporter"
    environment = var.environment
  })
}

# Kubernetes Deployment for Node Exporter (using Helm)
resource "helm_release" "node_exporter_k8s" {
  count = var.kubernetes_enabled && var.node_exporter_enabled ? 1 : 0

  name       = "node-exporter"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "prometheus-node-exporter"
  namespace  = var.kubernetes_namespace[0]
  version    = var.node_exporter_helm_chart_version

  values = [
    templatefile("${path.module}/values/node-exporter-values.yaml", {
      # Add Node Exporter specific configurations here
    })
  ]

  # provider = kubernetes.k8s_context_provider
}

# -----------------------------------------------------------------------------
# Blackbox Exporter Deployment
# -----------------------------------------------------------------------------

# AWS EC2 Deployment for Blackbox Exporter
resource "aws_instance" "blackbox_exporter_vm_aws" {
  count = var.aws_enabled && var.blackbox_exporter_enabled && !var.kubernetes_enabled ? 1 : 0

  ami           = var.aws_ami_id
  instance_type = var.instance_type
  key_name      = var.aws_key_name
  subnet_id     = var.aws_subnet_id
  vpc_security_group_ids = [var.aws_security_group_id]

  root_block_device {
    volume_size = var.disk_size
    volume_type = "gp2"
  }

  tags = merge(var.tags, {
    Name        = "${var.environment}-blackbox-exporter-vm"
    Service     = "BlackboxExporter"
    Environment = var.environment
  })

  user_data = <<-EOF
              #!/bin/bash
              echo "Installing Blackbox Exporter on AWS EC2..."
              # Add installation and configuration steps here
              EOF
}

# GCP GCE Deployment for Blackbox Exporter
resource "google_compute_instance" "blackbox_exporter_vm_gcp" {
  count = var.gcp_enabled && var.blackbox_exporter_enabled && !var.kubernetes_enabled ? 1 : 0

  project      = var.gcp_project_id
  zone         = var.gcp_zone
  machine_type = var.instance_type
  boot_disk {
    initialize_params {
      image = var.gcp_image
      size  = var.disk_size
    }
  }
  network_interface {
    network = var.gcp_network
    access_config {
      # Ephemeral IP
    }
  }

  metadata_startup_script = <<-EOF
                              #!/bin/bash
                              echo "Installing Blackbox Exporter on GCP GCE..."
                              # Add installation and configuration steps here
                              EOF

  labels = merge(var.tags, {
    name        = "${var.environment}-blackbox-exporter-vm"
    service     = "blackbox-exporter"
    environment = var.environment
  })
}

# Kubernetes Deployment for Blackbox Exporter (using Helm)
resource "helm_release" "blackbox_exporter_k8s" {
  count = var.kubernetes_enabled && var.blackbox_exporter_enabled ? 1 : 0

  name       = "blackbox-exporter"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "prometheus-blackbox-exporter"
  namespace  = var.kubernetes_namespace[0]
  version    = var.blackbox_exporter_helm_chart_version

  values = [
    templatefile("${path.module}/values/blackbox-exporter-values.yaml", {
      # Add Blackbox Exporter specific configurations here
      targets = var.blackbox_exporter_targets
    })
  ]

  # provider = kubernetes.k8s_context_provider
}

# -----------------------------------------------------------------------------
# Cloud-Specific Exporters
# -----------------------------------------------------------------------------

# AWS CloudWatch Exporter
resource "aws_instance" "cloudwatch_exporter_aws" {
  count = var.aws_enabled && var.aws_cloudwatch_exporter_enabled && !var.kubernetes_enabled ? 1 : 0

  ami           = var.aws_ami_id
  instance_type = var.instance_type
  key_name      = var.aws_key_name
  subnet_id     = var.aws_subnet_id
  vpc_security_group_ids = [var.aws_security_group_id]

  root_block_device {
    volume_size = var.disk_size
    volume_type = "gp2"
  }

  tags = merge(var.tags, {
    Name        = "${var.environment}-cloudwatch-exporter-vm"
    Service     = "CloudWatchExporter"
    Environment = var.environment
  })

  user_data = <<-EOF
              #!/bin/bash
              echo "Installing AWS CloudWatch Exporter on AWS EC2..."
              # Add installation and configuration steps here
              EOF
}

# GCP Stackdriver Exporter
resource "google_compute_instance" "stackdriver_exporter_gcp" {
  count = var.gcp_enabled && var.gcp_stackdriver_exporter_enabled && !var.kubernetes_enabled ? 1 : 0

  project      = var.gcp_project_id
  zone         = var.gcp_zone
  machine_type = var.instance_type
  boot_disk {
    initialize_params {
      image = var.gcp_image
      size  = var.disk_size
    }
  }
  network_interface {
    network = var.gcp_network
    access_config {
      # Ephemeral IP
    }
  }

  metadata_startup_script = <<-EOF
                              #!/bin/bash
                              echo "Installing GCP Stackdriver Exporter on GCP GCE..."
                              # Add installation and configuration steps here
                              EOF

  labels = merge(var.tags, {
    name        = "${var.environment}-stackdriver-exporter-vm"
    service     = "stackdriver-exporter"
    environment = var.environment
  })
}

# Kubernetes Deployment for CloudWatch Exporter (if available via Helm)
# resource "helm_release" "cloudwatch_exporter_k8s" {
#   count = var.kubernetes_enabled && var.aws_cloudwatch_exporter_enabled ? 1 : 0
#   name       = "cloudwatch-exporter"
#   repository = "https://prometheus-community.github.io/helm-charts" # Example, check actual repo
#   chart      = "cloudwatch-exporter"
#   namespace  = var.kubernetes_namespace[0]
#   version    = "..."
#   values = [...]
# }

# Kubernetes Deployment for Stackdriver Exporter (if available via Helm)
# resource "helm_release" "stackdriver_exporter_k8s" {
#   count = var.kubernetes_enabled && var.gcp_stackdriver_exporter_enabled ? 1 : 0
#   name       = "stackdriver-exporter"
#   repository = "https://prometheus-community.github.io/helm-charts" # Example, check actual repo
#   chart      = "stackdriver-exporter"
#   namespace  = var.kubernetes_namespace[0]
#   version    = "..."
#   values = [...]
# }

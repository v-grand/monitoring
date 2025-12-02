# main.tf for Prometheus module

# This module will deploy Prometheus on either a VM (AWS EC2/GCP GCE) or Kubernetes.
# The choice of deployment target is determined by the input variables.

# -----------------------------------------------------------------------------
# AWS EC2 Deployment for Prometheus
# -----------------------------------------------------------------------------
resource "aws_instance" "prometheus_vm_aws" {
  count = var.aws_enabled && !var.kubernetes_enabled ? 1 : 0

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
    Name        = "${var.environment}-prometheus-vm"
    Service     = "Prometheus"
    Environment = var.environment
  })

  # User data to install and configure Prometheus (example - needs detailed script)
  user_data = <<-EOF
              #!/bin/bash
              echo "Installing Prometheus on AWS EC2..."
              # Add installation and configuration steps here
              # e.g., install Docker, run Prometheus in a container, configure targets
              EOF
}

# -----------------------------------------------------------------------------
# GCP GCE Deployment for Prometheus
# -----------------------------------------------------------------------------
resource "google_compute_instance" "prometheus_vm_gcp" {
  count = var.gcp_enabled && !var.kubernetes_enabled ? 1 : 0

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
                              echo "Installing Prometheus on GCP GCE..."
                              # Add installation and configuration steps here
                              EOF

  labels = merge(var.tags, {
    name        = "${var.environment}-prometheus-vm"
    service     = "prometheus"
    environment = var.environment
  })
}

# -----------------------------------------------------------------------------
# Kubernetes Deployment for Prometheus (using Helm)
# -----------------------------------------------------------------------------
resource "helm_release" "prometheus_k8s" {
  count = var.kubernetes_enabled ? 1 : 0

  name       = "prometheus"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "prometheus"
  namespace  = var.kubernetes_namespace[0]
  version    = var.prometheus_helm_chart_version

  values = [
    templatefile("${path.module}/values/prometheus-values.yaml", {
      remote_write_url = var.remote_write_url
      # Add other Prometheus specific configurations here
      # e.g., target configurations, resource limits, persistence
    })
  ]

  # Ensure Kubernetes provider is configured if using a specific context
  # provider = kubernetes.k8s_context_provider # This would be defined in root module
}

# -----------------------------------------------------------------------------
# Prometheus Configuration (e.g., targets, remote_write)
# This part would typically involve generating a prometheus.yml and
# deploying it to the Prometheus instance, either directly or via a ConfigMap
# in Kubernetes.
# -----------------------------------------------------------------------------

# Example: Placeholder for Prometheus configuration management
# This would depend on the deployment method (VM vs K8s)
# For VMs, you might use a configuration management tool (Ansible, cloud-init)
# For K8s, a ConfigMap is common.

# resource "null_resource" "configure_prometheus_vm" {
#   count = (var.aws_enabled || var.gcp_enabled) && !var.kubernetes_enabled ? 1 : 0
#   triggers = {
#     instance_id = var.aws_enabled ? aws_instance.prometheus_vm_aws[0].id : google_compute_instance.prometheus_vm_gcp[0].id
#   }
#   provisioner "remote-exec" {
#     inline = [
#       "echo 'Configuring Prometheus on VM...'",
#       # Commands to copy prometheus.yml, restart service, etc.
#     ]
#   }
# }

# resource "kubernetes_config_map" "prometheus_config" {
#   count = var.kubernetes_enabled ? 1 : 0
#   metadata {
#     name      = "prometheus-config"
#     namespace = var.kubernetes_namespace[0]
#   }
#   data = {
#     "prometheus.yml" = templatefile("${path.module}/templates/prometheus.yml.tpl", {
#       targets = var.prometheus_targets # Example: list of targets
#       remote_write_url = var.remote_write_url
#     })
#   }
# }

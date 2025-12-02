# main.tf for Loki module

# This module will deploy Loki on either a VM (AWS EC2/GCP GCE) or Kubernetes.

# -----------------------------------------------------------------------------
# AWS EC2 Deployment for Loki
# -----------------------------------------------------------------------------
resource "aws_instance" "loki_vm_aws" {
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
    Name        = "${var.environment}-loki-vm"
    Service     = "Loki"
    Environment = var.environment
  })

  # User data to install and configure Loki (example - needs detailed script)
  user_data = <<-EOF
              #!/bin/bash
              echo "Installing Loki on AWS EC2..."
              # Add installation and configuration steps here
              # e.g., install Docker, run Loki in a container, configure storage
              EOF
}

# -----------------------------------------------------------------------------
# GCP GCE Deployment for Loki
# -----------------------------------------------------------------------------
resource "google_compute_instance" "loki_vm_gcp" {
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
                              echo "Installing Loki on GCP GCE..."
                              # Add installation and configuration steps here
                              EOF

  labels = merge(var.tags, {
    name        = "${var.environment}-loki-vm"
    service     = "loki"
    environment = var.environment
  })
}

# -----------------------------------------------------------------------------
# Kubernetes Deployment for Loki (using Helm)
# -----------------------------------------------------------------------------
resource "helm_release" "loki_k8s" {
  count = var.kubernetes_enabled ? 1 : 0

  name       = "loki"
  repository = "https://grafana.github.io/helm-charts"
  chart      = "loki"
  namespace  = var.kubernetes_namespace[0]
  version    = var.loki_helm_chart_version

  values = [
    templatefile("${path.module}/values/loki-values.yaml", {
      # Add Loki specific configurations here
      # e.g., storage, resource limits, persistence
    })
  ]

  # provider = kubernetes.k8s_context_provider # This would be defined in root module
}

# -----------------------------------------------------------------------------
# Promtail Deployment (for log collection)
# Promtail is typically deployed as a DaemonSet in Kubernetes or as an agent
# on VMs to collect logs and send them to Loki.
# -----------------------------------------------------------------------------

# Kubernetes Deployment for Promtail (using Helm)
resource "helm_release" "promtail_k8s" {
  count = var.kubernetes_enabled ? 1 : 0

  name       = "promtail"
  repository = "https://grafana.github.io/helm-charts"
  chart      = "promtail"
  namespace  = var.kubernetes_namespace[0]
  version    = var.promtail_helm_chart_version

  values = [
    templatefile("${path.module}/values/promtail-values.yaml", {
      loki_url = "http://loki.${var.kubernetes_namespace[0]}.svc.cluster.local:3100/api/prom/push"
      # Add Promtail specific configurations here
    })
  ]

  # provider = kubernetes.k8s_context_provider # This would be defined in root module
}

# Example: Placeholder for Promtail deployment on VMs
# This would typically involve cloud-init scripts or a configuration management tool
# to install and configure Promtail on each VM that needs log collection.
# resource "null_resource" "configure_promtail_vm" {
#   count = (var.aws_enabled || var.gcp_enabled) && !var.kubernetes_enabled ? 1 : 0
#   triggers = {
#     instance_id = var.aws_enabled ? aws_instance.loki_vm_aws[0].id : google_compute_instance.loki_vm_gcp[0].id # Or other target VMs
#   }
#   provisioner "remote-exec" {
#     inline = [
#       "echo 'Configuring Promtail on VM...'",
#       # Commands to install Promtail, configure it to send logs to Loki
#     ]
#   }
# }

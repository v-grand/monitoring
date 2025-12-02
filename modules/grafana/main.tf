# main.tf for Grafana module

# This module will deploy Grafana on either a VM (AWS EC2/GCP GCE) or Kubernetes.

# -----------------------------------------------------------------------------
# AWS EC2 Deployment for Grafana
# -----------------------------------------------------------------------------
resource "aws_instance" "grafana_vm_aws" {
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
    Name        = "${var.environment}-grafana-vm"
    Service     = "Grafana"
    Environment = var.environment
  })

  # User data to install and configure Grafana (example - needs detailed script)
  user_data = <<-EOF
              #!/bin/bash
              echo "Installing Grafana on AWS EC2..."
              # Add installation and configuration steps here
              # e.g., install Docker, run Grafana in a container, configure data sources, import dashboards
              EOF
}

# -----------------------------------------------------------------------------
# GCP GCE Deployment for Grafana
# -----------------------------------------------------------------------------
resource "google_compute_instance" "grafana_vm_gcp" {
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
                              echo "Installing Grafana on GCP GCE..."
                              # Add installation and configuration steps here
                              EOF

  labels = merge(var.tags, {
    name        = "${var.environment}-grafana-vm"
    service     = "grafana"
    environment = var.environment
  })
}

# -----------------------------------------------------------------------------
# Kubernetes Deployment for Grafana (using Helm)
# -----------------------------------------------------------------------------
resource "helm_release" "grafana_k8s" {
  count = var.kubernetes_enabled ? 1 : 0

  name       = "grafana"
  repository = "https://grafana.github.io/helm-charts"
  chart      = "grafana"
  namespace  = var.kubernetes_namespace[0]
  version    = var.grafana_helm_chart_version

  values = [
    templatefile("${path.module}/values/grafana-values.yaml", {
      admin_user     = var.admin_user
      admin_password = var.admin_password
      oauth_config   = var.oauth_config
      # Add other Grafana specific configurations here
      # e.g., data sources, dashboards, resource limits, persistence
    })
  ]

  # provider = kubernetes.k8s_context_provider # This would be defined in root module
}

# -----------------------------------------------------------------------------
# Grafana Configuration (e.g., data sources, dashboards, authentication)
# This part would typically involve configuring Grafana after deployment.
# For VMs, this might be done via API calls or configuration files.
# For K8s, ConfigMaps and Secrets are common.
# -----------------------------------------------------------------------------

# Example: Placeholder for Grafana data source and dashboard management
# This would depend on the deployment method (VM vs K8s)

# resource "null_resource" "configure_grafana_vm" {
#   count = (var.aws_enabled || var.gcp_enabled) && !var.kubernetes_enabled ? 1 : 0
#   triggers = {
#     instance_id = var.aws_enabled ? aws_instance.grafana_vm_aws[0].id : google_compute_instance.grafana_vm_gcp[0].id
#   }
#   provisioner "remote-exec" {
#     inline = [
#       "echo 'Configuring Grafana on VM...'",
#       # Commands to configure data sources, import dashboards, etc.
#     ]
#   }
# }

# resource "kubernetes_config_map" "grafana_datasources" {
#   count = var.kubernetes_enabled ? 1 : 0
#   metadata {
#     name      = "grafana-datasources"
#     namespace = var.kubernetes_namespace[0]
#   }
#   data = {
#     "prometheus.yaml" = <<-EOT
#       apiVersion: 1
#       datasources:
#         - name: Prometheus
#           type: prometheus
#           url: http://prometheus-k8s-service.${var.kubernetes_namespace[0]}.svc.cluster.local:9090
#           access: proxy
#           isDefault: true
#     EOT
#   }
# }

# resource "kubernetes_config_map" "grafana_dashboards" {
#   count = var.kubernetes_enabled ? 1 : 0
#   metadata {
#     name      = "grafana-dashboards"
#     namespace = var.kubernetes_namespace[0]
#   }
#   data = {
#     "dashboard-example.json" = file("${path.module}/dashboards/example.json") # Example dashboard file
#   }
# }

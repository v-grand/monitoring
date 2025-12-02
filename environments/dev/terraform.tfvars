# terraform.tfvars in environments/dev

# AWS Configuration
aws_enabled = true
aws_region  = "us-east-1"

# GCP Configuration
gcp_enabled    = false
gcp_project_id = "your-gcp-project-id" # REMEMBER TO CHANGE THIS FOR GCP DEPLOYMENTS
gcp_region     = "us-central1"

# Prometheus
prometheus_instance_type = "t3.medium"
prometheus_disk_size     = 50
# prometheus_remote_write_url = "https://prometheus-prod-01-prod-us-east-0.grafana.net/api/prom/push"

# Grafana
grafana_instance_type = "t3.medium"
grafana_disk_size     = 20
grafana_admin_user    = "admin"
grafana_admin_password = "your-secure-grafana-password" # CHANGE THIS!

# Loki
loki_instance_type = "t3.medium"
loki_disk_size     = 100

# Exporters
node_exporter_enabled = true
node_exporter_targets = ["192.168.1.100", "192.168.1.101"] # Example IPs
blackbox_exporter_enabled = false
# blackbox_exporter_targets = ["https://example.com", "https://google.com"]

aws_cloudwatch_exporter_enabled = false
gcp_stackdriver_exporter_enabled = false

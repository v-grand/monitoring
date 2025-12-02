# terraform.tfvars in environments/prod

# AWS Configuration
aws_enabled = true
aws_region  = "us-east-1"

# GCP Configuration
gcp_enabled    = false
gcp_project_id = "your-gcp-prod-project-id" # REMEMBER TO CHANGE THIS FOR GCP DEPLOYMENTS
gcp_region     = "us-central1"

# Prometheus
prometheus_instance_type = "t3.large"
prometheus_disk_size     = 200
# prometheus_remote_write_url = "https://prometheus-prod-01-prod-us-east-0.grafana.net/api/prom/push"

# Grafana
grafana_instance_type = "t3.medium"
grafana_disk_size     = 50
grafana_admin_user    = "admin"
grafana_admin_password = "your-secure-grafana-prod-password" # CHANGE THIS!

# Loki
loki_instance_type = "t3.xlarge"
loki_disk_size     = 500

# Exporters
node_exporter_enabled = true
node_exporter_targets = ["10.0.1.10", "10.0.1.11", "10.0.2.10"] # Example Production IPs
blackbox_exporter_enabled = true
blackbox_exporter_targets = ["https://your-prod-app.com", "https://your-prod-api.com"]

aws_cloudwatch_exporter_enabled = true
gcp_stackdriver_exporter_enabled = false

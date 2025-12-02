# outputs.tf for Exporters module

output "node_exporter_endpoints" {
  description = "List of endpoints for deployed Node Exporters."
  value = concat(
    aws_instance.node_exporter_vm_aws.*.public_ip,
    google_compute_instance.node_exporter_vm_gcp.*.network_interface[0].access_config[0].nat_ip,
    (var.kubernetes_enabled && var.node_exporter_enabled ? ["node-exporter.${var.kubernetes_namespace[0]}.svc.cluster.local:9100"] : [])
  )
}

output "blackbox_exporter_endpoint" {
  description = "The endpoint for the deployed Blackbox Exporter."
  value = one(concat(
    aws_instance.blackbox_exporter_vm_aws.*.public_ip,
    google_compute_instance.blackbox_exporter_vm_gcp.*.network_interface[0].access_config[0].nat_ip,
    (var.kubernetes_enabled && var.blackbox_exporter_enabled ? ["blackbox-exporter.${var.kubernetes_namespace[0]}.svc.cluster.local:9115"] : [])
  ))
}

output "cloudwatch_exporter_endpoint" {
  description = "The endpoint for the deployed AWS CloudWatch Exporter."
  value = one(concat(
    aws_instance.cloudwatch_exporter_aws.*.public_ip,
    (var.kubernetes_enabled && var.aws_cloudwatch_exporter_enabled ? ["cloudwatch-exporter.${var.kubernetes_namespace[0]}.svc.cluster.local:9106"] : [])
  ))
}

output "stackdriver_exporter_endpoint" {
  description = "The endpoint for the deployed GCP Stackdriver Exporter."
  value = one(concat(
    google_compute_instance.stackdriver_exporter_gcp.*.network_interface[0].access_config[0].nat_ip,
    (var.kubernetes_enabled && var.gcp_stackdriver_exporter_enabled ? ["stackdriver-exporter.${var.kubernetes_namespace[0]}.svc.cluster.local:9249"] : [])
  ))
}

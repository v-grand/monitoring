# outputs.tf for Grafana module

output "grafana_endpoint" {
  description = "The endpoint URL for the deployed Grafana instance."
  value = one(concat(
    aws_instance.grafana_vm_aws.*.public_ip,
    google_compute_instance.grafana_vm_gcp.*.network_interface[0].access_config[0].nat_ip,
    (var.kubernetes_enabled ? ["grafana.${var.kubernetes_namespace[0]}.svc.cluster.local:3000"] : [])
  ))
}

output "grafana_instance_id" {
  description = "The ID of the Grafana VM instance (if deployed on VM)."
  value = one(concat(
    aws_instance.grafana_vm_aws.*.id,
    google_compute_instance.grafana_vm_gcp.*.self_link,
    []
  ))
}

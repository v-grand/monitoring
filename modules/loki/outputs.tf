# outputs.tf for Loki module

output "loki_endpoint" {
  description = "The endpoint URL for the deployed Loki instance."
  value = one(concat(
    aws_instance.loki_vm_aws.*.public_ip,
    google_compute_instance.loki_vm_gcp.*.network_interface[0].access_config[0].nat_ip,
    (var.kubernetes_enabled ? ["loki.${var.kubernetes_namespace[0]}.svc.cluster.local:3100"] : [])
  ))
}

output "loki_instance_id" {
  description = "The ID of the Loki VM instance (if deployed on VM)."
  value = one(concat(
    aws_instance.loki_vm_aws.*.id,
    google_compute_instance.loki_vm_gcp.*.self_link,
    []
  ))
}

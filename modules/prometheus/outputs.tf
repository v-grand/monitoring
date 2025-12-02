# outputs.tf for Prometheus module

output "prometheus_endpoint" {
  description = "The endpoint URL for the deployed Prometheus instance."
  value = one(concat(
    aws_instance.prometheus_vm_aws.*.public_ip,
    google_compute_instance.prometheus_vm_gcp.*.network_interface[0].access_config[0].nat_ip,
    (var.kubernetes_enabled ? ["prometheus-k8s-service.${var.kubernetes_namespace[0]}.svc.cluster.local:9090"] : [])
  ))
}

output "prometheus_instance_id" {
  description = "The ID of the Prometheus VM instance (if deployed on VM)."
  value = one(concat(
    aws_instance.prometheus_vm_aws.*.id,
    google_compute_instance.prometheus_vm_gcp.*.self_link,
    []
  ))
}

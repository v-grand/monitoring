# Requirements for the Tailscale-Integrated Monitoring System

This document outlines the technical requirements for a containerized monitoring system designed to operate within a Tailscale network (Tailnet).

## 1. Core Architecture: Tailscale-First

1.  **Primary Network:** The Tailnet is the primary network for all internal communication, including service discovery and metrics scraping. All components of the monitoring stack **must** join the Tailnet.
2.  **Location Independence:** The monitoring stack can be deployed on any machine within the Tailnet; it does not need to be on the same host as the services it is monitoring.
3.  **Docker Compose:** The system must be managed via a `docker-compose.yml` file.
4.  **Service Authentication:** Each component joining the network must authenticate with Tailscale, preferably using an auth key with appropriate tags (e.g., `tag:monitoring`).

## 2. Core Components & Configuration

The system should use the standard Prometheus & Grafana stack, adapted for a Tailscale environment.

1.  **Prometheus (`prom/prometheus`):**
    -   **Role:** Scrapes, stores, and queries metrics over the Tailnet.
    -   **Configuration (`prometheus.yml`):**
        -   **Targets:** All scrape targets **must** use their Tailscale hostnames or MagicDNS names (e.g., `nginx-gateway-host:9113`, not `nginx-exporter:9113`).
        -   **Service Discovery:** While static configs are simple, the ideal approach is to use Tailscale's API for service discovery to automatically find new services with a specific tag.

2.  **Grafana (`grafana/grafana`):**
    -   **Role:** Visualizes metrics.
    -   **Data Source:** Must be configured to use the Prometheus container's Tailscale address (e.g., `http://prometheus-host:9090`).
    -   **Gateway Integration:** The Grafana service **must** be named `grafana` in its `docker-compose.yml` so that the Nginx gateway can route traffic to it from the public `/monitoring/` path.

3.  **Exporters (`node-exporter`, `cadvisor`, `nginx-exporter`):**
    -   **Accessibility:** The ports of these exporters (e.g., 9100, 8080, 9113) do **not** need to be published to the host's public IP. They only need to be accessible from within the Tailnet.
    -   **Nginx Exporter:** The Nginx gateway project now runs its own `nginx-exporter`. The monitoring stack's Prometheus instance should be configured to scrape it.

## 3. How to Join the Tailnet from Docker

The recommended method is to use the official Tailscale Docker image as a sidecar container for services that need to join the network, like Prometheus.

### Example `docker-compose.yml` for the Monitoring System

This example shows how to run Prometheus and Grafana within a Tailnet.

```yaml
version: '3.8'

volumes:
  prometheus_data:
  grafana_data:
  tailscale_state:

services:
  # This container's only job is to connect the entire stack to the Tailnet
  tailscale:
    image: tailscale/tailscale:latest
    container_name: monitoring-tailscale
    hostname: monitoring-stack # This will be its MagicDNS name
    environment:
      - TS_AUTHKEY=tskey-auth-k... # Use a pre-authorized, ephemeral auth key
      - TS_STATE_DIR=/var/lib/tailscale
    volumes:
      - tailscale_state:/var/lib/tailscale
    restart: unless-stopped

  prometheus:
    image: prom/prometheus:latest
    container_name: prometheus
    # This service joins the network through the 'tailscale' container
    network_mode: "service:tailscale"
    volumes:
      - ./prometheus.yml:/etc/prometheus/prometheus.yml
      - prometheus_data:/prometheus
    depends_on:
      - tailscale
    restart: unless-stopped

  grafana:
    image: grafana/grafana:latest
    container_name: grafana
    # This service also joins the network through the 'tailscale' container
    network_mode: "service:tailscale"
    volumes:
      - grafana_data:/var/lib/grafana
    depends_on:
      - tailscale
    restart: unless-stopped

  # Node Exporter and cAdvisor would be deployed on each host being monitored
```

### Example `prometheus.yml` using Tailscale Hostnames

```yaml
global:
  scrape_interval: 15s

scrape_configs:
  - job_name: 'prometheus'
    static_configs:
      # Prometheus scrapes itself via the loopback interface
      - targets: ['localhost:9090']

  - job_name: 'nginx-gateway'
    static_configs:
      # Scrape the Nginx exporter using its Tailscale hostname
      # Replace 'nginx-gateway-host' with the actual Tailscale name of that machine
      - targets: ['nginx-gateway-host:9113']

  - job_name: 'node-exporter'
    static_configs:
      # Scrape the node exporter on the gateway machine
      - targets: ['nginx-gateway-host:9100']
```
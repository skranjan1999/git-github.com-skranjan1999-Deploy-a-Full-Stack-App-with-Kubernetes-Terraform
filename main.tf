provider "kubernetes" {
  config_path = "~/.kube/config"
}

#######################
# ConfigMap & Secret
#######################

resource "kubernetes_config_map" "frontend_config" {
  metadata {
    name = "frontend-config"
  }
  data = {
    BACKEND_URL = "http://backend-service:5000"
  }
}

resource "kubernetes_secret" "backend_secret" {
  metadata {
    name = "backend-secret"
  }
  data = {
    API_KEY = base64encode("my-secret-api-key")
  }
  type = "Opaque"
}

#######################
# Persistent Volume & Claim
#######################

resource "kubernetes_persistent_volume_claim" "shared_pvc1" {
  metadata {
    name = "shared-pvc1"
  }
  spec {
    access_modes = ["ReadWriteOnce"]
    resources {
      requests = {
        storage = "1Gi"
      }
    }
  }
}

#######################
# Backend Deployment & Service


resource "kubernetes_deployment" "backend" {
  metadata {
    name = "backend"
    labels = {
      app = "backend"
    }
  }

  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "backend"
      }
    }

    template {
      metadata {
        labels = {
          app = "backend"
        }
      }

      spec {
        container {
          name  = "backend"
          image = "saurabh70/backend"
          port {
            container_port = 5000
          }

          env {
            name = "API_KEY"
            value_from {
              secret_key_ref {
                name = kubernetes_secret.backend_secret.metadata[0].name
                key  = "API_KEY"
              }
            }
          }

          volume_mount {
            name       = "shared-storage"
            mount_path = "/data"
          }

          resources {
            limits = {
              cpu = "500m"
            }
            requests = {
              cpu = "200m"
            }
          }
        }

        volume {
          name = "shared-storage"
          persistent_volume_claim {
            claim_name = kubernetes_persistent_volume_claim.shared_pvc1.metadata[0].name
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "backend_service" {
  metadata {
    name = "backend-service"
  }

  spec {
    selector = {
      app = "backend"
    }

    port {
      port        = 5000
      target_port = 5000
    }

    type = "ClusterIP"
  }
}

#######################
# Backend Autoscaler
#######################

resource "kubernetes_horizontal_pod_autoscaler_v2" "backend_autoscaler" {
  metadata {
    name = "backend-hpa"
  }

  spec {
    scale_target_ref {
      api_version = "apps/v1"
      kind        = "Deployment"
      name        = kubernetes_deployment.backend.metadata[0].name
    }

    min_replicas = 1
    max_replicas = 3

    metric {
      type = "Resource"

      resource {
        name = "cpu"
        target {
          type               = "Utilization"
          average_utilization = 80
        }
      }
    }
  }
}






# Frontend Deployment & Service



resource "kubernetes_deployment" "frontend" {
  metadata {
    name = "frontend"
    labels = {
      app = "frontend"
    }
  }

  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "frontend"
      }
    }

    template {
      metadata {
        labels = {
          app = "frontend"
        }
      }

      spec {
        container {
          name  = "frontend"
          image = "saurabh70/frontend"
          port {
            container_port = 80
          }

          env {
            name = "BACKEND_URL"
            value_from {
              config_map_key_ref {
                name = kubernetes_config_map.frontend_config.metadata[0].name
                key  = "BACKEND_URL"
              }
            }
          }

          volume_mount {
            name       = "shared-storage"
            mount_path = "/data"
          }
        }

        volume {
          name = "shared-storage"
          persistent_volume_claim {
            claim_name = kubernetes_persistent_volume_claim.shared_pvc1.metadata[0].name
          }
        }
      }
    }
  }
}



resource "kubernetes_service" "frontend_service" {
  metadata {
    name = "frontend-service"
  }

  spec {
    selector = {
      app = "frontend"
    }

    port {
      port        = 80
      target_port = 80
      node_port   = 30080
    }

    type = "NodePort"
  }
}

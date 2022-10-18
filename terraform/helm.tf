resource "helm_release" "helm-chart"{
    name= "api"
    chart= "./helm-chart"
    #namespace = "test"
    
    set_sensitive {
        name  = "username"
        value = var.DB_Secrets.DB_USER
    }
    set_sensitive {
        name  = "password"
        value = var.DB_Secrets.DB_PASSWORD
    }
    set_sensitive {
        name  = "ip"
        value = var.DB_Secrets.DB_IP
    }
    set_sensitive {
        name  = "name"
        value = var.DB_Secrets.DB_NAME
    }
}

output "helm-data" {
  value       = helm_release.helm-chart
  sensitive = true
}
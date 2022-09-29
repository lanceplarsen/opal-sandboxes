#namespaces
resource "kubernetes_namespace" "public-api" {
  metadata {
    annotations = {
      name = "public-api"
    }
    name = "public-api"
  }
}

#cluster role bindings
resource "kubernetes_cluster_role_binding" "cluster-viewer" {
  metadata {
    name = "opal:viewers"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "view"
  }
  subject {
    kind      = "Group"
    name      = "opal:viewers"
    api_group = "rbac.authorization.k8s.io"
  }
}

#role bindings
resource "kubernetes_role_binding" "public-api-admin" {
  metadata {
    name      = "opal:public-api-admins"
    namespace = "public-api"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "admin"
  }
  subject {
    kind      = "Group"
    name      = "opal:public-api-admins"
    api_group = "rbac.authorization.k8s.io"
  }
}

#namespaces
resource "kubernetes_namespace" "backend" {
  metadata {
    annotations = {
      name = "backend"
    }
    name = "backend"
  }
}
resource "kubernetes_namespace" "data-science" {
  metadata {
    annotations = {
      name = "data-science"
    }
    name = "data-science"
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
    name      = "opal:viewer"
    api_group = "rbac.authorization.k8s.io"
  }
}

#role bindings
resource "kubernetes_role_binding" "backend-admin" {
  metadata {
    name      = "opal:backend-admin"
    namespace = "backend"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "admin"
  }
  subject {
    kind      = "Group"
    name      = "opal:backend-admin"
    api_group = "rbac.authorization.k8s.io"
  }
}
resource "kubernetes_role_binding" "data-science-admin" {
  metadata {
    name      = "opal:data-science-admin"
    namespace = "data-science"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "admin"
  }
  subject {
    kind      = "Group"
    name      = "opal:data-science-admin"
    api_group = "rbac.authorization.k8s.io"
  }
}

#namespaces per team
resource "kubernetes_namespace" "public-api" {
  metadata {
    annotations = {
      name = "public-api"
    }
    name = "public-api"
  }
}
resource "kubernetes_namespace" "web" {
  metadata {
    annotations = {
      name = "web"
    }
    name = "web"
  }
}

#cluster role binding - cluster viewers
resource "kubernetes_role" "view-nodes" {
  metadata {
    name = "view-nodes"
  }
  rule {
    api_groups = [""]
    resources  = ["nodes"]
    verbs      = ["get", "list", "watch"]
  }
}
resource "kubernetes_cluster_role_binding" "cluster-viewer" {
  metadata {
    name = "opal:viewers"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "view"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "view-nodes"
  }
  subject {
    kind      = "Group"
    name      = "opal:viewers"
    api_group = "rbac.authorization.k8s.io"
  }
}

#role bindings - namespace admins
resource "kubernetes_role_binding" "developer-web" {
  metadata {
    name      = "opal:web-admin"
    namespace = "web"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "admin"
  }
  subject {
    kind      = "Group"
    name      = "opal:developers-web"
    api_group = "rbac.authorization.k8s.io"
  }
}
resource "kubernetes_role_binding" "developer-public-api" {
  metadata {
    name      = "opal:public-api-admin"
    namespace = "public-api"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "admin"
  }
  subject {
    kind      = "Group"
    name      = "opal:developers-public-api"
    api_group = "rbac.authorization.k8s.io"
  }
}

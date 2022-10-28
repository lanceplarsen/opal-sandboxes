#namespaces per team
resource "kubernetes_namespace" "product" {
  metadata {
    annotations = {
      name = "product"
    }
    name = "product"
  }
}
resource "kubernetes_namespace" "payments" {
  metadata {
    annotations = {
      name = "payments"
    }
    name = "payments"
  }
}
resource "kubernetes_namespace" "data_science" {
  metadata {
    annotations = {
      name = "data-science"
    }
    name = "data-science"
  }
}

#cluster role binding - cluster viewers
resource "kubernetes_cluster_role" "view_nodes" {
  metadata {
    name = "view-nodes"
  }
  rule {
    api_groups = [""]
    resources  = ["nodes"]
    verbs      = ["get", "list", "watch"]
  }
}
resource "kubernetes_cluster_role_binding" "cluster_view" {
  metadata {
    name = "opal:view"
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
resource "kubernetes_cluster_role_binding" "node_view" {
  metadata {
    name = "opal:view-nodes"
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
resource "kubernetes_role_binding" "developer_product" {
  metadata {
    name      = "opal:product-admin"
    namespace = "product"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "admin"
  }
  subject {
    kind      = "Group"
    name      = "opal:developers-product"
    api_group = "rbac.authorization.k8s.io"
  }
}
resource "kubernetes_role_binding" "developer_payments" {
  metadata {
    name      = "opal:payments-admin"
    namespace = "payments"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "admin"
  }
  subject {
    kind      = "Group"
    name      = "opal:developers-payments"
    api_group = "rbac.authorization.k8s.io"
  }
}
resource "kubernetes_role_binding" "data_science" {
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
    name      = "opal:developers-public-api"
    api_group = "rbac.authorization.k8s.io"
  }
}

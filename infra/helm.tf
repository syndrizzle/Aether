resource "helm_release" "metrics_server" {
  name       = "metrics-server"
  repository = "https://kubernetes-sigs.github.io/metrics-server/"
  chart      = "metrics-server"
  namespace  = "kube-system"
  depends_on = [module.eks]
  set = [
    {
      name  = "args[0]"
      value = "--kubelet-insecure-tls"
    }
  ]
}

resource "helm_release" "cluster_autoscaler" {
  name       = "cluster-autoscaler"
  repository = "https://kubernetes.github.io/autoscaler"
  chart      = "cluster-autoscaler"
  namespace  = "kube-system"
  depends_on = [module.eks]
  set = [
    {
      name  = "autoDiscovery.clusterName"
      value = module.eks.cluster_name
    },
    {
      name  = "awsRegion"
      value = "ap-south-1"
    }
  ]
}

variable "dags_git_url" {
  default = "https://github.com/shinyfoil/super-janky-eth-airflow.git"
}

data "template_file" "airflow" {
  template = yamlencode(yamldecode(file("${path.module}/airflow-values.yaml")))
  vars = {
    dags_git_url = var.dags_git_url




  }
}

data "helm_repository" "stable" {
  name = "stable"
  url  = "https://kubernetes-charts.storage.googleapis.com"
}

resource "helm_release" "airflow" {
  name       = "airflow"
  chart      = "stable/airflow"
  repository = data.helm_repository.stable.metadata[0].name
  namespace  = "kube-system"

  values = [data.template_file.airflow.rendered]
}

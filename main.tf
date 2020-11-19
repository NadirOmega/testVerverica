provider "ibm" {
  ibmcloud_api_key = "${var.ibm_api_key}"
}

data ibm_resource_group group {
  name = "ITGP_DATA"
}
data ibm_container_cluster k8s {
  resource_group_id = data.ibm_resource_group.group.id
  cluster_name_id = "kb-bnpp-itgp-data06-yl-kc-dev"
}
provider kubernetes {
  load_config_file       = false
  host                   = "${data.ibm_container_cluster_config.cluster.host}"
  client_certificate     = "${data.ibm_container_cluster_config.cluster.admin_certificate}"
  client_key             = "${data.ibm_container_cluster_config.cluster.admin_key}"
  cluster_ca_certificate = "${data.ibm_container_cluster_config.cluster.ca_certificate}"
}


##############################################################################
# Kubernetes Provider
##############################################################################

provider "helm" {
  kubernetes {
  config_path = "${data.ibm_container_cluster_config.cluster.config_file_path}"
  load_config_file       = false
    host                   = "${data.ibm_container_cluster_config.cluster.host}"
    client_certificate     = "${data.ibm_container_cluster_config.cluster.admin_certificate}"
    client_key             = "${data.ibm_container_cluster_config.cluster.admin_key}"
    cluster_ca_certificate = "${data.ibm_container_cluster_config.cluster.ca_certificate}"
}
resource "helm_release" "ververica" {
   create_namespace =true
   namespace = "ververica"
   name      = "ververicaTest"
   repository = "https://charts.ververica.com"
   chart     = "ververica/ververica-platform"
   version ="4.3.1"
   timeout = 600
   cleanup_on_fail = true  
   #set additional specification
 
   values = [
    "${file("values.yaml")}"
  ]
}
}

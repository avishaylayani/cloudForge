variable "instances" {
    type = list(string)
    default = ["cicd", "k8s_master", "k8s_node1", "k8s_node2"]
}
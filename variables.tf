variable "topic_name" {}
variable "cluster_id" {}
variable "member_name" {
  type = string
  default = ""
}
variable "instance_state_bucket_name" {
  type = string
  default = ""
}
variable "binding_iam_policy" {
  type = bool
  default = false
}
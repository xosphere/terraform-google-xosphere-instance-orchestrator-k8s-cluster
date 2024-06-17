locals {
  topic_name_pieces = split("/", var.topic_name)
  topic_id = element(local.topic_name_pieces, 3)
  topic_project_id = element(local.topic_name_pieces, 1)

  k8s_cluster_id_pieces = split("/", var.cluster_id)
  cluster_name = element(local.k8s_cluster_id_pieces, 5)
  cluster_location = element(local.k8s_cluster_id_pieces, 3)
  cluster_project_id = element(local.k8s_cluster_id_pieces, 1)

}

data "google_pubsub_topic" "node_drain_topic" {
  name = local.topic_id
  project = local.topic_project_id
}

data "google_container_cluster" "k8s_cluster" {
  name     = local.cluster_name
  location = local.cluster_location
  project = local.cluster_project_id
}

resource "google_pubsub_subscription" "node_drain_topic_subscription" {
  name  = "xosphere-node-drain-subscription-${sha256(data.google_container_cluster.k8s_cluster.id)}"
  topic = local.topic_id
  filter = "attributes.id=\"${data.google_container_cluster.k8s_cluster.id}\""
  ack_deadline_seconds = 120
  project = local.topic_project_id
}

resource "google_pubsub_subscription_iam_member" "subscriber" {
  count = var.binding_iam_policy ? 1 : 0
  subscription = google_pubsub_subscription.node_drain_topic_subscription.id
  role         = "roles/pubsub.subscriber"
  member = var.member_name
}

resource "google_storage_bucket_iam_member" "instance_state_bucket_owner" {
  count = var.binding_iam_policy ? 1 : 0
  bucket = var.instance_state_bucket_name
  role   = "roles/storage.objectCreator"
  member = var.member_name
}

/**
 * Copyright 2020 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

locals {
  cluster_type = "regional"
}

provider "google" {
  project = var.project_id
  version = "~> 3.29.0"
}

provider "google-beta" {
  project = var.project_id
  version = "~> 3.29.0"
}

data "google_compute_network" "anthos-platform" {
  name = "anthos-platform"
}

data "google_compute_subnetwork" "anthos-platform-central" {
  name   = "anthos-platform-central"
  region = "us-central1"
}

data "google_compute_subnetwork" "anthos-platform-east" {
  name   = "anthos-platform-east"
  region = "us-east1"
}

module "anthos-platform-dev" {
  source            = "./modules/anthos-platform-cluster"
  project_id        = var.project_id
  name              = "dev-us-central1"
  region            = "us-central1"
  network           = data.google_compute_network.anthos-platform.name
  subnetwork        = data.google_compute_subnetwork.anthos-platform-central.name
  ip_range_pods     = "anthos-platform-pods-dev"
  ip_range_services = "anthos-platform-services-dev"
}

module "anthos-platform-staging" {
  source            = "./modules/anthos-platform-cluster"
  project_id        = var.project_id
  name              = "staging-us-central1"
  region            = "us-central1"
  network           = data.google_compute_network.anthos-platform.name
  subnetwork        = data.google_compute_subnetwork.anthos-platform-central.name
  ip_range_pods     = "anthos-platform-pods-staging"
  ip_range_services = "anthos-platform-services-staging"
}

module "anthos-platform-prod-central" {
  source            = "./modules/anthos-platform-cluster"
  project_id        = var.project_id
  name              = "prod-us-central1"
  region            = "us-central1"
  network           = data.google_compute_network.anthos-platform.name
  subnetwork        = data.google_compute_subnetwork.anthos-platform-central.name
  ip_range_pods     = "anthos-platform-pods-prod"
  ip_range_services = "anthos-platform-services-prod"
}

module "anthos-platform-prod-east" {
  source            = "./modules/anthos-platform-cluster"
  project_id        = var.project_id
  name              = "prod-us-east1"
  region            = "us-east1"
  network           = data.google_compute_network.anthos-platform.name
  subnetwork        = data.google_compute_subnetwork.anthos-platform-east.name
  ip_range_pods     = "anthos-platform-pods-prod"
  ip_range_services = "anthos-platform-services-prod"
}

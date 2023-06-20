# GitLab Docker Autoscaler CICD Runner on GCP

This module provisions one or multiple docker autoscaler runners on Google Cloud Platform using Terraform.

## Project Objectives

- Provide low-cost CICD resources for projects and groups on GitLab
- Optimize runners for maximum speed
- Provide for job separation to maintain security
- Be self-contained and opinionated yet configurable

## Created Resources Description

This module creates a [Docker Autoscaler](https://docs.gitlab.com/runner/executors/docker_autoscaler.html) instance on Google Cloud Platform that is managed by a single persistant VM, then provisions a instance pool for each configured runner, creates a GCS bucket to store the runners' cache (one bucket for all configured runners at the moment), and builds the config.toml file.

The runner machines in the instance pool are backed by SSD disks, making them reasonably fast.

## Setup

> **DANGER: Ensure that your Terraform state is secure**
> 
> Static SSH credentials are stored in state, and if disclosed could give an unauthorized actor access to your runner fleet.
> 
> Additionally, the GitLab registration tokens could be exploited to create a fake runner resulting in exposure of credentials used by jobs.

### Required Quota Requests

This runner uses a lot (a lot!) of compute resources at peak usage, and therefore Google ***will throw errors by default*** unless the relevant quotas are increased:

- Compute Engine API > In-use IP addresses
  - Request: 1.2 * combined concurrency
- Compute Engine API > CPUs (all regions)
  - Request: 1.2 * combined concurrency * average # of CPUs per VM
- Compute Engine API > CPUs
  - Request: 1.2 * combined concurrency * average # of CPUs per VM
- Compute Engine API > VM Instances
  - Request: 1.2 * combined concurrency
- Compute Engine API > Persistent Disk SSD (GB) (in active region)
  - Request: 1.2.* 25 * combined concurrency

### Configuration Example

The following is an example configuration:

```tf
module "gitlab_runner" {
  source          = "./gitlab_runner"
  cache_max_age   = 7
  host_project    = var.project_id
  manager_vm_type = "e2-micro"
  region          = "us-central1"
  zone            = "us-central1-c"

  runners = [
    {
      id            = "runner-small"
      name          = "Runner - Small"
      token         = var.small_runner_token
      concurrency   = 20
      default_image = "alpine:latest"
      disk_size_gb  = 25
      idle_count    = 0
      vm_type       = "e2-standard-2"
    },
    {
      id            = "runner-large"
      name          = "Runner - Large"
      token         = var.large_runner_token
      concurrency   = 20
      default_image = "alpine:latest"
      disk_size_gb  = 25
      idle_count    = 0
      vm_type       = "e2-highcpu-8"
    }
  ]
}
```

With this configuration, for the compute itself you theoretically see variable costs of ~$0.0003/job/minute on the small runner and ~$0.001/job/minute on the large runner, on top of a monthly fixed cost of ~$6.00. Networking and storage costs are above and beyond these numbers. (Of course, your mileage may vary. Prices as of June 2023)

## Contributing

We do not claim that this module is perfect, so we would love to hear your suggestions for how it can be improved, or review an MR with your changes!

### Ideas for future config options

- Enable/Disable the cache bucket
- Provide an externally defined GCS bucket to use as the cache for the runners

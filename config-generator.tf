locals {
  # Compile a list of config blocks corresponding to each configured runner
  main_runner_config = join("\n\n", [
    for runner in module.runner : runner.config
  ])

  # Calculate the combined concurrency across all configured runners
  total_concurrency = sum([
    for runner in var.runners : runner.concurrency
  ])

  # Compile the complete config.toml file for consumption by the manager VM
  full_config = <<EOF
concurrent = ${local.total_concurrency}

${local.main_runner_config}
EOF
}
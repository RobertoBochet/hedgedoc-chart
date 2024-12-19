# HedgeDoc (unofficial) Helm Chart

[![GitHub](https://img.shields.io/github/license/RobertoBochet/hedgedoc-chart?style=flat-square)](https://github.com/RobertoBochet/hedgedoc-chart)
[![GitHub Workflow Status](https://img.shields.io/github/actions/workflow/status/RobertoBochet/hedgedoc-chart/release.yml?label=publish%20chart&style=flat-square)](https://github.com/RobertoBochet/scraper-bot/pkgs/container/hedgedoc-chart)
[![GitHub Latest Release Version](https://img.shields.io/github/v/release/RobertoBochet/hedgedoc-chart?sort=semver&display_name=release&style=flat-square)](https://github.com/RobertoBochet/hedgedoc-chart/releases)
[![Static Badge](https://img.shields.io/badge/-hedgedoc-w?style=flat-square&logo=artifacthub&logoColor=white&logoSize=18&label=Artifact%20Hub&labelColor=417598&color=2D4857)](https://artifacthub.io/packages/helm/robertobochet/hedgedoc)

[HedgeDoc](https://hedgedoc.org/) (formerly known as CodiMD) is an open-source, web-based, self-hosted, collaborative markdown editor.

## Deploy

1. Add the repository to helm
   ```shell
   helm repo add robertobochet https://robertobochet.github.io/charts
   helm repo update
   ```
2. Retrieve the default values file
   ```shell
   helm show values robertobochet/hedgedoc > values.yaml
   ```
3. Customize the `values.yaml`
4. Install hedgedoc
   ```shell
   helm install scraper-bot robertobochet/hedgedoc -f values.yaml
   ```

## Parameters

# Introduction
Kafka-conn is a Kafka Connector provisioning as a code following Gitops concept by using Gitlab Pipeline.

Deployment as Code ([GitOps style](https://gitops.tech/))

# Installtion
## Prerequisite
- Docker
- Kafka Confluent by Kubernetes Helm Charts: https://docs.confluent.io/5.0.0/installation/installing_cp/cp-helm-charts/docs/index.html
- Gitlab Pipeline

## Run
```sh
$ docker build . -t kafka-conn:v1
$ docker run kafka-conn:v1 kafka-conn --help
Usage: /app/kafka-conn [--help -h] 
Eg: 
         /app/kafka-conn -h --help 
         /app/kafka-conn validate env/dev
         /app/kafka-conn apply env/dev
         /app/kafka-conn sync env/dev
```

# Instructions for Use
## Folder structure
```
$ tree env
├── env
│   ├── dev
│   │   ├── __sink-minio-kong
│   │   └── __source-orders-dev
│   └── stag
│       └── __sink-echo-s3
```
- Each file with prefix `__<sink/source>-connectorName` will be configured via REST API to Kafka-Connector. To define which Kafka-connector is used via OS variable `$KAFKA_CONNECT_URL`
- Let's check `.gitlab-ci.yml` for more info.

## Gitlab Pipeline
- To make sure all PR/Commit for creating a connector is validated, I proposed this pipeline to validate, apply and clean up all connector in the kafka.

```yaml
stages:
- validate # All jobs in this stage will check all connector syntax, json validation...etc
- apply # This will be run kafka-conn apply to the connector.
- cleanup # This job cleans up all unused and undefined in env/* folder.
```

# Acknowledgements
- https://docs.gitlab.com/ee/ci/pipelines/
- https://docs.confluent.io/platform/current/connect/references/restapi.html
- 

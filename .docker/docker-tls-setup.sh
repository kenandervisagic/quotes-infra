#!/bin/bash

# Export Docker TLS settings
export DOCKER_TLS_VERIFY=1
export DOCKER_CERT_PATH=${GITHUB_WORKSPACE}/.docker
export DOCKER_HOST=$DOCKER_HOST

# Create the directory to store Docker certs
mkdir -p $DOCKER_CERT_PATH

# Decode the base64 encoded certificates and save them
echo "$CERT_PEM" | base64 --decode > $DOCKER_CERT_PATH/cert.pem
echo "$KEY_PEM" | base64 --decode > $DOCKER_CERT_PATH/key.pem
echo "$CA_PEM" | base64 --decode > $DOCKER_CERT_PATH/ca.pem
echo "Docker TLS setup complete"

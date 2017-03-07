#!/bin/bash
#
# Script to zip up lambda functions and then call terraform

echo "Zipping lambda functions"
for DIRECTORY in on_ingest on_scan process_file; do
  if [ -s lambdas/${DIRECTORY}/requirements.txt ]; then
    pip install -d lambdas/${DIRECTORY}/ -r lambdas/${DIRECTORY}/requirements.txt
  fi
  zip -j dd_${DIRECTORY}.zip lambdas/${DIRECTORY}/*
done

echo "Running terraform apply"
terraform apply terraform

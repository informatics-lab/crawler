export

all: help

help:
	terraform

apply: build simple-apply

simple-apply:
	terraform apply terraform

destroy:
	terraform destroy terraform

build:
	echo "Zipping lambda functions"
	@for DIRECTORY in on_ingest on_scan process_file; do \
	  if [ -s lambdas/$${DIRECTORY}/requirements.txt ]; then \
	    pip install -d lambdas/$${DIRECTORY}/ -r lambdas/$${DIRECTORY}/requirements.txt; \
	  fi; \
	  zip -j dd_$${DIRECTORY}.zip lambdas/$${DIRECTORY}/*; \
	done

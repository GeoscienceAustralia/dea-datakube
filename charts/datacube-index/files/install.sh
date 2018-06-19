#!/bin/bash
set -e

# Add config to wms
cp wms_cfg.py /code/datacube_wms/wms_cfy.py

# install psql for WMS database script
apt-get update && apt-get install -y --no-install-recommends \
    postgresql-client \
    && rm -rf /var/lib/apt/lists/*

# install ruamel for yaml parsing
pip3 install \
    ruamel.yaml \
    && rm -rf $HOME/.cache/pip

# Init system
datacube system init --no-init-users 2>&1

# Add Products @TODO: Make this a variable
datacube product add product-nrt-ls8.yaml
datacube product add product-nrt-s2.yaml

# Generate WMS specific config
PGPASSWORD=$DB_PASSWORD psql \
    -d $DB_DATABASE \
    -h $DB_HOSTNAME \
    -p $DB_PORT \
    -U $DB_USERNAME \
    -f /code/create_tables.sql 2>&1

# Run index
/bin/bash update_ranges_wrapper.sh
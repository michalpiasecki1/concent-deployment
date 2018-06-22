#! /bin/bash -e

source concent-env.sh
cd concent_api/

django_databases_name=(
    control
    storage
)

for django_db_name in "${django_databases_name[@]}"; do
    ./manage.py migrate --database=$django_db_name
done

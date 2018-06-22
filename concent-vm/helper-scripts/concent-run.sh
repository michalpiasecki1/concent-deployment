#! /bin/bash -e

trap "kill 0" SIGINT

source concent-env.sh
cd concent_api/

django_runserver_and_celery_command="$(
    celery worker                                   \
        --app=concent_api                           \
        --hostname=concent                          \
        --queues=concent &                          \
    celery worker                                   \
        --app=concent_api                           \
        --hostname=conductor                        \
        --queues=conductor &                        \
    celery worker                                   \
        --app=concent_api                           \
        --queues=verifier &                         \
    python manage.py runserver 0.0.0.0:8000 &       \
)"

$django_runserver_and_celery_command

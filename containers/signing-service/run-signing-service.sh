#! /bin/bash -e

cd /srv/http/
source /srv/http/virtualenv/bin/activate
./signing_service.sh $@

#! /bin/bash -e

DEFAULT_BRANCH=master

branch_name="${1:-$DEFAULT_BRANCH}"

cd ~/concent/concent_api/

# Fetch new code and checkout specific branch
git fetch --prune
git checkout origin/$branch_name

# Delete and recreate virtualenv
rm -rf ~/virtualenv/

virtualenv --python python3.6 ~/virtualenv/
source ~/virtualenv/bin/activate
cd ~/concent/
python -m pip install --requirement "concent_api/requirements.lock"
python -m pip install --requirement "requirements-development.txt"
python -m pip install gunicorn==19.7.1

# Migrate databases
concent-migrate.sh

#! /bin/bash -e

# Confirm executing script
read -p "Are you sure about execute this script? It's destroy databases, queues and other components like: Geth etc. [y/n]" -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    databases_name=(
        concent_api
        storage
    )

# Delete and recreate databases
    for db_name in "${databases_name[@]}"; do
        psql --host localhost --username postgres <<-EOF
            DROP DATABASE IF EXISTS $db_name;
            CREATE DATABASE $db_name;
EOF
    done

# Migrate databases
concent-migrate.sh

# Create superuser account
python_command="from django.contrib.auth.models import User;"
python_command="$python_command User.objects.create_superuser('admin', 'admin@example.com', 'password')"

(
source concent-env.sh
cd concent_api/
echo "$python_command"         \
    | python manage.py shell
)
# Reset Rabbitmq setting to default state
docker exec                                                                         \
    rabbitmq                                                                        \
    sh -c "rabbitmqctl stop_app && rabbitmqctl reset && rabbitmqctl start_app"

# Restart all service
sudo systemctl restart postgresql.service
sudo systemctl restart nginx.service
docker restart geth

fi

DB_NAME="some_name_db"
DB_USERNAME="some_username"
DB_PASSWORD="some_password"
DB_PORT="5432"

if [ $# -eq 0 ]
then
  echo "First parameter should be the name of the db.dump file."
  exit 1
fi

echo "Run docker db container"
docker compose up db -d

docker compose run db psql "postgres://$DB_USERNAME:$DB_PASSWORD@db:$DB_PORT/" -c "DROP DATABASE IF EXISTS $DB_NAME;"
docker compose run db psql "postgres://$DB_USERNAME:$DB_PASSWORD@db:$DB_PORT/" -c "CREATE DATABASE $DB_NAME;"

docker exec -i "$(docker compose ps -q db)" pg_restore --clean --no-acl --no-owner -U "$DB_USERNAME" -d "$DB_NAME" < "$1"

echo "Migrate DB"
docker compose run django python manage.py migrate
docker compose run -T django python manage.py shell < remakedb_pythondata.py

docker compose stop db

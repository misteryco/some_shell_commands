DB_NAME="some_name"

echo "Fetching the latest staging database dump..."
curl -o db.dump `heroku pg:backups:url --app app_name`

echo "Recreating the local database..."
dropdb --if-exists "$DB_NAME"

echo "Creating database ..."
sudo -u "$1" createdb -O "$1" "$DB_NAME"

echo "Starting pg_restore on the local database..."
pg_restore -U $1 -d "$DB_NAME" -v db.dump > dump_log 2>&1
rm db.dump

echo "Running migrations on the local database..."
python manage.py migrate

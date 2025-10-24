DB_NAME="some_name"

echo "Fetching the latest staging database dump..."
curl -o db.dump `heroku pg:backups:url --app app_name`

echo "Recreating the local database..."
dropdb --if-exists "$DB_NAME"

echo "Creating database ..."
sudo -u "$1" createdb -O "$1" "$DB_NAME"

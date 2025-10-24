DB_NAME="some_name"

echo "Fetching the latest database dump..."
curl -o db.dump `heroku pg:backups:url --app app_name`

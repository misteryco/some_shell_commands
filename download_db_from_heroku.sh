APP_NAME="some-name"
DUMP_FILE="db_$(date +%F).dump"

echo "✅ Fetching latest database dump from Heroku app: $APP_NAME"
echo "--------------------------------------"

curl -o "$DUMP_FILE" "$(heroku pg:backups:url --app "$APP_NAME")"

echo "--------------------------------------"
echo "📦 Output file: $DUMP_FILE"

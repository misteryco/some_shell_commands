DB_NAME="some_name_db"
DB_USERNAME="some_username"
DB_PASSWORD="some_password"
DB_PORT="5432"

if [ $# -eq 0 ]
then
  echo "❌ Error: First parameter should be the name of the db.dump file."
  echo "Usage: $0 <dump_file>"
  exit 1
fi

DUMP_FILE="$1"

echo "📦 Starting database restore process..."
echo "--------------------------------------"
echo "🚀 Starting Docker DB container..."
docker compose up db -d

echo "🧹 Dropping existing database \"$DB_NAME\" (if exists)..."
docker compose run db psql "postgres://$DB_USERNAME:$DB_PASSWORD@db:$DB_PORT/" -c "DROP DATABASE IF EXISTS $DB_NAME;"

echo "🏗️ Creating new database \"$DB_NAME\"..."
docker compose run db psql "postgres://$DB_USERNAME:$DB_PASSWORD@db:$DB_PORT/" -c "CREATE DATABASE $DB_NAME;"

echo "📤 Restoring database from dump file: $DUMP_FILE"
docker exec -i "$(docker compose ps -q db)" pg_restore --clean --no-acl --no-owner -U "$DB_USERNAME" -d "$DB_NAME" < "$DUMP_FILE"

echo "⚙️ Applying Django migrations..."
docker compose run django python manage.py migrate

echo "📜 Loading additional Python data (remakedb_pythondata.py)..."
docker compose run -T django python manage.py shell < remakedb_pythondata.py

echo "🛑 Stopping Docker DB container..."
docker compose stop db

echo "✅ Database restoration and migration completed successfully!"
echo "--------------------------------------"

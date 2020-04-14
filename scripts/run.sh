DIRSEED="./db/seeders/"
DIRMIGRATION="./db/migrations/"

echo "### Waiting for database $DATABASE_URL"
./scripts/wait-for-it.sh $DATABASE_URL:5432 -- echo "Database is up"

echo "### Running migrations"
node_modules/.bin/sequelize db:migrate --env "$NODE_ENV"

if [ -d "$DIRSEED" ] && [ "$(ls -A $DIRSEED)" ] 
then 
  echo "### Applying seeds"
  node_modules/.bin/sequelize db:seed:all --env "$NODE_ENV"
fi 

echo "### Starting service"
if [ "$NODE_ENV" == "production" ]
then
  npm run build:prod && npm run pm2
else
  npm run watch
fi

#!/usr/bin/env bash

symfony new web --version=6.4

cd ./web
symfony composer config extra.symfony.allow-contrib false

#
symfony composer require --no-interaction symfony/serializer-pack symfony/uid symfony/validator \
  doctrine/doctrine-migrations-bundle doctrine/orm gesdinet/jwt-refresh-token-bundle nelmio/cors-bundle
# dev
symfony composer require --no-interaction --dev symfony/maker-bundle doctrine/doctrine-fixtures-bundle

sed -i '29 s!DATABASE_URL=.*!DATABASE_URL="postgresql://myuser:secret@database:5432/mydatabase?serverVersion=16\&charset=utf8"!' .env
sed -i '26,28 d' .env

rm -rf .git compose*.yaml

symfony console make:user --is-entity --identity-property-name=email --with-password --with-uuid --no-interaction User
#symfony console make:controller --no-template BookController
#symfony console make:entity --with-uuid --no-interaction Book
symfony console lexik:jwt:generate-keypair
symfony console doctrine:migrations:diff --no-interaction
cd ..

chmod -R a+rw web
rsync -a web/ ./
rm -rf web

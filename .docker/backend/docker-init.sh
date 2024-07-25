#!/usr/bin/env bash

if [ ! -d "./src" ]; then
  . /home/install.sh
fi

symfony composer install --no-interaction

while ! nc -z database 5432; do sleep 1; done
symfony console doctrine:database:create --if-not-exists
symfony console doctrine:migrations:migrate --no-interaction
symfony console doctrine:fixtures:load --no-interaction

symfony server:start --daemon

tail -f /dev/null

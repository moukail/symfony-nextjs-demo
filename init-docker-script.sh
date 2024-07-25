#!/usr/bin/env bash

if [ -d ".docker" ]; then
  echo "docker exists"
  exit
fi

mkdir -p .docker/backend
cat << EOF > ./.docker/backend/Dockerfile
FROM php:8.3-fpm-alpine3.20

ENV TIMEZONE 'UTC'

RUN apk --update --no-cache add linux-headers bash wget gcc g++ make autoconf libsodium-dev openssh rsync git postgresql-dev
RUN docker-php-ext-install -j\$(nproc) pdo_mysql pdo_pgsql

RUN pecl install xdebug libsodium && docker-php-ext-enable xdebug opcache

# Use the default production configuration
RUN mv "\$PHP_INI_DIR/php.ini-production" "\$PHP_INI_DIR/php.ini" \
    && sed -i "s|;date.timezone =.*|date.timezone = \${TIMEZONE}|" /usr/local/etc/php/php.ini \
    && sed -i "s|memory_limit =.*|memory_limit = -1|" /usr/local/etc/php/php.ini

RUN echo $'zend_extension=xdebug.so \n\
xdebug.default_enable=1 \n\
xdebug.remote_enable=1 \n\
xdebug.remote_host=host.docker.internal '\
> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin/ --filename=composer
# Symfony CLI
RUN wget https://get.symfony.com/cli/installer -O - | bash && mv /root/.symfony5/bin/symfony /usr/bin/symfony

### Codeception
RUN wget http://codeception.com/codecept.phar -O /usr/bin/codecept && chmod a+x /usr/bin/codecept

RUN addgroup _www && adduser -S -H --ingroup _www _www

WORKDIR /var/www

ADD install.sh /home/
RUN chmod +x /home/install.sh
CMD bash /home/install.sh

ADD docker-init.sh /home/
RUN chmod +x /home/docker-init.sh
CMD bash /home/docker-init.sh
EOF

cat << EOF > ./.docker/backend/install.sh
#!/usr/bin/env bash

symfony new web --version=6.4

cd ./web
symfony composer config extra.symfony.allow-contrib false

#
symfony composer require --no-interaction symfony/serializer-pack symfony/uid symfony/validator doctrine/doctrine-migrations-bundle doctrine/orm gesdinet/jwt-refresh-token-bundle
# dev
symfony composer require --no-interaction --dev symfony/maker-bundle doctrine/doctrine-fixtures-bundle league/factory-muffin-faker

sed -i '29 s!DATABASE_URL=.*!DATABASE_URL="postgresql://myuser:secret@database:5432/mydatabase?serverVersion=16\&charset=utf8"!' .env
sed -i '26,28 d' .env

rm -rf .git compose*.yaml

symfony console make:user --is-entity --identity-property-name=email --with-password --no-interaction User
#symfony console make:controller --no-template BookController
#symfony console make:entity --with-uuid --no-interaction Book
symfony console lexik:jwt:generate-keypair
symfony console doctrine:migrations:diff --no-interaction
cd ..

chmod -R a+rw web
rsync -a web/ ./
rm -rf web
EOF

cat << EOF > ./.docker/backend/docker-init.sh
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
EOF

mkdir -p .docker/frontend
cat << EOF > ./.docker/frontend/Dockerfile
FROM node:22.3-alpine3.20
RUN apk --update --no-cache add bash

WORKDIR /var/www

ADD install.sh /home/
RUN chmod +x /home/install.sh

ADD docker-init.sh /home/
RUN chmod +x /home/docker-init.sh
CMD bash /home/docker-init.sh
EOF

cat << EOF > ./.docker/frontend/install.sh
#!/usr/bin/env bash

npx create-next-app --typescript --eslint --tailwind --use-npm --src-dir /var/www --import-alias "@/*" --app frontend <<< 'y'

npm install @mui/material-nextjs @emotion/cache @mui/x-data-grid
npm install axios swr
EOF

cat << EOF > ./.docker/frontend/docker-init.sh
#!/usr/bin/env bash

if [ ! -d "./src" ]; then
  . /home/install.sh
fi

npm install
npm run dev

tail -f /dev/null
EOF

cat << EOF > docker-compose.yml
services:
  backend:
    user: root
    build:
      context: .docker/backend
      dockerfile: Dockerfile
    depends_on:
      - database
    ports:
      - 8000:8000
    volumes:
      - ./backend:/var/www
    tty: true

  frontend:
    user: root
    build:
      context: .docker/frontend
      dockerfile: Dockerfile
    ports:
      - 3000:3000
    volumes:
      - ./frontend:/var/www
    tty: true

  database:
    image: postgres:16.3-alpine3.20
    environment:
      - 'POSTGRES_DB=mydatabase'
      - 'POSTGRES_PASSWORD=secret'
      - 'POSTGRES_USER=myuser'
    ports:
      - 5432:5432
    volumes:
      - database_data:/var/lib/postgresql/data:rw

volumes:
  database_data:
EOF

### Docker
docker compose up -d --build
docker logs demo-app-1

### Git
if [ -d ".git" ]; then
  echo "git exists"
  exit
fi

git init

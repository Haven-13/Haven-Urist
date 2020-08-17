FROM mariadb:latest

COPY migrate/* /docker-entrypoint-initdb.d/

ENV MYSQL_RANDOM_ROOT_PASSWORD=yes MYSQL_DATABASE=ah13 MYSQL_USER=gamelord MYSQL_PASSWORD=gamelord
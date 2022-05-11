FROM mariadb:10.7.3-focal

EXPOSE 3306

COPY tables.sql /docker-entrypoint-initdb.d/1_tables.sql
COPY users.sql /docker-entrypoint-initdb.d/2_users.sql
COPY inventory.sql /docker-entrypoint-initdb.d/3_inventory.sql
COPY custom.cnf /etc/mysql/conf.d/custom.cnf

RUN chmod 0444 /etc/mysql/conf.d/custom.cnf




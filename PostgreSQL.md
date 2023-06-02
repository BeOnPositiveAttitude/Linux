1. Ставим необходимые пакеты: `yum install postgresql-server postgresql-contrib -y`.
2. Выполняем первоначальную инициализацию: `postgresql-setup initdb`.
3. Стартуем сервис: `systemctl enable --now postgresql.service`.
4. Переключаемся в юзера postgres: `su - postgres`.
5. Переходим в оболочку: `psql`.
6. Создаем пользователя: `CREATE USER kodekloud_rin WITH PASSWORD 'B4zNgHA7Ya';`.
7. Создаем БД: `CREATE DATABASE kodekloud_db2;`.
8. Даем полные права юзеру на БД: `GRANT ALL PRIVILEGES ON DATABASE "kodekloud_db2" TO kodekloud_rin;`.
9. Редактируем конфиг: `vi /var/lib/pgsql/data/postgresql.conf`.
10. Рlisten_addresses = 'localhost'   

vi /var/lib/pgsql/data/pg_hba.conf 

psql -U kodekloud_rin -d kodekloud_db2 -h localhost

psql -U kodekloud_rin -d kodekloud_db2 -h localhost -W

1. Ставим необходимые пакеты: `yum install postgresql-server postgresql-contrib -y`.
2. Выполняем первоначальную инициализацию: `postgresql-setup initdb`.
3. Стартуем сервис: `systemctl enable --now postgresql.service`.
4. Переключаемся в юзера postgres: `su - postgres`.
5. Переходим в оболочку: `psql`.
6. Или одной командой: `sudo -u postgres psql`.
7. Создаем пользователя: `CREATE USER kodekloud_rin WITH PASSWORD 'B4zNgHA7Ya';`.
8. Создаем БД: `CREATE DATABASE kodekloud_db2;`.
9. Даем полные права юзеру на БД: `GRANT ALL PRIVILEGES ON DATABASE "kodekloud_db2" TO kodekloud_rin;`.
10. Выходим из оболочки: `\q`.
11. Редактируем конфиг: `vi /var/lib/pgsql/data/postgresql.conf`.
12. Раскомментируем опцию: `listen_addresses = 'localhost'`.
13. Редактируем конфиг: `vi /var/lib/pgsql/data/pg_hba.conf`.
14. Редактируем следующие опции:
```bash
local   all   all                  md5
host    all   all   127.0.0.1/32   md5
host    all   all   ::1/128        md5
```
15. При проблемах чекаем лог: `more /var/lib/pgsql/data/pg_log/postgresql-Fri.log`.
16. Проверяем подключение из под пользователя root: `psql -U kodekloud_rin -d kodekloud_db2 -h localhost -W`.

Установить RPM-пакет: `rpm -ivh telnet.rpm`.

Удалить RPM-пакет: `rpm -e telnet.rpm`.

Обновить RPM-пакет: `rpm -Uvh telnet.rpm`.

Запросить информацию о RPM-пакете из БД: `rpm -q telnet.rpm`.

Верифицировать RPM-пакет: `rpm -Vf telnet.rpm`.

Важно помнить, что менеджеров пакетов RPM не разрешает зависимости. Для этого на помощь приходит YUM.

Каталог с YUM-репозиториями: `/etc/yum.repos.d/`.
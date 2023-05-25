Установить RPM-пакет: `rpm -ivh telnet.rpm`.

Удалить RPM-пакет: `rpm -e telnet.rpm`.

Обновить RPM-пакет: `rpm -Uvh telnet.rpm`.

Запросить информацию о RPM-пакете из БД: `rpm -q telnet.rpm`.

Верифицировать RPM-пакет: `rpm -Vf telnet.rpm`.

Важно помнить, что менеджеров пакетов RPM не разрешает зависимости. Для этого на помощь приходит YUM.

Каталог с YUM-репозиториями: `/etc/yum.repos.d/`.

Создать локальный репозиторий на машине можно с помощью файла `/etc/yum.repos.d/my_local.repo`:

```bash
[epel_local]   #Repository ID, одно уникальное слово
name=epel_local   #Имя репозитория
baseurl=file:///packages/downloaded_rpms/   #Путь до локального каталога с пакетами, в данном случае это /packages/downloaded_rpms/
enabled=1   #Включен
gpgcheck=0
```

Проверить список репозиториев в системе: `yum repolist`.

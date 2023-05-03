Установить DEB-пакет: `dpkg -i telnet.deb`.

Удалить DEB-пакет: `dpkg -r telnet.deb`.

Смотреть краткое описание DEB-пакета: `dpkg -l telnet`.

Смотреть описание DEB-пакета: `dpkg -p <path to file>`.

Проверить установлен ли DEB-пакет в системе: `dpkg -s telnet`.

Важно помнить, что менеджеров пакетов DPKG не разрешает зависимости. Для этого на помощь приходит APT и APT-GET.

Каталог с APT-репозиториями: `/etc/apt/sources.list`.

Обновить информацию в репозитории: `apt update`.

Установить обновления для всех пакетов в системе: `apt upgrade`.

Редактировать репозиторий: `apt edit-sources`.

Установить пакет из репозитория: `apt install telnet`.

Удалить пакет из системы: `apt remove telnet`.

Искать пакет в репозитории: `apt search telnet`.

Смотреть список пакетов в репозитории: `apt list | grep telnet`.

Обновить только конкретный пакет: `sudo apt --only-upgrade install remmina`.

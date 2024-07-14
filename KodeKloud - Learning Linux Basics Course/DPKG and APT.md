### DPKG

Установить DEB-пакет: `dpkg -i telnet.deb`.

Удалить DEB-пакет: `dpkg -r telnet.deb`.

Смотреть краткое описание DEB-пакета: `dpkg -l telnet`.

Смотреть описание DEB-пакета: `dpkg -p <path to file>`.

Проверить установлен ли DEB-пакет в системе: `dpkg -s telnet`.

Список установленных пакетов: `dpkg-query -l | less`.

Посмотреть в каких каталогах расположены файлы установленного пакета: `dpkg --listfiles nginx`. Т.к. при установке например `nginx` также устанавливается зависимый пакет `nginx-core`, то можно посмотреть информацию и по нему: `dpkg --listfiles nginx-core`.

Более короткий вариант: `dpkg -L nginx`.

Либо наоборот, можно узнать название установленного пакета, передав путь до исполняемого файла: `dpkg --search /usr/sbin/nginx`.

Более короткий вариант: `dpkg -S /usr/sbin/nginx`.

### APT

Важно помнить, что менеджеров пакетов DPKG не разрешает зависимости. Для этого на помощь приходит APT и APT-GET.

Каталог с APT-репозиториями: `/etc/apt/sources.list`.

Рассмотрим пример строки из указанного файла: `deb http://ru.archive.ubuntu.com/ubuntu/ jammy main restricted`. Здесь `jammy` - кодовое имя дистрибутива, `main` означает пакеты, официально поддерживаемые командой Ubuntu. Также могут быть другие значения:

- `universe` - пакеты поддерживаемый энтузиастами и сообществом
- `multiverse` - пакеты находящиеся в "серой" зоне из-за юридических проблем или проблем с авторскими правами
- `restricted` - так называемое closed-source software, которое не дает нам доступ к исходному коду (например различные драйверы видеокарт, звуковых карт и т.д.)

Предположим нам нужно добавить новый third-party репозиторий, например Docker.

Скачиваем публичный ключ для дальнейшей валидации пакета: `curl https://download.docker.com/linux/ubuntu/gpg -o docker.key`.

Далее выполняем команду: `gpg --dearmor docker.key`. В текущем каталоге появится новый файл `docker.key.gpg`. Действие не требуется, видимо ключ на сайте Docker хранится уже в dearmored виде.

Перемещаем ключ в специальный каталог: `sudo mv docker.key /etc/apt/keyrings/`.

Далее создадим новый репозиторий. Но вместо того, чтобы добавлять новую запись в файл `/etc/apt/sources.list`, мы создадим новый файл в каталоге `/etc/apt/sources.list.d/docker.list`.

Содержимое нового файла: `deb [signed-by=/etc/apt/keyrings/docker.gpg.key] https://download.docker.com/linux/ubuntu jammy stable`.

В файле `/etc/apt/sources.list` в идеале должны содержаться записи только об исходных репозиториях Ubuntu. Соответственно, если в какой-то момент нам больше не нужен будет third-party репозиторий, мы просто удалим файл из каталога `/etc/apt/sources.list.d/`, вместо редактирования файла `/etc/apt/sources.list`.

Обновить информацию о пакетах в репозитории: `apt update`.

Установить найденные для пакетов обновления: `apt upgrade`.

Редактировать репозиторий: `apt edit-sources`.

Установить пакет из репозитория: `apt install nginx`.

Искать пакет в репозитории: `apt search nginx`. Будут найдены все пакеты, у которых слово `nginx` встречается либо в названии, либо в описании. Соответственно список будет большой.

Чтобы искать пакет только по имени: `apt search --names-only nginx`.

Искать пакет, у которого в названии/описании есть три указанные слова: `apt search nginx module image`.

Удалить пакет из системы: `apt remove nginx`. При этом удалится только основной пакет, зависимости останутся в системе.

Чтобы удалить и ненужные оставшиеся зависимые пакеты: `apt autoremove`.

Либо это можно сделать сразу в одну команду: `apt autoremove nginx`.

Альтернативный вариант: `sudo apt-get remove --auto-remove -y ziptool`.

Смотреть список пакетов в репозитории: `apt list | grep telnet`.

Обновить только конкретный пакет: `sudo apt --only-upgrade install remmina`.

Посмотреть информацию о пакете: `apt show libnginx-mod-stream`.

### Personal Package Archive - PPA

Добавить ppa-репозиторий: `sudo add-apt-repository ppa:john/mylatestapp`.

Смотреть список добавленных ppa-репозиториев: `add-apt-repository --list`.

Удалить добавленный ppa-репозиторий: `sudo add-apt-repository --remove ppa:john/mylatestapp`.
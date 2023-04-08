Файл /etc/passwd:

`john:x:1003:1003::/home/john:/bin/bash`

USERNAME:PASSWORD:UID:GID:GECOS:HOMEDIR:SHELL

- `john` - имя юзера
- `x` - означает что пароль хранится в /etc/shadow
- `1003` - UID
- `1003` - GID
- `::` - GECOS, поле для комментов (может быть пустое)
- `/home/john` - домашняя директория
- `/bin/bash` - дефолтный shell

Файл /etc/shadow:

`ayakhin:$6$yEfIUVQ2YQn0Ikzx$g70pOEdxxJQaeuYSfG5H3NEThHhdduDbayQsZn9Tgj7SuVnxEulJYSh.3nXtV9SmU.dtxdpPsef22kCP2X5iN.:19026:0:99999:7:::`

USERNAME:PASSWORD:LASTCHANGE:MINAGE:MAXAGE:WARN:INACTIVE:EXPDATE

- `empty` - PASSWORD, если поле пустое, значит пароль еще ни разу не задавался
- `19026` - LASTCHANGE, количество дней прошедших с 1 января 1970 года, когда последний раз меняли пароль
- `0` - MINAGE, минимальное количество дней, которые юзер должен выждать, чтобы повторно изменить пароль
- `99999` - MAXAGE, максимальное количество дней, по истечении которых, пароль нужно изменить
- `7` - WARN, за сколько дней до истечения срока действия пароля пользователь получит предупреждение о необходимости смены пароля
- `empty` - INACTIVE, через сколько дней после истечения пароля УЗ будет отключена
- `empty` - EXPDATE, количество дней прошедших с 1 января 1970 года, когда УЗ будет expired


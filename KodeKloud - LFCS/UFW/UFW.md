UFW - uncomplicated (несложный) firewall.

Смотреть запущен ли ufw: `sudo ufw status`.

Добавить новое правило, разрешающее ssh: `sudo ufw allow 22`. Будут разрешены и tcp и udp подключения.

Либо можно указать конкретно: `sudo ufs allow 22/tcp`.

Включить ufw: `sudo ufw enable`.

Смотреть расширенный статус: `sudo ufw status verbose`.

Разрешить подключения по ssh только с определенного IP-адреса: `sudo ufw allow from 192.168.1.60 to any port 22`. Здесь `any` означает разрешить подключение на любой IP-адрес на целевой машине, т.к. на нашем сервере может быть несколько сетевых интерфейсов.

Смотреть статус и приоритет правил: `sudo ufw status numbered`.

Новое правило будет добавлено в низ цепочки. Таким образом все равно будут разрешаться входящие подключения на 22 порт с любого IP-адреса.

```
Status: active

     To                         Action      From
     --                         ------      ----
[ 1] 22                         ALLOW IN    Anywhere
[ 2] 22                         ALLOW IN    192.168.1.60
[ 3] 22 (v6)                    ALLOW IN    Anywhere (v6)
```

Удалим первое правило: `sudo ufw delete 1`. Но при этом останется аналогичное правило для IPv6.

Можно удалить правило по его названию, а не по номеру: `sudo ufw delete allow 22`. Т.к. добавлялось правило командой `allow 22`, то таким же образом и удаляется.

Разрешить входящие ssh-подключения для диапазона IP-адресов: `sudo ufw allow from 10.11.12.0/24 to any port 22`.

Разрешить любые входящие подключения (на любой порт) для диапазона IP-адресов: `sudo ufw allow from 10.11.12.0/24`.

Запретить все подключения с определенного IP-адреса: `sudo ufw deny from 10.11.12.100`.

Однако новое запрещающее правило попадет в низ цепочки, и соответственно оно не сработает, т.к. выше есть разрешающее правило:

```
Status: active

     To                         Action      From
     --                         ------      ----
[ 1] 22                         ALLOW IN    192.168.1.60
[ 2] 22                         ALLOW IN    10.11.12.0/24
[ 3] Anywhere                   ALLOW IN    10.11.12.0/24
[ 4] Anywhere                   DENY IN     10.11.12.100
```

Удалим четвертое правило: `sudo ufw delete 4`.

И вставим правило в нужную нам позицию: `sudo ufw insert 3 deny from 10.11.12.100`.

Проверяем: `sudo ufw status numbered`.

```
Status: active

     To                         Action      From
     --                         ------      ----
[ 1] 22                         ALLOW IN    192.168.1.60
[ 2] 22                         ALLOW IN    10.11.12.0/24
[ 3] Anywhere                   DENY IN     10.11.12.100
[ 4] Anywhere                   ALLOW IN    10.11.12.0/24
```

Запретить исходящий трафик с определенного интерфейса на определенный IP-адрес: `sudo ufw deny out on enp0s3 to 8.8.8.8`.

Результат:

```
Status: active

     To                         Action      From
     --                         ------      ----
[ 1] 22                         ALLOW IN    192.168.1.60
[ 2] 22                         ALLOW IN    10.11.12.0/24
[ 3] Anywhere                   DENY IN     10.11.12.100
[ 4] Anywhere                   ALLOW IN    10.11.12.0/24
[ 5] 8.8.8.8                    DENY OUT    Anywhere on enp0s3         (out)
```

Разрешить входящие (`in`) соединения от машины с IP-адресом `192.168.1.60` к нашей машине, на определенный интерфейс (`enp0s3`), и на определенный IP-адрес (`192.168.1.81`) на этом интерфейсе:

`sudo ufw allow in on enp0s3 from 192.168.1.60 to 192.168.1.81 port 80 proto tcp`.

И разрешить исходящий (`out`) трафик в обратном направлении:

`sudo ufw allow out on enp0s3 from 192.168.1.81 to 192.168.1.60 port 80 proto tcp`.

Результат:

```
Status: active

     To                         Action      From
     --                         ------      ----
[ 1] 22                         ALLOW IN    192.168.1.60
[ 2] 22                         ALLOW IN    10.11.12.0/24
[ 3] Anywhere                   DENY IN     10.11.12.100
[ 4] Anywhere                   ALLOW IN    10.11.12.0/24
[ 5] 8.8.8.8                    DENY OUT    Anywhere on enp0s3         (out)
[ 6] 10.0.2.15 80/tcp on enp0s3 ALLOW IN    192.168.1.60
[ 7] 192.168.1.60 80/tcp        ALLOW OUT   192.168.1.81 on enp0s3     (out)
```
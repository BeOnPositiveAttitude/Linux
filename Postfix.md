Ставим пакет: `yum install postfix -y`.

Редактируем конфиг: `vi /etc/postfix/main.cf`.

```bash
myhostname = stmail01.example.com   #FQDN нашего хоста
mydomain = example.com
# Параметр myorigin указывает имя домена, которое используется в почте, отправляемой с этой машины 
myorigin = $mydomain
inet_interfaces = all
# Параметр mydestination указывает, для каких доменов почта будет доставляться локально вместо пересылки на другой хост. 
# По умолчанию, Postfix принимает почту только для локальной машины.
# ВАЖНО! Если Ваш хост является почтовым сервером для всего домена, Вам следует также включить $mydomain в mydestination.
mydestination = $myhostname, localhost.$mydomain, localhost, $mydomain
my_networks = 172.16.238.0/24, 127.0.0.0/8
home_mailbox = Maildir/
```

Включаем сервис: `systemctl enable --now postfix`.

Добавляем пользователя в систему: `useradd username`.

Задаем ему пароль: `passwd username`.

Подключаемся к хосту telnet-ом: `telnet stmail01 25`.

```bash
# EHLO — расширенное приветствие, которое позволит получить возможности почтового сервера
EHLO localhost
# Вводим адрес, от которого будем отправлять тестовое сообщение
mail from:user@example.com
# В ответ должны получить 250 2.1.0 Ok.
# Указываем на какой адрес отправляем тестовое сообщение:
rcpt to:user@example.com
# Вводим команду:
DATA
# Получим 354 End data with <CR><LF>.<CR><LF> — это означает, что можно вводить текст сообщения
test message
# Чтобы закончить, с новой строки ставим точку и нажимаем Enter:
.
# В ответ должны увидеть что-то подобное: 250 2.0.0 Ok: queued as B73E35232139, где последний код — идентификатор сообщения, присвоенный сервером. Сообщение отправлено.
quit
```

Переключаемся в созданного юзера: `su - username`.

Смотрим очередь писем: `mailq`.

Переходим в каталог `Maildir/` и видим внутри папку `new/`:

```bash
cd Maildir/
ls
cat new/1685177380.V1700057I52b0b4fM114681.stmail01.stratos.xfusioncorp.com 

Return-Path: <mariyam@stratos.xfusioncorp.com>
X-Original-To: mariyam@stratos.xfusioncorp.com
Delivered-To: mariyam@stratos.xfusioncorp.com
Received: from localohost (stmail01 [172.16.238.17])
        by stmail01.stratos.xfusioncorp.com (Postfix) with ESMTP id B73E35232139
        for <mariyam@stratos.xfusioncorp.com>; Sat, 27 May 2023 08:48:46 +0000 (UTC)
Message-Id: <20230527084856.B73E35232139@stmail01.stratos.xfusioncorp.com>
Date: Sat, 27 May 2023 08:48:46 +0000 (UTC)
From: mariyam@stratos.xfusioncorp.com

test message
```

Выходим: `exit`.

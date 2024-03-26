Создадим скрипт в каталоге `/usr/local/bin/myapp.sh`.

```bash
#!/bin/sh
echo "MyApp Started" | systemd-cat -t MyApp -p info
sleep 5
echo "MyApp Crashed" | systemd-cat -t MyApp -p err
```

`-t MyApp` - set syslog identifier (в логах journalctl будет видно имя приложения), `-p` - set priority value.

Делаем скрипт исполняемым: `sudo chmod a+x /usr/local/bin/myapp.sh`.

Смотреть мануал по созданию сервиса systemd: `man systemd.service`. Далее можем искать по словам `/OPTIONS` или `/EXAMPLES`.

Можно пойти более простым путем и скопировать уже готовый файл сервиса из каталога `/lib/systemd/system/`:

`sudo cp /lib/systemd/system/ssh.service /etc/systemd/system/myapp.service`.

Приведем его к такому виду:

```bash
[Unit]
Description=My Application
After=network.target auditd.service

[Service]
# здесь можно указать подготовительную таску перед запуском основной, например сканировать БД на ошибки перед ее запуском
ExecStartPre=echo "Systemd is preparing to start MyApp"
ExecStart=/usr/local/bin/myapp.sh
# как будет завершаться процесс при выполнении команды "systemctl stop service-name"
# "process" означает завершить только главный процесс, а потенциально возможные дочерние процессы при этом останутся висеть
# можно указать например "control-group" и тогда будут завершены все процессы,  созданные этим сервисом
KillMode=process
Restart=always
# Restart Delay
RestartSec=1
Type=simple

[Install]
WantedBy=multi-user.target
```

`network.target` - целая коллекция network-related сервисов.

Далее выполняем команду: `sudo systemctl daemon-reload`.

Запускаем сервис: `sudo systemctl start myapp.service`.
Создавать сервис нужно в директории: `/etc/systemd/system/project-mercury.service`.

```bash
[Unit]
Description=Python Django for Project Mercury
Documentation=http://wiki.caleston-dev.ca/mercury
After=postgresql.service                            #запускать наш сервис только когда поднялся postgresql.service

[Service]
ExecStart=/usr/bin/python3 manage.py runserver 0.0.0.0:8000
WorkingDirectory=/opt/caleston-code/mercuryProject/ #из какой директории будет выполняться команда выше
User=project_mercury                                #под каким пользователем запускать сервис
Restart=on-failure                                  #перезапускать сервис автоматически в случае сбоя
RestartSec=10                                       #сколько ждать в секундах перед попыткой перезапуска

[Install]                                           #секция отвечающая за автозапуск сервиса
WantedBy=graphical.target                           #запускать в graphical.target
```

После создания нового сервиса нужно выполнить команду: `systemctl daemon-reload`.
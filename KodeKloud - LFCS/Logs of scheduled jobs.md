Для включения логирования cron-задач в ОС Ubuntu нужно отредактировать файл `/etc/rsyslog.d/50-default.conf` и раскомментировать в нем строку `#cron.*`.

После этого перезапускаем службу: `sudo service rsyslog restart`.

После этого, если есть запланированные cron-задачи появится файл `/var/log/cron`.

Отфильтровать строки, относящиеся только к нашим задачам: `sudo grep CMD /var/log/cron`.

Отфильтровать сообщения, относящиеся к anacron-задачам: `sudo grep anacron /var/log/cron`.

Отфильтровать сообщения, относящиеся к определенной anacron-задаче: `sudo grep test_job /var/log/cron`.

Добавим в файл `/etc/anacrontab` следующую задачу:

```
1   10   test_job   /bin/echo "Testing anacron" | systemd-cat --identifier=test_job
```

Команда `systemd-cat --identifier=test_job` запишет лог в journalctl.

Смотреть логи демона atd: `sudo grep atd /var/log/cron`.

Также можно искать сообщения в `/var/log/messages` и `/var/log/syslog`.

Для приложений ротация логов настраивается в отдельных файлах, расположенных по пути `/etc/logrotate.d/`.

Например файл `/etc/logrotate.d/tomcat`:

```bash
/var/log/tomcat/*.log {   #означает ротировать все лог-файлы в указанной директории
    monthly   #ротировать раз в месяц
    rotate 3  #хранить последние 3 ротированных файла, остальные удалять
}
```

Запуск вручную: `logrotate -f /etc/logrotate.d/tomcat`.

Задание на автоматический запуск создается по умолчанию в файле `/etc/cron.daily/logrotate`. Идет запуск logrotate, который читает все файлы в директории `/etc/logrotate.d/` и выполняет для каждого из них ротацию.

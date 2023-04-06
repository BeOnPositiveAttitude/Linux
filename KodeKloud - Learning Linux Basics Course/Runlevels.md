Смотреть текущий runlevel: `runlevel`.

В процессе загрузки процесс init проверяет заданный runlevel и убеждается, что все программы, необходимые для нормального функционирования системы именно в этом runlevel, запущены. Например графический режим пользователя требует запуска display manager service. В то же время этот сервис не требуется для запуска системы в неграфическом режиме.

В systemd runlevels называются targets.

Смореть target по умолчанию: `ls -ltr /etc/systemd/system/default.target`.

- runlevel 0 => poweroff.target
- runlevel 1 => rescue.target
- runlevel 2 => multi-user.target
- runlevel 3 => multi-user.target
- runlevel 4 => multi-user.target
- runlevel 5 => graphical.target
- runlevel 6 => reboot.target
Для настройки SFTP делаем следующее.
1. Создаем пользователя: `useradd kareem`.
2. Задаем ему пароль: `passwd kareem`.
3. Создаем директорию: `mkdir -p /var/www/opt`.
4. Редактируем файл `/etc/ssh/sshd_config` и добавляем следующую секцию:
```bash
Subsystem   sftp   internal-sftp

Match User kareem
        ForceCommand internal-sftp
        PasswordAuthentication yes
        ChrootDirectory /var/www/opt
        PermitTunnel no
        AllowAgentForwarding no
        X11Forwarding no
        AllowTcpForwarding no
```
5. Перезапускаем службу: `systemctl reload sshd`.
6. Проверяем подключение командой: `sftp kareem@stapp01`.

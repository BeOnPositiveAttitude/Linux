Для настройки SFTP делаем следующее.
1. Создаем пользователя: `useradd kareem`.
2. Задаем ему пароль: `passwd kareem`.
3. Создаем директорию: `mkdir -p /var/www/opt`.
4. Необходимо, чтобы все каталоги пути имели права 755 и их владельцем был root.
```bash
chown root. /var/www
chmod -R 755 /var/www
```
5. Редактируем файл `/etc/ssh/sshd_config` и добавляем следующую секцию (обязательно в самый конец файла):
```bash
Subsystem   sftp   internal-sftp

Match User kareem
        ForceCommand internal-sftp   #использовать только sftp, встроенный в ssh
        PasswordAuthentication yes
        ChrootDirectory /var/www/opt
        PermitTunnel no
        AllowAgentForwarding no
        X11Forwarding no
        AllowTcpForwarding no
```
5. Перезапускаем службу: `systemctl reload sshd`.
6. Проверяем подключение командой: `sftp kareem@stapp01`.

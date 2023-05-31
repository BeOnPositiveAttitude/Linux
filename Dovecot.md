1. Ставим пакет: `yum install dovecot -y`.
2. Редактируем главный конфиг `vi /etc/dovecot/dovecot.conf`.
3. Указываем следующие протоколы: `protocols imap pop3 lmtp`.
4. Редактируем конфиг: `vi /etc/dovecot/conf.d/10-mail.conf`.
5. В нем редактируем опцию: `mail_location = maildir:~/Maildir`.
6. Редактируем конфиг: `vi /etc/dovecot/conf.d/10-auth.conf`:
```bash
disable_plaintext_auth = yes
auth_mechanisms = plain login
```
7. Редактируем конфиг: `vi /etc/dovecot/conf.d/10-master.conf`:
```bash
  unix_listener auth-userdb {
    #mode = 0666
    user = postfix
    group = postfix
  }
```
8. Включаем службу: `systemctl enable --now dovecot`.
9. Проверяем telnet-ом:
```bash
telnet stmail01 110
user ammar
pass mysuperpassword # В этом месте получаем ошибку auth error
retr 1
quit
```

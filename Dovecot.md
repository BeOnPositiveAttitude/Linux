yum install dovecot -y
vi /etc/dovecot/dovecot.conf
protocols imap pop3 lmtp 

vi /etc/dovecot/conf.d/10-mail.conf
mail_location = maildir:~/Maildir

vi /etc/dovecot/conf.d/10-auth.conf
disable_plaintext_auth = yes
auth_mechanisms = plain login

vi /etc/dovecot/conf.d/10-master.conf
  unix_listener auth-userdb {
    #mode = 0666
    user = postfix
    group = postfix
  }

systemctl enable --now dovecot

telnet stmail01 110
user ammar
pass mysuperpassword #auth error
retr 1
quit

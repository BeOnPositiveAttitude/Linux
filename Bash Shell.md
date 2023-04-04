Смотреть какой сейчас задан shell: `echo $SHELL`.

Сменить shell: `chsh`.

Задать переменную окружения на постоянной основе можно в файлах `~/.profile` или `~/.pam_environment`.

Добавить в PATH новый путь до какого-либо приложения: `export PATH=$PATH:/opt/obs/bin`.

Смотреть из чего формируется текущий prompt: `echo $PS1`.

Список возможных значений для формирования prompt:

```
\d :the date in "Weekday Month Date" format (e.g., "Tue May 26")
\e :an ASCII escape character(033)
\h :the hostname HQDN
\H :the complete hostname
\n :newline
\r :carriage return
\s :the name of the shell
\t :the current time in 24-hour HH:MM:SS format
\T :the current time in 12-hour HH:MM:SS format
\@ :the current time in 12-hour am/pm format
\A :the current time in 24-hour HH:MM format
\u :the username of the current user
\w :the current working directory, with $HOME abbreviated with a tilde
\W :the base name of the current working directory, with $HOME abbreviated with a tilde
\$ :if the effective UID is 0, a #, otherwise a $
```

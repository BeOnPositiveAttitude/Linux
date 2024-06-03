На ОС Ubuntu сначала отключаем сервис AppArmor: `sudo systemctl disable --now apparmor.service`.

Ставим необходимые пакеты: `sudo apt install selinux-basics auditd`.

Проверить включен ли SELinux: `sestatus`.

Включить SELinux: `sudo selinux-activate`.

При этом вносятся изменения в конфигурацию загрузчика `/etc/default/grub`:

```bash
GRUB_CMDLINE_LINUX=" security=selinux"
```

При этом в корне появляется файл `/.autorelabel`, который говорит системе, что нужно навесить на все файлы ОС метки SELinux.

Перезагружаем систему: `sudo systemctl reboot`.

Начнется процесс relabeling:

<img src="image-2.png" width="800" height="200"><br>

SELinux может работать в двух режимах - Permissive (разрешающий) и Enforcing.

В режиме Permissive ничего не запрещается, а только лишь логируется. Это своего рода режим, в котором SELinux обучается.

Посмотреть лог SELinux: `sudo audit2why --all | less`.

Рассмотрим например такую строку:

```
type=AVC msg=audit(1716488823.526:1068): avc:  denied  { execute_no_trans } for  pid=5357 comm="check-new-relea" path="/usr/bin/dpkg" dev="dm-0" ino=524574 scontext=system_u:system_r:sshd_t:s0-s0:c0.c1023 tcontext=system_u:object_r:dpkg_exec_t:s0 tclass=file permissive=1
        Was caused by:
                Missing type enforcement (TE) allow rule.

                You can use audit2allow to generate a loadable module to allow this access.
```

AVC - Access Vector Cache. Действие, которое было обнаружено в Permissive-режиме, в нормальном режиме будет запрещено. Процесс с меткой `sshd_t` попытался сделать что-то, что ему не разрешено.

Посмотрим какие процессы имеют метку `sshd_t`:

```bash
aidar@xubuntu-vm:~$ ps -eZ | grep sshd_t
system_u:system_r:sshd_t:s0-s0:c0.c1023 689 ?    00:00:00 sshd
system_u:system_r:sshd_t:s0-s0:c0.c1023 117652 ? 00:00:00 sshd
system_u:system_r:sshd_t:s0-s0:c0.c1023 117661 ? 00:00:00 sshd
system_u:system_r:sshd_t:s0-s0:c0.c1023 117683 ? 00:00:00 sshd
system_u:system_r:sshd_t:s0-s0:c0.c1023 117707 ? 00:00:00 sshd
```

Посмотрим какую метку имеет исполняемый файл `/usr/sbin/sshd`:

```bash
aidar@xubuntu-vm:~$ ls -Z /usr/sbin/sshd
system_u:object_r:sshd_exec_t:s0 /usr/sbin/sshd
```

Когда SELinux запускает что-либо с меткой `sshd_exec_t`, процесс перейдет в домен с меткой `sshd_t`.

Домен представляет собой некий "security bubble", содержащий внутри этот процесс, и позволяющий ему делать только то, что определено в рамках type `sshd_t`.

Type, примененный к конкретному процессу, решает какие правила ему "навязывать", поэтому это называется "type enforcement".

Таким образом, благодаря наличию у файла определенного label, SELinux понимает какие ограничения он должен применить к запускающемуся процессу.

На текущий момент процессы ограниченные доменом `sshd_t` не могут делать ничего. Если мы переведем SELinux в "Enforcing Mode", то не сможем залогиниться в систему по ssh.

Выполним команду: `sudo audit2allow --all -M mymodule`. Опция `--all` сообщает утилите, что нужно проверить все зафиксированные события. Опция `-M` сообщает утилите, что нужно сгенерировать так называемый модуль или "policy package". Это файл, который мы можем загрузить в SELinux для создания политики безопасности, разрешающей все зафиксированные ранее действия, `mymodule` - имя этого файла.

В итоге увидим следующее:

```
sudo audit2allow --all -M mymodule
******************** IMPORTANT ***********************
To make this policy package active, execute:

semodule -i mymodule.pp
```

Выполним команду `sudo semodule -i mymodule.pp`. Здесь опция `-i = install`.

Увидим ошибку-баг: `libsemanage.add_user: user sddm not in password file`, это нормально.

Будут сгенерированы два файла `mymodule.pp` (бинарый файл) и `mymodule.te` (можно открыть текстовым редактором). Здесь `pp = policy package`, а `te = type enforcement`.

В реальной практике нам нужно внимательно проанализировать файл `mymodule.te`, чтобы понять что именно будет разрешено, прежде чем применять эти правила к SELinux. При этом хорошо бы иметь под рукой документацию на SELinux.

Также хорошей практикой является создание отдельного policy package для каждого защищаемого объекта.

Рассмотрим для пример строку из файла `mymodule.te`:

```
allow sshd_t var_log_t:file { append create getattr ioctl open };
```

Это говорит SELinux, что процессу в домене `sshd_t` разрешено выполнять определенные действия с файлами, у которых есть метка `var_log_t`, например создавать, открывать и т.д.

Т.к. демон sshd пишет логи в файл `/var/log/auth.log`, то проверим метку на нем:

```bash
aidar@xubuntu-vm:~$ ls -lZ /var/log/auth.log
-rw-r-----. 1 syslog adm system_u:object_r:var_log_t:s0 118378 мая 30 15:45 /var/log/auth.log
```

Изменить контекст SELinux (в данном примере пользователя) можно командой: `sudo chcon -u unconfined_u /var/log/auth.log`. Здесь `chcon` означает "change context".

Изменить роль SELinux можно командой: `sudo chcon -r object_r /var/log/auth.log`.

Изменить type SELinux можно командой: `sudo chcon -t user_home_t /var/log/auth.log`.

В SELinux как правило мы работаем с сущностью type. Но кроме этого SELinux может "навязывать" ограничения, основываясь на пользователе, который пытается выполнить какое-либо действие, проверяя может ли пользователь "перейти" в определенную роль. Однако по умолчанию этого не происходит, т.к. при логине в ОС наш пользователь ассоциируется с пользователем SELinux под названием `unconfined_u`, у которого есть доступ практически ко всему.

При использовании команды `chcon` необходимо указывать действительные labels для пользователя, роли и type SELinux.

Смотреть labels пользователей SELinux: `seinfo -u`. Видимо аналог команды `sudo semanage user -l`.

```bash
aidar@xubuntu-vm:~$ seinfo -u

Users: 7
   root
   staff_u
   sysadm_u
   system_u
   unconfined_u
   user_u
   xdm
```

Смотреть labels для ролей SELinux: `seinfo -r`.

```bash
aidar@xubuntu-vm:~$ seinfo -r

Roles: 15
   auditadm_r
   dbadm_r
   guest_r
   logadm_r
   nx_server_r
   object_r
   secadm_r
   staff_r
   sysadm_r
   system_r
   unconfined_r
   user_r
   webadm_r
   xdm_r
   xguest_r
```

Смотреть labels для types SELinux: `seinfo -t`.

Выше мы умышленно повесили некорректные labels на файл `/var/log/auth.log`. Как теперь это исправить? Есть два варианта. Первый - посмотреть на labels у аналогичных файлов в каталоге `/var/log`. Например на labels файла `/var/log/syslog`.

Вместо того, чтобы вбивать вручную названия всех labels, мы можем сослаться (или иными словами скопировать labels) на "хороший" файл: `sudo chcon --reference=/var/log/syslog /var/log/auth.log`.

А как насчет новых файлов? Предположим у нас есть веб-сервер. Создадим каталог `sudo mkdir /var/www` и в нем создадим несколько файлов `sudo touch /var/www/{1..10}`.

При включенном SELinux наш веб-сервер (Apache либо Nginx) не смогут работать с этими файлами из-за отсутствия правильных labels.

```bash
aidar@xubuntu-vm:~$ ls -Z /var/www/1
unconfined_u:object_r:var_t:s0 /var/www/1
...
```

Как видно это слишком "общие" labels. К счастью в SELinux есть своего рода БД, которая указывает как должны быть промаркированы файлы в определенных директориях.

Выполним команду: `sudo restorecon -R /var/www`. Здесь `R = recursive`.

Проверим результат:

```bash
aidar@xubuntu-vm:~$ ls -Z /var/www/1
unconfined_u:object_r:httpd_sys_content_t:s0 /var/www/1
```

Важно понимать, что по умолчанию команда `restorecon` восстанавливает только label для type, а пользователь и роль не меняются. Предположим мы умышленно поменяли пользователя SELinux:

`sudo chcon -u staff_u /var/www/1`.

```bash
aidar@xubuntu-vm:~$ ls -Z /var/www/1
staff_u:object_r:httpd_sys_content_t:s0 /var/www/1
```

Если мы вновь выполним команду: `sudo restorecon -R /var/www`, то увидим, что пользователь не изменился.

```bash
aidar@xubuntu-vm:~$ ls -Z /var/www/1
staff_u:object_r:httpd_sys_content_t:s0 /var/www/1
```

Чтобы форсировать восстановление пользователя/роли нужно добавить флаг `-F`:

`sudo restorecon -F -R /var/www`

Результат:

```bash
aidar@xubuntu-vm:~$ ls -Z /var/www/1
system_u:object_r:httpd_sys_content_t:s0 /var/www/1
```

Видим, что пользователь поменялся на дефолтного пользователя SELinux для данной директории. Стоит отметить, что изменение labels с помощью команды `chcon` имеет некоторые недостатки. Если ФС когда-либо будет снова "перемаркирована" (relabeled), как это было при установке SELinux, то кастомные labels, установленные нами на файлах, могут быть потеряны. Поэтому, чтобы сохранить изменения в будущем, выполним это другим способом.

Например, нам нужно, чтобы файл `10`, всегда имел другую type label. Вместо использования `chcon`, мы можем выполнить следующую команду:

`sudo semanage fcontext --add --type var_log_t /var/www/10`

Данная команда добавляет `--add` новое дефолтное значение file context в БД SELinux для указанного файла, но не обновляет его!

Выполним команду: `sudo restorecon /var/www/10` и проверим результат:

```bash
aidar@xubuntu-vm:~$ ls -Z /var/www/10
system_u:object_r:var_log_t:s0 /var/www/10
```

Если требуется задать новый контекст для целого каталога, входящих в него подкаталогов и файлов , синтаксис команды становится несколько сложнее. На помощь приходит команда:

```bash
aidar@xubuntu-vm:~$ sudo semanage fcontext --list | grep "/var/www/uploads"
/var/www/uploads(/.*)?                             all files          system_u:object_r:httpd_cache_t:s0
```

В итоге получаем пример команды: `sudo semanage fcontext --add --type nfs_t "/nfs/shares(/.*)?"`.

Создадим указанный каталог: `sudo mkdir -p /nfs/shares` и посмотрим labels.

```bash
aidar@xubuntu-vm:~$ ls -Z /nfs/
unconfined_u:object_r:root_t:s0 shares
```

"Восстановим" labels: `sudo restorecon -R /nfs/` и снова посмотрим на labels.

```bash
aidar@xubuntu-vm:~$ ls -Z /nfs/
unconfined_u:object_r:nfs_t:s0 shares
```

Вместо определения сложных политик type enforcement, мы можем использовать так называемые "booleans", как будто мы щелкаем переключателем, разрешающим или запрещающим набор действий. Список поддерживаемых SELinux booleans можно посмотреть командой:

`sudo semanage boolean --list`

Рассмотрим пример-строку: `virt_use_nfs  (off  ,  off)  Determine whether confined virtual guests can use nfs file systems.`

Первый `off` означает текущее состояние - выключен, второй `off` означает значение по умолчанию.

Включить SELinux boolean: `sudo setsebool virt_use_nfs 1`.

Смотреть состояние определенного SELinux boolean: `getsebool virt_use_nfs`.

Другой аспект, который контролирует SELinux - на какой порт может "биндиться" определенный демон, чтобы слушать входящие подключения.

Посмотреть биндинг портов, разрешенных для каждого type можно командой: `sudo semanage port --list | grep ssh`.

Если мы хотим добавить дополнительный порт, например 2222: `sudo semanage port --add --type ssh_port_t --proto tcp 2222`.

Проверяем:

```bash
aidar@xubuntu-vm:~$ sudo semanage port --list | grep ssh
ssh_port_t                     tcp      2222, 22
```

Удалить порт из списка разрешенных: `sudo semanage port --delete --type ssh_port_t --proto tcp 2222`.

Перевести SELinux в "Enforcing Mode": `sudo setenforce 1`.

По умолчанию SELinux запрещает любые действия, поэтому если у нас нет необходимых разрешающих правил, то некоторые программы могут перестать работать.

Чтобы перевести SELinux в "Enforcing Mode" на постоянной основе, нужно отредактировать файл `/etc/selinux/config` и поменять строку `SELINUX=enforcing`.


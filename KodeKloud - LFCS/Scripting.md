Любой bash-скрипт начинается с *shebang*: `#!/bin/bash`.

```bash
#!/bin/bash
# Log the date and time the script was last executed
date >> /tmp/script.log
cat /proc/version >> /tmp/scipt.log
```

Смотреть список команд которые можно использовать в скриптах: `help`.

Смотреть справку по командам test/if: `help test` и `help if`.

```bash
#!/bin/bash

if test -f /tmp/archive.tar.gz; then
    mv /tmp/archive.tar.gz /tmp/archive.tar.gz.OLD
    tar acf /tmp/archive.tar.gz /etc/dnf/
else
    tar acf /tmp/archive.tar.gz /etc/dnf/
fi
```

Команда `test -f` проверяет существует ли файл по указанному пути. Если существует, то он переименовывается в OLD и создается новый архив.

```bash
#!/bin/bash

if grep -q '5' /etc/default/grub; then
    echo 'Grub has timeout of 5 seconds.'
else
    echo 'Grub DOES NOT have a timeout of 5 seconds.'
fi
```

Параметр `q = quiet` означает тихий режим, не выводить найденные совпадения на консоль.

В данном примере скрипт работает на основе exit code, 0 = успех, все что больше нуля = провал.

Пример скрипта, в котором можно посмотреть основные моменты в части синтаксиса: `cat /etc/cron.hourly/0anacron`.

Мой вариант решения задачи из KodeKloud Engineer:

```bash
#!/bin/bash

zip -r /backup/xfusioncorp_ecommerce.zip /var/www/html/ecommerce
# Передаем пароль через sshpass, опция StrictHostKeyChecking отключает проверку отпечатка хоста
sshpass -p "H@wk3y3" scp -o StrictHostKeyChecking=no /backup/xfusioncorp_ecommerce.zip clint@stbkp01:/backup
```

Однако более правильно было бы использовать не `sshpass`, а сгенерировать ssh-ключи и закинуть их на хост.

Выполняем `ssh-keygen` под пользователем `steve` на хосте `stapp02`.

Далее копируем созданный ключ `ssh-copy-id clint@stbkp01`, вводим пароля пользователя `clint`.

Таким образом мы копируем созданный под пользователем `steve` публичный ssh-ключ на удаленный хост в home-каталог пользователя `clint`.

Соответственно теперь мы можем запускать скрипт под пользователем `steve`, а в скрипте мы идем под пользователем `clint` по ssh.

В общем ssh-ключи не привязаны к конкретному пользователю.

```bash
#!/bin/bash

zip -r /backup/xfusioncorp_ecommerce.zip /var/www/html/ecommerce
scp /backup/xfusioncorp_ecommerce.zip clint@stbkp01:/backup
```
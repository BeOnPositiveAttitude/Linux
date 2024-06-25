Создать нового пользователя john: `sudo useradd john`.

При этом будет автоматически создана группа `john` и назначена пользователю в качестве primary group. Также будет создан домашний каталог `/home/john`, а shell-ом по умолчанию будет выбран `/bin/bash`. Файлы находящиеся в каталоге `/etc/skel` будут скопированы в домашний каталог пользователя.

В каталоге `/etc/skel` находятся файлы `.bash_logout`, `.bash_profile`, `.bashrc`.

Созданный таким образом аккаунт не будет иметь expiration date.

Посмотреть описанные выше настройки по умолчанию для создаваемых УЗ пользователей можно так:

```bash
aidar@xubuntu-vm:~$ useradd --defaults
GROUP=100
HOME=/home
INACTIVE=-1
EXPIRE=
SHELL=/bin/bash
SKEL=/etc/skel
CREATE_MAIL_SPOOL=no
```

Либо более короткая форма: `useradd -D`.

Кроме этого настройки по умолчанию для создания новых УЗ пользователей можно посмотреть в файле `/etc/login.defs`.

Задать пароль для созданного аккаунта: `sudo passwd john`.

Удалить пользователя john: `sudo userdel john`. При этому также будет удалена группа `john`, но home-каталог останется.

Удалить пользователя john и его home-каталог: `sudo userdel -r john`. Здесь `r = remove`.

Создать пользователя с указанием конкретного shell и home-каталога: `sudo useradd -s /bin/othershell -d /home/otherdirectory/ john`. Здесь `s = shell`, `d = home-dir`.

Создать пользователя с non-interactive shell: `sudo useradd -s /sbin/nologin jave`.

Создать пользователя с указанием конкретного uid: `sudo useradd -u 1100 smith`. Здесь `u = uid`. При этом созданная автоматически группа `smith` также получит id равный `1100`.

Посмотреть владельца и группу-владельца для файла или каталога в формате числового id можно так:

```bash
aidar@xubuntu-vm:~$ ls -ln /home
drwxr-x--- 24 1000 1000 4096 июн 23 09:41 aidar
```

Здесь `n = numeric`.

sudo useradd --system sysacc   #добавить системного юзера, id будет меньше 1000, хомяк не создается для системного юзера
sudo usermod -d /home/otherdirectory -m john   #d=home-dir, m=move-home, переименовать хомяк юзера john в /home/otherdirectory
sudo usermod -l jane john   #l=login, переименовать юзера john в jane
sudo usermod -s /bin/othershell jane   #s=shell, сменить шелл для юзера jane
sudo usermod -L jane   #L=lock, залочить аккаунт юзера
sudo usermod -U jane   #U=unlock, разлочить аккаунт юзера
sudo passwd -l user1   #залочить
sudo passwd -u user2   #разлочить
sudo usermod -e 2021-12-10 jane   #e=expiredate, YY-MM-DD, установить дату экспирации аккаунта
sudo usermod -e "" jane   #для удаления даты экспирации аккаунта мы посылаем пустую строку
sudo chage -d 0 jane   #d=lastday, при следующем логине юзера попросят сменить пароль, т.к. он устарел
sudo passwd -e david   #принудить юзера сменить пароль при следующем логине
sudo chage -d -1 jane   #для отмены экспирации пароля посылаем -1
sudo chage -M 30 jane   #M=maxdays, менять пароль каждые 30 дней для юзера jane
sudo chage -M -1 jane   #чтобы пароль никогда не протухал
sudo chage -l jane   #l=list, смотреть дату экспирации УЗ
sudo chage -W 2 jane   #W=warning-days, установить варнинг за два дня до истечения срока действия пароля
sudo useradd -p $(openssl passwd -1 examPassed) jane   #создать юзера и сразу задать пароль
sudo useradd -M john   #создать юзера без домашнего каталога

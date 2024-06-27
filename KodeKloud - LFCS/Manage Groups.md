Существует два типа групп - **Primary (или Login) Group** и **Secondary (или Supplementary Group)**.

Когда пользователь запускает программу, она выполняется под аккаунтом пользователя и его primary group. Или, иначе говоря, программа запускается с тем же набором привилегий, которыми обладают УЗ пользователя и его primary group.

Другой пример - когда пользователь создает файл, тот автоматически получает в качестве владельца аккаунт пользователя и его primary group.

Пользователь может иметь только одну primary group и множество secondary groups.

Создать группу: `sudo groupadd developers`.

Создать группу с определенным gid: `sudo groupadd -g 9875 developers`.

Добавить пользователя john в группу developers: `sudo gpasswd -a john developers`. Здесь `a = add`.

Либо альтернативный вариант: `sudo usermod -a -G developers john`.

Смотреть в каких группах состоит пользователь john: `groups john`.

```bash
aidar@xubuntu-vm:~$ groups aidar
aidar : aidar adm cdrom sudo dip plugdev lpadmin lxd sambashare
```

Первая группа после символа двоеточия - это primary group, все остальные группы - secondary groups.

Удалить пользователя john из группы developers: `sudo gpasswd -d john developers`. Здесь `d = delete`.

Изменить primary group для пользователя john: `sudo usermod -g testers john`. Здесь `g = gid`.

Если использовать параметр `G`, то будет изменена secondary group пользователя.

Переименовать группу "developers" в "programmers": `sudo groupmod -n programmers developers`. Здесь `n = new-name`.

Удалить группу: `sudo groupdel programmers`.

Если мы удаляем группу, которая является primary group для какого-либо пользователя, то получим ошибку.

Сначала нужно изменить primary group для этого пользователя и потом уже удалять группу.

Если же мы удаляем группу, которая является secondary group для какого-либо пользователя, все выполнится без ошибок.
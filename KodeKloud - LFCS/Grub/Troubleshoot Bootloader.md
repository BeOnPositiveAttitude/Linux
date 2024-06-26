Загружаемся с загрузочной флешки, выбираем пункт "Troubleshooting" => "Rescue a CentOS Stream system" => "Continue".

Монтируем корневую ФС: `chroot /mnt/sysroot`.

Сгенерировать конфиг-файл загрузчика для систем с BIOS: `grub2-mkconfig -o /boot/grub2/grub.cfg`.

Сгенерировать конфиг-файл загрузчика для систем с EFI: `grub2-mkconfig -o /boot/efi/EFI/centos/grub.cfg`.

Смотреть блочные устройства в системе: `lsblk`.

Установить загрузчик в первые секторы жесткого диска: `grub2-install /dev/sda`. Указывается диск целиком, а не номер партиции. Верно для систем с BIOS.

Для систем с EFI загрузчик ставится не в первые секторы диска, а в специальный раздел: `dnf reinstall grub2-efi grub2-efi-modules shim`.

Выйти из chroot: `exit`.

Настройки загрузчика: `vim /etc/default/grub`. Например таймаут отображения меню grub.

Из этого файла берутся настройки для генерации нового конфига загрузчика `/boot/grub2/grub.cfg` командой `grub2-mkconfig ...`

После изменения файла `/etc/default/grub` нужно сгенерировать заново конфиг `/boot/grub2/grub.cfg` соответствующей командой `grub2-mkconfig -o /boot/grub2/grub.cfg` и настройки применятся после перезагрузки.
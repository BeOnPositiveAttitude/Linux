### rsync

rsync = remote synchronization

rsync требует наличия ssh-демона на удаленном сервере.

Синхронизировать локальную папку с удаленной: `rsync -a Pictures/ aaron@9.9.9.9:/home/aaron/Pictures/`. Здесь `a = archive mode`.

При повторном запуске `rsync` только синхронизирует новые изменения, старые данные копироваться заново не будут.

Синхронизировать каталоги в обратном направлении, src = remote, dest = local: `rsync -a aaron@9.9.9.9:/home/aaron/Pictures/ Pictures/`.

Также можно синхронизировать две локальные директории: `rsync -a Pictures/ /Backups/Pictures/`.

### dd

Утилита `dd` используется для бекапирования целого диска или раздела, т.е. для создания его образа. При этом диск-источник должен быть отмонтирован перед началом создания образа, чтобы гарантировать неизменяемость данных.

Создать образ диска: `sudo dd if=/dev/vda of=diskimage.raw bs=1M status=progress`.

Здесь `if = input file`, `of = output file`, `bs = block size`, `status = progress, показывать прогресс выполнения`.

Записать созданный образ на диск: `sudo dd if=diskimage.raw of=/dev/vda bs=1M status=progress`.

Нельзя запускать утилиту `dd` на дисках виртуальных машин!!!
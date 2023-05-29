### Процесс переноса каталога с nginx с LVM-раздела на обычный

Проверяем статус службы: `systemctl status nginx`.

Останавливаем службу: `systemctl stop nginx`.

Переходим в каталог: `cd /etc`.

Архивируем каталог с nginx с сохранением всех permissions: `tar -pczvf /home/gt_prom/nginx.tar.gz nginx/`

Проверяем, что архив создался: `ls -l /home/gt_prom/nginx.tar.gz` и `tar -tf /home/gt_prom/nginx.tar.gz`.

Отмонтируем каталог с nginx (т.к. он находится на отдельном logical volume): `umount /etc/nginx/`.

Удаляем созданный ранее вручную каталог nginx: `rm -rf nginx/`.

Распаковываем созданный ранее архив с nginx: `tar --same-owner -xvf /home/gt_prom/nginx.tar.gz -C /etc`.

Проверяем: `ls -l /etc/nginx/`.

Запускаем службу: `systemctl start nginx`.

Проверяем ее статус: `systemctl status nginx`.

Удаляем LV, здесь data - имя VG, nginx - имя LV: `lvremove data/nginx`.

Удалеям VG: `vgremove data`.

Удаляем PV: `pvremove /dev/vdb`.

Существуют различные типы unit-ов - `service`, `socket`, `device`, `timer` и другие.

Смотреть справку: `man systemd.service`.

Service-unit описывает каким образом приложение запускается, перезапускается и т.д.

Смотреть содержимое service-unit для sshd: `systemctl cat sshd.service`.

Редактировать содержимое service-unit: `systemctl edit --full sshd.service`.

Вернуть содержимое service-unit к "заводским" настройкам: `systemctl revert sshd.service`.

Так как некоторые программы не умеют в `reload`, можно воспользоваться командой, которая сначала попытается сделать `reload` и, если он недоступен, то сделает `restart`:

`systemctl reload-or-restart sshd.service`

Проверить включен ли автозапуск сервиса: `systemctl is-enabled sshd.service`.

Добавить сервис в автозапуск и сразу же стартовать: `systemctl enable --now sshd.service`.

Отключить автозапуск и сразу же остановить службу: `systemctl disable --now sshd.service`.

Маскировать службу, это запрещает запуск службы и её добавление в автозапуск: `systemctl mask atd.service`.

Убрать маскирование: `systemctl unmask atd.service`.

Отобразить список всех service-units в системе: `sudo systemctl list-units --type service --all`.

Отобразить список только active units: `systemctl list-units`.

Смотреть определенное свойство сервиса: `systemctl show sshd --property=NeedDaemonReload`.

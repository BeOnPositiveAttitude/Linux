Смотреть текущие параметры ядра: `sudo sysctl -a`.

Имя параметра может начинаться например с `vm`, означает virtual memory.

Смотреть текущие параметры ядра в части виртуальной памяти: `sudo sysctl -a | grep vm`.

Временно изменить параметр ядра, действует до первой перезагрузки ОС: `sudo sysctl -w net.ipv6.conf.default.disable_ipv6=1`. Здесь `w = write-value-to-a-parameter`.

Смотреть значение определенного параметра ядра: `sudo sysctl net.ipv6.conf.default.disable_ipv6`.

Смотреть справку: `man sysctl.d`.

Чтобы изменить какой-либо параметр ядра на постоянной основе, нужно создать конфиг-файл в каталоге `/etc/sysctl.d/` с произвольным именем.

Например: `sudo vim /etc/sysctl.d/swap-less.conf` с содержимым `vm.swappiness=29`.

Немедленно применить новые параметры ядра из конфиг-файла: `sudo sysctl -p /etc/sysctl.d/swap-less.conf`.

Либо можно применить новые параметры ядра, перечитав все конфиг-файлы: `sudo sysctl -p`.

Отразить все параметры ядра, "грепнуть" по слову `cache` и далее записать в файл: `sudo sysctl -a | sudo bash -c 'grep cache > /opt/runtime.txt'`.

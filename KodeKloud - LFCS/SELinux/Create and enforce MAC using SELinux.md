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
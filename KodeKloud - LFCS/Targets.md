Смотреть таргет по умолчанию: `systemctl get-default`.

Задать новый таргет по умолчанию, нужна перезагрузка для применения: `sudo systemctl set-default multi-user.target`.

Временно переключиться на другой таргет, не требует перезагрузки: `sudo systemctl isolate graphical.target`.

Для восстановления/дебага системы можно воспользоваться:

- `sudo systemctl isolate emergency.target`
- `sudo systemctl isolate rescue.target`

Для загрузки системы в этих режимах нужно знать пароль пользователя `root`.
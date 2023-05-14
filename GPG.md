Сначала импортируем приватный и публичный ключи и проверяем, что импорт прошел успешно:

```bash
gpg --import public_key.asc
gpg --import private_key.asc
gpg --list-keys
gpg --list-secret-keys
```

Далее шифруем файл.

Мой вариант: `gpg --encrypt --output encrypted_me.asc --recipient kodekloud@kodekloud.com encrypt_me.txt`.

Либо то же самое, но короче: `gpg -e -o encrypted_me.asc -r kodekloud@kodekloud.com encrypt_me.txt`.

Здесь параметр `--output` задает имя итогового зашифрованного файла, `--recipient` берется из вывода команды по листингу ключей, в конце указано имя файла, который нужно зашифровать.

Вариант из лабы: `gpg --encrypt -r kodekloud@kodekloud.com --armor < encrypt_me.txt  -o encrypted_me.asc`

Здесь параметр `--armor` означает вывод в текстовом формате.

Далее расшифровываем другой файл.

Мой вариант: `gpg --decrypt --output decrypted_me.txt decrypt_me.asc`.

Либо то же самое, но короче: `gpg -d -o decrypted_me.txt decrypt_me.asc`.

Вариант из лабы: `gpg --decrypt decrypt_me.asc > decrypted_me.txt`.

Смотреть помощь по какой-либо команде openssl: `man openssl-req`.

Далее в открывшемся окне ищем примеры: `/EXAMPLES`.

Создать зашифрованный ключ и запрос на сертификат: `openssl req -newkey rsa:2048 -keyout key.pem -out req.pem`. Откроется диалоговое окно для ввода необходимых параметров. Затем запрос на сертификат должен быть передан в CA для подписи.

Если требуется создать самоподписанный сертификат: `openssl req -x509 -noenc -newkey rsa:4096 -days 365 -keyout myprivate.key -out mycertificate.crt`. Здесь опция `-noenc` означает не шифровать приватный ключ.

Далее смотрим созданные сертификат: `openssl x509 -in mycertificate.crt -text`.
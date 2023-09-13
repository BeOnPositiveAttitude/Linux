Вытащить сертификат для определенного домена из файла acme.json. Опция `-r` означает "output raw strings, not JSON texts", обязательна к использованию.

`cat acme.json | jq -r .'"letsencrypt-dns"."Certificates"[] | select(."domain"."main"=="auth.gos-tech.xyz") | ."certificate"' | base64 -d > acme.crt.pem`

Либо вариант с меньшим количеством кавычек для экспорта ключа: `cat acme.json | jq -r '."letsencrypt-dns".Certificates[] | select(.domain.main=="'auth.gos-tech.xyz'") | .key' | base64 -d`

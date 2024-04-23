Искать рекурсивно по всей папке: `grep -ir 'CentOS' /etc/`

- `r = recursive`
- `i = case-insensitive`

Искать строки в которых **нет** указанного слова: `grep -vi 'centos' /etc/os-release`, здесь `v = inVert-match`.

Искать именно заданное слово, но не составные слова, включающие это слово: `grep -wi 'name' /etc/os-release`, здесь `w = word-regexp, match only whole words`.

Пример:

```bash
aidar@xubuntu-vm:~$ grep -i 'name' /etc/os-release
PRETTY_NAME="Ubuntu 22.04.4 LTS"
NAME="Ubuntu"
VERSION_CODENAME=jammy
UBUNTU_CODENAME=jammy
```

```bash
aidar@xubuntu-vm:~$ grep -wi 'name' /etc/os-release
NAME="Ubuntu"
```

Отобразить только искомое слово, но не строки целиком, в которых оно встречается: `grep -oi 'centos' /etc/os-release`, здесь `o = only-matching`.

Пример:

```bash
aidar@xubuntu-vm:~$ grep -i 'name' /etc/os-release
PRETTY_NAME="Ubuntu 22.04.4 LTS"
NAME="Ubuntu"
VERSION_CODENAME=jammy
UBUNTU_CODENAME=jammy
```

```bash
aidar@xubuntu-vm:~$ grep -io name /etc/os-release
NAME
NAME
NAME
NAME
```

Искать строки начинающиеся на sam: `grep '^sam' names.txt`.

Искать строки заканчивающиеся на sam: `grep 'sam$' names.txt`.

Если нужно скомбинировать, то `^` указывается первым, а `$` последним.

Искать слова содержащие в себе cat, cut, c5t и т.д.: `grep -r 'c.t' /etc/`. Точка означает один символ, две точки - два символа и т.д.

Искать именно слова cat, cut, c5t и т.д., а не содержащие их составные слова, например execute: `grep -wr 'c.t' /etc/`.

Искать строки содержащие символ точки, экранируется обратным слэшом: `grep '\.' /etc/login.defs`.

Искать строки с вхождением le, let, lett и т.д.: `grep -r 'let*' /etc/`. Т.е. le тоже входит, `*` означает **0 и более раз**, применяется только к последнему символу.

Искать вхождения вида "/ноль или любое количество символов между двумя слэшами/": `grep -r '/.*/' /etc`.

Искать строки содержащие 0 **один и более раз**, то есть 0, 00, 000, символ `+` экранируется: `grep -r '0\+' /etc/`.

Посчитать число строк начинающихся на двойку: `grep -c '^2' textfile > /home/bob/count`.

Использовать расширенный grep, в котором нет нужды указывать обратный слэш: `grep -E = egrep`.

Искать строки содержащие 0 **один и более раз**, то есть 0, 00, 000: `grep -Er '0+' /etc/` или `egrep -r '0+' /etc/`.

Выполнить конвейер команд от рута, ищем строки начинающиеся с core и далее любое количество символов: `sudo bash -c  "grep -E \"^core.*\" /etc/services  >> /opt/coreservices.txt"`.

Искать строки с тремя и более подряд нулями: `egrep -r '0{3,}' /etc/`.

Искать строки содержащие от трех до пяти подряд нулей: `egrep -r '0{3,5}' /etc/`.

Искать строки с единицей и максимум тремя подряд нулями, возможно и ни одного нуля: `egrep -r '10{,3}' /etc/`.

Искать строки ровно с тремя подряд нулями: `egrep -r '0{3}' /etc/`.

Искать строки содержащие disabled, disable, `?` означает что символа может и не быть вовсе: `egrep -r 'disabled?' /etc/`.

Искать слова enabled или disabled: `egrep -r 'enabled|disabled' /etc/`.

Искать слова enabled, disabled, enable, disable: `egrep -r 'enabled?|disabled?' /etc/`.

Искать строки содержащие слова cat или cut: `egrep -r 'c[au]t' /etc/`.

Искать строки содержащие `/dev/`, далее любое количество символов: `egrep -r '/dev/.*' /etc/`.

Искать строки содержащие `/dev/`, далее любое количество символов от a до z: `egrep -r '/dev/[a-z]*' /etc/`.

Искать строки содержащие `/dev/`, далее любое количество символов от a до z и цифру от 0 до 9: `egrep -r '/dev/[a-z]*[0-9]' /etc/`.

Искать строки содержащие `/dev/`, далее любое количество символов от a до z и цифру от 0 до 9, либо цифры может и не быть: `egrep -r '/dev/[a-z]*[0-9]?' /etc/`.

Скобками можно задавать приоритет: `egrep -r '/dev/([a-z]*[0-9]?)*' /etc/`.

Большие или маленькие буквы: `egrep -r '/dev/(([a-z]|[A-Z])*[0-9]?)*' /etc/`.

Искать строки с http, но НЕ с https: `egrep -r 'http[^s]' /etc/`.

Искать строки содержащие `/` и не содержащие далее маленьких букв: `egrep -r '/[^a-z]' /etc/`.

Искать строки заканчивающиеся на цифру 3: `grep '3\>' /home/bob/shuffled.txt > /opt/filtered.txt`.

Отразит в результате поиска еще одну строку после строки Arsenal: `grep -A1 Arsenal premier-league-table.txt`.

Отразит в результате поиска еще одну строку перед строкой Arsenal: `grep -B1 Arsenal premier-league-table.txt`.

Отразит в результате поиска одну строку перед строкой Arsenal и строку после Arsenal, ну и сам Arsenal: `grep -A1 -B1 Arsenal premier-league-table.txt`.
Вывести содержимое файла в обратном порядке: `tac file1`.

Смотреть последние 20 строк файла: `tail -n 20 /var/log/dnf.log`.

Или более короткий вариант: `tail -20 /var/log/dnf.log`.

Смотреть первые 20 строк файла: `head -n 20 /var/log/dnf.log`.

Или более короткий вариант: `head -20 /var/log/dnf.log`.

### Sed - stream editor

Заменить все слова `canda` на слово `canada` в файле: `sed -i 's/canda/canada/g' userinfo.txt`.

Опции:
- `s = substitute`
- `g = global search and replace`
- `i = in-place`

Без опции `g` sed заменит только первое найденное вхождение на каждой строке. Поэтому если на одной строке будет несколько слов `canda`, sed заменит только первое. С опцией `g` sed заменит все найденные вхождения.

Без опции `i` sed только покажет будущий результат, но не изменит сам файл.

Нечувствительная к регистру замена: `sed -i 's/disabled/enabled/gi' values.conf`. Здесь `i = case insensitive`.

Заменить только с 500 по 2000 строку: `sed -i '500,2000s/enabled/disabled/g'values.conf`.

Экранировать все что между `'s~value1~value2~g'`, тут уже без прямых слэшей: `sed -i 's~#%$2jh//238720//31223~$2//23872031223~g' /home/bob/data.txt`.

Заменить только слово `to` целиком: `sed 's/\<to\>/from/g' BSD.txt > BSD_REPLACE.txt`. Т.е. если будет слово `contributor`, то не трогать.

Заменить только слово `band` целиком: `sed 's/\band\b/is/g' /home/BSD.txt`. Еще один вариант замены слова целиком.

Удалить строки с указанным словом: `sed '/software/d' BSD.txt > BSD_DELETE.txt`

### Cut

Оставить только первый столбец с именами из файла: `cut -d ' ' -f 1 userinfo.txt`.

Опции:
- `d = delimiter` - разделитель, в данном случае это пробел между словами
- `f = fields` - поля, которые мы хотим вытащить, в данном случае это первое слово на каждой строке

Вариант, когда в качестве разделителя используется запятая: `cut -d ',' -f 3 userinfo.txt > countries.txt`.

### Sort and Uniq

Удалить повторяющиеся друг за другом (важно!) строки: `uniq countries.txt`, если есть дубли вразнобой, то они останутся.

Отсортировать названия стран в алфавитном порядке: `sort countries.txt`.

Сначала отсортировать и затем удалить повторяющиеся дубли: `sort countries.txt | uniq`.

Сортировать и убрать дубли: `sort -duf values.txt`

Опции:
- `d = dictionary-order, consider only blanks and alphanumeric characters`
- `u = unique`
- `f = ignore-case, fold lower case to upper case characters`

### Diff

Сравнить два файла: `diff file1 file2`. Покажет только отличающиеся строки.

Сравнить два файла в более подробном режиме: `diff -c file1 file2`. Здесь опция `c = context.

Сравнить два файла в более удобном side-by-side режиме: `diff -y file1 file2` или `sdiff file1 file2`.

---
---

`cat query.log | awk '{ print $6 }' | sed 's/.\{6\}$//' | sort | uniq -c | sort`, здесь `awk` вырезает шестой столбец, `sed` удаляет последние 6 символов, сортирует.

`awk '{print $1}' access.log | sort | uniq -c | sort -r | head -1`, здесь `awk` вырезает первый столбец из лога, затем (важно!) нужно сначала отсортировать полученный список, затем уже uniq -c посчитает количество дублей, затем опять сортировка по убывающей и вывод максимального значения.

Записать строки в файл с помощью cat:

```bash
cat > myfile
string1
string2
string3
Ctrl+D
```

Найти в каталоге все текстовые файлы и для каждого из них (через `xargs`) посчитать (`grep -c`) количество вхождений слова "Alice":

```bash
find /home/admin/ -type f -name "*.txt" | xargs grep -c 'Alice'
/home/admin/agent/sadagent.txt:0
/home/admin/84-0.txt:0
/home/admin/11-0.txt:398
/home/admin/1342-0.txt:1
/home/admin/1661-0.txt:12
```

Команда `cat /proc/1/environ` возвращает длинную строку не разделенную пробелами или переносами:

`PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/binTERM=xtermcontainer=youlookedHOME=/rootHOSTNAME=ip-172-31-39-232`

Сделать красиво можно с помощью утилиты `tr` (translate). Заменим символ `\0` на перенос строки:

```bash
cat /proc/1/environ | tr "\0" "\n"

PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
TERM=xterm
container=youlooked
HOME=/root
HOSTNAME=ip-172-31-39-232
```

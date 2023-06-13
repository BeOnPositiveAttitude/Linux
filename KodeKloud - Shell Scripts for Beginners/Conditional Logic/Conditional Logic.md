```bash
mission_name=$1

mkdir $mission_name

rocket-add $mission_name

rocket-start-power $mission_name
rocket-internal-power $mission_name
rocket-start-sequence $mission_name
rocket-start-engine $mission_name
rocket-lift-off $mission_name

$rocket_status=$(rocket-status $mission_name)
```

В конце нашего скрипта мы выполняем команду `rocket-status`, чтобы протестировать статус выполнения скрипта. Эта команда возвращает статус ракеты, и он может быть следующим - launching, success, failed.

Если запуск провалился, то мы должны проверить почему. Для этого нужно запустить команду `rocket-debug`.

Таким образом теперь мы хотим запускать команду `rocket-debug` в конце нашего скрипта, но только если запуск ракеты провален. Если запуск ракеты упрошел успешно, то не нужно запускать команду `rocket-debug`.

Для этого нужно использовать выражение `if`:

```bash
mission_name=$1

mkdir $mission_name

rocket-add $mission_name

rocket-start-power $mission_name
rocket-internal-power $mission_name
rocket-start-sequence $mission_name
rocket-start-engine $mission_name
rocket-lift-off $mission_name

$rocket_status=$(rocket-status $mission_name)

if [ $rocket_status = "failed" ]
  rocket-debug $mission_name
elif [ $rocket_status = "success" ]   #второе условие будет проверено, только если первое не равно True
then
  echo "This is successful"
else                          #команда из блока else запустится, только если первые два условия не равны True
  echo "The state is not failed or success"
fi
```

Comparison statement указывается в квадратных скобках `[ STRING1 = STRING2 ]`, должен быть как минимум один пробел между скобками, оператором и значениями.

Оператор `[ "abc" = "abc" ]` используется только для сравнения строк, выполняется проверка на равенство строк.

Оператор `[ "abc" != "abc" ]` используется для проверки на неравенство строк.

Оператор `[ 5 -eq 5 ]` используется для сравнения чисел, выполняется проверка на равенство чисел.

Оператор `[ 5 -ne 5 ]` используется для проверки на равенство чисел.

Оператор `[ 6 -gt 5 ]` используется для проверки, что одно число больше другого.

Оператор `[ 5 -lt 6 ]` используется для проверки, что одно число меньше другого.

Также существует другой способ проверки условия. Он заключается в использовании двойных квадратных скобок `[[ STRING1 = STRING2 ]]`. Работает также как и описанный выше вариант с одинарными квадратными скобками, но поддерживает дополнительные операции, такие как matching patterns, использование выражений и т.д.

`[[ "abcd" = *bc* ]]` - проверяется, что строка `bc` содержится в строке `abcd`. Звездочки в начале и конце строки `*bc*` означают, что по обе стороны от нее может быть что угодно в первой строке `abcd`. Когда вы задаете pattern, то можно не использовать двойные ковычки, как в этом примере. Результат равен `True`.

`[[ "abc" = ab[cd] ]]` или `[[ "abd" = ab[cd] ]]` - проверяется, что строка `abc` удовлетворяет шаблону справа, первые два символа `ab`, а третий может быть `c` или `d`. Результат равен `True`.

`[[ "abe" = ab[cd] ]]` - результат равен `False`.

`[[ "abc" > "bcd" ]]` - это не символ больше, как мы могли ожидать. Сравнивается позиция строк, если бы они были отсортированы по алфавиту. `bcd` будет идти по алфавиту после `abc`. Соответственно `abc` будет иметь позицию равную 1, `bcd` позицию равную 2. 1 не больше 2, поэтому результат `False`.

`[[ "abc" < "bcd" ]]` - результат равен `True`.

`[ COND1 ] && [ COND2 ]` - логическое И, проверяется что оба условия верны.

`[ COND1 ] || [ COND2 ]` - логическое ИЛИ, проверяется что хотя бы одно условие верно.

Или расширенный формат записи: `[[ COND1 && COND2 ]]` и `[[ COND1 || COND2 ]]`.

Примеры: `[[ A -gt 4 && A -lt 10 ]]` и `[[ A -gt 4 || A -lt 10 ]]`.

Также существуют file-level операторы:
- `[ -e FILE ]` - проверяется, что файл существуют
- `[ -d FILE ]` - проверяется, что указанный путь существуют и является директорией
- `[ -s FILE ]` - проверяется, что файл существуют и его размер больше 0
- `[ -x FILE ]` - проверяется, что файл является исполняемым
- `[ -w FILE ]` - проверяется, что файл доступен для записи

Пример из лабы, проверка что директория существует:

```bash
if [ -d "/home/bob/caleston" ]
then
    echo "Directory exists"
else
    echo "Directory not found"
fi
```

Вернуть большее из двух чисел:

```bash
if [ $1 -gt $2 ]
then
    echo $1
else
    echo $2
fi
```

Develop a shell script that accepts the number of a month as input and prints the name of the respective month.

`./print-month-name.sh 1` should print `January` and `./print-month-name.sh 5` should print `May`.

Also keep these in mind:
- The script must accept a month number as a command line argument.
- If a month number is not provided as command line argument, the script must exit with the message `No month number given`.
- The script must not accept a value other than 1 to 12. If not the script must exit with the error `Invalid month number given`.
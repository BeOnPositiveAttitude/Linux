Наш текущий скрипт способен запустить только одну ракету.

```bash
mission_name=$1

mkdir $mission_name

rocket-add $mission_name

rocket-start-power $mission_name
rocket-internal-power $mission_name
rocket-start-sequence $mission_name
rocket-start-engine $mission_name
rocket-lift-off $mission_name

rocket_status=$(rocket-status $mission_name)

while [ $rocket_status = "launching" ]
do
  sleep 2
  rocket_status=$(rocket-status $mission_name)
done

if [ $rocket_status = "failed" ]
then
  rocket-debug $mission_name
  exit 1
fi
```

Но как быть, если мы хотим запускать дополнительные ракеты этим же скриптом без написания дополнительных скриптов? Нам придется дублировать все команды нашего скрипта для запуска дополнительной ракеты.

```bash
mission_name=$1

mkdir $mission_name

rocket-add $mission_name

rocket-start-power $mission_name
rocket-internal-power $mission_name
rocket-start-sequence $mission_name
rocket-start-engine $mission_name
rocket-lift-off $mission_name

rocket_status=$(rocket-status $mission_name)

while [ $rocket_status = "launching" ]
do
  sleep 2
  rocket_status=$(rocket-status $mission_name)
done

if [ $rocket_status = "failed" ]
then
  rocket-debug $mission_name
  exit 1
fi

mission_name=mars-mission

mkdir $mission_name

rocket-add $mission_name

rocket-start-power $mission_name
rocket-internal-power $mission_name
rocket-start-sequence $mission_name
rocket-start-engine $mission_name
rocket-lift-off $mission_name

rocket_status=$(rocket-status $mission_name)

while [ $rocket_status = "launching" ]
do
  sleep 2
  rocket_status=$(rocket-status $mission_name)
done

if [ $rocket_status = "failed" ]
then
  rocket-debug $mission_name
  exit 1
fi
```

Это не совсем аккуратный подход, т.к. теперь наш скрипт имеет дубли строк кода. В будушем, если мы изменим последовательность команд для запуска ракеты, то нужно будет внести изменения во все повторяющиеся блоки кода. А что если мы забудем внести изменения в одном из блоков? Скрипт станет неконсистентным.

При разработке best practice является не повторять строки кода. Нужно стремиться иметь один блок кода для одной функциональности. В нашем случае это функциональность для запуска ракеты от старта до финиша. Поэтому в идеале нам нужно иметь только один блок кода для этого.

Переместим наш блок кода в функцию. Функция в shell-скрипте - это блок кода, который выполняет определенный функционал и может быть переиспользован в теле скрипта. Теперь мы можем вызвать фунцию по имени и передать ей название миссии в качестве аргумента. Также это называется параметром функции.

```bash
function launch-rocket() {
  mission_name=$1

  mkdir $mission_name

  rocket-add $mission_name

  rocket-start-power $mission_name
  rocket-internal-power $mission_name
  rocket-start-sequence $mission_name
  rocket-start-engine $mission_name
  rocket-lift-off $mission_name

  rocket_status=$(rocket-status $mission_name)

  while [ $rocket_status = "launching" ]
  do
    sleep 2
    rocket_status=$(rocket-status $mission_name)
  done

  if [ $rocket_status = "failed" ]
  then
    rocket-debug $mission_name
    exit 1
  fi
}

launch-rocket lunar-mission
launch-rocket mars-mission
launch-rocket jupiter-mission
```

Теперь наш скрипт состоит из двух частей - определение функции (function definition) и собственно вызов функции (function call).

Функция в скрипте всегда должна быть объявлена до ее вызова!

Обратим внимание на выражение `exit 1` в теле функции. Если провалится запуск первой миссии `lunar-mission`, то скрипт будет завершен. Но мы не хотим этого. Нам нужно, чтобы скрипт продолжил выполнять запуск оставшихся ракет, не смотря на провал первой.

Поэтому нужно использовать выражение `return` вместо `exit`:

```bash
function launch-rocket() {
  mission_name=$1

  mkdir $mission_name

  rocket-add $mission_name

  rocket-start-power $mission_name
  rocket-internal-power $mission_name
  rocket-start-sequence $mission_name
  rocket-start-engine $mission_name
  rocket-lift-off $mission_name

  rocket_status=$(rocket-status $mission_name)

  while [ $rocket_status = "launching" ]
  do
    sleep 2
    rocket_status=$(rocket-status $mission_name)
  done

  if [ $rocket_status = "failed" ]
  then
    rocket-debug $mission_name
    return 1
  fi
}

launch-rocket lunar-mission
launch-rocket mars-mission
launch-rocket jupiter-mission
```

Выражение `return` определяет exit code для функции. Но при его использовании весь скрипт не будет завершен, только функция.

Return code каждого запуска функции может быть сохранен с помощью все той же встроенной переменной `$?`.

```bash
function launch-rocket() {
  mission_name=$1

  mkdir $mission_name

  rocket-add $mission_name

  rocket-start-power $mission_name
  rocket-internal-power $mission_name
  rocket-start-sequence $mission_name
  rocket-start-engine $mission_name
  rocket-lift-off $mission_name

  rocket_status=$(rocket-status $mission_name)

  while [ $rocket_status = "launching" ]
  do
    sleep 2
    rocket_status=$(rocket-status $mission_name)
  done

  if [ $rocket_status = "failed" ]
  then
    rocket-debug $mission_name
    return 1
  fi
}

launch-rocket lunar-mission
LUNAR_STATUS_CODE=$?
launch-rocket mars-mission
MARS_STATUS_CODE=$?
launch-rocket jupiter-mission
JUPITER_STATUS_CODE=$?
```

Когда мы должны использовать функции? Предположим вы работаете над сложной автоматизацией. Это большой скрипт или набор скриптов, которые выполняют различные задачи. Например установку пакетов, добавление пользователей, настройку firewall, некоторые математические операции. Каждая функциональность может быть написана как функции и легко вызвана в дальнейшем в нужной последовательности.

```bash
### Определяем функцию
function add() {
  $(( $1 + $2 ))
}

### Вызываем ее с параметрами комадной строки
add 3 5
```

Как в этом случае получить значение суммы чисел? Функция может быть рассмотрена как мини-скрипт в вашем основном скрипте. А вызов функции может быть рассмотрен как выполнение обычного скрипта в командной строке путем передачи аргументов.

Как получить результат работы скрипта и сохранить его в переменную? Нужно напечатать `echo` результат в скрипте и присвоить это значение переменной.

```bash
function add() {
  echo $(( $1 + $2 ))
}

sum=$( add 3 5 )
echo $sum
```

Однако важно помнить, все что будет напечатано в выводе функции будет присвоено переменной. Поэтому нужно с осторожностью использовать данных подход.

Другой подход заключается в использовании return code. Однако выражение `return` в shell работает не так как в других языках программирования, например C или Java. Выражение `return` используется только для возврата exit status. Кроме того вы можете вернуть только число, но не текст. Также в этом случае не получится "вытащить" результат путем присваивания вызова функции к переменной как в первом способе.

```bash
function add() {
  return $(( $1 + $2 ))
}

add 3 5
sum=$?
echo $sum
```

Best practices:
- Всегда разрабатывайте ваши скрипты модульным способом с использованием функций
- Старайтесь избегать дублирования кода
- Используйте аргументы комадной строки для передачи значений переменных функциям

Пример из лабы, переписанный с использованием функции скрипт-калькулятор:

```bash
#!/bin/bash

function read_numbers() {
  read -p "Enter Number1: " number1
  read -p "Enter Number2: " number2
}

while true
do
  echo "1. Add"
  echo "2. Subtract"
  echo "3. Multiply"
  echo "4. Divide"
  echo "5. Quit"

  read -p "Enter your choice: " choice

  case $choice in
    1)
        read_numbers
        echo Answer=$(( $number1 + $number2 ))
        ;;
    2)
        read_numbers
        echo Answer=$(( $number1 - $number2 ))
        ;;

    3)
        read_numbers
        echo Answer=$(( $number1 * $number2 ))
        ;;
    4)
        read_numbers
        echo Answer=$(( $number1 / $number2 ))
        ;;
    5)
        break
        ;;
  esac

done
```

Скрипт для запуска ракеты, переписанный с использованием функции:

```bash
function launch_rocket() {
  mission_name=$1

  mkdir $mission_name

  rocket-add $mission_name

  rocket-start-power $mission_name
  rocket-internal-power $mission_name
  rocket-start-sequence $mission_name
  rocket-start-engine $mission_name
  rocket-lift-off $mission_name

  rocket_status=$(rocket-status $mission_name)

  echo "The status of launch is $rocket_status"

  if [ $rocket_status = "launching" ]
  then
    sleep 2
    rocket_status=$(rocket-status $mission_name)
  fi

  if [ $rocket_status = "failed" ]
  then
    rocket-debug
    exit 1
  fi
}

launch_rocket $1
```
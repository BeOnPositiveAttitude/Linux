Теперь наш скрипт достаточно умен, чтобы выявлять причину провала запуска ракеты с помощью команды `rocket-debug`, в случае если статус запуска равен `failed`.

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

if [ $rocket_status = "failed" ]
then
  rocket-debug $mission_name
fi
```

Команда `rocket-status` может вернуть одну из трех стадий - `launching`, `success` или `failed`.

Ракета может оставаться в статусе `launching` некоторое время, до тех пор, пока он не изменится на `success` или `failed`.

На текущий момент наш скрипт написан таким образом, что статус проверяется только один раз, сразу после команды `rocket-lift-off`.

Однако существует вероятность, что ракета "застрянет" в статусе `launching` на продолжительное время, после которого станет `failed`. И так как мы проверяем статус ракеты только один раз, то нет гарантий, что мы сможем поймать все fail-ы при запусках.

Нам нужно, чтобы скрипт ждал некоторое время и после проверял статус. Если статус все еще `launching`, то мы хотим дальше проверять статус до тех пор, пока он не изменится на `success` или `failed`.

Для этого мы добавим новое условие перед выражением `if [ $rocket_status = "failed" ]`. Если ракета в статусе `launching`, то нужно подождать две секунды `sleep 2` и проверить статус снова.

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

if [ $rocket_status = "launching" ]
then
  sleep 2
  rocket_status=$(rocket-status $mission_name)

if [ $rocket_status = "failed" ]
then
  rocket-debug $mission_name
fi
```

Но как быть, если и спустя две секунды ракета все еще в статусе `launching`? Для этого мы снова используем conditional statement.

Это будет выражение `if` внутри выражения `if`:

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

if [ $rocket_status = "launching" ]
then
  sleep 2
  rocket_status=$(rocket-status $mission_name)
  if [ $rocket_status = "launching" ]
  then
    sleep 2
    rocket_status=$(rocket-status $mission_name)
  fi
fi

if [ $rocket_status = "failed" ]
then
  rocket-debug $mission_name
fi
```

В итоге таких `if` внутри `if` может набраться довольно много, если ракета запускается например 2 часа, и это не очень правильный подход. Правильнее использовать цикл `while`.

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
fi
```

Используйте цикл `while` в случаях, когда заранее неизвестно количество итераций.

Цикл `while` выполняется до тех пор, пока верно заданное условие.

Часто `while` используется для создания бесконечных циклов и программ с управляемым меню. Например:

```bash
while true
do
  echo "1. Shutdown"
  echo "2. Restart"
  echo "3. Exit menu"
  read -p "Enter your choice: " choice

  if [ $choice -eq 1 ]
  then
    shutdown now
  elif [ $choice -eq 2 ]
  then
    shutdown -r now
  elif [ $choice -eq 3 ]
  then
    break
  else
    continue
  fi
done
```

Выражение `break` может использоваться в циклах `for` и `while`. Оно прерывает выполнение цикла и выходит из него. Это полезно при работе с бесконечными циклами, как в примере выше.

Выражение `continue` в свою очередь возвращает выполнение цикла в его начало.

Задачи из лабы, простой калькулятор:

```bash
while true
do
  echo "1. Add"
  echo "2. Subtract"
  echo "3. Multiply"
  echo "4. Divide"
  echo "5. Quit"

  read -p "Enter your choice: " choice

  if [ $choice -eq 1 ]
  then
    read -p "Enter Number1: " num1
    read -p "Enter Number2: " num2
    echo Answer=$(( num1 + num2 ))

  elif [ $choice -eq 2 ]
  then
    read -p "Enter Number1: " num1
    read -p "Enter Number2: " num2
    echo Answer=$(( num1 - num2 ))

  elif [ $choice -eq 3 ]
  then
    read -p "Enter Number1: " num1
    read -p "Enter Number2: " num2
    echo Answer=$(( num1 * num2 ))

  elif [ $choice -eq 4 ]
  then
    read -p "Enter Number1: " num1
    read -p "Enter Number2: " num2
    echo Answer=$(( num1 / num2 ))

  elif [ $choice -eq 5 ]
  then
    break

  fi
done
```
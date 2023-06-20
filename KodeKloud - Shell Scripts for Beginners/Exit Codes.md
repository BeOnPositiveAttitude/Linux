Когда какая-либо команда запускается в Linux, то результатом ее работы будет либо успех либо fail.

Например команда `ls` вернет нам список файлов в текущем каталоге. А несуществуюшая команда `lss` вернет ошибку `command not found: lss`.

Кроме сообщения об ошибке на экране каждая команда также возвращает exit code или return code как его еще называют.

Так например команда `ls` вернет exit code равный 0. Вторая команда вернет exit code НЕ равный 0.

Если команда выполнилась успешно, то она вернет exit code равный 0.

Если команда выполнилась с ошибкой, то она вернет exit code больше 0.

Это же касается и нашей команды `rocket-status`. Она вернет exit code равный 0, если запуск ракеты успешен и exit code равный 1, если запуск провален.

Exit code хранится в специальной переменной `echo $?`. Таким образом можно узнать exit code команды, но только сразу после ее выполнения.

Хорошей практикой является использование exit codes в ваших скриптах.

Т.е. наш скипт должен возвращать exit code равный 0 в случае успешного выполнения и exit code равный 1 в случае провала.

В текущем виде даже в случае провала запуска ракеты он вернет exit code равный 0, т.к. мы просто проверяем причину фейла командой `rocket-debug` и не возвращаем какой-либо exit code.

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

Если вы явно не указываете exit code в вашем скрипте, то по умолчанию он будет равен 0.

Exit code задается с помощью выражения `exit`:

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
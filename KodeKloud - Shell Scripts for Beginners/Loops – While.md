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

$rocket_status=$(rocket-status $mission_name)

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
then
  rocket-debug $mission_name
fi
```
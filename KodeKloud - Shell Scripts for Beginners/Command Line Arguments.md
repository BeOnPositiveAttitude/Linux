Наш текущий скрипт нужно редактировать каждый раз, если нужно изменить значение переменной `$mission_name`. Это не очень удобно.

```bash
mission_name=lunar-mission

mkdir $mission_name

rocket-add $mission_name

rocket-start-power $mission_name
rocket-internal-power $mission_name
rocket-start-sequence $mission_name
rocket-start-engine $mission_name
rocket-lift-off $mission_name

rocket_status=$(rocket-status $mission_name)
echo "Status of launch: $rocket_status"
```

Удобнее было бы указывать название миссии непосредственно в командной строке при запуске скрипта, например так: `create-and-launch-rocket saturn-mission`. При таком способе нам бы не пришлось каждый раз редактировать скрипт.

Итак, мы будем указывать название миссии в командной строке. Но каким образом мы можем получить название миссии (указанное в командной строке) непосредственно из скрипта? В этом нам поможет набор встроенных переменных.

Команда, запущенная пользователем, делится на несколько частей, и каждая часть сохраняется в специальной встроенной переменной, начиная с номера 0.

Непосредственно сама команда `create-and-launch-rocket` доступна как `$0`.

Вторая часть нашей команды, в нашем случае название миссии, доступна как `$1`.

Соответственно, если бы у команды были еще аргументы, то они были бы доступны как `$2`, `$3`, `$4` и т.д.

Это называется аргументами командной строки.

Таким образом мы можем заменить захардкоженное название миссии в скрипте на встроенную переменную `$1`.

```bash
mission_name=$1

mkdir $mission_name

rocket-add $mission_name

rocket-start-power $mission_name
rocket-internal-power $mission_name
rocket-start-sequence $mission_name
rocket-start-engine $mission_name
rocket-lift-off $mission_name

rocket-status $mission_name

rocket_status=$(rocket-status $mission_name)
echo "Status of launch: $rocket_status"
```

Теперь мы можем запускать наш скрипт следующим способом: `create-and-launch-rocket jupiter-mission`. И в этом случае не нужно изменять само тело скрипта.

В данном случае мы присвоили одной переменной значение другой переменной `mission_name=$1`. Получается две переменные вместо одной. Действительно ли они нужны? Нет. Вот другая версия нашего скрипта:

```bash
mkdir $1

rocket-add $1

rocket-start-power $1
rocket-internal-power $1
rocket-start-sequence $1
rocket-start-engine $1
rocket-lift-off $1

rocket-status $1

rocket_status=$(rocket-status $1)
echo "Status of launch: $rocket_status"
```

Однако при таком подходе в будущем члены вашей команды могут не понять для чего нужна переменная `$1`. Поэтому рекомендуется придерживаться первоначального подхода и присваивать переменным понятные имена `mission_name=$1`.

Best practices:
- Всегда проектируйте ваш скрипт таким образом, чтобы его можно было переиспользовать
- Скрипт не должен требовать внесения изменений каждый раз перед его запуском
- Скрипт не должен содержать внутри захардкоженных переменных, используйте вместо этого аргументы командной строки
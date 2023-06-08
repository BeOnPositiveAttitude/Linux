Чтобы не "хардкодить" название миссии, стоит использовать переменные.

Название переменной содержит символ доллара в начале.

Название переменной может содержать только буквы, цифры и символ нижнего подчеркивания.

Например `mission_name` - это ОК, а `mission-name` - это НЕ ОК.

Кроме того имеет значение регистр в названии переменных, т.е. `mission_name` и `MISSION_NAME` - это разные переменные.

```bash
mission_name=lunar-mission

mkdir $mission_name

rocket-add $mission_name

rocket-start-power $mission_name
rocket-internal-power $mission_name
rocket-start-sequence $mission_name
rocket-start-engine $mission_name
rocket-lift-off $mission_name

rocket-status $mission_name
```

Также мы можем использовать переменные, чтобы сохранить output какой-либо команды.

```bash
mission_name=lunar-mission

mkdir $mission_name

rocket-add $mission_name

rocket-start-power $mission_name
rocket-internal-power $mission_name
rocket-start-sequence $mission_name
rocket-start-engine $mission_name
rocket-lift-off $mission_name

$rocket_status=$(rocket-status $mission_name)
echo "Status of launch: $rocket_status"
```

Best practices по именованию переменных:
- Используйте lower-case и символ нижнего подчеркивания для разделения слов в названии
Мы написал скрипт для легкого запуска ракеты под соответствующую миссию с помощью команды `create-and-launch-rocket lunar-mission`.

Теперь перед нами стоит задача запускать сотни ракет к различных планетам и звездам. Придется вводить одну и ту же команду сотни раз с различными названиями миссий.

```bash
create-and-launch-rocket lunar-mission
create-and-launch-rocket jupiter-mission
create-and-launch-rocket saturn-mission
create-and-launch-rocket satellite-mission
create-and-launch-rocket lunar-mission-2
create-and-launch-rocket mars-mission
create-and-launch-rocket earth-mission
```

Давайте попробуем автоматизировать этот процесс и разработаем другой скрипт. В этом нам поможет цикл `for`:

```bash
for mission in lunar-mission jupiter-mission saturn-mission satellite-mission lunar-mission-2 mars-mission earth-mission
do
  create-and-launch-rocket $mission
done
```

Ключевы слова `do` и `done` означают начало и конец цикла.

Однако, если названий миссий много, сотни и тысячи, тогда будет тяжело заносить их все в наш скрипт.

Вместо хард-кодинга названия миссий в нашем скрипте, мы можем прочитать эти названия из файла `mission-names.txt`.

```bash
for mission in `cat mission-names.txt`
do
  create-and-launch-rocket $mission
done
```

Теперь мы можем просто редактировать названия миссий в файле `mission-names.txt` и не трогать сам скрипт. Это считается одной из best practice. Всегда старайтесь разрабатывать ваши скрипты таким образом, чтобы в будущем для их запуска никому не пришлось вносить в них изменения. Весь input для скрипта должен передаваться через аргументы командной строки или через текстовый файл.

Другая best practice не использовать обратные ковычки при указании команд. Вместо этого используйте символ доллара и круглые скобки:

```bash
for mission in $(cat mission-names.txt)
do
  create-and-launch-rocket $mission
done
```

Предположим нам нужно сгенерировать сотню названий миссий в формате `mission-0, mission-1, ..., mission-100`.

```bash
for mission in {0..100}
do
  create-and-launch-rocket mission-$mission
done
```

Вариант в C-подобном стиле:

```bash
for (( mission = 0; mission <= 100; mission++ ))
do
  create-and-launch-rocket mission-$mission
done
```

Несколько примеров из реальной жизни с применением цикла `for`.

Посчитать количество строк в каждом файле в цикле:

```bash
for file in $(ls)
do
  echo Line count of $file is $(cat $file | wc -l)
done
```

Установить пакеты из списка:

```bash
for package in $(cat install-packages.txt)
do
  sudo apt-get install -y $package
done
```

Проверить uptime серверов по списку:

```bash
for server in $(cat servers.txt)
do
  ssh $server "uptime"
done
```
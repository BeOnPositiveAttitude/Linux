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

Примеры из лабы.

We have a few different applications running on this system. The list of applications are stored at `/tmp/assets/apps.txt` file. Each application has it's logs stored in `/var/log/apps` directory under a file with its name. Check it out!

A simple version of the script has been developed for you `/home/bob/count-requests.sh` that inspects the log file of an application and prints the number of GET, POST, and DELETE requests. Update the script to use a for loop to read the list of applications from the `apps.txt` file and count number of requests for each application and display it in a tabular format like this.

```bash
Log name GET POST DELETE
------------------------
Finance 10 20 50
Marketing 20 10 30
```

```bash
echo -e " Log name   \t      GET      \t      POST    \t   DELETE "
echo -e "------------------------------------------------------------"

for app in $(cat /tmp/assets/apps.txt)
do
  get_requests=$(cat /var/log/apps/${app}_app.log | grep "GET" | wc -l)
  post_requests=$(cat /var/log/apps/${app}_app.log | grep "POST" | wc -l)
  delete_requests=$(cat /var/log/apps/${app}_app.log | grep "DELETE" | wc -l)
  echo -e " ${app}    \t ${get_requests}    \t    ${post_requests}   \t   ${delete_requests}"
done
```

We have some images under the directory `/home/bob/images`. Develop a script `/home/bob/rename-images.sh` to rename all files within the images folder that has extension jpeg to jpg. A file with any other extension should remain the same.

Tip: Use a `for` loop to iterate over the files within `/home/bob/images`.
Tip: Use an `if` conditional to check if the file extension is jpeg.
Tip: Use `mv` to rename a file.

To replace jpeg to jpg in a filename use `echo user1.jpeg | sed 's/jpeg/jpg/g'`.

```bash
for image in $(ls /home/bob/images)
do
  if [[ $image = *.jpeg ]]
  then
    new_name=$(echo $image | sed 's/jpeg/jpg/g')
    mv images/$image images/$new_name
  fi
done
```
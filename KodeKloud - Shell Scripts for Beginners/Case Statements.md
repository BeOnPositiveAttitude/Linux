Вернемся к нашему скрипту с управляемым меню.

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

Множество выражений `if/elif` можно заменить на более компактный вариант с помощью выражения `case`:

```bash
while true
do
  echo "1. Shutdown"
  echo "2. Restart"
  echo "3. Exit menu"
  read -p "Enter your choice: " choice

  case $choice in
    1) shutdown now ;;
    2) shutdown -r now ;;
    3) break ;;
    *) continue ;;
  esac
done
```

Здесь значение переменной `$choice` сравнивается со значением или паттерном, указанным перед закрывающейся круглой скобкой.

Звездочка означает любой другой вариант, если не подошли первые три.

В конце каждой строки необходимо указывать двойные точку с запятой `;;`.

Или можно в таком виде:

```bash
while true
do
  echo "1. Shutdown"
  echo "2. Restart"
  echo "3. Exit menu"
  read -p "Enter your choice: " choice

  case $choice in
    1) shutdown now
       ;;
    2) shutdown -r now
       ;;
    3) break
       ;;
    *) continue
       ;;
  esac
done
```
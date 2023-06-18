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
    *) continue
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
  esac
done
```

Пример из лабы:

```bash
os=Fedora

case $os in
  "Fedora") echo "Uses RPM package manager" ;;
  "RHEL")   echo "Uses RPM package manager" ;;
  "CentOS") echo "Uses RPM package manager" ;;
  "Debian") echo "Uses DEB package manager" ;;
  "Ubuntu") echo "Uses DEB package manager"
esac
```

Скрипт с выводом названия месяца по его номеру с использованием `case` вместо `if`:

```bash
month_number=$1

if [ -z $month_number ]
then
  echo "No month number given. Please enter a month number as a command line argument."
  echo "eg: ./print-month-number 5"
  exit
fi

if [[ $month_number -lt 1 || $month_number -gt 12 ]]
then
  echo "Invalid month number given. Please enter a valid number - 1 to 12."
  exit
fi

case $month_number in
  1) echo "January" ;;
  2) echo "February" ;;
  3) echo "March" ;;
  4) echo "April" ;;
  5) echo "May" ;;
  6) echo "June" ;;
  7) echo "July" ;;
  8) echo "August" ;;
  9) echo "September" ;;
  10) echo "October" ;;
  11) echo "November" ;;
  12) echo "December"
esac
```

Скрипт калькулятор с использованием `case` вместо `if`:

```bash
while true
do
  echo "1. Add"
  echo "2. Subsctract"
  echo "3. Multiply"
  echo "4. Divide"
  echo "5. Average"
  echo "6. Quit"

  read -p "Enter your choice: " choice

  case $choice in
    1)
       read -p "Enter Number1: " number1
       read -p "Enter Number2: " number2
       echo Answer=$(( $number1 + $number2 ))
       ;;
    2)
       read -p "Enter Number1: " number1
       read -p "Enter Number2: " number2
       echo Answer=$(( $number1 - $number2 ))
       ;;
    3)
       read -p "Enter Number1: " number1
       read -p "Enter Number2: " number2
       echo Answer=$(( $number1 * $number2 ))
       ;;
    4)
       read -p "Enter Number1: " number1
       read -p "Enter Number2: " number2
       echo Answer=$(( $number1 / $number2 ))
       ;;
    5)
       read -p "Enter Number1: " number1
       read -p "Enter Number2: " number2
       sum=$(( number1 + number2 ))
       echo Answer=$(echo "$sum / 2" | bc -l)
       ;;
    6)
       break
  esac

done
```

```bash
color=$1
red=`tput setaf 1`
green=`tput setaf 2`
reset=`tput sgr0`

case $color in
    red) echo "${red}this is red${reset}" ;;
    green) echo "${green}this is green${reset}" ;;
    *) echo "red and green are the only choices"
esac
```
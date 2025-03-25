```shell
#!/bin/bash
# run this script with a few arguments
 
echo you have entered $# arguments

for i in $@
  do
    echo $i
  done

exit 0
```

- `$#` - это счетчик, который показывает, сколько аргументов было использовано при запуске скрипта
- `$@` - список всех аргументов, которые использовались при запуске скрипта

 В этом сценарии условие `for i in $@` означает "для каждого аргумента".
 
 Каждый раз, когда сценарий проходит цикл, значение из переменной `$@` присваивается переменной `$i`.

 ```shell
$ ./myscript.sh a b c d 
you have entered 4 arguments
a
b
c
d
```

```shell
$ ./myscript.sh a b c d e f g
you have entered 7 arguments
a
b
c
d
e
f
g
```

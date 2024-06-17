stdin: `<file1.txt`.

Перенаправить текст письма на вход команды sendemail: `sendemail someone@example.com < emailcontent.txt`.

stdout: `1>file1.txt` или `>file1.txt`.

stderr: `2>errors.txt`.

Перенаправить ошибки "в никуда": `grep -r '^The' /etc/ 2>/dev/null`.

Перенаправить stdout и stderr в разные файлы: `grep -r '^The' /etc/ 1>output.txt 2>errors.txt`.

Перенаправить stdout и stderr в разные файлы, с дозаписыванием в конец файлов: `grep -r '^The' /etc/ 1>>output.txt 2>>errors.txt`.

Перенаправить stdout и stderr в один и тот же файл, при этом важно соблюдать очередность: `grep -r '^The' /etc/ 1>all_output.txt 2>&1`.

Или: `grep -r '^The' /etc/ > all_output.txt 2>&1`. Здесь `2>&1` означает направить stderr в stdout.

```bash
sort <<EOF
> 6
> 5
> 4
> 3
> 2
> 1
> EOF
1
2
3
4
5
6
```

shell-калькулятор, передать входные данные для вычисления, полезно в скриптах: `bc <<<1+2+3+4`.

Искать строки НЕ начинающиеся с решетки, сортировать их в алфавитном порядке и далее выровнять по колонкам: `grep -v '^#' /etc/login.defs | sort | column -t`.

Записать в файл `shell.txt` строку `/bin/bash` и в отличие от обычного перенаправления вывода еще и вывести строку на экран: `echo $SHELL | tee shell.txt`.

Дозаписать строку в файл: `echo "This is the bash shell" | tee -a shell.txt`. Здесь `a = append`.
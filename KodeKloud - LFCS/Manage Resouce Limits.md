Ограничения на потребление ресурсов системы задаются в файле `/etc/security/limits.conf`.

- `<domain>`  - может быть указан пользователь в формате `jane` или группа в формате `@developers`, `*` означает всех пользователей системы
- `<type>` - может быть `hard`, пользователь не может его переопределить, это максимальное значение лимита, за которое нельзя выйти; `soft`, минимальное стартовое значение лимита, которое может быть увеличено до значения `hard` в случае необходимости; `-` означает и `hard` и `soft`
- `<item>` - может быть например `nproc` - максимальное число процессов в сессии пользователя, `fsize` - максимальный размер файла в Кб, который может быть создан в сессии пользователя, `cpu` - максимальное время CPU в минутах
- `<value>` - значение параметра

Лимит, указанный для определенного пользователя, переопределяет лимит, заданный через `*`.

Если процесс утилизирует 100% одного ядра CPU в течение одной секунды, то он использует 1 секунду процессорного времени.

Если процесс утилизирует 50% одного ядра CPU в течение одной секунды, то он использует 0,5 секунды процессорного времени.

Смотреть справку по возможным значениям: `man limits.conf`.

Для демонстрации зададим пользователю trinity лимит в файле `/etc/security/limits.conf`:

```bash
#<domain>      <type>  <item>         <value>

trinity        -       nproc          3
```

Залогинимся под пользователем trinity: `sudo -iu trinity`.

Выполним команду: `ps | less`.

```bash
    PID TTY          TIME CMD
 449294 pts/2    00:00:00 bash
 449480 pts/2    00:00:00 ps
 449481 pts/2    00:00:00 less
```

А теперь попробуем запустить суммарно четыре процесса: `ls -l | grep bash | less`.

```bash
-bash: fork: retry: Resource temporarily unavailable
-bash: fork: retry: Resource temporarily unavailable
```

Смотреть лимиты текущего пользователя: `ulimit -a`.

```bash
aidar@xubuntu-vm:~$ ulimit -a
real-time non-blocking time  (microseconds, -R) unlimited
core file size              (blocks, -c) 0
data seg size               (kbytes, -d) unlimited
scheduling priority                 (-e) 0
file size                   (blocks, -f) unlimited
pending signals                     (-i) 15309
max locked memory           (kbytes, -l) 500124
max memory size             (kbytes, -m) unlimited
open files                          (-n) 1048576
pipe size                (512 bytes, -p) 8
POSIX message queues         (bytes, -q) 819200
real-time priority                  (-r) 0
stack size                  (kbytes, -s) 8192
cpu time                   (seconds, -t) unlimited
max user processes                  (-u) 15309
virtual memory              (kbytes, -v) unlimited
file locks                          (-x) unlimited
```

Изменить значение определенного параметра (max user processes): `ulimit -u 5000`.

Обычный пользователь может только уменьшать лимит, не увеличивать.

Исключение составляют только hard и soft лимиты. Обычный пользователь может увеличить значение какого-либо параметра командой `ulimit`, но только один раз, и максимум до значения hard лимита. Повторно увеличивать нельзя, даже если значение hard лимита это позволяет, только уменьшать.
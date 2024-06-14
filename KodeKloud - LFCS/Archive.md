### tar

Смотреть содержимое архива: `tar -tf archive.tar` или `tar tf archive.tar`.

Создать архив из file1: `tar cf archive.tar file1`.

Добавить к уже существующему архиву `archive.tar` новый файл: `tar rf archive.tar file2`.

Создать архив можно с указанием относительного пути:

```bash
tar cf archive.tar LFCS-ssl-lesson/

tar tf archive.tar
LFCS-ssl-lesson/
LFCS-ssl-lesson/key.pem
LFCS-ssl-lesson/myprivate.key
LFCS-ssl-lesson/mycertificate.crt
LFCS-ssl-lesson/req.pem
```

А можно создать архив с указанием абсолютного пути:

```bash
tar cf archive.tar /home/aidar/Downloads/LFCS-ssl-lesson/
tar: Removing leading `/' from member names

tar tf archive.tar
home/aidar/Downloads/LFCS-ssl-lesson/
home/aidar/Downloads/LFCS-ssl-lesson/key.pem
home/aidar/Downloads/LFCS-ssl-lesson/myprivate.key
home/aidar/Downloads/LFCS-ssl-lesson/mycertificate.crt
home/aidar/Downloads/LFCS-ssl-lesson/req.pem
```

Как видим первый слэш `/` автоматически удаляется. Чтобы избежать этого, нужно добавить ключ `P`.

Здесь `P = absolute names, don't strip leading '/'s from file names`.

```bash
tar cfP archive.tar /home/aidar/Downloads/LFCS-ssl-lesson/

tar tf archive.tar
tar: Removing leading `/' from member names
/home/aidar/Downloads/LFCS-ssl-lesson/
/home/aidar/Downloads/LFCS-ssl-lesson/key.pem
/home/aidar/Downloads/LFCS-ssl-lesson/myprivate.key
/home/aidar/Downloads/LFCS-ssl-lesson/mycertificate.crt
/home/aidar/Downloads/LFCS-ssl-lesson/req.pem
```

Распаковать содержимое архива: `tar xf archive.tar`.

Распаковать содержимое архива в каталог /tmp: `tar xf archive.tar -C /tmp`.

### gzip, bzip2, xz

Создать gzip-архив: `gzip file1`. При этом исходный файл будет удален.

Создать gzip-архив и сохранить исходный файл: `gzip -k file2`. Здесь `k = keep`.

Создать bzip2-архив: `bzip2 file2`. При этом исходный файл будет удален.

Создать bzip2-архив и сохранить исходный файл: `bzip2 -k file2`. Здесь `k = keep`.

Создать xz-архив: `xz file3`. При этом исходный файл будет удален.

Создать xz-архив и сохранить исходный файл: `xz -k file2`. Здесь `k = keep`.

Распаковать gzip-архив и удалить исходный архив: `gunzip file1.gz`.

Распаковать gzip-архив и сохранить исходный архив: `gunzip -k file1.gz`. Здесь `k = keep`.

Распаковать bzip2-архив и удалить исходный архив: `bunzip2 file2.bz2`.

Распаковать bzip2-архив и сохранить исходный архив: `bunzip2 -k file2.bz2`.

Распаковать xz-архив и удалить исходный архив: `unxz file3.xz`.

Распаковать xz-архив и сохранить исходный архив: `unxz -k file3.xz`.

Просмотреть содержимое gzip-архива: `gzip -l file1.gz`. Здесь `l = list`.

Просмотреть содержимое xz-архива: `xz -l file3.xz`.

Создать zip-архив из файла: `zip archive.zip file1`.

Создать zip-архив из директории: `zip -r archive.zip Pictures/`. Здесь `r = recursively`.

Распаковать zip-архив: `unzip archive.zip`.

Распаковать zip-архив в определенную директорию: `unzip archive.zip -d /tmp/`.

**Важное замечание**! Утилиты gzip, bzip2, xz не умеют упаковывать несколько файлов или целую директорию с файлами в один архив, они работают только с одни файлом. Именно по этой причине эти утилиты используются в паре с утилитой `tar`.

Утилита zip в свою очередь умеет упаковывать  несколько файлов или целую директорию с файлами в один архив.

Объединяем tar и gzip для создания архива: `tar czf archive.tar.gz file1`.

Объединяем tar и bzip2 для создания архива: `tar cjf archive.tar.bz2 file1`.

Объединяем tar и xz для создания архива: `tar cJf archive.tar.xz file1`.

Автоматически выбрать формат архива на основании расширения файла: `tar caf archive.tar.gz file1`. Здесь `a = auto-compress`.

Распаковать архив: `tar xf archive.tar.gz`.


Смотреть содержимое текстового файла, находящегося в gzip-архиве, без его распаковки: `zcat file.txt.gz`.

Смотреть содержимое текстового файла, находящегося в bzip2-архиве, без его распаковки: `bzcat file.txt.bz2`.

Смотреть содержимое текстового файла, находящегося в xz-архиве, без его распаковки: `xzcat file.txt.xz`.

`cpio -idmv -D /`

Опции:
- `-i, --extract` - Extract files from an archive (run in copy-in mode)
- `-d, --make-directories` - Create leading directories where needed
- `-m, --preserve-modification-time` - Retain previous file modification times when creating files
- `-v, --verbose`
- `-D, --directory=DIR` - Change to directory DIR

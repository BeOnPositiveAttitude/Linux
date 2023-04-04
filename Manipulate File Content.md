tac file1   #аналог cat, только выведет содержимое файла в обратном порядке, line3, line2, line1
sed -i 's/canda/canada/g' userinfo.txt   #заменить все слова canda на слово canada, s=substitute, g=global search and replace, i=in-place
sed -i 's/disabled/enabled/gi' values.conf   #i=case insensitive
sed -i '500,2000s/enabled/disabled/g' values.conf   #заменить с 500 по 2000 строку
sed -i 's~#%$2jh//238720//31223~$2//23872031223~g' /home/bob/data.txt   #экранировать все что между 's~value1~value2~g', тут уже без прямых слэшей
# без опции g sed заменит только первое найденное на каждой строке вхождение, и если таковых на каждой строке будет несколько, остальные останутся без изменений
# без опции i sed только покажет будущий результат, но не изменить сам файл
cut -d ' ' -f 1 userinfo.txt   #оставит нам только первый столбец с именами из файла, d=delimiter, разделитель, в нашем случае это пробел между словами
# f=fields, поля которые мы хотим вытащить, в нашем случае это первое слово на каждой строке
uniq countries.txt   #удалить повторяющиеся друг за другом (важно!) строки, если есть дубли вразнобой, то они останутся
sort countries.txt   #отсортировать названия стран в алфавитном порядке
sort countries.txt | uniq    #сначала отсортировать и затем удалить повторяющиеся дубли
sort -duf values.txt   #d=dictionary-order, consider only blanks and alphanumeric characters, u=unique, сортировать и убрать дубли
# у команды sort есть еще опция f=ignore-case, fold lower case to upper case characters
diff file1 file2   #сравнить два файла
diff -c file1 file2   #сравнить два файла, c=context
sdiff file1 file2   #сравнить два файла, откроются в более удобном side-by-side формате
cat query.log | awk '{ print $6 }' | sed 's/.\{6\}$//' | sort | uniq -c | sort   #awk вырезат шестой столбец, sed удаляет последние 6 символов, сортирует

Записать строки в файл с помощью cat:

```bash
cat > myfile
string1
string2
string3
Ctrl+D
```
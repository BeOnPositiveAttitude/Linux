1. Ставим пакет: `yum install -y tomcat`.
2. Для конфигурации приложения редактируем файл: `/etc/tomcat/server.xml`. В нем меняем дефолтный порт 8080 на нужный нам: `<Connector port="8082" protocol="HTTP/1.1"`.
3. Стартуем сервис: `systemctl enable --now tomcat`.
4. Для деплоя .war-файла просто помещаем его в каталог `/usr/share/tomcat/webapps`, который на самом деле является символической ссылкой на `/var/lib/tomcat/webapps`.
```bash
[root@stapp03 ~]# ls -l /usr/share/tomcat
total 4
drwxr-xr-x 2 root root   4096 May 31 11:19 bin
lrwxrwxrwx 1 root tomcat   11 May 31 11:19 conf -> /etc/tomcat
lrwxrwxrwx 1 root tomcat   22 May 31 11:19 lib -> /usr/share/java/tomcat
lrwxrwxrwx 1 root tomcat   15 May 31 11:19 logs -> /var/log/tomcat
lrwxrwxrwx 1 root tomcat   22 May 31 11:19 temp -> /var/cache/tomcat/temp
lrwxrwxrwx 1 root tomcat   23 May 31 11:19 webapps -> /var/lib/tomcat/webapps
lrwxrwxrwx 1 root tomcat   22 May 31 11:19 work -> /var/cache/tomcat/work
```
5. Проверяем curl-ом, что приложение доступно по порту 8082.

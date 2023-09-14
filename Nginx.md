Установка на CentOS:

```bash
yum install epel-release -y
yum install nginx -y
```

Для настройки SSL раскомменчиваем соответствующую секцию в файле `/etc/nginx/nginx.conf`и указываем путь до сертификата и ключа:

```bash
    server {
        listen       443 ssl http2;
        listen       [::]:443 ssl http2;
        server_name  172.16.238.12;
        root         /usr/share/nginx/html;
        ssl_certificate "/etc/pki/CA/certs/nautilus.crt";
        ssl_certificate_key "/etc/pki/CA/private/nautilus.key";
        ssl_session_cache shared:SSL:1m;
        ssl_session_timeout  10m;
        ssl_ciphers HIGH:!aNULL:!MD5;
        ssl_prefer_server_ciphers on;
```

Файл `index.html` в каталоге `/usr/share/nginx/html` по умолчанию является ссылкой, можно ее удалить и сделать новый файл `index.html` с нужным содержимым.

Для настройки Nginx в качестве Reverse Proxy используем следующий конфиг:

```bash
server {
  listen 80;
  location / {
    proxy_pass http://my_server:3000;   #здесь указываем хост и порт, на который нужно проксировать запросы
  }
}
```

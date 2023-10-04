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

Для настройки Nginx в качестве LoadBalancer используем следующий минимальный конфиг:

```bash
user nginx;
worker_processes auto;
error_log /var/log/nginx/error.log;
pid /run/nginx.pid;

include /usr/share/nginx/modules/*.conf;

events {
    worker_connections 1024;
}

http {
    upstream backend {
        server stapp01:3003;
        server stapp02:3003;
        server stapp03:3003;
    }
    
    server {
        location / {
            proxy_pass http://backend;
        }
    }
}
```

Максимальная длина DNS-имени в секции `map{}`, по которому обращается клиент, для Nginx Openresty составляет 46 символов. Если сделать больше, получим ошибку: `could not build map_hash, you should increase map_hash_bucket_size: 64`.

Чтобы использовать более длинные имена нужно добавить в начало секции `stream{}` опцию `map_hash_bucket_size 128;`, а не как пишут в интернетах про добавление в секцию `http{}`.

Вероятно важно, чтобы указанная опция шла перед началом секции `map{}`.


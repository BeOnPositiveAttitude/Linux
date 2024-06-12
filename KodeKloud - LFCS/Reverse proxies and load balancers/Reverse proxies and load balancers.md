### Reverse Proxy

Пользователь обращается к Reverse Proxy, та в свою очередь запрашивает данные с веб-сервера. Веб-сервер возвращает данные Reverse Proxy, а она уже отдает контент пользователю.

<img src="image.png" width="700" height="150"><br>

Зачем вообще нужна Reverse Proxy? Предположим мы добавили в инфраструктуру новый более мощный веб-сервер. С помощью Reverse Proxy мы можем мгновенно переключить пользовательский трафик на новый веб-сервер.

Представим, что у нас бы не было Reverse Proxy. Тогда нам нужно было бы обновить DNS-запись для `example.com`, чтобы она указывала на IP-адрес нового веб-сервера.

*DNS propagation* - это процесс обновления кэша DNS-серверов по всему миру, который может занимать от нескольких минут до 72 часов.

Кроме того Reverse Proxy обладает и другими преимуществами - фильтрация веб-трафика, кэширование страниц для более быстрой отдачи контента пользователям и др.

### Load Balancing

Балансировка позволяет перенаправлять трафик сразу на несколько веб-серверов и динамически выбирать наиболее подходящий хост, например наименее загруженный (least busy).

<img src="image-1.png" width="700" height="350"><br>

### Nginx Reverse Proxy

Ставим nginx: `sudo apt install nginx`.

Создаем конфиг: `sudo vim /etc/nginx/sites-available/proxy.conf`.

```
server {
    listen 80;
    location / {
        proxy_pass http://1.1.1.1;
    }
}
```

<img src="image-2.png" width="700" height="170"><br>

<img src="image-3.png" width="700" height="150"><br>

Если целевой веб-сервер слушает на нестандартном порту, то его необходимо указать в конфиге:

```
server {
    listen 80;
    location / {
        proxy_pass http://1.1.1.1:8080;
    }
}
```

С точки зрения веб-сервера посетителем сайта будет являться Reverse Proxy. Предположим, мы хотим собирать статистику о реальных пользователях нашего веб-сайта, например их IP-адреса. Для этого внесем изменения в конфиг:

```
server {
    listen 80;
    location /images {
        proxy_pass http://1.1.1.1;
        include proxy_params;
    }
}
```

Содержимое файла `/etc/nginx/proxy_params`:

```
proxy_set_header Host $http_host;
proxy_set_header X-Real-IP $remote_addr;
proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
proxy_set_header X-Forwarded-Proto $scheme;
```

Создадим мягкую ссылку на конфиг для "включения" сайта: `ln -s /etc/nginx/sites-available/proxy.conf /etc/nginx/sites-enabled/proxy.conf`.

Удалим ссылку на дефолтный конфиг: `rm /etc/nginx/sites-enabled/default`.

Протестируем созданную конфигурацию: `sudo nginx -t`.

Перечитаем конфигурацию: `systemctl reload nginx`.

### Nginx Load Balancer

Удалим ссылку на предыдущий конфиг: `rm /etc/nginx/sites-enabled/proxy.conf`.

Создадим новый конфиг балансировщика: `sudo vim /etc/nginx/sites-available/lb.conf`.

```
upstream mywebservers {
    server 1.2.3.4;
    server 5.6.7.8;
}

server {
    listen 80;
    location / {
        proxy_pass http://mywebservers;
    }
}
```

По умолчанию используется алгоритм балансировки round-robin. Это подходит для небольших веб-сайтов, которые не обрабатывают гигантские объемы трафика. Для высоко нагруженных проектов лучше рассмотреть алгоритм, когда выбирается сервер с наименьшим количеством активных соединений -  `least_conn`.

```
upstream mywebservers {
    least_conn;
    server 1.2.3.4;
    server 5.6.7.8;
}

server {
    listen 80;
    location / {
        proxy_pass http://mywebservers;
    }
}
```

Рассмотрим случай, когда у нас есть несколько более мощных, чем остальные веб-серверов. В этом случае мы можем назначить на них "вес". По умолчанию параметр `weight=1`.

```
upstream mywebservers {
    least_conn;
    server 1.2.3.4 weight=3;
    server 5.6.7.8;
}

server {
    listen 80;
    location / {
        proxy_pass http://mywebservers;
    }
}
```

В данном примере из четырех пришедших на балансировщик запросов, три будут отправлены на хост с адресом `1.2.3.4`, и один на хост `5.6.7.8`.

В случае, когда нам нужно провести плановые/аварийные работы на одном из веб-серверов, мы можем перевести его в "maintenance mode" с помощью параметра `down`:

```
upstream mywebservers {
    least_conn;
    server 1.2.3.4 weight=3 down;
    server 5.6.7.8;
}

server {
    listen 80;
    location / {
        proxy_pass http://mywebservers;
    }
}
```

Также мы можем добавить backup веб-сервер, который будет неактивен, но включиться в работу, если выйдет из строя один из основных веб-серверов:

```
upstream mywebservers {
    least_conn;
    server 1.2.3.4:8081;
    server 5.6.7.8;
    server 10.20.30.40 backup;
}

server {
    listen 80;
    location / {
        proxy_pass http://mywebservers;
    }
}
```

Создадим мягкую ссылку на конфиг: `ln -s /etc/nginx/sites-available/lb.conf /etc/nginx/sites-enabled/lb.conf`.

Протестируем созданную конфигурацию: `sudo nginx -t`.

Перечитаем конфигурацию: `systemctl reload nginx`.
Установить iptables на Ubuntu: `sudo apt install iptables`.

Смотреть правила iptables: `iptables -L`.

```bash
Chain INPUT (policy ACCEPT)
target     prot opt source               destination

Chain FORWARD (policy ACCEPT)
target     prot opt source               destination

Chain OUTPUT (policy ACCEPT)
target     prot opt source               destination
```

- Chain INPUT - входящий трафик, например чтобы разрешить входящие ssh-подключения, нужно создать здесь правило
- Chain OUTPUT - исходящий трафик, подключения инициированные хостом к другим системам
- Chain FORWARD - обычно используется маршрутизаторами, когда данные перенаправляются другим устройствам в сети

Политика по умолчанию ACCEPT разрешает любой входящий и исходящий трафик.

Каждая цепочка (chain) имеет несколько правил внутри. Chain of rules.

Каждое правило осуществляет проверку и принимает или отбрасывает пакет, основываясь на условии.

<img src="screen1.png" width="600" height="200"><br>


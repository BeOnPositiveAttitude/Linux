### Bridge

Предположим у нас есть сервер с двумя интерфейсами, подключенными к разным сетям. Мы можем объединить два интерфейса в мост (bridge), чтобы хосты из разных сетей могли взаимодействовать друг с другом. Например Server1 таким образом сможет достучаться до Server8.

Мост в Linux позволяет объединить две сети вместе, равно как настоящий мост соединяет два куска суши.

Фактически с помощью моста можно объединить и более двух сетей.

<img src="image.png" width="800" height="400"><br>

Скопируем пример bridge-конфига: `sudo cp /usr/share/doc/netplan/examples/bridge.yaml /etc/netplan/99-bridge.yaml`.

Отредактируем конфиг:

```yaml
network:
  version: 2
  renderer: networkd
  ethernets:
    enp0s3:
      dhcp4: no
    enp0s8:
      dhcp4: no
  bridges:
    br0:
      dhcp4: yes
      interfaces:
        - enp0s3
        - enp0s8
```

Применим: `sudo netplan try`.

Удалить интерфейс: `sudo ip link delete br0`.

Плюс удаляем соответствующий конфиг из каталога `/etc/netplan`.

### Bonding

<img src="image-1.png" width="400" height="300"><br>

- Mode 0 - "round-robin", интерфейсы используются поочередно
- Mode 1 - "active-backup", активен только один интерфейс
- Mode 2 - "XOR", выбор на основе source и destination пакета, для каждой пары source и destination всегда используется один и тот же интерфейс
- Mode 3 - "broadcast", данные отправляются одновременно через оба интерфейса
- Mode 4 - "IEEE 802.3ad" - повышает производительность передачи трафика по сравнению с использованием одного интерфейса
- Mode 5 - "adaptive transmit load balancing" - данные отправляются через наименее загруженный интерфейс бонда
- Mode 6 - "adaptive load balancing" - попытка балансировать и входящий и исходящий трафик

Скопируем пример bond-конфига: `sudo cp /usr/share/doc/netplan/examples/bonding.yaml /etc/netplan/99-bond.yaml`

Отредактируем:

```yaml
network:
  version: 2
  renderer: networkd
  ethernets:
    enp0s3:
      dhcp4: no
    enp0s8:
      dhcp4: no
  bonds:
    bond0:
      dhcp4: yes
      interfaces:
        - enp0s3
        - enp0s8
      parameters:
        mode: active-backup
        primary: enp0s3
```

Применяем конфигурацию: `sudo netplan apply`. Команда `try` в данном случае не пройдет.

Перезагружаем ВМ.

Смотреть настройки бонда: `sudo cat /proc/net/bonding/bond0`.
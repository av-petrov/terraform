# Организация VPN в Yandex Cloud

### Цель сервиса
Использование VPN по мере необходимости, оплачивая минимально необходимую стоимость ресурсов. ВМ разворачивается из заранее сохранённого образа, который включает уже настроенный конфиг wireguard с предустановленной парой ключей. После поднятия регистрирует запись в DNS, которая используется конечными клиентами как точка подключения. Время развертывания - не более 5 минут.

Стоимость:
- 36 рублей в месяц за зону DNS
- 3.11*5 рублей в месяц за хранения образа

Требования:
- Наличие делегированной в Yandex Cloud зоны DNS
- Наличие заранее собранного образа с конфигурацией wireguard

Настроить VM:
```
export YC_TOKEN=$(yc iam create-token)
export YC_CLOUD_ID=$(yc config get cloud-id)
cp terraform.tfvars.example terraform.tfvars
# add to terraform.tfvars actual values
cp user-data.txt.example user-data.txt
# add to user-data.txt actual values
terraform validate
```

Запустить VM:
```bash
terraform plan
terraform apply
```

Удалить VM:
```bash
terraform destroy
```

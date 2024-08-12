#!/bin/bash

# Проверка на root-права
if [ "$EUID" -ne 0 ]; then
  echo "Пожалуйста, запустите скрипт с правами суперпользователя."
  exit 1
fi

# Обновление списка пакетов и обновление установленных пакетов
apt-get update -y
apt-get upgrade -y

# Установка curl, если не установлен
if ! command -v curl &> /dev/null; then
    echo "curl не установлен, устанавливаем..."
    apt-get install curl -y
fi

# Установка nginx-ui
echo "Устанавливаем nginx-ui..."
bash <(curl -L -s https://raw.githubusercontent.com/0xJacky/nginx-ui/master/install.sh) install

# Установка webmin
echo "Устанавливаем webmin..."
curl -o setup-repos.sh https://raw.githubusercontent.com/webmin/webmin/master/setup-repos.sh
sudo sh setup-repos.sh

# Очистка
rm -f setup-repos.sh

echo "Установка завершена!"

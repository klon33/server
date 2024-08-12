#!/bin/bash

# Проверка на root-права
if [ "$EUID" -ne 0 ]; then
  echo -e "\e[31mПожалуйста, запустите скрипт с правами суперпользователя.\e[0m"
  exit 1
fi

# Обновление списка пакетов и обновление установленных пакетов
echo -e "\e[32mОбновление списка пакетов и установленных пакетов...\e[0m"
apt-get update -y
apt-get upgrade -y

# Установка curl, если не установлен
if ! command -v curl &> /dev/null; then
    echo -e "\e[33mcurl не установлен, устанавливаем...\e[0m"
    apt-get install curl -y
fi

# Установка nginx-ui
echo -e "\e[32mУстанавливаем nginx-ui...\e[0m"
bash <(curl -L -s https://raw.githubusercontent.com/0xJacky/nginx-ui/master/install.sh) install

# Установка webmin
echo -e "\e[32mУстанавливаем webmin...\e[0m"
curl -o setup-repos.sh https://raw.githubusercontent.com/webmin/webmin/master/setup-repos.sh
sudo sh setup-repos.sh

# Очистка
echo -e "\e[34mОчистка временных файлов...\e[0m"
rm -f setup-repos.sh

echo -e "\e[32mУстановка завершена!\e[0m"

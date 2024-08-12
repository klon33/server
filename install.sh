#!/bin/bash

# Установка программ и первичная настройка ubuntu 24

# Проверка на root-права
if [ "$EUID" -ne 0 ]; then
  echo -e "\e[31mПожалуйста, запустите скрипт с правами суперпользователя.\e[0m"
  exit 1
fi

echo "" # Пробел для разделения

# Обновление списка пакетов и обновление установленных пакетов
echo -e "\e[32mОбновление списка пакетов и установленных пакетов...\e[0m"
apt-get update -y
apt-get upgrade -y

echo "" # Пробел для разделения

# Установка curl, если не установлен
if ! command -v curl &> /dev/null; then
    echo -e "\e[33mcurl не установлен, устанавливаем...\e[0m"
    apt-get install curl -y
fi

echo "" # Пробел для разделения

# Установка Speedtest
echo -e "\e[32mУстанавливаем Speedtest...\e[0m"
curl -s https://packagecloud.io/install/repositories/ookla/speedtest-cli/script.deb.sh | sudo bash
sudo apt-get install speedtest -y

echo "" # Пробел для разделения

# Установка nginx-ui
echo -e "\e[32mУстанавливаем nginx-ui...\e[0m"
bash <(curl -L -s https://raw.githubusercontent.com/0xJacky/nginx-ui/master/install.sh) install

echo "" # Пробел для разделения

# Установка webmin
echo -e "\e[32mУстанавливаем webmin...\e[0m"
curl -o setup-repos.sh https://raw.githubusercontent.com/webmin/webmin/master/setup-repos.sh
yes | sudo sh setup-repos.sh

echo "" # Пробел для разделения

echo -e "\e[32mУстанавливаем дополнительные инструменты...\e[0m"
apt-get install net-tools fail2ban mc -y

echo "" # Пробел для разделения

echo -e "\e[32mНастраиваем Fail2Ban...\e[0m"
systemctl enable fail2ban
systemctl start fail2ban


echo "" # Пробел для разделения

# Очистка
echo -e "\e[34mОчистка временных файлов...\e[0m"
rm -f setup-repos.sh

echo "" # Пробел для разделения

echo -e "\e[32mУстановка завершена!\e[0m"

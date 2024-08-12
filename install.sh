#!/bin/bash

# Установка программ и первичная настройка ubuntu 24
#установка vpn  и сертификата: sudo su -c "bash <(wget -qO- https://raw.githubusercontent.com/GFW4Fun/x-ui-pro/master/x-ui-pro.sh) -uninstall yes"


# Проверка на root-права
if [ "$EUID" -ne 0 ]; then
  echo -e "\e[31mПожалуйста, запустите скрипт с правами суперпользователя.\e[0m"
  exit 1
fi

# Логирование
LOG_FILE="/var/log/setup-script.log"
exec > >(tee -a $LOG_FILE) 2>&1

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
apt-get install net-tools fail2ban mc python3 python3-pip -y

echo "" # Пробел для разделения

echo -e "\e[32mНастраиваем Fail2Ban...\e[0m"
systemctl enable fail2ban
systemctl start fail2ban

echo "" # Пробел для разделения


echo -e "\e[32mМеняем порт SSH на 2222, если необходимо...\e[0m"
current_port=$(grep -E '^Port ' /etc/ssh/sshd_config | awk '{print $2}')
if [ "$current_port" != "2222" ]; then
    # Удаление старой строки порта, если она есть
    sed -i '/^Port /d' /etc/ssh/sshd_config
    
    # Добавление новой строки порта
    echo "Port 2222" >> /etc/ssh/sshd_config
    
    echo -e "\e[32mПорт SSH изменен на 2222.\e[0m"
    
    # Проверка конфигурационного файла на ошибки
    if ! sshd -t; then
        echo -e "\e[31mОшибка в конфигурации SSH. Пожалуйста, исправьте ошибки.\e[0m"
        exit 1
    fi
    
    echo -e "\e[32mПерезапускаем службу SSH...\e[0m"
    systemctl restart ssh
else
    echo -e "\e[32mПорт SSH уже установлен на 2222.\e[0m"
fi




echo "" # Пробел для разделения

# Очистка
echo -e "\e[34mОчистка временных файлов...\e[0m"
rm -f setup-repos.sh

echo "" # Пробел для разделения

echo -e "\e[32mУстановка завершена!\e[0m"
echo "" # Пробел для разделения
echo "" # Пробел для разделения

# Вывод информации о веб-панелях
ip_address=$(hostname -I | awk '{print $1}')
echo -e "\e[32mnginx-ui-panel: http://$ip_address:9000\e[0m"
echo -e "\e[32mwebmin: http://$ip_address:10000\e[0m"

echo "" # Пробел для разделения
echo "" # Пробел для разделения



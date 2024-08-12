apt-get update
apt-get upgrade

bash <(curl -L -s https://raw.githubusercontent.com/0xJacky/nginx-ui/master/install.sh) install

curl -o setup-repos.sh https://raw.githubusercontent.com/webmin/webmin/master/setup-repos.sh
sudo sh setup-repos.sh

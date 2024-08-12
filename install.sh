apt-get update
apt-get upgrade

#install nginx-ui
bash <(curl -L -s https://raw.githubusercontent.com/0xJacky/nginx-ui/master/install.sh) install

#install webmin
curl -o setup-repos.sh https://raw.githubusercontent.com/webmin/webmin/master/setup-repos.sh
sudo sh setup-repos.sh

echo -e "\e[34m>>>>>>>>>>>>>> Download Redis Repo <<<<<<<<<<<<\e[0m"
yum install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y

echo -e "\e[34m>>>>>>>>>>>>>> Enable Remi-6.2 Version <<<<<<<<<<<<\e[0m"
yum module enable redis:remi-6.2 -y

echo -e "\e[34m>>>>>>>>>>>>>> Install Redis <<<<<<<<<<<<\e[0m"
yum install redis -y

echo -e "\e[34m>>>>>>>>>>>>>> Change Listen Address <<<<<<<<<<<<\e[0m"
sed -i -e 's|127.0.0.1|0.0.0.0|' /etc/redis.conf /etc/redis/redis.conf

echo -e "\e[34m>>>>>>>>>>>>>> Start Redis Service <<<<<<<<<<<<\e[0m"
systemctl enable redis
systemctl restart redis
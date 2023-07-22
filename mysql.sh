yum module disable mysql -y

cp mysql.repo /etc/yum.repos.d/mongo.repo

yum install mysql-community-server -y

systemctl enable mysqld
systemctl restart mysqld

mysql_secure_installation --set-root-pass RoboShop@1
mysql -uroot -pRoboShop@1
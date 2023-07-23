echo -e "\e[34m>>>>>>>>>>>>>> Install Maven <<<<<<<<<<<<\e[0m"
yum install maven -y

echo -e "\e[34m>>>>>>>>>>>>>> Setup SystemD Service <<<<<<<<<<<<\e[0m"
cp ${script_path}/shipping.service /etc/systemd/system/shipping.service

echo -e "\e[34m>>>>>>>>>>>>>> Add Application User <<<<<<<<<<<<\e[0m"
useradd ${app_user}

echo -e "\e[34m>>>>>>>>>>>>>> Add Application Directory <<<<<<<<<<<<\e[0m"
rm -rf /app
mkdir /app

echo -e "\e[34m>>>>>>>>>>>>>> Download Application Content <<<<<<<<<<<<\e[0m"
curl -L -o /tmp/shipping.zip https://roboshop-artifacts.s3.amazonaws.com/shipping.zip

echo -e "\e[34m>>>>>>>>>>>>>> Unzip App Content <<<<<<<<<<<<\e[0m"
cd /app
unzip /tmp/shipping.zip

echo -e "\e[34m>>>>>>>>>>>>>> Download Maven Dependencies <<<<<<<<<<<<\e[0m"
mvn clean package
mv target/shipping-1.0.jar shipping.jar

echo -e "\e[34m>>>>>>>>>>>>>> Start Shipping Service <<<<<<<<<<<<\e[0m"
systemctl daemon-reload
systemctl enable shipping
systemctl restart shipping

echo -e "\e[34m>>>>>>>>>>>>>> Install Mysql Client <<<<<<<<<<<<\e[0m"
yum install mysql -y

echo -e "\e[34m>>>>>>>>>>>>>> Load Schema <<<<<<<<<<<<\e[0m"
mysql -h mysql-dev.akrdevopsb72.online -uroot -pRoboShop@1 < /app/schema/shipping.sql

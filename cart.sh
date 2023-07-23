script=$(realpath $0)
exit
source common.sh


exit




echo -e "\e[34m>>>>>>>>>>>>>> Download Nodejs Repos <<<<<<<<<<<<\e[0m"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash

echo -e "\e[34m>>>>>>>>>>>>>> Install Nodejs <<<<<<<<<<<<\e[0m"
yum install nodejs -y


echo -e "\e[34m>>>>>>>>>>>>>> Add Application User <<<<<<<<<<<<\e[0m"
useradd ${app_user}

echo -e "\e[34m>>>>>>>>>>>>>> Add Application Directory <<<<<<<<<<<<\e[0m"
rm -rf /app
mkdir /app

echo -e "\e[34m>>>>>>>>>>>>>> Download App Content <<<<<<<<<<<<\e[0m"
curl -L -o /tmp/cart.zip https://roboshop-artifacts.s3.amazonaws.com/cart.zip

echo -e "\e[34m>>>>>>>>>>>>>> Unzip App Content <<<<<<<<<<<<\e[0m"
cd /app
unzip /tmp/cart.zip

echo -e "\e[34m>>>>>>>>>>>>>> Install Nodejs Dependencies <<<<<<<<<<<<\e[0m"
npm install

echo -e "\e[34m>>>>>>>>>>>>>> Setup Systemd Service <<<<<<<<<<<<\e[0m"
cp cart.service /etc/systemd/system/cart.service

echo -e "\e[34m>>>>>>>>>>>>>> Start Cart Service <<<<<<<<<<<<\e[0m"
systemctl daemon-reload
systemctl enable cart
systemctl restart cart
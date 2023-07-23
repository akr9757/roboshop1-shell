script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh

curl -sL https://rpm.nodesource.com/setup_lts.x | bash

yum install nodejs -y

cp ${script_path}/catalogue.service /etc/systemd/system/catalogue.service



useradd ${app_user}r

rm -rf /app
mkdir /app

curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip

cd /app
unzip /tmp/catalogue.zip

npm install

systemctl daemon-reload
systemctl enable catalogue
systemctl restart catalogue

echo -e "\e[34m>>>>>>>>>>>>>> Copy Mongo Repo <<<<<<<<<<<<\e[0m"
cp ${script_path}/mongo.repo /etc/yum.repos.d/mongo.repo

echo -e "\e[34m>>>>>>>>>>>>>> Install Mongodb Client <<<<<<<<<<<<\e[0m"
yum install mongodb-org-shell -y

echo -e "\e[34m>>>>>>>>>>>>>> Load App Schema <<<<<<<<<<<<\e[0m"
mongo --host mongodb-dev.akrdevopsb72.online </app/schema/catalogue.js
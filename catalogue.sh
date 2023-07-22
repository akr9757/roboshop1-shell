
curl -sL https://rpm.nodesource.com/setup_lts.x | bash

yum install nodejs -y

cp catalogue.service /etc/systemd/system/catalogue.service



useradd roboshop

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
cp mongo.repo /etc/yum.repos.d/mongo.repo

echo -e "\e[34m>>>>>>>>>>>>>> Install Mongodb Client <<<<<<<<<<<<\e[0m"
yum install mongodb-org-shell -y

echo -e "\e[34m>>>>>>>>>>>>>> Load App Schema <<<<<<<<<<<<\e[0m"
mongo --host mongodb-dev.akrdevopsb72.online </app/schema/catalogue.js
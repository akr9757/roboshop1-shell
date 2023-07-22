curl -sL https://rpm.nodesource.com/setup_lts.x | bash

yum install nodejs -y

cp user.service /etc/systemd/system/user.service

cp mongo.repo /etc/yum.repos.d/mongo.repo

useradd roboshop

rm -rf /app
mkdir /app

curl -L -o /tmp/user.zip https://roboshop-artifacts.s3.amazonaws.com/user.zip

cd /app
unzip /tmp/user.zip

npm install

systemctl daemon-reload
systemctl enable user
systemctl restart user

yum install mongodb-org-shell -y
mongo --host mongodb-dev.akrdevopsb72.online </app/schema/user.js
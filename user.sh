curl -sL https://rpm.nodesource.com/setup_lts.x | bash

yum install nodejs -y

cp ${script_path}/user.service /etc/systemd/system/user.service

cp ${script_path}/mongo.repo /etc/yum.repos.d/mongo.repo

useradd ${app_user}

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
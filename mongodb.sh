cp mongo.repo /etc/yum.repos.d/mongo.repo

yum install mongodb-org -y

systemctl start mongod
systemctl enable mongod
systemctl restart mongod
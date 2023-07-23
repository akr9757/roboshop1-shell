script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh

echo -e "\e[34m>>>>>>>>>>>>>> Copy Mongo Repo <<<<<<<<<<<<<<\e[0m"
cp ${script_path}/mongo.repo /etc/yum.repos.d/mongo.repo

echo -e "\e[34m>>>>>>>>>>>>>> Install Mongodb Client <<<<<<<<<<<<<<\e[0m"
yum install mongodb-org -y

echo -e "\e[34m>>>>>>>>>>>>>> Update Listen Address <<<<<<<<<<<<<<\e[0m"
sed -i -e 's|127.0.0.1|0.0.0.0|' /etc/mongod.conf

echo -e "\e[34m>>>>>>>>>>>>>> Start Mongodb Service <<<<<<<<<<<<<<\e[0m"
systemctl start mongod
systemctl enable mongod
systemctl restart mongod
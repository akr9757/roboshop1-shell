script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh
rabbitmq_appuser_password=$1

if [ -z "$rabbitmq_appuser_password" ]; then
  echo input app user password is missing
  exit
fi

echo -e "\e[34m>>>>>>>>>>>>>> Download Erlang Repos <<<<<<<<<<<<<<\e[0m"
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash

echo -e "\e[34m>>>>>>>>>>>>>> Download Rabbitma Repo <<<<<<<<<<<<<<\e[0m"
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash

echo -e "\e[34m>>>>>>>>>>>>>> install Rabbitmq <<<<<<<<<<<<<<\e[0m"
yum install rabbitmq-server -y

echo -e "\e[34m>>>>>>>>>>>>>> Start Rabbitmq Service <<<<<<<<<<<<<<\e[0m"
systemctl enable rabbitmq-server
systemctl restart rabbitmq-server

echo -e "\e[34m>>>>>>>>>>>>>> Add Rabbitmq User <<<<<<<<<<<<<<\e[0m"
rabbitmqctl add_user roboshop ${rabbitmq_appuser_password}
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"
script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh
dispatch-app_password=$1

echo -e "\e[34m>>>>>>>>>>>>>> Install Golang <<<<<<<<<<<<\e[0m"
yum install golang -y

echo -e "\e[34m>>>>>>>>>>>>>> Setup SystemD Setup <<<<<<<<<<<<\e[0m"
sed -i -e 's|dispatch-app_password|${dispatch-app_password}|' ${script_path}/dispatch.service
cp ${script_path}/dispatch.service /etc/systemd/system/dispatch.service

echo -e "\e[34m>>>>>>>>>>>>>> Add Application User <<<<<<<<<<<<\e[0m"
useradd ${app_user}

echo -e "\e[34m>>>>>>>>>>>>>> Creat App Directory <<<<<<<<<<<<\e[0m"
rm -rf /app
mkdir /app

echo -e "\e[34m>>>>>>>>>>>>>> Download Application Content <<<<<<<<<<<<\e[0m"
curl -L -o /tmp/dispatch.zip https://roboshop-artifacts.s3.amazonaws.com/dispatch.zip

echo -e "\e[34m>>>>>>>>>>>>>> Unzip App Content <<<<<<<<<<<<\e[0m"
cd /app
unzip /tmp/dispatch.zip

echo -e "\e[34m>>>>>>>>>>>>>> Install Golang Dependencies <<<<<<<<<<<<\e[0m"
go mod init dispatch
go get
go build

echo -e "\e[34m>>>>>>>>>>>>>> Start Dispatch Service <<<<<<<<<<<<\e[0m"
systemctl daemon-reload
systemctl enable dispatch
systemctl restart dispatch
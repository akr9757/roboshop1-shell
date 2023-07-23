script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh
payment_appuser_password=$1

if [ -z "$payment_appuser_password" ]; then
    echo input app user password is missing
fi

echo -e "\e[34m>>>>>>>>>>>>>> Install Python <<<<<<<<<<<<<<\e[0m"
yum install python36 gcc python3-devel -y

echo -e "\e[34m>>>>>>>>>>>>>> Setup Systemd Setup <<<<<<<<<<<<<<\e[0m"
sed -i -e 's|payment_appuser_password|${payment_appuser_password}' ${script_path}/payment.service
cp ${script_path}/payment.service /etc/systemd/system/payment.service

echo -e "\e[34m>>>>>>>>>>>>>> Add Application User <<<<<<<<<<<<<<\e[0m"
useradd ${app_user}

echo -e "\e[34m>>>>>>>>>>>>>> Add Application Directory <<<<<<<<<<<<<<\e[0m"
rm -rf /app
mkdir /app

echo -e "\e[34m>>>>>>>>>>>>>> Download Application Content <<<<<<<<<<<<<<\e[0m"
curl -L -o /tmp/payment.zip https://roboshop-artifacts.s3.amazonaws.com/payment.zip

echo -e "\e[34m>>>>>>>>>>>>>> Unzip App Content <<<<<<<<<<<<<<\e[0m"
cd /app
unzip /tmp/payment.zip

echo -e "\e[34m>>>>>>>>>>>>>> Install Python Dependencies <<<<<<<<<<<<<<\e[0m"
pip3.6 install -r requirements.txt

echo -e "\e[34m>>>>>>>>>>>>>> Start payment Service <<<<<<<<<<<<<<\e[0m"
systemctl daemon-reload
systemctl enable payment
systemctl restart payment
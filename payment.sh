echo -e "\e[34m>>>>>>>>>>>>>> Install Python <<<<<<<<<<<<<<\e[0m"
yum install python36 gcc python3-devel -y

echo -e "\e[34m>>>>>>>>>>>>>> Setup Systemd Setup <<<<<<<<<<<<<<\e[0m"
cp payment.service /etc/systemd/system/payment.service

echo -e "\e[34m>>>>>>>>>>>>>> Add Application User <<<<<<<<<<<<<<\e[0m"
useradd roboshop

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
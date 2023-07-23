echo -e "\e[34m>>>>>>>>>>>>>> Install Nginx <<<<<<<<<<<<<<\e[0m"
yum install nginx -y

echo -e "\e[34m>>>>>>>>>>>>>> Setup Roboshop Configuration <<<<<<<<<<<<<<\e[0m"
cp ${script_path}/roboshop.conf /etc/nginx/default.d/roboshop.conf

echo -e "\e[34m>>>>>>>>>>>>>> Remove Default Content <<<<<<<<<<<<<<\e[0m"
rm -rf /usr/share/nginx/html/*

echo -e "\e[34m>>>>>>>>>>>>>> Download Frontend Content <<<<<<<<<<<<<<\e[0m"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip

echo -e "\e[34m>>>>>>>>>>>>>> Unzip Frontend Content <<<<<<<<<<<<<<\e[0m"
cd /usr/share/nginx/html
unzip /tmp/frontend.zip

echo -e "\e[34m>>>>>>>>>>>>>> Start Nginx Service <<<<<<<<<<<<<<\e[0m"
systemctl enable nginx
systemctl restart nginx
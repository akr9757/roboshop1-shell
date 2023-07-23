script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh

func_printhead "Install Nginx"
yum install nginx -y &>>$log_file
func_status_check $?

func_printhead "Setup Roboshop Configuration"
cp ${script_path}/roboshop.conf /etc/nginx/default.d/roboshop.conf &>>$log_file
func_status_check $?

func_printhead "Remove Default Content"
rm -rf /usr/share/nginx/html/* &>>$log_file
func_status_check $?

func_printhead "Download Frontend Content"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip &>>$log_file
func_status_check $?

func_printhead "Unzip Frontend Content"
cd /usr/share/nginx/html &>>$log_file
unzip /tmp/frontend.zip &>>$log_file
func_status_check $?

func_printhead "Start Nginx Service"
systemctl enable nginx &>>$log_file
systemctl restart nginx &>>$log_file
func_status_check $?
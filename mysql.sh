script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh
mysql_root_password=$1

if [ -z "$mysql_root_password" ]; then
  echo input app user password is missing
  exit
fi

func_printhead "Disable Default Mysql Version"
yum module disable mysql -y &>>$log_file
func_status_check $?

func_printhead "Copy Mysql Repo"
cp ${script_path}/mysql.repo /etc/yum.repos.d/mongo.repo &>>$log_file
func_status_check $?

func_printhead "Install Mysql Client"
yum install mysql-community-server -y &>>$log_file
func_status_check $?

func_printhead "Start Mysql Service"
systemctl enable mysqld &>>$log_file
systemctl restart mysqld &>>$log_file
func_status_check $?

func_printhead "Update Default User"
mysql_secure_installation --set-root-pass ${mysql_root_password} &>>$log_file
mysql -uroot -pRoboShop@1 &>>$log_file
func_status_check $?
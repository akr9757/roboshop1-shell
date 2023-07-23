script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh

func_printhead "Copy Mongo Repo"
cp ${script_path}/mongo.repo /etc/yum.repos.d/mongo.repo &>>$log_file
func_status_check $?

func_printhead "Install Mongodb Client"
yum install mongodb-org -y &>>$log_file
func_status_check $?

func_printhead "Update Listen Address"
sed -i -e 's|127.0.0.1|0.0.0.0|' /etc/mongod.conf &>>$log_file
func_status_check $?

func_printhead "Start Mongodb Service"
systemctl start mongod &>>$log_file
systemctl enable mongod &>>$log_file
systemctl restart mongod &>>$log_file
func_status_check $?
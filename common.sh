app_user=roboshop
script=$(realpath "$0")
script_path=$(dirname "$script")
log_file=/tmp/roboshop.log

func_printhead() {
  echo -e "\e[34m>>>>>>>>>>>>>> $1 <<<<<<<<<<<<\e[0m"
  echo -e "\e[34m>>>>>>>>>>>>>> $1 <<<<<<<<<<<<\e[0m" &>>$log_file

}

func_status_check() {
  if [ $1 -eq 0 ]; then
    echo -e "\e[32msuccess\e[0m"
  else
    echo -e "\e[31mfailure\e[0m"
    echo refer the log file for more information
    exit 1
  fi
}

func_app_prereq() {
    func_printhead "Add Application User"
    id ${app_user} &>>$log_file
    if [ $? -ne 0 ]; then
       useradd ${app_user} &>>$log_file
    fi
    func_status_check $?

    func_printhead "Add Application Directory"
    rm -rf /app &>>$log_file
    mkdir /app &>>$log_file
    func_status_check $?

    func_printhead "Download App Content"
    curl -L -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip &>>$log_file
    func_status_check $?

    func_printhead "Unzip App Content"
    cd /app &>>$log_file
    unzip /tmp/${component}.zip &>>$log_file
    func_status_check $?
}

func_systemd_setup() {
  func_printhead "Setup Systemd Service"
    cp ${script_path}/${component}.service /etc/systemd/system/${component}.service &>>$log_file
    func_status_check $?

    func_printhead "Start ${component} Service"
    systemctl daemon-reload &>>$log_file
    systemctl enable ${component} &>>$log_file
    systemctl restart ${component} &>>$log_file
    func_status_check $?
}

func_schema_setup() {
  if [ "$schema_setup" == "mongo" ]; then
     func_printhead "Copy Mongo Repo"
     cp ${script_path}/mongo.repo /etc/yum.repos.d/mongo.repo &>>$log_file
     func_status_check $?

     func_printhead "Install Mongodb Client"
     yum install mongodb-org-shell -y &>>$log_file
     func_status_check $?

     func_printhead "Load App Schema"
     mongo --host mongodb-dev.akrdevopsb72.online </app/schema/${component}.js &>>$log_file
     func_status_check $?
  fi
  if [ "$schema_setup" == "mysql" ]; then
     func_printhead "Install Mysql Client"
     yum install mysql -y &>>$log_file
     func_status_check $?

     func_printhead "Load Schema"
     mysql -h mysql-dev.akrdevopsb72.online -uroot -p${mysql_appuser_password} < /app/schema/${component}.sql &>>$log_file
     func_status_check $?
  fi
}

func_nodejs() {
  func_printhead "Download Nodejs Repos"
  curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>$log_file
  func_status_check $?

  func_printhead "Install Nodejs"
  yum install nodejs -y &>>$log_file
  func_status_check $?

  func_app_prereq

  func_printhead "Install Nodejs Dependencies"
  npm install &>>$log_file

  func_status_check $?

  func_schema_setup

  func_systemd_setup


}

func_java() {
  func_printhead "Install Maven"
  yum install maven -y &>>$log_file
  func_status_check $?

  func_app_prereq

  func_printhead "Download Maven Dependencies"
  mvn clean package &>>$log_file
  mv target/${component}-1.0.jar ${component}.jar &>>$log_file
  func_status_check $?

  func_schema_setup

  func_systemd_setup
}

func_python() {
  func_printhead "Install Python"
  yum install python36 gcc python3-devel -y &>>$log_file
  func_status_check $?

  func_app_prereq

  func_printhead "Install Python Dependencies"
  pip3.6 install -r requirements.txt &>>$log_file
  func_status_check $?

  func_printhead "Update Password System Service File"
  sed -i -e "s|payment_appuser_password|${payment_appuser_password}|" ${script_path}/payment.service &>>$log_file
  func_status_check $?

  func_systemd_setup
}

func_golang() {
  func_printhead "Install Golang"
  yum install golang -y &>>$log_file
  func_status_check $?

  func_app_prereq

  func_printhead "Install Golang Dependencies"
  go mod init ${component} &>>$log_file
  go get &>>$log_file
  go build &>>$log_file
  func_status_check $?

  func_printhead "Setup SystemD Setup"
  sed -i -e 's|dispatch_app_password|${dispatch_app_password}|' ${script_path}/dispatch.service &>>$log_file
  func_status_check $?

  func_systemd_setup
}
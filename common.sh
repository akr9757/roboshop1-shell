app_user=roboshop
script=$(realpath "$0")
script_path=$(dirname "$script")

func_printhead() {
  echo -e "\e[34m>>>>>>>>>>>>>> $1 <<<<<<<<<<<<\e[0m"
}

func_schema_setup() {
  if [ "$schema_setup" == "mongo" ]; then
     func_printhead "Copy Mongo Repo"
     cp ${script_path}/mongo.repo /etc/yum.repos.d/mongo.repo

     func_printhead "Install Mongodb Client"
     yum install mongodb-org-shell -y

     func_printhead "Load App Schema"
     mongo --host mongodb-dev.akrdevopsb72.online </app/schema/${component}.js
  fi
}

func_nodejs() {
  func_printhead "Download Nodejs Repos"
  curl -sL https://rpm.nodesource.com/setup_lts.x | bash

  func_printhead "Install Nodejs"
  yum install nodejs -y

  func_printhead "Add Application User"
  useradd ${app_user}

  func_printhead "Add Application Directory"
  rm -rf /app
  mkdir /app

  func_printhead "Download App Content"
  curl -L -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip

  func_printhead "Unzip App Content"
  cd /app
  unzip /tmp/${component}.zip

  func_printhead "Install Nodejs Dependencies"
  npm install

  func_printhead "Setup Systemd Service"
  cp ${script_path}/${component}.service /etc/systemd/system/${component}.service

  func_printhead "Start ${component} Service"
  systemctl daemon-reload
  systemctl enable ${component}
  systemctl restart ${component}

  func_schema_setup
}
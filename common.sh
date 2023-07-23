app_user=roboshop
script=$(realpath "$0")
script_path=$(dirname "$script")

func_schema_setup() {
  if [ "$schema_setup" == "mongo" ]; then
     echo -e "\e[34m>>>>>>>>>>>>>> Copy Mongo Repo <<<<<<<<<<<<\e[0m"
     cp ${script_path}/mongo.repo /etc/yum.repos.d/mongo.repo

     echo -e "\e[34m>>>>>>>>>>>>>> Install Mongodb Client <<<<<<<<<<<<\e[0m"
     yum install mongodb-org-shell -y

     echo -e "\e[34m>>>>>>>>>>>>>> Load App Schema <<<<<<<<<<<<\e[0m"
     mongo --host mongodb-dev.akrdevopsb72.online </app/schema/${component}.js
  fi
}

func_nodejs() {
  echo -e "\e[34m>>>>>>>>>>>>>> Download Nodejs Repos <<<<<<<<<<<<\e[0m"
  curl -sL https://rpm.nodesource.com/setup_lts.x | bash

  echo -e "\e[34m>>>>>>>>>>>>>> Install Nodejs <<<<<<<<<<<<\e[0m"
  yum install nodejs -y

  echo -e "\e[34m>>>>>>>>>>>>>> Add Application User <<<<<<<<<<<<\e[0m"
  useradd ${app_user}

  echo -e "\e[34m>>>>>>>>>>>>>> Add Application Directory <<<<<<<<<<<<\e[0m"
  rm -rf /app
  mkdir /app

  echo -e "\e[34m>>>>>>>>>>>>>> Download App Content <<<<<<<<<<<<\e[0m"
  curl -L -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip

  echo -e "\e[34m>>>>>>>>>>>>>> Unzip App Content <<<<<<<<<<<<\e[0m"
  cd /app
  unzip /tmp/${component}.zip

  echo -e "\e[34m>>>>>>>>>>>>>> Install Nodejs Dependencies <<<<<<<<<<<<\e[0m"
  npm install

  echo -e "\e[34m>>>>>>>>>>>>>> Setup Systemd Service <<<<<<<<<<<<\e[0m"
  cp ${script_path}/${component}.service /etc/systemd/system/${component}.service

  echo -e "\e[34m>>>>>>>>>>>>>> Start ${component} Service <<<<<<<<<<<<\e[0m"
  systemctl daemon-reload
  systemctl enable ${component}
  systemctl restart ${component}

  func_schema_setup
}
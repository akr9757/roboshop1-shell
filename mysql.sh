script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh
mysql_root_password=$1

if [ -z "$mysql_root_password" ]; then
  echo input app user password is missing
  exit
fi


echo -e "\e[34m>>>>>>>>>>>>>> Disable Default Mysql Version <<<<<<<<<<<<<<\e[0m"
yum module disable mysql -y

echo -e "\e[34m>>>>>>>>>>>>>> Copy Mysql Repo <<<<<<<<<<<<<<\e[0m"
cp ${script_path}/mysql.repo /etc/yum.repos.d/mongo.repo

echo -e "\e[34m>>>>>>>>>>>>>> Install Mysql Client <<<<<<<<<<<<<<\e[0m"
yum install mysql-community-server -y

echo -e "\e[34m>>>>>>>>>>>>>> Start Mysql Service <<<<<<<<<<<<<<\e[0m"
systemctl enable mysqld
systemctl restart mysqld

echo -e "\e[34m>>>>>>>>>>>>>> Update Default User <<<<<<<<<<<<<<\e[0m"
mysql_secure_installation --set-root-pass ${mysql_root_password}
mysql -uroot -pRoboShop@1
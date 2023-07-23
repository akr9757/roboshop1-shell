script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh
mysql_appuser_password=$1

if [ -z "$mysql_appuser_password" ]; then
    echo input app user password is missing
    exit
fi

component=shipping
schema_setup=mysql

func_java

script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh

component=user
schema_setup=mongo

func_nodejs

cp ${script_path}/mongo.repo /etc/yum.repos.d/mongo.repo
yum install mongodb-org-shell -y
mongo --host mongodb-dev.akrdevopsb72.online </app/schema/user.js

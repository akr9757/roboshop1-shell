script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh
dispatch_app_password=$1

if [ -z "$dispatch_app_password" ]; then
  echo input app user password is missing
  exit 1
fi

component=dispatch

func_golang
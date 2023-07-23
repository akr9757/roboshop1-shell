script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh
payment_appuser_password=$1

if [ -z "$payment_appuser_password" ]; then
  echo input app user password is missing
  exit
fi

component=payment
func_python

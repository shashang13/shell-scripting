statusCheck (){
  if [ "$1" -eq 0 ]; then
    echo -e "\e[32m $2 is a SUCCESS\e[0m"
  else
    echo -e "\e[31m $2 is FAILURE\e[0m"
    exit "$1"
  fi
}

descriptionPrint () {
  echo -e "\n--------------------\e[36m${1}\e[0m----------------------"
  STAGE=$1
}


logFile=/tmp/mongodb.log
rm -f $logFile
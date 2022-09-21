statusCheck (){
  if [ "$1" -eq 0 ]; then
    echo -e "\e[32m $1 is a SUCCESS\e[0m"
  else
    echo -e "\e[31m $1 is FAILURE\e[0m"
    exit "$1"
  fi
}

descriptionPrint () {
  echo -e "\n--------------------\e[36m${1}\e[0m----------------------"
}


logFile=/tmp/mongodb.log
rm -f $logFile
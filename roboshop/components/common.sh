statusCheck (){
  if [ "$1" -eq 0 ]; then
    echo -e "\e[32m $2 is a SUCCESS\e[0m" |tee -a ${logFile}
  else
    echo -e "\e[31m $2 is FAILURE\e[0m" |tee -a ${logFile}
    exit "$1"
  fi
}

descriptionPrint () {
  STAGE="${1}"
  echo -e "\n--------------------\e[36m${1}\e[0m----------------------" |tee -a ${logFile}
}


logFile=/tmp/roboshop.log
rm -f $logFile
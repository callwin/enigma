#!/usr/bin/env bash

nfre='^[A-Za-z]+\.[A-Za-z]+$'
re='^[A-Z ]+$'
rs='[[:blank:]]'
menu () {
        echo "0. Exit"
        echo "1. Create a file"
        echo "2. Read a file"
        echo "3. Encrypt a file"
        echo "4. Decrypt a file"
        echo  "Enter an option:"
}

new () {
  echo "Enter the filename:"
  read -r NewFile
  if [[ $NewFile =~ $nfre ]]; then
    echo "Enter a message:"
    read -r message
    if  [[ $message =~ $re ]]; then
      echo $message > $NewFile
      echo "The file was created successfully!"
    else
      echo "This is not a valid message!"
    fi
  else
    echo "File name can contain letters and dots only!"
  fi
}

transform () {
    action=$1
    echo "Enter the filename:"
    read -r file
    if [ -f $file ]; then
        echo "Enter password:"
        read -r password
        if [[ $action == 'e' ]]; then
          output=$file.enc
        else
          output=${file%.enc}
        fi
        openssl enc -aes-256-cbc \
            -"$action" \
            -pbkdf2 -nosalt \
            -in "$file" \
            -out "$output" \
            -pass pass:"$password" \
            &>/dev/null
        exit_code=$?
        if [[ $exit_code -ne 0 ]]; then
            echo "Fail"
        else
            rm $file
            echo "Success"
        fi
    else
        echo "File not found!"
    fi
}

get_content () {
  echo "Enter the filename:"
  read -r file
  if [ -f $file ]; then
    echo "File content:"
    cat $file
  else
    echo "File not found!"
  fi
}

echo "Welcome to the Enigma!"
while :
  do
    menu
    read -r w
    case $w in
        1 ) new
        ;;
        2 ) get_content
        ;;
        3 ) transform e
        ;;
        4 ) transform d
        ;;
        0 ) echo "See you later!"
            exit
        ;;
        * ) echo "Invalid option!"
            w=5
            continue
        ;;
    esac
  done
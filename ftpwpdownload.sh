#!/bin/bash

## version
VERSION="0.0.1"

## instalation folder
INSTALLATION_FOLDER="/usr/local/bin/"

## lists the wordpress files
ftpwpdownload_listfiles () {
    cat $INSTALLATION_FOLDER\wordpress_filelist
}


## check ncftp dependency
ftpwpdownload_checkncftpdependency () {
    which ncftp > /dev/null 2>&1
}

## check if the credentials works
ftpwpdownload_checkcredentials () {
    IFS=$'\n'

    server=$1
    user=$2
    pass=$3

    messages=($(ncftp <<EOF
        open -u $user -p $pass $1
EOF    
    )
    )

    for i in "${messages[@]}"; do
        echo $1
        echo target: Logged in to
        if echo $i | grep "Logged in to" > /dev/null 2>&1; then
            return 0
        fi
    done

    return 1
}


## main function
ftpwpdownload () {

    if ! ftpwpdownload_checkncftpdependency; then
        echo The ncftp utility is not installed in the system. Install it first.
        return 1
    fi

    date=$(date +%Y%m%d-%Hh%Mm%Ss)

    read -p "What is the ftp server? " ftpserver
    read -p "Provides the ftp user: " ftpuser
    read -s -p "The ftp password, please: " password

    echo ""

    if ! ftpwpdownload_checkcredentials $ftpserver $ftpuser $password > /dev/null 2>&1; then
        echo There\'s must be some problem in the credentials or connection. Please, try again and ensure you did not provided wrong credentials data.
        return 1
    fi

    read -p "Which is the ftp server directory to locate the Drupal 7 installation? Type here -> " ftpbasedir

    mkdir $date
    cd $date

    for i in $(ftpwpdownload_listfiles); do
        ncftpget -R -v -T -p $password -u $ftpuser $ftpserver . $ftpbasedir/$i
    done

    return 0
}

## detect if being sourced and
## export if so else execute
## main function with args
if [[ ${BASH_SOURCE[0]} != $0 ]]; then
  export -f ftpwpdownload
else
  ftpwpdownload "${@}"
  exit $?
fi



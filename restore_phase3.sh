#!/bin/bash

#restore

#Data INIT
restoreInfo=$HOME/.restore.info
recBinDir=$HOME/recyclebin
file=$1
inode=$(echo -n $file | cut -d"_" -f2)
fileName=$(echo -n $file | cut -d"_" -f1)
binName=$(echo -n $inode"_"$fileName)
restoreMatch=$(cat $restoreInfo | egrep $inode)
originalPath=$(echo -n $restoreMatch | cut -d":" -f2)

#Functions
function restoreFile() {
        mv -f  $recBinDir/$binName $originalPath
        cat $restoreInfo | egrep -v $inode > $HOME/.restoreTemp
        mv -f $HOME/.restoreTemp $HOME/.restore.info
}


#### MAIN ####
if [ $# -eq 0 ] ; then
        echo "No File name Provided"
        exit 1
elif [ ! -e $recBinDir/$binName ] ; then
        echo "File does not exist"
        exit
elif [ -e $originalPath ] ; then
        read -p "This file already exist. DO YOU WANT TO OVERWRITE: [y/n]?" opt
        case $opt in
                [yY]*)
                        restoreFile
                        echo "$file has been restored" ;;
                [nN]*)
                        echo "NO" ;;
                        *)
                        echo "Invalid Response"

        esac
else
        restoreFile
        echo "$file has been restored"
fi
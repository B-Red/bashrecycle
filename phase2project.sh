#!/bin/bash
#restore
restoreInfo=$HOME/.restore.info
recBinDir=$HOME/recyclebin/
file=$1
inode=$(echo -n $file | cut -d"_" -f2)
fileName=$(echo -n $file | cut -d"_" -f1)
restorePath=$(cat $restoreInfo | egrep $inode | cut -d":" -f2)
test1=$(cat $restoreInfo | grep -w ^$1)

if [ $# -eq 0 ] ; then
    echo "No file name provided"
elif [ ! -e $recBinDir$fileName ] ; then
    echo "File does not exist"
else
    echo "Else"
fi



#### MAIN ####
echo $restoreInfo
echo $recBinDir
ls $recBinDir
echo $file
echo $restoreInfo
echo $inode
echo $fileName
echo $restorePath
echo $test1
#!/bin/bash

#recycle

function createRecycle(){
recBinDir=$HOME/recyclebin
restoreInfo=$HOME/.restore.info
if [ !  -d $recBinDir ] ; then
        mkdir $recBinDir
        touch $restoreInfo
fi
}

function checkFile(){
for i in $*
do

file=$i

        if [ ! -e $file ] ; then
                echo "Error: $file does not exist"
                continue
        elif [ -d $file ] ; then
                echo "Error: This is a directory"
                continue
        elif [ $file = "recycle" ] ; then
                echo "Attempting to delete recycle - operation aborted"
                continue
        else
                optsCheck
        fi
done
}

function rmvFile(){
fileInode=$(ls -i $file | cut -d" " -f1)
fileName=$(basename $file)
inodeName=$fileInode\_$fileName
absPath=$(readlink -m $file)
restorePath=$inodeName:$absPath

echo $restorePath >> $restoreInfo
mv $file $recBinDir/$inodeName
}

function optsCheck(){
        if [ $optsNone = true ] ; then
                rmvFile
        elif [ $prompt = true ] && [ $verbose = true ] ; then
                read -p "remove regular empty file '$file'? " opt
        case $opt in
            [yY]*)
                                rmvFile
                echo "Removed '$file'";;
                *) ;;
                esac
        elif [ $prompt = true ] ; then
                read -p "remove regular empty file '$file'? " opt
                case $opt in
                        [yY]*)
                                rmvFile ;;
                                *) ;;
                esac
        elif [ $verbose = true ] ; then
                echo "removed '$file'"
                rmvFile
        fi
}


######## MAIN ########
createRecycle

optsNone=true
prompt=false
verbose=false


while getopts :iv opt
do
        case $opt in
                i)
                        prompt=true
                        optsNone=false
                        ;;
                v)
                        verbose=true
                        optsNone=false
                        ;;
                \?)
                        echo "Invalid Option - $OPTARG"
                        exit 1
                        ;;
        esac
done
shift $(($OPTIND - 1))

if [ $# = 0 ] ; then
        echo "No file name provided"
        exit 1
else
        checkFile $*
fi
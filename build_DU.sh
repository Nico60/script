#!/bin/sh

touch ~/repo_log.log
cd ~/Android/DU

CR='\033[0;31m'
CG='\033[0;32m'
CY='\033[0;33m'
CB='\033[0;34m'
CM='\033[0;35m'
CRT='\033[0m'

clear

ban()
{
    echo ""
    echo -e $CY
    echo -e "******************************"
    echo -e "* Welcome to DU build script *"
    echo -e "******************************"
    echo -e $CRT
    echo ""
}

ban
echo -e -n $CB"Repo sync O/N :"$CRT
read rsync 
clear

ban
echo -e $CG"Choose clean level :"$CRT
select cbuild in "make clobber" "make installclean" "no clean"; do
    case $cbuild in
        "make clobber"|"make installclean"|"no clean") break;;
        *) echo "Wrong selection !"
    esac
done
clear

ban
echo -e -n $CM"Build DU now O/N :"$CRT
read bnow
clear

if [ "$rsync" = "o" ] || [ "$rsync" = "O" ]; then
    echo ""
    echo -e $CY
    echo -e "***************************"
    echo -e "*"$CRT $CB"Syncing repositeries..."$CRT $CY"*"
    echo -e "***************************"
    echo -e $CRT
    echo ""
    repo sync 2>~/repo_log.log
fi

testrs()
{
    grep "error:" ~/repo_log.log >/dev/null
} 

case $cbuild in
    "make clobber")
        echo ""
        echo -e $CY
        echo -e "**************************"
        echo -e "*"$CRT $CG"Cleaning OUT folder..."$CRT $CY"*"
        echo -e "**************************"
        echo -e $CRT
        echo ""
        make clobber;;
    "make installclean")
        echo ""
        echo -e $CY
        echo -e "**************************"
        echo -e "*"$CRT $CG"Cleaning OUT folder..."$CRT $CY"*"
        echo -e "**************************"
        echo -e $CRT
        echo ""
        make installclean;;
    "no clean")
        testrs
        if [ $? == 1 -a \( "$bnow" = "o" -o "$bnow" = "O" \) ]; then
            echo ""
            echo -e $CY
            echo -e "**********************"
            echo -e "*"$CRT $CG"Nothing cleaned..."$CRT $CY"*"
            echo -e "**********************"
            echo -e $CRT
            echo ""
       fi
esac

testrs
if [ $? == 0 -a \( "$rsync" = "o" -o "$rsync" = "O" \) ]; then
    echo ""
    echo -e $CY
    echo -e "*****************************"
    echo -e "*"$CRT $CR"WARNING repo sync error !"$CRT $CY"*"
    echo -e "*****************************"
    echo -e $CRT
    echo ""
    cat ~/repo_log.log
elif [ "$bnow" = "o" ] || [ "$bnow" = "O" ]; then
    echo ""
    echo -e $CY
    echo -e "****************************"
    echo -e "*"$CRT $CM"Building DU for Shamu..."$CRT $CY"*" 
    echo -e "****************************"
    echo -e $CRT
    echo ""
    . build/envsetup.sh && lunch du_shamu-userdebug && time mka bacon
fi

rm ~/repo_log.log
cd ~/

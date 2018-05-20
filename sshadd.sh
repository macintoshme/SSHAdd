#!/bin/bash
IFS=$'\n'

configfile=~/.ssh/config

parseconfig(){
if [ ! -d ~/.ssh ]
 	then mkdir ~/.ssh
fi
if [ ! -f $configfile ]
	then 
	touch $configfile
	chmod 700 $configfile
fi
if [ $(grep $domain $configfile|wc -l) -lt 1 ]
        then echo "Host $domain" >> $configfile
        echo -e "\tHostname %h" >> $configfile
        echo -e "\tUser $user" >> $configfile
        if [ $privateKey != 0 ]
#	fullPrivateKeyPath="$(pwd)/$privateKey"
	cp $privateKey ~/.ssh/$domain
	chmod 700 ~/.ssh/$domain 	
#        then echo -e "\tIdentityFile $privateKey" >> $configfile
	then echo -e "\tIdentityFile $domain" >> $configfile
        fi
	echo >> $configfile
fi
}
#New SSH 
input="$@"
echo "Input equals"
echo $input
if [ $(echo $input|grep "@"|wc -l) -gt 0 ]
	then privateKey=0
                user=$(echo $input|grep -o "[^ ]*@[^ ]*"|sed s/@.*//)
                host=$(echo $input|grep -o "[^ ]*@[^ ]*"|sed s/.*@//)
                if [ $(echo $input|grep -o "[^ ]*@[^ ]*"|sed s/.*@//|tr -cd '.'|wc -c) -lt 2 ]
                        then domain=$(echo $input|grep -o "[^ ]*@[^ ]*"|sed s/.*@//)
                        else domain=$(echo $input|grep -o "[^ ]*@[^ ]*"|sed s/.*@//|awk -v OFS="." -F "." 'NF>=3{$1="*";print}')
                fi
                if [ $(echo $input|grep "\-i"|wc -l) -gt 0 ]
                        then positionCounter=1
			echo "Identity Exists"
                        while [ "$positionCounter" -le $(( $(echo $input|wc -w) - 1 )) ]
                                do if [ "$(echo $input|awk -v counter=$positionCounter '{print $counter}')" == "-i" ]
                                        then privateKeyPosition=$(( $positionCounter + 1 ))
                                        privateKey=$(echo $input|awk -v counter=$privateKeyPosition '{print $counter}')
                                        break
                                        else ((positionCounter++))
                                fi
                        done
                fi
                parseconfig
                else echo "$input"
		echo "not parsed"
        fi

#old for loop
#for hosts in $(cat ~/hosts);
#	do if [ $(echo $hosts|grep "@"|wc -l) -gt 0 ]
#		then privateKey=0
#		echo "User"
#		user=$(echo $hosts|grep -o "[^ ]*@[^ ]*"|sed s/@.*//)
#		echo $user
#		echo "Host"
#		host=$(echo $hosts|grep -o "[^ ]*@[^ ]*"|sed s/.*@//)
#		echo $host
#		echo "Domain"
#		if [ $(echo $hosts|grep -o "[^ ]*@[^ ]*"|sed s/.*@//|tr -cd '.'|wc -c) -lt 2 ]
#			then domain=$(echo $hosts|grep -o "[^ ]*@[^ ]*"|sed s/.*@//)
#			else domain=$(echo $hosts|grep -o "[^ ]*@[^ ]*"|sed s/.*@//|awk -v OFS="." -F "." 'NF>=3{$1="*";print}')
#		fi
##		echo $domain
#		if [ $(echo $hosts|grep "\-i"|wc -l) -gt 0 ]
#			then positionCounter=2
#			while [ "$positionCounter" -le $(( $(echo $hosts|wc -w) - 1 )) ]
#				do if [ "$(echo $hosts|awk -v counter=$positionCounter '{print $counter}')" == "-i" ]
#					then privateKeyPosition=$(( $positionCounter + 1 ))
#					privateKey=$(echo $hosts|awk -v counter=$privateKeyPosition '{print $counter}')
##					echo "PrivateKey"
##					echo $privateKey
#					break
#					else ((positionCounter++))
#				fi
#			done
#		fi
#		parseconfig
#		else echo "$hosts"
#	fi
#	done


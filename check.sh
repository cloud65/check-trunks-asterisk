#!/bin/sh
USER_ID=$1
TELEGRAM_BOT_TOKEN=$2

ASTERISK='/usr/sbin/asterisk'
MESSAGE=""


TRUNKS=$($ASTERISK -rx "pjsip show registrations"| grep "REG-SIP")
ALLTRUNKS=$(echo "$TRUNKS" | wc -l)
REGTRUNKS=$(echo "$TRUNKS" | grep " Registered" | wc -l)
if [ "$REGTRUNKS" -lt "$ALLTRUNKS" ]
then
	UNREG=$(echo "$TRUNKS" | grep -v " Registered" | sed -r 's/^ *//' | cut -d' ' -f1 | cut -d'/' -f1)

	for TRUNK in $UNREG
	do  
		MESSAGE="$MESSAGE$TRUNK\n"
		$ASTERISK -rx "pjsip send register $TRUNK"
	done
	
	MESSAGE=$(echo -e "Запущена перерегистрация транков:\n$MESSAGE")	

	DATA='{"chat_id": "'$USER_ID'", "text": "'$MESSAGE'", "disable_notification": true}'
	
	curl -X POST \
		 -H 'Content-Type: application/json' \
		 -d "$DATA" \
		 https://api.telegram.org/bot$TELEGRAM_BOT_TOKEN/sendMessage \
		 -s --output /dev/null	
fi


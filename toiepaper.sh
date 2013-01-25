#!/bin/bash
#		
#
#		Times of India (TOI) Daily downloader
#
#		Add this to your cron job as a daily script and this does its job
#
#		This checks your environment variable $TOIE to save the pdf
#		To Download Any other edition other than Bangalore's, change the city
#			
#		Other Cities ...
#
#		 Delhi		CAP
#		 Mumbai		TOIM
#		 Chennai	TOICH
#		 Hyderabad	TOIH
#		 Ahmedabad	TOIA
#		 Kolkata	TOIKM
#		 Kochi		TOIKRKO
#		 Jaipur		TOIJ
#		 Lucknow	TOIL
#		 Pune		TOIPU
#
#		sathanandh[@]gmail[.]com
#
#
edition="TOIBG"
#
#	change the city code to any of the above valid option
#
#
#
#
#
#
#
#day=$(date -d"01/24/2013" +%d)
#month=$(date -d"01/24/2013" +%m)
#year=$(date -d"01/24/2013" +%Y)

if [ -n "$TOIE" ]; 
then  
	location=$TOIE ;
else 
	location="$HOME/Books/TOIEpaper"
fi

day=$(date +%d)
month=$(date +%m)
year=$(date +%Y)
uday=$(printf %d $day)
umonth=$(printf %d $month)
uyear=$(printf %d $year)
npage=$(printf %.4d $page)

today=$(date | awk '{print $3 "-"$2"-" $6}')
page="1"

if [ ! -d "$location/$today" ]; then 
	echo "Creating a new folder...........at $location";
	cd $location
	mkdir $today
	cd $today
else
	cd "$location/$today"
fi

wget --cookies=on --keep-session-cookies --save-cookies cookie --post-data "pub=TOI&user=default&edition=Mumbai&version=standard" --timeout 10 -O x "http://epaper.timesofindia.com/processCookie.asp?pub=TOI&user=default&edition=Mumbai&version=standard" --debug

wget --cookies=on --keep-session-cookies --load-cookies cookie --save-cookies cookie -O x --timeout 10 "http://epaper.timesofindia.com/Default/Scripting/ArchiveView.asp?Daily=${edition}&AppName=1&login=default&pub=TOI&Skin=TOINEW&Enter=true&BaseHref=${edition}/${year}/${month}/${day}&Page=1﻿"

wget --cookies=on --keep-session-cookies --load-cookies cookie --timeout 10 -O x "http://epaper.timesofindia.com/Default/Scripting/ArchiveView.asp?Daily=${edition}&showST=true&login=default&pub=TOI&Enter=true&Skin=TOINEW&AppName=1"


wget --cookies=on --keep-session-cookies --save-cookies cookie --load-cookies cookie --timeout 10 -O 1.gif  "http://epaper.timesofindia.com/epsignup/captcha.aspx?token=0.705541077733014"


side=$(cat x|grep page)
max=$(expr "$side" : ".*page='\([^']*\)")
echo $max
#exit
for((i=1;i<=$max;i++))
do

	page=$i
	key=$(grep "key" cookie | cut  -f7)
	if [ ! -f ${page}.pdf ]
	then
		wget --cookies=on --keep-session-cookies --server-response ss --save-cookies newfile --load-cookies cookie --timeout 10 -O "${page}.pdf" "http://epaper.timesofindia.com/epsignup/downloadPDF.aspx?pdfPath=%2FRepository%2F${edition}%2F${year}%2F${month}%2F${day}%2F${edition}_${uyear}_${umonth}_${uday}_${page}.pdf&_captcha_text=${key}" 

		var=$(file ${page}.pdf)
		if [[ ! $var =~ .*PDF* ]]
		then 
			rm ${page}.pdf
			echo "Download error -deleting the html file"
		else
			echo "Done";
		fi


	else 
		echo "Already there"
	fi

done

nof=$(ls -1 *.pdf | wc -l)
if [[ $nof -eq $max ]]
then 
	echo "fine"
	today=$(date | awk '{print $3 "-"$2"-" $6}')
	args=$(ls *.pdf |sort -n|xargs echo)
	pdftk $args cat output ../$today.pdf
	rm 1.gif cookie x newfile

else
	echo "not fine"
	sleep 60
	cd ${HOME}  #any other location where this file exists
	bash $0
fi
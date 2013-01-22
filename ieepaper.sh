#!/bin/bash
#		
#
#		Indian Express (IE) Daily downloader
#
#		Add this to your cron job as a daily script and this does its job
#
#		This checks your environment variable $IEE to save the pdf
#		To Download Any other edition other than Delhi's change the city
#			
#		Other Cities ...
#
#		 Delhi
#		 Mumbai
#		 Chandigarh
#		 Pune
#		 Ahmedabad
#		 Kolkata
#		 Lucknow
#
#		sathanandh[@]gmail[.]com
#
#
CITY="Delhi"
#
#	change the city to any of the above valid option
#
if [ -n "$IEE" ]; 
then  
	location=$IEE ;
else 
	location="$HOME/Books/IEEpaper"
fi


today=$(date | awk '{print $3 "-"$2"-" $6}')
if [ ! -d "$location/$today" ]; then 
	echo "Creating a new folder...........at $location";
	cd $location
	mkdir $today
	cd $today

if [ "$CITY" == "Delhi" ]; 
then 

	orig="http://epaper.indianexpress.com/t/226/latest/Indian-Express"
else
	paper=$(curl "http://epaper.indianexpress.com/" | grep -E ".*http.*latest.*${CITY}")
	orig=$(expr "$paper" : '.*href="\([^"]*\)')

fi
	r=$(curl -L $orig)
	id=$(expr "$r" : ".*'volumeId': \([^,]*\).*")
	pages=$(expr "$r" : ".*'numPages': \([^,]*\).*")

	for (( i=1;i <= $pages; i++ ))
	do
		wget -O $i.pdf "http://epaper.indianexpress.com/pdf/get/$id/$i"
	done
	args=$(ls * |sort -n|xargs echo)
	pdftk $args cat output $today.pdf
	mv $today.pdf ../$today.pdf


else    
	echo "Todays downloaded Files already exist..."; 
	echo "----- ---- ---- ---- ---- ---- ---- ----";
fi






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
#
#		sathanandh[@]gmail[.]com
#
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

	r=$(curl -L "http://epaper.indianexpress.com/t/226/latest/Indian-Express")
	id=$(expr "$r" : ".*'volumeId': \([^,]*\).*")
	pages=$(expr "$r" : ".*'numPages': \([^,]*\).*")

	for (( i=1;i <= $pages; i++ ))
	do
		wget "http://epaper.indianexpress.com/pdf/get/$id/$i"
		mv $i $i.pdf
	done
	args=$(ls * |sort -n|xargs echo)
	pdftk $args cat output $today.pdf
	mkdir temp
	mv $args temp/


else    
	echo "Todays downloaded Files already exist..."; 
	echo "----- ---- ---- ---- ---- ---- ---- ----";
fi






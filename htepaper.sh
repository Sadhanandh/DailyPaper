#!/bin/bash
#		
#		
#				Hindustan Times (HT) Pdf downloader
#	
#	Attention !!! : Please read through and consider subscribing to their digital-edition (e-edition)
#
#	This is only for the needy and poor!
#	Please consider subscribing to their e-edition. 
#	The e-editions are more suitable for viewing in
#		Tablets and mobiles.
# 	E-editions are available in lighter and navigable formats.
#	Moreover the e-editions are really inexpensive.
#	A months subscription is lesser than a cup of coffee !!
#	
#	Good Journalism takes lots of effort and promote them by subscribing to
#		the e-edition.
#   (Try Reading -> "The Millenium Triology" to understand the journalist's toil. )
#
#	Democracy is sutained by journalism and by subscribing to e-editions 
#		you are directly helping in promoting and sustaining democracy
#
#		so follow the link below to subscribe e-editions
#	http://payment.epaper.timesofindia.com/epsignup/signup.aspx
#


#
#		Hindustan Times (HT) Daily downloader
#
#		Add this to your cron job as a daily script and this does its job
#
#		This checks your environment variable $HTE to save the pdf
#		To Download Any other edition other than Delhi's change the city
#		
#		Other Editions..
#
#		 Delhi
#		 Chandigarh
#		 Bhopal
#		 Jaipur
#		 Indore
#		 Lucknow
#		 Patna
#		 Ranchi
#		 Kolkata
#		 Mumbai
#
#
#		sathanandh[@]gmail[.]com
#
#

CITY="Delhi"

#Change the city to one of the above valid options

if [ -n "$HTE" ]; 
then  
	location=$HTE ;
else 
	location="$HOME/Books/HTEpaper"
fi

today=$(date | awk '{print $3 "-"$2"-" $6}')
if [ ! -f "$location/$today.pdf" ]; then 
	echo "Ready to download at $location";
	cd $location
	day=$(date +%m | xargs printf "%0d")
	month=$(date +%d | xargs printf "%0d")
	year=$(date +%Y)
	init=$(curl "http://paper.hindustantimes.com/epaper/homepage_v2.aspx?date=$day.$month.$year&width=1366"|grep -E ".*issue.*\(${CITY}\)")
	number=$(expr "$init" : ".*issue=\([^']*\)")
	response=$(curl "http://paper.hindustantimes.com/epaper/PageViewManager.aspx?action=download&issue=$number&page=1&page2=1&cpage=1&cpage2=1")
	link=$(expr "$response" : '.*href="\([^"]*\)" target')

	wget -O $today.pdf $link



else    
	echo "Todays downloaded Files already exist..."; 
	echo "----- ---- ---- ---- ---- ---- ---- ----";
fi




====DailyPaper
These are the scripts﻿ to automate the download of Indian newspapers everyday.

Indian Express  IE
Times of India	TOI
Hindustan Times	HT

==Optional requirement ->

pdftk - this is needed to merge the pdf's -> each page is downloaded separately and this is required to "stich" these pages together.


Add the script to your cron job.

The default folder to store the pdf is "~/Books/$NAMEOfThePAPER"

To save it in the preferred folder 
set your environment variable

Eg ->for HT it is $HTE
add this line to your .bashrc

export HTE="$HOME/MY/FOLDER"

If the script stops functioning -> mail me.

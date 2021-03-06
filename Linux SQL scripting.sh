#! /bin/bash
clear
echo " > Reading contents of directory"
ls -v1 *.sql > orderedList.txt
echo " > Contents sorted and stored in orderedList.txt"
echo " > "
echo " > Running database queries"
	while IFS= read -r cmd; do 
# extract numeric part of filename
	VERSIONID="${cmd//[!0-9]/}"
# Get current version
	CURRENTVID=$( sqlite3 mydatabase.db "select * from version" )
# compare versions and only execute if newer version
	if [ $VERSIONID -gt $CURRENTVID ]
	then
		while IFS= read -r cmd; do 
			eval sqlite3 mydatabase.db $cmd
			eval sqlite3 mydatabase.db \'update version set versionid = $VERSIONID\'
		done < $cmd
	
else 
	echo " > Latest version is already on the database"
fi
done < orderedList.txt
echo " > "

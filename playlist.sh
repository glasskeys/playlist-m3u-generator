#!/bin/bash

#Create Empty File With m3u Extension
filename=$(basename "$1")
filename="${filename%.*}.m3u"
echo -n "" > "$filename"

#Get The First Non-Loopback Local IP Address
interfaces=$(ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0.1')

ipos=$(echo $interfaces | awk 'match($0," "){print RSTART}')
if [ -n "$ipos" ]; then
	tmp=$(echo $interfaces | grep -o " .*")
	ip=${tmp:1}
else
	ip="$interfaces"
fi

#Convert Each Line Into A Web Link
while IFS='' read -r line || [[ -n $line ]]; do
	
	pos=$(echo $line | awk 'match($0,"Music"){print RSTART}')

	if [ -n "$pos" ]; then
  	
 		tmp=$(echo $line | grep -o "Music.*")
				
		musicfile=$(php -r "echo str_replace('%2F', '/', rawurlencode(\"$tmp\"));")
	    musiclink="http://$ip/$musicfile"	
		echo "$musiclink" >> "$filename"
	fi
done < "$1"
echo "Finished."

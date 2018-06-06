#!/bin/bash
page=1
rm -f jeter.txt
touch jeter.txt
while [ ${page} -gt  0 ]; do
	WC1=$(wc -l < jeter.txt)
	wget -q -O - "https://www.biostars.org/u/$1/?page=${page}&sort=update&limit=all time&q=" | \
		xmllint --xpath "//a[starts-with(@href,'/p/')]/@href" --html - 2> /dev/null |\
		tr " " "\n" | cut -d '"' -f 2 | grep -E '^/p/[0-9]+/$' >> jeter.txt
	sort jeter.txt | uniq > jeter2.txt
	WC2=$(wc -l <  jeter2.txt)
	mv jeter2.txt jeter.txt
	if [ ${WC1} -ne ${WC2} ] ; then
			let page=page+1
	else
			let page=0
	fi
done
cat jeter.txt

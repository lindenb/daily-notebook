# pdf size in bioarxiv..
seq 1 1850 | while read P;
do
	wget -q -O - "https://www.biorxiv.org/content/early/recent?page=${P}" |\
		xmllint --html   --xpath '//a[starts-with(@href,"/content/early/")]/@href' - 2> /dev/null |\
		tr '"' '\n' | grep '^/content' | grep -v '/recent' | while read A;
		do
				echo  -n "${A}	"
				wget -q -O - "https://www.biorxiv.org${A}.full.pdf" |wc -c
		done
done
	

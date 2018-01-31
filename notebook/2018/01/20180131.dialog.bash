#!/bin/bash
## zenity interface to jvarkit/vcffilterjdk see https://www.biostars.org/p/296145/

set -e

code=$(mktemp --suffix .code -t tmp.XXXXXXXXXX)
function cleanup {
  rm -vf "${code}"
}
trap cleanup EXIT


INVCF=$(zenity --file-selection --title="Select input VCF" --file-filter "*.vcf *.vcf.gz")
OUTVCF=$(zenity --save --confirm-overwrite --file-selection --title="Select output VCF" --file-filter "*.vcf *.vcf.gz")

if [ "${INVCF}" == "${OUTVCF}" ]; then
  zenity  --title="ERROR" --error --text="input same as output (${INVCF})"
  exit -1
fi

zenity --width=1000 --title="CODE" --entry --text="Java Code" --entry-text="return variant.getStart()%10==0;" > ${code}

## set the correct path
java -jar ${HOME}/src/jvarkit/dist/vcffilterjdk.jar  -o "${OUTVCF}" -f "${code}" ${INVCF}

zenity  --title="DONE" --info --text="Done:${OUTVCF}" 

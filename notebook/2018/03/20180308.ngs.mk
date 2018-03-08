# get the list of fastqs - R1 only
FQ=$(shell find /home/lindenb/src/jvarkit-git/src/test/resources/ -type f -name "*.R1.fq.gz")
# reference genome
REF=/home/lindenb/src/jvarkit-git/src/test/resources/rotavirus_rf.fa
.PHONY:all

# function used to extract a name from a fastq: we remove the suffix .R1.fq.gz and the directory
define sample
$(notdir $(subst .R1.fq.gz,,$(1)))
endef

# function used create a recipe fastq->sam
# argument $1 is a Fastq R1
# target is the sample-name + ".sam" extension
# depencies are : REF, the fastq-R1, the fastq R1 -> replace R1.fq.gz with R2.fq.gz

define run
$$(addsuffix .sam,$$(call sample,$(1))): $(REF) $(1) $$(subst .R1.fq.gz,.R2.fq.gz,$(1))
	bwa mem \
		 -R '@RG\tID:$$(call sample,$(1))\tSM:$$(call sample,$(1))\tLB:Trusight_custom_amplicon_CARR\tPL:ILLUMINA\tPI:150' \
		 -k 19 -A 1 -B 4 -O 6 -L 5  \
		$$(word 1,$$^) \
		$$(word 2,$$^) \
		$$(word 3,$$^) > $$@
endef

# final target:  extract the sample names from the R1.fastq and add the suffix '.sam'
all: $(addsuffix .sam,$(call sample,$(FQ)))

$(foreach S,$(FQ),$(eval $(call run,$S)))

## http://plindenbaum.blogspot.fr/2014/12/divide-and-conquer-in-makefile.html

## https://gist.github.com/lindenb/9a8601dc5c84f045845a339e7a817786

BAMS=/home/lindenb/src/jvarkit-git/src/test/resources/S3.bam \
	/home/lindenb/src/jvarkit-git/src/test/resources/S2.bam \
	/home/lindenb/src/jvarkit-git/src/test/resources/S1.bam \
	/home/lindenb/src/jvarkit-git/src/test/resources/S5.bam \
	/home/lindenb/src/jvarkit-git/src/test/resources/S4.bam
	
OUTDIR=TMP


define recursive


ifeq  ($(shell echo  "$(2)-$(1)" | bc),0)


else ifeq  ($(shell echo  "$(2)-$(1)" | bc),1)

$(OUTDIR)/target$(1)_$(2).tsv : $$(word $$(shell echo  "$(1)+1" | bc),$(3))
	mkdir -p $$(dir $$@) && \
	echo "#CHOM_POS	$$(notdir $$(basename $$<))" > $$@ && \
	samtools depth -a $$< | sed 's/	/_/' | LC_ALL=C sort -k1,1 >> $$@


else

$(OUTDIR)/target$(1)_$(2).tsv : $$(addprefix $(OUTDIR)/target, $$(addsuffix .tsv,  $(1)_$$(shell echo  "$(1) + ($(2)-$(1)) /2 " | bc) $$(shell echo  "$(1) + ($(2)-$(1)) /2 " | bc)_$(2) ))
	LC_ALL=C join -t '	' -1 1 -2 1 $$(word 1,$$^) $$(word 2,$$^) > $$@

$$(eval $$(call recursive,$(1),$(shell echo  "$(1) + ($(2)-$(1)) /2 " | bc),$(3)))
$$(eval $$(call recursive,$(shell echo  "$(1) + ($(2)-$(1)) /2 " | bc),$(2),$(3)))

endif


endef


all: $(OUTDIR)/target0_$(words ${BAMS}).tsv
	head $< | column -t

$(eval $(call recursive,0,$(words ${BAMS}),${BAMS}))


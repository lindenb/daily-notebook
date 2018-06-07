package org.broadinstitute.gatk.engine.filters;
import htsjdk.samtools.*;
import org.apache.log4j.Logger;
import org.broadinstitute.gatk.utils.commandline.Argument;
import org.broadinstitute.gatk.engine.filters.*;
import org.broadinstitute.gatk.engine.GenomeAnalysisEngine;

/**
 * author: Pierre Lindenbaum PhD
 */
public class ClippedReadFilter extends ReadFilter {
	private static Logger logger = Logger.getLogger(ClippedReadFilter.class);
	@Argument(fullName = "minfraction", shortName = "minfraction", doc="minimum fraction of the read that must be clipped", required=true)
	private double fraction=0f;

	public ClippedReadFilter() {
		}
	
	@Override
	public void initialize(final GenomeAnalysisEngine engine) {
		if( this.fraction <= 0f || this.fraction > 1f) throw new IllegalArgumentException("error 0 < fraction <1");
		}
    
	@Override
	public boolean filterOut(final SAMRecord read) {
	if(read.getReadUnmappedFlag() ||
		read.isSecondaryOrSupplementary() ||
		read.getReadFailsVendorQualityCheckFlag() ||
		read.getDuplicateReadFlag()) return true;

	final Cigar cigar = read.getCigar();
	double len = 0.0;
	double cliplen= 0.0;

	if( cigar==null || cigar.numCigarElements() <2 ) return true;

	for (final CigarElement ce : cigar) {
	    final CigarOperator op = ce.getOperator();            
	    if(op.isClipping()) cliplen += ce.getLength();
	    if(op!=CigarOperator.P) len += ce.getLength();
	    }
	return len<=0.0 || cliplen/len < this.fraction;
	}
}


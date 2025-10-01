

String _makeKey(s,o) {
    if(o instanceof List) {
        for(int i=0;i< o.size();i++) {
            s=_makeKey(s,o[i]);
        }
    } else if(o instanceof java.nio.file.Path) {
            s+= o.toRealPath().toString();
    } else {
       throw new IllegalArgumentException("${o.getClass()}");
    }
    return s;
}
String makeKey(o) {
    return _makeKey("",o).md5();
}

workflow DIVIDE_AND_CONQUER {
take:
    meta
    level
    gvcfs_bed
main:
    ch1 = gvcfs_bed
        .map{[it[0].plus(combine_key:makeKey([it[1].sort(),it[2]])),it[1],it[2]]}
    
    expect_ch = ch1.map{[it[0].combine_key,it]}

    GATK_COMBINE(level, ch1)

    combine_out_ch = GATK_COMBINE.out.gvcf.map{[it[0].combine_key,it]}

    join_ch = expect_ch.join(combine_out_ch,  remainder: true)
    failed_ch = join_ch.filter{it[2]==null}
        .map{it[1]}
        .map{[it[0].findAll {v->v.key != 'combine_key'},it[1],it[2]]}
        //.view{"### FAILED : $it"}
    REDUCE(failed_ch)
    failed_gvcf_bed = REDUCE.out.beds.map{meta,vcfs,bed->[[vcfs],bed]}
        .transpose()
        .map{vcf,bed->[[id:makeKey([vcf,bed])],vcf,bed]}
    
    sucess = GATK_COMBINE.out.gvcf
        .map{[it[0].findAll {v->v.key != 'combine_key'},it[1],it[2],it[3]]}
        //view{"### OK : $it"}

emit:
    failed_gvcf_bed
    combined_gvcf = sucess
}

process GATK_COMBINE {
errorStrategy "ignore"
input:
    val(level)
    tuple val(meta),path("VCFS/*"),path(bed)
output:
    tuple val(meta),path("*.vcf.gz"),path("*.vcf.gz.tbi"),path(bed),emit:gvcf
script:
"""

if ${level==1 || level==2}
then
    false
fi
touch ${meta.id}.g.vcf.gz
touch ${meta.id}.g.vcf.gz.tbi
"""
}

process REDUCE {
input:
    tuple val(meta),path(vcfs),path(bed)
output:
    tuple val(meta),path(vcfs),path("BEDS/*.bed"),emit:beds
script:
    def njobs=10
    def prefix="x1"
"""
mkdir -p BEDS

awk -F '\t' '{
    B=int(\$2);
    E=int(\$3);
    N=E-B;
    if(N<=1) next;
    DX=int(N/${njobs});
    if(DX<1) DX=1;
    while(B < E) {
        E2 = B+DX;
        if(E2 > E) E2 = E;
        printf("%s\t%d\t%d\\n",\$1,B,E2);
        B+=DX;
        }
    }' ${bed} |\\
    split -a 9 --additional-suffix=.bed --lines=1 - BEDS/${prefix}.${bed.name.md5()}
"""
}
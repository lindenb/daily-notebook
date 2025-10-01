include {DIVIDE_AND_CONQUER as DIVIDE_AND_CONQUER1} from './sub.nf'
include {DIVIDE_AND_CONQUER as DIVIDE_AND_CONQUER2} from './sub.nf'
include {DIVIDE_AND_CONQUER as DIVIDE_AND_CONQUER3} from './sub.nf'
include {DIVIDE_AND_CONQUER as DIVIDE_AND_CONQUER4} from './sub.nf'
include {DIVIDE_AND_CONQUER as DIVIDE_AND_CONQUER5} from './sub.nf'
include {DIVIDE_AND_CONQUER as DIVIDE_AND_CONQUER6} from './sub.nf'


workflow  {
    PREPARE_BED(Channel.of(1,2,3).map{[id:it]})
    PREPARE_DATA(Channel.of("A","B","C").map{[id:it]}.combine(PREPARE_BED.out.bed.map{it[1]}))
ch1 = PREPARE_DATA.out.gvcf
    .map{meta,vcf,tbi,bed->[bed.toRealPath(),[vcf,tbi]]}
    .groupTuple()
    .map{[[id:it[0].toString().md5()],it[1].flatten(),it[0]]}
    
COMBINE_GVCF([id:"todo"],ch1)
}

process PREPARE_BED {
input:
    val(meta)
output:
    tuple val(meta),path("*.bed"),emit:bed
script:
"""
echo 'chr${meta.id}\t0\t10000' > ${meta.id}.bed
"""
}

process PREPARE_DATA {
input:
    tuple val(meta),path(bed)
output:
    tuple val(meta),path("*.vcf.gz"),path("*.vcf.gz.tbi"),path(bed),emit:gvcf
script:
"""
touch ${bed.name}.sample${meta.id}.g.vcf.gz
touch ${bed.name}.sample${meta.id}.g.vcf.gz.tbi
"""
}

workflow COMBINE_GVCF {
take:
    meta
    gvcfs_bed
main:
    combined_gvcf = Channel.empty()

    DIVIDE_AND_CONQUER1(meta,1,gvcfs_bed)
    combined_gvcf = combined_gvcf.mix(DIVIDE_AND_CONQUER1.out.combined_gvcf)

    DIVIDE_AND_CONQUER2(meta,2,DIVIDE_AND_CONQUER1.out.failed_gvcf_bed)
    combined_gvcf = combined_gvcf.mix(DIVIDE_AND_CONQUER2.out.combined_gvcf)
    
    DIVIDE_AND_CONQUER3(meta,3,DIVIDE_AND_CONQUER2.out.failed_gvcf_bed)
    combined_gvcf = combined_gvcf.mix(DIVIDE_AND_CONQUER3.out.combined_gvcf)

    DIVIDE_AND_CONQUER4(meta,4,DIVIDE_AND_CONQUER3.out.failed_gvcf_bed)
    combined_gvcf = combined_gvcf.mix(DIVIDE_AND_CONQUER4.out.combined_gvcf)

    DIVIDE_AND_CONQUER5(meta, 5,DIVIDE_AND_CONQUER4.out.failed_gvcf_bed)
    combined_gvcf = combined_gvcf.mix(DIVIDE_AND_CONQUER5.out.combined_gvcf)

    DIVIDE_AND_CONQUER6(meta, 6,DIVIDE_AND_CONQUER5.out.failed_gvcf_bed)
    combined_gvcf = combined_gvcf.mix(DIVIDE_AND_CONQUER6.out.combined_gvcf)

    combined_gvcf.view{"COMBINED : ${it}"}
}
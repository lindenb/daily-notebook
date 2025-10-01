String toFilePath(Object id,int level) {
	def dir2 = id;
	def f= ""+workflow.workDir + "/FLAG/L"+level+ "/" + dir2.substring(0,2) + "/" + dir2.substring(2);
       return f;
	}


Object toFailurePath(Object id,int level) {
	return file(toFilePath(id,level)+".failed");
	}
Object toSuccessPath(Object id,int level) {
	return file(toFilePath(id,level)+".ok");
	}

boolean isClusterError(task) {
	if(task==null) return false;
	if(task.previousException == null) return false;
	String s = task.previousException.message;
	if(s.startsWith("Error submitting process ") && s.endsWith("for execution")) {
		return true;
		}
	return false;
	}



void _makeKey(digest,o) {   
    if(o==null) {
        digest.update((byte)0);
        }
    else if(o instanceof List) {
        digest.update((byte)'[');
        for(int i=0;i< o.size();i++) {
            _makeKey(digest,o[i]);
            if(i>0) digest.update((byte)',');
        }
       digest.update((byte)']');
    } else if(o instanceof Map) {
        def keys = o.keySet().sort()
        digest.update((byte)'[');
        for(int i=0;i< keys.size();i++) {
            _makeKey(digest,keys[i]);
             digest.update((byte)':');
             _makeKey(digest,o.get(keys[i]));
            if(i>0) digest.update((byte)',');
        }
       digest.update((byte)']');
    }
    else if(o instanceof java.lang.String) {
            digest.update(o.getBytes("UTF-8"));
    } else if(o instanceof java.nio.file.Path) {
           _makeKey(digest,o.toRealPath().toString());
    } else {
       throw new IllegalArgumentException("${o.getClass()}");
    }
}
    
String makeKey(o) {
    java.security.MessageDigest md5 = java.security.MessageDigest.getInstance("MD5");
    _makeKey(md5,o);
    java.math.BigInteger bigInt = new java.math.BigInteger(1, md5.digest());
    String s= "K"+bigInt.toString(16);
    return s;
}



workflow DIVIDE_AND_CONQUER {
take:
    metadata
    level
    gvcfs_bed
main:
    ch1 = gvcfs_bed
        .map{meta,vcf_files,bed->[meta,vcf_files.sort(),bed]}
        .map{meta,vcf_files,bed->[meta.plus(combine_key:makeKey([vcf_files,bed])),vcf_files,bed]}
        .map{meta,vcf_files,bed->[meta.plus(file:toFilePath([meta.combine_key,level])),vcf_files,bed]}
    
    ch2 = ch1.branch{meta,vcf_files,bed->
        known_to_success : toSuccessPath(meta.combine_key,level).exists()
        known_to_fail: toFailurePath(meta.combine_key,level).exists()
        todo: true
    }


    //ch2.known_to_success.view{"L${level} KNOWN TO SUCCESS: ${it}"}
    //ch2.known_to_fail.view{"L${level} KNOWN TO FAIL: ${it}"}
    //ch2.todo.view{"L${level} TODO : ${it}"}

    expect_ch = ch2.todo.map{meta,vcf_files,bed->[meta.combine_key,[meta,vcf_files,bed]]}

    GATK_COMBINE(level, ch2.todo)

    combine_out_ch = GATK_COMBINE.out.gvcf.map{meta,vcf,tbi,bed->[meta.combine_key,[meta,vcf,tbi,bed]]}

    join_ch = expect_ch.join(combine_out_ch,  remainder: true)

    TOUCH_FAILED(level, join_ch
        .filter{combine_key,row1,row2->row2==null}
        .map{combine_key,row1,row2->combine_key}
        )

    failed_ch = join_ch
        .filter{combine_key,row1,row2->row2==null}
        .map{combine_key,row1,row2->row1}
        //.view{"### FAILED : $it"}
    REDUCE(failed_ch.mix(ch2.known_to_fail))

    failed_gvcf_bed = REDUCE.out.beds
        .map{meta ,vcf_files,beds ->{
                def L1=[];
                def L2 = (beds instanceof List?beds:[beds]);
                for(int i=0;i< beds.size();i++ ) {
                    L1.add([vcf_files.collect() /* collect! otherwise concurrent mofification */,beds[i]]);
                    }
                return L1;
                }
            }
        .flatMap()
        .map{vcf_files,bed->[[id:makeKey([vcf_files,bed])],vcf_files,bed]}


    
    
    TOUCH_SUCCESS(level,GATK_COMBINE.out.gvcf)

    success = TOUCH_SUCCESS.out.gvcf
        .map{meta,vcf,tbi,bed->[meta.findAll {v->v.key != 'combine_key'},vcf,tbi,bed]}
        //view{"### OK : $it"}
   

    success = success.mix(
        ch2.known_to_success
            .map{meta,vcf_files,bed->toSuccessPath(meta.combine_key,level)}
            .splitCsv(header:false,sep:',')
            .map{metaid,vcf,tbi,bed->[[id:metaid],file(vcf),file(tbi),file(bed)]}
        )

emit:
    failed_gvcf_bed
    combined_gvcf = success
}

process GATK_COMBINE {
tag "${meta.id} ${meta.combine_key}"
errorStrategy  = {isClusterError(task)?"terminate":"ignore"}
input:
    val(level)
    tuple val(meta),path("VCFS/*"),path(bed)
output:
    tuple val(meta),path("*.vcf.gz"),path("*.vcf.gz.tbi"),path(bed),emit:gvcf
script:
    def prefix ="L"+level+"."+meta.id;
"""

if ${level==1 || level==2}
then
    false
fi
find VCFS/ -name "*.vcf.gz" | sort | paste -sd ';' | awk '{printf("%s\t${bed.toRealPath()}\\n",\$0);}' > ${prefix}.g.vcf.gz
touch ${meta.id}.g.vcf.gz.tbi
"""
}

process REDUCE {
tag "${meta} ${bed}"
input:
    tuple val(meta),path(vcfs),path(bed)
output:
    tuple val(meta),path(vcfs),path("BEDS/*.bed"),emit:beds
script:
    def njobs=10
    def prefix="x${njobs}"
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
    split -a 9 --additional-suffix=.bed --lines=1 - BEDS/${prefix}.${bed.toRealPath().toString().md5()}
"""
}

process TOUCH_FAILED {
executor "local"
tag "${combine_key} L${level}"
input:
    val(level)
    val(combine_key)
script:
    def f=toFailurePath(combine_key,level)
"""
mkdir -p "${f.parent}"
echo '${combine_key}' > ${f}
"""
}

process TOUCH_SUCCESS {
executor "local"
tag "${meta.combine_key} L${level} ${vcf.name} ${bed.name}"
input:
    val(level)
    tuple val(meta),path(vcf),path(tbi),path(bed)
output:
    tuple val(meta),path(vcf),path(tbi),path(bed),emit:gvcf
script:
    def f=toSuccessPath(meta.combine_key,level)
"""
mkdir -p "${f.parent}"
echo '${meta.combine_key},${vcf.toRealPath()},${tbi.toRealPath()},${bed.toRealPath()}' > ${f}
"""
}
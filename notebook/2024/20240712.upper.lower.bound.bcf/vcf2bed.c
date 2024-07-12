#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <assert.h>
#include <errno.h>
#include <htslib/hts.h>
#include <htslib/vcf.h>
#include <htslib/tbx.h>
#define WHERE do {fprintf(stderr,"[%s:%d]",__FILE__,__LINE__);} while(0)
#define WARNING(...) do { fputs("[WARNING]",stderr);WHERE;fprintf(stderr,__VA_ARGS__);fputc('\n',stderr);} while(0)
#define ERROR(...) do { fputs("[ERROR]",stderr);WHERE;fprintf(stderr,__VA_ARGS__);fputc('\n',stderr);abort();} while(0)


int main(int argc,char** argv) {
int ret=0;
htsFile *in = hts_open(argv[1],"r");
tbx_t *idx = NULL;

if(in==NULL) {
    ERROR("Cannot open input vcf %s.\n",strerror(errno));
    return EXIT_FAILURE;
    }
bcf_hdr_t *header = bcf_hdr_read(in);
if(header==NULL) {
    ERROR("Cannot read header for input vcf.");
    return EXIT_FAILURE;
    }

idx = tbx_index_load(argv[1]);
if(idx==NULL) {
	ERROR("Cannot read index.");
        return EXIT_FAILURE;
	}


bcf1_t* bcf = bcf_init();
if(bcf==NULL) {
    ERROR("Out of memory.");
    return EXIT_FAILURE;
    }


tbx_destroy(idx);
bcf_destroy(bcf);
bcf_hdr_destroy(header);
hts_close(in);
if(ret<-1) {
    ERROR("IO error in input VCF.\n");
    return EXIT_FAILURE;
    }
return EXIT_SUCCESS;
}

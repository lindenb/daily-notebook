/*  vcftobed.c -- find first and last variant POS from indexed VCF

    Author: Pierre Lindenbaum github.com/lindenb

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
DEALINGS IN THE SOFTWARE.  */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <assert.h>
#include <errno.h>
#include <unistd.h>
#include <getopt.h>
#include <htslib/hts.h>
#include <htslib/vcf.h>
#include <htslib/tbx.h>
#include <htslib/bgzf.h>
#include <htslib/thread_pool.h>
#include <htslib/kseq.h>
#include <bcftools.h>
#define WHERE do {fprintf(stderr,"[%s:%d]",__FILE__,__LINE__);} while(0)
#define WARNING(...) do { fputs("[WARNING]",stderr);WHERE;fprintf(stderr,__VA_ARGS__);fputc('\n',stderr);} while(0)
#define ERROR(...) do { fputs("[ERROR]",stderr);WHERE;fprintf(stderr,__VA_ARGS__);fputc('\n',stderr);abort();} while(0)
#define error_errno error

typedef struct indexed_vcf_t {
	/** HTS file */
    htsFile* in;
    /** vcf header */
    bcf_hdr_t* hdr;
    /** tabix index or NULL */
    tbx_t* tbx_idx;
    /** CSI index or NULL */
    hts_idx_t* bcf_idx;
    /** number of indexed sequences */
    int nseq;
    /** sequences name */
    const char** ctg_names;
    /** current line for tabix */
    bcf1_t *rec;
    /** current variant */
    kstring_t line;
    } indexed_vcf_t;



typedef struct
{
	FILE* out;
    int n_threads;
    hts_tpool* threads;
}
args_t;

static int mystrtoll(const char* s,hts_pos_t* v) {
   char* end = NULL;
   *v = strtoll(s, &end, 10);
   if (end == s ||*end!=0 || *v < 0)
        {
        WARNING("Warning: cannot parse value \"%s\" as int\n",s);
        return -1;
        }
   return 0;
   }

static void indexed_vcf_close(indexed_vcf_t* reader) {
    if(reader==NULL) return;
    if(reader->tbx_idx!=NULL) tbx_destroy(reader->tbx_idx);
    if(reader->bcf_idx!=NULL) hts_idx_destroy(reader->bcf_idx);
    if(reader->hdr!=NULL) bcf_hdr_destroy(reader->hdr);
    if(reader->in!=NULL) hts_close(reader->in);
    if(reader->ctg_names!=NULL) free(reader->ctg_names);
    if(reader->rec!=NULL) bcf_destroy1(reader->rec);
    free(reader->line.s);
    free(reader);
    }


static indexed_vcf_t* indexed_vcf_open(args_t *args, const char* filename) {
    char* fnidx=NULL;
    if ( (fnidx = strstr(filename, HTS_IDX_DELIM)) != NULL ) {
            *fnidx=0;
            fnidx+= strlen(HTS_IDX_DELIM);
            }

    indexed_vcf_t* ptr=(indexed_vcf_t*)calloc(1UL,sizeof(indexed_vcf_t));
    ptr->in = hts_open(filename,"r");
    if(ptr->in==NULL) {
        indexed_vcf_close(ptr);
        error_errno("Cannot open %s\n",filename);
        return NULL;
        }
	if(args->threads!=NULL) {
		 /*if (hts_set_thread_pool(ptr->in, args->threads) < 0) {
		    hts_log_info("Could not set thread pool!");
		    }*/
     }

		
    ptr->hdr = bcf_hdr_read(ptr->in);
    if(ptr->hdr==NULL) {
        indexed_vcf_close(ptr);
        ERROR("Cannot read header.");
        return NULL;
        }
    ptr->bcf_idx = bcf_index_load3(filename,fnidx,HTS_IDX_SILENT_FAIL);
    if( ptr->bcf_idx==NULL) {
        ptr->tbx_idx = tbx_index_load3(filename,fnidx,0);
        if( ptr->tbx_idx==NULL ) {
            indexed_vcf_close(ptr);
            error("Cannot read index.");
            return NULL;
            }
        else
            {
            ptr->ctg_names= tbx_seqnames(ptr->tbx_idx, &(ptr->nseq));
            }
        }
    else {
        ptr->nseq = hts_idx_nseq(ptr->bcf_idx);
        }
    ptr->rec = bcf_init1();
    return ptr;
    }





const char* indexed_vcf_ctg_name(indexed_vcf_t* reader, int tid, hts_pos_t* len) {
        const char *ctg_name= reader->ctg_names==NULL? bcf_hdr_id2name(reader->hdr, tid)  : reader->ctg_names[tid];
        bcf_hrec_t *hrec = reader->hdr!=NULL ? bcf_hdr_get_hrec(reader->hdr, BCF_HL_CTG, "ID", ctg_name, NULL) : NULL;
        if(hrec==NULL)  {
            *len=0;
            return NULL;
            }
        int hkey = bcf_hrec_find_key(hrec, "length");

        if(mystrtoll(hrec->vals[hkey],len)!=0) {
            fprintf(stderr,"Warning: cannot determine contig \"%s\" for length:%s\n",ctg_name, hrec->vals[hkey]);
            return NULL;
            }
        return ctg_name;
        }
#define STATUS_ERROR -2
#define STATUS_NOT_FOUND -4

static int get_chrom_pos(indexed_vcf_t* reader, hts_pos_t *pos) {
    hts_pos_t pos1=0;
	char* p= reader->line.s;
	*pos=0;
    while(*p!=0 && *p!='\n' && *p!='\t') {
        ++p;
        }

    if(*p!='\t') {
        WARNING("boum");
         return -1;
        }
   	++p;
   while(*p!=0 && *p!='\n' && *p!='\t') {
        pos1= pos1*10 + (*p-(int)'0');
        ++p;
        }
  
   if(*p!='\t' ||pos1 <0) {
        WARNING("boum");
        return -1;
        }
    *pos=pos1-1;
    return 0;
    }

int indexed_vcf_find_first(indexed_vcf_t* reader,int tid,hts_pos_t start,hts_pos_t end, hts_pos_t* pos) {
       hts_itr_t* itr= NULL;
       int ret = STATUS_ERROR;
       if ( reader->tbx_idx !=NULL )
        {
        
            //fprintf(stderr," searching first in interval =%"PRIu64" %"PRIu64" \n",start,end);
            itr= tbx_itr_queryi(reader->tbx_idx,tid,start,end+1);
            if(itr==NULL) {
                ret = STATUS_ERROR;
                goto cleanup;
                }
           
           // itr->readrec = bgzf_tbx_only_chrom_pos;

            ret = tbx_itr_next(reader->in, reader->tbx_idx, itr, &reader->line);
            if ( ret < -1 )  {
                WARNING("error occured");
                ret = STATUS_ERROR;
                goto cleanup;
                }
            if ( ret < 0 )  {
                ret = STATUS_NOT_FOUND;
                goto cleanup;
                }

            ret = get_chrom_pos(reader,pos);
            if ( ret<0 ) {
            	WARNING("error occured");
                ret = STATUS_ERROR;
                goto cleanup;
                }
        	ret=0;
        }
        else
        {
            itr = bcf_itr_queryi(reader->bcf_idx,tid,start,end+1);
            if(itr==NULL) {
                ret = STATUS_ERROR;
                goto cleanup;
                }
             ret = bcf_itr_next(reader->in, itr, reader->rec);
             if ( ret < -1 )  {
                ret = STATUS_ERROR;
                goto cleanup;
                }
            if ( ret < 0 )  {
                ret = STATUS_NOT_FOUND;
                goto cleanup;
                }
            *pos = reader->rec->pos;
            ret =0;
        }
    cleanup:
        if(itr!=NULL) hts_itr_destroy(itr);
    return ret;
    }


int scan(args_t *args, const char* filename) {
    int i,ret=EXIT_SUCCESS;
    indexed_vcf_t* reader = indexed_vcf_open(args,filename);
    if(reader==NULL) return EXIT_FAILURE;


    for(i=0;i< reader->nseq; i++) {
        hts_pos_t len, first_pos, curr,high;
        const char* ctg_name= indexed_vcf_ctg_name(reader,i,&len);
        if(ctg_name==NULL) continue;
        
        ret = indexed_vcf_find_first(reader,i,0,len+1,&first_pos);
        if(ret==STATUS_ERROR) {
            break;
            }
        if(ret==STATUS_NOT_FOUND) {
            continue;
            }
        curr = first_pos;
        high = len+1;
        for(;;) {

            hts_pos_t dist = (high-curr)/2;
            if(dist<1) break;
            hts_pos_t mid = curr+dist;


            hts_pos_t new_pos;
            ret = indexed_vcf_find_first(reader,i,mid,high+1,&new_pos);
            if(ret==STATUS_ERROR) {
                break;
                }
            if(ret==STATUS_NOT_FOUND) {
                high=mid;
                ret=0;
                }
            else
                {
                if(curr==new_pos) break;
                curr=new_pos;
                }
            }
        fprintf(args->out, "%s\t%" PRIu64 "\t%" PRIu64 "\t%s\n",ctg_name,first_pos,curr+1,filename);
        }
    indexed_vcf_close(reader);
    return ret;
    }

static void usage(FILE* out)
{
    fprintf(out, "\n");
    fprintf(out, "About:   Index bgzip compressed VCF/BCF files for random access.\n");
    fprintf(out, "Usage:   bcftools index [options] <in.bcf>|<in.vcf.gz>\n");
    fprintf(out, "\n");
    fprintf(out, "Indexing options:\n");
    fprintf(out, "    -o, --output FILE        optional output index file name\n");
    fprintf(out, "        --threads INT        use multithreading with INT worker threads [0]\n");
    fprintf(out, "\n");
}

int main(int argc,char** argv) {
    int c;
    char *tmp;
    char *outfn = NULL;
    int ret = EXIT_SUCCESS;
	args_t *args = (args_t*) calloc(1,sizeof(args_t));
	args->out=stdout;
	
	
    static struct option loptions[] =
    {
        {"threads",required_argument,NULL,'@'},
        {"output-file",required_argument,NULL,'o'},
        {"output",required_argument,NULL,'o'},
        {NULL, 0, NULL, 0}
    };

   
    while ((c = getopt_long(argc, argv, "@o:", loptions, NULL)) >= 0)
    {
      switch (c)
        {	
            case '@':
                args->n_threads = strtol(optarg,&tmp,10);
                if ( *tmp ) error("Could not parse argument: --threads %s\n", optarg);
                break;
            case 'o': outfn = optarg; break;
            default: usage(stderr); return EXIT_FAILURE;
        }
    }
    
    
    if (argc == optind && isatty(STDIN_FILENO)) {
       usage(stderr);
       return EXIT_FAILURE;
    }

    
    if(args->n_threads>0) {
    	args->threads = hts_tpool_init(args->n_threads);
    }
    
    int i;
    if(outfn!=NULL && strcmp(outfn,"-")!=0) {
    	args->out = fopen(outfn,"w");
    	if(args->out==NULL) {
    		error_errno("cannot write output to %s\n", optarg);
    		return EXIT_FAILURE;
    		}
    	}
    	
     /* no file was provided, input is stdin, each line contains the path to a vcf file */
    if (argc == optind) {
        htsFile* fp = hts_open("-", "r");
        if (fp == NULL) {
            error("Cannot read from stdin");
            ret = EXIT_FAILURE;
        } else {
            kstring_t ks = KS_INITIALIZE;
            int r;
            while ((r = hts_getline(fp, KS_SEP_LINE, &ks)) >= 0) {
            	 if(scan(args,ks_str(&ks))!=EXIT_SUCCESS) {
		        ret= EXIT_FAILURE;
		        break;
		        }
            }
            ks_free(&ks);
            hts_close(fp);
        }
    }
	else
		{
	   	for(i=optind;i< argc;++i) {
		    if(scan(args,argv[i])!=EXIT_SUCCESS) {
		        ret= EXIT_FAILURE;
		        break;
		        }
		    }
		}
   	
    if(outfn!=NULL && strcmp(outfn,"-")!=0) {
     	fclose(args->out);
     	}
	if( args->threads!=NULL) {
		hts_tpool_destroy(args->threads);
		}

    free(args);
    return ret;
    }


#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <assert.h>
#include <errno.h>
#include <htslib/hts.h>
#include <htslib/vcf.h>
#include <htslib/tbx.h>
#include <htslib/synced_bcf_reader.h>
#define WHERE do {fprintf(stderr,"[%s:%d]",__FILE__,__LINE__);} while(0)
#define WARNING(...) do { fputs("[WARNING]",stderr);WHERE;fprintf(stderr,__VA_ARGS__);fputc('\n',stderr);} while(0)
#define ERROR(...) do { fputs("[ERROR]",stderr);WHERE;fprintf(stderr,__VA_ARGS__);fputc('\n',stderr);abort();} while(0)

typedef struct indexed_vcf_t {
    htsFile* in;
    bcf_hdr_t* hdr;
    tbx_t* tbx_idx;
    hts_idx_t *bcf_idx;
    int nseq;
    const char** ctg_names;
    bcf1_t *rec;
    kstring_t line;
    } indexed_vcf_t;

void indexed_vcf_close(indexed_vcf_t* reader) {
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

indexed_vcf_t* indexed_vcf_open(const char* filename) {
    char* fnidx=NULL;    
    if ( (fnidx = strstr(filename, HTS_IDX_DELIM)) != NULL ) {
            *fnidx=0;
            fnidx+= strlen(HTS_IDX_DELIM);
            }


    indexed_vcf_t* ptr=(indexed_vcf_t*)calloc(1UL,sizeof(indexed_vcf_t));
    ptr->in = hts_open(filename,"r");
    if(ptr->in==NULL) {
        indexed_vcf_close(ptr);
        ERROR("Cannot open file");
        return NULL;
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
            ERROR("Cannot read index.");
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
        char *end = hrec->vals[hkey];
        *len = strtoll(hrec->vals[hkey], &end, 10);
        if (end == hrec->vals[hkey] || *len < 0)
            {
            fprintf(stderr,"Warning: cannot determine contig \"%s\" for length:%s\n",ctg_name, hrec->vals[hkey]);
            return NULL;
            }
        return ctg_name;
        }
#define STATUS_ERROR -2
#define STATUS_NOT_FOUND -4

int indexed_vcf_find_first(indexed_vcf_t* reader,int tid,int start,int end, hts_pos_t* pos) {
       hts_itr_t* itr= NULL; 
       int ret = STATUS_ERROR;
       if ( reader->tbx_idx !=NULL )
        {
            itr= tbx_itr_queryi(reader->tbx_idx,tid,start,end+1);
            if(itr==NULL) {
                ret = STATUS_ERROR;
                goto cleanup;
                }
       
            ret = tbx_itr_next(reader->in, reader->tbx_idx, itr, &reader->line);
            if ( ret < -1 )  {
                ret = STATUS_ERROR;
                goto cleanup;
                }
            if ( ret < 0 )  {
                ret = STATUS_NOT_FOUND;
                goto cleanup;
                }
            ret = vcf_parse1(&reader->line, reader->hdr, reader->rec);
            if ( ret<0 ) {
                ret = STATUS_ERROR;
                goto cleanup;
                }
             *pos = reader->rec->pos;
             ret = 0;
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


int scan(const char* filename) {
    int i;
    indexed_vcf_t* reader = indexed_vcf_open(filename);
    if(reader==NULL) return EXIT_FAILURE;

    fprintf(stderr,"%d sequence in %s\n",reader->nseq,filename);
    for(i=0;i< reader->nseq; i++) {
        hts_pos_t len, first_pos, curr,high;
        const char* ctg_name= indexed_vcf_ctg_name(reader,i,&len);
        if(ctg_name==NULL) continue;
        fprintf(stderr,"%s /  %d\n",ctg_name,(int)len);
        
        int ret = indexed_vcf_find_first(reader,i,0,len+1,&first_pos);
        if(ret==STATUS_ERROR) {
            break;
            }
        if(ret==STATUS_NOT_FOUND) {
            continue;
            }
        printf("1st : %d \n",first_pos);
        curr = first_pos;
        high = len+1;
        for(;;) {
            fprintf(stderr,"%d %d\n",curr,high);
            hts_pos_t dist = (high-curr);
            if(dist/2==0) break;
            hts_pos_t mid = curr+dist/2;
            hts_pos_t new_pos;
            ret = indexed_vcf_find_first(reader,i,mid,high+1,&new_pos);
            if(ret==STATUS_ERROR) {
                break;
                }
            if(ret==STATUS_NOT_FOUND) {
                high=mid;
                }
            else
                {
                printf("now farest : %d \n",new_pos);
                curr=mid;
                }
            }
         printf("%s\t%d\t%d\t%s\n",ctg_name,first_pos,curr+1,filename);
        }
    indexed_vcf_close(reader);
    return EXIT_SUCCESS;
    }

int main(int argc,char** argv) {
    int i;
    for(i=1;i< argc;++i) {
        if(scan(argv[i])!=EXIT_SUCCESS) {
            return EXIT_FAILURE;
            }
        }
    return EXIT_SUCCESS;
    }


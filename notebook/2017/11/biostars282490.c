/** compilation gcc -o biostars282490 biostars282490.c */ 
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>


static void recursive(
	const char* src,
    char* dna,
    const int pos,
    const int len)
    {
    unsigned int i=0UL;
    char bases[5];
    if(pos==len)
        {
        fputs(dna,stdout);
        fputc('\n',stdout);
        return;
        }
    
    memset((void*)bases,0,5);
    switch (toupper(src[pos])) {
        case 'A':
        case 'C':
        case 'G':
        case 'T':
        case 'U':
            bases[0] = dna[pos];
            break;
        case 'R': bases[0] = 'A'; bases[1] = 'G'; break;
        case 'Y': bases[0] = 'C'; bases[1] = 'T'; break;
        case 'S': bases[0] = 'G'; bases[1] = 'C';break;
        case 'W': bases[0] = 'A'; bases[1] = 'T';break;
        case 'K': bases[0] = 'G'; bases[1] = 'T';break;
        case 'M': bases[0] = 'A'; bases[1] = 'C';break;
        case 'B': bases[0] = 'C'; bases[1] = 'G'; bases[2] = 'T'; break;
        case 'D': bases[0] = 'A'; bases[1] = 'G'; bases[2] = 'T'; break;
        case 'H': bases[0] = 'A'; bases[1] = 'C'; bases[2] = 'T'; break;
        case 'V': bases[0] = 'A'; bases[1] = 'C'; bases[2] = 'G'; break;
        case 'N': bases[0] = 'A'; bases[1] = 'C'; bases[2] = 'G'; bases[3] = 'T';break;
    	}
    
    while(bases[i]!=0)
    	{
    	dna[pos]=bases[i++];
    	recursive(src,dna,pos+1,len);
    	}
    }

int main(int argc,char** argv)
    {
    size_t len;
    char* src;
    char* dna;
    if(argc!=2)
        {
        fprintf(stderr,"Usage %s DNA\n",argv[0]);
        return EXIT_FAILURE;
        }
    src = argv[1];
    len = strlen(src);
    if(len==0UL)
        {
        fprintf(stderr,"Bad DNA\n");
        return EXIT_FAILURE;
        }
    dna=(char*)malloc(sizeof(char)*(len+1));
    if(dna==0)
        {
        fprintf(stderr,"Out of memory\n");
        return EXIT_FAILURE;
        }
    strcpy(dna,src);
    recursive(src,dna,0,len);
    free(dna);
    return EXIT_SUCCESS;
    }


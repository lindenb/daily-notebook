#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <ctype.h>
#define SIZE 8

static void recurse(int pos,char* bits,int* y) {
	if(pos==8) {
		int v=0;
		printf("<g transform=\"translate(%f,%f)\">",SIZE/2.0,(double)(*y*SIZE));
		for(int i=0;i< 8;i++) {
			printf("<circle cx=\"%d\" cy=\"%f\" r=\"%f\" style=\"fill:%s;stroke:black;\"/>",i*SIZE,SIZE/2.0,SIZE/2.0,(bits[i]==0?"none":"black"));
			if(bits[i]) {
				v |=(1<< i);
				}
			}
		printf("<text x=\"%f\" y=\"%f\">",SIZE*(8.0+1),(double)SIZE );
		printf("%d",v);
		if(isprint(v)) {
			switch(v)
				{
				case '<': printf(" (&lt;)");break;
				case '>': printf(" (&gt;)");break;
				case '&': printf(" (&amp;)");break;
				default:printf(" (%c)",(char)v); break;
				}
			}
		printf("</text>");
		printf("</g>\n");
		++*y;
		return;
		}
	for(int i=0;i< 2;i++) {
		bits[pos]=i;
		recurse(pos+1,bits,y);
		}
	}

int main(int argc,char** argv) {
	char bits[8];
	int y=0;
	memset((void*)bits,0,sizeof(char)*8);
	printf("<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<svg style=\"font-size:10px;\" xmlns=\"http://www.w3.org/2000/svg\" width=\"%f\" height=\"%f\">\n",50+SIZE*8+1.0,256.0*8+1);
	recurse(0,bits,&y);
	printf("</svg>\n");
	return 0;
	}

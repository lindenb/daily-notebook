BEGIN	{
	FS="\t";
	}

($3=="gene") {
	gene_id="";
	gene_name=""
	gene_biotype=""
	N=split($9,a,/[ ]*[;][ ]*/);
	for(i=1;i<=N;++i) {
		N2 = split(a[i],b,/[ ]/);
		K = b[1];
		V=b[2];
		gsub(/"/,"",V);
		if(K=="gene_id") gene_id=V;
		else if(K=="gene_name") gene_name=V;
		else if(K=="gene_biotype") gene_biotype=V;
		}
	if(gene_id=="") next;
	printf("<bio:Gene rdf:about=\"%s\">\n",gene_id);
	printf("\t<bio:gene_id>%s</bio:gene_id>\n",gene_id);
	if(gene_name!="") printf("\t<bio:gene_name>%s</bio:gene_name>\n",gene_name);
	if(gene_biotype!="") printf("\t<bio:gene_biotype>%s</bio:gene_biotype>\n",gene_biotype);
	printf("\t<bio:location>\n");
	printf("\t\t<bio:Location>\n");
	printf("\t\t\t<bio:build>%s</bio:build>\n",BUILD);
	printf("\t\t\t<bio:chrom>%s</bio:chrom>\n",$1);
	printf("\t\t\t<bio:start rdf:datatype=\"http://www.w3.org/2001/XMLSchema#int\">%s</bio:start>\n",$4);
	printf("\t\t\t<bio:end rdf:datatype=\"http://www.w3.org/2001/XMLSchema#int\">%s</bio:end>\n",$5);
	printf("\t\t</bio:Location>\n");
	printf("\t</bio:location>\n");
	printf("</bio:Gene>\n");
	}

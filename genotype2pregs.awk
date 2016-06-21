#!/bin/gawk -f
#
# this program passes from true genotypes (nucleotide) to pregs format (0/1/2)
# the reference allele is the first one read on the file for each locus, a table of equivalences is generated on output
# I DO NOT check for triallelic SNPs
BEGIN{}
{
	geno=""
	if((NR % 500)==0){ printf("%s%s\n", NR," individuals treated") > "/dev/stderr" }
	for (i=2; i<=NF; i+=2){
		if(NR==1) {included[i]=0}
		# if we first see alleles in this locus store reference alleles unless missing one
		if(!included[i]){
			if($i!="."){
				ref[i]=$i
				included[i]=1
			}else if($(i+1)!="."){
				ref[i]=$(i+1)
				included[i]=1
			}
		}else{
		# now take the allele as a reference and count it
		#if(included[i]){
			out= +($i==ref[i]) +($(i+1)==ref[i])
		}
		if($i=="." || $(i+1)=="."){ out=5 }
		geno=geno out
	}
	printf("%20s%1s%" length(geno) "s\n",$1," ",geno )
}
END{ 
	printf("%s\n","locus reference_allele")> "equivalences_genotype2pregs"
	for (i=2; i<=NF; i+=2){
		printf("%s%s\n",i/2,ref[i]) > "equivalences_genotype2pregs"

	}

}	

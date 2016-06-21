#!/usr/local/bin/awk -f
#
# this program takes the recoded pedigree with recoded id in $1 and old id in $4,
# then reads a genotype file and creates a new file with recoded id instead of old id
#
# can pass pos as a variable using -v
BEGIN{posold=4; posnew=1}
{
        if(NR==FNR){
                newcod[$posold]=$posnew
        }
        # second file
        if(NR!=FNR){
        	cnt++
        	nsnp=length($2)
         	printf("%16s%1s%" nsnp "s\n",newcod[$1]," ",$2)
        }
}
END{printf("%s%s\n",FNR," genotypes processed") >"/dev/stderr"}

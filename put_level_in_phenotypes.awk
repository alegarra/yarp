#!/usr/local/bin/awk -f
#
# this program takes the recoded pedigree with recoded id in $1 and old id in $4,
# then reads a phenotype file with id in pos posid  and creates a new file with recoded id at the last column
#
# should pass posid as a variable using -v
BEGIN{posold=4; posnew=1}
{
        if(NR==FNR){
                newcod[$posold]=$posnew
        }
        # second file
        if(NR!=FNR){
        	cnt++
         	print $0,newcod[$posid]
        }
}
END{printf("%s%s\n",FNR," phenotypes processed") >"/dev/stderr"}

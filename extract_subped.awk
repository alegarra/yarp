#!/usr/local/bin/gawk -f
#
# This program reads animals from one file (in 1st column but that can be changed)
# then reads pedigree and extracts the subpedigree including ALL ancestors of animals 
# Andres Legarra and Tao Xiang 22/4/2016
# andres.legarra@toulouse.inra.fr
#
# TWO files need to be called. in_data_ex and ped_extract


BEGIN{
	unknown_parent="00000000000000"
	newped[0]=0
	included[0]=1 # exported into output?
	changed=1
	cnt=0
}
{
	if(NR==FNR){
		#read data file and store number
		cnt++
		included[$1]=1
	}else{
		if($1==unknown_parent) $1=0
		if($2==unknown_parent) $2=0
		if($3==unknown_parent) $3=0
		pos[$1]=FNR
		sire[$1]=$2
		dam[$1]=$3
		if(FNR%100000 == 0) printf("%10s%10s\n",FNR,"read") > "/dev/stderr"
	}
}
END{
	printf("\n") > "/dev/stderr"
	printf("%s\n","-----------------------------------------") > "/dev/stderr"
	printf("%s%10s%s%10s\n","in pedigree ",FNR," in data ",cnt) > "/dev/stderr"
	printf("%s\n","-----------------------------------------") > "/dev/stderr"
	printf("\n") > "/dev/stderr"
	iter=0
	while (changed){
		changed=0
		for (x in pos){
			if(x in included){
					if(!(included[sire[x]])){
						included[sire[x]]=1
						changed=1
						cnt++
					}
					if(!(included[dam[x]])){
						included[dam[x]]=1
						changed=1
						cnt++
					}
			}
		}
		iter++
		printf("%10s%10s%10s\n",iter,"included",cnt) > "/dev/stderr"
		previous=posout[last]
	}
	for (x in included){
		if(x!=0){ printf("%16s%16s%16s\n",x,sire[x],dam[x]) }
	}
}

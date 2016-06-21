#!/usr/local/bin/awk -f
# this script renums pedigrees with groups
# so that groups are added *after*regular animals
# groups are ascertained because they are not in the 1st column
#
# two examples are provided: exo.txt, genelogia.gru_split
#
BEGIN{
	pos[0]=0 # actual position in the original data file
	changed=1
	posout[0]=0 # position in the new file
	last=0
	cum[0]=0 #number of times it acts as parent
}
# read and store pedigree file
{
	pos[$1]=NR
	dam[$1]=$2
	sire[$1]=$3
	included[$1]=0
}
END{
    printf("%10s%10s\n",NR,"animals") > "/dev/stderr" 
    # find out who is a genetic group
    for (x in sire){
        if(! (sire[x] in pos)){ 
            is_group[sire[x]]=1 
		#printf("%10s%10s\n","sire",sire[x]) > "/dev/stderr"
		cum[sire[x],"sire"]++
	}
    }
    for (x in dam){
        if(! (dam[x] in pos)){ 
            is_group[dam[x]]=1 
		#printf("%10s%10s\n","dam",dam[x]) > "/dev/stderr"
		cum[dam[x],"dam"]++
        }
    }
    # compute numbers, but don't write them out
	printf("%16s\n","info on UPGs") > "/dev/stderr"
    last_group=NR
    # NR == number of animals !!
    for (x in is_group){
        last_group=last_group+1
        posout[x]=last_group
        included[x]=1
		printf("%10s%16s%10s%16s%10s%10s%10s\n","group",last_group,"included",x," as sire, as dam",cum[x,"sire"],cum[x,"dam"]) > "/dev/stderr"
    }
    # regular individuals
	iter=0
	while (changed){
		changed=0
		for (x in pos){
			if(!included[x]){
					if(included[dam[x]] && included[sire[x]]){
						# the new code is actually the order animals are printed
						posout[x]=posout[last]+1
						printf("%16s%16s%16s%16s%16s%16s\n", posout[x],posout[dam[x]],posout[sire[x]],x,dam[x],sire[x])
						included[x]=1
						changed=1
						last=x
					}
			}
        }
		iter++
		printf("%10s%10s%10s%10s%16s\n","round",iter,"included",posout[last],last) > "/dev/stderr"
	}
}

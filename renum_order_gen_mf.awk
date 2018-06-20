#!/usr/bin/awk -f
# gawk below gave me trouble !!
##!/usr/local/bin/awk -f
# this script renums pedigrees with metafounders
# so that they are added *before*regular animals
# mf are ascertained because they are not in the 1st column
# also ordered by generation assuming that all metafounders
# start at generation 1
#
#
	function maxval (a,b) { 
		max=b 
		if (a>b){max=a} 
		return max 
	}
BEGIN{
	posout[0]=0 # position in the new file
	last=0
	cum[0]=0 #number of times it acts as parent
	gen[0]=0
	included[0]=1
	changed=1
}
# read and store pedigree file
{
	pos[$1]=NR
	dam[$1]=$2
	sire[$1]=$3
	if($1==$2 || $1==$3){
        printf("incorrect pedigree\n") > "/dev/stderr"
        printf($0"\n") > "/dev/stderr"
        error=1
    }

}
END{
    if(error)exit 1
    printf("%10s%10s\n",NR,"animals") > "/dev/stderr" 
    # find out who is a genetic group
    for (x in sire){
        if(! (sire[x] in pos)){ 
            is_group[sire[x]]=1 
		    cum[sire[x],"sire"]++
	}
    }
    for (x in dam){
        if(! (dam[x] in pos)){ 
            is_group[dam[x]]=1 
		    cum[dam[x],"dam"]++
        }
    }
    # compute numbers, but don't write them out
    printf("%16s\n","info on mf") > "/dev/stderr"
    for (x in is_group){
        nmf++
        posout[x]=posout[last]+1
	    printf("%16s%16s%16s%16s%16s%16s%16s\n", posout[x],0,0,x,0,0,0)
        included[x]=1
        gen[x]=0
        last=x
        cumgen[0]++
	    printf("%10s%16s%10s%16s%10s%10s%10s\n","group",last," included as",posout[x]," as sire, as dam",cum[x,"sire"],cum[x,"dam"]) > "/dev/stderr"
    }
    # regular individuals
	printf("%16s\n","recoding animals") > "/dev/stderr"
	iter=1
	while (changed){
		changed=0
		for (x in pos){
			if(!included[x]){
			    if(included[dam[x]] && included[sire[x]]){
						if((gen[dam[x]]<iter) && (gen[sire[x]]<iter)){
							# the new code is actually the order animals are printed
							posout[x]=posout[last]+1
							gen[x]=iter 
							included[x]=1
							changed=1
							nanim++
							cumgen[gen[x]]++
							printf("%16s%16s%16s%16s%16s%16s%16s\n", posout[x],posout[dam[x]],posout[sire[x]],x,dam[x],sire[x],gen[x])
							last=x
						}
				}
		    }
        }
		iter++
		printf("%10s%10s%10s%10s%16s%16s\n","round",iter,"included",posout[last],"last ",last) > "/dev/stderr"
	}
	printf("%10s%10s%10s%10s%10s%10s\n","metafounders:",nmf," animals",nanim," total",posout[last]) > "/dev/stderr"
	printf("%16s%16s\n","pseudogenerations:",gen[last]) > "/dev/stderr"
	for (x in cumgen){
		    printf("%10s%16s%10s%16s\n","pseudogeneration:",x," including: ",cumgen[x]) > "/dev/stderr"
	}
}

#!/usr/local/bin/gawk -f
# this program extracts a subpedigree from the SECOND pedigree file, for the list of animals in the FIRST file
BEGIN{
	included[0]=1
}
{
	if(NR==FNR){
		included[$1]=1
		cnt++
	}else{
		pos[$1]=NR
		sire[$1]=$2
		dam[$1]=$3
		rec[$1]=$0
	}
}
END{
	iter=0
	changed=1
	#add all ancestors
	while(changed){
		changed=0
		for (x in included){
			if(!included[sire[x]]){
				included[sire[x]]=1
				changed=1
				cnt++
			}
			if(!included[dam[x]]){
				included[dam[x]]=1
				changed=1
				cnt++
			}
		}
		iter++	
		printf("%10s%10s\n",iter,cnt) > "/dev/stderr"
	}
	for(x in included){
		if(x!=0 && x!=""){
			# some ancestors do not have record on their own
			if(rec[x]!=""){ 
				print rec[x]
				cnt1++
			} else {
				cnt2++
			}
		}
	}
	printf("%s%s%s%s\n"," written ",cnt1," absent from pedigree file ",cnt2) > "/dev/stderr"
}


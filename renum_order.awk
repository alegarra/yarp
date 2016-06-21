#!/usr/local/bin/gawk -f
#
# This program renumbers a pedigree file so that parents precede progeny
# no checking of coherence is done.
# On standard output, a file with the first three columns renumbered, the 3 next have the original pedigree
# based on an idea by I Aguilar
#
# pedigree format: animal, sire, dam separated by spaces
#
# andres.legarra@toulouse.inra.fr
# 31/12/2010
#
BEGIN{
	unknown_parent="00000000000000"
	pos[0]=0 # actual position in the original data file
	included[0]=1 # exported into output?
	changed=1
	posout[0]=0 # position in the new file
	last=0
	previous=0
	unknowns=0
	unknownd=0
	unknownb=0
}
# read and store pedigree file
{
	if($1==unknown_parent) $1=0
	if($2==unknown_parent) $2=0
	if($3==unknown_parent) $3=0
	if( ($2==0) && ($3==0) ) unknownb++
	if( ($2!=0) && ($3==0) ) unknownd++
	if( ($2==0) && ($3!=0) ) unknowns++


	pos[$1]=NR
	sire[$1]=$2
	dam[$1]=$3
	included[$1]=0
	if(NR%100000 == 0) printf("%10s%10s\n",NR,"read") > "/dev/stderr"
}
END{
	printf("\n") > "/dev/stderr"
	printf("%s\n","-----------------------------------------") > "/dev/stderr"
	printf("%s%10s\n","total read",NR) > "/dev/stderr"
	printf("%s%10s%10s%10s\n","both unknown,sire unknown,dam unknown",unknownb,unknowns,unknownd) > "/dev/stderr"
	printf("%s\n","-----------------------------------------") > "/dev/stderr"
	printf("\n") > "/dev/stderr"
	iter=0
	while (changed){
		changed=0
		for (x in pos)
			if(!included[x]){
					if(included[dam[x]] && included[sire[x]]){
						# the new code is actually the order animals are printed
						posout[x]=posout[last]+1
						printf("%16s%16s%16s%16s%16s%16s\n", posout[x],posout[sire[x]],posout[dam[x]],x,sire[x],dam[x])
						included[x]=1
						changed=1
						last=x
					}
			}
		iter++
		printf("%10s%10s%10s%10s%10s\n",iter,"included",posout[last]-previous,"total",posout[last]) > "/dev/stderr"
		previous=posout[last]
		}
}

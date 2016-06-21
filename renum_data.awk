#!/usr/local//bin/awk -f
# this programs recodes given fields in a data set
# example ex_renum_data
# the order of print is: first recoded columns, then "untouched" fields passed to output, then the original complete (possibly alphanumeric)
# line. In this manner the output can be read as such by blupf90 with alphanumerics included
BEGIN{
	# which data fields do I recode
	sset= "1 2 4"
	split(sset,set," ")
	# untouched columns that go to the output
	# the interest of this is to put them 
	p="5 3"
	split(p,pp," ")
	# note that p and sset do not need to add up to "all fields"
	n=0
	for (i in set){
		last[i]=0
		n++
	}
	printf("%s%s%s\n",sset,"fields recodified,total ",n) > "/dev/stderr"
	m=0
	for (i in pp){ m++ }
	printf("%s%s%s\n",p,"fields passed to output,total ",m) > "/dev/stderr"
}
{
	if(NR==1) printf("%s%s\n",NF," number of fields read") > "/dev/stderr"
	if(NR%100000 == 0) printf("%10s%10s\n",NR,"read") > "/dev/stderr"
	out=""
	# for each field to be recoded
	for (i=1; i<=n; i++){
		#is it already there?
		if (! ((i,$set[i]) in pos) ) {
			#if not, add a new level to the number of levels to that field
			last[i]=last[i]+1
			# store the new level for the combination of field and level
			pos[i,$set[i]]=last[i]
			# store the reverse: for the field i and renumbered code j, which one is the level?
			who[i,last[i]]=$set[i]
		}
		cnt[i,$set[i]]++
		out=out" "pos[i,$set[i]]
	}
	# for each field to be passed
	for (i=1; i<=m; i++){
		out=out" "$pp[i]
	}
	# print out + original record 
	print out,$0
}
END{
	printf("%10s%10s\n",NR," total lines read") > "/dev/stderr"
	#two tables on extra output
	printf("%16s%16s%16s%16s\n","column","level","recodedlevel","count") >"levels"
	for (x in pos){
		split(x,xx,SUBSEP)
		printf("%16s%16s%16s%16s\n",xx[1],xx[2],pos[x],cnt[x]) >"levels"
	}
	printf("%16s%16s%16s%16s\n","column","recodedlevel","level","count") >"ordered.levels"
	for (i in set){
		for (j=1; j<=last[i]; j++){
			printf("%16s%16s%16s%16s\n",i,j,who[i,j],cnt[i,who[i,j]]) >"ordered.levels"
		}
	}



}


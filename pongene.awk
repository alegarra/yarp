#!/usr/bin/awk -f
# put animals in the first column if absent (unless they <=0)
# also allocate upg for missing animals, ehere
# yob = yob(progeny)-3 (so upg=upg+1)
BEGIN{
	unknown="00000000000000"
	inn[0]=1
	inn[unknown]=1
}
{
	inn[$1]=1
	line[NR]=$0
	print $0
}
END{
	for (i in line){
		split(line[i],arr)
		id=arr[1]
		sire=arr[2]
		dam=arr[3]
		yob=arr[4]
		sex=arr[5]
		if(!(sire in inn)){
			print sire,0,0,yob -4,1
			inn[sire]=1
			cntsire++
		}
		if(!(dam  in inn)){
			print dam,0,0, yob -4,2
			inn[dam]=1
			cntdam++
		}
	}
	printf ("%s%10s\n","number of sires added",cntsire) > "/dev/stderr"
	printf ("%s%10s\n","number of dams  added",cntdam) > "/dev/stderr"
}

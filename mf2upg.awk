#!/usr/local/bin/awk -f
# this program converts a recoded file with metafounder into a regular file with UPG
# that will to renumf90
#	-putting negative numbers for upgs
# keeps original id's but for upg's numbers are switched to negative
#
BEGIN{i=0; cntmf=0; cntanim=0}
{
	i++
	line[i]=$0
	if($2==0 && $3==0){ 
		is_mf[$1]=1
		cntmf++
	}else{
		cntanim++
	}
}
END{
	for (i=cntmf+1; i<=(cntanim+cntmf); i++){
		split(line[i],ll)
		# there are 7 cols in ll
		if(is_mf[ll[2]]){ll[2]=-ll[2]}		
		if(is_mf[ll[3]]){ll[3]=-ll[3]}		
		print ll[1],ll[2],ll[3],ll[4],ll[5],ll[6],ll[7]
	}
	printf("%s%s\n","nmf: ",cntmf) > "/dev/stderr"
	printf("%s%s\n","nanim: ",cntanim) > "/dev/stderr"
}	

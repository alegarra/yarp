#!/usr/bin/awk -f
# assings UPGs
BEGIN{
	unknown="00000000000000"
}
{
	#	when(        ian<1975) ig = '0000';
	#	when(1975<= ian <1980) ig = '1975';
	#	when(1980<= ian <1984) ig = '1980';
	#	when(1984<= ian <1988) ig = '1984';
	#	when(1988<= ian <1991) ig = '1988';
	#	when(1991<= ian <1994) ig = '1991';
	#	when(1994<= ian <1997) ig = '1994';
	#	when(1997<= ian <2000) ig = '1997';
	#	when(2000<= ian <2003) ig = '2000';
	#	when(2003<= ian <2006) ig = '2003';
	#	when(2006<= ian <2009) ig = '2006';
	#	when(2009<= ian <2012) ig = '2009';
	#	when(2012<= ian <2015) ig = '2012';
	#	otherwise              ig = '2015';

	#store type of unknown parentships
	su=0; du=0; upg="0"
	#assign different UPGs in function of yob and path of selection
	if($2==unkown){su=1}
	# if the dam is unknown, then the sire too
	if($3==unkown){du=1;su=1}
	if($4 < 1975)              {ig="0000"}
	if($4 >= 1975 && $4 <1980) {ig="1975"}
	if($4 >= 1980 && $4 <1984) {ig="1980"}
	if($4 >= 1984 && $4 <1988) {ig="1984"}
	if($4 >= 1988 && $4 <1991) {ig="1988"}
	if($4 >= 1991 && $4 <1994) {ig="1991"}
	if($4 >= 1994 && $4 <1997) {ig="1994"}
	if($4 >= 1997 && $4 <2000) {ig="1997"}
	if($4 >= 2000 && $4 <2003) {ig="2000"}
	if($4 >= 2003 && $4 <2006) {ig="2003"}
	if($4 >= 2006 && $4 <2009) {ig="2006"}
	if($4 >= 2009 && $4 <2012) {ig="2009"}
	if($4 >= 2012 && $4 <2015) {ig="2012"}
	if($4 >= 2015 )            {ig="2012"}
	if(su || du){
		upg=(ig)"su"(su)"du"(du)
		upg2=ig " su " su " du " du
		cnt[upg2]++
		id[upg2]=upg
		if(su) {$2=upg}
		if(du) {$3=upg}
	}
	print $1,$2,$3,$4,$5,ig,upg
}
END{
	for (i in cnt) {printf("%16s%16s%16s\n",i, cnt[i],id[i]) >"/dev/stderr"}
}

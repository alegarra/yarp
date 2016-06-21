#!/usr/bin/awk -f
# removes duplicates and identical parents
{
	ok=1
	ok=ok && ($2!=$3 || ($2==0 && $3==0))
	if(!printed[$1] && ok) print $0
	printed[$1]=1
}

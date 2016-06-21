#!/bin/awk -f
#
# this program takes the first file, creates a list of animals, and prints out records in the second file if animals in the first column
# are included in the first file
#
# can pass pos as a variable using -v
BEGIN{pos=1}
{
        if(NR==FNR){
                in1[$1]=1
        }
        # second file
        if(NR!=FNR){
                if(in1[$pos]) {print $0}
        }
}


# YARP
## Yet Another Renumbering Package

Andres Legarra, INRA Toulouse

![](http://m1.paperblog.com/i/250/2505423/arkuek-el-aralar-segunda-parte-L-dvBrOT.jpeg)

YARP is a series of scripts that I found useful for manipulating and recoding data. Most of them are written in `awk`. In most cases they are run like

	./xxx.awk file1 [file2] > file_out

### subped.awk 
### extract_subped.awk
These two programs take `file1`, read animals e.g. in data, and from a pedigree `file2` they extract all ancestors of individuals in `file1`.

For some reason that I cannot remember `subped.awk` is more efficient (or contains no errors) than `extract_subped.awk`		

### extract_2_from_1.awk
This program takes `file1`, creates a list of animals, and prints out records in `file2` if animals in the first column are included in `file1`

### pongene.awk
* It takes the pedigree file and put ancestors animals in the first column if they are absent (unless they <=0), 
* It also assigns year of birth (needed to create upg) for missing animals, here yob = yob(progeny)-3 

###extract_duplicates.awk
Remove duplicates and individuals with two identical parents

###renum_order.awk			
Renumbers the pedigree on `file1` so that parents precede offspring. Conceived for populations with no unknown parent groups, so missing ancestors are 0. On output, it generates `fileout` with 6 cols, the new and the old pedigree.

###renum_order_gen.awk		
Same as above but considering pseudo-generation numbers, so that uncles got numbers before nieces; see Kempthorne's example in which Z may, or may not, be numbered before F.
	
	A 0 0
	B 0 0
	D A B
	E A D
	F B E
	Z A B

###assign_UPGs_sire_dam.awk
It assings unknown parent groups based on year of birth and kind of missingness (both unknown or only sire unknown). In this case, for Manech Tete Rousse.

### renum_order_groups.awk

Same as `renum_order` above but creating files wih upg's that are added *after* regular animals.

### renum_order_mf.awk

Same as `renum_order` above but creating files wih metafounders that come  *before* regular animals.

### renum_order_gen_mf.awk	
Same as `renum_order_mf` above but considering pseudo-generation numbers  creating files wih metafounders that come  *before* regular animals.

### mf2upg.awk		

It converts a pedigree with metafounders first to another one with upg's coded as negative numbers (so that it fits into `renumf90`)
	
### renum_data.awk	

This programs recodes given fields in a data set
example `ex_renum_data`
the order of print is: 

* first recoded columns, 
* then "untouched" fields passed to output, 
* then the original complete (possibly alphanumeric)
line. 

In this manner the output can be read as such by `blupf90` with alphanumerics included.
**It has not really been tested.**

		
### put_level_in_genotypes.awk	
This program takes the recoded pedigree with recoded id in $1 and old id in $4, then reads a genotype file and creates a new file with recoded id instead of old id.

### put_level_in_phenotypes.awk	
This program takes the recoded pedigree with recoded id in $1 and old id in $4, then reads a phenotype file with id in pos posid  and creates a new file with recoded id at the last column


### genotype2pregs.awk
 This program passes from true genotypes (nucleotide) to pregs format (0/1/2). The reference allele is the first one read on the file for each locus, a table of equivalences is generated on output. It **does not** check for triallelic SNPs

		



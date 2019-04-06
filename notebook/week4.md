# 10/06

[gtf specification](http://www.gencodegenes.org/gencodeformat.html)

- download `.gtf` 

```bash
wget -P sorghum_bicolor_15_68_14 -c ftp://ftp.ensemblgenomes.org/pub/release-15/plants/gtf/sorghum_bicolor/Sorghum_bicolor.Sorbi1.15.gtf.gz
wget -P brachypodium_distachyon_15_68_12 -c ftp://ftp.ensemblgenomes.org/pub/release-15/plants/gtf/brachypodium_distachyon/Brachypodium_distachyon.v1.0.15.gtf.gz
wget -P zea_mays_15_68_5 -c ftp://ftp.ensemblgenomes.org/pub/release-15/plants/gtf/zea_mays/Zea_mays.AGPv2.15.gtf.gz
wget -P oryza_sativa_15_68_6 -c ftp://ftp.ensemblgenomes.org/pub/release-15/plants/gtf/oryza_sativa/Oryza_sativa.MSU6.15.gtf.gz
```

update: not needed



# 10/07

```bash
wget -c -O data-raw/sbi.exon.txt.gz ftp://ftp.ensemblgenomes.org/pub/release-15/plants/mysql/sorghum_bicolor_core_15_68_14/exon.txt.gz
```

- analyse exon info between `.gtf` and `mysql.exon.txt`

```r
library(stringr)

options(stringsAsFactors = F)

# read file
folder <- 'data-raw/'
mysql <- folder %>% paste0('/sbi.exon.txt.gz') %>% readr::read_lines();
gtf  <- folder %>% paste0('/gtf/Sorghum_bicolor.Sorbi1.15.gtf.gz') %>% readr::read_lines() %>% str_subset('exon\t');

# construct data frame
mysql %<>% paste0(collapse = '\n') %>% readr::read_tsv(col_names = c('start', 'end', 'id'), col_types = '--ii-----c---');
gtf  %<>% paste0(collapse = '\n') %>% readr::read_tsv(col_names = c('chr', 'start', 'end', 'info'), col_types = 'c--ii---c');

# start and end position determines an exon (the probability that two exons on different chromosome have the same coordinate)
mysql.all <-  mysql %>% {paste(.$start, .$end, str_replace(.$id, '\\.\\d+_exon_\\d+', ''))} %>% unique();

gtf_all <- . %>% {paste(.$start, .$end, str_extract(.$info, '(?<=gene_id ")[\\w\\W]+?(?=")'))} %>% unique;
gtf.chr.all <- gtf %>% dplyr::filter(!str_detect(chr, 'GL\\d')) %>% gtf_all;
gtf.oth.all <- gtf %>% dplyr::filter(str_detect(chr, 'GL\\d'))  %>% gtf_all;

#" chromosme exons are included
gtf.chr.all %>% setdiff(mysql.all);
#" other exons are included
gtf.oth.all %>% setdiff(mysql.all);
length(gtf.chr.all) + length(gtf.oth.all) - length(mysql.all);
```



# 10/08

in `pgenes/pseudopipe/bin/pseudopipe.sh`

`3.1e9` to `3100000000` 

- `tfasty` in [**fasta**](http://faculty.virginia.edu/wrpearson/fasta/)

```
cd src
make -f ../make/Makefile.linux_sse2 all
```

gene names in `pep.abinitio` is different from those on `pep.all`, to be consistent with `orthologous_relationships.tsv`, choose `pep.all`


- PseudoPipe

test time 

```bash
head -n 100 sbi/pep/Sorghum_bicolor.Sorbi1.15.pep.abinitio.fa > sbi/pep/Sorghum_bicolor.Sorbi1.15.pep.fa; trash ${pipeo}/sbi;  time  pseudopipe.sh ${pipeo}/sbi sbi/dna/dna_rm.fa sbi/dna/Sorghum_bicolor.Sorbi1.15.dna.chromosome.%s.fa sbi/pep/Sorghum_bicolor.Sorbi1.15.pep.fa sbi/mysql/chr%s_exLocs 0
```

10 23s
100 2m23s

sbi 45m

pipeline use use `blast/processed/*.sorted` and `pgenes/${genome}_pgenes.txt` of the `pipe_output`



# delay one day

- download `pep.all.fa`

```bash
# moved to .bashrc
# env virables for Gao
export species=('oryza_sativa' 'sorghum_bicolor' 'zea_mays' 'brachypodium_distachyon' 'arabidopsis_thaliana' 'populus_trichocarpa' 'vitis_vinifera')
    # sorted by ((1,4),(2,3))
export species2=(`echo ${species[*]} | sed 's/\b[a-z]/\U&/g'`) # toupper first letter
export abbrs=('osm' 'sbi' 'zm' 'bdi')
export abbrs2=('sbi_zm' 'osm_bdi');
declare -A longs
longs=([osm]='Oryza_sativa.MSU6.15' [sbi]='Sorghum_bicolor.Sorbi1.15' [zm]='Zea_mays.AGPv2.15' [bdi]='Brachypodium_distachyon.v1.0.15')

export ftp="ftp://ftp.ensemblgenomes.org/pub/release-15/plants"

for i in {0..6}; do wget -c -P data-raw/pep $ftp/fasta/${species[$i]}/pep/*all*; done; 
for i in {0..6}; do wget -c -P data-raw/gtf $ftp/gtf/${species[$i]}/*gtf*; done; 
for i in {0..6}; do wget -c -P data-raw/embl $ftp/embl/${species[$i]}/*gz; done; 
for i in {0..3}; do wget -c -P data-raw/dna $ftp/fasta/${species[$i]}/dna/*chromosome.[0-9]*; done; 
for i in {0..3}; do open-html $ftp/mysql/${species[$i]}*/; done; 

mkdir data-raw/embl
mv ~/Downloads/*dat* data-raw/embl
```

- deprecated

```bash
suffix=('MSU6' 'Sorbi1' 'AGPv2' 'v1.0' 'TAIR10' 'JGI2.0' 'IGGP_12x');
export longs=(`for i in {0..6}; do echo "${species[$i]}.${suffix[$i]}.15"; done | sed 's/^[a-z]/\U&/g' | paste -s -d ' '`);
```



# delay two days

when PseudoPipe fails, there are basically two reasons, blast fails (especially when you see `_M_*sorted`) and incorrect chromosome name.

- PseudoPipe time

osm    20m38.354s
sbi    36m58.541s
zm    225m21.997s
bdi    25m22.488s

osm_bdi/osm    9m
osm_bdi/bdi    7m
sbi_zm/sbi     21m
sbi_zm/zm      62m



- GMAP time

osm    18m
sbi    27m
zm     576m
bdi    14m



# delay three days

in `main.sh`

```bash
if [ ${#genomes[*]} -gt 1 ]; then
for num in `seq 1 ${#genomes[*]}`; do cp orthologous_groups_with_candidate_unitary_gene_loss_in_${genomes_list}.tsv orthologous_groups_with_candidate_unitary_gene_loss_in_${genomes[$num-1]}.tsv; done
fi
```

should not be commented (I commented it to summary some result a few weeks ago, then I forgot it, whihc takes me several hours to figure out where the wrong lies )

- for `EVS009_Supplemental_dataset_S1_pluslinks.tsv`

s/Os/LOC_Os
s/Bradi2g/BRADI2G

then md5sum passed

```bash
sed  -n '1,10p' data-raw/demo/EVS009_Supplemental_dataset_S1_pluslinks.tsv | md5sum;
sed  -n '1,10p' unitary_gene_loss_detection/EVS009_Supplemental_dataset_S1_pluslinks.tsv | md5sum;
```

- Explain Mt Pt Un Sy

https://www.ncbi.nlm.nih.gov/pmc/articles/PMC4035068/

fallocate -l 8g /tmp/8g.swap
mkswap /tmp/8g.swap
sudo swapon /tmp/8g.swap
time gmap_build -d zm  ${pipei}/zm/dna/*dna.* -D "unitary_gene_loss_detection/GMAP_database"



# delay four days

```bash
gzip -dc data-raw/gtf/*gz > gtf;
gzip -dc data-raw/pep/*gz | grep '>' > pep;

cat pep | awk '{print $3}' | awk -F ':' '{print $3}' | sort -u | grep -v '[0-9]' ;
cat gtf | awk '{print $1}' | sort -u | grep -v '[0-9]';
cat gtf | awk '{print $2}' | sort -u;
 
```

根据 gtf， LOC_Os03g61120 位于 bdi 的第 3 条染色体上，不知道为什么 pipeline 示例上把它作为 forbidden genes 。 
也许网站上只是 举个例子？ 或者是还有其他注释信息我没有找到

- you can see that gtf's Mt|Pt cover all pep's

```bash
forbidden='transposable_element|chloroplast|mitochondrion|Mt|Pt';
gzip -dc data-raw/gtf/*gz | grep -E "$forbidden" | awk '{print $10}' | awk -F '"' '{print $2}' > unitary_gene_loss_detection/forbidden.gtf;
gzip -dc data-raw/pep/*gz | grep '>' | grep -E "$forbidden" | awk '{print $4}' | awk -F ':' '{print $2}' >> unitary_gene_loss_detection/forbidden.pep;
setdiff2 unitary_gene_loss_detection/forbidden.pep unitary_gene_loss_detection/forbidden.gtf
```

- 直接把 gtf 中提出的基因作为 forbidden genes 的话，量会很多，导致 pipeline 运行很慢。于是从 pep.fa 提取出基因名，然后用 join 来保留 protein coding gene。这里有一个前提是 Ensembl 的 orthologous relationship 都是 protein coding gene。首先这个应该是成立的，因为 pipeline 中貌似只靠 orthologous relationship 来限定 gene 为 protein coding。其次，不成立也没关系，non protein coding gene 即使没被

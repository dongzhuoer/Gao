# 10/13

```r
library(stringr)

setwd('unitary_gene_loss_detection')

readr::read_tsv('orthologous_groups.tsv', F)

raw <- readr::read_lines('orthologous_groups.tsv')
x <- readr::read_lines('forbidden_gene_list.tsv')
y <- lapply(x, . %>% {str_subset(raw, fixed(.))} ) %>% c(recursive=T) 

str_replace(y, '^\\w+\t', '') %>% str_split(fixed('\t')) %>% c(recursive=T)  %>% str_subset('LOC_Os03g61120|LOC_Os03g61890|LOC_Os03g61940|LOC_Os03g62650|LOC_Os03g63330|LOC_Os03g63950|LOC_Os04g04230|LOC_Os04g08350|LOC_Os04g09900|LOC_Os04g10060') 

raw[2766] %>% stringr::str_count('\t') %>% {.[.==max(.)]}
```

to do: ensembl annotation
to do: gene name

Ensembl ftp https://www.ensembl.org/info/data/ftp/index.html


zm's gmap takes too long time (0:40~16:40) so I killed it. No matter I use `-k 13` or even  `-k 9` you still needs about 5G's swap, when I reach `SACA_K called with n = 2058582554, K = 5, level 0`


```bash
mkdir data-raw/tmp
gzip -dc data-raw/pep/*gz > data-raw/tmp/pep;
gzip -dc data-raw/gtf/*gz > data-raw/tmp/gtf;
```



# 10/14

- analyse gene name pattern

```bash
gzip -dc data-raw/gtf/Oryza_sativa.MSU6.15.gtf.gz  | awk -F '\t' '{print $9}' | awk '{print $2}' | sed 's/[";]//g' | grep -P '^LOC_Os\w+$|^\d{5}\.t\d{5}$|^\d+\.pre-tRNA-\w{3}-\d$' -v | head # '^LOC_Os\w+|\d{5}\.t\d{5}|\d{5}\.pre-tRNA-[a-zA-Z]{3}-\d$'
gzip -dc data-raw/gtf/Brachypodium_distachyon.v1.0.15.gtf.gz  | awk -F '\t' '{print $9}' | awk '{print $2}' | sed 's/[";]//g' | grep -P '^BRADI\w+' -v | head  
gzip -dc data-raw/gtf/Sorghum_bicolor.Sorbi1.15.gtf.gz   | awk -F '\t' '{print $9}' | awk '{print $2}' | sed 's/[";]//g' |  grep -P '^Sb\w+$|^sbi-MIR\w+$' -v | head
gzip -dc data-raw/gtf/Zea_mays.AGPv2.15.gtf.gz  | awk -F '\t' '{print $9}' | awk '{print $2}' | sed 's/[";]//g' | grep -P '^GRMZM\w+$|^[A-Z]{2}\d+\.\d_FG\d{3}$' -v | head   # '^GRMZM\dG\d{6}|[A-Z]{2}\d{5,6}\.\d_FG\d{3}$'
gzip -dc data-raw/gtf/Vitis_vinifera.IGGP_12x.15.gtf.gz  | awk -F '\t' '{print $9}' | awk '{print $2}' | sed 's/[";]//g' | grep -P '^Vv\w+$' -v | head
gzip -dc data-raw/gtf/Arabidopsis_thaliana.TAIR10.15.gtf.gz  | awk -F '\t' '{print $9}' | awk '{print $2}' | sed 's/[";]//g' | grep -P '^AT\w+$' -v | head  
gzip -dc data-raw/gtf/Populus_trichocarpa.JGI2.0.15.gtf.gz  | awk -F '\t' '{print $9}' | awk '{print $2}' | sed 's/[";]//g' | grep -P '^POPTR_\w+$' -v | head # '^POPTR_\d{4}s\d{5}$'
```

- analyse `data-raw/EVS009_Supplemental_dataset_S1_pluslinks.xls`

```bash
# extract gene name in gtf and pep.fa
> data-raw/gene.name
gzip -dc data-raw/gtf/*gz | awk -F '\t' '{print $9}' | awk '{print $2}' | sed 's/[";]//g' >> data-raw/gene.name ;
gzip -dc data-raw/pep/*gz | grep '>'  | awk '{print $4}' | sed 's/gene://'  >> data-raw/gene.name;
cat data-raw/gene.name | sort -u | sponge data-raw/gene.name;
```

```r
library(stringr); 
library(readr); 
read_lines('unitary_gene_loss_detection/EVS009_Supplemental_dataset_S1_pluslinks.tsv')[-1] %>% str_replace_all('chr[\\w\\W]+?\t', '\t') %>% str_replace('\thttp[\\w\\W]+$', '')  %>% str_replace_all('\\|\\|', '\t') %>% str_split('\t') %>% c(recursive=T) %>% {.[str_length(.) > 0]} %>% sort %>% unique %>% write_lines('data-raw/gene2.name');
read_lines('data-raw/demo/EVS009_Supplemental_dataset_S1_pluslinks.tsv')[-1] %>% str_replace_all('chr[\\w\\W]+?\t', '\t') %>% str_replace('\thttp[\\w\\W]+$', '')  %>% str_replace_all('\\|\\|', '\t') %>% str_split('\t') %>% c(recursive=T) %>% {.[str_length(.) > 0]} %>% sort %>% unique %>% write_lines('data-raw/gene3.name');
```

```bash
setdiff data-raw/gene2.name data-raw/gene.name > data-raw/gene.diff;
setdiff data-raw/gene3.name data-raw/gene.name 


cat data-raw/gene.diff | grep -P '^GRMZM\w+$|^[A-Z]{2}\d+\.\d_FG\d{3}$' -c   # zm gene
cat data-raw/gene.diff | grep -P '^BRADI\wG\w+$' -c                          # bdi gene
cat data-raw/gene.diff | grep -P '^LOC_Os\w+$' -c                            # osm (rice) gene
cat data-raw/gene.diff | grep -P '^[A-Z]{2}\d+\.\d_FGT\d{3}$' -c             # zm transcript
cat data-raw/gene.diff | grep -P '^BRADI\w+\.\d{2}$' -c                      # bdi transcipt

cat data-raw/gene.diff | grep -P '^GRMZM\w+$|^[A-Z]{2}\d+\.\d_FG\d{3}$' -v | grep -P '^BRADI\wG\w+$' -v | grep -P '^LOC_Os\w+$' -v | grep -P '^[A-Z]{2}\d+\.\d_FGT\d{3}$' -v | grep -P '^BRADI\w+\.\d{2}$' -v


cat data-raw/gene.diff | wc -l
echo 1634+2083+55+138+11 | bc
echo 1634+55 | bc
echo 2083+11 | bc


cat data-raw/gene.diff | grep -P '^[A-Z]{2}\d+\.\d_FGT\d{3}$' > /tmp/zm1;
gzip -dc data-raw/gtf/Zea* | awk -F '\t' '{print $9}'  | awk '{print $4}'  | sed 's/[";]//g' | sort -u > /tmp/zm2;

setdiff /tmp/zm1 /tmp/zm2 | wc -l;


cat data-raw/gene.diff | grep -P '^BRADI\w+\.\d{2}$' > /tmp/bdi1;
gzip -dc data-raw/gtf/Brachy* | awk -F '\t' '{print $9}'  | awk '{print $4}'  | sed 's/[";]//g' | sort -u > /tmp/bdi2;

setdiff /tmp/bdi1 /tmp/bdi2 | wc -l;
```


- how I choose keyword for match forbidden gene

```bash
filter_embl () {
    long=$1
    # 19 ' '
    gzip -dc data-raw/embl/$long* | grep '^FT ' | grep -v db_xref | grep 'FT                   /' > data-raw/tmp/$long;
}

for i in {0..6}; do filter_embl ${species2[$i]}; done

cat data-raw/tmp/* | grep chloropl |  grep -v chloroplast # match chloroplast
cat data-raw/tmp/* | grep -v [Cc]hloroplastic | grep plasti |  grep -v plastid  # phragmoplastin and tonoplastic shouldn't be filtered
cat data-raw/tmp/* | grep transpos |  sort -u # there is many classes, but we only use transposable_element for simplicity
cat data-raw/tmp/* | grep mitochon |  grep -v mitochondri[ao]  #  match mitochondrion
```

- check forbidden gene list

```bash
setdiff data-raw/demo/forbidden_gene_list.tsv unitary_gene_loss_detection/forbidden_gene_list.tsv
```



# 10/15

after address the three questions, I rewrite `pre.sh` and rerun PseudoPipe (omit zm and sbi_zm)

```bash
find unitary_gene_loss_detection -name '*_pgenes.txt' | grep -v 'modi' | grep -v 'zm' | xargs md5sum
find pgenes/ppipe_output -name '*_pgenes.txt'  | grep -v 'zm' | xargs md5sum

find -name 'bdi_pgenes.txt' | grep 'output/bdi/' | xargs -n 2 code -d
find -name 'osm_pgenes.txt' | grep 'output/osmbdi/' | xargs -n 2 code -d
```


- forbidden gene list did make soem difference

for bdi, 'GRMZM5G803365' removes

```
orthologous_group_15234_containing_osm_1_bdi_0_sbi_1_zm_1_viv_1_ath_1_pop_1_total_6	AT1G52560	POPTR_0001s19320	Vv09s0002g06790	Sb04g006890	GRMZM5G803365	LOC_Os02g10710
```

for osm, 'AT5G65460' and 'AT2G46910' removes

```
orthologous_group_999_containing_osm_0_bdi_1_sbi_1_zm_1_viv_1_ath_2_pop_3_total_9	AT5G10470	POPTR_0007s14340	POPTR_0007s14330	POPTR_0007s14320	Vv00s0313g00080	Sb10g007360	GRMZM2G017257	BRADI1G45833	AT5G65460
orthologous_group_12985_containing_osm_0_bdi_1_sbi_1_zm_2_viv_1_ath_1_pop_1_total_7	AT2G46910	Vv15s0048g02190	POPTR_0002s18460	Sb01g017450	BRADI3G30740	GRMZM2G026800	AC221033.3_FG001
```

change forbidden gene list again，and only sbi, bdi are effected

```bash
find unitary_gene_loss_detection -name 'ortho*.tsv'  | grep -v 'zm' | xargs md5sum
```



- gene loss paper:

  - [Constrained vertebrate evolution by pleiotropic genes](https://www.nature.com/articles/s41559-017-0318-0)
  - [Slow evolutionary loss of the potential for interspecific hybridization in birds: a manifestation of slow regulatory evolution](http://www.pnas.org/content/72/1/200.short)
  - [Gene loss, thermogenesis, and the origin of birds](http://onlinelibrary.wiley.com/doi/10.1111/nyas.12090/full)
  - [Dynamics of genome size evolution in birds and mammals](http://www.pnas.org/content/114/8/E1460.full)
  - [Evolution of the chicken Toll-like receptor gene family: A story of gene gain and gene loss](https://bmcgenomics.biomedcentral.com/articles/10.1186/1471-2164-9-62)
  - [Genomics of Gene Gain and Gene Loss in Eukaryotes](http://pubman.mpdl.mpg.de/pubman/faces/viewItemOverviewPage.jsp?itemId=escidoc:2430323)



# delay one day

```bash
wc unitary_gene_loss_detection/*/ortho* -l

wc unitary_gene_loss_detection/*/class*/*/FP.group -l
wc unitary_gene_loss_detection/*/class*/*/relic-lacking.group -l
wc unitary_gene_loss_detection/*/class*/*/relic-retaining.group -l

wc unitary_gene_loss_detection/*/*/*/relic-retaining_*info -l
wc unitary_gene_loss_detection/*/*/*/relic-lacking_*info -l
```

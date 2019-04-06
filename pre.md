---
title: prerequisite for pipeline
---



# env variable

```bash
# add  to PATH
# Unitary_Gene_Loss_Detection_Pipeline/, tfasty35, pgenes/pseudopipe/bin/

export data="/path/to/project/data-raw"
export dir="/path/to/project/unitary_gene_loss_detection"
export pipei="/path/to/project/pgenes/ppipe_input",


export species=('oryza_sativa' 'sorghum_bicolor' 'zea_mays' 'brachypodium_distachyon' 'arabidopsis_thaliana' 'populus_trichocarpa' 'vitis_vinifera')
    # sorted by ((1,4),(2,3))
export species2=(`echo ${species[*]} | sed 's/\b[a-z]/\U&/g'`) # toupper first letter
export abbrs=('osm' 'sbi' 'zm' 'bdi');
export abbrs2=('sbi_zm' 'osm_bdi');
declare -A longs
export longs=([osm]='Oryza_sativa.MSU6.15' [sbi]='Sorghum_bicolor.Sorbi1.15' [zm]='Zea_mays.AGPv2.15' [bdi]='Brachypodium_distachyon.v1.0.15')
```



# software

- PseudoPipe  
  in `bin/pseudopipe.sh`, `3.1e9` should be `310000000` and `source setenvPipelineVars` should be `source ./setenvPipelineVars`

- tfasty   
  should use 35， never 36

- `Unitary_Gene_Loss_Detection_Pipeline/`  
  `unitary_gene_loss_detection_pipeline.sh` line 8 最后的 `don` 应该为 `done`



# data

- `dna/` and `pep/` comes from Ensembl plants 15
- `demo/`: I manually copy the demo output from pipeline webpage and save, in order to compare with my own output by `md5sum`.
- `EVS009_Supplemental_dataset_S1_pluslinks.xls` comes from [Schnable et al.](http://gbe.oxfordjournals.org/content/early/2012/01/23/gbe.evs009.abstract)
- `gene-loss-zhao.xlsx` is additional file 1 of [Zhao et al, 2015](https://doi.org/10.1186/s12862-015-0345-x)

```
$tree data-raw
data-raw
├── demo
│   ├── EVS009_Supplemental_dataset_S1_pluslinks.tsv
│   ├── forbidden_gene_list.tsv
│   ├── orthologous_groups.tsv
│   ├── orthologous_groups_with_candidate_unitary_gene_loss_in_sbi.tsv
│   ├── relic-lacking.group
│   ├── relic-lacking_unitary_gene_loss_of_sbi.info
│   ├── relic-retaining.group
│   ├── relic-retaining_unitary_gene_loss_of_sbi.info
│   ├── unitary_gene_loss_info_for_sbi.tsv
│   └── unitary_gene_loss_info_for_sbi_zm.tsv
├── dna
│   ├── Arabidopsis_thaliana.TAIR10.dna.chromosome.1.fa.gz
│   ├── Arabidopsis_thaliana.TAIR10.dna.chromosome.2.fa.gz
│   ├── Arabidopsis_thaliana.TAIR10.dna.chromosome.3.fa.gz
│   ├── Arabidopsis_thaliana.TAIR10.dna.chromosome.4.fa.gz
│   ├── Arabidopsis_thaliana.TAIR10.dna.chromosome.5.fa.gz
│   ├── Arabidopsis_thaliana.TAIR10.dna_rm.chromosome.1.fa.gz
│   ├── Arabidopsis_thaliana.TAIR10.dna_rm.chromosome.2.fa.gz
│   ├── Arabidopsis_thaliana.TAIR10.dna_rm.chromosome.3.fa.gz
│   ├── Arabidopsis_thaliana.TAIR10.dna_rm.chromosome.4.fa.gz
│   ├── Arabidopsis_thaliana.TAIR10.dna_rm.chromosome.5.fa.gz
│   ├── Brachypodium_distachyon.v1.0.15.dna.chromosome.1.fa.gz
│   ├── Brachypodium_distachyon.v1.0.15.dna.chromosome.2.fa.gz
│   ├── Brachypodium_distachyon.v1.0.15.dna.chromosome.3.fa.gz
│   ├── Brachypodium_distachyon.v1.0.15.dna.chromosome.4.fa.gz
│   ├── Brachypodium_distachyon.v1.0.15.dna.chromosome.5.fa.gz
│   ├── Brachypodium_distachyon.v1.0.15.dna_rm.chromosome.1.fa.gz
│   ├── Brachypodium_distachyon.v1.0.15.dna_rm.chromosome.2.fa.gz
│   ├── Brachypodium_distachyon.v1.0.15.dna_rm.chromosome.3.fa.gz
│   ├── Brachypodium_distachyon.v1.0.15.dna_rm.chromosome.4.fa.gz
│   ├── Brachypodium_distachyon.v1.0.15.dna_rm.chromosome.5.fa.gz
│   ├── Oryza_sativa.MSU6.15.dna.chromosome.10.fa.gz
│   ├── Oryza_sativa.MSU6.15.dna.chromosome.11.fa.gz
│   ├── Oryza_sativa.MSU6.15.dna.chromosome.12.fa.gz
│   ├── Oryza_sativa.MSU6.15.dna.chromosome.1.fa.gz
│   ├── Oryza_sativa.MSU6.15.dna.chromosome.2.fa.gz
│   ├── Oryza_sativa.MSU6.15.dna.chromosome.3.fa.gz
│   ├── Oryza_sativa.MSU6.15.dna.chromosome.4.fa.gz
│   ├── Oryza_sativa.MSU6.15.dna.chromosome.5.fa.gz
│   ├── Oryza_sativa.MSU6.15.dna.chromosome.6.fa.gz
│   ├── Oryza_sativa.MSU6.15.dna.chromosome.7.fa.gz
│   ├── Oryza_sativa.MSU6.15.dna.chromosome.8.fa.gz
│   ├── Oryza_sativa.MSU6.15.dna.chromosome.9.fa.gz
│   ├── Oryza_sativa.MSU6.15.dna_rm.chromosome.10.fa.gz
│   ├── Oryza_sativa.MSU6.15.dna_rm.chromosome.11.fa.gz
│   ├── Oryza_sativa.MSU6.15.dna_rm.chromosome.12.fa.gz
│   ├── Oryza_sativa.MSU6.15.dna_rm.chromosome.1.fa.gz
│   ├── Oryza_sativa.MSU6.15.dna_rm.chromosome.2.fa.gz
│   ├── Oryza_sativa.MSU6.15.dna_rm.chromosome.3.fa.gz
│   ├── Oryza_sativa.MSU6.15.dna_rm.chromosome.4.fa.gz
│   ├── Oryza_sativa.MSU6.15.dna_rm.chromosome.5.fa.gz
│   ├── Oryza_sativa.MSU6.15.dna_rm.chromosome.6.fa.gz
│   ├── Oryza_sativa.MSU6.15.dna_rm.chromosome.7.fa.gz
│   ├── Oryza_sativa.MSU6.15.dna_rm.chromosome.8.fa.gz
│   ├── Oryza_sativa.MSU6.15.dna_rm.chromosome.9.fa.gz
│   ├── Sorghum_bicolor.Sorbi1.15.dna.chromosome.10.fa.gz
│   ├── Sorghum_bicolor.Sorbi1.15.dna.chromosome.1.fa.gz
│   ├── Sorghum_bicolor.Sorbi1.15.dna.chromosome.2.fa.gz
│   ├── Sorghum_bicolor.Sorbi1.15.dna.chromosome.3.fa.gz
│   ├── Sorghum_bicolor.Sorbi1.15.dna.chromosome.4.fa.gz
│   ├── Sorghum_bicolor.Sorbi1.15.dna.chromosome.5.fa.gz
│   ├── Sorghum_bicolor.Sorbi1.15.dna.chromosome.6.fa.gz
│   ├── Sorghum_bicolor.Sorbi1.15.dna.chromosome.7.fa.gz
│   ├── Sorghum_bicolor.Sorbi1.15.dna.chromosome.8.fa.gz
│   ├── Sorghum_bicolor.Sorbi1.15.dna.chromosome.9.fa.gz
│   ├── Sorghum_bicolor.Sorbi1.15.dna_rm.chromosome.10.fa.gz
│   ├── Sorghum_bicolor.Sorbi1.15.dna_rm.chromosome.1.fa.gz
│   ├── Sorghum_bicolor.Sorbi1.15.dna_rm.chromosome.2.fa.gz
│   ├── Sorghum_bicolor.Sorbi1.15.dna_rm.chromosome.3.fa.gz
│   ├── Sorghum_bicolor.Sorbi1.15.dna_rm.chromosome.4.fa.gz
│   ├── Sorghum_bicolor.Sorbi1.15.dna_rm.chromosome.5.fa.gz
│   ├── Sorghum_bicolor.Sorbi1.15.dna_rm.chromosome.6.fa.gz
│   ├── Sorghum_bicolor.Sorbi1.15.dna_rm.chromosome.7.fa.gz
│   ├── Sorghum_bicolor.Sorbi1.15.dna_rm.chromosome.8.fa.gz
│   ├── Sorghum_bicolor.Sorbi1.15.dna_rm.chromosome.9.fa.gz
│   ├── Zea_mays.AGPv2.15.dna.chromosome.10.fa.gz
│   ├── Zea_mays.AGPv2.15.dna.chromosome.1.fa.gz
│   ├── Zea_mays.AGPv2.15.dna.chromosome.2.fa.gz
│   ├── Zea_mays.AGPv2.15.dna.chromosome.3.fa.gz
│   ├── Zea_mays.AGPv2.15.dna.chromosome.4.fa.gz
│   ├── Zea_mays.AGPv2.15.dna.chromosome.5.fa.gz
│   ├── Zea_mays.AGPv2.15.dna.chromosome.6.fa.gz
│   ├── Zea_mays.AGPv2.15.dna.chromosome.7.fa.gz
│   ├── Zea_mays.AGPv2.15.dna.chromosome.8.fa.gz
│   ├── Zea_mays.AGPv2.15.dna.chromosome.9.fa.gz
│   ├── Zea_mays.AGPv2.15.dna_rm.chromosome.10.fa.gz
│   ├── Zea_mays.AGPv2.15.dna_rm.chromosome.1.fa.gz
│   ├── Zea_mays.AGPv2.15.dna_rm.chromosome.2.fa.gz
│   ├── Zea_mays.AGPv2.15.dna_rm.chromosome.3.fa.gz
│   ├── Zea_mays.AGPv2.15.dna_rm.chromosome.4.fa.gz
│   ├── Zea_mays.AGPv2.15.dna_rm.chromosome.5.fa.gz
│   ├── Zea_mays.AGPv2.15.dna_rm.chromosome.6.fa.gz
│   ├── Zea_mays.AGPv2.15.dna_rm.chromosome.7.fa.gz
│   ├── Zea_mays.AGPv2.15.dna_rm.chromosome.8.fa.gz
│   └── Zea_mays.AGPv2.15.dna_rm.chromosome.9.fa.gz
├── EVS009_Supplemental_dataset_S1_pluslinks.xls
├── gene-loss-zhao.xlsx
└── pep
    ├── Arabidopsis_thaliana.TAIR10.15.pep.all.fa.gz
    ├── Brachypodium_distachyon.v1.0.15.pep.all.fa.gz
    ├── Oryza_sativa.MSU6.15.pep.all.fa.gz
    ├── Populus_trichocarpa.JGI2.0.15.pep.all.fa.gz
    ├── Sorghum_bicolor.Sorbi1.15.pep.all.fa.gz
    ├── Vitis_vinifera.IGGP_12x.15.pep.all.fa.gz
    └── Zea_mays.AGPv2.15.pep.all.fa.gz

3 directories, 103 files
```



# orthologous relationships

I don't whether the following command can run, but you can a copy from netdisk

```bash
mysql -h mysql-eg-publicsql.ebi.ac.uk -P 4157 -u anonymous -e "use ensembl_compara_plants_15_68; select homology.homology_id, homology.description, homology.subtype, ncbi_taxa_name.name, member.stable_id from homology, homology_member, member, ncbi_taxa_name where member.taxon_id = ncbi_taxa_name.taxon_id and homology_member.member_id = member.member_id and homology.homology_id = homology_member.homology_id and homology.description like 'ortholog%' and (ncbi_taxa_name.name = 'Oryza sativa japonica' or ncbi_taxa_name.name = 'Brachypodium distachyon' or ncbi_taxa_name = 'Sorghum bicolor' or ncbi_taxa_name.name = 'Zea mays' or ncbi_taxa_name.name = 'Vitis vinifera' or ncbi_taxa_name.name = 'Arabidopsis thaliana' or ncbi_taxa_name.name = 'Populus trichocarpa') ;" > $dir/orthologous_relationships.tsv
```



# forbidden genes

```bash
embl2forbid () {
    long=$1
    # 19 ' '
    gzip -dc $data/embl/$long* | grep '^FT ' | grep -v db_xref | grep 'FT                   /' > /tmp/$long;
    R -e "library(stringr);readr::read_lines('/tmp/$long') %>% str_c(collapse = '\n') %>% str_split('/gene') %>% {.[[1]][-1]} %>% str_subset('chloroplast|plastid|mitochondri[ao]|transposable_element') %>% str_extract('^[\\\\w\\\\W]+?(?=\n)') %>% str_replace_all('[=\"]', '') %>% unique %>% readr::write_lines('$dir/forbidden_gene_list.tsv', append=T)";
}

> $dir/forbidden_gene_list.tsv;
for i in {0..6}; do embl2forbid ${species2[$i]}; done

forbidden='transposable_element|chloroplast|mitochondrion|Mt|Pt';
gzip -dc $data/gtf/*gz | grep -E "$forbidden" | awk '{print $10}' | awk -F '"' '{print $2}' >> $dir/forbidden_gene_list.tsv;

cat $dir/forbidden_gene_list.tsv | sort -u | sponge $dir/forbidden_gene_list.tsv;
gzip -dc $data/pep/*gz | grep '>' | grep -Po '(?<=gene:)[\w_]+' | sort -u | join $dir/forbidden_gene_list.tsv - | sponge $dir/forbidden_gene_list.tsv;
```



# synteny relationships

```bash
dataset="data-raw/EVS009_Supplemental_dataset_S1_pluslinks";
cd ${dir}; R -e "readxl::read_excel('$dataset.xls') %>% readr::write_tsv('$dataset.tsv', na= '')";
sed -r -e 's/Os/LOC_Os/g' -e 's/Bradi([0-9])g/BRADI\1G/g' -i  $dataset.tsv
mv $dataset.tsv $dir
```



# longest prptein

```r
files <- dir('data-raw/pep', pattern = 'gz', full.names = T);

preserve_longest_protein <- function(file) {
    get_longest_string <- function(string) {
        string %>% stringr::str_length() %>% {. == max(.)} %>% {which(.)[1]} %>% {string[.]};
    }
    
    pep <- bioinfor::read_fasta(file)
    gene.name <- pep %>% names() %>% stringr::str_extract('(?<=gene:)[\\w\\._]+');
    file %<>% stringr::str_replace('all.fa.gz', 'longest.fa');
    tapply(pep, gene.name, get_longest_string) %>% bioinfor::write_fasta(file);
}

lapply(files, preserve_longest_protein);
```



# prepare candidate unitary gene loss

```bash
cd ${dir};
echo 'osm'       | ${dir}/candidate-gene-loss.sh;
echo 'bdi'       | ${dir}/candidate-gene-loss.sh;
echo 'sbi'       | ${dir}/candidate-gene-loss.sh;
echo 'zm'        | ${dir}/candidate-gene-loss.sh;
echo 'osm bdi'   | ${dir}/candidate-gene-loss.sh;
echo 'sbi zm'    | ${dir}/candidate-gene-loss.sh;
cd ..;
```



# PseduoPipe


```bash
pre_pep() {
    abbr=$1  # you must be in `$pipei/$abbr`
    cat $dir/$abbr/orthologous_*_in_$abbr.tsv | sed -E 's/^\w+'$'\t''//'  | sed -E 's/'$'\t''/\n/g' | sort -u > pep/name;
    R -e "bioinfor::read_fasta('pep/pep.fa') %>% {.[names(.) %in% readr::read_lines('pep/name')]} %>% bioinfor::write_fasta('pep/pep.fa')"
    rm pep/name;
}
```

- 1.1. prepare input for one species

```bash
pre_ppipe() {
    #" clean and perpare env variables and workspace
    abbr=$1; species=$2; counterpart=$3;
    trash $pipei/$abbr/*; mkdir -p $pipei/$abbr/{dna,pep,mysql}; cd $pipei/$abbr;
    #" dna
    cp $data/dna/$species*dna.*[0-9]* dna; gzip -df dna/*gz; 
    gzip -dc $data/dna/$species*dna_rm.*[0-9]* > dna/dna_rm.fa;
    #" mysql
    gzip -dc ${data}/gtf/$species* | sed '/^GL/d' | awk '/exon\t/{t="\t"; print $1 t $7 t $4 t $5}' | sort -u |  awk '{print $0 > "mysql/chr"$1"_exLocs" }'
    #" pep
    cat ${data}/pep/$counterpart*.pep.longest.fa > pep/pep.fa; pre_pep $abbr;
}

pre_ppipe osm Oryza_sativa            Brachypodium_distachyon;
pre_ppipe sbi Sorghum_bicolor         Zea_mays;
pre_ppipe zm  Zea_mays                Sorghum_bicolor;
pre_ppipe bdi Brachypodium_distachyon Oryza_sativa;

#" remoe extra `exLocs` files (I don't want to make the `awk` in pep more sophisticated )
find $pipei -name '*exLocs' | grep -P '/chr[^0-9I]' | xargs rm # I to avoid rm c.elegans
```

- 1.2. run PseduoPipe for one species

```bash
run_ppipe() {
    abbr=$1; name=$2;
    trash ${pipeo}/$abbr/*; 
    time ${pipeb}/pseudopipe.sh ${pipeo}/$abbr ${pipei}/$abbr/dna/dna_rm.fa ${pipei}/$abbr/dna/$name.dna.chromosome.%s.fa ${pipei}/$abbr/pep/pep.fa ${pipei}/$abbr/mysql/chr%s_exLocs 0
}

run_ppipe osm Oryza_sativa.MSU6.15;
run_ppipe sbi Sorghum_bicolor.Sorbi1.15;
run_ppipe zm  Zea_mays.AGPv2.15;
run_ppipe bdi Brachypodium_distachyon.v1.0.15;
```

- 2.1. prepare `pep.fa` for MRCA of two species

```bash
pre_ppipe2() {
    ### clean and perpare env variables and workspace
    abbr=$1; name1=$2; name2=$3;
    trash $pipei/$abbr/*; mkdir -p $pipei/$abbr/pep; cd $pipei/$abbr;
    ###pep
    cat $data/pep/{$name1,$name2}.pep.longest.fa > pep/pep.fa; pre_pep $abbr;  
}

pre_ppipe2 osm_bdi Sorghum_bicolor.Sorbi1.15 Zea_mays.AGPv2.15;
pre_ppipe2 sbi_zm  Oryza_sativa.MSU6.15      Brachypodium_distachyon.v1.0.15;
```

- 2.2. run PseudoPipe for MRCA of two species

```bash
run_ppipe2() {
    abbr=$1; abbr1=$2; name=$3;
    trash ${pipeo}/$abbr/$abbr1;

    time ${pipeb}/pseudopipe.sh ${pipeo}/$abbr/$abbr1 ${pipei}/$abbr1/dna/dna_rm.fa ${pipei}/$abbr1/dna/$name.dna.chromosome.%s.fa ${pipei}/$abbr/pep/pep.fa ${pipei}/$abbr1/mysql/chr%s_exLocs 0;
}

run_ppipe2 osm_bdi osm Oryza_sativa.MSU6.15;
run_ppipe2 osm_bdi bdi Brachypodium_distachyon.v1.0.15;

run_ppipe2 sbi_zm sbi Sorghum_bicolor.Sorbi1.15;
run_ppipe2 sbi_zm zm  Zea_mays.AGPv2.15;
```

- 3. move PseudoPipe output

```bash
cp -r pgenes/ppipe_output $dir;
```



# GMAP


```bash
#" you have to prepare PseudoPipe input first since I use dna files in ${pipei}/*/dna/
mkdir $dir/GMAP_database;

run_gmap () {
    abbr=$1;
    time gmap_build -d $abbr  ${pipei}/$abbr/dna/*dna.* -D "$dir/GMAP_database"
}

run_gmap osm;
run_gmap sbi;
run_gmap bdi;


nohup time gmap_build -d zm -k 9 --no-sarray ${pipei}/zm/dna/*dna.* -D "$dir/GMAP_database" &> gmap.log &
```



# blast database

```bash
#" formatdb -o T -p T -t .. -n ..
cat $data/pep/*longest* | makeblastdb -parse_seqids -dbtype 'prot' -title 'Poaceae_viv_ath_pop_longest' -out $dir/BLAST_database/Poaceae_viv_ath_pop_longest
```

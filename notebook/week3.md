# 09/24

Ensembl Plants 和 Ensembl Genomes 最新的 Release 都是 37，所以二者的版本号应该是一致的（虽然 Ensembl 已经到 90 了）

根据源码推测， `fetchEnsemblFilesPlants.py` 的参数应该是 'Species name' [release],比如

```bash
cd "data-raw"
fetchEnsemblFilesPlants.py 'Sorghum bicolor' 15 > /dev/null &
fetchEnsemblFilesPlants.py 'Brachypodium distachyon' 15 > /dev/null &
fetchEnsemblFilesPlants.py 'Zea mays' 15 > /dev/null &
fetchEnsemblFilesPlants.py 'Oryza sativa' 15 > /dev/null &
```

顺便吐槽一下，pipeline webpage 上的物种名有问题 "Brachypodium distachyon" 成了 "Brachypodium distachchyon" 害我半天找不着

```bash
sudo apt -y install ncbi-blast+-legacy
```

edit `pgenes/pseudopipe/bin/env.sh` to run `PseudoPipe`

以 Sorghum bicolor 为例，Ensembl 给出的 pep 有重复现象， 比如 all 中的 Sb08g019235.1 和 Sb01g027164.1 这两个转录本的序列都是 VQINNGK...

这里我们暂定选用更多的 abinitio 而不是 all

[`mysql/exon.txt`](https://www.ensembl.org/info/docs/api/core/core_schema.html#exon)

ftp://ftp.ensemblgenomes.org/pub/release-15/plants/

`awk '{print $10}' sbi/mysql/exon.txt | grep Sb | sed -E 's/\w+.[0-9]_exon_//g' | sort | uniq -c | sort -k 1 -nr`

`gzip -c | head ` will cause broken pipe, but `gzip -d`



# 10/01

for gmap, 54M fa = 2m8s + 752M, 640M fa = 20m + 6.2G    

```bash
time gmap_build -d sbi sbi/dna/Sorghum_bicolor.Sorbi1.15.dna.chromosome.*.fa -D "unitary_gene_loss_detection/GMAP_database"
```

# access ensembl by mysql

http://ensemblgenomes.org/info/access/mysql
https://www.ensembl.org/info/docs/api/debug_installation_guide.html



# gmap

```bash
./configure --prefix=$HOME/.local/gmap
make; make check; make install
```



# pipeline 前面的部分

```bash
## detect candidate gene loss
cd unitary_gene_loss_detection
rm -r osm bdi sbi zm osm_bdi sbi_zm
echo 'osm'       | ./main.sh
echo 'bdi'       | ./main.sh
echo 'sbi'       | ./main.sh
echo 'zm'        | ./main.sh
echo 'osm bdi'   | ./main.sh
echo 'sbi zm'    | ./main.sh

## analyse gene loss number and compare with Zhao's
cd unitary_gene_loss_detection
find . -name *_in*.tsv | xargs wc -l
setdiff sbi/orthologous_groups_with_candidate_unitary_gene_loss_in_sbi.tsv ../data-raw/orthologous_groups_with_candidate_unitary_gene_loss_in_sbi.tsv  > sbi_fliter
```
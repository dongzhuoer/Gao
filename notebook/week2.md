# 09/17

for pipeline's demo, **sbi**. The genome _Sorghum bicolor v1.0_ has been updated to [Sorghum_bicolor_NCBIv3](https://www.ncbi.nlm.nih.gov/assembly/GCF_000003195.1/). [Ensembl](http://archive.plants.ensembl.org/Sorghum_bicolor/Info/Index) still uses the old 1.0 version, but its ftp is temporarily unavailable. So I download the fasta file form [NCBI](ftp://ftp.ncbi.nlm.nih.gov/genomes/genbank/plant/Sorghum_bicolor/all_assembly_versions/GCA_000003195.1_Sorbi1)

download successfully and md5sum check passed

Update: later the ftp recovered and `bin/fetchEnsemblFilesPlants.py` works fine for retrieve data



# 09/18

无法找到 `EVS009_Supplemental_dataset_S1_pluslinks.tsv`，论文中只有 `.xls`，将其另存为 `.tsv` 后。用md5sum检查发现与pipeline中给出的示例不一致，后来手动检查发现全文都没有示例第二行的 "LOC_Os05g39500" 这一项。

暂时先用WPS另存的，到 classify_candidate 这一步再看吧



# 09/23

关于 `orthologous_groups.tsv`，我自己生成的和网上示例是完全一样的（这个之前应该检查过来，但没有记下来，害我又检查了好久。）

但是网上并没有说该去哪里找 `forbidden_gene_list.tsv`， 不过建一个空文件可以凑合

没有任何 filter 时共有 629 个候选 gene loss （在两个物种中同时丢失算一件）

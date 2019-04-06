# Overview

internship at Ge Gao's lab


# Weekly Report

```r
dir('weekly-report', 'md', full = T) %>% lapply(
    rmarkdown::render, prettydoc::html_pretty(toc = T), output_dir = 'docs/weekly-report/'
)
```

refer to netdisk  for `.docx` I submitted, paper read note, and 2017-08-27,

[netdisk](https://cloud.tsinghua.edu.cn/d/17342eb01cf74bb69156/)

download [DongZ-WeeklyReport.docx](https://github.com/dongzhuoer/Gao/blob/master/weekly-report/DongZ-WeeklyReport.docx), then `pandoc -i *.md -o *.docx --reference-docx=DongZ-WeeklyReport.docx`







# main reference

1. [Paten et al, 2017](https://dx.doi.org/10.1101/gr.214155.116)  
   _Genome graphs and the evolution of genome inference_
1. [Albalat & Cañestro, 2016](https://doi.org/10.1038/nrg.2016.39)  
   _Evolution by gene loss_
1. [Zhao et al, 2015](https://doi.org/10.1186/s12862-015-0345-x)  
   _Identification and analysis of unitary loss of long-established protein-coding genes in Poaceae shows evidences for biased gene loss and putatively functional transcription of relics_



#  species name and id 

| name          | species                     | gene name  (^$ is omitted)                           | Chinese name | tax_id |
| ------------- | --------------------------- | ---------------------------------------------------- | ------------ | ------ |
| rice          | Oryza sativa Japonica Group | LOC_Os\w+ or \d{5}\.t\d{5} or \d+\.pre-tRNA-\w{3}-\d |              | 39947  |
| brachypodium  | Brachypodium distachchyon   | BRADI\w+                                             |              | 15368  |
| sorghum       | Sorghum bicolor             | Sb\w+ or sbi-MIR\w+                                  |              | 4558   |
| maize         | Zea mays                    | GRMZM\w+ or [A-Z]{2}\d+\.\d_FG\d{3}                  |              | 4577   |
| grape         | Vitis vinifera              | Vv\w+                                                |              |        |
| _Arabidopsis_ | Arabidopsis thaliana        | AT\w+                                                |              |        |
| poplar        | Populus trichocarpa         | POPTR_\w+                                            | 杨树         |        |



# afterword

how to improve research proposal

- user-friendly interface
- new pseudopipe
- complex phylogenetic relationship

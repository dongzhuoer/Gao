# Gao

```r
dir('weekly-report', 'md', full = T) %>% lapply(
    rmarkdown::render, prettydoc::html_pretty(toc = T), output_dir = 'docs/weekly-report/'
)
```

pandoc -i *.md -o *.docx --reference-docx=DongZ-WeeklyReport.docx

## main reference

1. [Paten et al, 2017](https://dx.doi.org/10.1101/gr.214155.116)  
   _Genome graphs and the evolution of genome inference_
1. [Albalat & Cañestro, 2016](https://doi.org/10.1038/nrg.2016.39)  
   _Evolution by gene loss_
1. [Zhao et al, 2015](https://doi.org/10.1186/s12862-015-0345-x)  
   _Identification and analysis of unitary loss of long-established protein-coding genes in Poaceae shows evidences for biased gene loss and putatively functional transcription of relics_



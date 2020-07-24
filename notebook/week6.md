# 10/22

- confirm that, for one species (use sbi on the webpage), `unitary_gene_loss_info.tsv` is exactly `relic-lacking.info` + `relic-retaining.info`. except that `info.tsv` add two columns: `relic-lacking/retaining` & species abbreviation (`sbi` here)

```r
setwd('data-raw/demo/') 
       
setdiff(
    c(readr::read_lines('relic-lacking_unitary_gene_loss_of_sbi.info'),readr::read_lines('relic-retaining_unitary_gene_loss_of_sbi.info')) %>% sort,    
    readr::read_lines('unitary_gene_loss_info_for_sbi.tsv') %>% stringr::str_replace('\trelic[\\w\\W]+$', '') %>% sort
)
```



```bash
find -name '*loss_info*tsv' | xargs code
```

- compare my result with Zhao

issue: why some OG group has only a diff?

the content has been moved to `summary.R`

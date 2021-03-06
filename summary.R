col_name_tsv <-  c('group', 'counterpart', 'chr', 'start', 'end', 'strand', 'frameshift', 'stop', 'class', 'species')
col_name_xlsx <-  c('ID', 'chr', 'start', 'end', 'strand', 'frameshift', 'stop','group', 'counterpart', 'class')
species <- c('brachypodium', 'rice', 'sorghum', 'maize')
abbr <- c('bdi', 'osm', 'sbi', 'zm')
abbr2 <- c('osm_bdi', 'osm_bdi', 'sbi_zm', 'sbi_zm')

result <- list() 
for (i in 1:4) {
    setwd(here::here('unitary_gene_loss_detection/'))
    tsv <- dplyr::bind_rows(
        #" use n instead of i to be compatible with read_excel
        paste0(abbr[i], '/unitary_gene_loss_info_for_', abbr[i], '.tsv') %>% 
            readr::read_tsv(col_name_tsv, 'ncnnncnncc'),
        paste0(abbr2[i], '/unitary_gene_loss_info_for_', abbr2[i], '.tsv') %>% 
            readr::read_tsv(col_name_tsv, 'ncnnncnncc')
    ) %>% dplyr::filter(species == abbr[i]) %>% 
        dplyr::select(chr:stop, group:counterpart, class) %>%
        dplyr::mutate(source = 'tsv')

    xlsx <- here::here('data-raw/gene-loss-zhao.xlsx') %>%
        readxl::read_excel(species[i]) %>% {names(.) = col_name_xlsx; .} %>%
        dplyr::select(-ID) %>%
            #" refer to comment for col_names_tsv for `-counterpart`
        dplyr::mutate(
            frameshift = as.numeric(frameshift), 
            stop = as.numeric(stop), 
            source = 'xlsx'
        )

    
    foobar <- function(df) {
        if (nrow(df) == 0) stop('empty group number')
        if (nrow(df) > 2) stop('duplicated group number')
        if (nrow(df) == 1) {
            dplyr::mutate(df, source = paste(source, 'unique')) %>% return
        } else { #" then nrow(df) must be 2
            same <- T
            
            class = df$class %>% unique
            
            if (class %>% length == 2) 
                same = F
            else {  
#                if (class == 'relic-retaining') 
                    same = df %>% dplyr::select(chr:group) %>% 
                        {identical(.[1, , drop = T], .[2, , drop = T])}
                        #" counterpart for relic-retaining gene loss in tsv is `NA` so we omit this row
#                else
#                    same = df %>% dplyr::select(chr:counterpart) %>% {identical(.[1, , drop = T], .[2, , drop = T])} 
            }
            
            if (same) {
                df %>% dplyr::filter(source == 'xlsx') %>% dplyr::mutate(source = 'same') %>% return
            }else
                dplyr::mutate(df, source = paste(source, 'diff')) %>% return
        }
    }
    result[[ species[i] ]] = dplyr::bind_rows(tsv, xlsx) %>% 
        plyr::ddply('group', foobar) %>% dplyr::arrange(group, source)
    
    
    result
}


WriteXLS::WriteXLS(
    result, . %>% {dplyr::filter(., class == 'relic-retaining')}, 
    here::here('output/gene-loss-dong.xlsx'), species, na = 'NA'
)


tab <- function(result) {
    rbind(plyr::laply(result, . %>% {table(.$source)}),
          do.call(dplyr::bind_rows, result) %>% {table(.$source)}
    ) %>% {rownames(.) = c(species, 'total'); .}  
}


tab(result)
plyr::llply(result, . %>% {dplyr::filter(., class == 'relic-retaining')}) %>% tab
#!/bin/bash
#Function: pipeline for unitary gene loss detection
#Usage:    program name_of_genome_for_gene_loss_detection

read -a genomes -p "Please input names of genomes for gene loss detection, you can detect gene loss for one species or the MRCA (most recent common ancestor) of multiple species:"


genomes_list=$( for num in `seq 1 ${#genomes[*]}`; do echo ${genomes[$num-1]}; done | paste -d "_" -s )


# `extract_orthologous_group.sh`

if [ ! -f orthologous_groups.tsv ]; then
    cut -f1,5 orthologous_relationships.tsv | grep -v homology_id  | extract_connected_components_of_graph.c | calculate_orthologs_amount_of_each_species.pl > orthologous_groups.tsv
fi

awk -F "\t" '{print $1 "\t" $2 "\t" $3 "\t" $4 "\t" $5 "\t" $11 "\n" $6 "\t" $7 "\t" $8 "\t" $9 "\t" $10 "\t" $11}' EVS009_Supplemental_dataset_S1_pluslinks.tsv > modified_EVS009_Supplemental_dataset_S1_pluslinks.tsv

cd $genomes_list


# `echo ${genomes[*]} | detect_candidate_unitary_gene_loss_based_on_orthologous_group.sh`

extract_orthologous_group_with_candidate_unitary_gene_loss.pl ${genomes[*]}

if [ ${#genomes[*]} -gt 1 ]; then

for num in `seq 1 ${#genomes[*]}`; do 

cp orthologous_groups_with_candidate_unitary_gene_loss_in_${genomes_list}.tsv orthologous_groups_with_candidate_unitary_gene_loss_in_${genomes[$num-1]}.tsv; 

done

fi

#!/bin/bash
#Function: pipeline for unitary gene loss detection
#Usage:    program name_of_genome_for_gene_loss_detection

read -a genomes -p "Please input names of genomes for gene loss detection, you can detect gene loss for one species or the MRCA (most recent common ancestor) of multiple species:"


genomes_list=$( for num in `seq 1 ${#genomes[*]}`; do echo ${genomes[$num-1]}; done | paste -d "_" -s )
mkdir $genomes_list;  
#mv BLAST_database GMAP_database ppipe_output $genomes_list



echo "${genomes[*]}" | ${dir}/candidate-gene-loss.sh;


cd $genomes_list;



mkdir classify_candidate_gene_loss;

for num in `seq 1 ${#genomes[*]}`; do mkdir classify_candidate_gene_loss/${genomes[$num-1]}; done

for num in `seq 1 ${#genomes[*]}`; do cd classify_candidate_gene_loss/${genomes[$num-1]}; classify_candidate_unitary_gene_loss.sh ${genomes[$num-1]}; cd ../..; done




mkdir ensure_relic-retaining_gene_loss

for num in `seq 1 ${#genomes[*]}`; do mkdir ensure_relic-retaining_gene_loss/${genomes[$num-1]}; done

for num in `seq 1 ${#genomes[*]}`; do cd ensure_relic-retaining_gene_loss/${genomes[$num-1]}; ensure_relic-retaining_unitary_gene_loss.sh ${genomes[$num-1]}; cd ../..; done



mkdir locate_relic-lacking_gene_loss

for num in `seq 1 ${#genomes[*]}`; do mkdir locate_relic-lacking_gene_loss/${genomes[$num-1]}; done

for num in `seq 1 ${#genomes[*]}`; do cd locate_relic-lacking_gene_loss/${genomes[$num-1]}; locate_relic-lacking_unitary_gene_loss.sh ${genomes[$num-1]}; cd ../..; done




echo ${genomes[*]} | integrate_unitary_gene_loss_info.sh

cd ..

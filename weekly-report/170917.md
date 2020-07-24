# Part I: Project Review

The same as previous.






# Part II: Status Update



## What I have already finished?

1. 使用 `mysql` 从 Ensembl 获取7个物种的直同源基因关系：`orthologous_relationships.tsv`

   师兄中的 pipeline 中的数据源 `mysql.ebi.ac.uk` 已失效，后来在 Ensembl 官网偶然发现了`mysql-eg-publicsql.ebi.ac.uk` 这个网址，从中顺利取得了 `ensembl_compara_plants_15_68` 这一数据库。（感觉 Ensembl 的更新向后兼容做得不够好，官网有一个网页用的也是旧链接，我还给官方写信反映了这一 bug。）

2. 安装 genewise，PseudoPipe，GMAP 并阅读使用说明。

3. 运行和研究师兄的脚本到 `detect_candidate_unitary_gene_loss_based_on_orthologous_group.sh` 这一步



## What was my to-do list from last meeting (copy directly from last RIP report)?

Run Zhao et al. (2015) 's pipeline.



## What I have finished since last meeting that was expected and planned?

The same as the answer for the first question.



## What are unexpected obstacles?

1. 不知道 Ensembl 的直同源基因信息该如何分析，师兄用到了 `extract_connected_components_of_graph.c`这个二进制文件（无法学习其源代码，也不知道是哪来的，找不到文档）。

2. 对于 Bash 作为一门编程语言掌握得还不是很熟练，加上 Perl 看不懂，导致 pipeline 理解困难。



## What are unexpected discoveries?

师兄的脚本在 PseudoPipe 这一步好像有很大的提升空间，师兄应该是先对所有的蛋白质都寻找假基因，然后把得到的信息用来后续分析。但是可以在找到候选 gene
loss 事件后，再对这一子集中的蛋白质进行假基因寻找。根据文档，目前 PseudoPipe 只能单机运行，对于线虫的基因组要花一整天，用在植物上的时间肯定会更多，这一步也许会节约不少时间。



## What are questions/problems that I need help with or need a targeted discussion?

有一个能从南开访问的高性能计算机。

如果上一个问题的猜想成立，最耗资源的应该是 `gmap_setup`，文档中的 4 GB RAM 倒是能满足，但是 SSAHA index 的大小也许会超出磁盘容量，而且其对 CPU 的要求现在还不清楚。



## Do we need to revise the scientific question, hypothesis, experiment plan ?

Yes. 但是还没有成熟的想法。



## What is my plan for the next two weeks?

继续运行 Zhao et al. (2015) 的 pipeline，运行 GMAP、PseudoPipe 的 demo，评估计算资源需求。


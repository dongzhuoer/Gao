# Part I: Project Review

The same as previous.






# Part II: Status Update



## What I have already finished?

总的来说，pipeline 完成 `detect_candidate_unitary_gene_loss_based_on_orthologous_group.sh` 这一步，为 `classify_candidate_unitary_gene_loss.sh` 做了很多准备工作。

1. 理解了脚本的运行方式并作出了一点改进，得到了四个物种的 candidate gene loss

   使用 ``$( for num in `seq 1 ${#genomes[*]}`; do echo ${genomes[$num-1]}; done | paste -d "_" -s )``，可以避免原来脚本中总是要 写入、读取再删除 `genomes_list.tsv` 这个文件。

   Table: 表1 没有任何 filter 时各物种gene loss 的数量
   
   ----------- -------------- ------ ------- --------- --------------------- -----------------
   species     brachypodium   rice   maize   sorghum   brachypodium & rice   maize & sorghum
   gene loss   132            102    245     88        27                    35
   ----------- -------------- ------ ------- --------- --------------------- -----------------

   表中数据的总和是 **629，与论文中 742 不符**（即使把发生在两个物种的最近共同祖先的 gene loss 算两次，也只有 691）。一个问题是找不到 `forbidden_gene_list.tsv`  或者不知道怎样构建该文件，网页上只有文件的一小部分（将其加上之后降到 628，brachypodium 少了一个）。
   
   网页中给出了 sorghum 的完整输出，共 83 个，少了 11051、11984、16329、71、8085 这五个 `orthologous_group`。就这个物种来说还很合理，如果能得到原文的 `forbidden_gene_list` 应该是可以重复的，只是不知道为什么整体上反而会多出 113 个。

2. 使用PseudoPipe 提供的 `fetchEnsemblFilesPlants.py` 下载前者需要的输入数据，并转换格式。

   官方只提供 Python 脚本，没有任何文档，我分析了一下源代码，推测其用法 `fetchEnsemblFilesPlants.py 'Sorghum bicolor' 15`，结果还蒙对了。另外从代码中还抠出 <ftp://ftp.ensemblgenomes.org/pub/release-15/plants> 这个网址，基本上解决了之前提到过的版本问题（论文中是 release 15 ，现在都已经到 37 了，上周还在为去哪找 15 的数据而发愁呢）。
   
   PseudoPipe 的输入中比较麻烦的是 `mysql/chr*_exLocs**`，官方要求类似于这样（第3、4列分别给出 exon 的起始坐标，每条染色体一个文件）
   
   ```
   269171 3 4119 4358 -1 0 0 1 0
   269173 3 4221 4358 -1 0 0 1 0
   269170 3 5195 5296 -1 0 0 1 1
   269169 3 6037 6327 -1 0 0 1 1
   ```
   
   但从 Ensembl 中获取的只有一个大文件，形如
   
   ```
   976098 6609 28648 28768 1 0 1 1 0 Sb0010s002010.1_exon_1 1 0000-00-00 00:00:00 0000-00-00 00:00:00
   976099 6609 28981 29065 1 1 2 1 0 Sb0010s002010.1_exon_2 1 0000-00-00 00:00:00 0000-00-00 00:00:00
   976100 6609 29374 30260 1 2 1 1 0 Sb0010s002010.1_exon_3 1 0000-00-00 00:00:00 0000-00-00 00:00:00
   976101 6609 31311 31330 1 1 0 1 0 Sb0010s002010.1_exon_4 1 0000-00-00 00:00:00 0000-00-00 00:00:00
   ```
   
   Ensembl 官网对该文件的格式有一个 [解释](https://www.ensembl.org/info/docs/api/core/core_schema.html#exon)，但是只说明了第3、4列分别给出 exon 的起始坐标，没指明每个 exon 位于哪一条染色体上。初步猜想第 1 0列最后一个数字对应着染色体，于是提取了一下，除去少部分 像 `sbi-MIR159b` 这样不规则的，结果如下
   
   ------- ------
   数量    编号
   35418   1
   26465   2
   19186   3
   14629   4
   11691   5
   9427    6
   7700    7
   6183    8
   5028    9
   4042    10
   3228    11
   2582    12
   2051    13
   1665    14
   1303    15
   1079    16
   871     17
   719     18
   584     19
   463     20
   379     21
   311     22
   243     23
   193     24
   159     25
   129     26
   116     27
   102     28
   84      29
   69      30
   63      31
   52      32
   42      33
   37      34
   31      35
   29      36
   24      37
   22      38
   18      39
   16      40
   14      41
   11      42
   10      45
   10      44
   10      43
   9       48
   9       47
   9       46
   8       49
   5       50
   4       53
   4       52
   4       51
   2       57
   2       56
   2       55
   2       54
   1       58
   ------- ------
   
   1,2,3 还挺明显的，但是 9 到 16 这部分没有明显的间断，也许猜想有误，还需要继续探究。

3. 修正运行PseudoPipe 的思路

   之前的想法有点问题，对于 gene loss 而言，目标物种是没有蛋白质序列的，也就是无法为 PseudoPipe 准备输入，这样的话就只能用近缘物种中的 counterpart。其实这个想法与论文中描述的方式是一致的（不知道原文" Run PseudoPipe with the orthologous counterpart ..." 中的 with 是不是应该这样理解），但是 pipeline 却好像不是这样子的， 其只是在用一些 shell 脚本处理 PseudoPipe 的输出文件。
   
   也就是说在运行 PseudoPipe 时，还没有 candidate gene loss 的信息。那么之前的想法不仅是节约时间的问题，更重要的是想法（软件的用法）的问题。还得好好探究，**PseudoPipe 能不能按我想的这样使用其他物种的蛋白质序列，还是一定要用该物种的所有蛋白质序列**。

4. 学习 shell 语法，积累一些分析文件的工具

   现在 pipeline 中的 shell 语言基本能看懂了（还能做到像 1 中提到的那种改进），不过 Perl 还是只能靠猜。
   
   能够比较方便的分析结果，尤其是两个文件以行为单位的集合操作，比如像 1 中那样对于师兄和我生成的两个 candidate unitary gene loss 文件，找出哪些是共有的，哪些是某个文件独有的。
   
   另外还发现 Ensembl 给出的 protein 居然还有重复的，比如 _Sorghum bicolor_ 的 Sb08g019235.1 和 Sb01g027164.1 这两个转录本的序列都是：
   
   ```
   VQINNGKHTCPSTSRVPGNTMASQAWVAERAIPLLKKKPSMGVRELQEALQDKYSIDINYQTVLYASKGLDHLKVTKGYQEEAEVTEIYKDEEVRRHVVYPTQHICTCREWQVTGKPCPHALALITTQRQPNMGMYVHNYYSVEKFQAAYNGIIPSITDRTQWPQVDKGFKLLRPNQMKKREPGKPRKKRILAASERSGKATRQVRCPECLEYGHRKGSWKCSKSGTKKRKRTKKTAPKPGRKKSKVDPTPTGGDTPRTRLALAREAAIQAAREAEEAAAKAAAAAEAAAAAEIQVIPPLQIEQPQPSSPAAR
   ```


## What was my to-do list from last meeting (copy directly from last RIP report)?

继续运行 Zhao et al. (2015) 的 pipeline，运行 GMAP、PseudoPipe demo，评估计算资源需求。



## What I have finished since last meeting that was expected and planned?

The same as the answer for the first question.



## What are unexpected obstacles?

如何获取 `forbidden_gene_list` 和构建 `chr*_exLocs` 文件。



## What are unexpected discoveries?

能这么方便地获取 Release 15 的数据。

我上周提出的 PseudoPipe 运行方式不仅节约了时间，而且在思想上也有很大更新。



## What are questions/problems that I need help with or need a targeted discussion? 

有一个能从南开访问的高性能计算机。

如果要重现结果的话，还是得用该物种的所有蛋白质序列来运行 PseudoPipe，这样对时间和性能的要求还是比较大的。

而且 GMAP 这关是绕不过去的。



## Do we need to revise the scientific question, hypothesis, experiment plan ?

Yes. 但是还没有成熟的想法。



## What is my plan for the next two weeks?

1. 查阅资料，构建 `forbidden_gene_list`

2. 解决 `chr*_exLocs` 的问题，按我的方式来运行 PseudoPipe

3. 评估GMAP的计算资源需求

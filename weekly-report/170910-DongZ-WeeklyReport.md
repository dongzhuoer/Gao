# Part I: Project Review



##   What is the general scientific question?

How to develop a better method for identifying gene loss ^[如无特殊说明，下文中的 gene loss 均指 unitary loss of protein-coding gene.] events
based on Zhao et al. (2015) ^[为简便起见，以下所有涉及到 Zhao et al., 2015 的均省去引用，或简称为论文。] 's pipeline?



##  What is my specific scientific question?

1. How to identify gene loss events using RNA-seq data?
2. How will the new pipeline perform and how to access it?
3. What is the significance of the new pipeline?
4. How to combined the two methods to provide more information about the gene loss events?



##  What is my hypothesis?

1. We can assembly many RNA-seq data to build a RNAatlas and then identify gene loss events.
2. We assume that the result will cover most of the 129 gene loss events (depending on how the RNAatlas cover all transcripts) and identify novel gene loss events (may overlap with the fitered candidate events). We can further assess the new pipeline by performing GO slim annotation and expression signature analysis, and compare the results with those of the paper.
3. Our method may provide an alternate way to identify gene loss for those lineages who don't have or only have a few genome data now, thus shows universal usability.
4. Besides the name of the lost gene, we can add the probability of the event if we are not sure. For example, when we assume a gene whose transcript can't be found in a RNAatlas with 90% coverage is functionally lost.



##  What is my experiment design plan to test the hypothesis?

1. 从 SRA 数据库中收集二穗短柄草、水稻、高粱和玉米这四个物种的 RNA-seq 数据，以基因组为参考进行组装，之后将结果合并到一起，并用 CPC 区分出 mRNA 和 lncRNA。在合并的过程中，类似降帅师姐 Fig. 7a 的形式，拟合出稀释曲线 ^[在数据增加的过程中，尽量保证不同组织类型均匀分布。但这里有两个问题：不同组织类型是应该按等比例还是按所有现有数据的比例？计数是只算sample数还是同时考虑碱基总量？]，以此评估得到的 RNAatlas 的 coverage。按照初步分析，高粱的数据是最少的，其它的物种以高粱 coverage 为基准，达到相应的值之后就不用再合并新的 RNA-seq 组装结果了 ^[这只是对于第 2 步的要求，对于第 4 步，数据充足的物种还是尽量让 coverage 更大一些，使给出的 p-value 更有意义。]。

2. 在论文中得到的 45589 直同源基因集的基础上，使用 HaMStR 软件从 RNAatlas 中预测出直同源基因[^predict-ortholog]对应的 mRNA。与论文中定义一致，对于其它物种都有 mRNA，而某一物种（支系）没有对应 mRNA 的情况，我们将其定义为基因丢失事件。将我们的结果与论文中得到的 712 个候选和 129 个最终结果进行比较 ^[包括覆盖了论文中的哪些结果，没有覆盖哪些结果，多出来哪些结果等。]。用这些结果重复论文后半部分的分析流程，包括 GO 富集、表达特征分析等 ^[根据情况，这一步也许会略去。]。

[^predict-ortholog]: 为什么要预测直同源基因对应的 mRNA 而不是直接使用现有的直同源基因集？

    - 此方法是面向转录组数据的分析，HaMStR 只需要有一个直同源基因集，并不需要包含水稻等4个物种，只有3个外群的直同源基因集也可以完成任务

    - 此处使用7个物种的直同源基因集是为了得出尽可能好的结果，后文在探究方法的拓展性时，也许会只是用3个外群（或3个外群加水稻）的直同源基因集

    - Ensembl 的具体情况我还没看，但从OrthoDB的经验来看，这些直同源基因注释应该是在植物这一支系上注释出来的，只有3个外群还是7个物种并不会影响orthologous
    group。

3. 以典型物种为代表，分析物种的基因组数据和 RNA-seq 数据分布情况 ^[这里并不要分析很多物种，只要找到一个案例，能说明方法的可推广性即可。根据经验，以昆虫为例，很多物种没有基因组数据，只有数条转录组数据。]。对于 1 中收集到的数据，通过随机抽样模拟相似条件 ^[以昆虫纲或其中的某个目为例：如果很多物种普通只有两三条 RNA-seq 数据，那水稻等 4 个物种中每个物种也只用 3 条RNA-seq数据；如果有 1 个典型物种有基因组序列，那就用 3 个外群加水稻的直同源基因集；如果都没有基因组数据，那就只用外群的直同源基因集（可能需要调整外群以保持和目标支系可用外群相似的系统发育距离）。]，重复以上步骤，分析结果的覆盖度。以此来评估该方法能不能推广到目前没有（或仅有少量）基因组数据的支系中 ^[这里还涉及到一个查新的工作，即查阅前人是否已经推出了类似的流程。]。

4. 将 2 中得到的结果与论文中得到的结果整合到一起，将基因丢失事件分为可靠和不可靠两类，对于不可靠的基因丢失事件，给出一个 p-value ^[主要是 RNAatlas 的 coverage，其它情况会在下文中具体描述，可能会将不同信息整合在一起] ^["可靠"并不是 p-value 为1，理解为 p-value not applicable更合适。]。

    a. 用 RNAatlas 鉴定出的，在 742 个候选之外的基因丢失事件，可以用 HaMStR 对相应 DNA 序列再做一遍直同源基因预测，Ⅰ 阴性则认为 Ensembl 的直同源基因注释有问题，将其并入候选集中 ^[严格来说，这里涉及到 Ensembl 与 HaMStR 冲突的问题，但是与下文中 genewise 的情况不同，这里就不分析可信度的问题了。]；Ⅱ 阳性则认为该基因在 coverage 对应的 p-value（也许可以整合启动子序列分析 ^[启动子的情况比较复杂，可以找一个启动子预测工具，然后分析其可靠性。（利用收集的基因组序列和 RNAatlas 分析假阳性和假阴性，假阴性比较好分析一点，但是都会受到 RNAatlas coverage 的限制。）总的来说采取一票否决制度，对于转录出 RNA 的情况，不论启动子分析结果如何；对于没有找到 RNA 的情况，即使启动子分析为阴性，也只能在某一置信水平上认为该基因不表达。根据情况这部分工作可能不会去做，而是留到展望中。]的结果）上已丢失。

    b. 对于 248 个"genic hits"中所有与 Pseudo gene 存在重叠的基因注释，和176个"intergenic hits"中 ORF 完好的情况。同时用 HaMStR 对这些基因再做一遍直同源基因预测，阴性则意味着该基因已丢失，阳性则分析在 RNAatlas 中是否有对应的 mRNA，没有的话结论同a）中Ⅱ。

    c. 对于176个"intergenic hits"中 genewise 给出的 ORF 被破坏的情况，结合 RNAatlas 分析是否真的无法转录出 mRNA。如果检测到了 mRNA，且确实为直同源基因，那么这个基因就没有丢失 ^[如果 mRNA 同时也存在，就是一个非常有意思的情况。]。如果这种假阳性的情况较多的话，就要仔细分析为什么 genewise 会认为 ORF 坏了，甚至可能需要评估 genewise 分析的可靠性 ^[因为这里是 genewise 和一个可靠结果（严格来说也有测序错误的可能）之间的冲突，所以可以考虑可信度，与上文及下文 HaMStR 等冲突的情况不同。]（61 个中的其它情况就不能再视作可靠结果，而是要加上一个 p-value 值）。

    d. 对于 176 个"No hits"的情况，如果在 RNAatlas 中有 mRNA 且 HaMStR 鉴定为直同源基因，那么这个基因就没有丢失 ^[严格来说，这里涉及到 Ensembl 与 HaMStR 冲突和PseduoPipe与 HaMStR 冲突的问题，但是与上文中 genewise 的情况不同，这里就不分析可信度的问题了。]。其它情况较为复杂，这里仅分析一种可能性 ^[实际上可能不会去做这种情况，就不列在正文中了。某一基因被分成了两段，而这两段中至少有一段能被识别出来，且这两段都无法转录出 mRNA（比如找到了前一段对应的 lncRNA，而后一段能匹配到基因组上某个位置且不转录）。]。
    



##  What is the new technology that I need to develop?

1. 在超级计算机上执行任务

   - 已经熟练掌握 Linux 基本操作和 R、C++ 语言，能够使用 SSH 远程操作系统，能够在纯命令行模式下（tty1）熟练操作 Linux 系统，但是在实际运行程序时还是偏向使用图形化界面，而且用的是本地电脑。

   - 具体来说需要掌握的有两点：1）远程执行需要运行较长时间程序（先开始运行，然后断掉连接，到时间后去查看结果）2）如何在超算上运行程序，或者说如何把超算用的和 Bash一样熟练。

2. 从头组装 RNA-seq 数据并整合

   - 熟练掌握如何从NCBI的SRA库中查询和获取 RNA-seq 数据，以及该数据的格式，如何使用等。

   - 了解稀释曲线的概念，熟练掌握曲线拟合的软件。

   - 需要学习如何以基因组为参考组装转录组，如何从头组装转录组，如何将不同的转录组合并到一起，如何计算转录本的表达量。

   - 需要查阅文献确定稀释曲线的表达式。

3. 论文后半部分的分析流程

   需要学习 GO 富集、表达特征分析等。

4. 概率论的基本概念

   学习如何给出一个合理的 p-value 计算公式



## What is the timeline and milestones?

|           |                                              |
|-----------|----------------------------------------------|
| Week1~4   | 撰写开题报告，收集数据，完成全部 RNA-seq 组装，尽量完成高粱的 RNAatlas |
| Week5~8   | 完成其它物种的 RNAatlas，使用 HaMStR 进行直同源基因预测         |
| Week9~12  | 将结果与论文比较，重复论文后半部分的分析流程，完成实验第3步               |
| Week13~16 | 完成实验第4步                                      |
| Week17    | 整理结果，撰写结题报告                                  |






# Part II: Status Update



##  What I have already finished?

1. 查阅 Zhao et al. (2015) 的参考文献和其它参考资料。

2. 修改 research proposal 并与高老师讨论。

Table: 附表1：SRA数据库中转录组数据量

----------------------------- ---------- ----------------
Organism                      Sample数   碱基总和/Gbase
Brachypodium distachyon       150        679.735
Oryza sativa Japonica Group   545        2112.556
Sorghum bicolor               168        438.073
Zea mays                      5327       17966.875
----------------------------- ---------- ----------------

注：搜索时使用 `transcriptome [Title]`，具体数据类型包括很多种，但是 RNA-seq 的数据至少能占到92%（按碱基总和来算）。

Table: 附表2：SRA数据库中转录组数据量（舍弃了碱基数 <1 Gbase的结果）

----------------------------- ---------- ----------------
Organism                      Sample数   碱基总和/Gbase
Brachypodium distachyon       117        662.583
Oryza sativa Japonica Group   331        2008.279
Sorghum bicolor               74         386.687
Zea mays                      4420       17435.237
----------------------------- ---------- ----------------



## What was my to-do list from last meeting (copy directly from last RIP report)?

1. 与老师讨论开题报告。

2. 分析不同支系的数据可用性，确定物种范围（9月11号起在南开上课）。



## What I have finished since last meeting that was expected and planned?


1. 与老师讨论开题报告。



## What are unexpected obstacles?

转录组数据的不完整性很难解决。



##  What are unexpected discoveries?

目前还没有人提出一个较好的鉴定 gene loss 的 pipeline。



## What are questions/problems that I need help with or need a targeted discussion?

有一个能从南开访问的高性能计算机。



## Do we need to revise the scientific question, hypothesis, experiment plan ?

Yes. 但我还得先跑一遍 Zhao et al. (2015) 的 pipeline，实践探索一番。



##  What is my plan for the next two weeks?

Run Zhao et al. (2015) 's pipeline.






# Appendix: Albalat & Cañestro, 2016 的问题

- Note: "gene loss" means gene loss in species or allele loss in individual.

- Why negative genetic interactions in redundant genes but positive interactions in alternative pathways？

- Note: "Genomic positional bias": initial random to non-random.

- Genomic positional bias 最后一段，X 染色体有剂量补偿，dosage­ sensitive 解释不通。

- Why "correlation between the rates of gene loss and the rates of molecular evolution" means "fixation is driven by neutral evolution"?

- How to estimate "propensity for gene loss"?

- What is "forward genomics"? How to associate genomic regions containing gene loss with a given lost phenotype?











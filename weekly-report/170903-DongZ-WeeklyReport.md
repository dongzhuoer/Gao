# Part I: Project Review



## What is the general scientific question?

How the reciprocal conversion between protein-coding gene and lncRNA
gene promote the evolution of genome?

更宽泛一点的话，可以说是**(全部)基因与基因组之间是如何互相影响**的。这里面有很多问题都没有搞清楚，比如基因组大小的限制，在鸟类中和唯一的飞行哺乳类------蝙蝠中都看到了基因组变小的现象，可以推断确实存在针对基因组大小的选择压，但是一个很 tricky 的地方在于 protein coding 基因只占基因组的 1%（加上内含子也不到5%），即使所有的 protein coding 基因都复制一遍，也不会有显著的选择压的改变（至少对于 DNA 代谢而言），那么基因数量的限制到底来源于哪里？也许 gene 与垃圾序列之间有某种未知方式的联系，增加基因的数量也不可避免地要增加垃圾序列。但不管怎么说，对于(全部)基因与基因组之间关系还有很多问题需要研究。

这里主要关心 protein coding 基因和 lncRNA 基因的互相转变。比如说在适应辐射的过程中，我们都能看到物种适应多种多样的环境和大量种化事件这些结果，但是背后的原因（在基因组水平上）是什么？凭空产生新基因是很慢的，但是有没有可能在已有的 protein coding 基因库和 lncRNA 基因库之间发生了大量的相互转化，范围甚至波及整个基因组，这样就可以只用较少的突变就能造成表型上巨大的变化。

为了研究这一点，首先我们要积累足够多的素材，这涉及到两个问题。1）对于一个物种而言，如何分析出其基因组中全部的 protein coding 基因和 lncRNA 基因2）在1）的基础上分析许多物种，结合系统发育关系，重构出 protein coding 基因和 lncRNA 基因之间互相转变的历史。然后就可以分析这些事件对于整个基因组的影响，对于表型的影响，在物种形成中的作用等。

这里面有很多事情可以去做，比如如何改进现有的基因注释方式，如何注释出 lncRNA 基因，重构历史时除了 gain 和 loss 的假设外能不能把序列变化的过程也考虑进去。



## What is my specific scientific question?

How to improve the pipeline in Zhao et al. (2015) to compile a reliable
and comprehensive gene loss catalogue?

虽然是以 Zhao et al. (2015)的 pipeline 为基础，但最主要的思想还是回答上文中的第二个问题。这里的核心思想是通过候选的 gene loss 与转录组序列之间的整合来重构历史。这其中并没有十分复杂的技术（比如从基因组注释 lncRNA），原理其实非常地简单，关键是一个新的想法。单从 DNA 序列来分析的话，很难把 gene loss 这件事说清楚（这也是一个很重要的方面，但是不是 16 周应该去完成的任务），但是转录组就很不一样了。lncRNA 不一定都会出现在转录组中（转录活性低，或者sample不包含其转录的条件），但是反过来，如果出现在了转录组中（设定 FPKM 阈值），就有很大的把握可以说这个基因已经丢失或者正在丢失（详见下文）。



## What is my hypothesis?

We can improve the pipeline in following ways:

1. Collect sequence from a broaden species spectrum and perform de novo ortholog annotation.

   这一步意义之一在于当我们有了更多的基因丢失数据和更长的演化时间，就能更好地探究一些问题；意义之二在于摆脱对于 Ensembl 的依赖，更快更好地利用新发表的测序结果（Ensembl 的直同源注释虽然质量高，但是注释的物种少，很难覆盖新发表的基因组数据）。

2. 对于 "Intergenic hits" 的后续筛选进行修正，加入对于可变剪接、启动子损坏等情况的考虑。

3. 对于 PseudoPipe 的三种结果的后续筛选进行修正，主要通过与转录组序列之间的整合来实现。

   比如对 "于Intergenic hits"的某一个遗迹（含有intact ORF），在 RNA-seq 中找到了序列匹配的 lncRNA，这就可能有两种情况，一是 ORF 的分析有问题，这个基因已经不再编码蛋白了；二是可变剪接导致这个基因既能转录出 protein coding RNA，又能转录出 lncRNA（这就非常有意思了，有可能后续的突变会让这一基因完全变成 lncRNA 基因，而在第1点的基础上我们甚至有可能看到整个转化的过程，进一步扩展的话也可能有 lncRNA 基因通过这种中间态转化成蛋白质编码基因）。对于"No hits"的情况，也许能在转录组中找到 orthologous counterpart 的前 250 bp 对应的 lncRNA，这就可能是染色体结构变异导致该基因的前半部分和启动子一起移到了某一转录终止序列的前面，所以这也能算基因以 lncRNA 的方式死亡的例子。对于其它"Genic hits", 也有可能发现找到的基因其实只能转录出 lncRNA。
   
总的来说，最重要的是第 3 点。对于第 1 点，一是有很多现有的直同源注释数据库可以用，比如鸟类有 90 多个物种有基因组序列，OrthoDB 就已经对其中 54 个物种进行了直同源基因注释；一是只是使用了别人写好的程序，对于 pipeline 而言可以算一点改进，但是在直同源基因注释这件事本身并没有多少创新。其主要意义实际上是为第3点做准备，在论文中的 176 个 relic 中或许找不到假设中提到的情况，或者案例很少，这时候就可以增加物种数目，扩大范围来搜索。对于第 2 点，主要是考虑思想的完整性才加上去的，因为这件事本身很难说清楚，也很难在方法上有大的创新，总之可以试一下。



## What is my experiment design plan to test the hypothesis?

1. 收集更多物种的数据，要求是每一个物种都要有全基因组序列以及较多的 RNA-seq 数据。可以考虑将范围扩大到单子叶植物（课题组拥有较好的背景支持）或鸟类（与其他脊椎动物不一样，鸟类经历了大量的基因组精简，很可能是受到飞行生活的选择压的影响）。然后从头进行直同源基因注释（使用 OrthoDB 的程序或者 HaMStR）

2. 从头组装每一物种的所有 RNA-seq 数据并整合在一起。

3. 前两步可能要花较多的时间，可以在等待的过程中，对于论文中已有的数据进行假设中2）和3）的操作。

4. 根据前面的情况，也许将 3 中找到的新的 gene loss 加入到Zhao et al. (2015)的后续分析中，看看对结果的影响。也许对于 1 和 2 准备好的更大的数据集，执行 Zhao et al. (2015)的 pipeline，然后按照3的操作改进 pipeline。

以下为后续展望：

- 对于"No hits"的其它情况，也许我们可以尝试重构染色体结构变异的历史，如果有较大的把握证明某一重构是正确的，那么也可以认为这一基因已经死亡。

- 对于"Genic hits"的情况，可以考虑分析基因的启动子或者类似上文与转录组相结合，证明该基因不再编码蛋白。也可以进行系统发育分析，证明即使 PseudoPipe 给出了 hit，这个结果也不可能是原始基因经过分子进化而来的。



## What is the new technology that I need to develop?

1. 在超级计算机上执行任务

   - 已经熟练掌握 Linux 基本操作和 R、C++ 语言，能够使用 SSH 远程操作系统，能够在纯命令行模式下（tty1）熟练操作 Linux 系统，但是在实际运行程序时还是偏向使用图形化界面，而且用的是本地电脑。

   - 具体来说需要掌握的有两点：1）远程执行需要运行较长时间程序（先开始运行，然后断掉连接，到时间后去查看结果）2）如何在超算上运行程序，或者说如何把超算用的和 Bash 一样顺手

2. 从头进行直同源基因注释

   - 熟练掌握如何从 NCBI 上查询和获取基因组数据
   - 熟练掌握如何从 OrthoDB 数据库中提取直同源基因的关系（相当于 pipeline 第一步的信息）
   - 熟练掌握 HaMStR 的使用
   - 如果使用 OrthoDB 的程序来注释的话，就需要去学习如何使用这个程序

3. 如何分析可变剪接、启动子损坏等

   需要熟悉 genewise 的原理，学习如何分析可变剪接，如何分析启动子功能等。

4. 从头组装 RNA-seq 数据并整合

   - 熟练掌握如何从 NCBI 的SRA库中查询和获取 RNA-seq 数据，以及该数据的格式，如何使用等。
   - 掌握如何使用 blast 中的 `makeblastdb` 命令，但是没有自己运行过 blast（我只需要准备好 blastdb 数据库，blast 是在 HaMStR 的内部被调用）
   - 需要学习如何从头组装转录组，如何计算转录本的表达量，如何使用 blast 等序列匹配软件

5. 使用Zhao et al. (2015)的 pipeline 分析新的数据

   第一步的筛选应该用R语言就能实现，以前在使用 HaMStR 时也做过类似的分析（那时是要筛选所有物种中都存在的直同源基因）。
   
   主要需要学习 PseduoPipe 的使用和后续结果处理。



## What is the timeline and milestones?

|           |                                           |
|-----------|-------------------------------------------|
| Week1~2   | 分析不同支系的数据可用性，确定物种范围，撰写开题报告                |
| Week3~5   | 收集数据，进行直同源基因注释和转录组组装                      |
| Week6~7   | 分析可变剪接、启动子损坏等情况                           |
| Week8~11  | 将候选丢失基因与转录组序列进行比对，并对阳性结果进行进一步分析           |
| Week12~15 | 将新的 gene loss 整合到后续分析中，或对新的数据集执行改进的 pipeline |
| Week16~17 | 整理结果，撰写结题报告                               |






# Part II: Status Update



## What I have already finished?

1. Finished throughout reading two paper : _Evolution by gene loss_ and _Identification and analysis of ... functional transcription of relics_.

2. 与老师讨论 _Genome graphs and the evolution of genome inference_ 和 _Identification and analysis of ... functional transcription of relics_ 中遇到的问题。

3. 提出课题，完成 research proposal 的初稿。



## What was my to-do list from last meeting (copy directly from last RIP report)? 

与老师讨论，1)确定方向、收集资料; 或2)阅读演化方向的论文



## What I have finished since last meeting that was expected and planned?

1. Finished throughout reading _Evolution by gene loss_.

2. 与老师讨论 _Genome graphs and the evolution of genome inference_ 中遇到的问题。

3. 确定研究方向。



## What are unexpected obstacles?

It is so hard to raise a project.



## What are unexpected discoveries? 

Nothing.



## What are questions/problems that I need help with or need a targeted discussion? 

深入讨论 research proposal，主要是科学问题是否有意义，还有可行性的问题。



## Do we need to revise the scientific question, hypothesis, experiment plan ? 

No. I just finished set up the scientific question, hypothesis, experiment plan 10 minutes ago.



## What is my plan for the next two weeks?

1. 与老师讨论开题报告

2. 分析不同支系的数据可用性，确定物种范围（9 月 11 号起在南开上课）


<!---
cd $Gao/office/; pandoc -i 171022-DongZ-WeeklyReport.md -o 171022-DongZ-WeeklyReport.docx --reference-docx=DongZ-WeeklyReport.docx
-->

# Part I: Project Review


## What is the general scientific question?

How to improve Zhao et al. (2015) 's pipeline and analyse gene loss in birds?

## What is my specific scientific question?

1. How to further filter the result of PseudoPipe?

1. How to detect unitary gene loss in birds? (How to choose _long-established_ protein-coding genes? How to choose appropriate divergent time? How will the pipeline perform to a large number of species?)

1. How does gene loss correlate with genome size/gain/loss?
    

## What is my hypothesis?

1. We can further filter the result of PseudoPipe by perfrom ortholog prediction again using [HaMStR](https://bmcevolbiol.biomedcentral.com/articles/10.1186/1471-2148-9-157).
  
1. We can use Palaeognathae （古颚总目) as outgroup to investige unitary gene loss in Galloanseres (鸡雁小纲) and neoaves (新鸟小纲), which diverged about **90** Myrs ago. Or use Palaeognathae and Galloanseres as outgroup to investige lineages within neoaves (新鸟小纲), which diverged time about **67** Myrs ago ( close to the WGD event in Poaceae accroding to [Schnable et al, 2016](https://academic.oup.com/gbe/article-lookup/doi/10.1093/gbe/evs009)).

1. genome loss may not influence unitary gene loss since they are long-established protein-coding genes ([Kapusta et al., 2017](http://www.pnas.org/content/114/8/E1460.full))

## What is my experiment design plan to test the hypothesis?

1. 收集鸟类的基因组数据和系统发育关系。

![Suh et al., 2016, figure 1](image/Suh2016-Fig1.png)

根据 [Suh et al. (2016)](https://onlinelibrary.wiley.com/doi/10.1111/nyas.13295/full) 整理的鸟类系统发育结果，neoaves 被分为 9 个支系，这些支系内部的系统发育关系已经比较稳定，但是它们之间的系统发育关系却存在着很大的争论。所以这里我们将其作为并系群。通过选取 Palaeognathae (while-thorated tinamou and common ostrich) 为外群， 我们能鉴定出 long-established protein-coding gene 的丢失。

![Jarvis et al., 2014, figure 1](image/Jarvis2014-Fig1.jpg)

根据 [Jarvis et al. (2014)](http://science.sciencemag.org/content/346/6215/1320.full) 构建的时间树，我们可以把支系限定为 Neognathae （今颚总目, Galloanseres + neoaves) 或 neoaves。这个分歧时间应该是比较合适的，既不太长，也不太短。


2. 运行师兄的 pipeline，并对 PseudoPipe 的结果进行额外的筛选，对于 "genic hits" 和 "intergenic hits" 中ORF完好的情况。用 HaMStR 对这些基因再做一遍直同源基因预测，若为阴性则意味着该假基因已经不属于这一直同源基因群，也就是说该基因在此物种中已丢失。

3. Kapusta et al. (2017) 提到： "Our data provide evidence for an “accordion” model of genome size evolution in birds and mammals, whereby the amount of DNA gained by transposable element expansion, which greatly varies across lineages, was counteracted by DNA loss through large segmental deletions."

![Kapusta et al., 2017, figure 3](image/Kapusta2017-Fig3.png)

我们可以利用其方法，分析本项研究的类群的 genome gain/loss, 然后分析 gene loss number 与 genome size/gain/loss 之间的关系。

## What is the new technology that I need to develop?

1. 在超级计算机上执行任务

    已经熟练掌握 Linux 基本操作和 R、C++语言。

    需要学习如何在超算上运行程序。

2. 处理 PseudoPipe 的输出

    目前解决程序的问题，可以顺利运行。但只是把其输出直接传给 pipeline， 还需要掌握如何自己分析输出结果。

3. 学习 Kapusta et al. (2017) 的分析方法。


## What is the timeline and milestones?

Week01~04 收集数据，运行完 pipeline，学习如何自己分析 PseudoPipe 的输出。

Week05~08 使用 HaMStR 处理 "genic hits" 和 "intergenic hits" 中ORF完好的情况，得出 gene loss

Week09~12 利用 Kapusta et al. (2017) 的方法，分析本项研究的类群的 genome gain/loss。

Week13~16 分析 gene loss number 与 genome size/gain/loss 之间的关系，撰写毕业论文。


# Part II: Status Update

## What I have already finished?



1. 分析比较 pipeline 结果与师兄结果的差异。

    pipeline 给出的结果中，relic-retaining 的 gene loss 没有输出 orthologous counterpart，而 relic-lacking 的 gene loss 却能正常输出，原因未知。

    pipeline 给出的结果有 bdi、osm、sbi、zm、bdi\_osm、sbi\_zm 这六个 tsv 文件，但是论文的补充材料中的 Excel 中只有针对 4 个物种的汇总数据。
    
    tsv 文件的最后一列是物种简称，比如 bdi\_osm 的最后一列就是 'osm' 或 'bdi'，也许可以根据这一项来拆分 bdi\_osm、sbi\_zm 这两个 tsv 文件。于是我用网页上的 sbi\_zm 的 tsv 文件试了一下，单看 orthologous group 倒是没什么问题，但是其他信息就有不一致的了，*比如 sorghum 中 orthologous group 编号为 5416 的 gene loss， 在网站的示例输出中，start 为 6133765， 而补充材料的 Excel 中却为 6133764*，有趣的是这个 gene loss 的其他信息都一样，而且 start 虽然不同，但只差 1。其他几个 gene loss 也有同样的情况。

    我按照上述方式将我得到的六个 tsv 文件整理成 4 个表格，然后与论文中的补充材料比较。统计结果如下：（tsv 指我得到的结果，xlsx 指论文中的补充材料的结果，same 表示完全一样，unique 表示一方有而另一方没有，diff 表示两方都有但某些信息不一样，这里我用 orthologous group number 作为 id。）

             same   tsv diff    tsv unique  xlsx diff   xlsx unique
brachypodium   16         20            17         20            11
rice            8          9            12          9            10
sorghum         3         10             9         10            10
maize           8          7            27          7            17
total          35         46            65         46            48

    后来我检查了一下，发现很多不一致都出在 orthologous counterpart 上。实际上我在比较的时候只有 relic-lacking 的 gene loss 我才会去比较 orthologous counterpart （因为 relic-retaining 的 gene loss 在 pipeline 的结果中 orthologous counterpart 都是 NA），这样对二者的处理就有偏差了。

    于是我有分析了一次，这一次 orthologous counterpart 的不同忽略不计，结果如下

             same   tsv diff    tsv unique  xlsx diff   xlsx unique
brachypodium   31          5            17          5            11
rice           14          3            12          3            10
sorghum         7          6             9          6            10
maize          11          4            27          4            17
total          63         18            65         18            48

    接着我单独对 relic-retaining 类型的 gene loss 比较了一下，结果如下（relic-lacking 减一下就行了，我就没单独分析）：

             same   tsv diff    tsv unique  xlsx diff   xlsx unique
brachypodium    9          4            10          3             3
rice            6          3             8          2             3
sorghum         1          5             8          6             8
maize           5          4            24          2            13
total          21         16            50         13            27

    可以看出，很大一部分的差距都出在 relic-retaining 上。

    总的来说，PseudoPipe 的影响比 `EVS009_Supplemental_dataset_S1_pluslinks.tsv` 要更大一点，就像之前提到过的，也许师兄运行 PseudoPipe 与我不一样。

## What was my to-do list from last meeting (copy directly from last RIP report)? 

查阅文献，进一步完善 research proposal。

## What I have finished since last meeting that was expected and planned?

与第一个问题一样

## What are unexpected obstacles?

师兄的网站上的结果居然有和论文中不一样的。

## What are unexpected discoveries? 

无

## What are questions/problems that I need help with or need a targeted discussion? 

无

## Do we need to revise the scientific question, hypothesis, experiment plan ? 

Yes. I have finished a draft.

## What is my plan for the next two weeks?

查阅文献，进一步完善 research proposal。



# Part I: Project Review

The same as previous.






# Part II: Status Update



## What I have already finished?

基本完成 pipeline 的运行。

1. 解决之前说到的 `chr*_exLocs` 的问题

   在 Ensembl plants 15 的 ftp 中，每个物种都会有一个 `.gtf`，其各列意义在 http://www.gencodegenes.org/gencodeformat.html 中有说明。
   
   对 `.gtf` 和 `mysql/exon.txt` 比较后发现，其中大部分是一样的，但是也有冲突的部分。
   
   刚开始是发现不同文件排序不一样，比如同一个基因的两个 exon：100-250 和 300-400。`mysql/exon.txt` 将其编号为 1、2，而 `.gtf` 则将其编号为 2、1。
   
   于是我就手动将 `.gtf` 中 exon 的编号逆序，再来比较，然而还是有区别。经过仔细检查，发现 `.gtf` 中的顺序不是固定的，有些基因的 exon 按坐标从大到小编号，另一些则从小到大编号。
   
   接下来我将 transcript name，start coordinate，end coordinate 三者 paste 成一个字符串，用于比较两个文件。结果绝大部分都是匹配的，但是还是有少数不一样。我挑选了一些例子来仔细检查，发现区别是由 RNA 的可变剪接造成的。比如有一个基因，前几条转录本都是一样的，但是有一条转录本，`mysql/exon.txt` 认为其由 exon2 exon3 exon5 组成，但 `.gtf` 认为其由 exon2 exon3 exon6 组成。
   
   不过这些用来组合的 exon 本身（用起始坐标来定义）都是一样的。最后我只将 start coordinate，end coordinate 两者 paste 成一个字符串，然后两个文件的信息就完全一样了。
   
   PseudoPipe 的官方说明中只要求给出 exon 的坐标，所以我就从 `.gtf` 中提取出 exon 起始坐标信息，按 chromosome 拆分成 `chr*_exLocs` 文件，作为其输入。（这里的隐含假定是不同的染色体上的 exon 的坐标不会完全一样，因为 `mysql/exon.txt` 文件本身是没有染色体的信息的，所以严格来说无法认定其与 `.gtf` 中的完全一样。不能排除有可能 `mysql/exon.txt` 认为在两条染色体上恰好存在两个坐标一样的 exon，但 `.gtf` 只认为其中一条染色体上存在这样的 exon。）

2. 成功运行 PseudoPipe

   关于之前提到的 PseudoPipe 不能运行的问题，我手动生成了 `chrI_P_sorted_exLocs` 和 `chrI_M_sorted_exLocs` 来测试。
   
   鼓捣了一会之后这一关算是 pass 了，然后又出现了 `can't open '...ppipe_output/.../blast/processed/*_M_*sorted_M_blastHits.sorted'`。看到这个我曾一度想放弃了，前面那个我还能手动生成，现在这个我是真不知道他到底想要什么样的文件了。
   
   后来我又试着一步一步调试 PseudoPipe 的 Python 源代码，发现其中的 `blast` 命令无法运行，错误信息如下：
   
   ```
   Error: Cannot convert string '3.1e9' to Int8 (m_Pos = 1)
   
   Error: Argument "dbsize". Argument cannot be converted: `3.1e9'
   
   Error: (CArgException::eConvert) Argument "dbsize". Argument
   cannot be converted: `3.1e9
   ```
   
   应该是代码中的 `blastall -p tblastn -m 8 -z 3.1e9` 出了问题。
   
   这里又涉及到另一个问题，自从 NCBI 推出 blast+ 之后，就找不到原来的文档了。legacy 中的 `blastall` 程序只实现一个参数转换的工作，但根本就不告诉你是怎么转化的。比如这里的 `-z`，根据错误信息可以推出对应到新版 `tblastn` 的 `-dbsize`，但是 `-m` 就不知道是什么意思了。即使是新版的文档，也没有详细解释 `-dbsize` 该怎么指定，光从错误信息 `Int8`，我也不知道 3,100,100,100 有没有超过其范围。
   
   后来我改成 `3100100100` 试了一下，发现能正常工作。很神奇的是，前面提到的两个 `*_M_*sorted` 的问题都不见了。（其实根本就不需要 `chrI_P_sorted_exLocs` 文件）。不过我也有经验了，之后只要 PseudoPipe 冒出 `*_M_*sorted`的问题，想都不用想，赶紧去查一下 `blast` 有没有出错就行了。
   
   之后还有一个 `source` 找不到文件的问题，把源代码中的 `source setenvPipelineVars` 改成 `source ./setenvPipelineVars` 就好了。
   
   还有就是程序的输入文件位置可以改变（这一点在分析两个物种的共同祖先时比较方便），但是 (1) `dna/species-name.dna.chromosome.%s.fa` 必须用完整名称，不能用 bash wildcard，比如 `dna/*.dna.*.%s.fa` (2) `pep.fa` 文件必须位于专门的 `pep/` 目录下。
   
   至此 PseudoPipe 算是可以顺利运行了。
   
   Table: PseudoPipe 运行时间 
   
   --------------------- ------------- -------------- ------------                               
   osm                   26m30.089s    osm_bdi/osm    13m16.814s
   sbi                   47m34.506s    osm_bdi/bdi    10m35.144s
   zm                    225m21.997s   sbi_zm/sbi     21m16.105s
   bdi                   22m34.467s    sbi_zm/zm      62m15.153s
   --------------------- ------------- -------------- ------------



3. GMAP

   这个之前还蛮顺利的，主要是后来在玉米中遇到问题了，这次全基因组扩增恰好超出了我可伶的电脑的 8G 内存的范围。后来我加上了 10G 的 swap。但是速度慢得有点离谱（可能即使是固态硬盘也远不如 DDR 内存吧），从中午跑到下午都没结束，于是我就让它跑一整晚，结果今天早上起来还没完。不过把昨天下午卡住的那一步跑完了，应该只差最后一点了。然而我用的是一个 IDE 里面的模拟终端，起来之后我开始用那个 IDE 查看文件（关于 forbidden gene list 的事），结果在打开一个大的 `.fa` 文件时 IDE 卡住了，最后崩溃了，连带着终端中的 GMAP 也终止了。最终造成现在还没有最终结果（今天晚上一定要加上 `nohup`，太可惜了）。

4. pipeline

   将 PseudoPipe 的输出与 pipeline 整合后发现一些问题。
   
   首先是基因名不匹配，更深层次的是之前提到的 PseudoPipe 运行方式的问题，也就是用什么作为 query 。论文中描述的和我想的是一致的，"ran PseudoPipe using the entire genome sequence of the species as the object and protein sequence of an orthologous counterpart of the lost gene from the adjacent species (e.g., brachypodium for rice) as the query."。但是网站上的描述却完全不符合，网站把 PseudoPipe 输出作为整个 pipeline 的前提，这个时候根本就不知道 lost gene 的 orthologous counterpart 是哪一个，而且网站上没有明说 PseudoPipe 的 query 到底是什么。
   
   这里我把 pipeline 的前面一部分拆分出来，先得出 `orthologous_groups_with_candidate_unitary_gene_loss_in_***.tsv` 文件，然后从中提取出，lost gene 的 orthologous counterpart 的基因名，然后从 adjacent species 的 `pep/pep.all.fa` 中匹配出相应的蛋白质（这里不能用 abinitio 的，因为基因名不匹配），然后以此作为 query 来运行 PseudoPipe 。
   
   但是用上面的输出来运行 pipeline 时出问题了。因为我把每一个基因的所有蛋白质都用来作 query ，所以 `pep.fa` 文件中序列名用的是蛋白质的名字。但是pipeline 后续流程用的是基因名来分析（比如基因名为 `LOC_Os01g01010`，蛋白质则有 `LOC_Os01g01010.1`，`LOC_Os01g01010.2` 等），于是就没有结果了。
   
   如果要跟基因名匹配上的话，那每个基因就只能保留一个蛋白质（至少 PseudoPipe 的输入文件 `pep.fa` 中的序列不能重名），这里我选择的是保留最长的蛋白质。但论文中没有明说这一点，不知道我的处理是否与论文一致，不过网站的 blast database 提到了 "create a BLAST protein database containing all longest proteins in ..."）。
   
   后面就是一些小问题了，比如 `unitary_gene_loss_detection_pipeline.sh` 中第 8 行 `don` 应该为 `done` 等。

5. synteny relationships

   之前提到过， Schnable et al. 只提供了 `EVS009_Supplemental_dataset_S1_pluslinks.xls`，然后我自己用 Excel 另存为的 `EVS009_Supplemental_dataset_S1_pluslinks.tsv` 与网站给出的前 10 行示例不一样。
   
   首先，为了重现性，我用 R 语言来将 `.xls` 转成 `.tsv`。然后与网站的示例逐一比较，发现主要问题在于 Schnable et al. 与 Ensembl 的基因名不一致。所有的 `Os***` 都应该被替换成 `LOC_Os***`, 还有 `Bradi1g`, `Bradi2g`, ... 要被替换成 `BRADI1G`, `BRADI2G`, ... 。最后是缺失值（这个可能是使用 R 语言而引入的），网站上缺失值用空表示（`1\t2\t3` 缺失2的话就是 `1\t\t3`），但是 R 语言转换的结果默认是 `NA`，加一个 `na= ''` 的参数就好了。
   
   最后用 `md5sum` 检测，（至少前 10 行）与网站上的示例完全一样了。
   
   （严格来说这里还需要确认一下，网站只有前 10 行的输出，也许后面还有别的需要替换的。）

6. forbidden gene list

   之前的信息比较少，现在综合 `.gtf` 文件和 `pep.fa` 的序列名信息之后，就能构造出 `forbidden_gene_list.tsv` 文件了。
   
   `.gtf` 可用信息在前两列。第一列有染色体信息，其中 线粒体基因组用 `mitochondrion` 或 `Mt` 表示，叶绿体基因组用 `chloroplast` 或 `Pt` 表示。第二列有基因类型信息，其中有用的是 `transposable_element` 和 `transposable_element_gene` 这两类。`pep.fa` 的序列名中也含有染色体信息。
   
   但是将这些信息整合之后，并不包含网站中给出的示例。比如水稻的 `LOC_Os03g63330` 位于第 3 条染色体上，不过 `.gtf`中没有 `transposable_element` 的注释。也许师兄从别的地方发现这个基因与转座子有关？或者是 `LOC_Os03g63330` 与另一个转座子有关基因在同一个直同源基因组中？



## What was my to-do list from last meeting (copy directly from last RIP report)?


1. 查阅资料，构建 `forbidden_gene_list`

2. 设法让 PseudoPipe 顺利运行

3. 跑完 pipeline，有些难以重复的部分就用网上给出的结果，继续运行后面的步骤

4. 构思新的 proposal



## What I have finished since last meeting that was expected and planned?

基本与第一个问题的答案一样。



## What are unexpected obstacles?

软件总是会出各种各样的问题。

GMAP 会需要 8 G以上的内存。



## What are unexpected discoveries?

无



## What are questions/problems that I need help with or need a targeted discussion?

还是高性能服务器的事。



## Do we need to revise the scientific question, hypothesis, experiment plan ?

Yes.



## What is my plan for the next two weeks?

1. 运行完玉米的 GMAP database

2. 解决剩余的一些小问题

3. 运行完 pipeline，蜀黎的结果与网站上的作比较，整合所有物种的结果后与论文中比较

4. 查阅论文，构思新的 proposal


# Part I: Project Review

The same as previous.






# Part II: Status Update



## What I have already finished?

1. 发现 PseudoPipe 的一个bug

   在分析 PseudoPipe 的计算需求时觉得有点不对劲，在不断增加输入的 protein 序列数量的情况下，运行时间都是一样的，而且输出信息中总在报错。后来发现运行软件自带的例子也是一直在报错，研究好久后发现程序本身有问题。

   中间某一步正负链分别需要 `chr*_P_*sorted_exLocs`，`chr*_M_*sorted_exLocs` 这两个文件，但是输入只写了 `chr*_exLocs` 的需求，而且程序自己也不会去生成这两个文件。

2. 运行 GMAP

   以高粱为例，生成了 `GMAP_database/` 。640M 的基因组花了 20m，生成了 6.2G 的文件。看来时间和内存倒不是问题，硬盘（SSD）倒是有点吃不消。

   另外，与只需要结果的 PseudoPipe 不同，pipeline 用到了GMAP 中的 `get-genome` 这一个程序。



## What was my to-do list from last meeting (copy directly from last RIP report)?

1. 查阅资料，构建 `forbidden_gene_list`

2. 解决 `chr*_exLocs` 的问题，按我的方式来运行 PseudoPipe

3. 评估GMAP的计算资源需求



## What I have finished since last meeting that was expected and planned?

基本与第一个问题的答案一样，只是我预期是找出我的输入的问题并设法解决，没想到会揪出程序本身的问题。



## What are unexpected obstacles?

没想到都已经发过论文的软件下载来还会出这样的问题。

还有，师兄那个 pipeline 的网页无法访问了。



## What are unexpected discoveries?

无



## What are questions/problems that I need help with or need a targeted discussion?

感觉师兄的软件的可重复性做得还是不够。

不光是 pipeline 的网页，[CBI 官网](http://www.cbi.pku.edu.cn) 都无法访问了，不知道是不是那边服务器的问题。



## Do we need to revise the scientific question, hypothesis, experiment plan ?

Yes. 下周应该会重写一遍。



## What is my plan for the next two weeks?

1. 查阅资料，构建 `forbidden_gene_list`

2. 设法让 PseudoPipe 顺利运行

3. 跑完 pipeline，有些难以重复的部分就用网上给出的结果，继续运行后面的步骤

4. 构思新的 proposal

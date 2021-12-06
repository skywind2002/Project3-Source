# README

2021年秋季学期《编码引论》 第三次大作业 信源编码与联调

- [README](#readme)
  - [平台使用指南](#平台使用指南)
  - [一、量化](#一量化)
  - [二、熵编码](#二熵编码)
    - [使用平台提供的单符号码表和双符号码表](#使用平台提供的单符号码表和双符号码表)
    - [自行完成Huffman编码](#自行完成huffman编码)
    - [像素统计](#像素统计)
    - [单符号逃逸码设计思路](#单符号逃逸码设计思路)
      - [讨论](#讨论)
    - [单符号码本生成](#单符号码本生成)
    - [单符号测试结果](#单符号测试结果)
    - [双符号思路](#双符号思路)

## 平台使用指南

文件夹中的`codec.m`文件是主程序，运行这个文件就可以得到全部结果。

运行`codec.m`文件的时候会让你选择一个图像，文件夹中的`lena_128_bw.bmp`就是测试图像；所有量化，熵编码的修改都可以在这个文件平台上完成，写函数挂进去就行了

## 一、量化

## 二、熵编码

### 使用平台提供的单符号码表和双符号码表

* 使用图片：`lena_128_bw.bmp`
* 量化参数选择：`blockOption = 2;` `i_quant = 1; % 1: H.261 quantization` `quant_factor = 50;`
* 编码参数选择：
```matlab
vlcRadio = 0; % 0:one symbol 1:two connected symbols
onesymbol_coodbook_file = "table.txt.example";
twosymbol_coodbook_file = "table2.txt.example";
```

单符号编码：
```
blockOption:2	slice_height:8
H.261 quantization	quant_factor=50
one symbol coding
input image bit:131072
Processed image bit:20389
Quantization success!
One symbol encode:	 slice_height:8
One symbol encode:	Encode success!	 Total bits:133350
```

双符号编码：
```
blockOption:2	slice_height:8
H.261 quantization	quant_factor=50
two symbol coding
input image bit:131072
Processed image bit:20389
Quantization success!
Two symbol encode: 	Slice_height:8
Two symbol encode:	Encode success!	 Total bits:137116
```

两种方式的解码结果都是全部正确。这是因为编解码的对应是唯一的，且未经过传输，编码的输出与解码的输入完全一致。也就是说，图像的重建效果与量化后的图像是完全一样的。

### 自行完成Huffman编码

见`h_Huffman.m`中的`function [huffmanSymbols, huffmanCodes] = h_Huffman(symbols, probabilities)`

使用面向过程的编程思想，在汇集两概率最小的符号时就赋予编码。对应的测试文件为`test_h_Huffman.m`。

### 像素统计

见`h_ProbStatistic.m`

```matlab
%% 分析一张灰度图中灰度值的概率分布
% 输入
% 一张灰度图片（二维矩阵 Uint8）
% 输出
% 符号Array
% 概率Array
function [symbols, probs] = h_ProbStatistic(srcImage)
```

### 单符号逃逸码设计思路

编码的符号总共有1-255共255个，分为两部分：一部分用直接指定码本，剩下的用逃逸码加8bit灰度值（逃逸码: 逃离对编码串一成不变的解析，转入一种新的解析方式）

如果码本设计的很长（包含的符号很多），那么逃逸码可以长一些；但是如果码本比较短，那么大多数符号都要使用逃逸码，这时逃逸码可以短一些，比如直接设置为0

如果是用Huffman编码的话，逃逸码不能是其他任何编码的前缀；事实上Huffman编码也不能是逃逸码的前缀。所以，我们可以将Huffman编码输入的符号概率矩阵中的一部分符号（逃逸符号）纳入一组，得到这些逃逸符号总概率，并编码为逃逸码加原本的灰度值。

注意这里考虑的是编码效率，并没有将编码算法复杂度纳入考虑。

#### 讨论

* 原始符号集合 $S$（在此次编码中为1-255共255个）
* 码本符号集合 $B$
* 逃逸符号集合 $E = S - B$
* 逃逸符号 $escape$（代表整个逃逸符号集合的那个符号）
* 编码符号合集 $C = B \cup \{escape\}$
* 如果采用上面的方法：
最终总的平均码长
= (码本符号集合与逃逸符号组合起来的符号集合 经过Huffman编码之后的平均码长) + P(逃逸符号集合) * 8
*用熵来近似Huffman编码的平均码长*
= $\sum_{c_i \in C} -p_{c_i}\log{p_{c_i}} + (8 + len(escape)) * \sum_{e_i \in E} p_{e_i}$
- - -
* 但是上面的方法有个问题，将逃逸符号集合合并后，一起做Huffman编码这时Huffman编码已经不是最优的了。再往源上想一步，其实添加逃逸码这一机制就已经不是编码效率最优了，因为把255个符号联合起来做Huffman肯定是最优的编码；逃逸码应该也是一个在编码复杂度与编码效率之间的一个折中。
* 如果逃逸符号集合总概率很高，escape短；如果总概率低，escape长，这一点也是符合直觉的。
* 概率高的符号肯定直接使用码本而不会使用逃逸码编码，所以逃逸符号集合大部分由概率较小的符号组成

我们不妨就采用上述方法进行编码，通过求上式的极值，找到分配C与S的方法；如果得不到理论解，可以在程序中进行多种尝试选出最优的（比如一种简单的划分是按照概率对所有的符号进行排序，分别按照概率和 50% ... 20% 10%来进行划分），在此次作业中，我们采用第二种划分方法。

### 单符号码本生成

```matlab
% 按照需求生成灰度图像的码本（带逃逸码）
% [input]
% srcImage 灰度图像 unit8
% escape_prob_threshold 总和低于这个的符号会被搞成逃逸码
% [output]
% generate table.txt in the current folder

function h_GenerateOneSymbolCodebook(srcImage, escape_prob_threshold)
```

测试文件为`test_GenerateOneSymbolCondebook.m`，其中`escape_prob_threshold`指定了需要被逃逸编码的符号的总概率。

### 单符号测试结果

在`codec.m`中`if vlcRadio == 0 % one symbol encoding`位置添加码本生成代码。

运行结果：

| escape_prob_threshold | huffman_symbols_count | encode_bits |
| - | - | - |
| 0.00 | 240 | 124852 |
| 0.01 | 201 | 124608 |
| 0.1 | 149 | 126508 |
| 0.2 | 119 | 127869 |
| 0.3 | 95 | 128503 |
| 0.4 | 73 | 129100 |
| 0.5 | 55 | 128545 |
| 0.6 | 38 | 128888 |
| 0.7 | 24 | 130071 |
| 0.8 | 13 | 132514 |
| 0.9 | 5 | 135899 |
| 0.999999 | 2 | 143114 |

可以看到当门限逐渐提高时，编码得到的比特数逐渐增大。其中第一行表示都使用Huffman编码，最后一行表示都是用逃逸码。同时可以看到，码本逐渐减小，这意味着解码（查表）所需消耗的算力增多，在运行程序时也有比较明显的感觉。实际选择`0.6～0.8`能达到算力与效率的大致平衡。

### 双符号思路

TODO
仍然采用上述思路，但联合时要注意应该是相近的。。。
等下双符号是怎么解码的？？？

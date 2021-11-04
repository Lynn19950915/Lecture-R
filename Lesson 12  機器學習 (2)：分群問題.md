<h2 align="center">Lesson 12: 機器學習 (2)：分群問題</h2>

### 12-1 距離運算
1. 向量點的距離
- A=c(10, 15, 20)
- B=c(10, 10, 10)

```
# 歐氏距離：即 minkowski distance(p=2)
> dist(rbind(A, B), method="euclidean")
# 曼哈頓距離：即 minkowski distance(p=1)
> dist(rbind(A, B), method="manhattan")

註：minkowski 之極限即為切比雪夫距離 (chebyshev)：max(0, 5, 10)=10
```

2. 常見聚合方式

| | 原理 |
| :---: | :---: |
| 單一連結聚合 | 群間距離=雙群中最近兩點之距 |
| 完整連結聚合 | 群間距離=雙群中`最遠兩點之距` |
| 平均連結聚合 | 群間距離=雙群中`各點距離之平均` |
| Wards method | 合併兩群後，各點至群心之距離總和 |

---
### 12-2 階層式分群 (以 bottom-up 為例)
1. 預處理：單位標準化 (ID 欄位除外)
```
> customer=read.csv("customer.csv", header=T)
> head(customer, 3)
   ID Visit.Time Average.Expense Sex Age
1   1          3             5.7   0  10
2   2          5            14.5   0  27
3   3         16            33.5   0  32

> customer=scale(customer[, -1])
> head(customer, 3)
     Visit.Time Average.Expense       Sex        Age
[1,] -1.2021905      -1.3523765 -1.456685 -1.2313440
[2,] -0.7569348      -0.3046072 -1.456685  0.5995173
[3,]  1.6919719       1.9576221 -1.456685  1.1380059
```

2. 距離演算選擇

| 點間距離 | 群間距離 | 語法 |
| :---: | :---: | :--- |
| 歐氏 | 沃德 | M1=hclust(dist(customer, method="euclidean"), method="ward.D2") |
| 曼哈頓 | 平均 | M2=hclust(dist(customer, method="manhattan"), method="average") |

```
# 依序輸出所有樣本分屬之群別
> cutree(M1, k=5)
> table(cutree(M1, k=5)) 
 1  2  3  4  5 
11  8 16 15 10 
> customer[cutree(M1, k=5)==1,]
      Visit.Time Average.Expense       Sex         Age
[1,] -1.20219054     -1.35237652 -1.456685 -1.23134396
[2,] -0.75693479     -0.30460718 -1.456685  0.59951732
[3,] -0.75693479     -0.13791661 -1.456685  0.92261049
 ...

# 畫出分群枝圖
> plot(M1)
# 繪框：需承接 plot() 指令繪製
> rect.hclust(M1, k=5)
```

---
### 12-3　K-Means 分群
- 需事先決定群數 K
```
> K=kmeans(customer, 4)
```

| 步驟 | Output |
| :--- | :--- |
| 1. 隨機選取 K 筆資料作為初始核心<br>2. 固定核心點，重新劃分其餘資料點之群屬<br>3. 固定剩餘資料，重新計算核心點<br>(循環上述步驟直至群心不再改變) | # K$size<br>K-means clustering with 4 clusters of sizes 8, 16, 25, 11<br><br># `K$center`: 最終之四群核心點<br>Cluster means:<br>  Visit.Time Average.Expense        Sex        Age<br>1  1.3302016       1.0155226 -1.4566845  0.5591307<br>2  0.8571173       0.9887331  0.6750489  1.0505015<br>3 -0.6322632      -0.7299063  0.6750489 -0.6411604<br>4 -0.7771737      -0.5178412 -1.4566845 -0.4774599<br><br># `K$cluster`: 各點最終之分群<br>Clustering vector:<br> [1] 4 4 1 4 1 4 1 1 4 4 4 1 1 4 4 4 1 4 1 2 3 2 3 2 2 3 3 2 3 3 3 2 2 2 3 3<br>[37] 2 3 3 3 3 3 3 3 2 2 3 3 3 2 3 2 2 3 3 3 2 3 3 2<br><br># K$withinss<br>Within cluster sum of squares by cluster:<br>[1]  5.90040 22.58236 20.89159 11.97454<br> (between_SS / total_SS =  74.0 %)<br><br>Available components:<br>[1] "cluster"      "centers"      "totss"        "withinss"    <br>[5] "tot.withinss" "betweenss"    "size"         "iter"        <br>[9] "ifault"      |

- 結果繪圖
```
> library(cluster)
# 2 components explain 85% of variability
> clusplot(customer, K$cluster)
# 2 variables (散佈圖預設：呈現兩大主成分)
> plot(customer, col=K$cluster)
# 轉置：組別成為次分類，本身已是聯合機率表
> barplot(t(K$centers), besides=T)　
```

---
### 12-4 分群評估
1. silhouette(x)
- 群間距離 (single-linkage)-群內距離：<br>
silhouette(x)=b(x)-a(x)/max([b(x), a(x)])
```
> K=kmeans(customer, 4)
# 分別代表分群及樣本點
> KS=silhouette(K$cluster, dist(customer))
 Cluster sizes and average silhouette widths:
        8        16        25        11 
0.5464597 0.3794910 0.5164434 0.4080823 
 Individual silhouette widths:
   Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
 0.1931  0.4030  0.4890  0.4641  0.5422  0.6333
> plot(KS)
```

2. $tot.withinss

| 原理 | Output |
| :--- | :--- |
| WSS (within sum of squares):<br>`斜率改變`處 | > G=2:10<br># 2~10 逐元素代入 $tot.withinss<br>> WSS=sapply(G, function(K){`kmeans(customer, centers=K)$tot.withinss`})<br>> plot(G, WSS, type="l") |
| SW (average silhouette width): `最大值`處 | > library(fpc)<br>> SW=sapply(G, function(K){`cluster.stats(dist(customer), kmeans(customer, centers=k)$cluster)$avg.silwidth`})<br>> plot(G, SW, type="l") |

---
### 12-5 密度式分群：DBSCAN
1. 由 `cores (核心點), EPS (半徑), minPts (數量)` 組成：

| | 定義 |
| :---: | :--- |
| 核心點 | 符合在 EPS (一段距離) 內，包含 minPts (數量) 者 |
| 邊界點 borders | 核心點`可觸及但不滿足 minPts` 者 |
| 局外點 noises | 不在任何點 EPS 距離內可達者 |

2. 可分辨資料 outlier 及偏態分布，唯組數為未定。

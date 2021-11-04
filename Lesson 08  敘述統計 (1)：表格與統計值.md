<h2 align="center">Lesson 08: 敘述統計 (1)：表格與統計值</h2>

### 8-1 表格讀取
| | 語法 |
| :---: | :--- |
| 設定工作路徑 | setwd(--工作路徑--) |
| 載入資料 | load(cdc.RData) |

1. 總體觀察
- 資料型態 class(cdc)
- 資料子集 head/tail(cdc)
- 彙整統計 summary(cdc)
```
> str(cdc)　
'data.frame':	20000 obs. of  9 variables:
 $ genhlth : Factor w/ 5 levels "excellent","very good",..: 3 3 3 3 2 2 2 2 3 3 ...
 $ exerany : num  0 0 1 1 0 1 1 0 0 1 ...
 $ hlthplan: num  1 1 1 1 1 1 1 1 1 1 ...
 $ smoke100: num  0 1 1 0 0 0 0 0 1 0 ...
 $ height  : num  70 64 60 66 61 64 71 67 65 70 ...
 $ weight  : int  175 125 105 132 150 114 194 170 150 180 ...
 $ wtdesire: int  175 115 105 124 130 114 185 160 130 170 ...
 $ age     : int  77 33 49 42 55 55 31 45 27 44 ...
 $ gender  : Factor w/ 2 levels "m","f": 1 2 2 2 2 2 1 1 2 1 ...

# 轉換為 factor 階層
> cdc$smoke100=as.factor(cdc$smoke100)
```

2. 資料結構與摘要
- 比較：類別資料 vs 連續資料

| | 類別變數 genhlth | 連續變數 age |
| :---: | :--- | :--- |
| table | 次數分配表 | 次數分配表 (個別窮舉列出)：宜先進行`離散化`處理 |
| summary | `分配狀況`<br> excellent very good      good      fair      poor<br>      4657      6972      5675      2019       677 | `分布狀況`<br>   Min. 1st Qu.  Median    Mean 3rd Qu.    Max.<br>  48.00   64.00   67.00   67.18   70.00   93.00 |

- 階層性類別變數
```
> summary(table(cdc$smoke))
Number of cases in table: 20000 
Number of factors: 1
```
- 離散化連續變數
```
# 預設含上界、不含下界 (right=T)
> table(cut(cdc$age, seq(16, 100, by=12)))
(16,28]  (28,40]  (40,52]  (52,64]  (64,76]  (76,88]  (88,100]
   3863     5207     4644     2954     2356      920        56 
```

---
### 8-2 資料統計值
1. 一維敘述統計

| 統計值 | 語法 | 備註 |
| :---: | :--- | :--- |
| 平均數 | mean(cdc$weight) | |
| 中位數 | median(cdc$weight) | # 尋找中位數 index<br>`which(cdc$weight=median(cdc$weight))` |
| 眾數 | # 無 mode 函數 | # 找次數分配表 table(cdc$weight) 的最大值及表頭<br>max(table(cdc$weight))<br>`names(which.max(table(cdc$weight)))` |
| 變異數 | var(cdc$age) | 標準差：`sd(cdc$age)`=sqrt(var(cdc$age)) |
| 全距 | range(cdc$age) | |
| 四分位數 | `IQR(cdc$age)` | # 四分位距=Q3-Q1 |

<pre>
summary 同時呈現：最大／大小值、平均數、四分位數
</pre>

2. 二維相關分析

| 統計值 | 定義 | 語法 |
| :---: | :--- | :--- |
| 共變異數 | 兩變數`線性關係之強度&方向` | cov(cdc$height, cdc$weight) |
| 相關係數 | 經`標準化`的共變異數 ([-1, 1]) | cor(cdc$weight, cdc$wtdesire) |

- 三變數以上並列，則會形成共變異數 (相關係數) 矩陣
```
> cov(cdc[, c("height", "weight", "age")])
> cor(cdc[, c("age", "weight", "wtdesire")])
```

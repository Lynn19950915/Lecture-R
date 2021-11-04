<h2 align="center">Lesson 05: 表格 (data frame) 與清單 (list)</h2>

### 5-1 Data Frame 之產生
1. 資料型態不須相同，稱之為`雜湊型資料`。
```
> product=c("egg", "milk", "beef")
> price=c(40, 110, 100)
> customer1=c(TRUE, FALSE, TRUE)
> customer2=c(TRUE, TRUE, FALSE)
> data=data.frame(product, price, customer1, customer2)
```

2. 資料概覽

| 語法 | Output |
| :---: | :---: |
| class(iris) | data frame |
| str(iris) | 'data.frame':	150 obs. of  5 variables:<br> $ Sepal.Length: num  5.1 ...<br> $ Species     : Factor w/ 3 levels "setosa" ... |
| data(iris) | 完整所有資料 |
| head(iris)<br>tail(iris, 10) | 最前六筆資料 (預設)<br>最末十筆資料 |

3. summary 呈現摘要統計
- 類別變數：`次數分配表`
- 數值變數：最大／小值、平均數與四分位數

```
> summary(iris)
  Sepal.Length    Sepal.Width     Petal.Length    Petal.Width          Species  
 Min.   :4.300   Min.   :2.000   Min.   :1.000   Min.   :0.100   setosa    :50  
 1st Qu.:5.100   1st Qu.:2.800   1st Qu.:1.600   1st Qu.:0.300   versicolor:50  
 Median :5.800   Median :3.000   Median :4.350   Median :1.300   virginica :50  
 Mean   :5.843   Mean   :3.057   Mean   :3.758   Mean   :1.199                  
 3rd Qu.:6.400   3rd Qu.:3.300   3rd Qu.:5.100   3rd Qu.:1.800                  
 Max.   :7.900   Max.   :4.400   Max.   :6.900   Max.   :2.500
```

---
### 5-2 條件與篩選
1. 先選 row 再選欄位
```
# 等同 iris[1:3, 3]
> iris[1:3, "Petal.Length"]
```

2. data frame 取單一欄位：降為一維向量
```
> iris$"Petal.Length"[1:3]
```

---
<h3 align="center">隨堂練習</h3>
<h4 align="center">請從鳶尾花資料集 (iris) 完成下列資料查詢：</h4>

1. 請選出花萼 (sepal) 長度 >5 之樣本。
```
# 呈現 TRUE 之資料位置 (index)
> which(iris$Sepal.Length>5)
> iris[iris$Sepal.Length>5,]
# 先取單一欄位 (降維) 判斷，再做為條件篩選資料
> iris[iris[, "Sepal.Length"]>5,]
```

2. 請選出品種 (species) virginica 之樣本。
```
> which(iris$Species=="virginica")
> iris[iris$Species=="virginica",]
> iris[iris[,"Species"]=="virginica",]
```

---
### 5-3 合併與排序

| | 描述 |
| :--- | :--- |
| merge(x=file1, y=file2, by="ID") | `inner`: 僅 ID 相同者會列出 |
| merge(x=file1, y=file2, by="ID", all.x=True) | 以 file1 為主 (不論其 ID 是否配對) 全數列出 |
| merge(x=file1, y=file2, by="ID", all=True) | |

1. sort: 針對欄位，(由大而小) 排序值
```
> sort(iris$Sepal.Length, decreasing=T)
  [1] 7.9 7.7 7.7 7.7 7.7 7.6 7.4 7.3 7.2 7.2 7.2 7.1 7.0 6.9 6.9 6.9 6.9 6.8 6.8 6.8 6.7 6.7 6.7 6.7 6.7 6.7 6.7 6.7 6.6 6.6 6.5 6.5 6.5 6.5 6.5 ...
 [46] 6.3 6.3 6.3 6.3 6.3 6.3 6.2 6.2 6.2 6.2 6.1 6.1 6.1 6.1 6.1 6.1 6.0 6.0 6.0 6.0 6.0 6.0 5.9 5.9 5.9 5.8 5.8 5.8 5.8 5.8 5.8 5.8 5.7 5.7 5.7 ...
 [91] 5.6 5.5 5.5 5.5 5.5 5.5 5.5 5.5 5.4 5.4 5.4 5.4 5.4 5.4 5.3 5.2 5.2 5.2 5.2 5.1 5.1 5.1 5.1 5.1 5.1 5.1 5.1 5.1 5.0 5.0 5.0 5.0 5.0 5.0 5.0 ...
[136] 4.8 4.8 4.8 4.8 4.7 4.7 4.6 4.6 4.6 4.6 4.5 4.4 4.4 4.4 4.3

# 值並非獨一，以值回取資料無意義
> iris[sort(iris$Sepal.Length, decreasing=T),]
```

2. order: 針對欄位，(由大而小) 排序位置
```
> order(iris$Sepal.Length, decreasing=T)
  [1] 132 118 119 123 136 106 131 108 110 126 130 103  51  53 121 140 142  77 113 144  66  78  87 109 125 141 145 146  59  76  55 105 111 117 148 ...
 [46] 101 104 124 134 137 147  69  98 127 149  64  72  74  92 128 135  63  79  84  86 120 139  62  71 150  15  68  83  93 102 115 143  16  19  56 ...
 [91] 122  34  37  54  81  82  90  91   6  11  17  21  32  85  49  28  29  33  60   1  18  20  22  24  40  45  47  99   5   8  26  27  36  41  44 ...
[136]  13  25  31  46   3  30   4   7  23  48  42   9  39  43  14

# index 為 UNIQUE，可以回取資料重排
> iris[order(iris$Sepal.Length, decreasing=T),]
```

---
<h3 align="center">隨堂練習</h3>
<h4 align="center">2330.csv 為一股價資料檔：</h4>

```
> stock=read.csv(2330.csv, header=TRUE)
> str(stock)
# 以利日期篩選，將 Date 欄位轉為日期型態
> stock$Date=as.Date(stock$Date)
```

1. 請找出 2014 全年最高、最低收盤價 (close) 為何？
```
# 兩行效果相同，均是針對欄位 (日期) 篩選
> stock2014=stock[[,("Date">"2014-01-01" & "Date"<"2014-12-31")],]
> stock2014=stock[(stock$Date>="2014-01-01" & stock$Date<="2014-12-31"),]

> max(stock2014$Close)
> min(stock2014$Close)
# 也可用排序觀察值 (首筆最高、末筆最低)
> sort(stock2014$Close, decreasing=T)
```

2. 承上，請找出這兩次事件的發生日期。
```
# 以 order 先找出 index 再回取資料
> stock2014[order(stock2014$Close, decreasing=T)]
```

---
### 5-4 清單 (list)
- 兼具`巢狀列表`以及`字典`的特色。
```
> product=list(name="orange", sales=c(10, 20))
> product
$name [1] "orange"
$sales[1] 10 20

# 等同 product[1]
> product$name
# 等同 product[[2]][1] (Python 字典取法)
> product$sales[1]

# list 也可包覆 data frame，篩選資料時要注意維度
> flower=list(title="iris data", data=iris)
# 等同 flower[[2]][, 1]
> flower$data[,"Sepal.Length"]
```

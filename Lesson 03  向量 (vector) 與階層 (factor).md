<h2 align="center">Lesson 03: 向量 (vector) 與階層 (factor)</h2>

### 3-1 向量之產生
1. numeric, logical 預設為 0 (FALSE)；character 預設為空字串。

2. 序列 sequence(seq)

| 語法 | Output |
| :--- | :--- |
| > seq1=1:16 | |
| > seq2=seq(1, 16) | 預設 by=1 |
| > seq3=seq(1, 16, by=5) | [1]  1  6 11 16 |
| > seq4=seq(1, 16, `length=5`) | [1]  1.00  4.75 8.50 12.25 16.00 |

3. 重複 repeat(rep)

| 語法 | Output |
| :--- | :--- |
| > rep1=rep(1, 5) | [1]  1  1  1  1  1 |
| > rep2=rep(c(1, 2), 5) | [1]  1  2  1  2  1  2  1  2  1  2 |
| > rep3=rep(c(1, 2), `each=5`) | [1]  1  1  1  1  1  2  2  2  2  2 |
| > rep4=rep(c(1, 2), length=5) | # 重複至長度為 5：[1]  1  2  1  2  1 |

---
### 3-2 基本向量運算
- A=c(10, 15, 20)、B=c(10, 3, 5)、C=c(10, 5)

```
> A+B
[1] 20 18 25
# 相異長度：會自動將短者重複至長度相同再運算
> A+C
[1] 20 20 30 (出現 warning 訊息)

> D=c(A, B, C)
# 可計算 length(D)、sum(D) 等
> D
[1] 10 15 20 10  3  5 10  5
```

---
<h3 align="center">隨堂練習</h3>
<h4 align="center">中央圖書館彙整本月違規次數如下：學士班 120 次、碩士班 200 次、博士班 40 次。</h4>

1. 試求碩士生在圖書館違規之相對次數？
```
> violate=c(120, 200, 40)
# 計算元素加總，再讓向量元素逐個與之相除
> per=violate/sum(violate)
> per
[1] 0.333 0.556 0.111
```

2. 圖書館另統計教職員亦有 60 次違規，請重新計算上題結果。
```
# 用 c 再加入最後一筆資料
> violate2=c(violate, 60)　
> per=violate2/sum(violate2)
> per
[1] 0.286 0.476 0.095 0.143
```

---
### 3-3 條件與篩選
1. 除了可用 index 取得元素，也可替元素命名。
```
> height=c(171, 178, 167, 177, 170)
> names(height)=c("01", "02", "03", "04", "05")
> height
 01  02  03  04  05 
171 178 167 177 170
```

| 語法 | Output | 備註 |
| :--- | :--- | :--- |
| > class(height) | [1] "numeric" | 是向量沒錯，不過是由 numeric 型態資料所組成 |
| > str(height) | Named num [1:5] 171 178 167 177 170<br>- attr(\*, "names")= chr[1:5] "01" "02" "03" "04" "05" | 同步顯示`自定義屬性 names`|
| > summary(height) | Min.  1st Qu.  Median   Mean  3rd Qu.   Max.<br>167.0   170.0   171.0   172.6   177.0   178.0 | 數值型資料呈現`分布狀況`<br>類別型資料呈現`分配狀況` |

2. TRUE/FALSE 可做為資料的篩選條件。

```
# 或：不可用 or
> height>175 | height==170
   01    02    03    04    05 
FALSE  TRUE FALSE  TRUE  TRUE
# 且：不可用 and
> height<175 & height>170
   01    02    03    04    05 
 TRUE FALSE FALSE FALSE  TRUE
```

| | 單項 | 多項 |
| :---: | :--- | :--- |
| index | > height[1] | # 向量為一維，不可寫成 (1, 2)<br>> height[c(1, 2)] |
| 元素名稱 | > height["02"] | > height[c("03", "05")] |
| 條件 | > height[height<175] | # 可搭配 |、& 查詢 |

---
<h3 align="center">隨堂練習</h3>
<h4 align="center">以下是數位同學之身高體重：Brian 180/73、Toby 169/87、Sherry 173/43：</h4>

1. 正常範圍之身體質量指數為 18.5~24，請找出符合者：
```
> height=c(180, 169, 173)
> weight=c(73, 87, 43)
> names(height)=c("Brian", "Toby", "Sherry")

# 條件只能放入單一參數，不是 height[條件1]&height[條件2]
> height[weight/(height/100)^2>18.5 & weight/(height/100)^2<24]
Brian 
  180 
```

2. 護理師想知道非正常範圍同學之 BMI 指數，請協助之：
```
> BMI=weight/(height/100)^2
> names(BMI)=c("Brian", "Toby", "Sherry")
> BMI[BMI>24|BMI<18.5]
  Toby  Sherry 
30.461 14.367
```

---
### 3-4 階層與順序
1. 以 `factor 取出階層類別`、length(levels) 計算階層數。
2. 可定義階層是否有序，並設定大小關係。

| | 無序階層 | 有序階層 |
| :---: | :--- | :--- |
| 組成 | weather=c("rainy", "cloudy", "cloudy", "sunny", "rainy") | size=c("XL", "M", "L", "S", "M") |
| factor | # 隨機排列<br>> factor(weather)<br>[1] rainy  cloudy cloudy sunny  rainy<br>Levels: cloudy rainy sunny | # 若未定義 order：以字母排序<br>> factor(size, `order=T`, levels=c("S", "M", "L", "XL"))<br>[1] XL M  L  S  M <br>Levels: S < M < L < XL |
| levels | [1] "cloudy" "rainy"  "sunny" | [1] "S"  "M"  "L"  "XL" |
| length(levels) | [1] 3 | [1] 4 |

```
stype=factor(size, order=T, levels=c("S", "M", "L", "XL"))

- 設定階層後可比較大小
> stype[1]>stype[2]
[1] TRUE
- 但與原始資料無關 (size[1], size[2] 不可比較)
```

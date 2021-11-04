<h2 align="center">Lesson 09: 敘述統計 (2)：圖表視覺化</h2>

- 儲存檔案後才能開始繪圖
```
> pdf(--工作路徑/檔名.pdf--)
> png(--工作路徑/檔名.png--)
> jpeg(--工作路徑/檔名.jpeg--)
> dev.off()
```

### 9-1 類別型圖表：只接受 (整理後) 次數統計
1. bar chart (長條圖): barplot

| 操作 | 語法 |
| :--- | :--- |
| 基本繪製 | barplot(table(cdc$exerany)) |
| 加上參數 (x, y 軸名稱、色彩) | barplot(table(cdc$genhlth), xlab="健康狀況", ylab="人數", `col=rainbow(5)`) |
| 離散化之連續資料 | barplot(table(`cut(cdc$height, seq(45, 95, by=5))`), xlab="身高區段", ylab="人數", col=rainbow(10)) |
| 雙變數：`聯合機率表`<br>預設為堆疊呈現 (beside=F) | barplot(table(cdc$exerany, cdc$gender), beside=T) |

2. pie chart (圓餅圖): pie

| 操作 | 語法 |
| :--- | :--- |
| 基本繪製 | G=table(cdc$genhlth)<br>pie(G) |
| 加上參數 (標籤、色彩)<br>- 標示類別次數<br>- 標示類別比例 | pie(G, labels=`names(G)`, col=rainbow(5))<br>pie(G, labels=paste(names(G), "x", G), col=rainbow(5))<br>pie(G, labels=paste(names(G), "x", `round(G/length(cdc$genhlth)*100, 1`), "%"), col=rainbow(5)) |
| `離散化之連續資料`<br>- 標示類別次數<br>- 標示類別比例 | H=table(cut(cdc$age, seq(16, 100, by=12), right=T))<br>pie(H, labels=paste(names(H), "x", H), col=rainbow(6))<br>pie(H, labels=paste(names(H), "x", round(H/length(cdc$age)*100, 1), "%"), col=rainbow(6)) |

<pre>
注意：圓餅圖不適合呈現聯合機率資料。
</pre>

3. mosaic chart (鑲嵌圖): mosaicplot
```
> M=table(cdc$gender, cdc$exerany)

# rownames 影響橫軸 (xlab)、colnames 影響縱軸 (ylab)
> rownames(M)=c("男性", "女性")
> colnames(M)=c("無運動", "有運動")　
> mosaicplot(M, col=rainbow(2))
```
<pre>
注意：鑲嵌圖不適合呈現聯合機率資料 (已離散化處理之連續資料無法跨變數分析)。
</pre>

---
### 9-2 連續型圖表：可逕用原始數據

1. histogram (直方圖): hist
- breaks: 指定 (概略) 組數
```
> hist(cdc$weight)
> hist(cdc$weight, breaks=25, col=rainbow(15))
```
---
<h3 align="center">隨堂練習</h3>
<h4 align="center">若欲依照性別做身高、體重的直方圖對照，如何顯示較為清晰？</h4>

```
# 規劃版面為 2x2 (row/col)
> par(mfrow=c(2, 2))
> M=cdc[cdc[,"gender"]=="m",]
> F=cdc[cdc[,"gender"]=="f",]

# 可統一設定 xlim 以利比較
> hist(M$height, breaks=15, col=rainbow(10), xlab="身高", main="男性身高")
> hist(M$weight, breaks=15, col=rainbow(10), xlab="體重", main="男性體重")
> hist(F$height, breaks=15, col=rainbow(10), xlab="身高", main="女性身高")
> hist(F$weight, breaks=15, col=rainbow(10), xlab="體重", main="女性體重")
```

2. box chart (盒鬚圖): boxplot

| 操作 | 語法 |
| :--- | :--- |
| 基本繪製 | boxplot(cdc$age) |
| 加上分類 (gender) | boxplot(cdc$age~cdc$gender, ylab="年齡", xlab="性別", col=rainbow(5)) |
| # 預設為`垂直`：x, y 標籤對調<br>設定水平輸出 | boxplot(cdc$age~cdc$gender, `xlab="年齡", ylab="性別"`, col=rainbow(5), horizontal=T) |

3. scatter plot (散佈圖): plot

| 操作 | 語法 |
| :--- | :--- |
| 基本繪製 | plot(cdc$weight, cdc$height) |
| 3x3 之`兩兩散佈圖` | plot(cdc[,`c("height", "weight", "wtdesire")`]) |

---
### 9-3 進階套件：ggplot
- 安裝套件：`ggplots`

1. 離散型資料：geom_bar()

| 操作 | 語法 |
| :--- | :--- |
| 基本繪製 | ggplot(cdc, aes(x=smoke100))+geom_bar() |
| 加上參數 (x, y 軸名稱、色彩) <br>預設為`藍底黃框` | ggplot(cdc, aes(x=smoke100))+geom_bar(fill="blue", color="yellow")<br>+xlab("吸菸情況")+ylab("人數") |
| 雙變數<br>預設 stack 堆疊 (fill: `圖例`)<br>可設定 dodge `左右並排` | ggplot(cdc, aes(x=smoke100, `fill=gender`))+geom_bar()<br>ggplot(cdc, aes(x=smoke100, fill=gender))+geom_bar(`position="dodge"`) |

- facet_wrap: 多圖並列
```
> ggplot(cdc, aes(x=smoke100))+geom_bar()+facet_wrap(~gender)
# genhlth 對 gender (5x2) 
> ggplot(cdc, aes(x=smoke100))+geom_bar()+facet_wrap(genhlth~gender)
```

- 同樣適用於離散化連續資料，然需`轉為 data frame` 才可取 x, y 變數。
```
> category=as.data.frame(table(cut(cdc$height, seq(45, 95, by=5))))
# identity: 直接以資料原貌製表，不需彙整統計
> ggplot(category, aes(x=Var1, y=Freq))+geom_bar(stat="identity")
```

- 延伸應用：
  - 水平軸向：coord_flip()
  - 極座標花瓣圖：`coord_polar()`

<pre>
注意：
1. ggplot 如同直方圖，可針對原始資料繪製 (無須彙總)；針對已匯整之資料須設定 stat=identity 才可使用。
2. ggplot 無法直接畫圓餅圖。
</pre>

2. 連續型資料：geom_histogram()
- ggplot 繪製概念類似圖層，可先定義原始畫布，再逐層堆疊添加
```
> g=ggplot(cdc, aes(x=height))
> g=g+geom_histogram()+xlab("身高分布")
# 以 plot 參數儲存圖片  
> ggsave(filename=--檔名.png--, plot=g)
```

| 操作 | 語法 |
| :--- | :--- |
| 基本繪製 | ggplot(cdc, aes(x=height))+geom_histogram() |
| 加上參數 (x, y 軸名稱、色彩) <br>bins 預設為 30 | ggplot(cdc, aes(x=height))+geom_histogram(fill="pink", color="black", bins=40)<br>+xlab("身高分布")+ylab("人數") |
| 雙變數<br>預設 stack 堆疊 (fill: `圖例`)<br>可設定 dodge `左右並排` | ggplot(cdc, aes(x=weight, `fill=gender`))+geom_histogram()<br>ggplot(cdc, aes(x=weight, fill=gender))+geom_histogram(`position="dodge"`) |

- facet_wrap: 多圖並列
```
> ggplot(cdc, aes(x=weight))+geom_histogram()+facet_wrap(~gender)
# gender 對 genhlth (2x5) 
> ggplot(cdc, aes(x=weight))+geom_histogram()+facet_wrap(gender~genhlth)
```

3. 連續型資料：geom_point()

| 操作 | 語法 |
| :--- | :--- |
| 基本繪製 | ggplot(cdc, aes(x=height, y=weight))+geom_point() |
| 加上`圖例` (shape/size 均可) | ggplot(cdc, aes(x=height, y=weight))+geom_point(`aes(col=gender)`) |

- 延伸應用：
  - 水平軸向：coord_flip()
  - 極座標花瓣圖：`coord_polar()`

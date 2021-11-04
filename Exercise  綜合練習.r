<h2 align="center">R Final Homework</h2>

```{r}
#(1) 請讀取final資料夾下的lvr_prices檔案。[5分]
```
<p>
# 若開檔後呈亂碼，則需先開啟 big5<br>
> load("E:/R/riii/final/lvr_prices_big5.RData")<br>
> load("E:/R/riii/final/lvr_prices.RData")
</p>

```{r}
#(2) 請問可使用哪個函式觀看檔案的資料結構？[5分]
```
<p>
# 不等同 str("lvr_prices"): chr<br>
> str(lvr_prices)
</p>
<pre>
'data.frame':   102054 obs. of  25 variables:
 $ Unnamed..0      : int  0 1 2 3 4 5 6 7 8 9 ...
 $ area            : Factor w/ 12 levels "士林區","大同區",..: 3 5 2 2 6 10 9 9 1 3 ...
 $ trading_target  : Factor w/ 5 levels "土地","車位",..: 3 3 1 3 3 1 1 3 3 3 ...
 $ address         : Factor w/ 17557 levels "一段91巷23弄1~30號",..: 6185 8775 17098 5469 9829 3472 17491 13570 4342 6811 ...
 $ land_sqmeter    : num  19.39 8.46 5.5 3.88 32.41 ...
 $ city_land_type  : Factor w/ 6 levels "","工","住","其他",..: 3 5 4 5 3 4 4 3 3 5 ...
 $ trading_ymd     : Factor w/ 2312 levels "","1973-08-29",..: 912 931 940 923 923 936 936 930 933 930 ...
 $ trading_num     : Factor w/ 420 levels "土地0建物0車位0",..: 130 306 87 337 105 303 87 105 105 105 ...
 $ floor           : Factor w/ 515 levels "","一層","一層，二層",..: 304 116 1 326 280 1 1 101 2 149 ...
 $ total_floor     : Factor w/ 37 levels "","一層","七層",..: 18 20 1 17 34 1 1 3 34 37 ...
 $ building_type   : Factor w/ 12 levels "工廠","公寓(5樓含以下無電梯)",..: 3 12 4 3 2 4 4 9 2 2 ...
 $ main_purpose    : Factor w/ 13 levels "","工商用","工業用",..: 12 11 1 11 5 1 1 12 5 5 ...
 $ built_with      : Factor w/ 18 levels "","土木造","土造",..: 17 17 1 17 17 1 1 17 17 17 ...
 $ finish_ymd      : Factor w/ 8710 levels "","1911-05-06",..: 4245 3467 1 2172 3125 1 1 5519 2821 1265 ...
 $ building_sqmeter: num  101 93.4 0 36.7 104.1 ...
 $ room            : int  3 0 0 1 3 0 0 3 2 3 ...
 $ living_room     : int  2 0 0 1 1 0 0 2 1 2 ...
 $ bath            : int  1 0 0 1 1 0 0 2 1 2 ...
 $ compartment     : Factor w/ 2 levels "有","無": 1 1 1 1 1 1 1 1 1 1 ...
 $ management      : Factor w/ 2 levels "有","無": 1 1 2 1 2 2 2 1 2 2 ...
 $ total_price     : num  18680000 20300000 132096 4200000 14000000 ...
 $ parking_type    : Factor w/ 8 levels "","一樓平面",..: 1 1 1 1 1 1 1 1 1 1 ...
 $ parking_sqmeter : num  0 0 0 0 0 0 0 0 0 0 ...
 $ parking_price   : int  0 0 0 0 0 0 0 0 0 0 ...
 $ ID              : Factor w/ 102054 levels "0","1","2","3",..: 1 2 3 4 5 6 7 8 9 10 ...
</pre>

```{r}
#(3) 請問可使用哪個函式觀看資料前10筆資料？[5分]
```
<p>
> head(lvr_prices, 10)
</p>

```{r}
#(4) 請篩選出
#  1. city_land_type為住宅用
#  2. total_price>0
#  3. building_sqmeter>0
#  4. finish_ymd非空值
#  的房屋資料，並存入house變數中。[8分]
```
<p>
# 查看 str(lvr_prices$finish_ymd) 可知：空值為空白字串 ("")，非缺失值 (\<NA>)<br>
> house=lvr_prices[lvr_prices$city_land_type=="住"&lvr_prices$total_price>0&lvr_prices$building_sqmeter>0&lvr_prices$finish_ymd!="", ]
</p>

```{r}
#(5) 請使用house資料，利用房屋價格(total_price)及房屋平方米數(building_sqmeter)兩欄位，
#    產生一新欄位為每平方米價格(price_per_sqmeter)，並將其四捨五入到整數位。[5分]
```
<p>
# 新增欄位需註明 house$<br>
> house$price_per_sqmeter=round(house$total_price/house$building_sqmeter, 0)
</p>

```{r}
#(6) 請使用house資料，利用scale()將每平方米價格(price_per_sqmeter)欄位資料標準化，
#    並剔除掉outlier資料(z-score>3)。[5分]
```
<p>
# abs 將標準化結果取絕對值，且篩選 \<=3 ([-3, 3]) 部分<br>
> house=house[abs(scale(house$price_per_meter))<=3, ]
</p>

```{r}
#(7) 請問在house資料中各行政區(area)的資料筆數為何？可否畫出其長條圖？[5分]
```
<p>
# summary 原本對類別資料即呈現次數統計，結果同 table(house$area)<br>
> summary(house$area)
</p>
<pre>
士林區  大同區  大安區  中山區  中正區  內湖區  文山區  北投區  松山區  信義區  南港區  萬華區 
 5274    983   3881   4438   2377   7793   6293   6057   2812   3085   2903   2440
</pre>
<p>
> barplot(summary(house$area), xlab="行政區")
</p>

```{r}
#(8) 請使用house資料，計算各行政區每平方米價格(price_per_sqmeter)欄位資料的平均數，中位數及標準差。[8分]
```
<p>
> install.packages("dplyr")<br>
> library("dplyr")<br>
> house %>%<br>
+ group_by(area) %>%<br>
# 對指定欄位 .vars、運算指定方法 .funs<br>
+ summarise_at(.vars=vars(price_per_sqmeter), .funs=funs(mean, median, sd))
</p>
<pre>
# A tibble: 12 x 4
   area    mean   median   sd
 1 士林區 165804. 158733  82886.
 2 大同區 138409. 140310  55706.
 3 大安區 247148. 248055 111525.
 4 中山區 191189. 188337  81773.
 5 中正區 205840. 205756  84486.
 6 內湖區 153235. 153264  54979.
 7 文山區 125664. 126366  39370.
 8 北投區 133586. 130108  55828.
 9 松山區 194180. 202705  75834.
10 信義區 195851. 187912  96538.
11 南港區 168883. 170298  55608.
12 萬華區 104257. 101056  55204.
</pre>
<p>
# 依 area 分組輸出 (僅能為單值)，需於函式內加寫 vector: c()<br>
> tapply(house$price_per_sqmeter, house$area, function(e){c(mean(e), median(e), sd(e))})
</p>
<pre>
$士林區
[1] 165804.02 158733.00  82885.72
$大同區
[1] 138409.27 140310.00  55705.87
$大安區
[1] 247147.8  248055.0  111525.0
$中山區
[1] 191188.54 188337.00  81773.21
$中正區
[1] 205840.27 205756.00  84486.38
$內湖區
[1] 153234.58 153264.00  54979.36
$文山區
[1] 125663.78 126366.00  39369.61
$北投區
[1] 133586.5  130108.0   55828.0
$松山區
[1] 194179.66 202705.00  75834.34
$信義區
[1] 195851.33 187912.00  96537.79
$南港區
[1] 168882.97 170298.00  55608.19
$萬華區
[1] 104257.01 101056.00  55204.07
</pre>

```{r}
#(9) 請使用house資料,利用ggplot2的facet_wrap函數繪製各行政區房屋每平方米價格(price_per_sqmeter)的直方圖。[8分]
```
<p>
> install.packages("ggplot2")<br>
> library("ggplot2")<br>
# graphics 中函數名稱為 hist()，facet_wrap 乃視覺化分組彙整功能<br>
> ggplot(house, aes(x=price_per_sqmeter))+geom_histogram()+facet_wrap(~area)
</p>

```{r}
#(10) 試利用房屋完工日期(finish_ymd)產生一新變數為屋齡(building_age)加入house資料中。
#hint1: 取得當前日期的函數為 Sys.Date()
#hint2: 一年請以365天計算，四捨五入至整數位
#hint3: 將運算完的資料轉為整數型態(integer) [8分]
```
<p>
# 查看 str(house$finish_ymd)：factor 無法做時間運算<br>
> house$finish_ymd=as.Date(house$finish_ymd)<br>
> house$building_age=as.integer(round((Sys.Date()-house$finish_ymd)/365, 0))<br>
> str(house)
</p>
<pre>
'data.frame':   48336 obs. of  27 variables #已增加變數 building_age
</pre>

```{r}
#(11) 請讀取final資料夾下的house_danger檔案，
#     並將house資料集和house_danger資料集以left outer join方式join起來，
#     存回house變數中。[5分]
```
<p>
> load("E:/R/riii/final/house_danger.RData")<br>
# left join 即以 house(x) 資料為主。亦可寫成：merge(house, house_danger, by="ID", all.x=T)<br>
> house=merge(x=house, y=house_danger, all.x=T)<br>
> str(house)
</p>
<pre>
'data.frame':   48336 obs. of  28 variables　#已增加變數 danger
</pre>

```{r}
#(12) 請將house資料以8:2的比例分為訓練集和測試集，
#     將訓練集資料存在trainset變數中，將測試集資料存在testset變數中。[5分]
```
<p>
# 依比例抽取 nrow 次，replace: 取後可放回<br>
> index=sample(2, nrow(house), replace=T, prob=c(0.8, 0.2))<br>
> trainset=house[index==1, ]<br>
# 從紀錄表根據符合項 (反取位置) 分割資料。逗號不可省略
> testset=house[index==2, ]<br>
> str(trainset)
</p>
<pre>
'data.frame':   38640 obs. of  28 variables
</pre>
<p>
> str(testset)
</p>
<pre>
'data.frame':    9696 obs. of  28 variables
</pre>

```{r}
#(13) 利用rpart套件建立一預測房屋是否為危樓(danger)的決策樹模型，
#     請利用行政區(area), 屋齡(building_age), 房屋總平方米數(building_sqmeter),
#     房屋類型(building_type)及每平方米價格(price_per_sqmeter)
#     5個變數作為解釋變數放入模型當中建模，並將模型存在house.rp變數中。[5分]
```
<p>
> install.packages("rpart")<br>
> library("rpart")<br>
# 建模：預測變數~解釋變數 (以加號相連接，非逗號分隔)<br>
> house.rp=rpart(danger~area+building_age+building_sqmeter+building_type+price_per_sqmeter, data=trainset)
</p>

```{r}
#(14) 請利用plot()和text()畫出house.rp模型的決策樹。[5分]
```
<p>
# 畫出決策樹骨幹<br>
> plot(house.rp)<br>
# 標示決策樹叢目 (use.n 加上樣本數據)<br>
> text(house.rp, use.n=T)
</p>

```{r}
#(15) 請問此決策樹是否需要進行剪枝(prune)？如需剪枝請將修剪後的模型存回house.rp中。[5分]
```
<p>
> house.rp$cptable
</p>
<pre>
        CP  nsplit rel error    xerror        xstd
1 0.19608835      0 1.0000000 1.0000000 0.011946787
2 0.09248019      2 0.6078233 0.6076547 0.009638361
3 0.06592480      4 0.4228629 0.4223571 0.008160587
4 0.02706120      5 0.3569381 0.3566009 0.007538828
5 0.01000000      8 0.2743214 0.2748272 0.006662034
</pre>
<p>
# xerror 持續降低未反升，理論上可以不剪枝 (which.min(house.rp$cptable[, "xerror"])=5)<br>
# 若需剪枝，設定剪枝條件：cptable[min(xerror) 位置, "CP"]<br>
> cut=house.rp$cptable[which.min(house.rp$cptable[, "xerror"]), "CP"]<br>
> house.rp=prune(house.rp, cp=cut)
</p>

```{r}
#(16) 請將測試集資料(testset)放入模型中進行驗證，請問此模型的accuracy, precision, recall等績效分別為何？[5分]
```
<p>
# 混淆矩陣需安裝 caret, e1071 套件<br>
> predict1=predict(house.rp, testset, type="class")<br>
> install.packages("caret")<br>
> library("caret")<br>
> install.packages("e1071")<br>
> library("e1071")<br>
> confusionMatrix(table(predict1, testset$danger)
</p>
<pre>
    predict   NO  YES
         NO  7784   18　# predict=N: 陽性 (TP 真陽、FP 偽陽)
         YES  403 1491　# predict=Y: 陰性 (FN 偽陰、TN 真陰)<br>            
               Accuracy : 0.9566　#accuracy 95.66%: TP+TN/ALL          
                 95% CI : (0.9523, 0.9606)
    No Information Rate : 0.8444          
    P-Value [Acc > NIR] : < 2.2e-16<br>      
                  Kappa : 0.8504<br>
 Mcnemar's Test P-Value : < 2.2e-16<br>
            Sensitivity : 0.9508　#recall 95.08%: TP/TP+FN  
            Specificity : 0.9881          
         Pos Pred Value : 0.9977　#precision 99.77%: TP/TP+FP         
         Neg Pred Value : 0.7872          
             Prevalence : 0.8444          
         Detection Rate : 0.8028          
   Detection Prevalence : 0.8047          
      Balanced Accuracy : 0.9694<br>
       'Positive' Class : NO
</pre>

```{r}
#(17) 請繪製出此模型的ROC曲線，並計算其AUC。[8分]
```
<p>
> install.packages("ROCR")<br>
> library("ROCR")<br><br>
# predict1: class 辨別分類、predict2: prob 分析機率<br>
> predict2=predict(house.rp, testset, type="prob")<br>
# 比對：testset 之預測機率及實際結果<br>
> predict3=prediction(predict2[, "YES"], testset$danger)<br><br>
> perform1=performance(predict3, "tpr", "fpr")<br>
# ROC 曲線：X=假陽性率, Y=真陽性率 (能否在 FP 發生尚低時找到足多之 TP 樣本)<br>
> plot(perform1)<br>
# perform1: ROC 曲線、perform2: AUC 指標，均由 predict3 之比對結果取得<br>
> perform2=performance(predict3, measure="auc", x.measure="cutoff")<br>
> print(perform2@y.values)
</p>
<pre>
[[1]]
[1] 0.9707122
</pre>

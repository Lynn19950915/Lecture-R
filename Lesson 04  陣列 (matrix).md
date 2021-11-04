<h2 align="center">Lesson 04: 陣列 (matrix)</h2>

### 4-1 陣列之產生
1. 預設以 col 填入，可設定 byrow=T/F。
```
# 1:6=seq(1, 6)
> M1=matrix(1:6, nrow=2)
> M2=matrix(seq(1, 6), nrow=2, byrow=T)
> M2
        [,1] [,2] [,3]
[1,]    1    2    3
[2,]    4    5    6
```

2. str 可觀察結構、summary 呈現摘要統計值。
```
> class(M2)
> str(M2)
int[1:2, 1:3] 1 4 2 5 3 6
> summary(M2)
       V1             V2             V3      
 Min.   :1.00   Min.   :2.00   Min.   :3.00  
 1st Qu.:1.75   1st Qu.:2.75   1st Qu.:3.75  
 Median :2.50   Median :3.50   Median :4.50  
 Mean   :2.50   Mean   :3.50   Mean   :4.50  
 3rd Qu.:3.25   3rd Qu.:4.25   3rd Qu.:5.25  
 Max.   :4.00   Max.   :5.00   Max.   :6.00
```

---
### 4-2 基本操作運算
1. 乘法計算
- M1*M2: 對應位置相乘
- M1XM2: 矩陣乘法 (需 col(M1)=row(M2) 才可計算)

2. 行列與轉置
```
> A=c(80, 95, 85)
> B=c(90, 85, 88)
> score=matrix(c(A, B), nrow=2, byrow=T)

> t(score)
     [,1] [,2]
[1,]   80   90
[2,]   95   85
[3,]   85   88
# 長度顯示：nrow/ncol
> dim(score)
> ncol(score)
```

---
### 4-3 條件與篩選
1. 行列均可設定 name，篩選時只要任一邊大於 1 即顯示表頭名稱。
```
> rownames(score)=c("Lynn", "Irene")
> colnames(score)=c("M", "F", "T")
# 等同 score["Lynn",] 篩選
> score[1,]
  M  F  T 
 80 95 85
# 等同 score[, c("M", "F")]
> score[, 1:2]
       M  F
Lynn  80 95
Irene 90 85
```
- rowSums(score): 學生總成績
- colMeans(score): 測驗平均分數

2. rbind/cbind: 行列增寫

```
> score2=rbind(score, c(99, 95, 98))
# 陣列要求型態相同，故數字被強制轉換
> score3=cbind(score2, c("A", "A", "A+"))
     　 M    F    T        
 Lynn "80" "95" "85" "A" 
Irene "90" "85" "88" "A" 
      "99" "93" "97" "A+"
```

---
<h3 align="center">隨堂練習</h3>
<h4 align="center">R 語言測驗分為期中、期末考，以下是三位同學之成績: Adam 74/83、Linda 91/78、William 69/96。</h4>

1. 請計算出期中、期末考之平均成績。
```
> Adam=c(74, 83)
> Linda=c(91, 78)
> William=c(69, 96)
# 以 row 填入，並計算平均 colMeans
> score=matrix(c(Adam, Linda, William), byrow=T, nrow=3)
> colMeans(score)
[1] 78.000 85.667
```

2. 今發現遺漏一筆成績：Joanna 85/86，請協助增補上並新增一個總分欄位 (T)。
```
> Joanna=c(85, 86)
> score2=rbind(score, Joanna)
# cbind: 將 rowSums 新增為一個欄位
> score3=cbind(score2, rowSums(score2))
> rownames(score2)=c("Adam", "Linda", "William", "Joanna")
> colnames(score3)=c("M", "F", "T")
> score3
          M  F   T
 Adam    74 83 157
 Linda   91 78 169
 William 69 96 165
 Joanna  85 86 171
```

3. 在計算成績時，老師以 40% M、60% F 為配重比例，請依此新增一個總成績欄位(S)。
```
> score4=cbind(score3, score3[, 1]*0.4+score3[, 2]*0.6)
# 設定末項 colname
> colnames(score4)[ncol(score4)]="S"
> score4
          M  F   T    S
 Adam    74 83 157 79.4
 Linda   91 78 169 83.2
 William 69 96 165 85.2
 Joanna  85 86 171 85.6
```

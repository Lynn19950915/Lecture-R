<h2 align="center">Lesson 06: 流程與函式</h2>

### 6-1 流程控制
1. 條件判斷 if...(else if...)else
- 分號、大括號可省略；小括號則不行
```
> if(x>10){print("x>10");}else{print("x<=10");}
> if(x>10) print("x>10")  else print("x<=10")

> if(x>10){print("第一類");}else if(x>5){print("第二類");}else{print("第三類");}
> if(x>10) print("第一類")  else if(x>5) print("第二類")  else print("第三類")
```

- ifelse
```
> test=ifelse(x>3, "x>3", "x<=3")
```

2. 迴圈 for/while

| | sum=0 | output: sum |
| :---: | :--- | :---: |
| for | for(i in 1:10){sum=sum+i;} | 55 |
| while | j=1<br>while(j<=10){j=j+1; sum=sum+j;} | 55 |

---
<h3 align="center">隨堂練習</h3>
<h4 align="center">請運用 for 迴圈寫出九九乘法表。</h4>

```
# 類似 concat(python) 相黏功能
> for(i in 1:9){for(j in 1:9){print(paste(i, "x", j, "=", i*j))}}　

# 預設串接符為空白，串接長度=1
> paste("A", "B", "C", "D", sep="-")
# 對位串接，串接長度=2
> paste(c("A", "B'), c("C", "D"))
[1] "A C" "B D"
# 加入相黏符，串接長度=1
> paste(c("A", "B"), c("C", "D"), collapse="+")
```

---
### 6-2 迴圈函式
```
# 建立一預設輸出五倍的腳本，類似 python lambda 函式
> f=function(a, x=5){a*x}
> f(10)
```

1. lapply&sapply: 逐一運算 (代入每一個元素)
- lapply: 以 list 形式呈現
- sapply: 以 vector 形式呈現

| | 向量 | 陣列 | 表格 | 清單 |
| :---: | :---: | :---: | :---: | :---: |
| 組成 | V=c(10, 20, 30)<br>視為 3 個元素 | M=matrix(1:4, byrow=T, nrow=2)<br>視為 `4 個`元素 | D=data.frame(V, V)<br>由向量組成，視為 `2 個`元素 | L=list(c(10, 20), c(30, 40))<br>視為 2 個元素 |
| | (V, max) | (M, mean) | (D, `function(i) i%%7`) | (L, sum) |
| lapply | [[1]][1] 10<br>[[2]][1] 20<br>... | [[1]][1] 1<br>[[2]][1] 3<br>... | $V [1] 3 6 2<br>$V.1[1] 3 6 2 | [[1]][1] 30<br>[[2]][1] 70 |
| sapply | [1] 10 20 30 | # 預設縱向輸出<br>[1] 1 3 2 4 | `V V.1`<br>`[1,] 3 3`<br>`[2,] 6 6`<br>`[3,] 2 2` | [1] 30 70 |


2. apply&tapply: 彙整運算
- apply: 1 代表橫向 (row)、2 代表縱向 (col)
```
> M=matrix(1:4, byrow=T, nrow=2)
> apply(M, 1, mean)
[1] 1.5 3.5
# lazy function (等同 apply(M, 2, sum))
> apply(M, 2, function(i) sum(i))
[1] 4 6
```

- tapply: 加上分組參數
```
> score=c(92, 77, 83, 80, 98)
> group=c("A", "B", "B", "C", "A")
# 以 group 為分組參數，定義元素彙總方式
> tapply(score, group, mean)
 A  B  C 
95 80 80 
```

---
<h3 align="center">隨堂練習</h3>
<h4 align="center">請寫出一函式能讀取檔案 match.txt，並將檔案中之對戰成績轉換為一矩陣</h4>

```
> setwd(--工作路徑--)
# 宣告函式所需變數
> match_func=function(filename, header, sep){　
> A=read.table(filename, header=header, sep=sep)
```

```
# nrow=length(levels(A[, 1]), ncol=length(levels(A[, 2])
> B=matrix(-1, nrow=5, ncol=5)
# rownames=levels(A[, 1])
> rownames(B)=c("A", "B", "C", "D", "E")
# colnames=levels(A[, 2])
> colnames(B)=c("A", "B", "C", "D", "E")

# B[A[i, 1], A[i, 2]]=A[i, 3]
> for(i in 1:nrow(A)){
+ B[A[i, "V1"], A[i, "V2"]]=A[i, "V3"]}}　
> match_func(filename="match.txt", header=F, sep="|")
```

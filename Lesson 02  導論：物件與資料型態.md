<h2 align="center">Lesson 02: 導論：物件與資料型態</h2>

### 2-1 資料型態
1. 數與計算
```
> a<-3-8
# 物件導向語言：重新賦予、指向新值
> a<-3*8　
> b=2^10
# 取餘數：形同 7mod3, 7%3(python)
> c=7%%3

> 10, 2.5, -16
# integer: 數值型態之一，強調整數
> 10L, 4L
# complex: 複數
> 3+4i
```

2. 文字、布林與日期
```
> "Lynn", "Applepie"
> TRUE(T), FALSE(F)
# date，其下包含 posixct, posixlt(datetime) 格式
> "2019-10-25"
```
★ 當要求資料型態相同時，將發生自動強制轉換：
- character>date, posixct, posixlt
- character>complex>numeric, integer>boolean

---
### 2-2 物件型態：每筆資料均有各自型態，一至多筆資料可組成物件
1. atomic: 物件內之元素，型態`需保持相同`

| | 維度 | 性質 | 舉例 |
| :---: | :---: | :---: | :---: |
| 向量 (vector) | 一維 | 最基本之物件 | 顧客姓名、會員生日 |
| 階層 (factor) | 一維 | 帶有`類別型態`之物件，可自訂是否具比較關係 | 服裝尺碼、病患血型 |
| 陣列 (matrix) | `二維` | 具備兩個以上之欄位 | 考試成績榜 |

- 向量 (vector)
```
> height=c(178, 167, 177, 177, 170)
> height
[1] 178 167 177 177 170
```

- 階層 (factor)
```
> size=c("M", "XL", "S", "M", "L")
# 以 factor 取出資料中之 (不重複) 類別
> size_factor=factor(size)　
> size_factor
[1] M  XL S  M  L 
Levels: L M S XL
```

- 陣列 (matrix)
```
> M=matrix(1:8, nrow=2)
> M
     [,1] [,2] [,3] [,4]
[1,]    1    3    5    7
[2,]    2    4    6    8
```

2. recursive: 物件內之元素，型態`可有差異`

| | 維度 | 性質 | 舉例 |
| :---: | :---: | :---: | :---: |
| 清單 (list) | 一維 | 由`鍵-值組合`而成，類似 python 字典。<br>可儲存與 data frame 相同之資料，惟維度結構不同 | |
| 表格 (data frame) | `二維` | 具備兩個以上之欄位 | 顧客資料表 |

- 清單 (list)
```
> name=c("first", "mid", "final")
> per=c(30, 30, 40)
> ave=c(75, 78, 71)
> test=list(name, per, ave)
# 巢狀列表：由三大項組成，各自內均可再取出小項
> test
[[1]] [1] "first" "mid" "final"
[[2]] [1] 30 30 40
[[3]] [1] 75 78 71
```

- 表格 (data frame)
```
> name=c("first", "mid", "final")
> per=c(30, 30, 40)
> ave=c(75, 78, 71)
> test=data.frame(name, per, ave)
> test
    name per ave
1  first  30  75
2  mid    30  78
3  final  40  71
```

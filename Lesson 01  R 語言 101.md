<h2 align="center">Lesson 01: R 語言 101</h2>

### 1-1 常用功能指令

| | 功能簡介 |
| :---: | :---: |
| ?sum、?base::sum | 查看指令或套件之概略質性描述 |
| help(sum)、help(package="base") | 查看指令或套件之詳細使用文檔 |
| ls() | 查看現有環境變數 |
| rm(iris) | 刪除指定變數 |
| q() | 退出離開 |

---
### 1-2 檔案使用
1. 檔案位址
```
# 查看內建資料集
> data()
# 使用 iris 資料集
> data(iris)

# 查看當前目錄 (work-directory)
> getwd()
# 正反斜線均可 (\ 用於跳脫字符)
> setwd("C:/***")
```

2. 讀、寫檔案
- txt/csv/Rdata
```
> data1=read.table("data1.txt", header=T)
# 預設資料無表頭 (header)，可指定分隔符
> data2=read.csv("data2.csv", header=F, sep="|")
> data3=load("data3.RData")

# sample.data: R 軟體內開啟之檔案
> file1=write.table(sample.data, file="file1.txt")
> file2=write.csv(sample.data, file="file2.csv", sep="")
> file3=save(x=sample.data, file="file3.RData")
```
<br/>

| 格式 | 安裝套件 | 指令碼 |
| :---: | :---: | :--- |
| xls/xlsx | `install.packages(readxl)`+library(readxl) | data4=read_excel("data4.xlsx") |
| json | install.packages(jsonlite)+library(jsonlite) | data5=`fromJSON("data5.json")` |
| xml | install.packages(XML)+library(XML) | url="http://..."<br>data6=`xmlToDataFrame(url)` |

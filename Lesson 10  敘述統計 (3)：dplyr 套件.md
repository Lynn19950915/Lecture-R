<h2 align="center">Lesson 10: 敘述統計 (3)：dplyr 套件</h2>

### 10-1 資料庫連接
1. 安裝套件：`dplyr+RMariaDB`
```
> install.packages("dplyr")
> install.packages("RMariaDB")
> library(dplyr)
> library(RMariaDB)
```

2. 取得資料內容

| 步驟 | 語法 |
| :--- | :--- |
| 1) 資料庫連線 | conn=dbConnect(MariaDB(), dbname=xxx, host=xxx, port=xxx, user=xxx, password=xxx)
| 2) 取得資料表 | iris=copy_to(conn, "iris") |

- 使用 `dbGetQuery` 可直接寫入 SQL 語句。
```
dbGetQuery(conn, "select "Sepal.Length" from iris") %>% filter(Species=="setosa")
```

---
### 10-2 基礎篩選、排序
1. select: +欄位

| 語法 | 備註 |
| :--- | :--- |
| select(appledaily, category, clicked) | # R: appledaily`[, c("category", "clicked")]`<br># SQL: select category, clicked from appledaily |
| select(starts_with("Sepal"), "Species") | # 可搭配 contains, starts/ends with<br>篩選符合條件之`欄位名稱` (無關資料內容) |

2. filter: +條件

| 語法 | 備註 |
| :--- | :--- |
| filter(appledaily, category=="國際") | # R: appledaily[appledaily$category=="國際", ]<br># SQL: select * from appledaily where category="國際" |
| filter(appledaily, category %in% c("娛樂", "社會")) | # 可搭配 & and, | or 結合條件 (`針對資料內容`) |

3. arrange: `+[asc/]desc(欄位)`

---
<h3 align="center">隨堂練習</h3>
<h4 align="center">以 dplyr 語句完成下列資料查詢需求：</h4>

1. 篩選出娛樂分類新聞之 category, clicked 欄位。
```
> appledaily %>%
# . 可省略，表承接上層資料 (pipe: 資料導流)
+ select(., category, clicked) %>%
+ filter(., category=="娛樂")
```

2. 承上，將新聞分類更改為社會，並依點閱數由高至低排列。
```
> appledaily %>%
+ select(., category, clicked) %>%
+ filter(., category=="社會") %>%
# 預設升冪排列 (asc)
+ arrange(., desc(clicked))
```

---
### 10-3 分組彙整
1. 利用 `group_by` 分組 (類似迴圈函式 tapply)，可搭配 summarise 依組別彙算。

| 語法 | Output |
| :--- | :--- |
| > appledaily %>%<br>+ group_by(category) %>%<br>+ summarise(`total=sum(clicked)`)<br># 處理資料空值<br>summarise(total=sum(clicked, na.rm=T)) | # A tibble: 16 x 2<br>   category                             total<br> 1 3C                                  146308<br> 2 正妹                                672949<br> 3 生活                               3405582<br> 4 地產                                219668<br> 5 社會                               5644438<br> ... |
| > tapply(appledaily$clicked, appledaily$category, sum)<br># 處理資料空值<br>> tapply(appledaily$clicked, appledaily$category, `function(e){sum(e), na.rm=T`}) |     3C        正妹        生活        地產        社會<br>  146308      672949     3405582      219668     5644438 |

2. `summarise_at` 可同時搭配多個變數做彙整運算。
```
> tbl(conn, "iris") %>%
+ select(starts_with("Sepal"), "Species") %>%
+ group_by("Species") %>%
+ summarise_at(.funs=funs(mean, sd(., na.rm=T)), .vars=vars(starts_with("Sepal"))))
```

---
<h3 align="center">隨堂練習</h3>
<h4 align="center">以 dplyr 語句完成下列資料查詢需求：</h4>

1. 統計各類新聞之平均點閱數，並依結果由低至高排列。
```
> appledaily %>%
+ group_by(category) %>%
+ summarise(average=mean(clicked, na.rm=T)) %>%
+ arrange(average)
```

2. 計算各類新聞之類別總點閱數、類別總點閱占比。

| 步驟 | Solution |
| :--- | :--- |
| 解一<br>增寫點閱占比欄位，再同時彙整點閱數及占比<br><br># summarise 之用法：<br>- summarise_at: `+指定欄位`<br>- summarise_if: +符合條件<br>- summarise_all | > all=appledaily %>%<br>+ select(clicked) %>%<br>+ sum()<br><br>> appledaily=appledaily %>%<br>+ mutate(portion=clicked/all)<br><br>> summary1=appledaily %>%<br>+ group_by(category) %>%<br>+ summarise_at(.vars=vars(clicked, portion), .funs=funs(sum)) |
| 解二<br>分組彙整點閱數，再統一相除總點閱數、增寫欄位 | > summary2=appledaily %>%<br>+ group_by(category) %>%<br>+ summarise(total=sum(clicked))<br><br>> all=appledaily %>%<br>+ select(clicked) %>%<br>+ sum()<br><br>> summary2=summary2 %>%<br>+ mutate(portion=total/all) |

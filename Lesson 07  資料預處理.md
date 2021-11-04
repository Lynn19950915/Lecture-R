<h2 align="center">Lesson 07: 資料預處理</h2>

### 7-1 型態與資料整理

| | 語法 |
| :---: | :--- |
| 設定工作路徑 | setwd(--工作路徑--) |
| 載入資料 | load(appledaily.RData) |
| 輸出資料 | # 將 appledaily 變數輸出為檔案<br>save(appledaily, `file=--(工作路徑+)檔名.RData--`) |

1. 型態轉換

| 型態 | 語法 | 範例 |
| :---: | :--- | :--- |
| 字串 | as.character("字串") | as.character(appledaily$title) |
| 日期 | as.Date("日期") | as.Date(appledaily$dt, `format="%Y年%m月%d日"`) |
| 時間 | as.POSIXct("時間")<br>例："2016-04-13 16:25:00 CST" | as.POSIXct(appledaily$dt, `format="%Y年%m月%d日%H:%M"`)<br>unclass: 會以**總秒數**儲存 |
| | as.POSIXlt("時間") | as.POSIXlt(appledaily$dt)<br>unclass: 會依**各時間單位**儲存 ($sec, $min, $hour, $mday...) |

2. 覆寫、比對
- 將`人氣(254)`當中的數字取出，\\ 表示跳脫字元
```
> appledaily$clicked=sub("人氣\\(", "" , appledaily$clicked)
> appledaily$clicked=sub("\\)", "", appledaily$clicked)
> appledaily$clicked=as.integer(appledaily$clicked)

# 可以結合成單行 (巢狀式寫法)
> appledaily$clicked=as.integer(sub("人氣\\(", "", sub("\\)", "", appledaily$clicked)))
> appledaily$clicked
[1]   1754      0      0      0    311     24     20   ...
```
- 尋找標題包含 #日本 的文章
```
# 數字代表 index，需從原始欄位取得內容
> grep("日本", appledaily$title)
[1]    174    210    262    325    334    422    426   ...
> appledaily$title[grep("日本", appledaily$title)]
 [1] "翁啟惠自日本轉機回台　預計12:45降落松山機場"    "日本熊本大地震　我外交部：國人均安"             "【壹週刊】日本寫真女星　在台熱舞替她宣傳"      
 [4] "【法廣RFI】日本九州發生強烈地震"                "【法廣RFI】日本熊本地震 已知9死餘震不斷"        "日本熊本強震　當地主播戴安全帽報新聞"          
 [7] "【更新】日本益城町19棟建築倒塌　89人受傷"       "日本熊本縣強震　蔡英文表達關切與慰問"           "觀光局：初查日本旅行團人員均安"                
[10] "【有片】受強震影響　日本熊本縣建築倒塌多處起火" "日本預警系統多強大　正妹記者超有感"             "日本熊本益城町強震　至少10棟建築物倒塌"        
...
```

---
### 7-2 遺失值處理
1. 於資料中隨機產生遺失值

| 步驟 | 語法 | 備註 |
| :--- | :--- | :--- |
| 1) 抽出 20 個 index | draw=sample(1:nrow(appledaily), 20) | nrow: 完整資料筆數 |
| 2) 將這 20 個位置的資料移除 (設為 NA) | appledaily\[draw, "clicked"]=NA | |
| 3) 查詢資料遺失處的 index | `which(is.na(appledaily$clicked))` | is.na 中為 TRUE 的位置 |
| 4) 確認共有幾處資料發生遺失 | sum(is.na(appledaily$clicked)) | TRUE=1，sum 代表`遺失項數` |

2. 以平均數針對遺失處補值

| 步驟 | 語法 | 備註 |
| :--- | :--- | :--- |
| 1) 找出資料遺失之項次 | missing=which(is.na(appledaily$clicked)) | |
| 2) 計算其餘資料之平均 | appledaily=appledaily`[-missing,]`<br>average=mean(appledaily$clicked) | 兩步可合併為 average=mean(appledaily$clicked, `na.rm=T`) |
| 3) 依平均數進行補值 | appledaily\[missing, "clicked"]=average | =appledaily$clicked`[is.na(appledaily$clicked)]`=average |

3. 以`類別平均數`針對遺失處補值
```
# 以 tapply 針對文章類別分組
> cat_average=tapply(appledaily$clicked, appledaily$category, mean)
# 加上自定義函式，排除缺漏值
> cat_average=tapply(appledaily$clicked, appledaily#category, function(e){mean(e, na.rm=T)})

# 文章分類：names(cat_average[i])、平均點閱數：cat_average[i]
> cat_average
       3C           正妹          生活	　　　...　　
 3954.270      84118.625      11703.03	　　　...
> for (i in 1:length(cat_average)){
+ appledaily[appledaily$category==names(cat_average[i])&is.na(appledaily$clicked), "clicked"]=cat_average[i]
+ }
```

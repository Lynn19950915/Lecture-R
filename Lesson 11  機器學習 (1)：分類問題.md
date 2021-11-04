<h2 align="center">Lesson 11: 機器學習 (1)：分類問題</h2>

### 11-1 機器學習導論

| | 常見分析方法 |
| :---: | :---: |
| 監督式學習 | `分類問題(預測類別)`、迴歸分析(預測數值) |
| 非監督式學習 | 降低維度(合併特徵)、`分群問題(合併樣本)` |

- Lift: 描述變數與預測項之`連動關係`，包含方向、大小。
- Entropy: 描述系統之失序、混亂程度，介於 [0,1] 間。

---
### 11-2 分類演算
1. 資料切分：training/testing
```
> install.packages("C50")
> library("C50")
> data(churnTrain)

# 負面表列：排除哪些欄位
> churnTrain=churnTrain[, !names(churnTrain) %in% c("state", "area_code", "account_length")]
# 依比例抽樣 nrow 次，replace: 取後可以放回
> index=sample(2, nrow(churnTrain), replace=T, prob=c(0.7, 0.3))

# 依 index 號碼將資料分割為 70% 訓練集+30% 測試集
> training=churnTrain[index==1,]
> testing=churnTrain[index==2,]
```

2. 分組評估模型

| package | 衡量參數 | 特色 | 模型名稱 |
| :---: | :---: | :---: | :---: |
| rpart | Gini 值 | 可透過`交叉檢驗`選擇剪枝與模型 | rpart 模型 |
| party | `卡方 P-value` | 可透過置換檢驗`選擇分割點，無需剪枝` | ctree 模型 |

```
> library("rpart")
# 以 churn 欄位為根，切分變數與樣本
> T1=rpart(churn~., data=training)
# plot(T1); text(T1, use.n=T)
> T1
  1) root 2329 338 no (0.14512666 0.85487334)  
    2) total_day_minutes>=264.4 150  59 yes (0.60666667 0.39333333)  
      4) voice_mail_plan=no 115  28 yes (0.75652174 0.24347826)  
        8) total_eve_minutes>=167.3 91  10 yes (0.89010989 0.10989011) *
        9) total_eve_minutes< 167.3 24   6 no (0.25000000 0.75000000) *
      5) voice_mail_plan=yes 35   4 no (0.11428571 0.88571429) *
    3) total_day_minutes< 264.4 2179 247 no (0.11335475 0.88664525)  
      6) number_customer_service_calls>=3.5 186  88 no (0.47311828 0.52688172)  
       12) total_day_minutes< 159.75 69   6 yes (0.91304348 0.08695652) *
       13) total_day_minutes>=159.75 117  25 no (0.21367521 0.78632479)  
         26) total_eve_minutes< 155.5 21   9 yes (0.57142857 0.42857143)  
           52) total_day_minutes< 195.5 11   1 yes (0.90909091 0.09090909) *
           53) total_day_minutes>=195.5 10   2 no (0.20000000 0.80000000) *
         27) total_eve_minutes>=155.5 96  13 no (0.13541667 0.86458333)  
           54) total_day_minutes< 180.25 27   9 no (0.33333333 0.66666667)  
            108) total_eve_minutes< 212.15 11   2 yes (0.81818182 0.18181818) *
            109) total_eve_minutes>=212.15 16   0 no (0.00000000 1.00000000) *
           55) total_day_minutes>=180.25 69   4 no (0.05797101 0.94202899) *
      ...

> library("party")
> T2=ctree(churn~., data=training)
# 每一處俱為一節點 (node)，亦可做為參數
> T2　#plot(T2); text(T2, use.n=T)
```

---
### 11-3 剪枝與評估<br>
僅 rpart 可剪枝，故無 T2$cptable
```
> T1$cptable
# xerror 涉及總體修剪，觀察最小值並取之
> which.min(T1$cptable[, "xerror"])
> P=prune(T1, cp=T1$cptable[8, "CP"])
# plot(P); text(P, use.n=T)
> P
```

1. 常見驗證方法
- Holdout: 由樣本選出部分比例，做為交叉驗證數據 (如 30% 測試數據集)。
- K-fold: 將原始樣本分割 K 份，重複驗證 K 次，逐次輪替其一為交叉驗證數據、餘為訓練集。
- LOOCV: 留一驗證。

```
# rpart 參數：class, prob
> P1=predict(T1, testing, type="class")
> table(testing$churn, P1)

# party 參數：response, prob, node
> P2=predict(T2, testing, type="response")
> table(testing$churn, P2)
      yes  no
  yes 100  45
  no   18 841
```

2. 預測效力指標

| | YES | NO |
| :---: | :---: | :---: |
| Predict=Yes | TP 真陽性 | `FP 偽陽性` |
| Predict=No | `FN 偽陰性` | TN 真陰性 |

<pre>
偽陽性在刑案誤判時很嚴重，偽陰性在診疾誤判時很嚴重；兩者輕重要依情境權衡。
</pre>

- AUC 曲線下面積
- ROC 曲線：X=假陽性率、Y=真陽性率，能否於 X 尚低時找到足夠多 Y 樣本。

```
> install.packages("e1071")
> library("e1071")
> confusionMatrix(table(testing$churn, P2))                                          
           Accuracy : 0.9373    # 準確度：100+841/100+45+18+841          
           ...                                               
        Sensitivity : 0.8475    # 靈敏度 (陽性樣本)：100/100+18      
        Specificity : 0.9492    # 特異性 (陰性樣本)：841/45+841      
     Pos Pred Value : 0.6897    # PPV 陽性反應樣本：100/100+45      
     Neg Pred Value : 0.9790    # NPV 陰性反應樣本：841/18+841     
           ...  
```

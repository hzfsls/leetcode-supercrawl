## [1693.每天的领导和合伙人 中文官方题解](https://leetcode.cn/problems/daily-leads-and-partners/solutions/100000/mei-tian-de-ling-dao-he-he-huo-ren-by-le-jet2)
[TOC]

## 解决方案

---

### 方法：Group by 与 聚合

#### Pandas

对于这个问题，我们想找出 `daily_sales` DataFrame 中每个 **date_id** 和 **make_name** 中唯一的 **lead_id** 和唯一的 **product_id** 的个数。让我们看看原始的 DataFrame `daily_sales`：

| date_id   | make_name | lead_id | partner_id |
|-----------|-----------|---------|------------|
| 2020-12-8 | toyota    | 0       | 1          |
| 2020-12-8 | toyota    | 1       | 0          |
| 2020-12-8 | toyota    | 1       | 2          |
| 2020-12-7 | toyota    | 0       | 2          |
| 2020-12-7 | toyota    | 0       | 1          |
| 2020-12-8 | honda     | 1       | 2          |
| 2020-12-8 | honda     | 2       | 1          |
| 2020-12-7 | honda     | 0       | 1          |
| 2020-12-7 | honda     | 1       | 2          |
| 2020-12-7 | honda     | 2       | 1          |

<br>

我们首先使用 `.groupby().agg()` 方法，以 **date_id**、**make_name** 作为分组标准。DataFrame 将被拆分成组，每个组代表 **date_id** 和 **make_name** 的唯一组合。分组后，分组后的数据将使用 `.agg()` 方法进行分组，**lead_id** 和 **partner_id** 列将使用 `nunique` 方法聚合，计算每个分组内的唯一元素。我们还将使用 `.reset_index()` 方法来重命名聚合列。

```Python
# 让我们利用 .groupby() 方法，使用 'data_id' 和 'make_name'
# 作为分组标准并且使用 'nunique' 方法聚合 'lead_id' 和 'partner_id'
# 这会返回一组中不同的元素
df = daily_sales.groupby(['date_id', 'make_name']).agg({
    'lead_id': pd.Series.nunique,
    'partner_id': pd.Series.nunique
}).reset_index()
```

下面是我们新创建的 `df` DataFrame：

| date_id   | make_name | lead_id | partner_id |
|-----------|-----------|---------|------------|
| 2020-12-07 | honda    | 3       | 2          |
| 2020-12-07 | toyota   | 1       | 2          |
| 2020-12-08 | honda    | 2       | 2          |
| 2020-12-08 | toyota   | 2       | 3          |

<br>

在这个 `.groupby().agg()` 方法之后，产生的 `df` DataFrame 列需要相应地重命名：**lead_id** 为 **unique_leads**，**partner_id** 为 **unique_partners**。

```Python
# 重命名结果 DataFrame 并且 重命名列
df = df.rename(columns={
    'lead_id': 'unique_leads',
    'partner_id': 'unique_partners'
})
```

下面是重命名列之后的结果 `df` DataFrame：

| date_id    | make_name | unique_leads | unique_partners |
| ---------- | --------- | ------------ | --------------- |
| 2020-12-07 | honda     | 3            | 2               |
| 2020-12-07 | toyota    | 1            | 2               |
| 2020-12-08 | honda     | 2            | 2               |
| 2020-12-08 | toyota    | 2            | 3               |

<br>

下面是我们的完整代码：

```Python
import pandas as pd

def daily_leads_and_partners(daily_sales: pd.DataFrame) -> pd.DataFrame:
    # 方法：Group by 并聚合
    # 让我们利用 .groupby() 方法，使用 'data_id' 和 'make_name'
    # 作为分组标准并且使用 'nunique' 方法聚合 'lead_id' 和 'partner_id'
    # 这会返回一组中不同的元素
    df = daily_sales.groupby(['date_id', 'make_name']).agg({
        'lead_id': 'nunique',
        'partner_id': 'nunique'
    }).reset_index()
    
    # 重命名结果 DataFrame 并且 重命名列
    df = df.rename(columns={
        'lead_id': 'unique_leads',
        'partner_id': 'unique_partners'
    })

    # 返回 DataFrame
    return df
```

<br>

#### MySQL

在SQL中，我们将使用带有 **date_id** 和 **make_name** 的 `GROUP BY` 聚合子句将每个相似的 date_id 和 make_name 行组合在一起。为了计算唯一的 **lead_id** 和 **Partner_id**，我们使用 `COUNT(DISTINCT {column_name})` 来统计指定的每一列中唯一出现的次数。在本例中，传入的列名为 **lead_id** 和 **partner_id**。

下面是完整的代码：

```Sql
SELECT
    date_id,
    make_name,
    COUNT(DISTINCT lead_id) AS unique_leads,
    COUNT(DISTINCT partner_id) AS unique_partners
FROM
    DailySales
GROUP BY date_id, make_name;
```
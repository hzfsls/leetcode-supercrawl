[TOC]

## 解决方案

---

#### 方法：行过滤

**思路**

| name        | continent | area    | population | gdp          |
| ----------- | --------- | ------- | ---------- | ------------ |
| Afghanistan | Asia      | 652230  | 25500100   | 20343000000  |
| Albania     | Europe    | 28748   | 2831741    | 12960000000  |
| Algeria     | Africa    | 2381741 | 37100000   | 188681000000 |
| Andorra     | Europe    | 468     | 78115      | 3712000000   |
| Angola      | Africa    | 1246700 | 20609294   | 100990000000 |

<br>
要确定一个国家是否被认为是“大国”，有两个条件需要验证，如描述中所述：

- 该国家的面积至少为 300 万平方千米，表示为 `area >= 3,000,000`。

- 该国家的人口至少为 2500 万，表示为 `population >= 25,000,000`。

**实现**

首先，我们应用行过滤来识别满足条件的国家。

**MySQL**

```sql
SELECT 
    * 
FROM 
    world 
WHERE 
    area >= 3000000 
    OR population >= 25000000
```

**Pandas**

```Python
df = World[(World['area'] >= 3000000) | (World['population'] >= 25000000)]
```

此步骤会过滤掉不满足条件的国家行，保留剩下的表格如下。

| name        | continent | area    | population | gdp          |
| ----------- | --------- | ------- | ---------- | ------------ |
| Afghanistan | Asia      | 652230  | 25500100   | 20343000000  |
| Algeria     | Africa    | 2381741 | 37100000   | 188681000000 |



<br>

注意表格有五列，我们需要根据问题的要求返回三列，相对顺序为：`name`、`population` 和 `area`。

**MySQL**

```sql
SELECT 
    name, population, area 
FROM 
    world 
WHERE 
    area >= 3000000 
    OR population >= 25000000
```

**Pandas**

```Python
df = df[['name', 'population', 'area']]
```

| name        | population | area    |
| ----------- | ---------- | ------- |
| Afghanistan | 25500100   | 652230  |
| Algeria     | 37100000   | 2381741 |


<br>

综上所述，完整的答案如下。

**MySQL**

```sql
SELECT
    name, population, area
FROM
    world
WHERE
    area >= 3000000 OR population >= 25000000
;
```


**Pandas**

```Python
import pandas as pd

def big_countries(World: pd.DataFrame) -> pd.DataFrame:
    df = World[(World['area'] >= 3000000) | (World['population'] >= 25000000)]
    return df[['name', 'population', 'area']]
```
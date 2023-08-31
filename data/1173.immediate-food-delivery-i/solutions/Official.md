## [1173.即时食物配送 I 中文官方题解](https://leetcode.cn/problems/immediate-food-delivery-i/solutions/100000/ji-shi-shi-wu-pei-song-i-by-leetcode-solution)

[TOC]

## 解决方案

--- 

### 方法：根据条件选择行

#### 思路

计算即时交货百分比的公式如下：

$\text{percentage} = \frac{\text{validCount}}{\text{totalCount}} \cdot 100$

#### Pandas

我们有下面的原始 DataFrame `delivery`：

| delivery_id | customer_id | order_date | customer_pref_delivery_date |
|-------------|-------------|------------|-----------------------------|
| 1           | 1           | 2019-08-01 | 2019-08-02                  |
| 2           | 5           | 2019-08-02 | 2019-08-02                  |
| 3           | 1           | 2019-08-11 | 2019-08-11                  |
| 4           | 3           | 2019-08-24 | 2019-08-26                  |
| 5           | 4           | 2019-08-21 | 2019-08-22                  |
| 6           | 2           | 2019-08-11 | 2019-08-13                  |

<br>

首先，我们找出判断订单是否为即时订单的条件，即当 `order_date` 等于 `customer_pref_delivery_date` 时。因此，第一步是识别并计算满足以下条件的行数：

```
delivery['order_date'] = delivery['customer_pref_delivery_date']
```

当我们使用上面的表达式比较 Pandas 中的两列时，Pandas 会在这两列之间执行逐个元素的比较。此比较的结果是一个 Series，其中每个元素要么是 `True`，要么是 `False`，这取决于两列中相应的元素是否相等：

```Python
is_valid = (delivery['order_date'] == delivery['customer_pref_delivery_date'])
```

我们将会获得结果 Series `is_valid`：

```
0    False
1     True
2     True
3    False
4    False
5    False
dtype: bool
```

要计算这个序列中 `True` 的个数，我们可以使用 `sum()` 方法，同时使用 bool 索引。在 Pandas 中，`True` 被视为 1，`False` 被视为 0，因此对此数列求和可以有效地计算 `True` 值的数量。

```Python
valid_count = is_valid.sum()

# valid_count = 2
```

<br>

订单总数等于 DataFrame `delivery` 中的行数，可以通过 `len()` 方法直接获取：

```Python
total_count = len(delivery)

# total_count = 6
```

<br>

根据问题的要求，我们需要将结果四舍五入到小数点后两位，所以我们使用内置函数 `round()`，该函数可以将一个数值四舍五入到指定的小数位数：

```Python
# 将百分比舍入到两位小数
percentage = round(100 * valid_count / total_count, 2)

# percentage = 33.33
```

<br>

最终，我们生成了一个包含舍入值的 DataFrame `df`。

```Python
df = pd.DataFrame({'immediate_percentage': [percentage]})
```

结果 DataFrame `df` 看起来是这样：

| immediate_percentage |
|------------|
| 33.33       |

<br>

下面是完整代码：

```Python
import pandas as pd

def food_delivery(delivery: pd.DataFrame) -> pd.DataFrame:
    is_valid = delivery['order_date'] == delivery['customer_pref_delivery_date']
    
    # 计算有效（立即）订单数量和所有订单数量。
    valid_count = is_valid.sum()
    total_count = len(delivery)

    # 将百分比舍入到两位小数。
    percentage = round(100 * valid_count / total_count, 2)

    df = pd.DataFrame({'immediate_percentage': [percentage]})
    return df
```

<br>

#### MySQL

关于百分比公式，我们首先需要推导出即时订单占总订单的比例，计算公式如下：

```MySQL
AVG(order_date = customer_pref_delivery_date)
```

关键字 `AVG` 用于计算数值列或计算结果为数值的表达式的平均值。它接受单个参数，该参数可以是列名、数学表达式或两者的组合。在我们的例子中，`AVG()` 接受一个逻辑表达式 `order_date = customer_pref_delivery_date`，该表达式将 `order_date` 与 `customer_pref_delivery_date` 进行比较，如果它们相等，则返回 1（`True`），否则返回 0（`False`）。然后 `AVG()` 计算这些 1 和 0 的平均值，这就给出了 `order_date` 等于 `customer_pref_delivery_date` 的行数的小数百分比。

<br>

根据开头的公式，我们需要将小数点后的平均值乘以 100，转换为百分比值，然后四舍五入到小数点后 2 位，可以这样实现：

```MySQL
ROUND(
    100 * AVG(order_date = customer_pref_delivery_date),
    2)
```

`ROUND()` 是将数字四舍五入到指定的小数位数的函数。它的语法为 `ROUND(number，k)`，将`number` 舍入到 `k`位小数。在这个问题中，我们使用它将平均值四舍五入到小数点后两位。

接下来，使用关键字 `AS` 对四舍五入的值进行重命名，并将其命名为`immediate_percentage`。

```MySQL
SELECT ROUND(
    100 * AVG(order_date = customer_pref_delivery_date), 
    2) AS immediate_percentage
FROM 
    Delivery;
```
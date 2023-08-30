#### 方法一：`JOIN`

**思路**

本题需要计算每个产品的平均售价，**平均售价 = 销售总额 / 总数量**，因此我们只需要计算除每个产品的销售总额和总数量即可。

总数量可以直接使用 `UnitsSold` 计算得出，使用 `GROUP BY` 和 `SUM` 函数即可：

```mysql
SELECT product_id, SUM(units) FROM UnitsSold GROUP BY product_id
```

因为每个产品不同时期的售价不同，因此在计算销售总额之前要先分别计算每个价格的销售总额。每个价格的销售总额为 $对应时间内的价格 * 对应时间内的数量$。因为价格和时间在 `Prices` 表中，数量在 `UnitsSold` 表中，这两个表通过 `product_id` 关联，那么我们就可以使用 `JOIN` 将两个表连接，通过 `WHERE` 查询对应时间内每个产品的价格和数量，并计算出对应的销售总额。

```mysql
SELECT
    Prices.product_id AS product_id,
    Prices.price * UnitsSold.units AS sales,
    UnitsSold.units AS units
FROM Prices 
JOIN UnitsSold ON Prices.product_id = UnitsSold.product_id
WHERE UnitsSold.purchase_date BETWEEN Prices.start_date AND Prices.end_date
```

计算出产品每个价格的销售总额后，同样的使用 `SUM` 函数计算出产品所有时间的销售总额，然后除以总数量并使用 `ROUND` 函数保留两位小数即可。

**代码**

```mysql [sol1-MySQL]
SELECT
    product_id,
    Round(SUM(sales) / SUM(units), 2) AS average_price
FROM (
    SELECT
        Prices.product_id AS product_id,
        Prices.price * UnitsSold.units AS sales,
        UnitsSold.units AS units
    FROM Prices 
    JOIN UnitsSold ON Prices.product_id = UnitsSold.product_id
    WHERE UnitsSold.purchase_date BETWEEN Prices.start_date AND Prices.end_date
) T
GROUP BY product_id
```
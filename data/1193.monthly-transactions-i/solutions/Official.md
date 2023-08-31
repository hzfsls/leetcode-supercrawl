## [1193.每月交易 I 中文官方题解](https://leetcode.cn/problems/monthly-transactions-i/solutions/100000/mei-yue-jiao-yi-i-by-leetcode-solution)

#### 预备知识

本题使用到的 `MySQL` 函数的说明：

- `DATE_FORMAT(date, format)` ：用于以不同的格式显示日期/时间数据。`date` 参数是合法的日期，`format` 规定日期/时间的输出格式。


#### 方法一：`DATE_FORMAT()` 函数、`GROUP BY`

**思路**

本题要求 **查找每个月和每个国家/地区的事务数及其总金额、已批准的事务数及其总金额**，我们可以将这句话拆分成几个子任务：
1. 查找每个月和每个国家/地区。
    数据表中的 `trans_date` 是精确到日，我们可以使用 `DATE_FORMAT()` 函数将日期按照年月 `%Y-%m` 输出。比如将 `2019-01-02` 转换成 `2019-01` 。
    ```Mysql
    DATE_FORMAT(trans_date, '%Y-%m')
    ```
    获取到所有的月份后，使用 `GROUP BY` 聚合每个月和每个国家的记录就完成了第一步。

2. 查找总的事务数。
    第一步已经将数据按月和国家聚合，只需要使用 `COUNT` 函数就能获取到总的事务数。
    ```Mysql
    COUNT(*) AS trans_count
    ```

3. 查找总金额。
    使用 `SUM` 函数计算总金额。
    ```Mysql
    SUM(amount) AS trans_total_amount
    ```

4. 查找已批准的事物数。
    已批准的事物的 `state` 标记为 `approved`。首先使用 `IF` 函数将 `state = 'approved'` 的记录标记为 1，否则为 `NULL`。再使用 `COUNT` 计算总量。
    ```Mysql
    COUNT(IF(state = 'approved', 1, NULL)) AS approved_count
    ```

5. 查找已批准的事物的总金额。
    和第四步一样，先使用 `IF` 函数，再使用 `SUM` 函数。
    ```Mysql
    SUM(IF(state = 'approved', amount, 0)) AS approved_total_amount
    ```

**代码**

```Mysql [ ]
SELECT DATE_FORMAT(trans_date, '%Y-%m') AS month,
    country,
    COUNT(*) AS trans_count,
    COUNT(IF(state = 'approved', 1, NULL)) AS approved_count,
    SUM(amount) AS trans_total_amount,
    SUM(IF(state = 'approved', amount, 0)) AS approved_total_amount
FROM Transactions
GROUP BY month, country
```
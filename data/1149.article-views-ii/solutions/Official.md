#### 方法一：`GROUP BY` 和 `DISTINCT`

**算法**

根据题目一步一步的拆分成子任务：
1. 首先题目要求是**同一天**，所以需要根据时间聚合记录，使用 `GROUP BY` 聚合。
```
GROUP BY view_date
```
2. 其次是**至少阅读两篇文章的人**。通过这句话我们可以知道还需要根据人来聚合，计算每个人阅读的文章数。在 `GROUP BY` 的基础上使用 `HAVING` 过滤条件。因为表中可能有重复的数据，所以还要对 `article_id` 做去重处理。
```
GROUP BY viewer_id
HAVING COUNT(DISTINCT article_id) >= 2
```
3. 然后将**结果按照 `id` 升序排序**，这个只需要使用 `ORDER BY` 对结果进行排序。
4. 最后将上面三步联合起来就是我们需要的数据。但是结果依然有可能重复，所以需要再对结果去重。


**代码**

```Mysql [ ]
SELECT DISTINCT viewer_id AS id
FROM Views
GROUP BY view_date, viewer_id
HAVING COUNT(DISTINCT article_id) >= 2
ORDER BY viewer_id
```
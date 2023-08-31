## [1148.文章浏览 I 中文官方题解](https://leetcode.cn/problems/article-views-i/solutions/100000/wen-zhang-liu-lan-i-by-leetcode-solution)
[TOC]



## 解决方案

---

### 方法：根据条件选择行

#### Pandas

我们有以下原始DataFrame `views`：

| article_id | author_id | viewer_id | view_date  |
| ---------- | --------- | --------- | ---------- |
| 1          | 3         | 5         | 2019-08-01 |
| 1          | 3         | 6         | 2019-08-02 |
| 2          | 7         | 7         | 2019-08-01 |
| 2          | 7         | 6         | 2019-08-02 |
| 4          | 7         | 1         | 2019-07-22 |
| 3          | 4         | 4         | 2019-07-21 |
| 3          | 4         | 4         | 2019-07-21 |

首先，让我们找到判断作者是否评论了自己文章的条件，即 `author_id` 等于 `viewer_id`。因此，第一步是根据此条件过滤所有 `views` 行，并确定满足条件的行。

```Python
views['author_id'] = views['viewer_id']
```

在 Pandas 中，布尔索引允许我们通过使用布尔数组或条件来过滤 DataFrame。这意味着我们可以使用布尔值的 Series 或创建对于 DataFrame 中每一行都评估为 `True` 或 `False` 的条件。通过将这些布尔值或条件应用为 DataFrame 的索引，我们可以选择性地提取满足条件的行。

在这种情况下，我们应该选择仅当 `author_id` 列的值等于 `viewer_id` 列的值的行，可以表示为：

```Python
# 仅选择 views['author_id'] == views['viewer_id'] 为 True 的行。
df = views[views['author_id'] == views['viewer_id']]
```

此过滤操作创建了一个新的 DataFrame `df`，其中包含满足上述条件的行。我们可以看到每一行的 `author_id` 等于 `viewer_id`，而不满足此条件的行被过滤掉了。

| article_id | author_id | viewer_id | view_date  |
| ---------- | --------- | --------- | ---------- |
| 2          | 7         | 7         | 2019-08-01 |
| 5          | 3         | 4         | 2019-07-21 |
| 6          | 3         | 4         | 2019-07-21 |


<br>

在应用自定义条件来过滤有效行之后，可能会在 `author_id` 列（例如，`author_id = 4` 的作者查看了他的文章多次）中遇到重复的作者。为了解决这个问题，我们需要通过应用 `drop_duplicates()` 方法选择不重复的 `author_ids`，即移除任何重复项。在这种情况下，`drop_duplicates()` 方法的参数设置如下：

```Python
df.drop_duplicates(subset=['author_id'], inplace=False)
```

- `subset`：它指定应该考虑哪些列来查找重复项。如果未指定，将使用 DataFrame 中的所有列来识别重复项。在我们的情况下，我们将其设置为 `['author_id']` ，因此仅考虑`author_id`列中的重复项。
- `inplace`：这是一个布尔参数，用于确定方法是否应该对原始 DataFrame 进行就地修改，还是返回一个删除了重复项的新 DataFrame。我们将其设置为 `True`，表示原地修改。

因此，此函数通过仅保留基于 `author_id` 列的唯一行来修改 `df` 。现在，我们已经选择了所有唯一的 `author_ids`，下一步是获取符合指定格式的答案。我们需要将 `author_id` 列重命名为`id`并按升序排序。

```Python
# 仅保留包含唯一的 'author_id' 的行。
df.drop_duplicates(subset=['author_id'], inplace=True)

# 按 'author_id' 列升序排序 DataFrame。
df.sort_values(by=['author_id'], inplace=True)

# 将 'author_id' 列重命名为 'id'。
df.rename(columns={'author_id':'id'}, inplace=True)
```

得到的 DataFrame 如下所示：

| article_id | id   | viewer_id | view_date  |
| ---------- | ---- | --------- | ---------- |
| 3          | 4    | 4         | 2019-07-21 |
| 2          | 7    | 7         | 2019-08-01 |



<br>


最后，我们通过仅选择所需的列 `id` 来返回 DataFrame 。完整的代码如下所示：

```Python
import pandas as pd

def article_views(views: pd.DataFrame) -> pd.DataFrame:
    df = views[views['author_id'] == views['viewer_id']]

    df.drop_duplicates(subset=['author_id'], inplace=True)
    df.sort_values(by=['author_id'], inplace=True)
    df.rename(columns={'author_id':'id'}, inplace=True)

    df = df[['id']]

    return df
```

| id   |
| ---- |
| 4    |
| 7    |




#### MySQL

在 SQL 中，我们可以在 SELECT 语句中使用 DISTINCT 关键字来从表 Views 中检索唯一元素。我们还使用 WHERE 子句应用条件。此条件过滤掉仅包含 `author_id` 等于 `viewer_id` 的行。

```sql
SELECT 
    DISTINCT author_id 
FROM 
    Views 
WHERE 
    author_id = viewer_id 
```

我们将通过给 `author_id` 列取别名 `id` 来重命名该列。

```sql
SELECT 
    DISTINCT author_id AS id 
FROM 
    Views 
WHERE 
    author_id = viewer_id  
```

注意，我们还应该根据 `id` 列按升序对结果表进行排序，这可以通过使用 ORDER BY 关键字实现。完整的代码如下所示：

```sql
SELECT 
    DISTINCT author_id AS id 
FROM 
    Views 
WHERE 
    author_id = viewer_id 
ORDER BY 
    id 
```
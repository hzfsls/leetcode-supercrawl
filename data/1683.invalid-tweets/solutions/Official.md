## [1683.无效的推文 中文官方题解](https://leetcode.cn/problems/invalid-tweets/solutions/100000/wu-xiao-de-tui-wen-by-leetcode-solution-5tfp)

[TOC]

## 解决方案

---

### 方法：条件过滤行

| tweet_id | content                          |
| -------- | -------------------------------- |
| 1        | Vote for Biden                   |
| 2        | Let us make America great again! |



这个问题要求确定推文的长度是否大于 15，涉及计算字符串的长度。

**Pandas**

对于 DataFrame，我们可以使用 [str.len()](https://pandas.pydata.org/docs/reference/api/pandas.Series.str.len.html) 系列方法来计算列中字符串的长度。该方法应用于DataFrame的目标列，以检索该列中每个字符串元素的长度。

我们在 `content` 列上应用 `str.len()` 方法。结果 `is_valid` 是一个布尔Series，其中表示每个推文是否有效（长度大于 15）。

```Python
is_valid = tweets['content'].str.len() > 15
```


```
0    False
1     True
Name: content, dtype: bool
```

<br>

接下来，我们使用 `tweets[is_valid]` 来使用 `is_valid` 作为过滤器选择 `tweets` 中的行。

```Python
df = tweets[is_valid]
```

因此，我们可以得到以下DataFrame `df`：

| tweet_id | content                          |
| -------- | -------------------------------- |
| 2        | Let us make America great again! |


<br>

注意，我们需要返回所需的列。完整的代码如下：

```Python
import pandas as pd

def invalid_tweets(tweets: pd.DataFrame) -> pd.DataFrame:
    is_valid = tweets['content'].str.len() > 15
    df = tweets[is_valid]
    return df[['tweet_id']]
```




<br>

**MySQL**

对于SQL表，用于计算字符串中字符数的最佳函数是 [CHAR_LENGTH(str)](https://dev.mysql.com/doc/refman/5.7/en/string-functions.html#function_char-length)，它返回字符串 `str` 的长度。

另一个常用的函数 [LENGTH(str)](https://dev.mysql.com/doc/refman/5.7/en/string-functions.html#function_length) 在这个问题中也适用，因为列 `content` 只包含英文字符，没有特殊字符。否则，`LENGTH()` 可能会返回不同的结果，因为该函数返回字符串 `str` 的**字节数**，某些字符包含多于 1 个字节。

以字符 `'¥'` 为例：`CHAR_LENGTH()` 返回结果为 1，而 `LENGTH()` 返回结果为 2，因为该字符串包含 2 个字节。

| LENGTH('¥') | CHAR_LENGTH('¥') |
| ----------- | ---------------- |
| 2           | 1                |


<br>

**MySQL**

```Sql
SELECT 
    tweet_id
FROM 
    tweets
WHERE 
    CHAR_LENGTH(content) > 15
```
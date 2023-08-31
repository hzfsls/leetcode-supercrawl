## [1527.患某种疾病的患者 中文官方题解](https://leetcode.cn/problems/patients-with-a-condition/solutions/100000/huan-mou-chong-ji-bing-de-huan-zhe-by-le-7i52)
[TOC]

## 解决方案

---

### 概述

我们需要识别有特殊医疗条件，即 I 型糖尿病的病人。条件代码保存在一个用空格隔开的字符串中。如果一个条件代码以 `"DIAB1"` 开头，那么它表示 I 型糖尿病。

---

### 方法 1：使用正则表达式单词边界

#### 思路

如果你不熟悉正则表达式，请先查看题目 [1517 查询拥有有效邮箱的用户](https://leetcode.cn/problems/find-users-with-valid-e-mails/)

1. `SUBSTRING(column_name, start, length)`：从列的值中提取一个子串，从指定的起始位置开始，直到指定的长度。

2. `UPPER(expression)`：将字符串表达式转换为大写。

3. `LOWER(expression)`：将字符串表达式转换为小写。

4. `CONCAT(string1, string2, ...)`：将两个或多个字符串连接成一个。

核心思想是把 name 列的第一个字符从其余字符中分开，相应地改变它们的的大小写，然后把它们拼接回去。

#### 算法

1. 提取 name 列的第一个字符并将其转换为大写。
2. 提取 name 列的其余部分（从第二个字符到最后）并且把它转换为小写。
3. 拼接第一个字符的大写和其余部分的小写。
4. 根据 user_id 对结果进行排序

#### 实现

##### MySQL

```Sql
SELECT patient_id, patient_name, conditions
FROM Patients
WHERE conditions REGEXP '\\bDIAB1.*';
```

##### Pandas

```Python
import pandas as pd

def find_patients(patients: pd.DataFrame) -> pd.DataFrame:
    return patients[patients["conditions"].str.contains(r"\bDIAB1", regex=True)]
```

---

### 方法 2：不使用正则表达式

#### 思路

如果你不熟悉正则表达式，不用担心，依然可以解决这个问题！我们可以通过将问题分解为我们需要考虑的情况来做到这一点。

#### 算法

这个问题可以归结于两种情况：

1. 条件代码以 `"DIAB1"` 开头。

    **结果表格：**

    ```
    +------------+--------------+--------------+
    | patient_id | patient_name | conditions   |
    +------------+--------------+--------------+
    | 3          | Bob          | DIAB100 MYOP |
    +------------+--------------+--------------+
    ```

1. 条件代码包含 `" DIAB1"`，即有一个空格在前。

    **结果表格：**

    ```
    +------------+--------------+--------------+
    | patient_id | patient_name | conditions   |
    +------------+--------------+--------------+
    | 4          | George       | ACNE DIAB100 | 
    +------------+--------------+--------------+
    ```

这是条件代码可以表示 I 型糖尿病的唯一方法。因此，我们可以简单地分析这两种情况。

#### 实现

##### MySQL

```Sql
SELECT patient_id, patient_name, conditions
FROM Patients
WHERE conditions LIKE 'DIAB1%' OR conditions LIKE '% DIAB1%';
```

##### Pandas

```Python3
import pandas as pd

def find_patients(patients: pd.DataFrame) -> pd.DataFrame:
    return patients[patients["conditions"].str.startswith("DIAB1") | patients["conditions"].str.contains(" DIAB1", regex=False)]
```

**结果表格:**

```
+------------+--------------+--------------+
| patient_id | patient_name | conditions   |
+------------+--------------+--------------+
| 3          | Bob          | DIAB100 MYOP |
| 4          | George       | ACNE DIAB100 | 
+------------+--------------+--------------+
```

---
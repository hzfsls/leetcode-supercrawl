## [2133.检查是否每一行每一列都包含全部整数 中文官方题解](https://leetcode.cn/problems/check-if-every-row-and-column-contains-all-numbers/solutions/100000/jian-cha-shi-fou-mei-yi-xing-mei-yi-lie-uwrwu)
#### 方法一：哈希表

**思路与算法**

由于矩阵元素仅由从 $1$ 到 $n$ 的整数构成，因此，「某一行/列包含从 $1$ 到 $n$ 的所有整数」等价于「某一行/列的数值**互不重复**」。

因此，在遍历每一行/列的过程中，我们可以用一个哈希集合 $\textit{occur}$ 维护该行/列出现过的整数。如果遍历到某一个在 $\textit{occur}$ 中存在的整数，则说明该行/列没有包含从 $1$ 到 $n$ 的所有整数，此时我们返回 $\texttt{false}$。

当遍历完成全部行与列后，每一行/列都包含从 $1$ 到 $n$ 的所有整数，则说明该矩阵为有效矩阵，此时我们返回 $\texttt{true}$。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    bool checkValid(vector<vector<int>>& matrix) {
        int n = matrix.size();
        unordered_set<int> occur;   // 每一行/列出现过的整数
        // 判断每一行是否符合要求
        for (int i = 0; i < n; ++i) {
            occur.clear();   // 确保统计前哈希表为空
            for (int j = 0; j < n; ++j) {
                if (occur.count(matrix[i][j])) {
                    // 出现重复整数，该行不符合要求
                    return false;
                }
                occur.insert(matrix[i][j]);
            }
        }
        // 判断每一列是否符合要求
        for (int i = 0; i < n; ++i) {
            occur.clear();   // 确保统计前哈希表为空
            for (int j = 0; j < n; ++j) {
                if (occur.count(matrix[j][i])) {
                    // 出现重复整数，该列不符合要求
                    return false;
                }
                occur.insert(matrix[j][i]);
            }
        }
        return true;
    }
};
```


```Python [sol1-Python3]
class Solution:
    def checkValid(self, matrix: List[List[int]]) -> bool:
        n = len(matrix)
        occur = set()   # 每一行/列出现过的整数
        # 判断每一行是否符合要求
        for i in range(n):
            occur.clear()   # 确保统计前哈希表为空
            for j in range(n):
                if matrix[i][j] in occur:
                    # 出现重复整数，该行不符合要求
                    return False
                occur.add(matrix[i][j])
        # 判断每一列是否符合要求
        for i in range(n):
            occur.clear()   # 确保统计前哈希表为空
            for j in range(n):
                if matrix[j][i] in occur:
                    # 出现重复整数，该列不符合要求
                    return False
                occur.add(matrix[j][i])
        return True
```


**复杂度分析**

- 时间复杂度：$O(n^2)$，其中 $n$ 为矩阵 $\textit{matrix}$ 的长或宽。判断每一行或列是否符合要求的时间复杂度为 $O(n)$，我们共需判断 $O(n)$ 次。

- 空间复杂度：$O(n)$，即为哈希表的空间开销。
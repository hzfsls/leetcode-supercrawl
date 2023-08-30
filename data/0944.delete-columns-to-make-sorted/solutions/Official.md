#### 方法一：直接遍历

**思路与算法**

题目要求删除不是按字典序升序排列的列，由于每个字符串的长度都相等，我们可以逐列访问字符串数组，统计不是按字典序升序排列的列。

对于第 $j$ 列的字符串，我们需要检测所有相邻字符是否均满足 $\textit{strs}[i-1][j] \le \textit{strs}[i][j]$。

**代码**

```Python [sol1-Python3]
class Solution:
    def minDeletionSize(self, strs: List[str]) -> int:
        return sum(any(x > y for x, y in pairwise(col)) for col in zip(*strs))  # 空间复杂度为 O(m)，改用下标枚举可以达到 O(1)
```

```Java [sol1-Java]
class Solution {
    public int minDeletionSize(String[] strs) {
        int row = strs.length;
        int col = strs[0].length();
        int ans = 0;
        for (int j = 0; j < col; ++j) {
            for (int i = 1; i < row; ++i) {
                if (strs[i - 1].charAt(j) > strs[i].charAt(j)) {
                    ans++;
                    break;
                }
            }
        }
        return ans;
    }
}
```

```C++ [sol1-C++]
class Solution {
public:
    int minDeletionSize(vector<string>& strs) {
        int row = strs.size();
        int col = strs[0].size();
        int ans = 0;
        for (int j = 0; j < col; ++j) {
            for (int i = 1; i < row; ++i) {
                if (strs[i - 1][j] > strs[i][j]) {
                    ans++;
                    break;
                }
            }
        }
        return ans;
    }
};
```

```C# [sol1-C#]
public class Solution {
    public int MinDeletionSize(string[] strs) {
        int row = strs.Length;
        int col = strs[0].Length;
        int ans = 0;
        for (int j = 0; j < col; ++j) {
            for (int i = 1; i < row; ++i) {
                if (strs[i - 1][j] > strs[i][j]) {
                    ans++;
                    break;
                }
            }
        }
        return ans;
    }
}
```

```C [sol1-C]
int minDeletionSize(char ** strs, int strsSize) {
    int row = strsSize;
    int col = strlen(strs[0]);
    int ans = 0;
    for (int j = 0; j < col; ++j) {
        for (int i = 1; i < row; ++i) {
            if (strs[i - 1][j] > strs[i][j]) {
                ans++;
                break;
            }
        }
    }
    return ans;
}
```

```go [sol1-Golang]
func minDeletionSize(strs []string) (ans int) {
    for j := range strs[0] {
        for i := 1; i < len(strs); i++ {
            if strs[i-1][j] > strs[i][j] {
                ans++
                break
            }
        }
    }
    return
}
```

```JavaScript [sol1-JavaScript]
var minDeletionSize = function(strs) {
    const row = strs.length;
    const col = strs[0].length;
    let ans = 0;
    for (let j = 0; j < col; ++j) {
        for (let i = 1; i < row; ++i) {
            if (strs[i - 1][j] > strs[i][j]) {
                ans++;
                break;
            }
        }
    }
    return ans;
};
```

**复杂度分析**

- 时间复杂度：$O(m \times n)$，其中 $m$ 为字符串数组的长度，$n$ 为数组中每个字符串的长度，判定每一列的的字典序需要遍历字符串数组每一列，因此时间复杂度为 $O(m \times n)$。

- 空间复杂度：$O(1)$。
## [2232.向表达式添加括号后的最小结果 中文官方题解](https://leetcode.cn/problems/minimize-result-by-adding-parentheses-to-expression/solutions/100000/xiang-biao-da-shi-tian-jia-gua-hao-hou-d-5ox4)

#### 方法一：枚举

**思路与算法**

我们可以使用枚举的方法得到所有满足要求的表达式，计算每一个表达式的结果并选出最小值。

具体地，我们首先在给定的字符串 $\textit{expression}$ 中定位到加号的位置，记为 $\textit{mid}$。由于「左括号必须添加在加号的左侧，右括号必须添加在加号的右侧」，因此我们可以枚举两个位置 $i$ 和 $j$，将字符串分成五部分，即：

- $[0, i)$，对应的数值记为 $p$；
- $[i, \textit{mid})$，对应的数值记为 $q$；
- $\textit{mid}$ 位置上的加号；
- $(\textit{mid}, j]$，对应的数值记为 $r$；
- $(j, n)$，对应的数值记为 $s$，其中 $n$ 是字符串 $\textit{expression}$ 的长度；

那么表达式的值即为 $p \times (q+r) \times s$。特别地，如果 $i = 0$ 或者 $j = n-1$，那么 $[0, i)$ 或者 $(j, n)$ 是空串，我们可以特判其对应的数值为 $1$。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    string minimizeResult(string expression) {
        int n = expression.size();
        int mid = expression.find('+');
        int best = INT_MAX;
        string ans;

        for (int i = 0; i < mid; ++i) {
            for (int j = mid + 1; j < n; ++j) {
                int p = (i == 0 ? 1 : stoi(expression.substr(0, i)));
                int q = stoi(expression.substr(i, mid - i));
                int r = stoi(expression.substr(mid + 1, j - mid));
                int s = (j == n - 1 ? 1 : stoi(expression.substr(j + 1, n - j - 1)));
                int result = p * (q + r) * s;
                if (result <= best) {
                    best = result;
                    ans = expression.substr(0, i) + "(" + expression.substr(i, j - i + 1) + ")" + expression.substr(j + 1, n - j - 1);
                }
            }
        }

        return ans;
    }
};
```

```Python [sol1-Python3]
class Solution:
    def minimizeResult(self, expression: str) -> str:
        n = len(expression)
        mid = expression.index("+")
        best, ans = float("inf"), ""
        for i in range(mid):
            for j in range(mid + 1, n):
                result = int(expression[:i] or 1) * (int(expression[i:mid]) + int(expression[mid+1:j+1])) * int(expression[j+1:] or 1)
                if result < best:
                    best = result
                    ans = expression[:i] + "(" + expression[i:j+1] + ")" + expression[j+1:]
        return ans
```

**复杂度分析**

- 时间复杂度：$O(n^3)$，其中 $n$ 是字符串 $\textit{expression}$ 的长度。枚举 $i$ 和 $j$ 的时间复杂度为 $O(n^2)$，我们还需要 $O(n)$ 的时间遍历整个字符串并计算表达式的值。

- 空间复杂度：$O(n)$，即为计算表达式的值时，存储 $\textit{expression}$ 的子串需要的空间。
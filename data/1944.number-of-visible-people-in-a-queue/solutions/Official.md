#### 方法一：逆序遍历 + 单调栈

**提示 $1$**

$i$ 能够看到 $j$ 的条件即为 $i$ 和 $j$ 都高于 $i+1, i+2, \cdots, j-1$。

**提示 $2$**

假设 $j_1$ 在 $j_2$ 的左侧，并且前者不比后者矮，即 $j_1 < j_2$ 且 $\textit{heights}[j_1] > \textit{heights}[j_2]$，那么对于所有的在 $j_1$ 左侧的 $i$（即 $i < j_1$），他们一定都无法看到 $j_2$。

**提示 $2$ 解释**

因为 $j_2$ 不高于 $j_1$，所以 $i$ 无法看到 $j_2$。

**提示 $3$**

对于任意的 $i$，他能够看到的所有人，按照位置顺序的高度是单调递增的。即如果 $i$ 能够看到 $j_1, j_2, \cdots, j_x$ 并且 $j_1 < j_2 < \cdots < j_x$，那么一定有：

$$
\textit{heights}[j_1] < \textit{heights}[j_2] < \cdots < \textit{heights}[j_x]
$$

**提示 $3$ 解释**

使用反证法。如果存在 $k$ 使得 $\textit{heights}[j_k] > \textit{heights}[j_{k+1}]$，那么根据提示 $2$，$i$ 无法看到 $j_{k+1}$，此时就产生了矛盾。

**思路与算法**

根据提示 $2$ 和 $3$，我们可以使用一个单调递减的栈，从栈底到栈顶逆序地存储当前**可能**可以被看见的人的下标。同时，这些下标的 $\textit{heights}$ 值也是单调递减的。

我们逆序遍历这 $n$ 个人的下标，如果当前遍历到了第 $i$ 个人，那么我们需要在栈中选出第 $i$ 个人可以看到的那些人。设栈顶的下标为 $j$，则：

- 如果栈为空，说明第 $i$ 个人是遍历到的所有人中最高的那个人，我们退出比较环节；
    
- 如果 $\textit{height}[i] > \textit{height}[j]$，说明 $i$ 能够看到 $j$，并且根据提示 $2$，$i$ 左侧的所有人都无法看到 $j$，因此我们将 $j$ 出栈，并继续将 $i$ 与新的栈顶元素进行比较；

- 如果 $\textit{height}[i] < \textit{height}[j]$，说明 $i$ 能够看到 $j$，但是根据提示 $2$，$i$ 无法看到 $j$ 右侧的所有人，因此我们退出比较环节。

在比较结束后，栈要么为空，要么其栈顶下标 $j$ 满足 $\textit{height}[i] < \textit{height}[j]$。我们将 $i$ 入栈，就可以保持其单调性。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    vector<int> canSeePersonsCount(vector<int>& heights) {
        int n = heights.size();
        vector<int> ans(n);
        stack<int> s;
        for (int i = n - 1; i >= 0; --i) {
            while (!s.empty()) {
                ++ans[i];
                if (heights[i] > heights[s.top()]) {
                    s.pop();
                }
                else {
                    break;
                }
            }
            s.push(i);
        }
        return ans;
    }
};
```

```Python [sol1-Python3]
class Solution:
    def canSeePersonsCount(self, heights: List[int]) -> List[int]:
        n = len(heights)
        ans = [0] * n
        s = list()

        for i in range(n - 1, -1, -1):
            while s:
                ans[i] += 1
                if heights[i] > heights[s[-1]]:
                    s.pop()
                else:
                    break
            s.append(i)
        
        return ans
```

**复杂度分析**

- 时间复杂度：$O(n)$。每个下标会恰好入栈一次，并且最多出栈一次。

- 空间复杂度：$O(n)$，即为单调栈需要使用的空间。
## [667.优美的排列 II 中文官方题解](https://leetcode.cn/problems/beautiful-arrangement-ii/solutions/100000/you-mei-de-pai-lie-ii-by-leetcode-soluti-qkrs)
#### 方法一：从特殊情况到一般情况

**思路与算法**

当 $k=1$ 时，我们将 $1 \sim n$ 按照 $[1, 2, \cdots, n]$ 的顺序进行排列，那么相邻的差均为 $1$，满足 $k=1$ 的要求。

当 $k=n-1$ 时，我们将 $1 \sim n$ 按照 $[1, n, 2, n-1, 3, \cdots]$ 的顺序进行排列，那么相邻的差从 $n-1$ 开始，依次递减 $1$。这样一来，所有从 $1$ 到 $n-1$ 的差值均出现一次，满足 $k=n-1$ 的要求。

对于其它的一般情况，我们可以将这两种特殊情况进行合并，即列表的前半部分相邻差均为 $1$，后半部分相邻差从 $k$ 开始逐渐递减到 $1$，这样从 $1$ 到 $k$ 的差值均出现一次，对应的列表即为：

$$
[1, 2, \cdots, n-k, n, n-k+1, n-1, n-k+2, \cdots]
$$

**代码**

```C++ [sol1-C++]
class Solution {
public:
    vector<int> constructArray(int n, int k) {
        vector<int> answer;
        for (int i = 1; i < n - k; ++i) {
            answer.push_back(i);
        }
        for (int i = n - k, j = n; i <= j; ++i, --j) {
            answer.push_back(i);
            if (i != j) {
                answer.push_back(j);
            }
        }
        return answer;
    }
};
```

```Java [sol1-Java]
class Solution {
    public int[] constructArray(int n, int k) {
        int[] answer = new int[n];
        int idx = 0;
        for (int i = 1; i < n - k; ++i) {
            answer[idx] = i;
            ++idx;
        }
        for (int i = n - k, j = n; i <= j; ++i, --j) {
            answer[idx] = i;
            ++idx;
            if (i != j) {
                answer[idx] = j;
                ++idx;
            }
        }
        return answer;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int[] ConstructArray(int n, int k) {
        int[] answer = new int[n];
        int idx = 0;
        for (int i = 1; i < n - k; ++i) {
            answer[idx] = i;
            ++idx;
        }
        for (int i = n - k, j = n; i <= j; ++i, --j) {
            answer[idx] = i;
            ++idx;
            if (i != j) {
                answer[idx] = j;
                ++idx;
            }
        }
        return answer;
    }
}
```

```Python [sol1-Python3]
class Solution:
    def constructArray(self, n: int, k: int) -> List[int]:
        answer = list(range(1, n - k))
        i, j = n - k, n
        while i <= j:
            answer.append(i)
            if i != j:
                answer.append(j)
            i, j = i + 1, j - 1
        return answer
```

```C [sol1-C]
int* constructArray(int n, int k, int* returnSize){
    int *answer = (int *)malloc(sizeof(int) * n);
    int pos = 0;
    for (int i = 1; i < n - k; ++i) {
        answer[pos++] = i;
    }
    for (int i = n - k, j = n; i <= j; ++i, --j) {
        answer[pos++] = i;
        if (i != j) {
            answer[pos++] = j;
        }
    }
    *returnSize = n;
    return answer;
}
```

```JavaScript [sol1-JavaScript]
var constructArray = function(n, k) {
    const answer = new Array(n).fill(0);
    let idx = 0;
    for (let i = 1; i < n - k; ++i) {
        answer[idx] = i;
        ++idx;
    }
    for (let i = n - k, j = n; i <= j; ++i, --j) {
        answer[idx] = i;
        ++idx;
        if (i !== j) {
            answer[idx] = j;
            ++idx;
        }
    }
    return answer;
};
```

```go [sol1-Golang]
func constructArray(n, k int) []int {
    ans := make([]int, 0, n)
    for i := 1; i < n-k; i++ {
        ans = append(ans, i)
    }
    for i, j := n-k, n; i <= j; i++ {
        ans = append(ans, i)
        if i != j {
            ans = append(ans, j)
        }
        j--
    }
    return ans
}
```

**复杂度分析**

- 时间复杂度：$O(n)$。

- 空间复杂度：$O(1)$，这里不计入返回值需要的空间。
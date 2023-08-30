#### 方法一：构造

我们首先将最小的 `n - 1` 个自然数 `0, 1, 2, ..., n - 2` 放入数组中，它们的和为 `sum`。对于剩下的 `1` 个数，我们可以令其为 `-sum`，此时这 `n` 个数的和为 `0`，并且：

- 当 `n = 1` 时，我们构造的答案中只有唯一的 `1` 个数 `0`；

- 当 `n > 1` 时，我们构造的答案中包含 `n - 1` 个互不相同的自然数和 `1` 个负数；

因此这 `n` 个数互不相同，即我们得到了一个满足要求的数组。

```C++ [sol1-C++]
class Solution {
public:
    vector<int> sumZero(int n) {
        vector<int> ans;
        int sum = 0;
        for (int i = 0; i < n - 1; ++i) {
            ans.push_back(i);
            sum += i;
        }
        ans.push_back(-sum);
        return ans;
    }
};
```

```Python [sol1-Python3]
class Solution:
    def sumZero(self, n: int) -> List[int]:
        ans = [x for x in range(n - 1)]
        ans.append(-sum(ans))
        return ans
```

**复杂度分析**

- 时间复杂度：$O(N)$。

- 空间复杂度：$O(1)$，除了存储答案的数组 `ans` 之外，额外的空间复杂度是 $O(1)$。
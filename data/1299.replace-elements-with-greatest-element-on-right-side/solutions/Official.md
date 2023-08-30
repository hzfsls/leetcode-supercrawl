#### 方法一：逆序遍历

本题等价于对于数组 `arr` 中的每个元素 `arr[i]`，将其替换成 `arr[i + 1], arr[i + 2], ..., arr[n - 1]` 中的最大值。因此我们可以逆序地遍历整个数组，同时维护从数组右端到当前位置所有元素的最大值。

设 `ans[i] = max(arr[i + 1], arr[i + 2], ..., arr[n - 1])`，那么在进行逆序遍历时，我们可以直接通过

```
ans[i] = max(ans[i + 1], arr[i + 1])
```

来递推地得到答案。

```C++ [sol1-C++]
class Solution {
public:
    vector<int> replaceElements(vector<int>& arr) {
        int n = arr.size();
        vector<int> ans(n);
        ans[n - 1] = -1;
        for (int i = n - 2; i >= 0; --i) {
            ans[i] = max(ans[i + 1], arr[i + 1]);
        }
        return ans;
    }
};
```

```Python [sol1-Python3]
class Solution:
    def replaceElements(self, arr: List[int]) -> List[int]:
        n = len(arr)
        ans = [0] * (n - 1) + [-1]
        for i in range(n - 2, -1, -1):
            ans[i] = max(ans[i + 1], arr[i + 1])
        return ans
```

**复杂度分析**

- 时间复杂度：$O(N)$，其中 $N$ 是数组 `arr` 的长度。

- 空间复杂度：$O(1)$，除了存储答案的数组 `ans` 之外，额外的空间复杂度是 $O(1)$。
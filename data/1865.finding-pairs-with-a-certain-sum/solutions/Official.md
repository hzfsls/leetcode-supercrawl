#### 方法一：哈希表

**提示 $1$**

由于数组 $\textit{nums}_1$ 的最大长度小于等于 $\textit{nums}_2$，因此对于 $\texttt{getPairs(tot)}$ 操作，我们可以将 $\textit{nums}_2$ 中的元素放入哈希映射中，枚举 $\textit{nums}_1$ 中的元素 $\textit{num}$，从而在哈希映射中找出键 $\textit{tot} - \textit{num}$ 对应的值。这些值的总和即为答案。

**思路与算法**

我们将数组 $\textit{num}_1$ 和 $\textit{nums}_2$ 存储下来，并且额外存储一份数组 $\textit{nums}_2$ 中元素的哈希映射 $\textit{cnt}$。

对于 $\texttt{add(index, val)}$ 操作，我们将 $\textit{cnt}[\textit{nums}_2[\textit{index}]]$ 减去 $1$，$\textit{nums}_2[\textit{index}]$ 加上 $\textit{val}$，再将更新后的 $\textit{cnt}[\textit{nums}_2[\textit{index}]]$ 加上 $1$。

对于 $\texttt{getPairs(tot)}$ 操作，我们枚举 $\textit{nums}_1$ 中的元素 $\textit{num}$，将答案累加 $\textit{cnt}[\textit{tot} - \textit{num}]$，并返回最终的答案。

**代码**

```C++ [sol1-C++]
class FindSumPairs {
private:
    vector<int> nums1, nums2;
    unordered_map<int, int> cnt;

public:
    FindSumPairs(vector<int>& nums1, vector<int>& nums2) {
        this->nums1 = nums1;
        this->nums2 = nums2;
        for (int num: nums2) {
            ++cnt[num];
        }
    }
    
    void add(int index, int val) {
        --cnt[nums2[index]];
        nums2[index] += val;
        ++cnt[nums2[index]];
    }
    
    int count(int tot) {
        int ans = 0;
        for (int num: nums1) {
            int rest = tot - num;
            if (cnt.count(rest)) {
                ans += cnt[rest];
            }
        }
        return ans;
    }
};
```

```Python [sol1-Python3]
class FindSumPairs:

    def __init__(self, nums1: List[int], nums2: List[int]):
        self.nums1 = nums1
        self.nums2 = nums2
        self.cnt = Counter(nums2)

    def add(self, index: int, val: int) -> None:
        _nums2, _cnt = self.nums2, self.cnt

        _cnt[_nums2[index]] -= 1
        _nums2[index] += val
        _cnt[_nums2[index]] += 1

    def count(self, tot: int) -> int:
        _nums1, _cnt = self.nums1, self.cnt

        ans = 0
        for num in _nums1:
            if (rest := tot - num) in _cnt:
                ans += _cnt[rest]
        return ans
```

**复杂度分析**

- 时间复杂度：$O(n + q_1 + (q_2 + 1)m)$，其中 $n$ 和 $m$ 分别是数组 $\textit{nums}_1$ 和 $\textit{nums}_2$ 的长度，$q_1$ 和 $q_2$ 分别是 $\texttt{add(index, val)}$ 和 $\texttt{getPairs(tot)}$ 操作的次数。

    - 初始化需要的时间为 $O(n + m)$；
    
    - 单次 $\texttt{add(index, val)}$ 操作需要的时间为 $O(1)$；

    - 单次 $\texttt{getPairs(tot)}$ 操作需要的时间为 $O(m)$。

    将它们分别乘以操作次数再相加即可得到总时间复杂度。

- 空间复杂度：$O(n + m + q_1)$。数组 $\textit{nums}_1$ 和 $\textit{nums}_2$ 分别需要 $O(n)$ 和 $O(m)$ 的空间，哈希映射初始时需要 $O(m)$ 的空间，每一次 $\texttt{add(index, val)}$ 操作需要额外的 $O(1)$ 空间。

    这里也可以选择在 $\texttt{add(index, val)}$ 操作时将值减为 $0$ 的键值对删除，使得哈希映射的空间恒定为 $O(m)$ 而与 $q_1$ 无关。
## [2086.从房屋收集雨水需要的最少水桶数 中文官方题解](https://leetcode.cn/problems/minimum-number-of-food-buckets-to-feed-the-hamsters/solutions/100000/cong-fang-wu-shou-ji-yu-shui-xu-yao-de-z-w2vj)
#### 方法一：贪心

**思路与算法**

我们可以对字符串 $\textit{street}$ 从左到右进行一次遍历。

每当我们遍历到一个房屋时，我们可以有如下的选择：

- 如果房屋的两侧已经有水桶，那么我们无需再放置水桶了；

- 如果房屋的两侧没有水桶，那么我们优先在房屋的「右侧」放置水桶，这是因为我们是从左到右进行遍历的，即当我们遍历到第 $i$ 个位置时，前 $i-1$ 个位置的房屋周围都是有水桶的。因此我们在左侧放置水桶没有任何意义，而在右侧放置水桶可以让之后的房屋使用该水桶。

    如果房屋的右侧无法放置水桶（例如是另一栋房屋或者边界），那么我们只能在左侧放置水桶。如果左侧也不能放置，说明无解。

我们可以通过修改字符串来表示水桶的放置，从而实现上述算法。一种无需修改字符串的方法是，每当我们在房屋的右侧放置水桶时，可以直接「跳过」后续的两个位置，因为如果字符串形如 $\texttt{H.H}$，我们在第一栋房屋的右侧（即两栋房屋的中间）放置水桶后，就无需考虑第二栋房屋；如果字符串形如 $\text{H..}$，后续没有房屋，我们也可以全部跳过。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    int minimumBuckets(string street) {
        int n = street.size();
        int ans = 0;
        for (int i = 0; i < n; ++i) {
            if (street[i] == 'H') {
                if (i + 1 < n && street[i + 1] == '.') {
                    ++ans;
                    // 直接跳过后续的两个位置
                    i += 2;
                }
                else if (i - 1 >= 0 && street[i - 1] == '.') {
                    ++ans;
                }
                else {
                    return -1;
                }
            }
        }
        return ans;
    }
};
```

```Python [sol1-Python3]
class Solution:
    def minimumBuckets(self, street: str) -> int:
        n = len(street)
        i = ans = 0
        while i < n:
            if street[i] == "H":
                if i + 1 < n and street[i + 1] == ".":
                    ans += 1
                    # 直接跳过后续的两个位置
                    i += 2
                elif i - 1 >= 0 and street[i - 1] == ".":
                    ans += 1
                else:
                    return -1
            i += 1
        return ans
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 是字符串 $\textit{street}$ 的长度。

- 空间复杂度：$O(1)$。
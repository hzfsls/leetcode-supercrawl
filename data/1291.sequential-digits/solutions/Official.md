### 方法一：枚举

我们可以枚举所有的「顺次数」，并依次判断它们是否在 `[low, high]` 的范围内。

具体地，我们首先枚举「顺次数」的最高位数字 `i`，随后递增地枚举「顺次数」的最低位数字 `j`，需要满足 `j > i`。对于每一组 `(i, j)`，我们可以得到其对应的「顺次数」`num`，如果 `num` 在 `[low, high]` 的范围内，就将其加入答案中。

在枚举完所有的「顺次数」后，我们将答案进行排序，就可以得到最终的结果。

```C++ [sol1-C++]
class Solution {
public:
    vector<int> sequentialDigits(int low, int high) {
        vector<int> ans;
        for (int i = 1; i <= 9; ++i) {
            int num = i;
            for (int j = i + 1; j <= 9; ++j) {
                num = num * 10 + j;
                if (num >= low && num <= high) {
                    ans.push_back(num);
                }
            }
        }
        sort(ans.begin(), ans.end());
        return ans;
    }
};
```

```Python [sol1-Python3]
class Solution:
    def sequentialDigits(self, low: int, high: int) -> List[int]:
        ans = list()
        for i in range(1, 10):
            num = i
            for j in range(i + 1, 10):
                num = num * 10 + j
                if low <= num <= high:
                    ans.append(num)
        return sorted(ans)
```

**复杂度分析**

- 时间复杂度：$O(1)$。根据定义，每一组满足 $1 \leq i < j \leq 9$ 的 $(i, j)$ 就对应了一个「顺次数」，那么「顺次数」的数量为 $\binom{9}{2} = \frac{9 \times 8}{2} = 36$ 个，可以视作一个常数。因此时间复杂度为 $O(1)$。

- 空间复杂度：$O(1)$。
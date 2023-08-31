## [477.汉明距离总和 中文官方题解](https://leetcode.cn/problems/total-hamming-distance/solutions/100000/yi-ming-ju-chi-zong-he-by-leetcode-solut-t0ev)

#### 方法一：逐位统计

在计算汉明距离时，我们考虑的是同一比特位上的值是否不同，而不同比特位之间是互不影响的。

对于数组 $\textit{nums}$ 中的某个元素 $\textit{val}$，若其二进制的第 $i$ 位为 $1$，我们只需统计 $\textit{nums}$ 中有多少元素的第 $i$ 位为 $0$，即计算出了 $\textit{val}$ 与其他元素在第 $i$ 位上的汉明距离之和。

具体地，若长度为 $n$ 的数组 $\textit{nums}$ 的所有元素二进制的第 $i$ 位共有 $c$ 个 $1$，$n-c$ 个 $0$，则些元素在二进制的第 $i$ 位上的汉明距离之和为

$$
c\cdot(n-c)
$$

我们可以从二进制的最低位到最高位，逐位统计汉明距离。将每一位上得到的汉明距离累加即为答案。

具体实现时，对于整数 $\textit{val}$ 二进制的第 $i$ 位，我们可以用代码 `(val >> i) & 1` 来取出其第 $i$ 位的值。此外，由于 $10^9<2^{30}$，我们可以直接从二进制的第 $0$ 位枚举到第 $29$ 位。

```C++ [sol1-C++]
class Solution {
public:
    int totalHammingDistance(vector<int> &nums) {
        int ans = 0, n = nums.size();
        for (int i = 0; i < 30; ++i) {
            int c = 0;
            for (int val : nums) {
                c += (val >> i) & 1;
            }
            ans += c * (n - c);
        }
        return ans;
    }
};
```

```Java [sol1-Java]
class Solution {
    public int totalHammingDistance(int[] nums) {
        int ans = 0, n = nums.length;
        for (int i = 0; i < 30; ++i) {
            int c = 0;
            for (int val : nums) {
                c += (val >> i) & 1;
            }
            ans += c * (n - c);
        }
        return ans;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int TotalHammingDistance(int[] nums) {
        int ans = 0, n = nums.Length;
        for (int i = 0; i < 30; ++i) {
            int c = 0;
            foreach (int val in nums) {
                c += (val >> i) & 1;
            }
            ans += c * (n - c);
        }
        return ans;
    }
}
```

```go [sol1-Golang]
func totalHammingDistance(nums []int) (ans int) {
    n := len(nums)
    for i := 0; i < 30; i++ {
        c := 0
        for _, val := range nums {
            c += val >> i & 1
        }
        ans += c * (n - c)
    }
    return
}
```

```Python [sol1-Python3]
class Solution:
    def totalHammingDistance(self, nums: List[int]) -> int:
        n = len(nums)
        ans = 0
        for i in range(30):
            c = sum(((val >> i) & 1) for val in nums)
            ans += c * (n - c)
        return ans
```

```C [sol1-C]
int totalHammingDistance(int* nums, int numsSize) {
    int ans = 0;
    for (int i = 0; i < 30; ++i) {
        int c = 0;
        for (int j = 0; j < numsSize; ++j) {
            c += (nums[j] >> i) & 1;
        }
        ans += c * (numsSize - c);
    }
    return ans;
}
```

```JavaScript [sol1-JavaScript]
var totalHammingDistance = function(nums) {
    let ans = 0, n = nums.length;
    for (let i = 0; i < 30; ++i) {
        let c = 0;
        for (const val of nums) {
            c += (val >> i) & 1;
        }
        ans += c * (n - c);
    }
    return ans;
};
```

**复杂度分析**

- 时间复杂度：$O(n\cdot L)$。其中 $n$ 是数组 $\textit{nums}$ 的长度，$L=30$。

- 空间复杂度：$O(1)$。

---
## ✨扣友帮帮团 - 互动答疑

[![讨论.jpg](https://pic.leetcode-cn.com/1621178600-MKHFrl-%E8%AE%A8%E8%AE%BA.jpg){:width=260px}](https://leetcode-cn.com/topic/kou-you-bang-bang-tuan/discuss/latest/)


即日起 - 5 月 30 日，点击 [这里](https://leetcode-cn.com/topic/kou-you-bang-bang-tuan/discuss/latest/) 前往「[扣友帮帮团](https://leetcode-cn.com/topic/kou-you-bang-bang-tuan/discuss/latest/)」活动页，把你遇到的问题大胆地提出来，让扣友为你解答～

### 🎁 奖励规则
被采纳数量排名 1～3 名：「力扣极客套装」 *1 并将获得「力扣神秘应援团」内测资格
被采纳数量排名 4～10 名：「力扣鼠标垫」 *1 并将获得「力扣神秘应援团」内测资格
「诲人不倦」：活动期间「解惑者」只要有 1 个回答被采纳，即可获得 20 LeetCoins 奖励！
「求知若渴」：活动期间「求知者」在活动页发起一次符合要求的疑问帖并至少采纳一次「解惑者」的回答，即可获得 20 LeetCoins 奖励！

活动详情猛戳链接了解更多：[🐞 你有 BUG 我来帮 - 力扣互动答疑季](https://leetcode-cn.com/circle/discuss/xtliW6/)
## [2172.数组的最大与和 中文官方题解](https://leetcode.cn/problems/maximum-and-sum-of-array/solutions/100000/shu-zu-de-zui-da-yu-he-by-leetcode-solut-hjyv)

#### 方法一：三进制状态压缩动态规划

**思路与算法**

注意到题目的数据范围并不大，因此我们可以考虑使用状态压缩。可供压缩的有两种，即数和篮子：

- 最多有 $18$ 个数，每个数被放入篮子或不放入篮子总计 $2$ 种情况，因此状态的数量为 $2^{18} = 262144$；

- 最多有 $9$ 个篮子，每个篮子可以被放入 $0,1,2$ 个数，总计 $3$ 种情况，因此状态的数量为 $3^9 = 19683$。

第二种压缩方法的状态数量明显较小，因此我们考虑对篮子进行压缩。

我们用一个位数为 $\textit{numSlots}$ 的三进制数 $\textit{mask}$ 表示当前篮子的状态，其中 $\textit{mask}$ 的第 $i$ 位为 $0,1,2$ 分别表示编号为 $i+1$ 的篮子被放入了 $0,1,2$ 个数。由于我们放置数的顺序并不会影响答案（即先将数 $x$ 放入篮子 $p$ 再将数 $y$ 放入篮子 $q$，与先将 $y$ 放入篮子 $q$ 再将数 $x$ 放入篮子 $p$ 没有区别），因此我们将 $\textit{mask}$ 的所有数位进行相加得到 $\textit{cnt}$，$\textit{cnt}$ 就表示已经放入篮子的数的数量，我们可以枚举最后一个数（即 $\textit{nums}[\textit{cnt} - 1]$）放入的具体篮子的编号来进行状态转移。

记 $f[\textit{mask}]$ 表示当篮子的状态为 $\textit{mask}$，篮子中数的总个数为 $\textit{cnt}$，并且我们放入的是数组中最开始的 $\textit{cnt}$ 个数的情况下的「最大与和」。在进行状态转移时，我们枚举最后一个数放入的具体篮子的编号即可：

$$
f[\textit{mask}] = \max_{\textit{mask}~ 的第 ~i~ 位不为 ~0}\big\{ f[\textit{mask} - 3^i] + \textit{nums}[\textit{cnt} - 1] \wedge (i+1) \big\}
$$

其中 $\textit{mask} - 3^i$ 就是将 $\textit{mask}$ 的第 $i$ 位减去 $1$，$\wedge$ 表示与运算。

动态规划的边界条件为 $f[0] = 0$，最终的答案即为所有 $f[..]$ 中的最大值。

**细节**

由于 $\textit{mask}$ 是三进制表示，而大部分语言没有三进制相关的 API，因此获取 $\textit{mask}$ 的第 $i$ 位较为困难。由于 $\textit{mask}$ 本质上是以十进制值展示的，因此我们可以使用类似「十进制转三进制」的方法，使用一个 $\textit{numSlots}$ 次的循环，每次通过 $\textit{mask} \bmod 3$ 获取 $\textit{mask}$ 的最低位，再将 $\textit{mask}$ 整除 $3$ 以消去最低位。这样一来，我们就相当于遍历了 $\textit{mask}$ 的每个数位了。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    int maximumANDSum(vector<int>& nums, int numSlots) {
        int n = nums.size();
        int mask_max = 1;
        for (int i = 0; i < numSlots; ++i) {
            mask_max *= 3;
        }
        
        vector<int> f(mask_max);
        for (int mask = 1; mask < mask_max; ++mask) {
            int cnt = 0;
            for (int i = 0, dummy = mask; i < numSlots; ++i, dummy /= 3) {
                cnt += dummy % 3;
            }
            if (cnt > n) {
                continue;
            }
            for (int i = 0, dummy = mask, w = 1; i < numSlots; ++i, dummy /= 3, w *= 3) {
                int has = dummy % 3;
                if (has) {
                    f[mask] = max(f[mask], f[mask - w] + (nums[cnt - 1] & (i + 1)));
                }
            }
        }
        
        return *max_element(f.begin(), f.end());
    }
};
```

```Python [sol1-Python3]
class Solution:
    def maximumANDSum(self, nums: List[int], numSlots: int) -> int:
        n = len(nums)
        mask_max = 3 ** numSlots

        f = [0] * mask_max        
        for mask in range(1, mask_max):
            cnt, dummy = 0, mask

            for i in range(numSlots):
                cnt += dummy % 3
                dummy //= 3
            
            if cnt > n:
                continue
            
            dummy, w = mask, 1
            for i in range(numSlots):
                has = dummy % 3
                if has > 0:
                    f[mask] = max(f[mask], f[mask - w] + (nums[cnt - 1] & (i + 1)))
                dummy //= 3
                w *= 3
        
        return max(f)
```

**复杂度分析**

- 时间复杂度：$O(\textit{numSlots} \times 3^\textit{numSlots})$。注意上述方法的时间复杂度和 $n$ 并没有关系，因为每一个 $\textit{mask}$ 都可以唯一确定当前需要放入的数的下标。

- 空间复杂度：$O(3^\textit{numSlots})$，即为动态规划需要使用的空间。
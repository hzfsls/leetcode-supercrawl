## [1985.找出数组中的第 K 大整数 中文官方题解](https://leetcode.cn/problems/find-the-kth-largest-integer-in-the-array/solutions/100000/zhao-chu-shu-zu-zhong-de-di-k-da-zheng-s-wvwg)

#### 方法一：自定义排序

**思路与算法**

为了找出字符串数组中的第 $k$ 大整数，一种可行的方式是把字符串数组按照字符串对应的整数大小进行**降序排序**，最终选择排序后数组中的第 $k$ 个元素作为答案返回。而自定义排序算法的核心在于实现一个自定义的比较函数 $\textit{cmp}(s_1, s_2)$，即对于数组 $\textit{nums}$ 中的任意两个字符串 $s_1$ 与 $s_2$，比较它们对应整数的大小，并按照要求返回对应的结果。

由于 $s_1$ 与 $s_2$ 的长度上限为 $100$，对应的整数超出了大多数编程语言的内置整型的上限，因此我们难以将字符串直接转化为内置整型进行比较。此时我们需要直接对字符串进行比较来判断它们对应整数的大小，比较过程可以分为两个部分：

- 第一部分：由于 $s_1$ 与 $s_2$ 均不含前导零，因此我们首先可以比较 $s_1$ 与 $s_2$ 的长度：如果 $s_1$ 的长度大于 $s_2$ 的长度，则 $s_1$ 对应的整数也大于 $s_2$ 对应的整数；反之亦然。

- 第二部分：如果 $s_1$ 与 $s_2$ 的长度相等，我们就需要从高位至低位比较每一位字符对应数字的大小。当比较至某一位时，如果 $s_1$ 在该位对应的数字大于 $s_2$ 在该位对应的数字，则 $s_1$ 对应的整数也大于 $s_2$ 对应的整数；反之亦然。这部分的比较过程等价于直接比较字符串**字典序**的大小。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    string kthLargestNumber(vector<string>& nums, int k) {
        // 自定义比较函数，在 s1 对应的整数较大时返回 true，反之返回 false
        auto cmp = [](const string& s1, const string& s2) -> bool{
            // 首先比较字符串长度
            if (s1.size() > s2.size()){
                return true;
            }
            else if (s1.size() < s2.size()){
                return false;
            }
            else{
                // 长度相等时比较字符串字典序大小
                return s1 > s2;
            }
        };
        
        sort(nums.begin(), nums.end(), cmp);
        return nums[k-1];
    }
};
```

```Python [sol1-Python3]
from functools import cmp_to_key
class Solution:
    def kthLargestNumber(self, nums: List[str], k: int) -> str:
        # 自定义比较函数，在 s1 对应的整数较大时返回 -1，反之返回 1
        def cmp(s1: str, s2: str) -> int:
            # 首先比较字符串长度
            if len(s1) > len(s2):
                return -1
            elif len(s1) < len(s2):
                return 1
            else:
                # 长度相等时比较字符串字典序大小
                if s1 > s2:
                    return -1
                else:
                    return 1
            
        nums.sort(key=cmp_to_key(cmp))
        return nums[k-1]
```

**复杂度分析**

- 时间复杂度：$O(nm \log n)$，其中 $n$ 为 $\textit{nums}$ 的长度，$m$ 为 $\textit{nums}$ 中字符串的长度。排序的过程中会存在 $O(n \log n)$ 次比较与交换操作，每次比较与交换操作的时间复杂度为 $O(m)$。

- 空间复杂度：$O(m + \log n)$，即为交换操作的空间开销与排序的栈空间开销。
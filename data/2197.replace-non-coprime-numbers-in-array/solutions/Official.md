## [2197.替换数组中的非互质数 中文官方题解](https://leetcode.cn/problems/replace-non-coprime-numbers-in-array/solutions/100000/ti-huan-shu-zu-zhong-de-fei-hu-zhi-shu-b-mnml)
#### 方法一：栈

**思路与算法**

由于题目不加证明地给出了「任意顺序替换相邻的非互质数都可以得到相同的结果」，因此我们可以从前往后进行替换。

我们可以使用一个栈来进行替换操作。具体地，我们对数组 $\textit{nums}$ 进行一次遍历。当遍历到 $\textit{nums}[i]$ 时。在其被放入栈顶前，我们重复进行替换操作，直到 $\textit{nums}[i]$ 和栈顶的元素互质，或者栈为空为止。此时，我们再将替换完成的 $\textit{nums}[i]$ 放入栈顶。

最终栈底到栈顶的元素序列即为答案。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    vector<int> replaceNonCoprimes(vector<int>& nums) {
        vector<int> ans;
        for (int num: nums) {
            while (!ans.empty()) {
                int g = gcd(ans.back(), num);
                if (g > 1) {
                    num = ans.back() / g * num;
                    ans.pop_back();
                }
                else {
                    break;
                }
            }
            ans.push_back(num);
        }
        return ans;
    }
};
```

```Python [sol1-Python3]
class Solution:
    def replaceNonCoprimes(self, nums: List[int]) -> List[int]:
        ans = list()
        for num in nums:
            while ans:
                g = math.gcd(ans[-1], num)
                if g > 1:
                    num = ans[-1] // g * num
                    ans.pop()
                else:
                    break
            ans.append(num)
        
        return ans
```

**复杂度分析**

- 时间复杂度：$O(n \log C)$，其中 $n$ 是数组 $\textit{nums}$ 的长度，$C$ 是数组 $\textit{nums}$ 中的数据范围，$O(\log C)$ 即为单次计算最大公约数需要的时间。

- 空间复杂度：$O(1)$。这里不计入返回值需要使用的空间。
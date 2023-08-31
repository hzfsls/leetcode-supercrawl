## [2243.计算字符串的数字和 中文官方题解](https://leetcode.cn/problems/calculate-digit-sum-of-a-string/solutions/100000/ji-suan-zi-fu-chuan-de-shu-zi-he-by-leet-pfuh)

#### 方法一：模拟

**思路与算法**

我们可以模拟题目中的操作过程**更新**字符串 $s$，具体在每一轮操作中：

我们用字符串（或数组，视不同语言字符串的实现方式而确定）$\textit{tmp}$ 来维护该轮操作的结果。随后，我们遍历字符串 $s$，以每 $k$ 个字符为一组，计算该组的数字和 $\textit{val}$，并转化为字符串添加至 $\textit{tmp}$ 尾部。最终，我们将 $s$ 更新为 $\textit{tmp}$ **所表示的字符串**。

我们执行上述操作直到 $s$ 的长度小于等于 $k$ 为止，并最终返回 $s$ 作为答案。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    string digitSum(string s, int k) {
        while (s.size() > k) {
            string tmp;   // 每次操作结束的字符串
            int n = s.size();
            for (int i = 0; i < n; i += k) {
                int val = 0;
                for (int j = i; j < min(i + k, n); ++j) {
                    val += s[j] - '0';
                }
                tmp.append(to_string(val));
            }
            s = tmp;
        }
        return s;
    }
};
```


```Python [sol1-Python3]
class Solution:
    def digitSum(self, s: str, k: int) -> str:
        while len(s) > k:
            tmp = []   # 每次操作结束的字符串对应数组
            n = len(s)
            for i in range(0, n, k):
                val = 0
                for j in range(i, min(i + k, n)):
                    val += int(s[j])
                tmp.append(str(val))
            s = "".join(tmp)
        return s
```


**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 为字符串 $s$ 的长度。即为所有操作的时间复杂度之和。可以证明，当 $k$ 增大时，操作的次数以及每次操作时当前字符串的长度都会减小；同时，当 $k = 2$ 时，每次操作开始字符串的长度总和仍为 $n$ 的常数倍。因此每次操作时字符串长度之和以及最终的时间复杂度都为 $O(n)$。

- 空间复杂度：$O(n)$，即为辅助数组或字符串的空间开销。
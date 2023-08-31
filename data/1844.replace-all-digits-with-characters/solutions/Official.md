## [1844.将所有数字用字符替换 中文官方题解](https://leetcode.cn/problems/replace-all-digits-with-characters/solutions/100000/jiang-suo-you-shu-zi-yong-zi-fu-ti-huan-r77zx)

#### 方法一：模拟

**思路与算法**

我们以两个字符为一组对字符串按要求进行修改即可。

对于 $\texttt{C++}$，我们直接在 $\textit{s}$ 上进行修改即可。

对于 $\texttt{Python}$，由于我们无法直接修改字符串，因此需要引入辅助数组 $\textit{arr}$，并在辅助数组上进行相应操作，最终转化回字符串。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    string replaceDigits(string s) {
        int n = s.size();
        for (int i = 1; i < n; i += 2){
            s[i] = s[i-1] + (s[i] - '0');
        }
        return s;
    }
};
```

```Python [sol1-Python3]
class Solution:
    def replaceDigits(self, s: str) -> str:
        n = len(s)
        arr = list(s)
        for i in range(1, n, 2):
            arr[i] = chr(ord(arr[i-1]) + int(arr[i]))
        return "".join(arr)
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 为字符串的长度。我们对字符串进行了常数次数的遍历操作，单次遍历操作的时间复杂度为 $O(n)$。

- 空间复杂度：这里由于 $\texttt{Python}$ 中无法修改字符串，因此不同语言的代码实现有一定区别。对应的空间复杂度也有所区别。

    - $\texttt{C++}$ 代码：$O(1)$，我们直接对原字符串进行修改。

    - $\texttt{Python}$ 代码：$O(n)$，即为辅助数组 $\textit{arr}$ 的空间开销。
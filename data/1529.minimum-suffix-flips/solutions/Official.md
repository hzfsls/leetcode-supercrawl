## [1529.最少的后缀翻转次数 中文官方题解](https://leetcode.cn/problems/minimum-suffix-flips/solutions/100000/deng-pao-kai-guan-iv-by-leetcode-solution)
#### 方法一：贪心

根据翻转操作的定义，选定下标 $i$ 之后，翻转从下标 $i$ 到下标 $n-1$ 的每个字符，在下标 $i$ 前面的字符则不被翻转。因此，如果一个字符被翻转，则一定是选择了该字符的下标或者该字符前面的某个下标，然后进行了翻转操作。

初始时，所有的字符都是 $0$。对于下标为 $0$ 的字符，如果其在 $\textit{target}$ 中的值是 $1$，则一定有一次对下标为 $0$ 的字符的翻转操作。

对于下标为 $i$（$i>0$）的字符，如果其在 $\textit{target}$ 中的值与前一个字符（即下标为 $i-1$ 的字符）的值不同，则一定有一次对下标为 $i$ 的字符的翻转操作。

由此可以想到一个贪心的思路：从前往后遍历 $\textit{target}$，对每个下标判断是否进行了翻转操作即可，同时计算最少翻转次数。

```Java [sol1-Java]
class Solution {
    public int minFlips(String target) {
        int flips = 0;
        char prev = '0';
        int n = target.length();
        for (int i = 0; i < n; i++) {
            char curr = target.charAt(i);
            if (curr != prev) {
                flips++;
                prev = curr;
            }
        }
        return flips;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int MinFlips(string target) {
        int flips = 0;
        char prev = '0';
        int n = target.Length;
        for (int i = 0; i < n; i++) {
            char curr = target[i];
            if (curr != prev) {
                flips++;
                prev = curr;
            }
        }
        return flips;
    }
}
```

```C++ [sol1-C++]
class Solution {
public:
    int minFlips(string target) {
        int flips = 0;
        char prev = '0';
        int n = target.size();
        for (int i = 0; i < n; i++) {
            char curr = target.at(i);
            if (curr != prev) {
                flips++;
                prev = curr;
            }
        }
        return flips;
    }
};
```

```Python [sol1-Python3]
class Solution:
    def minFlips(self, target: str) -> int:
        flips, prev = 0, "0"
        for curr in target:
            if curr != prev:
                flips += 1
                prev = curr
        return flips
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 是字符串 $\textit{target}$ 的长度。遍历字符串一次。

- 空间复杂度：$O(1)$。只需要维护常量的额外空间。
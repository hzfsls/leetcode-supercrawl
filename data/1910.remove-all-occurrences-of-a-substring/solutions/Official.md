#### 方法一：模拟 + 暴力匹配

**思路与算法**

我们设字符串 $\textit{part}$ 的长度为 $m$。在从左到右遍历字符串 $s$ 时，如果以当前字符结尾的长度为 $m$ 的子串与 $\textit{part}$ 相等，那么我们就需要删去该子串。

我们可以用一个初始为空的字符串 $\textit{res}$ 来模拟这一过程。我们从左到右遍历字符串 $s$，并将对应的字符添加至 $\textit{res}$ 的尾部。如果此时 $\textit{res}$ 中长度为 $m$ 的后缀与 $\textit{part}$ 相等，那么我们删去该后缀。最终，$\textit{res}$ 即为 $s$ 中删除所有 $\textit{part}$ 子串后得到的剩余字符串。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    string removeOccurrences(string s, string part) {
        int m = part.size();
        string res;
        for (const char ch: s){
            // 模拟从左至右匹配的过程
            res.push_back(ch);
            int n = res.size();
            if (n >= m && res.substr(n - m, n) == part){
                // 如果匹配成功，那么删去对应后缀
                res = res.substr(0, n - m);
            }
        }
        return res;
    }
};
```

```Python [sol1-Python3]
class Solution:
    def removeOccurrences(self, s: str, part: str) -> str:
        m = len(part)
        res = ""
        for ch in s:
            # 模拟从左至右匹配的过程
            res += ch
            if len(res) >= m and res[-m:] == part:
                # 如果匹配成功，那么删去对应后缀
                res = res[:-m]
        return res
```

**复杂度分析**

- 时间复杂度：$O(n^2 + nm)$，其中 $n$ 为字符串 $s$ 的长度，$m$ 为字符串 $\textit{part}$ 的长度。在模拟过程中，每次匹配的时间复杂度为 $O(m)$，匹配成功后更新 $\textit{res}$ 的时间复杂度为 $O(n)$。而匹配与更新的次数至多为 $O(n)$ 次。

- 空间复杂度：$O(n + m)$。


#### 方法二：$\text{KMP}$ 算法

**思路与算法**

在方法一中，每一次匹配都需要暴力比较两个长度为 $m$ 的字符串，时间复杂度为 $O(m)$。我们可以对暴力比较的过程进行优化。在这里，我们使用 $\text{KMP}$ 算法对匹配过程进行优化。如果读者不熟悉 $\text{KMP}$ 算法，可以阅读[「28. 实现 strStr() 的官方题解」](https://leetcode-cn.com/problems/implement-strstr/solution/shi-xian-strstr-by-leetcode-solution-ds6y/) 中的方法二。

在这里，除了需要保留 $\textit{part}$ 的前缀函数数组，我们还需要保留 $\textit{res}$ 的前缀函数数组。当新插入字符对应的前缀函数值等于 $m$ 时，代表 $\textit{res}$ 中长度为 $m$ 的后缀与 $\textit{part}$ 相等，此时我们需要删去该后缀以及对应的前缀函数值。

另外，由于 $\texttt{Python}$ 等语言不支持删除字符串的元素，我们需要将字符串转化为数组进行操作。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    string removeOccurrences(string s, string part) {
        int m = part.size();
        vector<int> pi1(m);   // part 的前缀数组
        // 更新 part 的前缀数组
        for (int i = 1, j = 0; i < m; i++) {
            while (j > 0 && part[i] != part[j]) {
                j = pi1[j-1];
            }
            if (part[i] == part[j]) {
                j++;
            }
            pi1[i] = j;
        }

        string res;
        vector<int> pi2 = {0};   // res 的前缀数组
        for (const char ch: s) {
            // 模拟从左至右匹配的过程
            res.push_back(ch);
            // 更新 res 的前缀数组
            int j = pi2.back();
            while (j > 0 && ch != part[j]) {
                j = pi1[j-1];
            }
            if (ch == part[j]){
                ++j;
            }
            pi2.push_back(j);
            if (j == m) {
                // 如果匹配成功，那么删去对应后缀
                pi2.erase(pi2.end() - m, pi2.end());
                res.erase(res.end() - m, res.end());
            }
        }
        return res;
    }
};
```

```Python [sol1-Python3]
class Solution:
    def removeOccurrences(self, s: str, part: str) -> str:
        m = len(part)
        pi1 = [0] * m   # part 的前缀数组
        # 更新 part 的前缀数组
        j = 0
        for i in range(1, m):
            while j > 0 and part[i] != part[j]:
                j = pi1[j-1]
            if part[i] == part[j]:
                j += 1
            pi1[i] = j
        
        res = []
        pi2 = [0]   # res 的前缀数组
        for ch in s:
            # 模拟从左至右匹配的过程
            res.append(ch)
            # 更新 res 的前缀数组
            j = pi2[-1]
            while j > 0 and ch != part[j]:
                j = pi1[j-1]
            if ch == part[j]:
                j += 1
            pi2.append(j)
            if j == m:
                # 如果匹配成功，那么删去对应后缀
                pi2[-m:] = []
                res[-m:] = []
        return "".join(res)
```

**复杂度分析**

- 时间复杂度：$O(n + m)$，其中 $n$ 为字符串 $s$ 的长度，$m$ 为字符串 $\textit{part}$ 的长度。计算 $s$ 与 $\textit{res}$ 的前缀数组的时间复杂度为 $O(n + m)$；由于 $s$ 中的每个字符最多会被加入或删除各一次，因此维护 $\textit{res}$ 的时间复杂度为 $O(n)$。

- 空间复杂度：$O(n + m)$。
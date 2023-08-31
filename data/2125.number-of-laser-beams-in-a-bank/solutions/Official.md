## [2125.银行中的激光束数量 中文官方题解](https://leetcode.cn/problems/number-of-laser-beams-in-a-bank/solutions/100000/yin-xing-zhong-de-ji-guang-shu-shu-liang-ad02)
#### 方法一：直接计数

**思路与算法**

根据题目的要求，对于两个不同的行 $r_1$ 和 $r_2~(r_1 < r_2)$，如果它们恰好是相邻的两行（即 $r_1 + 1 = r_2$），或者它们之间的所有行都全为 $0$，那么第 $r_1$ 行的任意一个安全设备与第 $r_2$ 行的任意一个安全设备之间都有激光束。

因此，我们只需要统计每一行的安全设备个数，记为 $\textit{cnt}$，以及上一个不全为 $0$ 的行的安全设备个数，记为 $\textit{last}$。那么 $\textit{cnt} \times \textit{last}$ 即为激光束的个数。我们对所有的行进行遍历，维护 $\textit{cnt}$ 和 $\textit{last}$ 并对 $\textit{cnt} \times \textit{last}$ 进行累加，即可得到激光束的总数量。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    int numberOfBeams(vector<string>& bank) {
        int last = 0, ans = 0;
        for (const string& line: bank) {
            int cnt = count_if(line.begin(), line.end(), [](char ch) {return ch == '1';});
            if (cnt != 0) {
                ans += last * cnt;
                last = cnt;
            }
        }
        return ans;
    }
};
```

```Python [sol1-Python3]
class Solution:
    def numberOfBeams(self, bank: List[str]) -> int:
        last = ans = 0
        for line in bank:
            cnt = line.count("1")
            if cnt != 0:
                ans += last * cnt
                last = cnt
        return ans
```

**复杂度分析**

- 时间复杂度：$O(mn)$。

- 空间复杂度：$O(1)$。
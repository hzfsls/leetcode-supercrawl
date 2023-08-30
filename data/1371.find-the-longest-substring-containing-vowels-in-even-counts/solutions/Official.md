#### 方法一：前缀和 + 状态压缩

**思路和算法**

我们先来考虑暴力方法怎么做。最直观的方法无非就是枚举所有子串，遍历子串中的所有字符，统计元音字母出现的个数。如果符合条件，我们就更新答案，但这样肯定会因为超时而无法通过所有测试用例。

再回顾一下上面的操作，其实每个子串对应着一个区间，那么有什么方法可以在不重复遍历子串的前提下，快速求出这个区间里元音字母出现的次数呢？答案就是前缀和，对于一个区间，我们可以用两个前缀和的差值，得到其中某个字母的出现次数。

我们对每个元音字母维护一个前缀和，定义 $\textit{pre}[i][k]$ 表示在字符串前 $i$ 个字符中，第 $k$ 个元音字母一共出现的次数。假设我们需要求出 $[l,r]$ 这个区间的子串是否满足条件，那么我们可以用 $\textit{pre}[r][k]-pre[l-1][k]$，在 $O(1)$ 的时间得到第 $k$ 个元音字母出现的次数。对于每一个元音字母，我们都判断一下其是否出现偶数次即可。

我们利用前缀和优化了统计子串的时间复杂度，然而枚举所有子串的复杂度仍需要 $O(n^2)$，不足以通过本题，还需要继续进行优化，避免枚举所有子串。我们考虑枚举字符串的每个位置 $i$ ，计算以它结尾的满足条件的最长字符串长度。其实我们要做的就是快速找到**最小**的 $j \in [0,i)$，满足 $\textit{pre}[i][k]-pre[j][k]$（即每一个元音字母出现的次数）均为偶数，那么以 $i$ 结尾的最长字符串 $s[j+1,i]$ 长度就是 $i-j$。

有经验的读者可能马上就想到了利用哈希表来优化查找的复杂度，但是单单利用前缀和，我们无法找到 $i$ 和 $j$ 相关的恒等式，像「[1248. 统计优美子数组](https://leetcode-cn.com/problems/count-number-of-nice-subarrays/)」这道题我们是能明确知道两个前缀的差值是恒定的。那难道就没办法了么？其实不然，这道题我们还有一个性质没有充分利用：我们需要找的子串中，每个元音字母都恰好出现了**偶数次**。

**偶数**这个条件其实告诉了我们，对于满足条件的子串而言，两个前缀和 $\textit{pre}[i][k]$ 和 $\textit{pre}[j][k]$ 的奇偶性一定是相同的，因为小学数学的知识告诉我们：奇数减奇数等于偶数，偶数减偶数等于偶数。因此我们可以对前缀和稍作修改，从维护元音字母出现的次数改作维护元音字母出现次数的**奇偶性**。这样我们只要实时维护每个元音字母出现的奇偶性，那么 $s[j+1,i]$ 满足条件当且仅当对于所有的 $k$，$\textit{pre}[i][k]$ 和 $\textit{pre}[j][k]$ 的奇偶性都相等，此时我们就可以利用哈希表存储**每一种**奇偶性（即考虑所有的元音字母）对应**最早出现的位置**，边遍历边更新答案。

题目做到这里基本上做完了，但是我们还可以进一步优化我们的编码方式，如果直接以每个元音字母出现次数的奇偶性为哈希表中的键，难免有些冗余，我们可能需要额外定义一个状态：

```text
{
  a: cnta, // a 出现次数的奇偶性
  e: cnte, // e 出现次数的奇偶性
  i: cnti, // i 出现次数的奇偶性
  o: cnto, // o 出现次数的奇偶性
  u: cntu  // u 出现次数的奇偶性
}
```

将这么一个结构当作我们哈希表存储的键值，如果题目稍作修改扩大了字符集，那么维护起来可能会比较吃力。考虑到出现次数的奇偶性其实无非就两个值，$0$ 代表出现了偶数次，$1$ 代表出现了奇数次，我们可以将其压缩到一个二进制数中，第 $k$ 位的 $0$ 或 $1$ 代表了第 $k$ 个元音字母出现的奇偶性。举一个例子，假如到第 $i$ 个位置，`u o i e a` 出现的奇偶性分别为 `1 1 0 0 1`，那么我们就可以将其压成一个二进制数 $(11001)_2=(25)_{10}$ 作为它的状态。这样我们就可以将 $5$ 个元音字母出现次数的奇偶性压缩到了一个二进制数中，且连续对应了二进制数的 $[(00000)_2,(11111)_2]$ 的范围，转成十进制数即 $[0,31]$。因此我们也不再需要使用哈希表，直接用一个长度为 $32$ 的数组来存储对应状态出现的最早位置即可。

```C++ [sol1-C++]
class Solution {
public:
    int findTheLongestSubstring(string s) {
        int ans = 0, status = 0, n = s.length();
        vector<int> pos(1 << 5, -1);
        pos[0] = 0;
        for (int i = 0; i < n; ++i) {
            if (s[i] == 'a') {
                status ^= 1<<0;
            } else if (s[i] == 'e') {
                status ^= 1<<1;
            } else if (s[i] == 'i') {
                status ^= 1<<2;
            } else if (s[i] == 'o') {
                status ^= 1<<3;
            } else if (s[i] == 'u') {
                status ^= 1<<4;
            }
            if (~pos[status]) {
                ans = max(ans, i + 1 - pos[status]);
            } else {
                pos[status] = i + 1;
            }
        }
        return ans;
    }
};
```

```JavaScript [sol1-JavaScript]
var findTheLongestSubstring = function(s) {
    const n = s.length;
    const pos = new Array(1 << 5).fill(-1);
    let ans = 0, status = 0;
    pos[0] = 0;
    for (let i = 0; i < n; ++i) {
        const ch = s.charAt(i);
        if (ch === 'a') {
            status ^= 1<<0;
        } else if (ch === 'e') {
            status ^= 1<<1;
        } else if (ch === 'i') {
            status ^= 1<<2;
        } else if (ch === 'o') {
            status ^= 1<<3;
        } else if (ch === 'u') {
            status ^= 1<<4;
        }
        if (~pos[status]) {
            ans = Math.max(ans, i + 1 - pos[status]);
        } else {
            pos[status] = i + 1;
        }
    }
    return ans;
};
```

```Java [sol1-Java]
class Solution {
    public int findTheLongestSubstring(String s) {
        int n = s.length();
        int[] pos = new int[1 << 5];
        Arrays.fill(pos, -1);
        int ans = 0, status = 0;
        pos[0] = 0;
        for (int i = 0; i < n; i++) {
            char ch = s.charAt(i);
            if (ch == 'a') {
                status ^= (1 << 0);
            } else if (ch == 'e') {
                status ^= (1 << 1);
            } else if (ch == 'i') {
                status ^= (1 << 2);
            } else if (ch == 'o') {
                status ^= (1 << 3);
            } else if (ch == 'u') {
                status ^= (1 << 4);
            }
            if (pos[status] >= 0) {
                ans = Math.max(ans, i + 1 - pos[status]);
            } else {
                pos[status] = i + 1;
            }
        }
        return ans;
    }
}
```
```csharp [sol1-C#]
public class Solution {
    public int FindTheLongestSubstring(string s) {
        int[] earliest = new int [1 << 5];
        for (int i = 0; i < earliest.Length; ++i) {
            earliest[i] = int.MaxValue;
        }
        earliest[0] = -1;
        int mask = 0, ans = 0;
        for (int i = 0; i < s.Length; ++i) {
            switch (s[i]) {
                case 'a': mask ^= (1 << 0); break;
                case 'e': mask ^= (1 << 1); break;
                case 'i': mask ^= (1 << 2); break;
                case 'o': mask ^= (1 << 3); break;
                case 'u': mask ^= (1 << 4); break;
            }
            if (earliest[mask] == int.MaxValue) earliest[mask] = i;
            else ans = Math.Max(ans, i - earliest[mask]);
        } 
        return ans;
    } 
}
```

```golang [sol1-Golang]
func findTheLongestSubstring(s string) int {
    ans, status := 0, 0
    pos := make([]int, 1 << 5)
    for i := 0; i < len(pos); i++ {
        pos[i] = -1
    }
    pos[0] = 0
    for i := 0; i < len(s); i++ {
        switch s[i] {
        case 'a':
            status ^= 1 << 0
        case 'e':
            status ^= 1 << 1
        case 'i':
            status ^= 1 << 2
        case 'o':
            status ^= 1 << 3
        case 'u':
            status ^= 1 << 4
        }
        if pos[status] >= 0 {
            ans = Max(ans, i + 1 - pos[status])
        } else {
            pos[status] = i + 1
        }
    }
    return ans
}

func Max(x, y int) int {
    if x > y {
        return x
    }
    return y
}
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 为字符串 $s$ 的长度。我们只需要遍历一遍字符串即可求得答案，因此时间复杂度为 $O(n)$。

- 空间复杂度：$O(S)$，其中 $S$ 表示元音字母压缩成一个状态数的最大值，在本题中 $S = 32$。我们需要对应 $S$ 大小的空间来存放每个状态第一次出现的位置，因此需要 $O(S)$ 的空间复杂度。
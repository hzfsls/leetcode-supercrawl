## [1781.所有子字符串美丽值之和 中文官方题解](https://leetcode.cn/problems/sum-of-beauty-of-all-substrings/solutions/100000/suo-you-zi-zi-fu-chuan-mei-li-zhi-zhi-he-rq3x)

#### 方法一：双层循环

**思路**

用两个下标 $i$ 和 $j$ 表示子字符串的两端。用双层循环来遍历所有子字符串，第一层循环子字符串的起点 $i$，第二层循环固定 $i$，遍历子字符串的重点 $j$，遍历时维护更新用来记录字符频率的哈希表，并计算美丽值。

**代码**

```Python [sol1-Python3]
class Solution:
    def beautySum(self, s: str) -> int:
        res = 0
        for i in range(len(s)):
            cnt = Counter()
            mx = 0
            for j in range(i, len(s)):
                cnt[s[j]] += 1
                mx = max(mx, cnt[s[j]])
                res += mx - min(cnt.values())
        return res
```

```C++ [sol1-C++]
class Solution {
public:
    int beautySum(string s) {
        int res = 0;
        for (int i = 0; i < s.size(); i++) {
            vector<int> cnt(26);
            int maxFreq = 0;
            for (int j = i; j < s.size(); j++) {
                cnt[s[j] - 'a']++;
                maxFreq = max(maxFreq, cnt[s[j] - 'a']); 
                int minFreq = s.size();
                for (int k = 0; k < 26; k++) {
                    if (cnt[k] > 0) {
                        minFreq = min(minFreq, cnt[k]);
                    }
                }
                res += maxFreq - minFreq;
            }
        }
        return res;
    }
};
```

```Java [sol1-Java]
class Solution {
    public int beautySum(String s) {
        int res = 0;
        for (int i = 0; i < s.length(); i++) {
            int[] cnt = new int[26];
            int maxFreq = 0;
            for (int j = i; j < s.length(); j++) {
                cnt[s.charAt(j) - 'a']++;
                maxFreq = Math.max(maxFreq, cnt[s.charAt(j) - 'a']);
                int minFreq = s.length();
                for (int k = 0; k < 26; k++) {
                    if (cnt[k] > 0) {
                        minFreq = Math.min(minFreq, cnt[k]);
                    }
                }
                res += maxFreq - minFreq;
            }
        }
        return res;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int BeautySum(string s) {
        int res = 0;
        for (int i = 0; i < s.Length; i++) {
            int[] cnt = new int[26];
            int maxFreq = 0;
            for (int j = i; j < s.Length; j++) {
                cnt[s[j] - 'a']++;
                maxFreq = Math.Max(maxFreq, cnt[s[j] - 'a']);
                int minFreq = s.Length;
                for (int k = 0; k < 26; k++) {
                    if (cnt[k] > 0) {
                        minFreq = Math.Min(minFreq, cnt[k]);
                    }
                }
                res += maxFreq - minFreq;
            }
        }
        return res;
    }
}
```

```C [sol1-C]
#define MAX(a, b) ((a) > (b) ? (a) : (b))
#define MIN(a, b) ((a) < (b) ? (a) : (b))

int beautySum(char * s) {
    int res = 0, len = strlen(s);
    for (int i = 0; i < len; i++) {
        int cnt[26];
        memset(cnt, 0, sizeof(cnt));
        int maxFreq = 0;
        for (int j = i; j < len; j++) {
            cnt[s[j] - 'a']++;
            maxFreq = MAX(maxFreq, cnt[s[j] - 'a']);
            int minFreq = len;
            for (int k = 0; k < 26; k++) {
                if (cnt[k] > 0) {
                    minFreq = MIN(minFreq, cnt[k]);
                }
            }
            res += maxFreq - minFreq;
        }
    }
    return res;
}
```

```JavaScript [sol1-JavaScript]
var beautySum = function(s) {
    let res = 0;
    for (let i = 0; i < s.length; i++) {
        const cnt = new Array(26).fill(0);
        let maxFreq = 0;
        for (let j = i; j < s.length; j++) {
            cnt[s[j].charCodeAt() - 'a'.charCodeAt()]++;
            maxFreq = Math.max(maxFreq, cnt[s[j].charCodeAt() - 'a'.charCodeAt()]);
            let minFreq = s.length;
            for (let k = 0; k < 26; k++) {
                if (cnt[k] > 0) {
                    minFreq = Math.min(minFreq, cnt[k]);
                }
            }
            res += maxFreq - minFreq;
        }
    }
    return res;
};
```

```go [sol1-Golang]
func beautySum(s string) (ans int) {
    for i := range s {
        cnt := [26]int{}
        maxFreq := 0
        for _, c := range s[i:] {
            cnt[c-'a']++
            maxFreq = max(maxFreq, cnt[c-'a'])
            minFreq := len(s)
            for _, c := range cnt {
                if c > 0 {
                    minFreq = min(minFreq, c)
                }
            }
            ans += maxFreq - minFreq
        }
    }
    return
}

func min(a, b int) int {
    if a < b {
        return a
    }
    return b
}

func max(a, b int) int {
    if a > b {
        return a
    }
    return b
}
```

**复杂度分析**

- 时间复杂度：$O(C\times n^2)$，其中 $C$ 是 $s$ 的元素种类，$n$ 是 $s$ 的长度。

- 空间复杂度：$O(C)$。
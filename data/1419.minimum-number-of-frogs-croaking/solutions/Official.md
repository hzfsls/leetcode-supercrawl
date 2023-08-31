## [1419.数青蛙 中文官方题解](https://leetcode.cn/problems/minimum-number-of-frogs-croaking/solutions/100000/shu-qing-wa-by-leetcode-solution-o532)

#### 方法一：计数

**思路与算法**

题目给出一个字符串 $\textit{croakOfFrogs}$，它表示不同青蛙发出的蛙鸣声的组合，且字符串中只包含 $\text{`c'}$，$\text{`r'}$，$\text{`o'}$，$\text{`a'}$ 和 $\text{`k'}$ 五种字符。若一只青蛙想要发出蛙鸣，则该青蛙需要依序输出 $\text{`c'}$，$\text{`r'}$，$\text{`o'}$，$\text{`a'}$ 和 $\text{`k'}$ 这 $5$ 个字符。如果没有输出全部五个字符，那么它就不会发出声音。现在我们需要求得能模拟出字符串 $\textit{croakOfFrogs}$ 中所有蛙鸣所需青蛙的最少数目，其中同一时间可以有多只青蛙发出声音。若字符串 $\textit{croakOfFrogs}$ 不能被若干有效的蛙鸣混合而成，则返回 $-1$。

现在我们用 $\textit{frog\_num}$ 来表示现在正在发出蛙鸣声的青蛙数目，用 $\textit{cnt}[c]$ 表示已经发出一次有效蛙鸣中的字符 $c$ 的青蛙个数，比如当 $\textit{cnt}[\text{`c'}] = 2$ 时表示当前有 $2$ 只青蛙已经发出了有效蛙鸣中的字符 $\text{`c'}$，下一个需要发出字符 $\text{`r'}$。那么我们遍历字符串 $\textit{croakOfFrogs}$ 来模拟青蛙蛙鸣，现在记遍历到的字符为 $c$，有：

- 若 $c = \text{`c'}$，则需要一只青蛙开始发出蛙鸣，有 $\textit{fog\_num} = \textit{fog\_num} + 1$，$\textit{cnt}[\text{`c'}] = \textit{cnt}[\text{`c'}] + 1$。
- 否则我们记 $\textit{prec}$ 为一次有效蛙鸣中该字符 $c$ 的前一个字符
  - 若当前 $\textit{cnt}[\textit{prec}] = 0$，即没有青蛙可以发出字符 $c$，直接返回 $-1$。
  - 否则 $\textit{cnt}[\textit{prec}] = \textit{cnt}[\textit{prec}] - 1$，$\textit{cnt}[\textit{c}] = \textit{cnt}[\textit{c}] + 1$。且当 $c = \text{`k'}$ 时，说明一只青蛙完成了完整的一次蛙鸣，此时正在发出蛙鸣声的青蛙数目减一，有：$\textit{fog\_num} = \textit{fog\_num} - 1$。

若遍历完还有正在发出蛙鸣的青蛙，即 $\textit{fog\_num} > 0$，说明 $\textit{croakOfFrogs}$ 不是被若干有效的蛙鸣混合而成，直接返回 $-1$。否则我们只需要返回在遍历的过程中正在发出蛙鸣的青蛙数目的最大值即可。

**代码**

```Python [sol1-Python3]
class Solution:
    def minNumberOfFrogs(self, croakOfFrogs: str) -> int:
        if len(croakOfFrogs) % 5:
            return -1
        res, frog_num = 0, 0
        cnt = [0] * 4
        mp = {'c':0, 'r':1, 'o':2, 'a':3, 'k':4}
        for c in croakOfFrogs:
            t = mp[c]
            if t == 0:
                cnt[t] += 1
                frog_num += 1
                if frog_num > res:
                    res = frog_num
            else:
                if cnt[t - 1] == 0:
                    return -1
                cnt[t - 1] -= 1
                if t == 4:
                    frog_num -= 1
                else:
                    cnt[t] += 1
        if frog_num > 0:
            return -1
        return res
```

```Java [sol1-Java]
class Solution {
    public int minNumberOfFrogs(String croakOfFrogs) {
        if (croakOfFrogs.length() % 5 != 0) {
            return -1;
        }
        int res = 0, frogNum = 0;
        int[] cnt = new int[4];
        Map<Character, Integer> map = new HashMap<Character, Integer>() {{
            put('c', 0);
            put('r', 1);
            put('o', 2);
            put('a', 3);
            put('k', 4);
        }};
        for (int i = 0; i < croakOfFrogs.length(); i++) {
            char c = croakOfFrogs.charAt(i);
            int t = map.get(c);
            if (t == 0) {
                cnt[t]++;
                frogNum++;
                if (frogNum > res) {
                    res = frogNum;
                }
            } else {
                if (cnt[t - 1] == 0) {
                    return -1;
                }
                cnt[t - 1]--;
                if (t == 4) {
                    frogNum--;
                } else {
                    cnt[t]++;
                }
            }
        }
        if (frogNum > 0) {
            return -1;
        }
        return res;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int MinNumberOfFrogs(string croakOfFrogs) {
        if (croakOfFrogs.Length % 5 != 0) {
            return -1;
        }
        int res = 0, frogNum = 0;
        int[] cnt = new int[4];
        IDictionary<char, int> dictionary = new Dictionary<char, int>() {
            {'c', 0}, {'r', 1}, {'o', 2}, {'a', 3}, {'k', 4}
        };
        foreach (char c in croakOfFrogs) {
            int t = dictionary[c];
            if (t == 0) {
                cnt[t]++;
                frogNum++;
                if (frogNum > res) {
                    res = frogNum;
                }
            } else {
                if (cnt[t - 1] == 0) {
                    return -1;
                }
                cnt[t - 1]--;
                if (t == 4) {
                    frogNum--;
                } else {
                    cnt[t]++;
                }
            }
        }
        if (frogNum > 0) {
            return -1;
        }
        return res;
    }
}
```

```C++ [sol1-C++]
class Solution {
public:
    int minNumberOfFrogs(string croakOfFrogs) {
        if (croakOfFrogs.size() % 5 != 0) {
            return -1;
        }
        int res = 0, frogNum = 0;
        vector<int> cnt(4);
        unordered_map<char, int> mp = {{'c', 0}, {'r', 1}, {'o', 2}, {'a', 3}, {'k', 4}};
        for (char c : croakOfFrogs) {
            int t = mp[c];
            if (t == 0) {
                cnt[t]++;
                frogNum++;
                if (frogNum > res) {
                    res = frogNum;
                }
            } else {
                if (cnt[t - 1] == 0) {
                    return -1;
                }
                cnt[t - 1]--;
                if (t == 4) {
                    frogNum--;
                } else {
                    cnt[t]++;
                }
            }
        }
        if (frogNum > 0) {
            return -1;
        }
        return res;
    }
};
```

```C [sol1-C]
int minNumberOfFrogs(char * croakOfFrogs) {
    int len = strlen(croakOfFrogs);
    if (len % 5 != 0) {
        return -1;
    }
    int res = 0, frogNum = 0;
    int cnt[4], map[26];
    memset(cnt, 0, sizeof(cnt));
    map['c' - 'a'] = 0;
    map['r' - 'a'] = 1;
    map['o' - 'a'] = 2;
    map['a' - 'a'] = 3;
    map['k' - 'a'] = 4;
    for (int i = 0; i < len; i++) {
        char c = croakOfFrogs[i];
        int t = map[c - 'a'];
        if (t == 0) {
            cnt[t]++;
            frogNum++;
            if (frogNum > res) {
                res = frogNum;
            }
        } else {
            if (cnt[t - 1] == 0) {
                return -1;
            }
            cnt[t - 1]--;
            if (t == 4) {
                frogNum--;
            } else {
                cnt[t]++;
            }
        }
    }
    if (frogNum > 0) {
        return -1;
    }
    return res;
}
```

```JavaScript [sol1-JavaScript]
var minNumberOfFrogs = function(croakOfFrogs) {
    if (croakOfFrogs.length % 5 !== 0) {
        return -1;
    }
    let res = 0, frogNum = 0;
    const cnt = new Array(4).fill(0);
    const map = new Map();
    map.set('c', 0);
    map.set('r', 1);
    map.set('o', 2);
    map.set('a', 3);
    map.set('k', 4);
    for (let i = 0; i < croakOfFrogs.length; i++) {
        const c = croakOfFrogs[i];
        const t = map.get(c);
        if (t === 0) {
            cnt[t]++;
            frogNum++;
            if (frogNum > res) {
                res = frogNum;
            }
        } else {
            if (cnt[t - 1] === 0) {
                return -1;
            }
            cnt[t - 1]--;
            if (t === 4) {
                frogNum--;
            } else {
                cnt[t]++;
            }
        }
    }
    if (frogNum > 0) {
        return -1;
    }
    return res;
};
```

```go [sol1-Golang]
func minNumberOfFrogs(croakOfFrogs string) int {
    if len(croakOfFrogs)%5 != 0 {
        return -1
    }
    res := 0
    frogNum := 0
    cnt := make([]int, 4)
    mp := map[rune]int{'c': 0, 'r': 1, 'o': 2, 'a': 3, 'k': 4}
    for _, c := range croakOfFrogs {
        t := mp[c]
        if t == 0 {
            cnt[t]++
            frogNum++
            if frogNum > res {
                res = frogNum
            }
        } else {
            if cnt[t-1] == 0 {
                return -1
            }
            cnt[t-1]--
            if t == 4 {
                frogNum--
            } else {
                cnt[t]++
            }
        }
    }
    if frogNum > 0 {
        return -1
    }
    return res
}
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 为字符串 $\textit{croakOfFrogs}$ 的长度。
- 空间复杂度：$O(1)$，仅使用常量空间。
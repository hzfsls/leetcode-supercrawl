## [423.从英文中重建数字 中文官方题解](https://leetcode.cn/problems/reconstruct-original-digits-from-english/solutions/100000/cong-ying-wen-zhong-zhong-jian-shu-zi-by-9g1r)

#### 方法一：依次确定每一个数字的次数

**思路与算法**

首先我们可以统计每个字母分别在哪些数字中出现：

| 字母 | 数字 |
| :-: | :-:|
| e | 0 1 3 5 7 8 9 |
| f | 4 5 |
| g | 8 |
| h | 3 8 |
| i | 5 6 8 9 |
| n | 1 7 9 |
| o | 0 1 2 4 |
| r | 0 3 4 |
| s | 6 7 |
| t | 2 3 8 |
| u | 4 |
| v | 5 7 |
| w | 2 |
| x | 6 |
| z | 0 |

可以发现，$\text{z, w, u, x, g}$ 都只在一个数字中，即 $0, 2, 4, 6, 8$ 中出现。因此我们可以使用一个哈希表统计每个字母出现的次数，那么 $\text{z, w, u, x, g}$ 出现的次数，即分别为 $0, 2, 4, 6, 8$ 出现的次数。

随后我们可以注意那些只在两个数字中出现的字符：

- $\text{h}$ 只在 $3, 8$ 中出现。由于我们已经知道了 $8$ 出现的次数，因此可以计算出 $3$ 出现的次数。

- $\text{f}$ 只在 $4, 5$ 中出现。由于我们已经知道了 $4$ 出现的次数，因此可以计算出 $5$ 出现的次数。

- $\text{s}$ 只在 $6, 7$ 中出现。由于我们已经知道了 $6$ 出现的次数，因此可以计算出 $7$ 出现的次数。

此时，我们还剩下 $1$ 和 $9$ 的出现次数没有求出：

- $\text{o}$ 只在 $0, 1, 2, 4$ 中出现，由于我们已经知道了 $0, 2, 4$ 出现的次数，因此可以计算出 $1$ 出现的次数。

最后的 $9$ 就可以通过 $\text{n, i, e}$ 中的任一字符计算得到了。这里推荐使用 $\text{i}$ 进行计算，因为 $\text{n}$ 在 $9$ 中出现了 $2$ 次，$\text{e}$ 在 $3$ 中出现了 $2$ 次，容易在计算中遗漏。

当我们统计完每个数字出现的次数后，我们按照升序将它们进行拼接即可。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    string originalDigits(string s) {
        unordered_map<char, int> c;
        for (char ch: s) {
            ++c[ch];
        }

        vector<int> cnt(10);
        cnt[0] = c['z'];
        cnt[2] = c['w'];
        cnt[4] = c['u'];
        cnt[6] = c['x'];
        cnt[8] = c['g'];

        cnt[3] = c['h'] - cnt[8];
        cnt[5] = c['f'] - cnt[4];
        cnt[7] = c['s'] - cnt[6];

        cnt[1] = c['o'] - cnt[0] - cnt[2] - cnt[4];

        cnt[9] = c['i'] - cnt[5] - cnt[6] - cnt[8];

        string ans;
        for (int i = 0; i < 10; ++i) {
            for (int j = 0; j < cnt[i]; ++j) {
                ans += char(i + '0');
            }
        }
        return ans;
    }
};
```

```Java [sol1-Java]
class Solution {
    public String originalDigits(String s) {
        Map<Character, Integer> c = new HashMap<Character, Integer>();
        for (int i = 0; i < s.length(); ++i) {
            char ch = s.charAt(i);
            c.put(ch, c.getOrDefault(ch, 0) + 1);
        }

        int[] cnt = new int[10];
        cnt[0] = c.getOrDefault('z', 0);
        cnt[2] = c.getOrDefault('w', 0);
        cnt[4] = c.getOrDefault('u', 0);
        cnt[6] = c.getOrDefault('x', 0);
        cnt[8] = c.getOrDefault('g', 0);

        cnt[3] = c.getOrDefault('h', 0) - cnt[8];
        cnt[5] = c.getOrDefault('f', 0) - cnt[4];
        cnt[7] = c.getOrDefault('s', 0) - cnt[6];

        cnt[1] = c.getOrDefault('o', 0) - cnt[0] - cnt[2] - cnt[4];

        cnt[9] = c.getOrDefault('i', 0) - cnt[5] - cnt[6] - cnt[8];

        StringBuffer ans = new StringBuffer();
        for (int i = 0; i < 10; ++i) {
            for (int j = 0; j < cnt[i]; ++j) {
                ans.append((char) (i + '0'));
            }
        }
        return ans.toString();
    }
}
```

```C# [sol1-C#]
public class Solution {
    public string OriginalDigits(string s) {
        Dictionary<char, int> c = new Dictionary<char, int>();
        foreach (char ch in s) {
            if (!c.ContainsKey(ch)) {
                c.Add(ch, 0);
            }
            ++c[ch];
        }

        int[] cnt = new int[10];
        cnt[0] = c.ContainsKey('z') ? c['z'] : 0;
        cnt[2] = c.ContainsKey('w') ? c['w'] : 0;
        cnt[4] = c.ContainsKey('u') ? c['u'] : 0;
        cnt[6] = c.ContainsKey('x') ? c['x'] : 0;
        cnt[8] = c.ContainsKey('g') ? c['g'] : 0;

        cnt[3] = (c.ContainsKey('h') ? c['h'] : 0) - cnt[8];
        cnt[5] = (c.ContainsKey('f') ? c['f'] : 0) - cnt[4];
        cnt[7] = (c.ContainsKey('s') ? c['s'] : 0) - cnt[6];

        cnt[1] = (c.ContainsKey('o') ? c['o'] : 0) - cnt[0] - cnt[2] - cnt[4];

        cnt[9] = (c.ContainsKey('i') ? c['i'] : 0) - cnt[5] - cnt[6] - cnt[8];

        StringBuilder ans = new StringBuilder();
        for (int i = 0; i < 10; ++i) {
            for (int j = 0; j < cnt[i]; ++j) {
                ans.Append((char) (i + '0'));
            }
        }
        return ans.ToString();
    }
}
```

```Python [sol1-Python3]
class Solution:
    def originalDigits(self, s: str) -> str:
        c = Counter(s)

        cnt = [0] * 10
        cnt[0] = c["z"]
        cnt[2] = c["w"]
        cnt[4] = c["u"]
        cnt[6] = c["x"]
        cnt[8] = c["g"]

        cnt[3] = c["h"] - cnt[8]
        cnt[5] = c["f"] - cnt[4]
        cnt[7] = c["s"] - cnt[6]
        
        cnt[1] = c["o"] - cnt[0] - cnt[2] - cnt[4]

        cnt[9] = c["i"] - cnt[5] - cnt[6] - cnt[8]

        return "".join(str(x) * cnt[x] for x in range(10))
```

```go [sol1-Golang]
func originalDigits(s string) string {
    c := map[rune]int{}
    for _, ch := range s {
        c[ch]++
    }

    cnt := [10]int{}
    cnt[0] = c['z']
    cnt[2] = c['w']
    cnt[4] = c['u']
    cnt[6] = c['x']
    cnt[8] = c['g']

    cnt[3] = c['h'] - cnt[8]
    cnt[5] = c['f'] - cnt[4]
    cnt[7] = c['s'] - cnt[6]

    cnt[1] = c['o'] - cnt[0] - cnt[2] - cnt[4]

    cnt[9] = c['i'] - cnt[5] - cnt[6] - cnt[8]

    ans := []byte{}
    for i, c := range cnt {
        ans = append(ans, bytes.Repeat([]byte{byte('0' + i)}, c)...)
    }
    return string(ans)
}
```

```JavaScript [sol1-JavaScript]
var originalDigits = function(s) {
    const c = new Map();
    for (const ch of s) {
        c.set(ch, (c.get(ch) || 0) + 1);
    }

    const cnt = new Array(10).fill(0);
    cnt[0] = c.get('z') || 0;
    cnt[2] = c.get('w') || 0;
    cnt[4] = c.get('u') || 0;
    cnt[6] = c.get('x') || 0;
    cnt[8] = c.get('g') || 0;

    cnt[3] = (c.get('h') || 0) - cnt[8];
    cnt[5] = (c.get('f') || 0) - cnt[4];
    cnt[7] = (c.get('s') || 0) - cnt[6];

    cnt[1] = (c.get('o') || 0) - cnt[0] - cnt[2] - cnt[4];

    cnt[9] = (c.get('i') || 0) - cnt[5] - cnt[6] - cnt[8];

    const ans = [];
    for (let i = 0; i < 10; ++i) {
        for (let j = 0; j < cnt[i]; ++j) {
            ans.push(String.fromCharCode(i + '0'.charCodeAt()));
        }
    }
    return ans.join('');
};
```

**复杂度分析**

- 时间复杂度：$O(|s|)$，其中 $|s|$ 是字符串 $s$ 的长度。

- 空间复杂度：$O(|\Sigma|)$，其中 $\Sigma$ 表示字符集，$|\Sigma|$ 表示字符集的大小，在本题中 $\Sigma$ 为所有在 $0 \sim 9$ 中出现的英文字母。
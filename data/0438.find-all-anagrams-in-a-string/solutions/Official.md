## [438.找到字符串中所有字母异位词 中文官方题解](https://leetcode.cn/problems/find-all-anagrams-in-a-string/solutions/100000/zhao-dao-zi-fu-chuan-zhong-suo-you-zi-mu-xzin)
#### 方法一：滑动窗口

**思路**

根据题目要求，我们需要在字符串 $s$ 寻找字符串 $p$ 的异位词。因为字符串 $p$ 的异位词的长度一定与字符串 $p$ 的长度相同，所以我们可以在字符串 $s$ 中构造一个长度为与字符串 $p$ 的长度相同的滑动窗口，并在滑动中维护窗口中每种字母的数量；当窗口中每种字母的数量与字符串 $p$ 中每种字母的数量相同时，则说明当前窗口为字符串 $p$ 的异位词。

**算法**

在算法的实现中，我们可以使用数组来存储字符串 $p$ 和滑动窗口中每种字母的数量。

**细节**

当字符串 $s$ 的长度小于字符串 $p$ 的长度时，字符串 $s$ 中一定不存在字符串 $p$ 的异位词。但是因为字符串 $s$ 中无法构造长度与字符串 $p$ 的长度相同的窗口，所以这种情况需要单独处理。

**代码**

```Python [sol1-Python3]
class Solution:
    def findAnagrams(self, s: str, p: str) -> List[int]:
        s_len, p_len = len(s), len(p)
        
        if s_len < p_len:
            return []

        ans = []
        s_count = [0] * 26
        p_count = [0] * 26
        for i in range(p_len):
            s_count[ord(s[i]) - 97] += 1
            p_count[ord(p[i]) - 97] += 1

        if s_count == p_count:
            ans.append(0)

        for i in range(s_len - p_len):
            s_count[ord(s[i]) - 97] -= 1
            s_count[ord(s[i + p_len]) - 97] += 1
            
            if s_count == p_count:
                ans.append(i + 1)

        return ans
```

```Java [sol1-Java]
class Solution {
    public List<Integer> findAnagrams(String s, String p) {
        int sLen = s.length(), pLen = p.length();

        if (sLen < pLen) {
            return new ArrayList<Integer>();
        }

        List<Integer> ans = new ArrayList<Integer>();
        int[] sCount = new int[26];
        int[] pCount = new int[26];
        for (int i = 0; i < pLen; ++i) {
            ++sCount[s.charAt(i) - 'a'];
            ++pCount[p.charAt(i) - 'a'];
        }

        if (Arrays.equals(sCount, pCount)) {
            ans.add(0);
        }

        for (int i = 0; i < sLen - pLen; ++i) {
            --sCount[s.charAt(i) - 'a'];
            ++sCount[s.charAt(i + pLen) - 'a'];

            if (Arrays.equals(sCount, pCount)) {
                ans.add(i + 1);
            }
        }

        return ans;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public IList<int> FindAnagrams(string s, string p) {
        int sLen = s.Length, pLen = p.Length;

        if (sLen < pLen) {
            return new List<int>();
        }

        IList<int> ans = new List<int>();
        int[] sCount = new int[26];
        int[] pCount = new int[26];
        for (int i = 0; i < pLen; ++i) {
            ++sCount[s[i] - 'a'];
            ++pCount[p[i] - 'a'];
        }

        if (Enumerable.SequenceEqual(sCount, pCount)) {
            ans.Add(0);
        }

        for (int i = 0; i < sLen - pLen; ++i) {
            --sCount[s[i] - 'a'];
            ++sCount[s[i + pLen] - 'a'];

            if (Enumerable.SequenceEqual(sCount, pCount)) {
                ans.Add(i + 1);
            }
        }

        return ans;
    }
}
```

```C++ [sol1-C++]
class Solution {
public:
    vector<int> findAnagrams(string s, string p) {
        int sLen = s.size(), pLen = p.size();

        if (sLen < pLen) {
            return vector<int>();
        }

        vector<int> ans;
        vector<int> sCount(26);
        vector<int> pCount(26);
        for (int i = 0; i < pLen; ++i) {
            ++sCount[s[i] - 'a'];
            ++pCount[p[i] - 'a'];
        }

        if (sCount == pCount) {
            ans.emplace_back(0);
        }

        for (int i = 0; i < sLen - pLen; ++i) {
            --sCount[s[i] - 'a'];
            ++sCount[s[i + pLen] - 'a'];

            if (sCount == pCount) {
                ans.emplace_back(i + 1);
            }
        }

        return ans;
    }
};
```

```go [sol1-Golang]
func findAnagrams(s, p string) (ans []int) {
    sLen, pLen := len(s), len(p)
    if sLen < pLen {
        return
    }

    var sCount, pCount [26]int
    for i, ch := range p {
        sCount[s[i]-'a']++
        pCount[ch-'a']++
    }
    if sCount == pCount {
        ans = append(ans, 0)
    }

    for i, ch := range s[:sLen-pLen] {
        sCount[ch-'a']--
        sCount[s[i+pLen]-'a']++
        if sCount == pCount {
            ans = append(ans, i+1)
        }
    }
    return
}
```

```JavaScript [sol1-JavaScript]
var findAnagrams = function(s, p) {
    const sLen = s.length, pLen = p.length;

    if (sLen < pLen) {
        return [];
    }

    const ans = [];
    const sCount = new Array(26).fill(0);
    const pCount = new Array(26).fill(0);
    for (let i = 0; i < pLen; ++i) {
        ++sCount[s[i].charCodeAt() - 'a'.charCodeAt()];
        ++pCount[p[i].charCodeAt() - 'a'.charCodeAt()];
    }

    if (sCount.toString() === pCount.toString()) {
        ans.push(0);
    }

    for (let i = 0; i < sLen - pLen; ++i) {
        --sCount[s[i].charCodeAt() - 'a'.charCodeAt()];
        ++sCount[s[i + pLen].charCodeAt() - 'a'.charCodeAt()];

        if (sCount.toString() === pCount.toString()) {
            ans.push(i + 1);
        }
    }

    return ans;
};
```

**复杂度分析**

- 时间复杂度：$O(m + (n-m) \times \Sigma)$，其中 $n$ 为字符串 $s$ 的长度，$m$ 为字符串 $p$ 的长度，$\Sigma$ 为所有可能的字符数。我们需要 $O(m)$ 来统计字符串 $p$ 中每种字母的数量；需要 $O(m)$ 来初始化滑动窗口；需要判断 $n-m+1$ 个滑动窗口中每种字母的数量是否与字符串 $p$ 中每种字母的数量相同，每次判断需要 $O(\Sigma)$ 。因为 $s$ 和 $p$ 仅包含小写字母，所以 $\Sigma = 26$。

- 空间复杂度：$O(\Sigma)$。用于存储字符串 $p$ 和滑动窗口中每种字母的数量。

#### 方法二：优化的滑动窗口

**思路和算法**

在方法一的基础上，我们不再分别统计滑动窗口和字符串 $p$ 中每种字母的数量，而是统计滑动窗口和字符串 $p$ 中每种字母数量的差；并引入变量 $\textit{differ}$ 来记录当前窗口与字符串 $p$ 中数量不同的字母的个数，并在滑动窗口的过程中维护它。

在判断滑动窗口中每种字母的数量与字符串 $p$ 中每种字母的数量是否相同时，只需要判断 $\textit{differ}$ 是否为零即可。

**代码**

```Python [sol2-Python3]
class Solution:
    def findAnagrams(self, s: str, p: str) -> List[int]:
        s_len, p_len = len(s), len(p)

        if s_len < p_len:
            return []

        ans = []
        count = [0] * 26
        for i in range(p_len):
            count[ord(s[i]) - 97] += 1
            count[ord(p[i]) - 97] -= 1

        differ = [c != 0 for c in count].count(True)

        if differ == 0:
            ans.append(0)

        for i in range(s_len - p_len):
            if count[ord(s[i]) - 97] == 1:  # 窗口中字母 s[i] 的数量与字符串 p 中的数量从不同变得相同
                differ -= 1
            elif count[ord(s[i]) - 97] == 0:  # 窗口中字母 s[i] 的数量与字符串 p 中的数量从相同变得不同
                differ += 1
            count[ord(s[i]) - 97] -= 1

            if count[ord(s[i + p_len]) - 97] == -1:  # 窗口中字母 s[i+p_len] 的数量与字符串 p 中的数量从不同变得相同
                differ -= 1
            elif count[ord(s[i + p_len]) - 97] == 0:  # 窗口中字母 s[i+p_len] 的数量与字符串 p 中的数量从相同变得不同
                differ += 1
            count[ord(s[i + p_len]) - 97] += 1
            
            if differ == 0:
                ans.append(i + 1)

        return ans
```

```Java [sol2-Java]
class Solution {
    public List<Integer> findAnagrams(String s, String p) {
        int sLen = s.length(), pLen = p.length();

        if (sLen < pLen) {
            return new ArrayList<Integer>();
        }

        List<Integer> ans = new ArrayList<Integer>();
        int[] count = new int[26];
        for (int i = 0; i < pLen; ++i) {
            ++count[s.charAt(i) - 'a'];
            --count[p.charAt(i) - 'a'];
        }

        int differ = 0;
        for (int j = 0; j < 26; ++j) {
            if (count[j] != 0) {
                ++differ;
            }
        }

        if (differ == 0) {
            ans.add(0);
        }

        for (int i = 0; i < sLen - pLen; ++i) {
            if (count[s.charAt(i) - 'a'] == 1) {  // 窗口中字母 s[i] 的数量与字符串 p 中的数量从不同变得相同
                --differ;
            } else if (count[s.charAt(i) - 'a'] == 0) {  // 窗口中字母 s[i] 的数量与字符串 p 中的数量从相同变得不同
                ++differ;
            }
            --count[s.charAt(i) - 'a'];

            if (count[s.charAt(i + pLen) - 'a'] == -1) {  // 窗口中字母 s[i+pLen] 的数量与字符串 p 中的数量从不同变得相同
                --differ;
            } else if (count[s.charAt(i + pLen) - 'a'] == 0) {  // 窗口中字母 s[i+pLen] 的数量与字符串 p 中的数量从相同变得不同
                ++differ;
            }
            ++count[s.charAt(i + pLen) - 'a'];
            
            if (differ == 0) {
                ans.add(i + 1);
            }
        }

        return ans;
    }
}
```

```C# [sol2-C#]
public class Solution {
    public IList<int> FindAnagrams(string s, string p) {
        int sLen = s.Length, pLen = p.Length;

        if (sLen < pLen) {
            return new List<int>();
        }

        IList<int> ans = new List<int>();
        int[] count = new int[26];
        for (int i = 0; i < pLen; ++i) {
            ++count[s[i] - 'a'];
            --count[p[i] - 'a'];
        }

        int differ = 0;
        for (int j = 0; j < 26; ++j) {
            if (count[j] != 0) {
                ++differ;
            }
        }

        if (differ == 0) {
            ans.Add(0);
        }

        for (int i = 0; i < sLen - pLen; ++i) {
            if (count[s[i] - 'a'] == 1) {  // 窗口中字母 s[i] 的数量与字符串 p 中的数量从不同变得相同
                --differ;
            } else if (count[s[i] - 'a'] == 0) {  // 窗口中字母 s[i] 的数量与字符串 p 中的数量从相同变得不同
                ++differ;
            }
            --count[s[i] - 'a'];

            if (count[s[i + pLen] - 'a'] == -1) {  // 窗口中字母 s[i+pLen] 的数量与字符串 p 中的数量从不同变得相同
                --differ;
            } else if (count[s[i + pLen] - 'a'] == 0) {  // 窗口中字母 s[i+pLen] 的数量与字符串 p 中的数量从相同变得不同
                ++differ;
            }
            ++count[s[i + pLen] - 'a'];
            
            if (differ == 0) {
                ans.Add(i + 1);
            }
        }

        return ans;
    }
}
```

```C++ [sol2-C++]
class Solution {
public:
    vector<int> findAnagrams(string s, string p) {
        int sLen = s.size(), pLen = p.size();

        if (sLen < pLen) {
            return vector<int>();
        }

        vector<int> ans;
        vector<int> count(26);
        for (int i = 0; i < pLen; ++i) {
            ++count[s[i] - 'a'];
            --count[p[i] - 'a'];
        }

        int differ = 0;
        for (int j = 0; j < 26; ++j) {
            if (count[j] != 0) {
                ++differ;
            }
        }

        if (differ == 0) {
            ans.emplace_back(0);
        }

        for (int i = 0; i < sLen - pLen; ++i) {
            if (count[s[i] - 'a'] == 1) {  // 窗口中字母 s[i] 的数量与字符串 p 中的数量从不同变得相同
                --differ;
            } else if (count[s[i] - 'a'] == 0) {  // 窗口中字母 s[i] 的数量与字符串 p 中的数量从相同变得不同
                ++differ;
            }
            --count[s[i] - 'a'];

            if (count[s[i + pLen] - 'a'] == -1) {  // 窗口中字母 s[i+pLen] 的数量与字符串 p 中的数量从不同变得相同
                --differ;
            } else if (count[s[i + pLen] - 'a'] == 0) {  // 窗口中字母 s[i+pLen] 的数量与字符串 p 中的数量从相同变得不同
                ++differ;
            }
            ++count[s[i + pLen] - 'a'];
            
            if (differ == 0) {
                ans.emplace_back(i + 1);
            }
        }

        return ans;
    }
};
```

```go [sol2-Golang]
func findAnagrams(s, p string) (ans []int) {
    sLen, pLen := len(s), len(p)
    if sLen < pLen {
        return
    }

    count := [26]int{}
    for i, ch := range p {
        count[s[i]-'a']++
        count[ch-'a']--
    }

    differ := 0
    for _, c := range count {
        if c != 0 {
            differ++
        }
    }
    if differ == 0 {
        ans = append(ans, 0)
    }

    for i, ch := range s[:sLen-pLen] {
        if count[ch-'a'] == 1 { // 窗口中字母 s[i] 的数量与字符串 p 中的数量从不同变得相同
            differ--
        } else if count[ch-'a'] == 0 { // 窗口中字母 s[i] 的数量与字符串 p 中的数量从相同变得不同
            differ++
        }
        count[ch-'a']--

        if count[s[i+pLen]-'a'] == -1 { // 窗口中字母 s[i+pLen] 的数量与字符串 p 中的数量从不同变得相同
            differ--
        } else if count[s[i+pLen]-'a'] == 0 { // 窗口中字母 s[i+pLen] 的数量与字符串 p 中的数量从相同变得不同
            differ++
        }
        count[s[i+pLen]-'a']++

        if differ == 0 {
            ans = append(ans, i+1)
        }
    }
    return
}
```

```JavaScript [sol2-JavaScript]
var findAnagrams = function(s, p) {
    const sLen = s.length, pLen = p.length;

    if (sLen < pLen) {
        return [];
    }

    const ans = [];
    const count = Array(26).fill(0);
    for (let i = 0; i < pLen; ++i) {
        ++count[s[i].charCodeAt() - 'a'.charCodeAt()];
        --count[p[i].charCodeAt() - 'a'.charCodeAt()];
    }

    let differ = 0;
    for (let j = 0; j < 26; ++j) {
        if (count[j] !== 0) {
            ++differ;
        }
    }

    if (differ === 0) {
        ans.push(0);
    }

    for (let i = 0; i < sLen - pLen; ++i) {
        if (count[s[i].charCodeAt() - 'a'.charCodeAt()] === 1) {  // 窗口中字母 s[i] 的数量与字符串 p 中的数量从不同变得相同
            --differ;
        } else if (count[s[i].charCodeAt() - 'a'.charCodeAt()] === 0) {  // 窗口中字母 s[i] 的数量与字符串 p 中的数量从相同变得不同
            ++differ;
        }
        --count[s[i].charCodeAt() - 'a'.charCodeAt()];

        if (count[s[i + pLen].charCodeAt() - 'a'.charCodeAt()] === -1) {  // 窗口中字母 s[i+pLen] 的数量与字符串 p 中的数量从不同变得相同
            --differ;
        } else if (count[s[i + pLen].charCodeAt() - 'a'.charCodeAt()] === 0) {  // 窗口中字母 s[i+pLen] 的数量与字符串 p 中的数量从相同变得不同
            ++differ;
        }
        ++count[s[i + pLen].charCodeAt() - 'a'.charCodeAt()];

        if (differ === 0) {
            ans.push(i + 1);
        }
    }

    return ans;
};
```

**复杂度分析**

- 时间复杂度：$O(n+m+\Sigma)$，其中 $n$ 为字符串 $s$ 的长度，$m$ 为字符串 $p$ 的长度，其中$\Sigma$ 为所有可能的字符数。我们需要 $O(m)$ 来统计字符串 $p$ 中每种字母的数量；需要 $O(m)$ 来初始化滑动窗口；需要 $O(\Sigma)$ 来初始化 $\textit{differ}$；需要 $O(n-m)$ 来滑动窗口并判断窗口内每种字母的数量是否与字符串 $p$ 中每种字母的数量相同，每次判断需要 $O(1)$ 。因为 $s$ 和 $p$ 仅包含小写字母，所以 $\Sigma = 26$。

- 空间复杂度：$O(\Sigma)$。用于存储滑动窗口和字符串 $p$ 中每种字母数量的差。
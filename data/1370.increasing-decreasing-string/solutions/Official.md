## [1370.上升下降字符串 中文官方题解](https://leetcode.cn/problems/increasing-decreasing-string/solutions/100000/shang-sheng-xia-jiang-zi-fu-chuan-by-leetcode-solu)

#### 方法一：桶计数

**思路及解法**

仔细分析步骤，我们发现：

1. 每个字符被选择且仅被选择一次；

2. 每一轮会在字符串末尾加入一个先升后降的字符串，且该串的上升部分和下降部分都会尽可能长。

于是我们重复若干轮下述操作，直到每一个字符都被选择过，这样就可以构造出这个字符串：

1. 先从未被选择的字符中提取出最长的上升字符串，将其加入答案。

2. 然后从未被选择的字符中提取出最长的下降字符串，将其加入答案。

注意到在构造时我们只关注字符本身，而不关注字符在原字符串中的位置。因此我们可以直接创建一个大小为 $26$ 的桶，记录每种字符的数量。每次提取最长的上升或下降字符串时，我们直接顺序或逆序遍历这个桶。

具体地，在遍历桶的过程中，如果当前桶的计数值不为零，那么将当前桶对应的字符加入到答案中，并将当前桶的计数值减一即可。我们重复这一过程，直到答案字符串的长度与传入的字符串的长度相等。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    string sortString(string s) {
        vector<int> num(26);
        for (char &ch : s) {
            num[ch - 'a']++;
        }

        string ret;
        while (ret.length() < s.length()) {
            for (int i = 0; i < 26; i++) {
                if (num[i]) {
                    ret.push_back(i + 'a');
                    num[i]--;
                }
            }
            for (int i = 25; i >= 0; i--) {
                if (num[i]) {
                    ret.push_back(i + 'a');
                    num[i]--;
                }
            }
        }
        return ret;
    }
};
```

```Java [sol1-Java]
class Solution {
    public String sortString(String s) {
        int[] num = new int[26];
        for (int i = 0; i < s.length(); i++) {
            num[s.charAt(i) - 'a']++;
        }

        StringBuffer ret = new StringBuffer();
        while (ret.length() < s.length()) {
            for (int i = 0; i < 26; i++) {
                if (num[i] > 0) {
                    ret.append((char) (i + 'a'));
                    num[i]--;
                }
            }
            for (int i = 25; i >= 0; i--) {
                if (num[i] > 0) {
                    ret.append((char) (i + 'a'));
                    num[i]--;
                }
            }
        }
        return ret.toString();
    }
}
```

```js [sol1-JavaScript]
var sortString = function(s) {
    const num = new Array(26).fill(0);
    for (let ch of s) {
        num[ch.charCodeAt() - 'a'.charCodeAt()]++;
    }

    let ret = '';
    while (ret.length < s.length) {
        for (let i = 0; i < 26; i++) {
            if (num[i]) {
                ret += String.fromCharCode(i + 'a'.charCodeAt());
                num[i]--;
            }
        }
        for (let i = 25; i >= 0; i--) {
            if (num[i]) {
                ret += String.fromCharCode(i + 'a'.charCodeAt());
                num[i]--;
            }
        }
    }
    return ret;
};
```

```Python [sol1-Python3]
class Solution:
    def sortString(self, s: str) -> str:
        num = [0] * 26
        for ch in s:
            num[ord(ch) - ord('a')] += 1
        
        ret = list()
        while len(ret) < len(s):
            for i in range(26):
                if num[i]:
                    ret.append(chr(i + ord('a')))
                    num[i] -= 1
            for i in range(25, -1, -1):
                if num[i]:
                    ret.append(chr(i + ord('a')))
                    num[i] -= 1

        return "".join(ret)
```

```Golang [sol1-Golang]
func sortString(s string) string {
    cnt := ['z' + 1]int{}
    for _, ch := range s {
        cnt[ch]++
    }
    n := len(s)
    ans := make([]byte, 0, n)
    for len(ans) < n {
        for i := byte('a'); i <= 'z'; i++ {
            if cnt[i] > 0 {
                ans = append(ans, i)
                cnt[i]--
            }
        }
        for i := byte('z'); i >= 'a'; i-- {
            if cnt[i] > 0 {
                ans = append(ans, i)
                cnt[i]--
            }
        }
    }
    return string(ans)
}
```

```C [sol1-C]
char* sortString(char* s) {
    int num[26];
    memset(num, 0, sizeof(num));
    int n = strlen(s);
    for (int i = 0; i < n; i++) {
        num[s[i] - 'a']++;
    }

    char* ret = malloc(sizeof(char) * (n + 1));
    int retSize = 0;
    while (retSize < n) {
        for (int i = 0; i < 26; i++) {
            if (num[i]) {
                ret[retSize++] = i + 'a';
                num[i]--;
            }
        }
        for (int i = 25; i >= 0; i--) {
            if (num[i]) {
                ret[retSize++] = i + 'a';
                num[i]--;
            }
        }
    }
    ret[retSize] = 0;
    return ret;
}
```

**复杂度分析**

- 时间复杂度：$O(|\Sigma|\times|s|)$，其中 $\Sigma$ 为字符集，$s$ 为传入的字符串，在这道题中，字符集为全部小写字母，$|\Sigma|=26$。最坏情况下字符串中所有字符都相同，那么对于每一个字符，我们需要遍历一次整个桶。

- 空间复杂度：$O(|\Sigma|)$，其中 $\Sigma$ 为字符集。我们需要和 $|\Sigma|$ 等大的桶来记录每一类字符的数量。
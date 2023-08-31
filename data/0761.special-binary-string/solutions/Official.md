## [761.特殊的二进制序列 中文官方题解](https://leetcode.cn/problems/special-binary-string/solutions/100000/te-shu-de-er-jin-zhi-xu-lie-by-leetcode-sb7ry)

#### 方法一：分治

**前言**

对于本题而言，将 $1$ 看成左括号 $\text{`('}$，$0$ 看成右括号 $\text{`)'}$，那么一个特殊的二进制序列就可以看成一个合法的括号序列。这种「映射」有助于理解题目中的操作，即交换两个相邻且非空的合法括号序列。但为了与题目保持一致，下面的部分仍然使用 $1/0$ 进行叙述。

**思路与算法**

对于一个特殊序列而言，它一定以 $1$ 开始，以 $0$ 结束。这是因为：

- 长度为 $1$ 的前缀中 $1$ 的数量一定要大于等于 $0$ 的数量，所以首位一定是 $1$；

- 由于 $0$ 和 $1$ 的数量相等，并且任意前缀中 $1$ 的数量一定大于等于 $0$ 的数量，那么任意后缀中 $0$ 的数量一定大于等于 $1$ 的数量，因此与上一条类似，末位一定是 $0$。

如果给定的字符串是一个「整体」的特殊序列，也就是说，它无法完整地拆分成多个特殊序列，那么它的首位 $1$ 和末位 $0$ 是不可能在任何交换操作中出现的。这里给出首位 $1$ 的证明，末位 $0$ 的证明是类似的：

> 如果首位 $1$ 可以在交换操作中出现，那么包含它的子串是给定字符串（特殊序列）的一个前缀，同时这个子串也是一个特殊序列。对于字符串中剩余的后缀部分，$0$ 和 $1$ 的数量相等（因为给定字符串和前缀子串的 $0$ 和 $1$ 数量均相等）并且满足「每一个前缀中 $1$ 的数量大于等于 $0$ 的数量」（因为后缀部分的每一个前缀可以映射为给定字符串在同一位置结束的前缀，再扣掉前缀子串，由于前缀子串中 $0$ 和 $1$ 的数量相等，因此扣除后仍然满足要求），那么后缀部分也是一个特殊序列，这就说明给定字符串可以拆分成两个特殊序列，与假设相矛盾。

因此，我们可以把首位 $1$ 和末位 $0$ 直接移除，进一步考虑剩余的字符串。

如果给定的字符串可以拆分成多个特殊序列（这里规定每一个拆分出来的特殊序列都是一个「整体」，不能继续进行拆分），那么我们可以「分别」进一步考虑每一个特殊序列，即把某个特殊序列的首位 $1$ 和末位 $0$ 移除后，递归地进行相同的拆分操作。

在递归返回后，我们可以进行「合并」操作：将所有的特殊序列按照字典序进行降序排序，再拼接起来，就可以得到字典序最大的字符串。由于每一次我们可以交换两个相邻的特殊序列，因此按照冒泡排序的方法，我们可以将这些特殊序列任意进行的排列，也就一定能得到字典序最大的字符串。

**细节**

在编写代码时，我们可以使用一个计数器，并从头遍历给定的字符串。当我们遇到 $1$ 时计数器加 $1$，遇到 $0$ 时计数器减 $1$。当计数器为 $0$ 时，我们就拆分除了一个「整体」的特殊序列。

当递归到的字符串长度小于等于 $2$ 时，说明字符串要么为空，要么为 $10$，此时字符串就是字典序最大的结果，可以直接返回。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    string makeLargestSpecial(string s) {
        if (s.size() <= 2) {
            return s;
        }
        int cnt = 0, left = 0;
        vector<string> subs;
        for (int i = 0; i < s.size(); ++i) {
            if (s[i] == '1') {
                ++cnt;
            }
            else {
                --cnt;
                if (cnt == 0) {
                    subs.push_back("1" + makeLargestSpecial(s.substr(left + 1, i - left - 1)) + "0");
                    left = i + 1;
                }
            }
        }

        sort(subs.begin(), subs.end(), greater<string>{});
        string ans = accumulate(subs.begin(), subs.end(), ""s);
        return ans;
    }
};
```

```Java [sol1-Java]
class Solution {
    public String makeLargestSpecial(String s) {
        if (s.length() <= 2) {
            return s;
        }
        int cnt = 0, left = 0;
        List<String> subs = new ArrayList<String>();
        for (int i = 0; i < s.length(); ++i) {
            if (s.charAt(i) == '1') {
                ++cnt;
            } else {
                --cnt;
                if (cnt == 0) {
                    subs.add("1" + makeLargestSpecial(s.substring(left + 1, i)) + "0");
                    left = i + 1;
                }
            }
        }

        Collections.sort(subs, (a, b) -> b.compareTo(a));
        StringBuilder ans = new StringBuilder();
        for (String sub : subs) {
            ans.append(sub);
        }
        return ans.toString();
    }
}
```

```C# [sol1-C#]
public class Solution {
    public string MakeLargestSpecial(string s) {
        if (s.Length <= 2) {
            return s;
        }
        int cnt = 0, left = 0;
        List<string> subs = new List<string>();
        for (int i = 0; i < s.Length; ++i) {
            if (s[i] == '1') {
                ++cnt;
            } else {
                --cnt;
                if (cnt == 0) {
                    subs.Add("1" + MakeLargestSpecial(s.Substring(left + 1, i - left - 1)) + "0");
                    left = i + 1;
                }
            }
        }

        subs.Sort((a, b) => b.CompareTo(a));
        StringBuilder ans = new StringBuilder();
        foreach (string sub in subs) {
            ans.Append(sub);
        }
        return ans.ToString();
    }
}
```

```Python [sol1-Python3]
class Solution:
    def makeLargestSpecial(self, s: str) -> str:
        if len(s) <= 2:
            return s
        
        cnt = left = 0
        subs = list()

        for i, ch in enumerate(s):
            if ch == "1":
                cnt += 1
            else:
                cnt -= 1
                if cnt == 0:
                    subs.append("1" + self.makeLargestSpecial(s[left+1:i]) + "0")
                    left = i + 1
        
        subs.sort(reverse=True)
        return "".join(subs)
```

```C [sol1-C]
static inline int cmp(const void* pa, const void* pb) {
    return strcmp(*(char **)pb, *(char **)pa);
}

char *helper(char *s, int start, int end) {
    int len = end - start + 1;
    if (len <= 2) {
        char *ans = (char *)malloc(sizeof(char) * (len + 1));
        strncpy(ans, s + start, len);
        ans[len] = '\0';
        return ans;
    }
    int cnt = 0, left = start;
    char **subs = (char **)malloc(sizeof(char *) * len);
    int subsSize = 0;
    for (int i = start; i <= end; ++i) {
        if (s[i] == '1') {
            ++cnt;
        } else {
            --cnt;
            if (cnt == 0) {
                char *res = helper(s, left + 1, i - 1);
                subs[subsSize] = (char *)malloc(sizeof(char) * (strlen(res) + 3));
                sprintf(subs[subsSize], "%s%s%s", "1", res, "0");
                left = i + 1;
                subsSize++;
            }
        }
    }
    qsort(subs, subsSize, sizeof(char *), cmp);
    char *ans = (char *)malloc(sizeof(char) * (len + 1));
    int pos = 0;
    for (int i = 0; i < subsSize; i++) {
        pos += sprintf(ans + pos, "%s", subs[i]);
        free(subs[i]);
    }
    ans[pos] = '\0';
    return ans;
}

char * makeLargestSpecial(char * s) {
    int len = strlen(s);
    return helper(s, 0, len - 1);
}
```

```go [sol1-Golang]
func makeLargestSpecial(s string) string {
    if len(s) <= 2 {
        return s
    }
    subs := sort.StringSlice{}
    cnt, left := 0, 0
    for i, ch := range s {
        if ch == '1' {
            cnt++
        } else if cnt--; cnt == 0 {
            subs = append(subs, "1"+makeLargestSpecial(s[left+1:i])+"0")
            left = i + 1
        }
    }
    sort.Sort(sort.Reverse(subs))
    return strings.Join(subs, "")
}
```

```JavaScript [sol1-JavaScript]
var makeLargestSpecial = function(s) {
    if (s.length <= 2) {
        return s;
    }
    let cnt = 0, left = 0;
    const subs = [];
        for (let i = 0; i < s.length; ++i) {
        if (s[i] === '1') {
            ++cnt;
        } else {
            --cnt;
            if (cnt === 0) {
                subs.push("1" + makeLargestSpecial(s.substring(left + 1, i)) + '0');
                left = i + 1;
            }
        }
    }

    subs.sort().reverse();
    return subs.join('');
};
```

**复杂度分析**

- 时间复杂度：$O(n^2)$，其中 $n$ 是字符串 $s$ 的长度。在最坏的情况下，$s$ 由 $\dfrac{n}{2}$ 个 $1$ 接着 $\dfrac{n}{2}$ 个 $0$ 拼接而成，每次递归仅减少 $2$ 的字符串长度，需要进行 $\dfrac{n}{2}$ 次递归。同时每次递归需要 $O(n)$ 的时间进行拼接并返回答案，因此总时间复杂度为 $O(n^2)$。

- 空间复杂度：$O(n)$，即为递归需要的栈空间以及存储递归返回的字符串需要的临时空间。
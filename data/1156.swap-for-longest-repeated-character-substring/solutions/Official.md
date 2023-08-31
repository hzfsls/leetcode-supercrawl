## [1156.单字符重复子串的最大长度 中文官方题解](https://leetcode.cn/problems/swap-for-longest-repeated-character-substring/solutions/100000/dan-zi-fu-zhong-fu-zi-chuan-de-zui-da-ch-9ywr)

#### 方法一：滑动窗口

**思路与算法**

给定一个字符串，你需要选择两个字符进行交换，这个操作最多进行一次，要求使得仅包含相同字符的子串尽可能的长。例如 $``bbababaaaa"$，可以交换第 $2$（下标从 $0$ 开始） 个字符 $a$ 与第 $5$ 个字符 $b$，使得包含相同字符的子串最长为 $6$，即 $``aaaaaa"$。

我们设 $n$ 为字符串 $\textit{text}$ 的长度，下标从 $0$ 开始，现在有一段区间 $[i, j)$ （不包括 $j$ ）由相同字符 $a$ 构成，并且该区间两边不存在相同的字符 $a$，而整个 $\textit{text}$ 中 $a$ 的出现次数为 $\textit{count}[a]$，那么当 $\textit{count}[a] \gt j - i$ ，并且 $i > 0$ 或者 $j \lt n$ 时，可以将其他地方出现的 $a$ 与 $\textit{text}[i-1]$ 或 $\textit{text}[j]$ 交换，从而得到更长的一段仅包含字符 $a$ 的子串。

交换后，交换过来的 $a$ 可能会使得两段连续的 $a$ 拼接在一起，我们假设 $[i, j)$ 是前面的一段，当 $\textit{text}[j+1] = a$ 时，我们在找到后面的一段 $[j + 1, k)$，这两段拼接在一起构成更长的子串。注意，我们需要重新判断是否有多余的 $a$ 交换到中间来，因此将拼接后的长度 $k - i$ 与 $\textit{count}[a]$ 取最小值来更新答案。

在实现过程中，我们可以使用滑动窗口算法来求解由相同字符构成的最长区间。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    int maxRepOpt1(string text) {
        unordered_map<char, int> count;
        for (auto c : text) {
            count[c]++;
        }

        int res = 0;
        for (int i = 0; i < text.size(); ) {
            // step1: 找出当前连续的一段 [i, j)
            int j = i;
            while (j < text.size() && text[j] == text[i]) {
                j++;
            }
            int cur_cnt = j - i;

            // step2: 如果这一段长度小于该字符出现的总数，并且前面或后面有空位，则使用 cur_cnt + 1 更新答案
            if (cur_cnt < count[text[i]] && (j < text.size() || i > 0)) {
                res = max(res, cur_cnt + 1);
            }

            // step3: 找到这一段后面与之相隔一个不同字符的另一段 [j + 1, k)，如果不存在则 k = j + 1 
            int k = j + 1;
            while (k < text.size() && text[k] == text[i]) {
                k++;
            }
            res = max(res, min(k - i, count[text[i]]));
            i = j;
        }
        return res;
    }
};
```

```Java [sol1-Java]
class Solution {
    public int maxRepOpt1(String text) {
        Map<Character, Integer> count = new HashMap<Character, Integer>();
        for (int i = 0; i < text.length(); i++) {
            char c = text.charAt(i);
            count.put(c, count.getOrDefault(c, 0) + 1);
        }

        int res = 0;
        for (int i = 0; i < text.length(); ) {
            // step1: 找出当前连续的一段 [i, j)
            int j = i;
            while (j < text.length() && text.charAt(j) == text.charAt(i)) {
                j++;
            }
            int curCnt = j - i;

            // step2: 如果这一段长度小于该字符出现的总数，并且前面或后面有空位，则使用 curCnt + 1 更新答案
            if (curCnt < count.getOrDefault(text.charAt(i), 0) && (j < text.length() || i > 0)) {
                res = Math.max(res, curCnt + 1);
            }

            // step3: 找到这一段后面与之相隔一个不同字符的另一段 [j + 1, k)，如果不存在则 k = j + 1 
            int k = j + 1;
            while (k < text.length() && text.charAt(k) == text.charAt(i)) {
                k++;
            }
            res = Math.max(res, Math.min(k - i, count.getOrDefault(text.charAt(i), 0)));
            i = j;
        }
        return res;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int MaxRepOpt1(string text) {
        IDictionary<char, int> count = new Dictionary<char, int>();
        foreach (char c in text) {
            count.TryAdd(c, 0);
            count[c]++;
        }

        int res = 0;
        for (int i = 0; i < text.Length; ) {
            // step1: 找出当前连续的一段 [i, j)
            int j = i;
            while (j < text.Length && text[j] == text[i]) {
                j++;
            }
            int curCnt = j - i;

            // step2: 如果这一段长度小于该字符出现的总数，并且前面或后面有空位，则使用 curCnt + 1 更新答案
            if (curCnt < (count.ContainsKey(text[i]) ? count[text[i]] : 0) && (j < text.Length || i > 0)) {
                res = Math.Max(res, curCnt + 1);
            }

            // step3: 找到这一段后面与之相隔一个不同字符的另一段 [j + 1, k)，如果不存在则 k = j + 1 
            int k = j + 1;
            while (k < text.Length && text[k] == text[i]) {
                k++;
            }
            res = Math.Max(res, Math.Min(k - i, count.ContainsKey(text[i]) ? count[text[i]] : 0));
            i = j;
        }
        return res;
    }
}
```

```C [sol1-C]
static inline int min(int a, int b) {
    return a < b ? a : b;
}

static inline int max(int a, int b) {
    return a > b ? a : b;
}

int maxRepOpt1(char * text) {
    int len = strlen(text);
    int count[26];
    memset(count, 0, sizeof(count));
    for (int i = 0; i < len; i++) {
        count[text[i] - 'a']++;
    }

    int res = 0;
    for (int i = 0; i < len; ) {
        // step1: 找出当前连续的一段 [i, j)
        int j = i;
        while (j < len && text[j] == text[i]) {
            j++;
        }
        int cur_cnt = j - i;

        // step2: 如果这一段长度小于该字符出现的总数，并且前面或后面有空位，则使用 cur_cnt + 1 更新答案
        if (cur_cnt < count[text[i] - 'a'] && (j < len || i > 0)) {
            res = max(res, cur_cnt + 1);
        }

        // step3: 找到这一段后面与之相隔一个不同字符的另一段 [j + 1, k)，如果不存在则 k = j + 1 
        int k = j + 1;
        while (k < len && text[k] == text[i]) {
            k++;
        }
        res = max(res, min(k - i, count[text[i] - 'a']));
        i = j;
    }
    return res;
}
```

```Python [sol1-Python3]
class Solution:
    def maxRepOpt1(self, text: str) -> int:
        count = Counter(text)
        res = 0
        i = 0
        while i < len(text):
            # step1: 找出当前连续的一段 [i, j)
            j = i
            while j < len(text) and text[j] == text[i]:
                j += 1

            # step2: 如果这一段长度小于该字符出现的总数，并且前面或后面有空位，则使用 cur_cnt + 1 更新答案
            cur_cnt = j - i
            if cur_cnt < count[text[i]] and (j < len(text) or i > 0):
                res = max(res, cur_cnt + 1)

            # step3: 找到这一段后面与之相隔一个不同字符的另一段 [j + 1, k)，如果不存在则 k = j + 1
            k = j + 1
            while k < len(text) and text[k] == text[i]:
                k += 1
            res = max(res, min(k - i, count[text[i]]))
            i = j
        return res
```

```Go [sol1-Go]
func maxRepOpt1(text string) int {
    count := make(map[rune]int)
    for _, c := range text {
        count[c]++
    }

    res := 0
    i := 0
    for i < len(text) {
         // step1: 找出当前连续的一段 [i, j)
        j := i
        for j < len(text) && text[j] == text[i] {
            j++
        }
        curCnt := j - i

        // step2: 如果这一段长度小于该字符出现的总数，并且前面或后面有空位，则使用 cur_cnt + 1 更新答案
        if curCnt < count[rune(text[i])] && (j < len(text) || i > 0) {
            res = max(res, curCnt+1)
        }

        // step3: 找到这一段后面与之相隔一个不同字符的另一段 [j + 1, k)，如果不存在则 k = j + 1
        k := j + 1
        for k < len(text) && text[k] == text[i] {
            k++
        }
        res = max(res, min(k-i, count[rune(text[i])]))
        i = j
    }

    return res
}

func max(a, b int) int {
    if a > b {
        return a
    }
    return b
}

func min(a, b int) int {
    if a < b {
        return a
    }
    return b
}
```

```JavaScript [sol1-JavaScript]
var maxRepOpt1 = function(text) {
    const count = new Map();
    for (let i = 0; i < text.length; i++) {
        const c = text[i];
        count.set(c, (count.get(c) || 0) + 1);
    }

    let res = 0;
    for (let i = 0; i < text.length; ) {
        // step1: 找出当前连续的一段 [i, j)
        let j = i;
        while (j < text.length && text[j] === text[i]) {
            j++;
        }
        let curCnt = j - i;

        // step2: 如果这一段长度小于该字符出现的总数，并且前面或后面有空位，则使用 curCnt + 1 更新答案
        if (curCnt < (count.get(text[i] || 0)) && (j < text.length || i > 0)) {
            res = Math.max(res, curCnt + 1);
        }

        // step3: 找到这一段后面与之相隔一个不同字符的另一段 [j + 1, k)，如果不存在则 k = j + 1 
        let k = j + 1;
        while (k < text.length && text[k] === text[i]) {
            k++;
        }
        res = Math.max(res, Math.min(k - i, (count.get(text[i]) || 0)));
        i = j;
    }
    return res;
};
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 是字符串 $\textit{text}$ 的长度。求解每种字符出现次数的时间复杂度为 $O(n)$，而每一段包含相同字符的区间最多会被遍历两次，因此总体时间复杂度为 $O(n)$。

- 空间复杂度：$O(C)$，其中 $C$ 是字符集大小，在本题中为 $26$。
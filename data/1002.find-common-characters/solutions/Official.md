## [1002.查找共用字符 中文官方题解](https://leetcode.cn/problems/find-common-characters/solutions/100000/cha-zhao-chang-yong-zi-fu-by-leetcode-solution)
#### 方法一：计数

**思路与算法**

根据题目的要求，如果字符 $c$ 在所有字符串中均出现了 $k$ 次及以上，那么最终答案中需要包含 $k$ 个 $c$。因此，我们可以使用 $\textit{minfreq}[c]$ 存储字符 $c$ 在所有字符串中出现次数的最小值。

我们可以依次遍历每一个字符串。当我们遍历到字符串 $s$ 时，我们使用 $\textit{freq}[c]$ 统计 $s$ 中每一个字符 $c$ 出现的次数。在统计完成之后，我们再将每一个 $\textit{minfreq}[c]$ 更新为其本身与 $\textit{freq}[c]$ 的较小值。这样一来，当我们遍历完所有字符串后，$\textit{minfreq}[c]$ 就存储了字符 $c$ 在所有字符串中出现次数的最小值。

由于题目保证了所有的字符均为小写字母，因此我们可以用长度为 $26$ 的数组分别表示 $\textit{minfreq}$ 以及 $\textit{freq}$。

在构造最终的答案时，我们遍历所有的小写字母 $c$，并将 $\textit{minfreq}[c]$ 个 $c$ 添加进答案数组即可。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    vector<string> commonChars(vector<string>& words) {
        vector<int> minfreq(26, INT_MAX);
        vector<int> freq(26);
        for (const string& word: words) {
            fill(freq.begin(), freq.end(), 0);
            for (char ch: word) {
                ++freq[ch - 'a'];
            }
            for (int i = 0; i < 26; ++i) {
                minfreq[i] = min(minfreq[i], freq[i]);
            }
        }

        vector<string> ans;
        for (int i = 0; i < 26; ++i) {
            for (int j = 0; j < minfreq[i]; ++j) {
                ans.emplace_back(1, i + 'a');
            }
        }
        return ans;
    }
};
```

```Java [sol1-Java]
class Solution {
    public List<String> commonChars(String[] words) {
        int[] minfreq = new int[26];
        Arrays.fill(minfreq, Integer.MAX_VALUE);
        for (String word : words) {
            int[] freq = new int[26];
            int length = word.length();
            for (int i = 0; i < length; ++i) {
                char ch = word.charAt(i);
                ++freq[ch - 'a'];
            }
            for (int i = 0; i < 26; ++i) {
                minfreq[i] = Math.min(minfreq[i], freq[i]);
            }
        }

        List<String> ans = new ArrayList<String>();
        for (int i = 0; i < 26; ++i) {
            for (int j = 0; j < minfreq[i]; ++j) {
                ans.add(String.valueOf((char) (i + 'a')));
            }
        }
        return ans;
    }
}
```

```Python [sol1-Python3]
class Solution:
    def commonChars(self, words: List[str]) -> List[str]:
        minfreq = [float("inf")] * 26
        for word in words:
            freq = [0] * 26
            for ch in word:
                freq[ord(ch) - ord("a")] += 1
            for i in range(26):
                minfreq[i] = min(minfreq[i], freq[i])
        
        ans = list()
        for i in range(26):
            ans.extend([chr(i + ord("a"))] * minfreq[i])
        return ans
```

```Golang [sol1-Golang]
func commonChars(words []string) (ans []string) {
    minFreq := [26]int{}
    for i := range minFreq {
        minFreq[i] = math.MaxInt64
    }
    for _, word := range words {
        freq := [26]int{}
        for _, b := range word {
            freq[b-'a']++
        }
        for i, f := range freq[:] {
            if f < minFreq[i] {
                minFreq[i] = f
            }
        }
    }
    for i := byte(0); i < 26; i++ {
        for j := 0; j < minFreq[i]; j++ {
            ans = append(ans, string('a'+i))
        }
    }
    return
}
```

```C [sol1-C]
char** commonChars(char** words, int wordsSize, int* returnSize) {
    int minfreq[26], freq[26];
    for (int i = 0; i < 26; ++i) {
        minfreq[i] = INT_MAX;
        freq[i] = 0;
    }
    for (int i = 0; i < wordsSize; ++i) {
        memset(freq, 0, sizeof(freq));
        int n = strlen(words[i]);
        for (int j = 0; j < n; ++j) {
            ++freq[words[i][j] - 'a'];
        }
        for (int j = 0; j < 26; ++j) {
            minfreq[j] = fmin(minfreq[j], freq[j]);
        }
    }

    int sum = 0;
    for (int i = 0; i < 26; ++i) {
        sum += minfreq[i];
    }

    char** ans = malloc(sizeof(char*) * sum);
    *returnSize = 0;
    for (int i = 0; i < 26; ++i) {
        for (int j = 0; j < minfreq[i]; ++j) {
            ans[*returnSize] = malloc(sizeof(char) * 2);
            ans[*returnSize][0] = i + 'a';
            ans[*returnSize][1] = 0;
            (*returnSize)++;
        }
    }
    return ans;
}
```

**复杂度分析**

- 时间复杂度：$O(n(m+|\Sigma|))$，其中 $n$ 是数组 $A$ 的长度（即字符串的数目），$m$ 是字符串的平均长度，$\Sigma$ 为字符集，在本题中字符集为所有小写字母，$|\Sigma|=26$。

    - 遍历所有字符串并计算 $\textit{freq}$ 的时间复杂度为 $O(nm)$；
    - 使用 $\textit{freq}$ 更新 $\textit{minfreq}$ 的时间复杂度为 $O(n|\Sigma|)$；
    - 由于最终答案包含的字符个数不会超过最短的字符串长度，因此构造最终答案的时间复杂度为 $O(m+|\Sigma|)$。这一项在渐进意义上小于前二者，可以忽略。

- 空间复杂度：$O(|\Sigma|)$，这里只计算存储答案之外的空间。我们使用了数组 $\textit{freq}$ 和 $\textit{minfreq}$，它们的长度均为 $|\Sigma|$。
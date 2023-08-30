#### 方法一：前缀和

为方便表述，以下将以元音开头和结尾的字符串称为「元音字符串」。

这道题要求返回一系列查询的答案，每个查询为计算特定区间中的元音字符串数。可以使用前缀和实现区间查询。

用 $n$ 表示数组 $\textit{words}$ 的长度，创建长度为 $n + 1$ 的数组 $\textit{prefixSums}$，其中 $\textit{prefixSums}[i]$ 表示数组 $\textit{words}$ 的前 $i$ 个字符串（即下标范围 $[0, i - 1]$ 的字符串）中的元音字符串数，$\textit{prefixSums}[0] = 0$。

从左到右遍历数组 $\textit{words}$，对于下标 $0 \le i < n$，执行如下操作：

- 如果 $\textit{words}[i]$ 是元音字符串，则 $\textit{prefixSums}[i + 1] = \textit{prefixSums}[i] + 1$；

- 如果 $\textit{words}[i]$ 不是元音字符串，则 $\textit{prefixSums}[i + 1] = \textit{prefixSums}[i]$。

得到前缀和数组之后，对于 $0 \le i \le j < n$，区间 $[i, j]$ 中的元音字符串数是 $\textit{prefixSums}[j + 1] - \textit{prefixSums}[i]$。

用 $\textit{ans}[i]$ 表示第 $i$ 个查询 $\textit{queries}[i]$ 的答案。如果 $\textit{queries}[i] = [\textit{start}_i, \textit{end}_i]$，则 $\textit{ans}[i] = \textit{prefixSums}[\textit{end}_i + 1] - \textit{prefixSums}[\textit{start}_i]$。

遍历所有的查询之后，即可得到答案数组 $\textit{ans}$。

```Java [sol1-Java]
class Solution {
    public int[] vowelStrings(String[] words, int[][] queries) {
        int n = words.length;
        int[] prefixSums = new int[n + 1];
        for (int i = 0; i < n; i++) {
            int value = isVowelString(words[i]) ? 1 : 0;
            prefixSums[i + 1] = prefixSums[i] + value;
        }
        int q = queries.length;
        int[] ans = new int[q];
        for (int i = 0; i < q; i++) {
            int start = queries[i][0], end = queries[i][1];
            ans[i] = prefixSums[end + 1] - prefixSums[start];
        }
        return ans;
    }

    public boolean isVowelString(String word) {
        return isVowelLetter(word.charAt(0)) && isVowelLetter(word.charAt(word.length() - 1));
    }

    public boolean isVowelLetter(char c) {
        return c == 'a' || c == 'e' || c == 'i' || c == 'o' || c == 'u';
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int[] VowelStrings(string[] words, int[][] queries) {
        int n = words.Length;
        int[] prefixSums = new int[n + 1];
        for (int i = 0; i < n; i++) {
            int value = IsVowelString(words[i]) ? 1 : 0;
            prefixSums[i + 1] = prefixSums[i] + value;
        }
        int q = queries.Length;
        int[] ans = new int[q];
        for (int i = 0; i < q; i++) {
            int start = queries[i][0], end = queries[i][1];
            ans[i] = prefixSums[end + 1] - prefixSums[start];
        }
        return ans;
    }

    public bool IsVowelString(string word) {
        return IsVowelLetter(word[0]) && IsVowelLetter(word[word.Length - 1]);
    }

    public bool IsVowelLetter(char c) {
        return c == 'a' || c == 'e' || c == 'i' || c == 'o' || c == 'u';
    }
}
```

```C++ [sol1-C++]
class Solution {
public:
    vector<int> vowelStrings(vector<string>& words, vector<vector<int>>& queries) {
        int n = words.size();
        int prefixSums[n + 1];
        memset(prefixSums, 0, sizeof(prefixSums));
        for (int i = 0; i < n; i++) {
            int value = isVowelString(words[i]) ? 1 : 0;
            prefixSums[i + 1] = prefixSums[i] + value;
        }
        vector<int> ans(queries.size());
        for (int i = 0; i < queries.size(); i++) {
            int start = queries[i][0], end = queries[i][1];
            ans[i] = prefixSums[end + 1] - prefixSums[start];
        }
        return ans;
    }

    bool isVowelString(const string &word) {
        return isVowelLetter(word[0]) && isVowelLetter(word.back());
    }

    bool isVowelLetter(char c) {
        return c == 'a' || c == 'e' || c == 'i' || c == 'o' || c == 'u';
    }
};

```

```Python [sol1-Python3]
class Solution:
    def vowelStrings(self, words: List[str], queries: List[List[int]]) -> List[int]:
        def isVowelString(word):
            return isVowelLetter(word[0]) and isVowelLetter(word[-1])

        def isVowelLetter(c):
            return c == 'a' or c == 'e' or c == 'i' or c == 'o' or c == 'u'

        n = len(words)
        prefix_sums = [0] * (n + 1)
        for i in range(n):
            value = 1 if isVowelString(words[i]) else 0
            prefix_sums[i + 1] = prefix_sums[i] + value
        ans = []
        for i in range(len(queries)):
            start, end = queries[i]
            ans.append(prefix_sums[end + 1] - prefix_sums[start])
        return ans
```

```Go [sol1-Go]
func vowelStrings(words []string, queries [][]int) []int {
    n := len(words)
    prefixSums := make([]int, n + 1)
    for i := 0; i < n; i++ {
        value := 0
        if isVowelString(words[i]) {
            value = 1
        }
        prefixSums[i + 1] = prefixSums[i] + value
    }
    ans := make([]int, len(queries))
    for i := 0; i < len(queries); i++ {
        start := queries[i][0]
        end := queries[i][1]
        ans[i] = prefixSums[end + 1] - prefixSums[start]
    }
    return ans
}

func isVowelString(word string) bool {
    return isVowelLetter(word[0]) && isVowelLetter(word[len(word) - 1])
}

func isVowelLetter(c byte) bool {
    return c == 'a' || c == 'e' || c == 'i' || c == 'o' || c == 'u'
}
```

```JavaScript [sol1-JavaScript]
var vowelStrings = function(words, queries) {
    let n = words.length;
    let prefixSums = new Array(n + 1).fill(0);
    for (let i = 0; i < n; i++) {
        let value = isVowelString(words[i]) ? 1 : 0;
        prefixSums[i + 1] = prefixSums[i] + value;
    }
    let ans = [];
    for (let i = 0; i < queries.length; i++) {
        let start = queries[i][0], end = queries[i][1];
        ans.push(prefixSums[end + 1] - prefixSums[start]);
    }
    return ans;
}

function isVowelString(word) {
    return isVowelLetter(word[0]) && isVowelLetter(word[word.length - 1]);
}

function isVowelLetter(c) {
    return c == 'a' || c == 'e' || c == 'i' || c == 'o' || c == 'u';
}
```

```C [sol1-C]
bool isVowelLetter(char c) {
    return c == 'a' || c == 'e' || c == 'i' || c == 'o' || c == 'u';
}

bool isVowelString(const char *word) {
    int len = strlen(word);
    return isVowelLetter(word[0]) && isVowelLetter(word[len - 1]);
}

int* vowelStrings(char ** words, int wordsSize, int** queries, int queriesSize, int* queriesColSize, int* returnSize) {
    int n = wordsSize;
    int prefixSums[n + 1];
    memset(prefixSums, 0, sizeof(prefixSums));
    for (int i = 0; i < n; i++) {
        int value = isVowelString(words[i]) ? 1 : 0;
        prefixSums[i + 1] = prefixSums[i] + value;
    }
    int *ans = (int *)calloc(queriesSize, sizeof(int));
    for (int i = 0; i < queriesSize; i++) {
        int start = queries[i][0], end = queries[i][1];
        ans[i] = prefixSums[end + 1] - prefixSums[start];
    }
    *returnSize = queriesSize;
    return ans;
}
```

**复杂度分析**

- 时间复杂度：$O(n + q)$，其中 $n$ 是数组 $\textit{words}$ 的长度，$q$ 是数组 $\textit{queries}$ 的长度（即查询数）。计算前缀和数组的时间是 $O(n)$，然后计算 $q$ 个查询的答案，计算每个查询的答案的时间是 $O(1)$，因此时间复杂度是 $O(n + q)$。

- 空间复杂度：$O(n)$，其中 $n$ 是数组 $\textit{words}$ 的长度。需要创建长度为 $n + 1$ 的前缀和数组。注意返回值不计入空间复杂度。
#### 方法一：状态压缩

因为单词数目不超过 $14$，因此我们可以使用状态压缩的方式来枚举所有的单词子集。使用整数 $s$ 表示单词子集，$s$ 的第 $k$ 位为 $1$ 代表单词子集 $s$ 包含单词 $\textit{words}[k]$，$s$ 的第 $k$ 位为 $0$ 代表单词子集 $s$ 不包含单词 $\textit{words}[k]$。

使用 $\textit{count}$ 保存字母表 $\textit{letters}$ 中各种字母的数目，使用 $\textit{wordCount}$ 保存单词子集 $s$ 中所有单词的各种字母的数目。

枚举所有的单词子集，遍历单词子集的单词并更新 $\textit{wordCount}$，如果 $\textit{wordCount}$ 中的任一字母的数目都小于等于 $\textit{count}$ 中对应字母的数目，那么说明单词子集的单词可以由字母表 $\textit{letters}$ 拼写，计算单词子集的分数，最终结果就是这些分数中的最大值。

```C++ [sol1-C++]
class Solution {
public:
    int maxScoreWords(vector<string>& words, vector<char>& letters, vector<int>& score) {
        int n = words.size(), res = 0;
        vector<int> count(26);
        for (auto c : letters) {
            count[c - 'a']++;
        }
        for (int s = 1; s < (1 << n); s++) {
            vector<int> wordCount(26); // 统计子集 s 所有单词的字母数目
            for (int k = 0; k < n; k++) {
                if ((s & (1 << k)) == 0) { // words[k] 不在子集 s 中
                    continue;
                }
                for (auto c : words[k]) {
                    wordCount[c - 'a']++;
                }
            }
            bool ok = true; // 判断子集 s 是否合法
            int sum = 0; // 保存子集 s 的得分
            for (int i = 0; i < 26; i++) {
                sum += score[i] * wordCount[i];
                ok = ok && (wordCount[i] <= count[i]);
            }
            if (ok) {
                res = max(res, sum);
            }
        }
        return res;
    }
};
```

```Java [sol1-Java]
class Solution {
    public int maxScoreWords(String[] words, char[] letters, int[] score) {
        int n = words.length, res = 0;
        int[] count = new int[26];
        for (char c : letters) {
            count[c - 'a']++;
        }
        for (int s = 1; s < (1 << n); s++) {
            int[] wordCount = new int[26]; // 统计子集 s 所有单词的字母数目
            for (int k = 0; k < n; k++) {
                if ((s & (1 << k)) == 0) { // words[k] 不在子集 s 中
                    continue;
                }
                for (int i = 0; i < words[k].length(); i++) {
                    char c = words[k].charAt(i);
                    wordCount[c - 'a']++;
                }
            }
            boolean ok = true; // 判断子集 s 是否合法
            int sum = 0; // 保存子集 s 的得分
            for (int i = 0; i < 26; i++) {
                sum += score[i] * wordCount[i];
                ok = ok && (wordCount[i] <= count[i]);
            }
            if (ok) {
                res = Math.max(res, sum);
            }
        }
        return res;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int MaxScoreWords(string[] words, char[] letters, int[] score) {
        int n = words.Length, res = 0;
        int[] count = new int[26];
        foreach (char c in letters) {
            count[c - 'a']++;
        }
        for (int s = 1; s < (1 << n); s++) {
            int[] wordCount = new int[26]; // 统计子集 s 所有单词的字母数目
            for (int k = 0; k < n; k++) {
                if ((s & (1 << k)) == 0) { // words[k] 不在子集 s 中
                    continue;
                }
                foreach (char c in words[k]) {
                    wordCount[c - 'a']++;
                }
            }
            bool ok = true; // 判断子集 s 是否合法
            int sum = 0; // 保存子集 s 的得分
            for (int i = 0; i < 26; i++) {
                sum += score[i] * wordCount[i];
                ok = ok && (wordCount[i] <= count[i]);
            }
            if (ok) {
                res = Math.Max(res, sum);
            }
        }
        return res;
    }
}
```

```JavaScript [sol1-JavaScript]
var maxScoreWords = function(words, letters, score) {
    let n = words.length, res = 0;
    const count = new Array(26).fill(0);
    for (const c of letters) {
        count[c.charCodeAt() - 'a'.charCodeAt()]++;
    }
    for (let s = 1; s < (1 << n); s++) {
        const wordCount = new Array(26).fill(0); // 统计子集 s 所有单词的字母数目
        for (let k = 0; k < n; k++) {
            if ((s & (1 << k)) === 0) { // words[k] 不在子集 s 中
                continue;
            }
            for (let i = 0; i < words[k].length; i++) {
                const c = words[k][i];
                wordCount[c.charCodeAt() - 'a'.charCodeAt()]++;
            }
        }
        let ok = true; // 判断子集 s 是否合法
        let sum = 0; // 保存子集 s 的得分
        for (let i = 0; i < 26; i++) {
            sum += score[i] * wordCount[i];
            ok = ok && (wordCount[i] <= count[i]);
        }
        if (ok) {
            res = Math.max(res, sum);
        }
    }
    return res;
};
```

**复杂度分析**

+ 时间复杂度：$O \big (L + (S + \sum) \times 2^n \big )$，其中 $L$ 是数组 $\textit{letters}$ 的长度，$S$ 是字符串数组 $\textit{words}$ 的所有字符串长度，$\sum=26$ 是字符集大小。$\textit{words}$ 中的每个单词存在于 $2^{n-1}$ 个子集中，因此每个单词被遍历 $2^{n-1}$ 次。

+ 空间复杂度：$O \big ( \sum \big )$。保存 $\textit{count}$ 和 $\textit{wordCount}$ 需要 $O \big ( \sum \big )$ 的空间。
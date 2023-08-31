## [2451.差值数组不同的字符串 中文官方题解](https://leetcode.cn/problems/odd-string-difference/solutions/100000/chai-zhi-shu-zu-bu-tong-de-zi-fu-chuan-b-3rhg)
#### 方法一：遍历

**思路与算法**

注意到字符串数组 $\textit{words}$ 的长度 $m$ 最小为 $3$，因此我们记 $\textit{diff}_0$，$\textit{diff}_1$，$\textit{diff}_2$ 分别是 $\textit{words}_0$，$\textit{words}_1$，$\textit{words}_2$ 的差值整数数组，基于此分情况讨论：

1. 如果 $\textit{diff}_0 = \textit{diff}_1$，那么我们遍历 $\textit{words}_2 \sim \textit{words}_{m-1}$，找到第一个差值整数数组不等于 $\textit{diff}_0$ 的字符串即可。
2. 否则如果 $\textit{diff}_0 \neq \textit{diff}_1$，那么我们只需判断 $\textit{diff}_0$ 是否等于 $\textit{diff}_2$ 即可。如果等于则足以说明 $\textit{words}_1$ 是唯一一个与其他字符串的差值整数数组都不相同的字符串，因此直接返回 $\textit{words}_1$。反之，如果 $\textit{diff}_0$ 不等于 $\textit{diff}_2$ 则返回 $\textit{words}_0$。
   
**代码**

```C++ [sol1-C++]
class Solution {
public:
    vector<int> get(string &word) {
        vector<int> diff(word.size() - 1);
        for (int i = 0; i + 1 < word.size(); i++) {
            diff[i] = word[i + 1] - word[i];
        }
        return diff;
    }

    string oddString(vector<string>& words) {
        auto diff0 = get(words[0]);
        auto diff1 = get(words[1]);
        if (diff0 == diff1) {
            for (int i = 2; i < words.size(); i++) {
                if (diff0 != get(words[i])) {
                    return words[i];
                }
            }
        }
        return diff0 == get(words[2]) ? words[1] : words[0];
    }
};
```

```Java [sol1-Java]
class Solution {
    public String oddString(String[] words) {
        int[] diff0 = get(words[0]);
        int[] diff1 = get(words[1]);
        if (Arrays.equals(diff0, diff1)) {
            for (int i = 2; i < words.length; i++) {
                if (!Arrays.equals(diff0, get(words[i]))) {
                    return words[i];
                }
            }
        }
        return Arrays.equals(diff0, get(words[2])) ? words[1] : words[0];
    }

    public int[] get(String word) {
        int[] diff = new int[word.length() - 1];
        for (int i = 0; i + 1 < word.length(); i++) {
            diff[i] = word.charAt(i + 1) - word.charAt(i);
        }
        return diff;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public string OddString(string[] words) {
        int[] diff0 = Get(words[0]);
        int[] diff1 = Get(words[1]);
        if (Enumerable.SequenceEqual(diff0, diff1)) {
            for (int i = 2; i < words.Length; i++) {
                if (!Enumerable.SequenceEqual(diff0, Get(words[i]))) {
                    return words[i];
                }
            }
        }
        return Enumerable.SequenceEqual(diff0, Get(words[2])) ? words[1] : words[0];
    }

    public int[] Get(string word) {
        int[] diff = new int[word.Length - 1];
        for (int i = 0; i + 1 < word.Length; i++) {
            diff[i] = word[i + 1] - word[i];
        }
        return diff;
    }
}
```

```Python [sol1-Python3]
class Solution:
    def oddString(self, words: List[str]) -> str:
        def get(word):
            diff = [0] * (len(word) - 1)
            for i in range(len(word)-1):
                diff[i] = ord(word[i+1]) - ord(word[i])
            return diff

        diff0 = get(words[0])
        diff1 = get(words[1])
        if diff0 == diff1:
            for i in range(2, len(words)):
                if diff0 != get(words[i]):
                    return words[i]
        return words[1] if diff0 == get(words[2]) else words[0]

```

```Go [sol1-Go]
func get(word string) []int {
    diff := make([]int, len(word) - 1)
    for i:= 0; i + 1 < len(word); i++ {
        diff[i] = int(word[i + 1]) - int(word[i])
    }
    return diff
}

func oddString(words []string) string {
    diff0 := get(words[0])
    diff1 := get(words[1])
    if reflect.DeepEqual(diff0, diff1) {
        for i:= 2; i < len(words); i++ {
            if !reflect.DeepEqual(diff0, get(words[i])) {
                return words[i]
            }
        }
    }
    if reflect.DeepEqual(diff0, get(words[2])) {
        return words[1]
    }
    return words[0]
}
```

```JavaScript [sol1-JavaScript]
function get(word) {
    let diff = new Array(word.length-1);
    for (let i = 0; i + 1 < word.length; i++) {
        diff[i] = word.charCodeAt(i + 1) - word.charCodeAt(i);
    }
    return diff.toString();
}

var oddString = function(words) {
    let diff0 = get(words[0]);
    let diff1 = get(words[1]);
    if (diff0 === diff1) {
        for (let i = 2; i < words.length; i++) {
            if (diff0 != get(words[i])) {
                return words[i];
            }
        }
    }
    return diff0 === get(words[2]) ? words[1] : words[0]
}
```

```C [sol1-C]
void get(const char *word, int *diff) {
    int len = strlen(word);
    for (int i = 0; i + 1 < len; i++) {
        diff[i] = word[i + 1] - word[i];
    }
}

char * oddString(char ** words, int wordsSize) {
    int len = strlen(words[0]);
    int diff0[len - 1];
    int diff1[len - 1];
    int diff[len - 1];
    get(words[0], &diff0);
    get(words[1], &diff1);
    if (memcmp(&diff0, &diff1, sizeof(int) * (len - 1)) == 0) {
        for (int i = 2; i < wordsSize; i++) {
            get(words[i], &diff);
            if (memcmp(&diff0, &diff, sizeof(int) * (len - 1)) != 0) {
                return words[i];
            }
        }
    }
    get(words[2], &diff);
    return memcmp(&diff0, &diff, sizeof(int) * (len - 1)) == 0 ? words[1] : words[0];
}
```

**复杂度分析**

- 时间复杂度：$O(mn)$，其中 $m$ 是 $\textit{words}$ 的长度，$n$ 是 $\textit{words}$ 中字符串的长度。计算每个字符串的差值整数数组复杂度为 $O(n)$，比较两个字符串的差值整数数组是否相同的复杂度为 $O(n)$，过程中最多比较 $m$ 次，因此总体复杂度为 $O(mn)$。

- 空间复杂度：$O(n)$。过程中，最多会同时存在 $3$ 个长度为 $n$ 的差值整数数组，因此空间复杂度为 $O(n)$。
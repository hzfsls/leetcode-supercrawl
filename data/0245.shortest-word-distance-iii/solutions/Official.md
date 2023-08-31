## [245.最短单词距离 III 中文官方题解](https://leetcode.cn/problems/shortest-word-distance-iii/solutions/100000/zui-duan-dan-ci-ju-chi-iii-by-leetcode-s-y4hu)

#### 方法一：一次遍历

这道题是「[243. 最短单词距离](https://leetcode-cn.com/problems/shortest-word-distance)」的进阶版本，和第 243 题的区别在于这道题中给定的两个单词 $\textit{word}_1$ 和 $\textit{word}_2$ 可能相同，当 $\textit{word}_1$ 和 $\textit{word}_2$ 相同时，表示数组中的两个独立的单词。

当 $\textit{word}_1$ 和 $\textit{word}_2$ 相同时，需要遍历数组 $\textit{words}$ 得到 $\textit{word}_1$ 在数组中的所有下标。为了计算最短距离，当遍历到 $\textit{word}_1$ 时，应该在之前已经遍历到的 $\textit{word}_1$ 中取最后一个下标，计算和当前下标的距离。

当 $\textit{word}_1$ 和 $\textit{word}_2$ 不同时，可以使用第 243 题的方法计算最短距离，见「[243. 最短单词距离的官方题解](https://leetcode-cn.com/problems/shortest-word-distance/solution/)」。

无论 $\textit{word}_1$ 和 $\textit{word}_2$ 是否相同，都只需要遍历数组 $\textit{words}$ 一次，时间复杂度是 $O(n)$。

```Python [sol1-Python3]
class Solution:
    def shortestWordDistance(self, wordsDict: List[str], word1: str, word2: str) -> int:
        ans = len(wordsDict)
        if word1 == word2:
            pre = -1
            for i, word in enumerate(wordsDict):
                if word == word1:
                    if pre >= 0:
                        ans = min(ans, i - pre)
                    pre = i
        else:
            index1, index2 = -1, -1
            for i, word in enumerate(wordsDict):
                if word == word1:
                    index1 = i
                elif word == word2:
                    index2 = i
                if index1 >= 0 and index2 >= 0:
                    ans = min(ans, abs(index1 - index2))
        return ans
```

```Java [sol1-Java]
class Solution {
    public int shortestWordDistance(String[] wordsDict, String word1, String word2) {
        int length = wordsDict.length;
        int ans = length;
        if (word1.equals(word2)) {
            int prev = -1;
            for (int i = 0; i < length; i++) {
                String word = wordsDict[i];
                if (word.equals(word1)) {
                    if (prev >= 0) {
                        ans = Math.min(ans, i - prev);
                    }
                    prev = i;
                }
            }
        } else {
            int index1 = -1, index2 = -1;
            for (int i = 0; i < length; i++) {
                String word = wordsDict[i];
                if (word.equals(word1)) {
                    index1 = i;
                } else if (word.equals(word2)) {
                    index2 = i;
                }
                if (index1 >= 0 && index2 >= 0) {
                    ans = Math.min(ans, Math.abs(index1 - index2));
                }
            }
        }
        return ans;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int ShortestWordDistance(string[] wordsDict, string word1, string word2) {
        int length = wordsDict.Length;
        int ans = length;
        if (word1.Equals(word2)) {
            int prev = -1;
            for (int i = 0; i < length; i++) {
                string word = wordsDict[i];
                if (word.Equals(word1)) {
                    if (prev >= 0) {
                        ans = Math.Min(ans, i - prev);
                    }
                    prev = i;
                }
            }
        } else {
            int index1 = -1, index2 = -1;
            for (int i = 0; i < length; i++) {
                string word = wordsDict[i];
                if (word.Equals(word1)) {
                    index1 = i;
                } else if (word.Equals(word2)) {
                    index2 = i;
                }
                if (index1 >= 0 && index2 >= 0) {
                    ans = Math.Min(ans, Math.Abs(index1 - index2));
                }
            }
        }
        return ans;
    }
}
```

```C++ [sol1-C++]
class Solution {
public:
    int shortestWordDistance(vector<string>& wordsDict, string word1, string word2) {
        int length = wordsDict.size();
        int ans = length;
        if (word1 == word2) {
            int prev = -1;
            for (int i = 0; i < length; i++) {
                string word = wordsDict[i];
                if (word == word1) {
                    if (prev >= 0) {
                        ans = min(ans, i - prev);
                    }
                    prev = i;
                }
            }
        } else {
            int index1 = -1, index2 = -1;
            for (int i = 0; i < length; i++) {
                string word = wordsDict[i];
                if (word == word1) {
                    index1 = i;
                } else if (word == word2) {
                    index2 = i;
                }
                if (index1 >= 0 && index2 >= 0) {
                    ans = min(ans, abs(index1 - index2));
                }
            }
        }
        return ans;
    }
};
```

```C [sol1-C]
#define MIN(a, b) ((a) < (b) ? (a) : (b))

int shortestWordDistance(char ** wordsDict, int wordsDictSize, char * word1, char * word2){
    int ans = wordsDictSize;
    if (strcmp(word1, word2) == 0) {
        int prev = -1;
        for (int i = 0; i < wordsDictSize; i++) {
            if (strcmp(wordsDict[i], word1) == 0) {
                if (prev >= 0) {
                    ans = MIN(ans, i - prev);
                }
                prev = i;
            }
        }
    } else {
        int index1 = -1, index2 = -1;
        for (int i = 0; i < wordsDictSize; i++) {
            if (strcmp(wordsDict[i], word1) == 0) {
                index1 = i;
            } else if (strcmp(wordsDict[i], word2) == 0) {
                index2 = i;
            }
            if (index1 >= 0 && index2 >= 0) {
                ans = MIN(ans, abs(index1 - index2));
            }
        }
    }
    return ans;
}
```

```JavaScript [sol1-JavaScript]
var shortestWordDistance = function(wordsDict, word1, word2) {
    const length = wordsDict.length;
    let ans = length;
    if (word1 === word2) {
        let prev = -1;
        for (let i = 0; i < length; i++) {
            const word = wordsDict[i];
            if (word === word1) {
                if (prev >= 0) {
                    ans = Math.min(ans, i - prev);
                }
                prev = i;
            }
        }
    } else {
        let index1 = -1, index2 = -1;
        for (let i = 0; i < length; i++) {
            const word = wordsDict[i];
            if (word === word1) {
                index1 = i;
            } else if (word === word2) {
                index2 = i;
            }
            if (index1 >= 0 && index2 >= 0) {
                ans = Math.min(ans, Math.abs(index1 - index2));
            }
        }
    }
    return ans;
};
```

```go [sol1-Golang]
func shortestWordDistance(wordsDict []string, word1, word2 string) int {
    ans := len(wordsDict)
    if word1 == word2 {
        pre := -1
        for i, word := range wordsDict {
            if word == word1 {
                if pre >= 0 {
                    ans = min(ans, i-pre)
                }
                pre = i
            }
        }
    } else {
        index1, index2 := -1, -1
        for i, word := range wordsDict {
            if word == word1 {
                index1 = i
            } else if word == word2 {
                index2 = i
            }
            if index1 >= 0 && index2 >= 0 {
                ans = min(ans, abs(index1-index2))
            }
        }
    }
    return ans
}

func abs(x int) int {
    if x < 0 {
        return -x
    }
    return x
}

func min(a, b int) int {
    if a > b {
        return b
    }
    return a
}
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 是数组 $\textit{wordsDict}$ 的长度。需要遍历数组一次计算 $\textit{word}_1$ 和 $\textit{word}_2$ 的最短距离，每次更新下标和更新最短距离的时间都是 $O(1)$。这里将字符串的长度视为常数。

- 空间复杂度：$O(1)$。
#### 方法一：一次遍历

最直观的做法是遍历数组 $\textit{wordsDict}$，对于数组中的每个 $\textit{word}_1$，遍历数组 $\textit{wordsDict}$ 找到每个 $\textit{word}_2$ 并计算距离。该做法在最坏情况下的时间复杂度是 $O(n^2)$，需要优化。

为了降低时间复杂度，需要考虑其他的做法。从左到右遍历数组 $\textit{wordsDict}$，当遍历到 $\textit{word}_1$ 时，如果已经遍历的单词中存在 $\textit{word}_2$，为了计算最短距离，应该取最后一个已经遍历到的 $\textit{word}_2$ 所在的下标，计算和当前下标的距离。同理，当遍历到 $\textit{word}_2$ 时，应该取最后一个已经遍历到的 $\textit{word}_1$ 所在的下标，计算和当前下标的距离。

基于上述分析，可以遍历数组一次得到最短距离，将时间复杂度降低到 $O(n)$。

用 $\textit{index}_1$ 和 $\textit{index}_2$ 分别表示数组 $\textit{wordsDict}$ 已经遍历的单词中的最后一个 $\textit{word}_1$ 的下标和最后一个 $\textit{word}_2$ 的下标，初始时 $\textit{index}_1 = \textit{index}_2 = -1$。遍历数组 $\textit{wordsDict}$，当遇到 $\textit{word}_1$ 或 $\textit{word}_2$ 时，执行如下操作：

1. 如果遇到 $\textit{word}_1$，则将 $\textit{index}_1$ 更新为当前下标；如果遇到 $\textit{word}_2$，则将 $\textit{index}_2$ 更新为当前下标。

2. 如果 $\textit{index}_1$ 和 $\textit{index}_2$ 都非负，则计算两个下标的距离 $|\textit{index}_1 - \textit{index}_2|$，并用该距离更新最短距离。

遍历结束之后即可得到 $\textit{word}_1$ 和 $\textit{word}_2$ 的最短距离。

```Python [sol1-Python3]
class Solution:
    def shortestDistance(self, wordsDict: List[str], word1: str, word2: str) -> int:
        ans = len(wordsDict)
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
    public int shortestDistance(String[] wordsDict, String word1, String word2) {
        int length = wordsDict.length;
        int ans = length;
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
        return ans;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int ShortestDistance(string[] wordsDict, string word1, string word2) {
        int length = wordsDict.Length;
        int ans = length;
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
        return ans;
    }
}
```

```C++ [sol1-C++]
class Solution {
public:
    int shortestDistance(vector<string>& wordsDict, string word1, string word2) {
        int length = wordsDict.size();
        int ans = length;
        int index1 = -1, index2 = -1;
        for (int i = 0; i < length; i++) {
            if (wordsDict[i] == word1) {
                index1 = i;
            } else if (wordsDict[i] == word2) {
                index2 = i;
            }
            if (index1 >= 0 && index2 >= 0) {
                ans = min(ans, abs(index1 - index2));
            }
        }
        return ans;
    }
};
```

```C [sol1-C]
#define MIN(a, b) ((a) < (b) ? (a) : (b))

int shortestDistance(char ** wordsDict, int wordsDictSize, char * word1, char * word2){
    int ans = wordsDictSize;
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
    return ans;
}
```

```JavaScript [sol1-JavaScript]
var shortestDistance = function(wordsDict, word1, word2) {
    const length = wordsDict.length;
    let ans = length;
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
    return ans;
};
```

```go [sol1-Golang]
func shortestDistance(wordsDict []string, word1, word2 string) int {
    ans := len(wordsDict)
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
## [318.最大单词长度乘积 中文官方题解](https://leetcode.cn/problems/maximum-product-of-word-lengths/solutions/100000/zui-da-dan-ci-chang-du-cheng-ji-by-leetc-lym9)
#### 方法一：位运算

为了得到最大单词长度乘积，朴素的做法是，遍历字符串数组 $\textit{words}$ 中的每一对单词，判断这一对单词是否有公共字母，如果没有公共字母，则用这一对单词的长度乘积更新最大单词长度乘积。

用 $n$ 表示数组 $\textit{words}$ 的长度，用 $l_i$ 表示单词 $\textit{words}[i]$ 的长度，其中 $0 \le i < n$，则上述做法需要遍历字符串数组 $\textit{words}$ 中的每一对单词，对于下标为 $i$ 和 $j$ 的单词，其中 $i < j$，需要 $O(l_i \times l_j)$ 的时间判断是否有公共字母和计算长度乘积。因此上述做法的时间复杂度是 $O(\sum_{0 \le i < j < n} l_i \times l_j)$，该时间复杂度高于 $O(n^2)$。

如果可以将判断两个单词是否有公共字母的时间复杂度降低到 $O(1)$，则可以将总时间复杂度降低到 $O(n^2)$。可以使用位运算预处理每个单词，通过位运算操作判断两个单词是否有公共字母。由于单词只包含小写字母，共有 $26$ 个小写字母，因此可以使用位掩码的最低 $26$ 位分别表示每个字母是否在这个单词中出现。将 $\text{a}$ 到 $\text{z}$ 分别记为第 $0$ 个字母到第 $25$ 个字母，则位掩码的从低到高的第 $i$ 位是 $1$ 当且仅当第 $i$ 个字母在这个单词中，其中 $0 \le i \le 25$。

用数组 $\textit{masks}$ 记录每个单词的位掩码表示。计算数组 $\textit{masks}$ 之后，判断第 $i$ 个单词和第 $j$ 个单词是否有公共字母可以通过判断 $\textit{masks}[i]~\&~\textit{masks}[j]$ 是否等于 $0$ 实现，当且仅当 $\textit{masks}[i]~\&~\textit{masks}[j] = 0$ 时第 $i$ 个单词和第 $j$ 个单词没有公共字母，此时使用这两个单词的长度乘积更新最大单词长度乘积。

```Java [sol1-Java]
class Solution {
    public int maxProduct(String[] words) {
        int length = words.length;
        int[] masks = new int[length];
        for (int i = 0; i < length; i++) {
            String word = words[i];
            int wordLength = word.length();
            for (int j = 0; j < wordLength; j++) {
                masks[i] |= 1 << (word.charAt(j) - 'a');
            }
        }
        int maxProd = 0;
        for (int i = 0; i < length; i++) {
            for (int j = i + 1; j < length; j++) {
                if ((masks[i] & masks[j]) == 0) {
                    maxProd = Math.max(maxProd, words[i].length() * words[j].length());
                }
            }
        }
        return maxProd;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int MaxProduct(string[] words) {
        int length = words.Length;
        int[] masks = new int[length];
        for (int i = 0; i < length; i++) {
            String word = words[i];
            int wordLength = word.Length;
            for (int j = 0; j < wordLength; j++) {
                masks[i] |= 1 << (word[j] - 'a');
            }
        }
        int maxProd = 0;
        for (int i = 0; i < length; i++) {
            for (int j = i + 1; j < length; j++) {
                if ((masks[i] & masks[j]) == 0) {
                    maxProd = Math.Max(maxProd, words[i].Length * words[j].Length);
                }
            }
        }
        return maxProd;
    }
}
```

```C++ [sol1-C++]
class Solution {
public:
    int maxProduct(vector<string>& words) {
        int length = words.size();
        vector<int> masks(length);
        for (int i = 0; i < length; i++) {
            string word = words[i];
            int wordLength = word.size();
            for (int j = 0; j < wordLength; j++) {
                masks[i] |= 1 << (word[j] - 'a');
            }
        }
        int maxProd = 0;
        for (int i = 0; i < length; i++) {
            for (int j = i + 1; j < length; j++) {
                if ((masks[i] & masks[j]) == 0) {
                    maxProd = max(maxProd, int(words[i].size() * words[j].size()));
                }
            }
        }
        return maxProd;
    }
};
```

```JavaScript [sol1-JavaScript]
var maxProduct = function(words) {
    const length = words.length;
    const masks = new Array(length).fill(0);
    for (let i = 0; i < length; i++) {
        const word = words[i];
        const wordLength = word.length;
        for (let j = 0; j < wordLength; j++) {
            masks[i] |= 1 << (word[j].charCodeAt() - 'a'.charCodeAt());
        }
    }
    let maxProd = 0;
    for (let i = 0; i < length; i++) {
        for (let j = i + 1; j < length; j++) {
            if ((masks[i] & masks[j]) === 0) {
                maxProd = Math.max(maxProd, words[i].length * words[j].length);
            }
        }
    }
    return maxProd;
};
```

```go [sol1-Golang]
func maxProduct(words []string) (ans int) {
    masks := make([]int, len(words))
    for i, word := range words {
        for _, ch := range word {
            masks[i] |= 1 << (ch - 'a')
        }
    }

    for i, x := range masks {
        for j, y := range masks[:i] {
            if x&y == 0 && len(words[i])*len(words[j]) > ans {
                ans = len(words[i]) * len(words[j])
            }
        }
    }
    return
}
```

```Python [sol1-Python3]
class Solution:
    def maxProduct(self, words: List[str]) -> int:
        masks = [reduce(lambda a, b: a | (1 << (ord(b) - ord('a'))), word, 0) for word in words]
        return max((len(x[1]) * len(y[1]) for x, y in product(zip(masks, words), repeat=2) if x[0] & y[0] == 0), default=0)
```

**复杂度分析**

- 时间复杂度：$O(L + n^2)$，其中 $L$ 是数组 $\textit{words}$ 中的全部单词长度之和，$n$ 是数组 $\textit{words}$ 的长度。预处理每个单词的位掩码需要遍历全部单词的全部字母，时间复杂度是 $O(L)$，然后需要使用两重循环遍历位掩码数组 $\textit{masks}$ 计算最大单词长度乘积，时间复杂度是 $O(n^2)$，因此总时间复杂度是 $O(L + n^2)$。

- 空间复杂度：$O(n)$，其中 $n$ 是数组 $\textit{words}$ 的长度。需要创建长度为 $n$ 的位掩码数组 $\textit{masks}$。

#### 方法二：位运算优化

方法一需要对数组 $\textit{words}$ 中的每个单词计算位掩码，如果数组 $\textit{words}$ 中存在由相同的字母组成的不同单词，则会造成不必要的重复计算。例如单词 $\text{meet}$ 和 $\text{met}$ 包含的字母相同，只是字母的出现次数和单词长度不同，因此这两个单词的位掩码表示也相同。由于判断两个单词是否有公共字母是通过判断两个单词的位掩码的按位与运算实现，因此在位掩码相同的情况下，单词的长度不会影响是否有公共字母，当两个位掩码的按位与运算等于 $0$ 时，为了得到最大单词长度乘积，这两个位掩码对应的单词长度应该尽可能大。根据上述分析可知，如果有多个单词的位掩码相同，则只需要记录该位掩码对应的最大单词长度即可。

可以使用哈希表记录每个位掩码对应的最大单词长度，然后遍历哈希表中的每一对位掩码，如果这一对位掩码的按位与运算等于 $0$，则用这一对位掩码对应的长度乘积更新最大单词长度乘积。

由于每个单词的位掩码都不等于 $0$，任何一个不等于 $0$ 的数和自身做按位与运算的结果一定不等于 $0$，因此当一对位掩码的按位与运算等于 $0$ 时，这两个位掩码一定是不同的，对应的单词也一定是不同的。

```Java [sol2-Java]
class Solution {
    public int maxProduct(String[] words) {
        Map<Integer, Integer> map = new HashMap<Integer, Integer>();
        int length = words.length;
        for (int i = 0; i < length; i++) {
            int mask = 0;
            String word = words[i];
            int wordLength = word.length();
            for (int j = 0; j < wordLength; j++) {
                mask |= 1 << (word.charAt(j) - 'a');
            }
            if (wordLength > map.getOrDefault(mask, 0)) {
                map.put(mask, wordLength);
            }
        }
        int maxProd = 0;
        Set<Integer> maskSet = map.keySet();
        for (int mask1 : maskSet) {
            int wordLength1 = map.get(mask1);
            for (int mask2 : maskSet) {
                if ((mask1 & mask2) == 0) {
                    int wordLength2 = map.get(mask2);
                    maxProd = Math.max(maxProd, wordLength1 * wordLength2);
                }
            }
        }
        return maxProd;
    }
}
```

```C# [sol2-C#]
public class Solution {
    public int MaxProduct(string[] words) {
        Dictionary<int, int> dictionary = new Dictionary<int, int>();
        int length = words.Length;
        for (int i = 0; i < length; i++) {
            int mask = 0;
            String word = words[i];
            int wordLength = word.Length;
            for (int j = 0; j < wordLength; j++) {
                mask |= 1 << (word[j] - 'a');
            }
            if (dictionary.ContainsKey(mask)) {
                if (wordLength > dictionary[mask]) {
                    dictionary[mask] = wordLength;
                }
            } else {
                dictionary.Add(mask, wordLength);
            }
        }
        int maxProd = 0;
        foreach (int mask1 in dictionary.Keys) {
            int wordLength1 = dictionary[mask1];
            foreach (int mask2 in dictionary.Keys) {
                if ((mask1 & mask2) == 0) {
                    int wordLength2 = dictionary[mask2];
                    maxProd = Math.Max(maxProd, wordLength1 * wordLength2);
                }
            }
        }
        return maxProd;
    }
}
```

```C++ [sol2-C++]
class Solution {
public:
    int maxProduct(vector<string>& words) {
        unordered_map<int,int> map;
        int length = words.size();
        for (int i = 0; i < length; i++) {
            int mask = 0;
            string word = words[i];
            int wordLength = word.size();
            for (int j = 0; j < wordLength; j++) {
                mask |= 1 << (word[j] - 'a');
            }
            if(map.count(mask)) {
                if (wordLength > map[mask]) {
                    map[mask] = wordLength;
                }
            } else {
                map[mask] = wordLength;
            }
            
        }
        int maxProd = 0;
        for (auto [mask1, _] : map) {
            int wordLength1 = map[mask1];
            for (auto [mask2, _] : map) {
                if ((mask1 & mask2) == 0) {
                    int wordLength2 = map[mask2];
                    maxProd = max(maxProd, wordLength1 * wordLength2);
                }
            }
        }
        return maxProd;
    }
};
```

```JavaScript [sol2-JavaScript]
var maxProduct = function(words) {
    const map = new Map();
    const length = words.length;
    for (let i = 0; i < length; i++) {
        let mask = 0;
        const word = words[i];
        const wordLength = word.length;
        for (let j = 0; j < wordLength; j++) {
            mask |= 1 << (word[j].charCodeAt() - 'a'.charCodeAt());
        }
        if (wordLength > (map.get(mask) || 0)) {
            map.set(mask, wordLength);
        }
    }
    let maxProd = 0;
    const maskSet = Array.from(map.keys());
    for (const mask1 of maskSet) {
        const wordLength1 = map.get(mask1);
        for (const mask2 of maskSet) {
            if ((mask1 & mask2) === 0) {
                const wordLength2 = map.get(mask2);
                maxProd = Math.max(maxProd, wordLength1 * wordLength2);
            }
        }
    }
    return maxProd;
};
```

```go [sol2-Golang]
func maxProduct(words []string) (ans int) {
    masks := map[int]int{}
    for _, word := range words {
        mask := 0
        for _, ch := range word {
            mask |= 1 << (ch - 'a')
        }
        if len(word) > masks[mask] {
            masks[mask] = len(word)
        }
    }

    for x, lenX := range masks {
        for y, lenY := range masks {
            if x&y == 0 && lenX*lenY > ans {
                ans = lenX * lenY
            }
        }
    }
    return
}
```

```Python [sol2-Python3]
class Solution:
    def maxProduct(self, words: List[str]) -> int:
        masks = defaultdict(int)
        for word in words:
            mask = reduce(lambda a, b: a | (1 << (ord(b) - ord('a'))), word, 0)
            masks[mask] = max(masks[mask], len(word))
        return max((masks[x] * masks[y] for x, y in product(masks, repeat=2) if x & y == 0), default=0)
```

**复杂度分析**

- 时间复杂度：$O(L + n^2)$，其中 $L$ 是数组 $\textit{words}$ 中的全部单词长度之和，$n$ 是数组 $\textit{words}$ 的长度。预处理每个单词的位掩码并将位掩码对应的最大单词长度存入哈希表需要遍历全部单词的全部字母，时间复杂度是 $O(L)$，然后需要使用两重循环遍历哈希表计算最大单词长度乘积，时间复杂度是 $O(n^2)$，因此总时间复杂度是 $O(L + n^2)$。

- 空间复杂度：$O(n)$，其中 $n$ 是数组 $\textit{words}$ 的长度。需要创建哈希表记录每个位掩码对应的最大单词长度，哈希表中的记录数量不会超过 $n$。
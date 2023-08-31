## [2347.最好的扑克手牌 中文官方题解](https://leetcode.cn/problems/best-poker-hand/solutions/100000/zui-hao-de-bu-ke-shou-pai-by-leetcode-so-5zz2)

#### 方法一：哈希表 + 计数

**思路与算法**

题目给出 $5$ 张扑克牌和一个整数数组 $\textit{ranks}$ 与一个字符数组 $\textit{suits}$，其中第 $i$ 张牌的大小为 $\textit{ranks}[i]$，花色为 $\textit{suits}[i]$。现在从好到坏给出四种我们可能持有的「手牌类型」：

- $\text{Flush}$：同花，五张相同花色的扑克牌。
- $\text{Three of a Kind}$：三条，有 $3$ 张大小相同的扑克牌。
- $\text{Pair}$：对子，两张大小一样的扑克牌。
- $\text{High Card}$：高牌，五张大小互不相同的扑克牌。

我们需要给出我们手中 $5$ 张给出的扑克牌能组成的最好的手牌类型。因为扑克牌大小和扑克牌花色对于「手牌类型」的影响相互独立，所以首先我们将 $\textit{ranks}$ 和 $\textit{suits}$ 分别放入哈希表中进行计数，然后判断我们当前的「手牌类型」。

- 若 $\textit{suits}$ 放入哈希表后，哈希表中只有一个元素则说明该 $5$ 张扑克牌花色相同，为「同花」手牌，否则当前手牌不构成「同花」手牌。
- 若不为「同花」手牌，那么我们将 $\textit{ranks}$ 放入哈希表后，若哈希表中有 $5$ 个不同的元素，则该手牌只能为「高牌」，否则我们判断哈希表的构成中是否有一个数字个数大于等于 $3$，若有则说明该手牌为「三条」手牌，否则该手牌为「对子」。

**代码**

```Python [sol1-Python3]
class Solution:
    def bestHand(self, ranks: List[int], suits: List[str]) -> str:
        if len(set(suits)) == 1:
            return "Flush"
        h = Counter(ranks)
        if len(h) == 5:
            return "High Card"
        for [a, b] in h.items():
            if b > 2:
                return "Three of a Kind"
        return "Pair"
```

```Java [sol1-Java]
class Solution {
    public String bestHand(int[] ranks, char[] suits) {
        Set<Character> suitsSet = new HashSet<Character>();
        for (char suit : suits) {
            suitsSet.add(suit);
        }
        if (suitsSet.size() == 1) {
            return "Flush";
        }
        Map<Integer, Integer> h = new HashMap<Integer, Integer>();
        for (int rank : ranks) {
            h.put(rank, h.getOrDefault(rank, 0) + 1);
        }
        if (h.size() == 5) {
            return "High Card";
        }
        for (Map.Entry<Integer, Integer> entry : h.entrySet()) {
            if (entry.getValue() > 2) {
                return "Three of a Kind";
            }
        }
        return "Pair";
    }
}
```

```C# [sol1-C#]
public class Solution {
    public string BestHand(int[] ranks, char[] suits) {
        ISet<char> suitsSet = new HashSet<char>();
        foreach (char suit in suits) {
            suitsSet.Add(suit);
        }
        if (suitsSet.Count == 1) {
            return "Flush";
        }
        IDictionary<int, int> h = new Dictionary<int, int>();
        foreach (int rank in ranks) {
            h.TryAdd(rank, 0);
            h[rank]++;
        }
        if (h.Count == 5) {
            return "High Card";
        }
        foreach (KeyValuePair<int, int> pair in h) {
            if (pair.Value > 2) {
                return "Three of a Kind";
            }
        }
        return "Pair";
    }
}
```

```C++ [sol1-C++]
class Solution {
public:
    string bestHand(vector<int>& ranks, vector<char>& suits) {
        unordered_set<char> suitsSet;
        for (char suit : suits) {
            suitsSet.emplace(suit);
        }
        if (suitsSet.size() == 1) {
            return "Flush";
        }
        unordered_map<int, int> h;
        for (int rank : ranks) {
            h[rank]++;
        }
        if (h.size() == 5) {
            return "High Card";
        }
        for (auto [_, val] : h) {
            if (val > 2) {
                return "Three of a Kind";
            }
        }
        return "Pair";
    }
};
```

```C [sol1-C]
char * bestHand(int* ranks, int ranksSize, char* suits, int suitsSize) {
    int suitsSet = 0;
    for (int i = 0; i < suitsSize; i++) {
        suitsSet |= 1 << (suits[i] - 'a');
    }
    if (__builtin_popcount(suitsSet) == 1) {
        return "Flush";
    }
    int h[16];
    memset(h, 0, sizeof(h));
    for (int i = 0; i < ranksSize; i++) {
        h[ranks[i]]++;
    }
    int cnt = 0;
    for (int i = 0; i < 16; i++) {
        if (h[i] > 2) {
            return "Three of a Kind";
        } else if (h[i] == 1) {
            cnt++;
        }
    }
    if (cnt == 5) {
        return "High Card";
    }
    return "Pair";
}
```

```JavaScript [sol1-JavaScript]
var bestHand = function(ranks, suits) {
    const suitsSet = new Set();
    for (const suit of suits) {
        suitsSet.add(suit);
    }
    if (suitsSet.size === 1) {
        return "Flush";
    }
    const h = new Map();
    for (const rank of ranks) {
        h.set(rank, (h.get(rank) || 0) + 1);
    }
    if (h.size === 5) {
        return "High Card";
    }
    for (const value of h.values()) {
        if (value > 2) {
            return "Three of a Kind";
        }
    }
    return "Pair";
};
```

```go [sol1-Golang]
func bestHand(ranks []int, suits []byte) string {
    if bytes.Count(suits, suits[:1]) == 5 {
        return "Flush"
    }
    cnt, pair := map[int]int{}, false
    for _, r := range ranks {
        cnt[r]++
        if cnt[r] == 3 {
            return "Three of a Kind"
        }
        if cnt[r] == 2 {
            pair = true
        }
    }
    if pair {
        return "Pair"
    }
    return "High Card"
}
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 为数组 $\textit{ranks}$ 的长度。
- 空间复杂度：$O(n)$，其中 $n$ 为数组 $\textit{ranks}$ 的长度。主要为哈希表的存储开销。
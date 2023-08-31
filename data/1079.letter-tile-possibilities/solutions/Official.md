## [1079.活字印刷 中文官方题解](https://leetcode.cn/problems/letter-tile-possibilities/solutions/100000/huo-zi-yin-shua-by-leetcode-solution-e49s)
#### 方法一：回溯

**思路与算法**

题目要求返回非空字母序列的数目。我们首先统计所有字符的个数，然后用回溯来查找所有排列。

每次搜索中，我们依次遍历所有剩余的字符，每次遍历选用当前字符，将当前字符减一，递归调用搜索函数，累计搜索完成后的结果，再把当前字符数量加一进行「回溯」。

递归循环的结束条件是第 $n$ 次递归，此时我们用完了所有字符，找到一个可行字母序列，返回结果为 $1$。

最后我们返回搜索到的所有字符串，因为题目要求返回非空字符串的数目，所以结果还要减一。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    int numTilePossibilities(string tiles) {
        unordered_map<char, int> count;
        set<char> tile;
        int n = tiles.length();
        for (char c : tiles) {
            count[c]++;
            tile.insert(c);
        }
        return dfs(count, tile, n) - 1;
    }

    int dfs(unordered_map<char, int>& count, set<char>& tile, int i) {
        if (i == 0) {
            return 1;
        }
        int res = 1;
        for (char t : tile) {
            if (count[t] > 0) {
                count[t]--;
                res += dfs(count, tile, i - 1);
                count[t]++;
            }
        }
        return res;
    }
};
```

```Java [sol1-Java]
class Solution {
    public int numTilePossibilities(String tiles) {
        Map<Character, Integer> count = new HashMap<>();
        for (char t : tiles.toCharArray()) {
            count.put(t, count.getOrDefault(t, 0) + 1);
        }
        Set<Character> tile = new HashSet<>(count.keySet());
        return dfs(tiles.length(), count, tile) - 1;
    }

    private int dfs(int i, Map<Character, Integer> count, Set<Character> tile) {
        if (i == 0) {
            return 1;
        }
        int res = 1;
        for (char t : tile) {
            if (count.get(t) > 0) {
                count.put(t, count.get(t) - 1);
                res += dfs(i - 1, count, tile);
                count.put(t, count.get(t) + 1);
            }
        }
        return res;
    }
}
```

```Python [sol1-Python3]
class Solution:
    def numTilePossibilities(self, tiles: str) -> int:
        count = Counter(tiles)
        tile = set(tiles)

        def dfs(i):
            if i == 0:
                return 1
            res = 1
            for t in tile:
                if count[t] > 0:
                    count[t] -= 1
                    res += dfs(i - 1)
                    count[t] += 1
            return res

        return dfs(len(tiles)) - 1
```

```Go [sol1-Go]
func numTilePossibilities(tiles string) int {
    count := make(map[rune]int)
    for _, t := range tiles {
        count[t]++
    }
    return dfs(len(tiles), count) - 1
}

func dfs(i int, count map[rune]int) int {
    if i == 0 {
        return 1
    }
    res := 1
    for t := range count {
        if count[t] > 0 {
            count[t]--
            res += dfs(i - 1, count)
            count[t]++
        }
    }
    return res
}
```

```JavaScript [sol1-JavaScript]
var numTilePossibilities = function(tiles) {
    const count = new Map()
    for (let t of tiles) {
        count.set(t, (count.get(t) || 0) + 1)
    }
    const tile = new Set(tiles)
    const n = tiles.length

    function dfs(i) {
        if (i == n) {
            return 1
        }
        let res = 1
        for (let t of tile) {
            if (count.get(t) > 0) {
                count.set(t, count.get(t) - 1)
                res += dfs(i + 1)
                count.set(t, count.get(t) + 1)
            }
        }
        return res
    }

    return dfs(0) - 1
}
```

```C# [sol1-C#]
public class Solution {
    public int NumTilePossibilities(string tiles) {
        IDictionary<char, int> count = new Dictionary<char, int>();
        foreach (char t in tiles) {
            if (count.ContainsKey(t)) {
                count[t]++;
            } else {
                count.Add(t, 1);
            }
        }
        ISet<char> tile = new HashSet<char>(count.Keys);
        return DFS(tiles.Length, count, tile) - 1;
    }

    private int DFS(int i, IDictionary<char, int> count, ISet<char> tile) {
        if (i == 0) {
            return 1;
        }
        int res = 1;
        foreach (char t in tile) {
            if (count[t] > 0) {
                count[t]--;
                res += DFS(i - 1, count, tile);
                count[t]++;
            }
        }
        return res;
    }
}
```

```C [sol1-C]
 int dfs(int *count, const char *tile, int i) {
    if (i == 0) {
        return 1;
    }
    int res = 1;
    for (int j = 0; tile[j] != '\0'; j++) {
        int t = tile[j];
        if (count[t - 'A'] > 0) {
            count[t - 'A']--;
            res += dfs(count, tile, i - 1);
            count[t - 'A']++;
        }
    }
    return res;
}

int numTilePossibilities(char * tiles) {
    int n = strlen(tiles);
    int count[26] = {0};
    char tile[27] = {0};
    for (int i = 0; i < n; i++) {
        char c = tiles[i];
        count[c - 'A']++;
    }
    int pos = 0;
    for (int i = 0; i < 26; i++) {
        if (count[i] > 0) {
            tile[pos++] = 'A' + i;
        }
    }
    tile[pos] = '\0';
    return dfs(count, tile, n) - 1;
}
```

**复杂度分析**

在最差情况下，所有字符互不相同，总共有 $n!$ 个结果，对应 $\textit{dfs}$ 有 $n!$ 个状态，每个状态有 $O(n)$ 的搜索复杂度。

- 时间复杂度：$O(n \times n!)$，其中 $n$ 表示 $\textit{tiles}$ 长度的最小值。

- 空间复杂度：$O(n)$， 其中 $n$ 表示字符集大小和 $\textit{tiles}$ 长度的最小值。
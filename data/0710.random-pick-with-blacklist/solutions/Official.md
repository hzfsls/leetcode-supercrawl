## [710.黑名单中的随机数 中文官方题解](https://leetcode.cn/problems/random-pick-with-blacklist/solutions/100000/hei-ming-dan-zhong-de-sui-ji-shu-by-leet-cyrx)

#### 方法一：黑名单映射

设 $\textit{blacklist}$ 的长度为 $m$。

考察一个特殊的例子：所有黑名单数全部在区间 $[n-m,n)$ 范围内。此时我们可以直接在 $[0,n-m)$ 范围内取随机整数。

这给我们一个启示，对于在 $[0,n-m)$ 范围内的黑名单数，我们可以将其映射到 $[n-m,n)$ 范围内的非黑名单数（白名单数）上。每次 $\text{pick()}$ 时，仍然可以在 $[0,n-m)$ 范围内取随机整数（设其为 $x$），那么：

- 如果 $x$ 不在黑名单中，则直接返回 $x$；
- 如果 $x$ 在黑名单中，则返回 $x$ 映射到 $[n-m,n)$ 范围内的白名单数。

我们可以在初始化时，构建一个从 $[0,n-m)$ 范围内的黑名单数到 $[n-m,n)$ 的白名单数的映射：

1. 将 $[n-m,n)$ 范围内的黑名单数存入一个哈希集合 $\textit{black}$；
2. 初始化白名单数 $\textit{w}=n-m$；
3. 对于每个 $[0,n-m)$ 范围内的黑名单数 $b$，首先不断增加 $\textit{w}$ 直至其不在黑名单中，然后将 $b$ 映射到 $\textit{w}$ 上，并将 $\textit{w}$ 增加一。

```Python [sol1-Python3]
class Solution:
    def __init__(self, n: int, blacklist: List[int]):
        m = len(blacklist)
        self.bound = w = n - m
        black = {b for b in blacklist if b >= self.bound}
        self.b2w = {}
        for b in blacklist:
            if b < self.bound:
                while w in black:
                    w += 1
                self.b2w[b] = w
                w += 1

    def pick(self) -> int:
        x = randrange(self.bound)
        return self.b2w.get(x, x)
```

```C++ [sol1-C++]
class Solution {
    unordered_map<int, int> b2w;
    int bound;

public:
    Solution(int n, vector<int> &blacklist) {
        int m = blacklist.size();
        bound = n - m;
        unordered_set<int> black;
        for (int b: blacklist) {
            if (b >= bound) {
                black.emplace(b);
            }
        }

        int w = bound;
        for (int b: blacklist) {
            if (b < bound) {
                while (black.count(w)) {
                    ++w;
                }
                b2w[b] = w++;
            }
        }
    }

    int pick() {
        int x = rand() % bound;
        return b2w.count(x) ? b2w[x] : x;
    }
};
```

```Java [sol1-Java]
class Solution {
    Map<Integer, Integer> b2w;
    Random random;
    int bound;

    public Solution(int n, int[] blacklist) {
        b2w = new HashMap<Integer, Integer>();
        random = new Random();
        int m = blacklist.length;
        bound = n - m;
        Set<Integer> black = new HashSet<Integer>();
        for (int b : blacklist) {
            if (b >= bound) {
                black.add(b);
            }
        }

        int w = bound;
        for (int b : blacklist) {
            if (b < bound) {
                while (black.contains(w)) {
                    ++w;
                }
                b2w.put(b, w);
                ++w;
            }
        }
    }

    public int pick() {
        int x = random.nextInt(bound);
        return b2w.getOrDefault(x, x);
    }
}
```

```C# [sol1-C#]
public class Solution {
    Dictionary<int, int> b2w;
    Random random;
    int bound;

    public Solution(int n, int[] blacklist) {
        b2w = new Dictionary<int, int>();
        random = new Random();
        int m = blacklist.Length;
        bound = n - m;
        ISet<int> black = new HashSet<int>();
        foreach (int b in blacklist) {
            if (b >= bound) {
                black.Add(b);
            }
        }

        int w = bound;
        foreach (int b in blacklist) {
            if (b < bound) {
                while (black.Contains(w)) {
                    ++w;
                }
                b2w.Add(b, w);
                ++w;
            }
        }
    }

    public int Pick() {
        int x = random.Next(bound);
        return b2w.ContainsKey(x) ? b2w[x] : x;
    }
}
```

```go [sol1-Golang]
type Solution struct {
    b2w   map[int]int
    bound int
}

func Constructor(n int, blacklist []int) Solution {
    m := len(blacklist)
    bound := n - m
    black := map[int]bool{}
    for _, b := range blacklist {
        if b >= bound {
            black[b] = true
        }
    }

    b2w := make(map[int]int, m-len(black))
    w := bound
    for _, b := range blacklist {
        if b < bound {
            for black[w] {
                w++
            }
            b2w[b] = w
            w++
        }
    }
    return Solution{b2w, bound}
}

func (s *Solution) Pick() int {
    x := rand.Intn(s.bound)
    if s.b2w[x] > 0 {
        return s.b2w[x]
    }
    return x
}
```

```C [sol1-C]
typedef struct {
    int key;
    int val;
    UT_hash_handle hh;
} HashItem;

typedef struct {
    HashItem *b2w;
    int bound;
} Solution;

Solution* solutionCreate(int n, int* blacklist, int blacklistSize) {
    Solution *obj = (Solution *)malloc(sizeof(Solution));
    obj->b2w = NULL;
    obj->bound = n - blacklistSize;
    HashItem *black = NULL;
    for (int i = 0; i < blacklistSize; i++) {
        int b = blacklist[i];
        if (b >= obj->bound) {
            HashItem *pEntry = NULL;
            HASH_FIND_INT(black, &b, pEntry);
            if (NULL == pEntry) {
                pEntry = (HashItem *)malloc(sizeof(HashItem));
                pEntry->key = b;
                pEntry->val = 0;
                HASH_ADD_INT(black, key, pEntry);
            }
        }
    }
    int w = obj->bound;
    for (int i = 0; i < blacklistSize; i++) {
        int b = blacklist[i];
        if (b < obj->bound) {
            HashItem *pEntry = NULL;
            do {
                pEntry = NULL;
                HASH_FIND_INT(black, &w, pEntry);
                if (pEntry) {
                    ++w;
                }
            } while(pEntry);
            pEntry = NULL;
            HASH_FIND_INT(obj->b2w, &b, pEntry);
            if (pEntry == NULL) {
                pEntry = (HashItem *)malloc(sizeof(HashItem));
                pEntry->key = b;
                HASH_ADD_INT(obj->b2w, key, pEntry);
            } 
            pEntry->val = w++;
        }
    }
    HashItem *curr, *tmp;
    HASH_ITER(hh, black, curr, tmp) {
        HASH_DEL(black, curr); 
        free(curr);        
    }
    return obj;
}

int solutionPick(Solution* obj) {
    int x = rand() % obj->bound;
    HashItem *pEntry = NULL;
    HASH_FIND_INT(obj->b2w, &x, pEntry);
    return pEntry != NULL ? pEntry->val : x;
}

void solutionFree(Solution* obj) {
    HashItem *curr, *tmp;
    HASH_ITER(hh, obj->b2w, curr, tmp) {
        HASH_DEL(obj->b2w, curr);  
        free(curr);        
    }
    free(obj);
}
```

```JavaScript [sol1-JavaScript]
var Solution = function(n, blacklist) {
    this.b2w = new Map();
    const m = blacklist.length;
    this.bound = n - m;
    const black = new Set();
    for (const b of blacklist) {
        if (b >= this.bound) {
            black.add(b);
        }
    }

    let w = this.bound;
    for (const b of blacklist) {
        if (b < this.bound) {
            while (black.has(w)) {
                ++w;
            }
            this.b2w.set(b, w);
            ++w;
        }
    }
};

Solution.prototype.pick = function() {
    const x = Math.floor(Math.random() * this.bound);
    return this.b2w.get(x) || x;
};
```

**复杂度分析**

- 时间复杂度：初始化为 $O(m)$，$\text{pick()}$ 为 $O(1)$，其中 $m$ 是数组 $\textit{blacklist}$ 的长度。在初始化结束时，$[n-m,n)$ 内的每个数字要么是黑名单数，要么被一个黑名单数所映射，因此 $\textit{white}$ 会恰好增加 $m$ 次，因此初始化的时间复杂度为 $O(m)$。

- 空间复杂度：$O(m)$。哈希表需要 $O(m)$ 的空间。
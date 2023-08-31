## [839.相似字符串组 中文官方题解](https://leetcode.cn/problems/similar-string-groups/solutions/100000/xiang-si-zi-fu-chuan-zu-by-leetcode-solu-8jt9)
#### 方法一：并查集

**思路及解法**

我们把每一个字符串看作点，字符串之间是否相似看作边，那么可以发现本题询问的是给定的图中有多少连通分量。于是可以想到使用并查集维护节点间的连通性。

我们枚举给定序列中的任意一对字符串，检查其是否具有相似性，如果相似，那么我们就将这对字符串相连。

在实际代码中，我们可以首先判断当前这对字符串是否已经连通，如果没有连通，我们再检查它们是否具有相似性，可以优化一定的时间复杂度的常数。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    vector<int> f;

    int find(int x) {
        return f[x] == x ? x : f[x] = find(f[x]);
    }

    bool check(const string &a, const string &b, int len) {
        int num = 0;
        for (int i = 0; i < len; i++) {
            if (a[i] != b[i]) {
                num++;
                if (num > 2) {
                    return false;
                }
            }
        }
        return true;
    }

    int numSimilarGroups(vector<string> &strs) {
        int n = strs.size();
        int m = strs[0].length();
        f.resize(n);
        for (int i = 0; i < n; i++) {
            f[i] = i;
        }
        for (int i = 0; i < n; i++) {
            for (int j = i + 1; j < n; j++) {
                int fi = find(i), fj = find(j);
                if (fi == fj) {
                    continue;
                }
                if (check(strs[i], strs[j], m)) {
                    f[fi] = fj;
                }
            }
        }
        int ret = 0;
        for (int i = 0; i < n; i++) {
            if (f[i] == i) {
                ret++;
            }
        }
        return ret;
    }
};
```

```Java [sol1-Java]
class Solution {
    int[] f;

    public int numSimilarGroups(String[] strs) {
        int n = strs.length;
        int m = strs[0].length();
        f = new int[n];
        for (int i = 0; i < n; i++) {
            f[i] = i;
        }
        for (int i = 0; i < n; i++) {
            for (int j = i + 1; j < n; j++) {
                int fi = find(i), fj = find(j);
                if (fi == fj) {
                    continue;
                }
                if (check(strs[i], strs[j], m)) {
                    f[fi] = fj;
                }
            }
        }
        int ret = 0;
        for (int i = 0; i < n; i++) {
            if (f[i] == i) {
                ret++;
            }
        }
        return ret;
    }

    public int find(int x) {
        return f[x] == x ? x : (f[x] = find(f[x]));
    }

    public boolean check(String a, String b, int len) {
        int num = 0;
        for (int i = 0; i < len; i++) {
            if (a.charAt(i) != b.charAt(i)) {
                num++;
                if (num > 2) {
                    return false;
                }
            }
        }
        return true;
    }
}
```

```JavaScript [sol1-JavaScript]
var numSimilarGroups = function(strs) {
    const n = strs.length;
    const m = strs[0].length;
    const f = new Array(n).fill(0).map((element, index) => index);

    for (let i = 0; i < n; i++) {
        for (let j = i + 1; j < n; j++) {
            const fi = find(i), fj = find(j);
            if (fi === fj) {
                continue;
            }
            if (check(strs[i], strs[j], m)) {
                f[fi] = fj;
            }
        }
    }
    let ret = 0;
    for (let i = 0; i < n; i++) {
        if (f[i] === i) {
            ret++;
        }
    }
    return ret;

    function find(x) {
        return f[x] === x ? x : (f[x] = find(f[x]));
    }

    function check(a, b, len) {
        let num = 0;
        for (let i = 0; i < len; i++) {
            if (a[i] !== b[i]) {
                num++;
                if (num > 2) {
                    return false;
                }
            }
        }
        return true;
    }
};
```

```Python [sol1-Python3]
class Solution:
    def numSimilarGroups(self, strs: List[str]) -> int:
        n = len(strs)
        f = list(range(n))

        def find(x: int) -> int:
            if f[x] == x:
                return x
            f[x] = find(f[x])
            return f[x]
        
        def check(a: str, b: str) -> bool:
            num = 0
            for ac, bc in zip(a, b):
                if ac != bc:
                    num += 1
                    if num > 2:
                        return False
            return True
        
        for i in range(n):
            for j in range(i + 1, n):
                fi, fj = find(i), find(j)
                if fi == fj:
                    continue
                if check(strs[i], strs[j]):
                    f[fi] = fj
        
        ret = sum(1 for i in range(n) if f[i] == i)
        return ret
```

```go [sol1-Golang]
type unionFind struct {
    parent, size []int
    setCount     int // 当前连通分量数目
}

func newUnionFind(n int) *unionFind {
    parent := make([]int, n)
    size := make([]int, n)
    for i := range parent {
        parent[i] = i
        size[i] = 1
    }
    return &unionFind{parent, size, n}
}

func (uf *unionFind) find(x int) int {
    if uf.parent[x] != x {
        uf.parent[x] = uf.find(uf.parent[x])
    }
    return uf.parent[x]
}

func (uf *unionFind) union(x, y int) {
    fx, fy := uf.find(x), uf.find(y)
    if fx == fy {
        return
    }
    if uf.size[fx] < uf.size[fy] {
        fx, fy = fy, fx
    }
    uf.size[fx] += uf.size[fy]
    uf.parent[fy] = fx
    uf.setCount--
}

func (uf *unionFind) inSameSet(x, y int) bool {
    return uf.find(x) == uf.find(y)
}

func isSimilar(s, t string) bool {
    diff := 0
    for i := range s {
        if s[i] != t[i] {
            diff++
            if diff > 2 {
                return false
            }
        }
    }
    return true
}

func numSimilarGroups(strs []string) int {
    n := len(strs)
    uf := newUnionFind(n)
    for i, s := range strs {
        for j := i + 1; j < n; j++ {
            if !uf.inSameSet(i, j) && isSimilar(s, strs[j]) {
                uf.union(i, j)
            }
        }
    }
    return uf.setCount
}
```

```C [sol1-C]
int find(int *f, int x) {
    return f[x] == x ? x : (f[x] = find(f, f[x]));
}

bool check(char *a, char *b, int len) {
    int num = 0;
    for (int i = 0; i < len; i++) {
        if (a[i] != b[i]) {
            num++;
            if (num > 2) {
                return false;
            }
        }
    }
    return true;
}

int numSimilarGroups(char **strs, int strsSize) {
    int n = strsSize;
    int m = strlen(strs[0]);
    int f[n];
    for (int i = 0; i < n; i++) {
        f[i] = i;
    }
    for (int i = 0; i < n; i++) {
        for (int j = i + 1; j < n; j++) {
            int fi = find(f, i), fj = find(f, j);
            if (fi == fj) {
                continue;
            }
            if (check(strs[i], strs[j], m)) {
                f[fi] = fj;
            }
        }
    }
    int ret = 0;
    for (int i = 0; i < n; i++) {
        if (f[i] == i) {
            ret++;
        }
    }
    return ret;
}
```

**复杂度分析**

- 时间复杂度：$O(n^2m + n \log n))$，其中 $n$ 是字符串的数量。我们需要 $O(n^2)$ 地枚举任意一对字符串之间的关系，对于任意一对字符串，我们需要 $O(m)$ 的时间检查字符串是否相同。在最坏情况下我们需要对并查集执行 $O(n)$ 次合并，合并的均摊时间复杂度 $O(\log n)$。综上，总的时间复杂度为 $O(n^2m + n \log n))$。

- 空间复杂度：$O(n)$，其中 $n$ 是字符串的数量。并查集需要 $O(n)$ 的空间。
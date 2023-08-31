## [952.按公因数计算最大组件大小 中文官方题解](https://leetcode.cn/problems/largest-component-size-by-common-factor/solutions/100000/an-gong-yin-shu-ji-suan-zui-da-zu-jian-d-amdx)

#### 方法一：并查集

为了得到数组 $\textit{nums}$ 中的每个数和哪些数属于同一个组件，需要得到数组 $\textit{nums}$ 中的最大值 $m$，对于每个不超过 $m$ 的正整数 $\textit{num}$ 计算 $\textit{num}$ 和哪些数属于同一个组件。对于范围 $[2, \sqrt{\textit{num}}]$ 内的每个正整数 $i$，如果 $i$ 是 $\textit{num}$ 的因数，则 $\textit{num}$ 和 $i$、$\dfrac{\textit{num}}{i}$ 都属于同一个组件。

可以使用并查集实现组件的计算。初始时，每个数分别属于不同的组件。如果两个正整数满足其中一个正整数是另一个正整数的因数，则这两个正整数属于同一个组件，将这两个正整数的组件合并。

当所有不超过 $m$ 的正整数都完成合并操作之后。遍历数组 $\textit{nums}$，对于每个数得到其所在的组件并更新该组件的大小，遍历结束之后即可得到最大组件的大小。

```Python [sol1-Python3]
class UnionFind:
    def __init__(self, n: int):
        self.parent = list(range(n))
        self.rank = [0] * n

    def find(self, x: int) -> int:
        if self.parent[x] != x:
            self.parent[x] = self.find(self.parent[x])
        return self.parent[x]

    def merge(self, x: int, y: int) -> None:
        x, y = self.find(x), self.find(y)
        if x == y:
            return
        if self.rank[x] > self.rank[y]:
            self.parent[y] = x
        elif self.rank[x] < self.rank[y]:
            self.parent[x] = y
        else:
            self.parent[y] = x
            self.rank[x] += 1

class Solution:
    def largestComponentSize(self, nums: List[int]) -> int:
        uf = UnionFind(max(nums) + 1)
        for num in nums:
            i = 2
            while i * i <= num:
                if num % i == 0:
                    uf.merge(num, i)
                    uf.merge(num, num // i)
                i += 1
        return max(Counter(uf.find(num) for num in nums).values())
```

```Java [sol1-Java]
class Solution {
    public int largestComponentSize(int[] nums) {
        int m = Arrays.stream(nums).max().getAsInt();
        UnionFind uf = new UnionFind(m + 1);
        for (int num : nums) {
            for (int i = 2; i * i <= num; i++) {
                if (num % i == 0) {
                    uf.union(num, i);
                    uf.union(num, num / i);
                }
            }
        }
        int[] counts = new int[m + 1];
        int ans = 0;
        for (int num : nums) {
            int root = uf.find(num);
            counts[root]++;
            ans = Math.max(ans, counts[root]);
        }
        return ans;
    }
}

class UnionFind {
    int[] parent;
    int[] rank;

    public UnionFind(int n) {
        parent = new int[n];
        for (int i = 0; i < n; i++) {
            parent[i] = i;
        }
        rank = new int[n];
    }

    public void union(int x, int y) {
        int rootx = find(x);
        int rooty = find(y);
        if (rootx != rooty) {
            if (rank[rootx] > rank[rooty]) {
                parent[rooty] = rootx;
            } else if (rank[rootx] < rank[rooty]) {
                parent[rootx] = rooty;
            } else {
                parent[rooty] = rootx;
                rank[rootx]++;
            }
        }
    }

    public int find(int x) {
        if (parent[x] != x) {
            parent[x] = find(parent[x]);
        }
        return parent[x];
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int LargestComponentSize(int[] nums) {
        int m = nums.Max();
        UnionFind uf = new UnionFind(m + 1);
        foreach (int num in nums) {
            for (int i = 2; i * i <= num; i++) {
                if (num % i == 0) {
                    uf.Union(num, i);
                    uf.Union(num, num / i);
                }
            }
        }
        int[] counts = new int[m + 1];
        int ans = 0;
        foreach (int num in nums) {
            int root = uf.Find(num);
            counts[root]++;
            ans = Math.Max(ans, counts[root]);
        }
        return ans;
    }
}

class UnionFind {
    int[] parent;
    int[] rank;

    public UnionFind(int n) {
        parent = new int[n];
        for (int i = 0; i < n; i++) {
            parent[i] = i;
        }
        rank = new int[n];
    }

    public void Union(int x, int y) {
        int rootx = Find(x);
        int rooty = Find(y);
        if (rootx != rooty) {
            if (rank[rootx] > rank[rooty]) {
                parent[rooty] = rootx;
            } else if (rank[rootx] < rank[rooty]) {
                parent[rootx] = rooty;
            } else {
                parent[rooty] = rootx;
                rank[rootx]++;
            }
        }
    }

    public int Find(int x) {
        if (parent[x] != x) {
            parent[x] = Find(parent[x]);
        }
        return parent[x];
    }
}
```

```C++ [sol1-C++]
class UnionFind {
public:
    UnionFind(int n) {
        parent = vector<int>(n);
        rank = vector<int>(n);
        for (int i = 0; i < n; i++) {
            parent[i] = i;
        }
    }

    void uni(int x, int y) {
        int rootx = find(x);
        int rooty = find(y);
        if (rootx != rooty) {
            if (rank[rootx] > rank[rooty]) {
                parent[rooty] = rootx;
            } else if (rank[rootx] < rank[rooty]) {
                parent[rootx] = rooty;
            } else {
                parent[rooty] = rootx;
                rank[rootx]++;
            }
        }
    }

    int find(int x) {
        if (parent[x] != x) {
            parent[x] = find(parent[x]);
        }
        return parent[x];
    }
private:
    vector<int> parent;
    vector<int> rank;
};

class Solution {
public:
    int largestComponentSize(vector<int>& nums) {
        int m = *max_element(nums.begin(), nums.end());
        UnionFind uf(m + 1);
        for (int num : nums) {
            for (int i = 2; i * i <= num; i++) {
                if (num % i == 0) {
                    uf.uni(num, i);
                    uf.uni(num, num / i);
                }
            }
        }
        vector<int> counts(m + 1);
        int ans = 0;
        for (int num : nums) {
            int root = uf.find(num);
            counts[root]++;
            ans = max(ans, counts[root]);
        }
        return ans;
    }
};
```

```C [sol1-C]
#define MAX(a, b) ((a) > (b) ? (a) : (b))

typedef struct UnionFind {
    int *parent;
    int *rank;
} UnionFind;

UnionFind* unionFindCreate(int n) {
    UnionFind *obj = (UnionFind *)malloc(sizeof(UnionFind));
    obj->parent = (int *)malloc(sizeof(int) * n);
    obj->rank = (int *)malloc(sizeof(int) * n);
    memset(obj->rank, 0, sizeof(int) * n);
    for (int i = 0; i < n; i++) {
        obj->parent[i] = i;
    }
    return obj;
}

int find(const UnionFind *obj, int x) {
    if (obj->parent[x] != x) {
        obj->parent[x] = find(obj, obj->parent[x]);
    }
    return obj->parent[x];
}

void uni(UnionFind *obj, int x, int y) {
    int rootx = find(obj, x);
    int rooty = find(obj, y);
    if (rootx != rooty) {
        if (obj->rank[rootx] > obj->rank[rooty]) {
            obj->parent[rooty] = rootx;
        } else if (obj->rank[rootx] < obj->rank[rooty]) {
            obj->parent[rootx] = rooty;
        } else {
            obj->parent[rooty] = rootx;
            obj->rank[rootx]++;
        }
    }
}

void unionFindFree(UnionFind *obj) {
    free(obj->parent);
    free(obj->rank);
    free(obj);
}

int largestComponentSize(int* nums, int numsSize) {
    int m = nums[0];
    for (int i = 0; i < numsSize; i++) {
        m = MAX(m, nums[i]);
    }
    UnionFind *uf = unionFindCreate(m + 1);
    for (int i = 0; i < numsSize; i++) {
        int num = nums[i];
        for (int i = 2; i * i <= num; i++) {
            if (num % i == 0) {
                uni(uf, num, i);
                uni(uf, num, num / i);
            }
        }
    }
    int *counts = (int *)malloc(sizeof(int) * (m + 1));
    memset(counts, 0, sizeof(int) * (m + 1));
    int ans = 0;
    for (int i = 0; i < numsSize; i++) {
        int root = find(uf, nums[i]);
        counts[root]++;
        ans = MAX(ans, counts[root]);
    }
    free(counts);
    unionFindFree(uf);
    return ans;
}
```

```JavaScript [sol1-JavaScript]
var largestComponentSize = function(nums) {
    const m = _.max(nums);;
    const uf = new UnionFind(m + 1);
    for (const num of nums) {
        for (let i = 2; i * i <= num; i++) {
            if (num % i === 0) {
                uf.union(num, i);
                uf.union(num, Math.floor(num / i));
            }
        }
    }
    const counts = new Array(m + 1).fill(0);
    let ans = 0;
    for (let num of nums) {
        const root = uf.find(num);
        counts[root]++;
        ans = Math.max(ans, counts[root]);
    }
    return ans;
};

class UnionFind {
    constructor(n) {
        this.parent = new Array(n).fill(0).map((_, i) => i);
        this.rank = new Array(n).fill(0);
    }

    union(x, y) {
        let rootx = this.find(x);
        let rooty = this.find(y);
        if (rootx !== rooty) {
            if (this.rank[rootx] > this.rank[rooty]) {
                this.parent[rooty] = rootx;
            } else if (this.rank[rootx] < this.rank[rooty]) {
                this.parent[rootx] = rooty;
            } else {
                this.parent[rooty] = rootx;
                this.rank[rootx]++;
            }
        }
    }

    find(x) {
        if (this.parent[x] !== x) {
            this.parent[x] = this.find(this.parent[x]);
        }
        return this.parent[x];
    }
}
```

```go [sol1-Golang]
type unionFind struct {
    parent, rank []int
}

func newUnionFind(n int) unionFind {
    parent := make([]int, n)
    for i := range parent {
        parent[i] = i
    }
    return unionFind{parent, make([]int, n)}
}

func (uf unionFind) find(x int) int {
    if uf.parent[x] != x {
        uf.parent[x] = uf.find(uf.parent[x])
    }
    return uf.parent[x]
}

func (uf unionFind) merge(x, y int) {
    x, y = uf.find(x), uf.find(y)
    if x == y {
        return
    }
    if uf.rank[x] > uf.rank[y] {
        uf.parent[y] = x
    } else if uf.rank[x] < uf.rank[y] {
        uf.parent[x] = y
    } else {
        uf.parent[y] = x
        uf.rank[x]++
    }
}

func largestComponentSize(nums []int) (ans int) {
    m := 0
    for _, num := range nums {
        m = max(m, num)
    }
    uf := newUnionFind(m + 1)
    for _, num := range nums {
        for i := 2; i*i <= num; i++ {
            if num%i == 0 {
                uf.merge(num, i)
                uf.merge(num, num/i)
            }
        }
    }
    cnt := make([]int, m+1)
    for _, num := range nums {
        rt := uf.find(num)
        cnt[rt]++
        ans = max(ans, cnt[rt])
    }
    return
}

func max(a, b int) int {
    if b > a {
        return b
    }
    return a
}
```

**复杂度分析**

- 时间复杂度：$O(n \times \alpha(n) \times \sqrt{m})$，其中 $n$ 是数组 $\textit{nums}$ 的长度，$m$ 是数组 $\textit{nums}$ 中的最大元素，$\alpha$ 是反阿克曼函数。这里的并查集使用了路径压缩和按秩合并，单次操作的时间复杂度是 $O(\alpha(n))$，对于每个元素需要遍历 $O(\sqrt{m})$ 个数字寻找公因数并执行合并操作，总操作次数是 $O(n \times \sqrt{m})$，因此整个数组的并查集操作的时间复杂度是 $O(n \times \alpha(n) \times \sqrt{m})$，并查集操作之后需要 $O(n \times \alpha(n))$ 的时间再次遍历数组计算最大组件大小，因此总时间复杂度是 $O(n \times \alpha(n) \times \sqrt{m})$。

- 空间复杂度：$O(m)$，其中 $m$ 是数组 $\textit{nums}$ 中的最大元素。并查集和统计组件大小都需要 $O(m)$ 的空间。
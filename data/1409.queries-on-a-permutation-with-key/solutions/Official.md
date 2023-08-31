## [1409.查询带键的排列 中文官方题解](https://leetcode.cn/problems/queries-on-a-permutation-with-key/solutions/100000/cha-xun-dai-jian-de-pai-lie-by-leetcode-solution)
#### 方法一：模拟

最容易想到的方法就是根据题目要求直接进行模拟。

对于数组 $\textit{queries}$ 中的每一个询问项 $\textit{query}$，我们在排列 $P$ 中找到 $\textit{query}$ 所在的位置，并把它加入答案。随后，我们需要将 $\textit{query}$ 移动到排列 $P$ 的首部。具体地，我们首先将 $\textit{query}$ 从排列 $P$ 中移除，再添加到排列 $P$ 的首部即可。

只要掌握常用语言中对于变长数组（例如 `C++` 中的 `std::vector`、`Java` 中的 `ArrayList`、`Python` 中的 `list`）的插入和删除操作，就可以解决本题。

```C++ [sol1-C++]
class Solution {
public:
    vector<int> processQueries(vector<int>& queries, int m) {
        vector<int> p(m);
        iota(p.begin(), p.end(), 1);
        vector<int> ans;
        for (int query: queries) {
            int pos = -1;
            for (int i = 0; i < m; ++i) {
                if (p[i] == query) {
                    pos = i;
                    break;
                }
            }
            ans.push_back(pos);
            p.erase(p.begin() + pos);
            p.insert(p.begin(), query);
        }
        return ans;
    }
};
```

```Java [sol1-Java]
class Solution {
    public int[] processQueries(int[] queries, int m) {
        List<Integer> p = new ArrayList<Integer>();
        for (int i = 1; i <= m; ++i) {
            p.add(i);
        }
        int[] ans = new int[queries.length];
        for (int i = 0; i < queries.length; ++i) {
            int query = queries[i];
            int pos = -1;
            for (int j = 0; j < m; ++j) {
                if (p.get(j) == query) {
                    pos = j;
                    break;
                }
            }
            ans[i] = pos;
            p.remove(pos);
            p.add(0, query);
        }
        return ans;
    }
}
```

```Python [sol1-Python3]
class Solution:
    def processQueries(self, queries: List[int], m: int) -> List[int]:
        p = [x + 1 for x in range(m)]
        ans = list()
        for query in queries:
            pos = -1
            for i in range(m):
                if p[i] == query:
                    pos = i
                    break
            ans.append(pos)
            p.pop(pos)
            p.insert(0, query)
        return ans
```

**复杂度分析**

- 时间复杂度：$O(MQ)$，其中 $M$ 是排列 $P$ 的长度，$Q$ 是数组 $\textit{queries}$ 的长度。对于每一个询问项，我们都需要遍历排列 $P$，找到位置并进行操作。

- 空间复杂度：$O(M)$。除了存储答案的数组之外，我们还需要将排列 $P$ 存储下来，其占用的空间为 $O(M)$。

#### 方法二：树状数组

**说明**

方法一的时间复杂度已经足够通过本题。下面介绍一种进阶的方法，需要使用到「树状数组」的相关知识。树状数组本身不是这篇题解的重点，因此这里不再赘述，读者可以使用阅读各类博客进行学习。

要想使用树状数组解决本题，读者需要至少掌握如下内容：

- 了解树状数组的基本概念，知道树状数组可以用来维护「单点修改」和「区间查询」两种操作；

- 会编写树状数组的代码。

**分析**

对于每一个询问项 $\textit{query}$，我们想求出它在排列 $P$ 中的位置，实际上只要知道 **它的前面有几个数** 就可以了。由于排列 $P$ 的位置是从 $0$ 开始的，因此这两者在数值上是等价的。

既然我们把这个问题的答案转化成了一个「数数」的过程，那么我们不妨再想想题目中的操作是不是也可以往「数数」的方向上靠。我们每次求出 $\textit{query}$ 之前有几个数之后，都需要把 $\textit{query}$ 移动到数组的首部，而这样是非常不优雅的。在方法一中，我们采用先从列表中「删除」这个数再将其「插入」数组首部的方法，导致时间复杂度为 $O(M)$。

但我们试想一下，如果在现实生活中，你要管理一个队伍，想把其中的一个人放到队首，你会怎么做？最简单的做法是直接把这个人拉出来让他/她站到第一个人的前面就行了。为什么我们可以这么做？这是因为现实生活中的队伍不是数组，在第一个人前面是有很多空间的。

这是否对我们的优化有一些借鉴的意义呢？我们知道查询的次数 $Q$，那么我们可以使用一个长度为 $Q + M$ 的数组，一开始的排列 $P$ 占据了数组的最后 $M$ 个位置，而每处理一个询问项 $\textit{query}$，我们将其直接放到数组的前 $Q$ 个位置就行了，顺序是从右往左放置。

以示例一为例，对于排列 `[1, 2, 3, 4, 5]` 以及查询 `[3, 1, 2, 1]`，一开始的数组为：

```
_ _ _ _ 1 2 3 4 5
```

前面空出了四个位置，即查询的长度。

我们第一次查询 $3$，$3$ 之前有 $2$ 个数。随后将 $3$ 移到前面：

```
_ _ _ 3 1 2 _ 4 5
```

我们第二次查询 $1$，$1$ 之前有 $1$ 个数。随后将 $1$ 移到前面：

```
_ _ 1 3 _ 2 _ 4 5
```

我们第二次查询 $2$，$1$ 之前有 $2$ 个数。随后将 $2$ 移到前面：

```
_ 2 1 3 _ _ _ 4 5
```

我们第二次查询 $1$，$1$ 之前有 $1$ 个数。随后将 $1$ 移到前面：

```
1 2 _ 3 _ _ _ 4 5
```

在上面的示例中，我们可以发现，我们只需要支持下面三个操作：

- 查询某一个位置之前有几个位置不为空，作为返回的答案；

- 将一个位置变为空；

- 将一个位置变为非空。

如果我们将「空」的位置看成 $1$，「非空」的位置看成 $0$，实际上就是要支持这些操作：

- 数组中一开始前 $Q$ 个位置为 $0$，后 $M$ 个位置为 $1$；

    - 可以看成数组中一开始均为 $0$，我们使用 $M$ 次树状数组的单点修改操作，将对应的位置变为 $1$。

- 每次查询操作等价于询问一个前缀区间的和；

    - 可以使用树状数组的区间查询操作。

- 将一个位置从 $1$ 变为 $0$；

    - 可以使用树状数组的单点修改操作。

- 将一个位置从 $0$ 变为 $1$。

    - 可以使用树状数组的单点修改操作。

这样就变成了一个可以用树状数组解决的问题了。

```C++ [sol2-C++]
struct BIT {
    vector<int> a;
    int n;
    
    BIT(int _n): n(_n), a(_n + 1) {}
    
    static int lowbit(int x) {
        return x & (-x);
    }

    int query(int x) const {
        int ret = 0;
        while (x) {
            ret += a[x];
            x -= lowbit(x);
        }
        return ret;
    }

    void update(int x, int dt) {
        while (x <= n) {
            a[x] += dt;
            x += lowbit(x);
        }
    }
};

class Solution {
public:
    vector<int> processQueries(vector<int>& queries, int m) {
        int n = queries.size();
        BIT bit(m + n);
        
        vector<int> pos(m + 1);
        for (int i = 1; i <= m; ++i) {
            pos[i] = n + i;
            bit.update(n + i, 1);
        }
        
        vector<int> ans;
        for (int i = 0; i < n; ++i) {
            int& cur = pos[queries[i]];
            bit.update(cur, -1);
            ans.push_back(bit.query(cur));
            cur = n - i;
            bit.update(cur, 1);
        }
        return ans;
    }
};
```

```Java [sol2-Java]
class Solution {
    public int[] processQueries(int[] queries, int m) {
        int n = queries.length;
        BIT bit = new BIT(m + n);
        
        int[] pos = new int[m + 1];
        for (int i = 1; i <= m; ++i) {
            pos[i] = n + i;
            bit.update(n + i, 1);
        }
        
        int[] ans = new int[n];
        for (int i = 0; i < n; ++i) {
            int cur = pos[queries[i]];
            bit.update(cur, -1);
            ans[i] = bit.query(cur);
            cur = n - i;
            pos[queries[i]] = cur;
            bit.update(cur, 1);
        }
        return ans;
    }
}

class BIT {
    int[] a;
    int n;

    public BIT(int n) {
        this.n = n;
        this.a = new int[n + 1];
    }

    public int query(int x) {
        int ret = 0;
        while (x != 0) {
            ret += a[x];
            x -= lowbit(x);
        }
        return ret;
    }

    public int update(int x, int dt) {
        while (x <= n) {
            a[x] += dt;
            x += lowbit(x);
        }
        return x;
    }

    public static int lowbit(int x) {
        return x & (-x);
    }
}
```

```Python [sol2-Python3]
class BIT:
    def __init__(self, n):
        self.n = n
        self.a = [0] * (n + 1)
    
    @staticmethod
    def lowbit(x):
        return x & (-x)
    
    def query(self, x):
        ret = 0
        while x > 0:
            ret += self.a[x]
            x -= BIT.lowbit(x)
        return ret
    
    def update(self, x, dt):
        while x <= self.n:
            self.a[x] += dt
            x += BIT.lowbit(x)
        
class Solution:
    def processQueries(self, queries: List[int], m: int) -> List[int]:
        n = len(queries)
        bit = BIT(m + n)
        
        pos = [0] * (m + 1)
        for i in range(1, m + 1):
            pos[i] = n + i
            bit.update(n + i, 1)
        
        ans = list()
        for i, query in enumerate(queries):
            cur = pos[query]
            bit.update(cur, -1)
            ans.append(bit.query(cur))
            cur = pos[query] = n - i
            bit.update(cur, 1)
        return ans
```

**复杂度分析**

- 时间复杂度：$O(Q \log (M + Q))$，我们在长度为 $M + Q$ 的数组上建立树状数组，查询次数为 $Q$，对于每次查询操作，对应在树状数组中进行查询和修改操作的时间复杂度为 $\log (M + Q)$。

- 空间复杂度：$O(M + Q)$，即为树状数组使用的空间。
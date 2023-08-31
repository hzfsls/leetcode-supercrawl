## [1553.吃掉 N 个橘子的最少天数 中文官方题解](https://leetcode.cn/problems/minimum-number-of-days-to-eat-n-oranges/solutions/100000/chi-diao-n-ge-ju-zi-de-zui-shao-tian-shu-by-leetco)

#### 前言

我们可以容易地想出一种递推的做法。设 $f(i)$ 表示吃完 $i$ 个橘子需要的最少时间，则有递推式：

$$
f(i) = \begin{cases}
1, & i=1 \\
\min \{ f(i-1), f(i/2), f(i/3) \} + 1, & i \text{ 是 6 的倍数} \\
\min \{ f(i-1), f(i/2) \} + 1, & i \text{ 是 2 的倍数} \\
\min \{ f(i-1), f(i/3) \} + 1, & i \text{ 是 3 的倍数} \\
f(i-1) + 1, & \text{其它情况}
\end{cases}
$$

我们只要从小到大遍历 $i$ 并计算出 $f(i)$，最后的 $f(n)$ 即为答案。下面给出这种做法的伪代码：

```
f(1) = 1
for i = 2 to n do
    f(i) = f(i - 1) + 1
    if i % 2 == 0 then
        f(i) = min(f(i), f(i / 2) + 1)
    end if
    if i % 3 == 0 then
        f(i) = min(f(i), f(i / 3) + 1)
    end if
end for
```

然而，这种做法的时间复杂度为 $O(n)$，本题中 $n$ 的最大值为 $2*10^9$，明显超出了时间限制。因此，我们需要进行一些优化。

#### 方法一：记忆化搜索

**思路与算法**

「前言」部分的递推是「自底向上」的，我们可以试着将这个过程改成「自顶向下」的记忆化搜索，并深度挖掘题目的性质。

由于我们需要用最少的天数吃完所有的橘子，而「吃掉一个橘子」这样的操作是很不优秀的，不像另外的两种操作可以直接将橘子数变为当前的 $1/2$ 和 $1/3$。直观地来说，我们希望「吃掉一个橘子」的操作次数尽可能少。

> 为了叙述方便，我们称「吃掉一个橘子」为操作 $1$，「吃掉一半橘子」为操作 $2$，「吃掉三分之二橘子」为操作 $3$。

我们可以证明，在最优的方法中，操作 $1$ 的次数是十分有限的：

- 如果我们连续地进行了 $k$ 次操作 $1$ 之后进行了操作 $2$，那么橘子数从 $n$ 变成了 $(n-k)/2$。我们设 $k_0$ 为 $k$ 对 $2$ 取模的值，$0 \leq k_0 \leq 1$，那么我们只需要依次进行 $k_0$ 次操作 $1$，$1$ 次操作 $2$，$(k-k_0)/2$ 次操作 $1$，同样也能得到

    $$
    (n - k_0)/2 - (k-k_0)/2 = (n-k)/2
    $$

    相同的结果 $(n-k)/2$。然而操作次数仅为
    
    $$
    k_0 + 1 + (k-k_0)/2
    $$

    解不等式

    $$
    k_0 + 1 + (k-k_0) / 2 \leq k + 1
    $$

    得到

    $$
    k \geq k_0
    $$

    这个不等式在 $k$ 为正整数时显然成立，因此我们可以用对应的操作替代 $k$ 次操作 $1$，这样我们保证了在任意一次操作 $2$ 之前，操作 $1$ 的次数都不会超过 $1$ 次。

- 如果我们连续地进行了 $k$ 次操作 $1$ 之后进行了操作 $3$，那么橘子数从 $n$ 变成了 $(n-k)/3$。我们设 $k_0$ 为 $k$ 对 $3$ 取模的值，$0 \leq k_0 \leq 2$，那么我们只需要依次进行 $k_0$ 次操作 $1$，$1$ 次操作 $3$，$(k-k_0)/3$ 次操作 $1$，同样也能得到

    $$
    (n-k_0)/3 - (k-k_0)/3 = (n-k)/3
    $$

    相同的结果 $(n-k)/3$。然而操作次数仅为

    $$
    k_0 + 1 + (k-k_0)/3
    $$

    解不等式

    $$
    k_0 + 1 + (k-k_0)/3 \leq k + 1
    $$

    得到

    $$
    k \geq k_0
    $$

    这个不等式在 $k$ 为正整数时显然成立，因此我们可以用对应的操作替代 $k$ 次操作 $1$，这样我们保证了在任意一次操作 $3$ 之前，操作 $1$ 的次数都不会超过 $2$ 次。

- 如果我们连续地进行了 $k$ 次操作 $1$ 并吃完了所有橘子（即接下来没有进行操作 $2$ 或 $3$），那么橘子数从 $k$ 变成 $0$。只要 $k \geq 2$，我们可以在 $k=2$ 的时候将操作 $1$ 用等价的操作 $2$ 替代（即 $2-1 = 2/2$），这样在操作 $2$ 之前的 $k-2$ 次操作 $1$ 就可以再通过上面提到的方法进行替代。因此，$k$ 只能等于 $1$，也就是说，只要当前的橘子数多于 $1$ 个，我们就没有必要一直进行操作 $1$ 直到橘子被吃完。

根据上面的分析，我们可以得到三条重要的结论：

- 在任意一次操作 $2$ 之前最多只会有 $1$ 次操作 $1$；

    - 对于任意的橘子数 $i \geq 2$，唯一的操作方法是将 $n$ 通过操作 $1$ 减少到最近的 $2$ 的倍数，随后进行一次操作 $2$。写成递推式即为：

    $$
    f(i) = i \% 2 + 1 + f(\lfloor i/2 \rfloor)
    $$

- 在任意一次操作 $3$ 之前最多只会有 $2$ 次操作 $1$；

    - 对于任意的橘子数 $i \geq 3$，唯一的操作方法是将 $n$ 通过操作 $1$ 减少到最近的 $3$ 的倍数，随后进行一次操作 $3$。写成递推式即为：

    $$
    f(i) = i \% 3 + 1 + f(\lfloor i/3 \rfloor)
    $$

- 除了最后的一次操作 $1$ 之外，其余连续的操作 $1$ 之后都会有操作 $2$ 或 $3$。即：

    $$
    f(1) = 1
    $$

其中 $\%$ 表示取模运算，$\lfloor x \rfloor$ 表示对 $x$ 向下取整。这样一来，我们就可以使用递归的方法得到 $f(n)$，递归的伪代码如下：

```
function getFn(n)
    if n <= 1 then
        return n
    else
        return min(n % 2 + 1 + f(n / 2), n % 3 + 1 + f(n / 3))
    end if
end function
```

注意：伪代码中并没有判断在进行操作 $3$ 之前是否有 $i \geq 3$，但不会影响最终的答案。

递归的时间复杂度是多少？直接根据递归的代码不太容易看出，我们可以设 $n$ 对应的时间复杂度为 $T(n)$，那么有递推式：

$$
T(n) = T(n/2) + T(n/3) + O(1)
$$

如果设 $T(n) = O(n^t)$，那么带入递推式可以得到

$$
O(n^t) = O((n/2)^t) + O((n/3)^t) + O(1)
$$

两边同时除以 $O(n^t)$，右侧 $O(1)$ 项可忽略：

$$
1 = (1/2)^t + (1/3)^t
$$

解得

$$
t \approx 0.788
$$

因此递归的时间复杂度为 $O(n^{0.788})$，仍然无法通过本题。但我们可以对递归添加记忆化，将 $f(i)$ 的值存储下来，防止重复计算，这样就有如下的代码：

**代码**

```C++ [sol1-C++]
class Solution {
private:
    unordered_map<int, int> memo;

public:
    int minDays(int n) {
        if (n <= 1) {
            return n;
        }
        if (memo.count(n)) {
            return memo[n];
        }
        return memo[n] = min(n % 2 + 1 + minDays(n / 2), n % 3 + 1 + minDays(n / 3));
    }
};
```

```Java [sol1-Java]
class Solution {
    Map<Integer, Integer> memo = new HashMap<Integer, Integer>();

    public int minDays(int n) {
        if (n <= 1) {
            return n;
        }
        if (memo.containsKey(n)) {
            return memo.get(n);
        }
        memo.put(n, Math.min(n % 2 + 1 + minDays(n / 2), n % 3 + 1 + minDays(n / 3)));
        return memo.get(n);
    }
}
```

```Python [sol1-Python3]
class Solution:
    @lru_cache(None)
    def minDays(self, n: int) -> int:
        if n <= 1:
            return n
        return min(n % 2 + 1 + self.minDays(n // 2), n % 3 + 1 + self.minDays(n // 3))
```

读者可以尝试提交代码，会在很快的时间内通过本题，说明时间复杂度大大降低，那么加了记忆化后的时间复杂度是多少呢？

**复杂度分析**

这里需要使用到一个结论：

> 对于正整数 $n, x, y$，有：
>   $$
    \lfloor \lfloor n/x \rfloor / y \rfloor = \lfloor n/(xy) \rfloor = \lfloor \lfloor n/y \rfloor / x \rfloor
>   $$

读者可以自行尝试证明。实际上，只有所有满足 $i = \lfloor n / (2^x3^y) \rfloor$ 的 $f(i)$ 值才会被计算，如果不使用记忆化，会造成大量的重复计算。

> 例如 $f(n)$ 递归调用了 $f(\lfloor n/2 \rfloor)$ 和 $f(\lfloor n/3 \rfloor)$，前者递归调用了 $f(\lfloor n/4 \rfloor)$ 和 $f(\lfloor n/6 \rfloor)$，后者递归调用了 $f(\lfloor n/6 \rfloor)$ 和 $f(\lfloor n/9 \rfloor)$，这样 $f(\lfloor n/6 \rfloor)$ 实际上计算了两次。

在使用了记忆化之后，根据 $i = \lfloor n / (2^x3^y) \rfloor$，有 $x \leq \lfloor \log_2 n \rfloor$ 以及 $y \leq \lfloor \log_3 n \rfloor$，因此我们可以估计出需要计算的 $f(i)$ 的个数不超过 $\lfloor \log_2 n \rfloor * \lfloor \log_3 n \rfloor = O(\log^2 n)$。因此：

- 时间复杂度：$O(\log^2 n)$。

- 空间复杂度：$O(\log^2 n)$，即为需要存储的 $f(i)$ 的个数。

#### 方法二：最短路

**思路与算法**

我们也可以将方法一中的思路抽象成一个「最短路」问题，即：

- 图 $G$ 中有若干个节点，每个节点表示着一个数。根据方法一，每个节点对应着一个 $\lfloor n/(2^x3^y) \rfloor$，节点数为 $O(\log^2 n)$；

- 图 $G$ 中有若干条有向边，如果某个节点表示的数为 $i$，那么 $i$ 到 $\lfloor i/2 \rfloor$ 有一条长度为 $i\%2 + 1$ 的有向边，$i$ 到 $\lfloor i/3 \rfloor$ 有一条长度为 $i\%3 + 1$ 的有向边。边数同样为 $O(\log^2 n)$；

- 我们需要求出 $n$ 对应的节点到 $1$ 对应的节点的最短路径的长度。

因此我们可以用 `Dijkstra` 算法求出答案。

**代码**

```C++ [sol2-C++]
using PII = pair<int, int>;

class Solution {
public:
    int minDays(int n) {
        priority_queue<PII, vector<PII>, greater<PII>> q;
        unordered_set<int> visited;
        q.emplace(0, n);
        int ans = 0;
        while (true) {
            auto [days, rest] = q.top();
            q.pop();
            if (visited.count(rest)) {
                continue;
            }
            visited.insert(rest);
            if (rest == 1) {
                ans = days + 1;
                break;
            }
            q.emplace(days + rest % 2 + 1, rest / 2);
            q.emplace(days + rest % 3 + 1, rest / 3);
        }
        return ans;
    }
};
```

```Java [sol2-Java]
class Solution {
    public int minDays(int n) {
        PriorityQueue<int[]> queue = new PriorityQueue<int[]>(new Comparator<int[]>() {
            public int compare(int[] daysRest1, int[] daysRest2) {
                if (daysRest1[0] != daysRest2[0]) {
                    return daysRest1[0] - daysRest2[0];
                } else {
                    return daysRest1[1] - daysRest2[1];
                }
            }
        });
        Set<Integer> visited = new HashSet<Integer>();
        queue.offer(new int[]{0, n});
        int ans = 0;
        while (true) {
            int[] daysRest = queue.poll();
            int days = daysRest[0], rest = daysRest[1];
            if (visited.contains(rest)) {
                continue;
            }
            visited.add(rest);
            if (rest == 1) {
                ans = days + 1;
                break;
            }
            queue.offer(new int[]{days + rest % 2 + 1, rest / 2});
            queue.offer(new int[]{days + rest % 3 + 1, rest / 3});
        }
        return ans;
    }
}
```

```Python [sol2-Python3]
class Solution:
    def minDays(self, n: int) -> int:
        q = [(0, n)]
        visited = set()
        ans = 0
        
        while True:
            days, rest = heapq.heappop(q)
            if rest in visited:
                continue
            visited.add(rest)
            if rest == 1:
                ans = days + 1
                break
            heapq.heappush(q, (days + rest % 2 + 1, rest // 2))
            heapq.heappush(q, (days + rest % 3 + 1, rest // 3))
        
        return ans
```

**复杂度分析**

- 时间复杂度：$O(\log^2 n \cdot \log\log n)$。对于节点数为 $n'$ 且边数为 $m'$ 的图，上述代码中使用优先队列优化的 `Dijkstra` 算法的时间复杂度为 $O((n'+m') \log m')$，带入 $n'=m'=O(\log^2 n)$ 即可得到时间复杂度。

- 空间复杂度：$O(\log^2 n)$。

#### 方法三：启发式搜索

**说明**

本方法为竞赛考点，在面试中不会出现，仅供读者自主学习和尝试。

**思路与算法**

我们也可以使用启发式搜索的方法找出最短路。这里简单介绍一种启发式搜索算法 `A*`。

在 `A*` 中，对于当前的节点 $x$，需要维护三个函数：

- $G(x)$：表示从起点到节点 $x$ **当前的**最短路径的长度；

- $H(x)$：表示从节点 $x$ 到终点**期望的**最短路径的长度。$H(x)$ 即为启发函数（heuristic function）；

- $F(x)$：满足 $F(x) = G(x) + H(x)$。

与 `Dijkstra` 算法类似，我们同样使用优先队列维护一系列节点 $\{x\}$，每次取出的节点为优先队列中 $F(x)$ 值最小的 $x$ 进行扩展。实际上，`Dijkstra` 算法就是 `A*` 算法在 $H(x) \equiv 0$ 时的特殊情况。

`A*` 算法具有两个性质：

- 如果 $H(x) \leq H'(x)$ 恒成立，那么称启发函数是「可接受」（admissible heuristic）的，其中 $H'(x)$ 表示从节点 $x$ 到终点**真正的**最短路径的长度。在这种情况下，`A*` 算法一定能找到最短路，但每个节点可能需要被扩展多次，即当我们从优先队列中取出节点 $x$ 时，$G(x)$ 并不一定等于从起点到节点 $x$ **真正的**最短路径的长度；

- 如果 $H(x) - H(y) \leq D(x, y)$ 恒成立，并且 $H(t) = 0$，那么称启发函数是「一致」（consistent heuristic）的，其中 $x$ 到 $y$ 有一条有向边直接相连，$D(x, y)$ 表示这条有向边的长度，$t$ 为终点。可以证明，一致的启发函数也是可接受的。在这种情况下，每个节点只需要被扩展一次，就能找到最短路，即当我们从优先队列中取出节点 $x$ 时，$G(x)$ 一定等于从起点到节点 $x$ **真正的**最短路径的长度。

显然，`Dijkstra` 算法中 $H(x) \equiv 0$ 是一致的。而在本题中，我们可以令 $H(x) = \lfloor \log_3 x \rfloor + 1$ 以及 $H(0) = 0$，可以证明 $H(x)$ 是一致的，因此我们直接使用与 `Dijkstra` 算法相同的框架实现 `A*` 算法。

**代码**

```C++ [sol3-C++]
using TIII = tuple<int, int, int>;

class Solution {
public:
    int minDays(int n) {
        auto getHeuristicValue = [](int rest) -> int {
            return rest == 0 ? 0 : \
                static_cast<int>(log(static_cast<double>(rest)) / log(3.)) + 1;
        };
        auto compareFn = [](const TIII& u, const TIII& v) {
            return get<0>(u) + get<1>(u) > get<0>(v) + get<1>(v);
        };
        priority_queue<TIII, vector<TIII>, decltype(compareFn)> q(compareFn);
        unordered_set<int> visited;
        q.emplace(0, getHeuristicValue(n), n);
        int ans = 0;
        while (true) {
            auto [days, heuristic, rest] = q.top();
            q.pop();
            if (visited.count(rest)) {
                continue;
            }
            visited.insert(rest);
            if (rest == 1) {
                ans = days + 1;
                break;
            }
            q.emplace(days + rest % 2 + 1, getHeuristicValue(rest / 2), rest / 2);
            q.emplace(days + rest % 3 + 1, getHeuristicValue(rest / 3), rest / 3);
        }
        return ans;
    }
};
```

```Java [sol3-Java]
class Solution {
    public int minDays(int n) {
        PriorityQueue<int[]> queue = new PriorityQueue<int[]>(new Comparator<int[]>() {
            public int compare(int[] tuple1, int[] tuple2) {
                if (tuple1[0] != tuple2[0]) {
                    return tuple1[0] - tuple2[0];
                } else if (tuple1[1] != tuple2[1]) {
                    return tuple1[1] - tuple2[1];
                } else {
                    return tuple1[2] - tuple2[2];
                }
            }
        });
        queue.offer(new int[]{getHeuristicValue(n), 0, n});
        Set<Integer> visited = new HashSet<Integer>();
        int ans = 0;

        while (true) {
            int[] tuple = queue.poll();
            int expected = tuple[0], days = tuple[1], rest = tuple[2];
            if (visited.contains(rest)) {
                continue;
            }
            visited.add(rest);
            if (rest == 1) {
                ans = days + 1;
                break;
            }
            queue.offer(new int[]{days + rest % 2 + 1 + getHeuristicValue(rest / 2), days + rest % 2 + 1, rest / 2});
            queue.offer(new int[]{days + rest % 3 + 1 + getHeuristicValue(rest / 3), days + rest % 3 + 1, rest / 3});
        }

        return ans;
    }

    public int getHeuristicValue(int rest) {
        return rest == 0 ? 0 : (int) (Math.log(rest) / Math.log(3)) + 1;
    }
}
```

```Python [sol3-Python3]
class Solution:
    def minDays(self, n: int) -> int:
        @lru_cache(None)
        def getHeuristicValue(rest: float) -> int:
            return 0 if rest == 0 else \
                int(math.log(rest) / math.log(3.0)) + 1
        
        q = [(getHeuristicValue(n), 0, n)]
        visited = set()
        ans = 0
        
        while True:
            expected, days, rest = heapq.heappop(q)
            if rest in visited:
                continue
            visited.add(rest)
            if rest == 1:
                ans = days + 1
                break
            heapq.heappush(q, (
                days + rest % 2 + 1 + getHeuristicValue(rest // 2),
                days + rest % 2 + 1,
                rest // 2
            ))
            heapq.heappush(q, (
                days + rest % 3 + 1 + getHeuristicValue(rest // 3),
                days + rest % 3 + 1,
                rest // 3
            ))
        
        return ans
```

**复杂度分析**

- 时间复杂度：启发式算法不计算时间复杂度。

- 空间复杂度：$O(\log^2 n)$。
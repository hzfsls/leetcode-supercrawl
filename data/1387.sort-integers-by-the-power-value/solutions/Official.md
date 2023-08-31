## [1387.将整数按权重排序 中文官方题解](https://leetcode.cn/problems/sort-integers-by-the-power-value/solutions/100000/jiang-zheng-shu-an-quan-zhong-pai-xu-by-leetcode-s)

#### 题目分析

我们要按照权重为第一关键字，原值为第二关键字对区间 `[lo, hi]` 进行排序，关键在于我们怎么求权重。

#### 方法一：递归

**思路**

记 $x$ 的权重为 $f(x)$，按照题意很明显我们可以构造这样的递归式：

$$
f(x) =
    \left \{ \begin{aligned}
    0                  &, & x = 1 \\
    f(3x + 1) + 1      &, & x \bmod{2} = 1 \\
    f(\frac{x}{2}) + 1 &, & x \bmod{2} = 0
    \end{aligned} \right .
$$

于是我们就可以递归求解每个数字的权重了。

**代码**

```cpp [sol1-C++]
class Solution {
public:
    int getF(int x) {
        if (x == 1) return 0;
        if (x & 1) return getF(x * 3 + 1) + 1;
        else return getF(x / 2) + 1;
    }

    int getKth(int lo, int hi, int k) {
        vector <int> v;
        for (int i = lo; i <= hi; ++i) v.push_back(i);
        sort(v.begin(), v.end(), [&] (int u, int v) {
            if (getF(u) != getF(v)) return getF(u) < getF(v);
            else return u < v;
        });
        return v[k - 1];
    }
};
```

```Java [sol1-Java]
class Solution {
    public int getKth(int lo, int hi, int k) {
        List<Integer> list = new ArrayList<Integer>();
        for (int i = lo; i <= hi; ++i) {
            list.add(i);
        }
        Collections.sort(list, new Comparator<Integer>() {
            public int compare(Integer u, Integer v) {
                if (getF(u) != getF(v)) {
                    return getF(u) - getF(v);
                } else {
                    return u - v;
                }
            }
        });
        return list.get(k - 1);
    }

    public int getF(int x) {
        if (x == 1) {
            return 0;
        } else if ((x & 1) != 0) {
            return getF(x * 3 + 1) + 1;
        } else {
            return getF(x / 2) + 1;
        }
    }
}
```

```python [sol1-Python3]
class Solution:
    def getKth(self, lo: int, hi: int, k: int) -> int:
        def getF(x):
            if x == 1:
                return 0
            return (getF(x * 3 + 1) if x % 2 == 1 else getF(x // 2)) + 1
        
        v = list(range(lo, hi + 1))
        v.sort(key=lambda x: (getF(x), x))
        return v[k - 1]
```

**复杂度分析**

记区间长度为 $n$，等于 `hi - lo + 1`。

- 时间复杂度：这里的区间一定是 $[1, 1000]$ 的子集，在 $[1, 1000]$ 中权重最大数的权重为 $178$，即这个递归函数要执行 $178$ 次，所以排序的每次比较的时间代价为 $O(178)$，故渐进时间复杂度为 $O(178 \times n \log n)$。

- 空间复杂度：我们使用了长度为 $n$ 的数组辅助进行排序，同时再使用递归计算权重时最多会使用 $178$ 层的栈空间，故渐进空间复杂度为 $O(n + 178)$。

#### 方法二：记忆化

**思路**

我们知道在求 $f(3)$ 的时候会调用到 $f(10)$，在求 $f(20)$ 的时候也会调用到 $f(10)$。同样的，如果单纯递归计算权重的话，会存在很多重复计算，我们可以用记忆化的方式来加速这个过程，即「先查表，再计算」和「先记忆，再返回」。我们可以用一个哈希映射作为这里的记忆化的「表」，这样保证每个元素的权值只被计算 $1$ 次。在 $[1, 1000]$ 中所有 $x$ 求 $f(x)$ 的值的过程中，只可能出现 $2228$ 种 $x$，于是效率就会大大提高。

代码如下。

**代码**

```cpp [sol2-C++]
class Solution {
public:
    unordered_map <int, int> f;

    int getF(int x) {
        if (f.find(x) != f.end()) return f[x];
        if (x == 1) return f[x] = 0;
        if (x & 1) return f[x] = getF(x * 3 + 1) + 1;
        else return f[x] = getF(x / 2) + 1;
    }

    int getKth(int lo, int hi, int k) {
        vector <int> v;
        for (int i = lo; i <= hi; ++i) v.push_back(i);
        sort(v.begin(), v.end(), [&] (int u, int v) {
            if (getF(u) != getF(v)) return getF(u) < getF(v);
            else return u < v;
        });
        return v[k - 1];
    }
};
```

```Java [sol2-Java]
class Solution {
    Map<Integer, Integer> f = new HashMap<Integer, Integer>();

    public int getKth(int lo, int hi, int k) {
        List<Integer> list = new ArrayList<Integer>();
        for (int i = lo; i <= hi; ++i) {
            list.add(i);
        }
        Collections.sort(list, new Comparator<Integer>() {
            public int compare(Integer u, Integer v) {
                if (getF(u) != getF(v)) {
                    return getF(u) - getF(v);
                } else {
                    return u - v;
                }
            }
        });
        return list.get(k - 1);
    }

    public int getF(int x) {
        if (!f.containsKey(x)) {
            if (x == 1) {
                f.put(x, 0);
            } else if ((x & 1) != 0) {
                f.put(x, getF(x * 3 + 1) + 1);
            } else {
                f.put(x, getF(x / 2) + 1);
            }
        }
        return f.get(x);
    }
}
```

```python [sol2-Python3]
class Solution:
    def getKth(self, lo: int, hi: int, k: int) -> int:
        f = {1: 0}

        def getF(x):
            if x in f:
                return f[x]
            f[x] = (getF(x * 3 + 1) if x % 2 == 1 else getF(x // 2)) + 1
            return f[x]
        
        v = list(range(lo, hi + 1))
        v.sort(key=lambda x: (getF(x), x))
        return v[k - 1]
```

**复杂度分析**

- 时间复杂度：平均情况下比较的次数为 $n \log n$，把 $2228$ 次平摊到每一次的时间代价为 $O(\frac{2228}{n \log n})$，故总时间代价为 $O(\frac{2228}{n \log n} \times n \log n) = O(2228)$。

- 空间复杂度：我们使用了长度为 $n$ 的数组辅助进行排序，哈希映射只可能存在 $2228$ 种键，故渐进空间复杂度为 $O(n + 2228)$。由于这里我们使用了记忆化，因此递归使用的栈空间层数会均摊到所有的 $n$ 中，由于 $n$ 的最大值为 $1000$，因此每一个 $n$ 使用的栈空间为 $O(\frac{2228}{1000}) \approx O(2)$，相较于排序的哈希映射需要的空间可以忽略不计。
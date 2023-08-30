#### 方法一：枚举三元组

我们可以直接根据题目要求，枚举三元组 $(i, j, k)$ 表示三名士兵，其中 $i < j < k$。在枚举过程中，我们只需要判断这三名士兵的评分是否严格单调递增

$$
\textit{rating}[i] < \textit{rating}[j] < \textit{rating}[k]
$$

或严格单调递减

$$
\textit{rating}[i] > \textit{rating}[j] > \textit{rating}[k]
$$

即可。

```C++ [sol1-C++]
class Solution {
public:
    int numTeams(vector<int>& rating) {
        int n = rating.size();
        int ans = 0;
        for (int i = 0; i < n; ++i) {
            for (int j = i + 1; j < n; ++j) {
                for (int k = j + 1; k < n; ++k) {
                    if ((rating[i] < rating[j] && rating[j] < rating[k]) || (rating[i] > rating[j] && rating[j] > rating[k])) {
                        ++ans;
                    }
                }
            }
        }
        return ans;
    }
};
```
```Java [sol1-Java]
class Solution {
    public int numTeams(int[] rating) {
        int n = rating.length;
        int ans = 0;
        for (int i = 0; i < n; ++i) {
            for (int j = i + 1; j < n; ++j) {
                for (int k = j + 1; k < n; ++k) {
                    if ((rating[i] < rating[j] && rating[j] < rating[k]) || (rating[i] > rating[j] && rating[j] > rating[k])) {
                        ++ans;
                    }
                }
            }
        }
        return ans;
    }
}
```
```Python [sol1-Python3]
class Solution:
    def numTeams(self, rating: List[int]) -> int:
        n = len(rating) 
        ans = 0
        for i in range(n):
            for j in range(i + 1, n):
                for k in range(j + 1, n):
                    if rating[i] < rating[j] < rating[k] or rating[i] > rating[j] > rating[k]:
                        ans += 1
        return ans
```

**复杂度分析**

- 时间复杂度：$O(N^3)$，其中 $N$ 是数组 $\textit{ratings}[]$ 的长度。我们需要使用三重循环枚举三元组。

- 空间复杂度：$O(1)$。

#### 方法二：枚举中间点

我们也可以枚举三元组 $(i, j, k)$ 中的 $j$，它是三元组的中间点。在这之后，我们统计：

- 出现在位置 $j$ 左侧且比 $j$ 评分低的士兵数量 $i_{\textit{less}}$；

- 出现在位置 $j$ 左侧且比 $j$ 评分高的士兵数量 $i_{\textit{more}}$；

- 出现在位置 $j$ 右侧且比 $j$ 评分低的士兵数量 $k_{\textit{less}}$；

- 出现在位置 $j$ 右侧且比 $j$ 评分高的士兵数量 $k_{\textit{more}}$。

这样以来，任何一个出现在 $i_{\textit{less}}$ 中的士兵 $i$，以及出现在 $k_{\textit{more}}$ 中的士兵 $k$，都可以和 $j$ 组成一个严格单调递增的三元组；同理，任何一个出现在 $i_{\textit{more}}$ 中的士兵 $i$，以及出现在 $k_{\textit{less}}$ 中的士兵 $k$，都可以和 $j$ 组成一个严格单调递减的三元组。因此，以 $j$ 为中间点的三元组的数量为：

$$
i_{\textit{less}} * k_{\textit{more}} + i_{\textit{more}} * k_{\textit{less}}
$$

我们将所有的值进行累加即可得到答案。

```C++ [sol2-C++]
class Solution {
public:
    int numTeams(vector<int>& rating) {
        int n = rating.size();
        int ans = 0;
        // 枚举三元组中的 j
        for (int j = 1; j < n - 1; ++j) {
            int iless = 0, imore = 0;
            int kless = 0, kmore = 0;
            for (int i = 0; i < j; ++i) {
                if (rating[i] < rating[j]) {
                    ++iless;
                }
                // 注意这里不能直接写成 else
                // 因为可能有评分相同的情况
                else if (rating[i] > rating[j]) {
                    ++imore;
                }
            }
            for (int k = j + 1; k < n; ++k) {
                if (rating[k] < rating[j]) {
                    ++kless;
                }
                else if (rating[k] > rating[j]) {
                    ++kmore;
                }
            }
            ans += iless * kmore + imore * kless;
        }
        return ans;
    }
};
```
```Java [sol2-Java]
class Solution {
    public int numTeams(int[] rating) {
        int n = rating.length;
        int ans = 0;
        // 枚举三元组中的 j
        for (int j = 1; j < n - 1; ++j) {
            int iless = 0, imore = 0;
            int kless = 0, kmore = 0;
            for (int i = 0; i < j; ++i) {
                if (rating[i] < rating[j]) {
                    ++iless;
                }
                // 注意这里不能直接写成 else
                // 因为可能有评分相同的情况
                else if (rating[i] > rating[j]) {
                    ++imore;
                }
            }
            for (int k = j + 1; k < n; ++k) {
                if (rating[k] < rating[j]) {
                    ++kless;
                } else if (rating[k] > rating[j]) {
                    ++kmore;
                }
            }
            ans += iless * kmore + imore * kless;
        }
        return ans;
    }
}
```
```Python [sol2-Python3]
class Solution:
    def numTeams(self, rating: List[int]) -> int:
        n = len(rating)
        ans = 0
        # 枚举三元组中的 j
        for j in range(1, n - 1):
            iless = imore = kless = kmore = 0
            for i in range(j):
                if rating[i] < rating[j]:
                    iless += 1
                # 注意这里不能直接写成 else
                # 因为可能有评分相同的情况
                elif rating[i] > rating[j]:
                    imore += 1
            for k in range(j + 1, n):
                if rating[k] < rating[j]:
                    kless += 1
                elif rating[k] > rating[j]:
                    kmore += 1
            ans += iless * kmore + imore * kless
        return ans
```

**复杂度分析**

- 时间复杂度：$O(N^2)$，其中 $N$ 是数组 $\textit{ratings}[]$ 的长度。我们需要使用一重循环枚举三元组中的 $j$，另一重循环计算 $i_{\textit{less}}$，$i_{\textit{more}}$，$k_{\textit{less}}$ 和 $k_{\textit{more}}$。

- 空间复杂度：$O(1)$。


#### 方法三：离散化树状数组

**前置知识**

+ 离散化思想，在不改变数据相对大小的条件下，对数据进行相应的缩小。
+ [树状数组（二元索引树）](https://zh.wikipedia.org/wiki/%E6%A0%91%E7%8A%B6%E6%95%B0%E7%BB%84)，一种动态维护前缀和的数据结构。

**思路**

考虑优化方法二中求 $i_{\textit{less}}$、$k_{\textit{more}}$、$i_{\textit{more}}$、$k_{\textit{less}}$ 的过程。在方法二中我们使用了枚举来求解这四个量，单次枚举的时间代价是 $O(N)$。假设我们有一个桶数组，索引 $i$ 的值为 $1$ 就说明存在元素 $i$，为 $0$ 就说明不存在元素 $i$，那么该桶数组的前缀和 ${\rm preffixSum}[i - 1]$ 就表示当前比 $i$ 小的数的个数，我们只需要用树状数组动态维护这个前缀和，就可以把单次的时间代价从 $O(N)$ 优化到 $O(\log N)$。

我们对 `rating` 数组做两次遍历，一次从前向后，一次从后向前。从前向后的时候，对于每一个 `rating[i]` （记为 $x$），求到上述桶数组下标 $x - 1$ 的前缀和，即 $i_{\textit{less}}$，记 `rating` 数组中出现的最大值为 $r_{\max} $，用 $r_{\max}$ 的前缀和减去 $x$ 位置的前缀和即可得到 $i_{\textit{more}}$。从后向前的那次遍历同理。

**思考：仅仅这样做真的可以单次计算变成 $\log N$ 吗？** 我们知道树状数组修改和查询的时间代价和树状数组的长度相关，也就是这里的 $r_{\max}$（它最大可以到 $10^5$），所以这里单次查询的代价是 $O(\log r_{\max})$。实际上 `rating` 的长度最大只有 $200$，也就是这个树状数组中的「有效位置」最多只有 $200$ 个，所以我们不用开辟 $10^5$ 的长度，只需要开辟 $200$ 的长度，通过离散化的方法缩小值域，这样就可以把单次的时间代价变成 $O(\log N)$。

由于这里没有重复的数字，所以只需要对 `rating` 数组中的数进行排序，然后二分获取离散化之后的值即可，单次二分的时间代价也是 $O(\log N)$。

代码如下。

**代码**

```cpp [sol3-cpp]
class Solution {
public:
    static constexpr int MAX_N = 200 + 5;

    int c[MAX_N];
    vector <int> disc;
    vector <int> iLess, iMore, kLess, kMore;

    int lowbit(int x) {
        return x & (-x);
    }

    void add(int p, int v) {
        while (p < MAX_N) {
            c[p] += v;
            p += lowbit(p);
        }
    }

    int get(int p) {
        int r = 0;
        while (p > 0) {
            r += c[p];
            p -= lowbit(p);
        }
        return r;
    }

    int numTeams(vector<int>& rating) {
        disc = rating;
        disc.push_back(-1);
        sort(disc.begin(), disc.end());
        auto getId = [&] (int target) {
            return lower_bound(disc.begin(), disc.end(), target) - disc.begin();
        };


        iLess.resize(rating.size());
        iMore.resize(rating.size());
        kLess.resize(rating.size());
        kMore.resize(rating.size());

        for (int i = 0; i < rating.size(); ++i) {
            auto id = getId(rating[i]);
            iLess[i] = get(id);
            iMore[i] = get(201) - get(id); 
            add(id, 1);
        }

        memset(c, 0, sizeof c);
        for (int i = rating.size() - 1; i >= 0; --i) {
            auto id = getId(rating[i]);
            kLess[i] = get(id);
            kMore[i] = get(201) - get(id); 
            add(id, 1);
        }
        
        int ans = 0;
        for (unsigned i = 0; i < rating.size(); ++i) {
            ans += iLess[i] * kMore[i] + iMore[i] * kLess[i];
        }

        return ans;
    }
};
```
```Java [sol3-Java]
class Solution {
    int maxN;
    int[] c;
    List<Integer> disc;
    int[] iLess;
    int[] iMore;
    int[] kLess;
    int[] kMore;

    public int numTeams(int[] rating) {
        int n = rating.length;
        maxN = n + 2;
        c = new int[maxN];
        disc = new ArrayList<Integer>();
        for (int i = 0; i < n; ++i) {
            disc.add(rating[i]);
        }
        disc.add(-1);
        Collections.sort(disc);
        iLess = new int[n];
        iMore = new int[n];
        kLess = new int[n];
        kMore = new int[n];

        for (int i = 0; i < n; ++i) {
            int id = getId(rating[i]);
            iLess[i] = get(id);
            iMore[i] = get(n + 1) - get(id); 
            add(id, 1);
        }

        c = new int[maxN];
        for (int i = n - 1; i >= 0; --i) {
            int id = getId(rating[i]);
            kLess[i] = get(id);
            kMore[i] = get(n + 1) - get(id); 
            add(id, 1);
        }
        
        int ans = 0;
        for (int i = 0; i < n; ++i) {
            ans += iLess[i] * kMore[i] + iMore[i] * kLess[i];
        }

        return ans;
    }

    public int getId(int target) {
        int low = 0, high = disc.size() - 1;
        while (low < high) {
            int mid = (high - low) / 2 + low;
            if (disc.get(mid) < target) {
                low = mid + 1;
            } else {
                high = mid;
            }
        }
        return low;
    }

    public int get(int p) {
        int r = 0;
        while (p > 0) {
            r += c[p];
            p -= lowbit(p);
        }
        return r;
    }

    public void add(int p, int v) {
        while (p < maxN) {
            c[p] += v;
            p += lowbit(p);
        }
    }

    public int lowbit(int x) {
        return x & (-x);
    }
}
```

**复杂度分析**

- 时间复杂度：$O(N \log N)$。离散化过程中对数组排序的时间代价是 $O(N \log N)$。两次遍历，每次 $N$ 个元素，对于每个元素做一次 $O(\log N)$ 的离散值查询和 $O(3 \times \log N)$ 的树状数组操作，故渐进时间复杂度为 $O(N \log N + 2 \times N \times (\log N + 3 \log N)) = O(N \log N)$。
- 空间复杂度：$O(N)$。这里用了长度为 $N$ 的数组（6 个）最为辅助空间，渐进空间复杂度为 $O(N)$。
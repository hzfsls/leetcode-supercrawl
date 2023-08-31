## [914.卡牌分组 中文官方题解](https://leetcode.cn/problems/x-of-a-kind-in-a-deck-of-cards/solutions/100000/qia-pai-fen-zu-by-leetcode-solution)

#### 方法一：暴力

**思路**

我们枚举所有可行的 $X$，判断是否有满足条件的 $X$ 即可。

**算法**

我们从 $2$ 开始，从小到大枚举 $X$。

由于每一组都有 $X$ 张牌，那么 $X$ 必须是卡牌总数 $N$ 的约数。

其次，对于写着数字 $i$ 的牌，如果有 $\textit{count}_i$ 张，由于题目要求「组内所有的牌上都写着相同的整数」，那么 $X$ 也必须是 $\textit{count}_i$ 的约数，即：

$$
\textit{count}_i \bmod X == 0
$$

所以对于每一个枚举到的 $X$，我们只要先判断 $X$ 是否为 $N$ 的约数，然后遍历所有牌中存在的数字 $i$，看它们对应牌的数量 $\textit{count}_i$ 是否满足上述要求。如果都满足等式，则 $X$ 为符合条件的解，否则需要继续令 $X$ 增大，枚举下一个数字。

```Java [sol1-Java]
class Solution {
    public boolean hasGroupsSizeX(int[] deck) {
        int N = deck.length;
        int[] count = new int[10000];
        for (int c: deck) {
            count[c]++;
        }

        List<Integer> values = new ArrayList<Integer>();
        for (int i = 0; i < 10000; ++i) {
            if (count[i] > 0) {
                values.add(count[i]);
            }
        }

        for (int X = 2; X <= N; ++X) {
            if (N % X == 0) {
                boolean flag = true;
                for (int v: values) {
                    if (v % X != 0) {
                        flag = false;
                        break;
                    }
                }
                if (flag) {
                    return true;
                }
            }
        }

        return false;
    }
}
```

```Python [sol1-Python3]
class Solution:
    def hasGroupsSizeX(self, deck: List[int]) -> bool:
        count = collections.Counter(deck)
        N = len(deck)
        for X in range(2, N + 1):
            if N % X == 0:
                if all(v % X == 0 for v in count.values()):
                    return True
        return False
```

```C++ [sol1-C++]
class Solution {
    int count[10000];
public:
    bool hasGroupsSizeX(vector<int>& deck) {
        int N = (int)deck.size();
        for (int c: deck) count[c]++;

        vector<int> values;
        for (int i = 0; i < 10000; ++i) {
            if (count[i] > 0) {
                values.emplace_back(count[i]);
            }
        }

        for (int X = 2; X <= N; ++X) {
            if (N % X == 0) {
                bool flag = 1;
                for (int v: values) {
                    if (v % X != 0) {
                        flag = 0;
                        break;
                    }
                }
                if (flag) {
                    return true;
                }
            }
        }
        return false;
    }
};
```

**复杂度分析**

- 时间复杂度：$O(N^2)$，其中 $N$ 是卡牌个数。最多枚举 $N$ 个可能的 $X$，对于每个 $X$，要遍历的数字 $i$ 最多有 $N$ 个。

- 空间复杂度：$O(N + C)$ 或 $O(N)$，其中 $C$ 是数组 $\textit{deck}$ 中数的范围，在本题中 $C$ 的值为 $10000$。在 $\text{C++}$ 和 $\text{Java}$ 代码中，我们先用频率数组 $\textit{count}$ 存储了每个数字 $i$ 出现的次数 $\textit{count}[i]$，随后将所有超过零的次数转移到数组 $\textit{values}$ 中，方便进行遍历，因此需要使用长度为 $C$ 的 $\textit{count}$ 数组以及长度不超过 $N$ 的 $\textit{values}$ 数组，空间复杂度为 $O(N + C)$。在 $\text{Python}$ 代码中，我们直接使用哈希映射存储每个数字 $i$ 以及出现的次数，因此空间复杂度为 $O(N)$。

#### 方法二：最大公约数

**思路和算法**

由于方法一已经提及 $X$ 一定为 $\textit{count}_i$ 的约数，这个条件是对所有牌中存在的数字 $i$ 成立的，所以我们可以推出，只有当 $X$ 为所有 $\textit{count}_i$ 的约数，即所有 $\textit{count}_i$ 的最大公约数的约数时，才存在可能的分组。公式化来说，我们假设牌中存在的数字集合为 $a, b, c, d, e$，那么只有当 $X$ 为

$$
gcd(\textit{count}_a,\textit{count}_b,\textit{count}_c,\textit{count}_d,\textit{count}_e)
$$

的约数时才能满足要求。

因此我们只要求出所有 $\textit{count}_i$ 最大公约数 $g$，判断 $g$ 是否大于等于 $2$ 即可，如果大于等于 $2$，则满足条件，否则不满足。

```Java [sol2-Java]
class Solution {
    public boolean hasGroupsSizeX(int[] deck) {
        int[] count = new int[10000];
        for (int c: deck) {
            count[c]++;
        }

        int g = -1;
        for (int i = 0; i < 10000; ++i) {
            if (count[i] > 0) {
                if (g == -1) {
                    g = count[i];
                } else {
                    g = gcd(g, count[i]);
                }
            }
        }
        return g >= 2;
    }

    public int gcd(int x, int y) {
        return x == 0 ? y : gcd(y % x, x);
    }
}
```

```Python [sol2-Python3]
class Solution:
    def hasGroupsSizeX(self, deck: List[int]) -> bool:
        vals = collections.Counter(deck).values()
        return reduce(gcd, vals) >= 2
```

```C++ [sol2-C++]
class Solution {
    int cnt[10000];
public:
    bool hasGroupsSizeX(vector<int>& deck) {
        for (auto x: deck) cnt[x]++;
        int g = -1;
        for (int i = 0; i < 10000; ++i) {
            if (cnt[i]) {
                if (~g) {
                    g = gcd(g, cnt[i]);
                } else {
                    g = cnt[i];
                }
            }
        }
        return g >= 2;
    }
};
```

**复杂度分析**

- 时间复杂度：$O(N \log C)$，其中 $N$ 是卡牌的个数，$C$ 是数组 $\textit{deck}$ 中数的范围，在本题中 $C$ 的值为 $10000$。求两个数最大公约数的复杂度是 $O(\log C)$，需要求最多 $N - 1$ 次。

- 空间复杂度：$O(N + C)$ 或 $O(N)$。
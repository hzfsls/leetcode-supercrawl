## [1505.最多 K 次交换相邻数位后得到的最小整数 中文官方题解](https://leetcode.cn/problems/minimum-possible-integer-after-at-most-k-adjacent-swaps-on-digits/solutions/100000/zui-duo-k-ci-jiao-huan-xiang-lin-shu-wei-hou-de-da)
#### 前言

给定一个长度为 $n$ 的数组 $a$，设计一种数据结构，支持如下的操作：

- 「单点修改」：输入下标 $x$ 和增量 $d$，将 $a[x]$ 增加 $d$；

- 「区间查询」：输入下标 $x$ 和 $y$，求出 $a[x]$ 到 $a[y]$ 的和，即：

    $$
    \sum_{i=x}^y a[i]
    $$

我们需要使得两个操作的时间复杂度尽可能小。「树状数组」就是一种符合条件的数据结构，它能够在 $O(\log n)$ 的时间完成「单点修改」和「区间查询」操作。

在本题中，我们就需要使用到树状数组。由于树状数组的设计与实现不是本题解的重点，因此这里不会对树状数组本身进行讲解，读者可以自行查阅资料进行学习。

#### 方法一：贪心算法

**思路**

在对字符串 $\textit{num}$ 进行数位交换的过程中，它的长度（数位的个数）不会发生变化。因此，**数值**最小的整数就等价于**字典序**最小的整数。

要想得到在 $k$ 次交换内**字典序**最小的整数，我们可以「贪心」地从 $\textit{num}$ 的最高位开始考虑，即希望 $\textit{num}$ 的最高位尽可能小。我们可以依次枚举 $0 \sim 9$，对于当前枚举到的数位 $x$，判断是否可以将某个位置上的 $x$ 通过最多 $k$ 次交换移动到最高位。由于每一次交换只能交换相邻位置的两个数字，因此将一个距离最高位为 $s$ 的数位移动到最高位，需要 $s$ 次交换操作。例如当 $\textit{num} = 97620$ 时，$0$ 与最高位的距离为 $4$，我们可以通过 $4$ 次交换操作把 $0$ 移动到最高位：

```
 9  7  6  2 [0]
 9  7  6 [0] 2
 9  7 [0] 6  2
 9 [0] 7  6  2
[0] 9  7  6  2
```

这样的交换操作相当于把 $0$ 移动到最高位，同时将 $0$ 之前的所有数位向后移动了一位。

如果有多个 $x$ 与最高位的距离小于等于 $k$，那么我们该如何进行选择呢？直观来看，我们应该选择最近的那个 $x$，这样需要交换的次数就最少。

我们接下来考虑次高位。与最高位类似，我们选择最小的数位 $x$，使得它与次高位的距离不超过 $k'$，其中 $k'$ 是 $k$ 扣除最高位交换后的剩余次数。考虑上面 $\textit{num} = 97620$ 的例子，此时我们应当选择 $x=2$ 交换至次高位。然而我们发现，**经过第一次的交换操作，$2$ 所在的位置发生了变化**！在 $\textit{num}$ 中，$2$ 与次高位的距离为 $2$，而将 $0$ 交换至最高位后，$2$ 与次高位的距离增加了 $1$，变为 $3$。这是因为 $0$ 从 $2$ 的后面「转移」到了 $2$ 的前面，使得 $2$ 向后移动了一位。因此，**$x$ 实际所在的位置，等于 $x$ 初始时在 $\textit{num}$ 中的位置，加上 $x$ 后面发生交换的数位个数**。这里的「$x$ 后面发生交换的数位个数」，就可以使用树状数组进行维护。

因此，我们从高到低考虑每一位，对于每一位找出距离该位置小于等于 $k$（剩余的交换次数）且最小的数位，记录该数位的位置、完成交换并更新 $k$ 值。注意到如果我们枚举到了恰好在这一位上的那个数位，计算出的距离为 $0$，同样小于等于 $k$。因此我们总能找到一个满足要求的数位进行交换。

**算法**

对于未接触过树状数组的读者来说，本题有较大的难度。这里我们给出解决本题的算法框架：

- 我们用 $\textit{pos}[x]$ 按照从高位到低位的顺序，存放所有 $x$ 在 $\textit{num}$ 中出现的位置；

- 我们从高到低遍历每一个位置。对于位置 $i$，我们从小到大枚举交换的数位 $x$。$\textit{pos}[x]$ 中的首元素即为与当前位置距离最近的 $x$ 的位置：

    - 记 $u$ 为 $\textit{pos}[x]$ 中的首元素，那么 $\textit{num}[u]$（也就是 $x$）当前实际所在的位置，等于 $u$ 加上 $u$ 后面发现交换的数位个数。我们使用树状数组查询区间 $[u+1, n]$，得到结果 $\textit{behind}$，其中 $n$ 是 $\textit{num}$ 的长度。那么 $\textit{num}[u]$ 与位置 $i$ 的实际距离即为 $u + \textit{behind} - i$。

    - 如果该距离小于等于 $k$，那么我们就可以将 $x$ 交换到位置 $i$。我们使用树状数组更新单点 $u$，将对应的值增加 $1$，表示该位置的数位发生了交换。随后我们还需要更新 $k$ 值以及将 $u$ 从 $\textit{pos}$ 中移除。

- 在遍历结束后，我们就得到了答案。

> 注意：树状数组的下标一般从 $1$ 开始，而给定的字符串 $\textit{num}$ 的下标从 $0$ 开始，因此需要设置 $1$ 的下标偏移量。

**代码**

```C++ [sol1-C++]
class BIT {
private:
    vector<int> tree;
    int n;

public:
    BIT(int _n): n(_n), tree(_n + 1) {}

    static int lowbit(int x) {
        return x & (-x);
    }
    
    void update(int x) {
        while (x <= n) {
            ++tree[x];
            x += lowbit(x);
        }
    }

    int query(int x) const {
        int ans = 0;
        while (x) {
            ans += tree[x];
            x -= lowbit(x);
        }
        return ans;
    }

    int query(int x, int y) const {
        return query(y) - query(x - 1);
    }
};

class Solution {
public:
    string minInteger(string num, int k) {
        int n = num.size();
        vector<queue<int>> pos(10);
        for (int i = 0; i < n; ++i) {
            pos[num[i] - '0'].push(i + 1);
        }
        string ans;
        BIT bit(n);
        for (int i = 1; i <= n; ++i) {
            for (int j = 0; j < 10; ++j) {
                if (!pos[j].empty()) {
                    int behind = bit.query(pos[j].front() + 1, n);
                    int dist = pos[j].front() + behind - i;
                    if (dist <= k) {
                        bit.update(pos[j].front());
                        pos[j].pop();
                        ans += (j + '0');
                        k -= dist;
                        break;
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
    public String minInteger(String num, int k) {
        int n = num.length();
        Queue<Integer>[] pos = new Queue[10];
        for (int i = 0; i < 10; ++i) {
            pos[i] = new LinkedList<Integer>();
        }
        for (int i = 0; i < n; ++i) {
            pos[num.charAt(i) - '0'].offer(i + 1);
        }
        StringBuffer ans = new StringBuffer();
        BIT bit = new BIT(n);
        for (int i = 1; i <= n; ++i) {
            for (int j = 0; j < 10; ++j) {
                if (!pos[j].isEmpty()) {
                    int behind = bit.query(pos[j].peek() + 1, n);
                    int dist = pos[j].peek() + behind - i;
                    if (dist <= k) {
                        bit.update(pos[j].poll());
                        ans.append(j);
                        k -= dist;
                        break;
                    }
                }
            }
        }
        return ans.toString();
    }
}

class BIT {
    int n;
    int[] tree;

    public BIT(int n) {
        this.n = n;
        this.tree = new int[n + 1];
    }

    public static int lowbit(int x) {
        return x & (-x);
    }

    public void update(int x) {
        while (x <= n) {
            ++tree[x];
            x += lowbit(x);
        }
    }

    public int query(int x) {
        int ans = 0;
        while (x > 0) {
            ans += tree[x];
            x -= lowbit(x);
        }
        return ans;
    }

    public int query(int x, int y) {
        return query(y) - query(x - 1);
    }
}
```

```Python [sol1-Python3]
class BIT:
    def __init__(self, n: int):
        self.n = n
        self.tree = [0] * (n + 1)
    
    @staticmethod
    def lowbit(x: int) -> int:
        return x & (-x)
    
    def update(self, x: int):
        while x <= self.n:
            self.tree[x] += 1
            x += BIT.lowbit(x)
    
    def query(self, x: int) -> int:
        ans = 0
        while x > 0:
            ans += self.tree[x]
            x -= BIT.lowbit(x)
        return ans

    def queryRange(self, x: int, y: int) -> int:
        return self.query(y) - self.query(x - 1)


class Solution:
    def minInteger(self, num: str, k: int) -> str:
        n = len(num)
        pos = [list() for _ in range(10)]
        for i in range(n - 1, -1, -1):
            pos[ord(num[i]) - ord('0')].append(i + 1)
        
        ans = ""
        bit = BIT(n)
        for i in range(1, n + 1):
            for j in range(10):
                if pos[j]:
                    behind = bit.queryRange(pos[j][-1] + 1, n)
                    dist = pos[j][-1] + behind - i
                    if dist <= k:
                        bit.update(pos[j][-1])
                        pos[j].pop()
                        ans += str(j)
                        k -= dist
                        break
        
        return ans
```

```C [sol1-C]
#include <math.h>
#include <string.h>

int lowbit(int x) { return x & (-x); }

void update(int* tree, int x, int n) {
    while (x <= n) {
        ++tree[x];
        x += lowbit(x);
    }
}

int query_pre(int* tree, int x) {
    int ans = 0;
    while (x) {
        ans += tree[x];
        x -= lowbit(x);
    }
    return ans;
}

int query(int* tree, int x, int y) {
    return query_pre(tree, y) - query_pre(tree, x - 1);
}

char* minInteger(char* num, int k) {
    int n = strlen(num);
    int* tree = (int*)malloc(sizeof(int) * (n + 1));
    memset(tree, 0, sizeof(int) * (n + 1));

    int** pos = (int**)malloc(sizeof(int*) * 10);
    for (int i = 0; i < 10; i++) {
        pos[i] = (int*)malloc(sizeof(int) * (n + 1));
    }

    int* len = (int*)malloc(sizeof(int) * 10);
    memset(len, 0, sizeof(int) * 10);
    int* add = (int*)malloc(sizeof(int) * 10);
    memset(add, 0, sizeof(int) * 10);

    for (int i = 0; i < n; ++i) {
        pos[num[i] - '0'][len[num[i] - '0']++] = i + 1;
    }
    char* ans = (char*)malloc(sizeof(char) * (n + 1));
    ans[n] = '\0';
    for (int i = 1; i <= n; ++i) {
        for (int j = 0; j < 10; ++j) {
            if (add[j] < len[j]) {
                int behind = query(tree, pos[j][add[j]] + 1, n);
                int dist = pos[j][add[j]] + behind - i;
                if (dist <= k) {
                    update(tree, pos[j][add[j]], n);
                    add[j]++;
                    ans[i - 1] = (j + '0');
                    k -= dist;
                    break;
                }
            }
        }
    }
    return ans;
}
```

**复杂度分析**

- 时间复杂度：$O(n \log n)$，其中 $n$ 是字符串 $\textit{num}$ 的长度。遍历位置的时间复杂度为 $O(n)$，枚举数位的时间复杂度为 $O(10)=O(1)$，树状数组「单点修改」和「区间查询」操作的时间复杂度均为 $O(\log n)$，相乘即可得到总时间复杂度 $O(n \log n)$。

- 空间复杂度：$O(n)$。除了返回的答案之外，数组 $\textit{pos}$ 以及树状数组需要的空间均为 $O(n)$。
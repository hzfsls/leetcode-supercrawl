## [149.直线上最多的点数 中文官方题解](https://leetcode.cn/problems/max-points-on-a-line/solutions/100000/zhi-xian-shang-zui-duo-de-dian-shu-by-le-tq8f)

#### 方法一：哈希表

**思路及解法**

我们可以考虑枚举所有的点，假设直线经过该点时，该直线所能经过的最多的点数。

假设我们当前枚举到点 $i$，如果直线同时经过另外两个不同的点 $j$ 和 $k$，那么可以发现点 $i$ 和点 $j$ 所连直线的斜率恰等于点 $i$ 和点 $k$ 所连直线的斜率。

于是我们可以统计其他所有点与点 $i$ 所连直线的斜率，出现次数最多的斜率即为经过点数最多的直线的斜率，其经过的点数为该斜率出现的次数加一（点 $i$ 自身也要被统计）。

**如何记录斜率**

需要注意的是，浮点数类型可能因为精度不够而无法足够精确地表示每一个斜率，因此我们需要换一种方法来记录斜率。

一般情况下，斜率可以表示为 $\textit{slope} = \dfrac{\Delta y}{\Delta x}$ 的形式，因此我们可以用分子和分母组成的二元组来代表斜率。但注意到存在形如 $\dfrac{1}{2}=\dfrac{2}{4}$ 这样两个二元组不同，但实际上两分数的值相同的情况，所以我们需要将分数 $\dfrac{\Delta y}{\Delta x}$ 化简为最简分数的形式。

将分子和分母同时除以二者绝对值的最大公约数，可得二元组 $\Big(\dfrac{\Delta x}{\gcd(|\Delta x|,|\Delta y|)},\dfrac{\Delta y}{\gcd(|\Delta x|,|\Delta y|)}\Big)$。令 $\textit{mx}=\dfrac{\Delta x}{\gcd(|\Delta x|,|\Delta y|)}$，$\textit{my}=\dfrac{\Delta y}{\gcd(|\Delta x|,|\Delta y|)}$，则上述化简后的二元组为 $(\textit{mx},\textit{my})$。

此外，因为分子分母可能存在负数，为了防止出现形如 $\dfrac{-1}{2}=\dfrac{1}{-2}$ 的情况，我们还需要规定分子为非负整数，如果 $\textit{my}$ 为负数，我们将二元组中两个数同时取相反数即可。

特别地，考虑到 $\textit{mx}$ 和 $\textit{my}$ 两数其中有一个为 $0$ 的情况（因为题目中不存在重复的点，因此不存在两数均为 $0$ 的情况），此时两数不存在数学意义上的最大公约数，因此我们直接特判这两种情况。当 $\textit{mx}$ 为 $0$ 时，我们令 $\textit{my}=1$；当 $\textit{my}$ 为 $0$ 时，我们令 $\textit{mx}=1$ 即可。

经过上述操作之后，即可得到最终的二元组 $(\textit{mx},\textit{my})$。在本题中，因为点的横纵坐标取值范围均为 $[-10^4, 10^4]$，所以斜率 $\textit{slope} = \dfrac{\textit{my}}{\textit{mx}}$ 中，$\textit{mx}$ 落在区间 $[- 2 \times 10^4, 2 \times 10^4]$ 内，$\textit{my}$ 落在区间 $[0, 2 \times 10^4]$ 内。注意到 $32$ 位整数的范围远超这两个区间，因此我们可以用单个 $32$ 位整型变量来表示这两个整数。具体地，我们令 $\textit{val} = \textit{my} + (2 \times 10^4 + 1) \times \textit{mx}$ 即可。

**优化**

最后我们再加四个小优化：

- 在点的总数量小于等于 $2$ 的情况下，我们总可以用一条直线将所有点串联，此时我们直接返回点的总数量即可；
- 当我们枚举到点 $i$ 时，我们只需要考虑编号大于 $i$ 的点到点 $i$ 的斜率，因为如果直线同时经过编号小于点 $i$ 的点 $j$，那么当我们枚举到 $j$ 时就已经考虑过该直线了；
- 当我们找到一条直线经过了图中超过半数的点时，我们即可以确定该直线即为经过最多点的直线；
- 当我们枚举到点 $i$（假设编号从 $0$ 开始）时，我们至多只能找到 $n-i$ 个点共线。假设此前找到的共线的点的数量的最大值为 $k$，如果有 $k \geq n-i$，那么此时我们即可停止枚举，因为不可能再找到更大的答案了。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    int gcd(int a, int b) {
        return b ? gcd(b, a % b) : a;
    }

    int maxPoints(vector<vector<int>>& points) {
        int n = points.size();
        if (n <= 2) {
            return n;
        }
        int ret = 0;
        for (int i = 0; i < n; i++) {
            if (ret >= n - i || ret > n / 2) {
                break;
            }
            unordered_map<int, int> mp;
            for (int j = i + 1; j < n; j++) {
                int x = points[i][0] - points[j][0];
                int y = points[i][1] - points[j][1];
                if (x == 0) {
                    y = 1;
                } else if (y == 0) {
                    x = 1;
                } else {
                    if (y < 0) {
                        x = -x;
                        y = -y;
                    }
                    int gcdXY = gcd(abs(x), abs(y));
                    x /= gcdXY, y /= gcdXY;
                }
                mp[y + x * 20001]++;
            }
            int maxn = 0;
            for (auto& [_, num] : mp) {
                maxn = max(maxn, num + 1);
            }
            ret = max(ret, maxn);
        }
        return ret;
    }
};
```

```Java [sol1-Java]
class Solution {
    public int maxPoints(int[][] points) {
        int n = points.length;
        if (n <= 2) {
            return n;
        }
        int ret = 0;
        for (int i = 0; i < n; i++) {
            if (ret >= n - i || ret > n / 2) {
                break;
            }
            Map<Integer, Integer> map = new HashMap<Integer, Integer>();
            for (int j = i + 1; j < n; j++) {
                int x = points[i][0] - points[j][0];
                int y = points[i][1] - points[j][1];
                if (x == 0) {
                    y = 1;
                } else if (y == 0) {
                    x = 1;
                } else {
                    if (y < 0) {
                        x = -x;
                        y = -y;
                    }
                    int gcdXY = gcd(Math.abs(x), Math.abs(y));
                    x /= gcdXY;
                    y /= gcdXY;
                }
                int key = y + x * 20001;
                map.put(key, map.getOrDefault(key, 0) + 1);
            }
            int maxn = 0;
            for (Map.Entry<Integer, Integer> entry: map.entrySet()) {
                int num = entry.getValue();
                maxn = Math.max(maxn, num + 1);
            }
            ret = Math.max(ret, maxn);
        }
        return ret;
    }

    public int gcd(int a, int b) {
        return b != 0 ? gcd(b, a % b) : a;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int MaxPoints(int[][] points) {
        int n = points.Length;
        if (n <= 2) {
            return n;
        }
        int ret = 0;
        for (int i = 0; i < n; i++) {
            if (ret >= n - i || ret > n / 2) {
                break;
            }
            Dictionary<int, int> dictionary = new Dictionary<int, int>();
            for (int j = i + 1; j < n; j++) {
                int x = points[i][0] - points[j][0];
                int y = points[i][1] - points[j][1];
                if (x == 0) {
                    y = 1;
                } else if (y == 0) {
                    x = 1;
                } else {
                    if (y < 0) {
                        x = -x;
                        y = -y;
                    }
                    int gcdXY = gcd(Math.Abs(x), Math.Abs(y));
                    x /= gcdXY;
                    y /= gcdXY;
                }
                int key = y + x * 20001;
                if (!dictionary.ContainsKey(key)) {
                    dictionary.Add(key, 1);
                } else {
                    dictionary[key]++;
                }
            }
            int maxn = 0;
            foreach (int num in dictionary.Values) {
                maxn = Math.Max(maxn, num + 1);
            }
            ret = Math.Max(ret, maxn);
        }
        return ret;
    }

    public int gcd(int a, int b) {
        return b != 0 ? gcd(b, a % b) : a;
    }
}
```

```go [sol1-Golang]
func maxPoints(points [][]int) (ans int) {
    n := len(points)
    if n <= 2 {
        return n
    }
    for i, p := range points {
        if ans >= n-i || ans > n/2 {
            break
        }
        cnt := map[int]int{}
        for _, q := range points[i+1:] {
            x, y := p[0]-q[0], p[1]-q[1]
            if x == 0 {
                y = 1
            } else if y == 0 {
                x = 1
            } else {
                if y < 0 {
                    x, y = -x, -y
                }
                g := gcd(abs(x), abs(y))
                x /= g
                y /= g
            }
            cnt[y+x*20001]++
        }
        for _, c := range cnt {
            ans = max(ans, c+1)
        }
    }
    return
}

func gcd(a, b int) int {
    for a != 0 {
        a, b = b%a, a
    }
    return b
}

func abs(x int) int {
    if x < 0 {
        return -x
    }
    return x
}

func max(a, b int) int {
    if a > b {
        return a
    }
    return b
}
```

```JavaScript [sol1-JavaScript]
var maxPoints = function(points) {
    const n = points.length;
    if (n <= 2) {
        return n;
    }
    let ret = 0;
    for (let i = 0; i < n; i++) {
        if (ret >= n - i || ret > n / 2) {
            break;
        }
        const map = new Map();
        for (let j = i + 1; j < n; j++) {
            let x = points[i][0] - points[j][0];
            let y = points[i][1] - points[j][1];
            if (x === 0) {
                y = 1;
            } else if (y === 0) {
                x = 1;
            } else {
                if (y < 0) {
                    x = -x;
                    y = -y;
                }
                const gcdXY = gcd(Math.abs(x), Math.abs(y));
                x /= gcdXY;
                y /= gcdXY;
            }
            const key = y + x * 20001;
            map.set(key, (map.get(key) || 0)+ 1);
        }
        let maxn = 0;
        for (const num of map.values()) {
            maxn = Math.max(maxn, num + 1);
        }
        ret = Math.max(ret, maxn);
    }
    return ret;
};

const gcd = (a, b) => {
    return b != 0 ? gcd(b, a % b) : a;
}
```

```C [sol1-C]

struct HashTable {
    int key, val;
    UT_hash_handle hh;
};

int gcd(int a, int b) {
    return b ? gcd(b, a % b) : a;
}

int maxPoints(int** points, int pointsSize, int* pointsColSize) {
    int n = pointsSize;
    if (n <= 2) {
        return n;
    }
    int ret = 0;
    for (int i = 0; i < n; i++) {
        if (ret >= n - i || ret > n / 2) {
            break;
        }
        struct HashTable* hashTable = NULL;
        for (int j = i + 1; j < n; j++) {
            int x = points[i][0] - points[j][0];
            int y = points[i][1] - points[j][1];
            if (x == 0) {
                y = 1;
            } else if (y == 0) {
                x = 1;
            } else {
                if (y < 0) {
                    x = -x;
                    y = -y;
                }
                int gcdXY = gcd(abs(x), abs(y));
                x /= gcdXY, y /= gcdXY;
            }
            struct HashTable* tmp;
            int val = y + x * 20010;
            HASH_FIND_INT(hashTable, &val, tmp);
            if (tmp == NULL) {
                tmp = malloc(sizeof(struct HashTable));
                tmp->key = val;
                tmp->val = 1;
                HASH_ADD_INT(hashTable, key, tmp);
            } else {
                tmp->val++;
            }
        }
        int maxn = 0;
        struct HashTable *iter, *tmp;
        HASH_ITER(hh, hashTable, iter, tmp) {
            maxn = fmax(maxn, iter->val + 1);
            HASH_DEL(hashTable, iter);
            free(iter);
        }
        ret = fmax(ret, maxn);
    }
    return ret;
}
```

**复杂度分析**

- 时间复杂度：$O(n^2 \times \log m)$，其中 $n$ 为点的数量，$m$ 为横纵坐标差的最大值。最坏情况下我们需要枚举所有 $n$ 个点，枚举单个点过程中需要进行 $O(n)$ 次最大公约数计算，单次最大公约数计算的时间复杂度是 $O(\log m)$，因此总时间复杂度为 $O(n^2 \times \log m)$。

- 空间复杂度：$O(n)$，其中 $n$ 为点的数量。主要为哈希表的开销。
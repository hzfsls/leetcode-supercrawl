## [447.回旋镖的数量 中文官方题解](https://leetcode.cn/problems/number-of-boomerangs/solutions/100000/hui-xuan-biao-de-shu-liang-by-leetcode-s-lft5)
#### 方法一：枚举 + 哈希表

题目所描述的回旋镖可以视作一个 $\texttt{V}$ 型的折线。我们可以枚举每个 $\textit{points}[i]$，将其当作 $\texttt{V}$ 型的拐点。设 $\textit{points}$ 中有 $m$ 个点到 $\textit{points}[i]$ 的距离均相等，我们需要从这 $m$ 点中选出 $2$ 个点当作回旋镖的 $2$ 个端点，由于题目要求考虑元组的顺序，因此方案数即为在 $m$ 个元素中选出 $2$ 个不同元素的排列数，即：

$$
A_m^2 = m\cdot(m-1)
$$

据此，我们可以遍历 $\textit{points}$，计算并统计所有点到 $\textit{points}[i]$ 的距离，将每个距离的出现次数记录在哈希表中，然后遍历哈希表，并用上述公式计算并累加回旋镖的个数。

在代码实现时，我们可以直接保存距离的平方，避免复杂的开方运算。

```Python [sol1-Python3]
class Solution:
    def numberOfBoomerangs(self, points: List[List[int]]) -> int:
        ans = 0
        for p in points:
            cnt = defaultdict(int)
            for q in points:
                dis = (p[0] - q[0]) * (p[0] - q[0]) + (p[1] - q[1]) * (p[1] - q[1])
                cnt[dis] += 1
            for m in cnt.values():
                ans += m * (m - 1)
        return ans
```

```C++ [sol1-C++]
class Solution {
public:
    int numberOfBoomerangs(vector<vector<int>> &points) {
        int ans = 0;
        for (auto &p : points) {
            unordered_map<int, int> cnt;
            for (auto &q : points) {
                int dis = (p[0] - q[0]) * (p[0] - q[0]) + (p[1] - q[1]) * (p[1] - q[1]);
                ++cnt[dis];
            }
            for (auto &[_, m] : cnt) {
                ans += m * (m - 1);
            }
        }
        return ans;
    }
};
```

```Java [sol1-Java]
class Solution {
    public int numberOfBoomerangs(int[][] points) {
        int ans = 0;
        for (int[] p : points) {
            Map<Integer, Integer> cnt = new HashMap<Integer, Integer>();
            for (int[] q : points) {
                int dis = (p[0] - q[0]) * (p[0] - q[0]) + (p[1] - q[1]) * (p[1] - q[1]);
                cnt.put(dis, cnt.getOrDefault(dis, 0) + 1);
            }
            for (Map.Entry<Integer, Integer> entry : cnt.entrySet()) {
                int m = entry.getValue();
                ans += m * (m - 1);
            }
        }
        return ans;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int NumberOfBoomerangs(int[][] points) {
        int ans = 0;
        foreach (int[] p in points) {
            Dictionary<int, int> cnt = new Dictionary<int, int>();
            foreach (int[] q in points) {
                int dis = (p[0] - q[0]) * (p[0] - q[0]) + (p[1] - q[1]) * (p[1] - q[1]);
                if (!cnt.ContainsKey(dis)) {
                    cnt.Add(dis, 1);
                } else {
                    ++cnt[dis];
                }
            }
            foreach (KeyValuePair<int, int> kv in cnt) {
                int m = kv.Value;
                ans += m * (m - 1);
            }
        }
        return ans;
    }
}
```

```go [sol1-Golang]
func numberOfBoomerangs(points [][]int) (ans int) {
    for _, p := range points {
        cnt := map[int]int{}
        for _, q := range points {
            dis := (p[0]-q[0])*(p[0]-q[0]) + (p[1]-q[1])*(p[1]-q[1])
            cnt[dis]++
        }
        for _, m := range cnt {
            ans += m * (m - 1)
        }
    }
    return
}
```

```JavaScript [sol1-JavaScript]
var numberOfBoomerangs = function(points) {
    let ans = 0;
    for (const p of points) {
        const cnt = new Map();
        for (const q of points) {
            const dis = (p[0] - q[0]) * (p[0] - q[0]) + (p[1] - q[1]) * (p[1] - q[1]);
            cnt.set(dis, (cnt.get(dis) || 0) + 1);
        }
        for (const [_, m] of cnt.entries()) {
            ans += m * (m - 1);
        }
    }
    return ans;
};
```

**复杂度分析**

- 时间复杂度：$O(n^2)$，其中 $n$ 是数组 $\textit{points}$ 的长度。

- 空间复杂度：$O(n)$。
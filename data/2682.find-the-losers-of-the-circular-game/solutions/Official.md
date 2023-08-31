## [2682.找出转圈游戏输家 中文官方题解](https://leetcode.cn/problems/find-the-losers-of-the-circular-game/solutions/100000/zhao-chu-zhuan-quan-you-xi-shu-jia-by-le-rfiq)

#### 方法一：直接模拟

**思路与算法**

根据题意可以知道总共有 $n$ 个位置，由于起始编号为 $1$，第 $i$ 个朋友的位置顺时针移动 $1$ 步会到达第 $(i + 1) \bmod n + 1$ 个朋友的位置。

游戏规则如下：
从第 $1$ 个位置开始传球。
- 接着，第 $1$ 个朋友将球传给距离他顺时针方向 $k$ 步的朋友。
- 然后，接球的朋友应该把球传给距离他顺时针方向 $2k$ 步的朋友。
- 接着，接球的朋友应该把球传给距离他顺时针方向 $3k$ 步的朋友，以此类推。

换句话说，在第 $i$ 轮中持有球的那位朋友将球传递给距离他顺时针方向 $i \times k$ 步的朋友，假设在第 $i$ 轮中持有球的朋友位置为 $x$，则第 $i + 1$ 轮持有球的朋友位置为 $(x + i \times k) \bmod n  + 1$。当某个位置第 $2$ 次接到球时，游戏结束,在整场游戏中没有接到过球的朋友是**输家**。

我们根据题意直接模拟即可，为了方便计算，设第 $1$ 个小朋友的起始位置为 $0$，则从 $0$ 开始进行传递，同时用 $\textit{visit}$ 来标记每个位置是否被访问过，假设当前的位置为 $j$，则第 $i$ 次传递后球的位置处于 $(j + i \times k) \bmod n$，此时将所有访问过的位置标记即可，直到当前位置 $j$ 已经被遍历过则直接结束，然后依次遍历找到未被访问的位置返回即可。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    vector<int> circularGameLosers(int n, int k) {
        vector<bool> visit(n, false);
        for (int i = k, j = 0; !visit[j]; i += k) {
            visit[j] = true;
            j = (j + i) % n;
        }
        vector<int> ans;
        for (int i = 0; i < n; i++) {
            if (!visit[i]) {
                ans.emplace_back(i + 1);
            }
        }
        return ans;
    }
};
```

```Java [sol1-Java]
class Solution {
    public int[] circularGameLosers(int n, int k) {
        boolean[] visit = new boolean[n];
        for (int i = k, j = 0; !visit[j]; i += k) {
            visit[j] = true;
            j = (j + i) % n;
        }
        List<Integer> list = new ArrayList<Integer>();
        for (int i = 0; i < n; i++) {
            if (!visit[i]) {
                list.add(i + 1);
            }
        }
        int[] ans = new int[list.size()];
        for (int i = 0; i < list.size(); i++) {
            ans[i] = list.get(i);
        }
        return ans;
    }
}
```

```Python [sol1-Python3]
class Solution:
    def circularGameLosers(self, n: int, k: int) -> List[int]:
        visit = [False] * n
        i = k
        j = 0
        while not visit[j]:
            visit[j] = True
            j = (j + i) % n
            i += k
        ans = []
        for i in range(n):
            if not visit[i]:
                ans.append(i + 1)
        return ans
```

```Go [sol1-Go]
func circularGameLosers(n, k int) []int {
    visit := make([]bool, n)
    j := 0
    for i := k; !visit[j]; i += k {
        visit[j] = true;
        j = (j + i) % n;
    }
    ans := make([]int, 0, n)
    for i := 0; i < n; i++ {
        if !visit[i] {
            ans = append(ans, i+1)
        }
    }
    return ans
}
```

```JavaScript [sol1-JavaScript]
var circularGameLosers = function(n, k) {
    let visit = new Array(n).fill(false);
    for (let i = k, j = 0; !visit[j]; i += k) {
        visit[j] = true;
        j = (j + i) % n;
    }
    let ans = [];
    for (let i = 0; i < n; i++) {
        if (!visit[i]) {
            ans.push(i + 1);
        }
    }
    return ans;
};
```

```C# [sol1-C#]
public class Solution {
    public int[] CircularGameLosers(int n, int k) {
        bool[] visit = new bool[n];
        for (int i = k, j = 0; !visit[j]; i += k) {
            visit[j] = true;
            j = (j + i) % n;
        }
        IList<int> list = new List<int>();
        for (int i = 0; i < n; i++) {
            if (!visit[i]) {
                list.Add(i + 1);
            }
        }
        int[] ans = new int[list.Count];
        for (int i = 0; i < list.Count; i++) {
            ans[i] = list[i];
        }
        return ans;
    }
}
```

```C [sol1-C]
int* circularGameLosers(int n, int k, int* returnSize) {
    bool visit[n];
    memset(visit, 0, sizeof(visit));
    for (int i = k, j = 0; !visit[j]; i += k) {
        visit[j] = true;
        j = (j + i) % n;
    }
    int *ans = (int *)malloc(sizeof(int) * n);
    int pos = 0;
    for (int i = 0; i < n; i++) {
        if (!visit[i]) {
            ans[pos++] = i + 1;
        }
    }
    *returnSize = pos;
    return ans;
}
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 为给定的数字。一共有 $n$ 个位置，由于每个位置最多只会被访问一次，因此时间复杂度为 $O(n)$。

- 空间复杂度：$O(n)$，其中 $n$ 为给定的数字。一共有 $n$ 个位置，需要记录每个位置是否被访问过，因此空间复杂度为 $O(n)$。
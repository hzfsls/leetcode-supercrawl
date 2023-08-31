## [455.分发饼干 中文官方题解](https://leetcode.cn/problems/assign-cookies/solutions/100000/fen-fa-bing-gan-by-leetcode-solution-50se)
#### 方法一：排序 + 双指针 + 贪心

为了尽可能满足最多数量的孩子，从贪心的角度考虑，应该按照孩子的胃口从小到大的顺序依次满足每个孩子，且对于每个孩子，应该选择可以满足这个孩子的胃口且尺寸最小的饼干。证明如下。

假设有 $m$ 个孩子，胃口值分别是 $g_1$ 到 $g_m$，有 $n$ 块饼干，尺寸分别是 $s_1$ 到 $s_n$，满足 $g_i \le g_{i+1}$ 和 $s_j \le s_{j+1}$，其中 $1 \le i < m$，$1 \le j < n$。

假设在对前 $i-1$ 个孩子分配饼干之后，可以满足第 $i$ 个孩子的胃口的最小的饼干是第 $j$ 块饼干，即 $s_j$ 是剩下的饼干中满足 $g_i \le s_j$ 的最小值，最优解是将第 $j$ 块饼干分配给第 $i$ 个孩子。如果不这样分配，考虑如下两种情形：

- 如果 $i<m$ 且 $g_{i+1} \le s_j$ 也成立，则如果将第 $j$ 块饼干分配给第 $i+1$ 个孩子，且还有剩余的饼干，则可以将第 $j+1$ 块饼干分配给第 $i$ 个孩子，分配的结果不会让更多的孩子被满足；

- 如果 $j<n$，则如果将第 $j+1$ 块饼干分配给第 $i$ 个孩子，当 $g_{i+1} \le s_j$ 时，可以将第 $j$ 块饼干分配给第 $i+1$ 个孩子，分配的结果不会让更多的孩子被满足；当 $g_{i+1}>s_j$ 时，第 $j$ 块饼干无法分配给任何孩子，因此剩下的可用的饼干少了一块，因此分配的结果不会让更多的孩子被满足，甚至可能因为少了一块可用的饼干而导致更少的孩子被满足。

基于上述分析，可以使用贪心的方法尽可能满足最多数量的孩子。

首先对数组 $g$ 和 $s$ 排序，然后从小到大遍历 $g$ 中的每个元素，对于每个元素找到能满足该元素的 $s$ 中的最小的元素。具体而言，令 $i$ 是 $g$ 的下标，$j$ 是 $s$ 的下标，初始时 $i$ 和 $j$ 都为 $0$，进行如下操作。

对于每个元素 $g[i]$，找到**未被使用的**最小的 $j$ 使得 $g[i] \le s[j]$，则 $s[j]$ 可以满足 $g[i]$。由于 $g$ 和 $s$ 已经排好序，因此整个过程只需要对数组 $g$ 和 $s$ 各遍历一次。当两个数组之一遍历结束时，说明所有的孩子都被分配到了饼干，或者所有的饼干都已经被分配或被尝试分配（可能有些饼干无法分配给任何孩子），此时被分配到饼干的孩子数量即为可以满足的最多数量。

```Java [sol1-Java]
class Solution {
    public int findContentChildren(int[] g, int[] s) {
        Arrays.sort(g);
        Arrays.sort(s);
        int m = g.length, n = s.length;
        int count = 0;
        for (int i = 0, j = 0; i < m && j < n; i++, j++) {
            while (j < n && g[i] > s[j]) {
                j++;
            }
            if (j < n) {
                count++;
            }
        }
        return count;
    }
}
```

```JavaScript [sol1-JavaScript]
var findContentChildren = function(g, s) {
    g.sort((a, b) => a - b);
    s.sort((a, b) => a - b);
    const m = g.length, n = s.length;
    let count = 0;
    for (let i = 0, j = 0; i < m && j < n; i++, j++) {
        while (j < n && g[i] > s[j]) {
            j++;
        }
        if (j < n) {
            count++;
        }
    }
    return count;
};
```

```C++ [sol1-C++]
class Solution {
public:
    int findContentChildren(vector<int>& g, vector<int>& s) {
        sort(g.begin(), g.end());
        sort(s.begin(), s.end());
        int m = g.size(), n = s.size();
        int count = 0;
        for (int i = 0, j = 0; i < m && j < n; i++, j++) {
            while (j < n && g[i] > s[j]) {
                j++;
            }
            if (j < n) {
                count++;
            }
        }
        return count;
    }
};
```

```Go [sol1-Golang]
func findContentChildren(g []int, s []int) (ans int) {
    sort.Ints(g)
    sort.Ints(s)
    m, n := len(g), len(s)
    for i, j := 0, 0; i < m && j < n; i++ {
        for j < n && g[i] > s[j] {
            j++
        }
        if j < n {
            ans++
            j++
        }
    }
    return
}
```

```Python [sol1-Python3]
class Solution:
    def findContentChildren(self, g: List[int], s: List[int]) -> int:
        g.sort()
        s.sort()
        m, n = len(g), len(s)
        i = j = count = 0

        while i < m and j < n:
            while j < n and g[i] > s[j]:
                j += 1
            if j < n:
                count += 1
            i += 1
            j += 1
        
        return count
```

```C [sol1-C]
int cmp(int* a, int* b) {
    return *a - *b;
}

int findContentChildren(int* g, int gSize, int* s, int sSize) {
    qsort(g, gSize, sizeof(int), cmp);
    qsort(s, sSize, sizeof(int), cmp);
    int m = gSize, n = sSize;
    int count = 0;
    for (int i = 0, j = 0; i < m && j < n; i++, j++) {
        while (j < n && g[i] > s[j]) {
            j++;
        }
        if (j < n) {
            count++;
        }
    }
    return count;
}
```

**复杂度分析**

- 时间复杂度：$O(m \log m + n \log n)$，其中 $m$ 和 $n$ 分别是数组 $g$ 和 $s$ 的长度。对两个数组排序的时间复杂度是 $O(m \log m + n \log n)$，遍历数组的时间复杂度是 $O(m+n)$，因此总时间复杂度是 $O(m \log m + n \log n)$。

- 空间复杂度：$O(\log m + \log n)$，其中 $m$ 和 $n$ 分别是数组 $g$ 和 $s$ 的长度。空间复杂度主要是排序的额外空间开销。
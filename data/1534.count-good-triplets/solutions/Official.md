## [1534.统计好三元组 中文官方题解](https://leetcode.cn/problems/count-good-triplets/solutions/100000/tong-ji-hao-san-yuan-zu-by-leetcode-solution)

#### 方法一：枚举

**思路与算法**

用 $O(n^3)$ 的循环依次枚举所有的 $(i, j, k)$，这里 $0 \leq i < j < k < {\rm arr.length}$，对于每组 $(i, j, k)$，判断 ${\rm arr}[i]$、${\rm arr}[j]$、${\rm arr}[k]$ 是否满足条件。

最终统计出所有满足条件的三元组的数量。

**代码**

```cpp [sol1-C++]
class Solution {
public:
    int countGoodTriplets(vector<int>& arr, int a, int b, int c) {
        int n = arr.size(), cnt = 0;
        for (int i = 0; i < n; ++i) {
            for (int j = i + 1; j < n; ++j) {
                for (int k = j + 1; k < n; ++k) {
                    if (abs(arr[i] - arr[j]) <= a && abs(arr[j] - arr[k]) <= b && abs(arr[i] - arr[k]) <= c) {
                        ++cnt;
                    }
                }
            }
        }
        return cnt;
    }
};
```

```Java [sol1-Java]
class Solution {
    public int countGoodTriplets(int[] arr, int a, int b, int c) {
        int n = arr.length, cnt = 0;
        for (int i = 0; i < n; ++i) {
            for (int j = i + 1; j < n; ++j) {
                for (int k = j + 1; k < n; ++k) {
                    if (Math.abs(arr[i] - arr[j]) <= a && Math.abs(arr[j] - arr[k]) <= b && Math.abs(arr[i] - arr[k]) <= c) {
                        ++cnt;
                    }
                }
            }
        }
        return cnt;
    }
}
```

```JavaScript [sol1-JavaScript]
var countGoodTriplets = function(arr, a, b, c) {
    const n = arr.length;
    let cnt = 0;
    for (let i = 0; i < n; ++i) {
        for (let j = i + 1; j < n; ++j) {
            for (let k = j + 1; k < n; ++k) {
                if (Math.abs(arr[i] - arr[j]) <= a && Math.abs(arr[j] - arr[k]) <= b && Math.abs(arr[i] - arr[k]) <= c) {
                    ++cnt;
                }
            }
        }
    }
    return cnt;
};
```

```Python [sol1-Python3]
class Solution:
    def countGoodTriplets(self, arr: List[int], a: int, b: int, c: int) -> int:
        n = len(arr)
        cnt = 0
        for i in range(n):
            for j in range(i + 1, n):
                for k in range(j + 1, n):
                    if abs(arr[i] - arr[j]) <= a and abs(arr[j] - arr[k]) <= b and abs(arr[i] - arr[k]) <= c:
                        cnt += 1
        return cnt
```

**复杂度分析**

+ 时间复杂度：$O(n^3)$，其中 $n$ 是数组 $\textit{arr}$ 的长度。

+ 空间复杂度：$O(1)$。

#### 方法二：枚举优化

**思路与算法**

我们考虑 $O(n^2)$ 枚举满足 $|\rm arr[j]-\rm arr[k]|\le b$ 的二元组 $(j,k)$，统计这个二元组下有多少 $i$ 满足条件。由题目已知 $i$ 的限制条件为 $|\rm arr[i]-\rm arr[j]|\le a \ \&\&\ |\rm arr[i]-\rm arr[k]|\le c$，我们可以拆开绝对值，得到符合条件的值一定是 $[\rm arr[j]-a,\rm arr[j]+a]$ 和 $[\rm arr[k]-c,\rm arr[k]+c]$ 两个区间的交集，我们记为 $[l,r]$。因此，在枚举 $(j,k)$ 这个二元组的时候，我们只需要快速统计出满足 $i<j$ 且 $\rm arr[i]$ 的值域范围在 $[l,r]$ 的 $i$ 的个数即可。

很容易想到维护一个 $\rm arr[i]$ 频次数组的前缀和 $\rm sum$，对于一个二元组 $(j,k)$，我们可以 $O(1)$ 得到答案为 $\rm sum[r]-\rm sum[l-1]$。考虑怎么维护保证当前频次数组存的数的下标符合 $i<j$ 的限制，我们只要从小到大枚举 $j$，每次 $j$ 移动指针加一的时候，将 $\rm arr[j]$ 的值更新到 $\rm sum$ 数组中即可，这样能保证枚举到 $j$ 的时候 $\rm sum$ 数组里存的值的下标满足限制。

 「将 $\rm arr[j]$ 的值更新到 $\rm sum$ 数组中」这个操作在本方法中是暴力更新，因为数组的值域上限很小，有能力的读者可以考虑怎么在进一步优化这一部分的复杂度，可以从离散化或者树状数组的角度考虑，这里不再赘述。

**代码**

```cpp [sol2-C++]
class Solution {
public:
    int countGoodTriplets(vector<int>& arr, int a, int b, int c) {
        int ans = 0, n = arr.size();
        vector<int> sum(1001, 0);
        for (int j = 0; j < n; ++j) {
            for (int k = j + 1; k < n; ++k) {
                if (abs(arr[j] - arr[k]) <= b) {
                    int lj = arr[j] - a, rj = arr[j] + a;
                    int lk = arr[k] - c, rk = arr[k] + c;
                    int l = max(0, max(lj, lk)), r = min(1000, min(rj, rk));
                    if (l <= r) {
                        if (l == 0) {
                            ans += sum[r];
                        }
                        else {
                            ans += sum[r] - sum[l - 1];
                        }
                    }
                }
            }
            for (int k = arr[j]; k <= 1000; ++k) {
                ++sum[k];
            }
        }
        return ans;
    }
};
```

```Java [sol2-Java]
class Solution {
    public int countGoodTriplets(int[] arr, int a, int b, int c) {
        int ans = 0, n = arr.length;
        int[] sum = new int[1001];
        for (int j = 0; j < n; ++j) {
            for (int k = j + 1 ; k < n; ++k) {
                if (Math.abs(arr[j] - arr[k]) <= b) {
                    int lj = arr[j] - a, rj = arr[j] + a;
                    int lk = arr[k] - c, rk = arr[k] + c;
                    int l = Math.max(0, Math.max(lj, lk)), r = Math.min(1000, Math.min(rj, rk));
                    if (l <= r) {
                        if (l == 0) {
                            ans += sum[r];
                        }
                        else {
                            ans += sum[r] - sum[l - 1];
                        }
                    }
                }
            }
            for (int k = arr[j]; k <= 1000; ++k) {
                ++sum[k];
            }
        }
        return ans;
    }
}
```

```JavaScript [sol2-JavaScript]
var countGoodTriplets = function(arr, a, b, c) {
    const n = arr.length, sum = new Array(1001).fill(0);
    let ans = 0;
    for (let j = 0; j < n; ++j) {
        for (let k = j + 1; k < n; ++k) {
            if (Math.abs(arr[j] - arr[k]) <= b) {
                const lj = arr[j] - a, rj = arr[j] + a;
                const lk = arr[k] - c, rk = arr[k] + c;
                const l = Math.max(0, Math.max(lj, lk)), r = Math.min(1000, Math.min(rj, rk));
                if (l <= r) {
                    if (l === 0) {
                        ans += sum[r];
                    }
                    else {
                        ans += sum[r] - sum[l - 1];
                    }
                }
            }
        }
        for (let k = arr[j]; k <= 1000; ++k) {
            sum[k] += 1;
        }
    }
    return ans;
};
```

```Python [sol2-Python3]
class Solution:
    def countGoodTriplets(self, arr: List[int], a: int, b: int, c: int) -> int:
        ans = 0
        n = len(arr)
        total = [0] * 1001
        for j in range(n):
            for k in range(j + 1, n):
                if abs(arr[j] - arr[k]) <= b:
                    lj, rj = arr[j] - a, arr[j] + a
                    lk, rk = arr[k] - c, arr[k] + c
                    l = max(0, lj, lk)
                    r = min(1000, rj, rk)
                    if l <= r:
                        ans += total[r] if l == 0 else total[r] - total[l - 1]
            for k in range(arr[j], 1001):
                total[k] += 1
        
        return ans
```

**复杂度分析**

+ 时间复杂度：$O(n^2+nS)$，其中 $n$ 是数组 $\textit{arr}$ 的长度，$S$ 为数组的值域上限，这里为 $1000$。

+ 空间复杂度：$O(S)$。我们需要 $O(S)$ 的空间维护 $\rm arr[i]$ 频次数组的前缀和。
## [976.三角形的最大周长 中文官方题解](https://leetcode.cn/problems/largest-perimeter-triangle/solutions/100000/san-jiao-xing-de-zui-da-zhou-chang-by-leetcode-sol)
#### 方法一：贪心 + 排序

不失一般性，我们假设三角形的边长 $a,b,c$ 满足 $a \leq b \leq c$，那么这三条边组成面积不为零的三角形的充分必要条件为 $a+b>c$。

基于此，我们可以选择枚举三角形的最长边 $c$，而从贪心的角度考虑，我们一定是选「小于 $c$ 的最大的两个数」作为边长 $a$ 和 $b$，此时最有可能满足 $a+b>c$，使得三条边能够组成一个三角形，且此时的三角形的周长是最大的。

因此，我们先对整个数组排序，**倒序枚举**第 $i$ 个数作为最长边，那么我们只要看其前两个数 $A[i-2]$ 和 $A[i-1]$，判断 $A[i-2]+A[i-1]$ 是否大于 $A[i]$ 即可，如果能组成三角形我们就找到了最大周长的三角形，返回答案 $A[i-2]+A[i-1]+A[i]$ 即可。如果对于任何数作为最长边都不存在面积不为零的三角形，则返回答案 $0$。

```Java [sol1-Java]
class Solution {
    public int largestPerimeter(int[] A) {
        Arrays.sort(A);
        for (int i = A.length - 1; i >= 2; --i) {
            if (A[i - 2] + A[i - 1] > A[i]) {
                return A[i - 2] + A[i - 1] + A[i];
            }
        }
        return 0;
    }
}
```

```C++ [sol1-C++]
class Solution {
public:
    int largestPerimeter(vector<int>& A) {
        sort(A.begin(), A.end());
        for (int i = (int)A.size() - 1; i >= 2; --i) {
            if (A[i - 2] + A[i - 1] > A[i]) {
                return A[i - 2] + A[i - 1] + A[i];
            }
        }
        return 0;
    }
};
```

```JavaScript [sol1-JavaScript]
var largestPerimeter = function(A) {
    A.sort((a, b) => a - b);
    for (let i = A.length - 1; i >= 2; --i) {
        if (A[i - 2] + A[i - 1] > A[i]) {
            return A[i - 2] + A[i - 1] + A[i];
        }
    }
    return 0;
};
```

```Golang [sol1-Golang]
func largestPerimeter(a []int) int {
    sort.Ints(a)
    for i := len(a) - 1; i >= 2; i-- {
        if a[i-2]+a[i-1] > a[i] {
            return a[i-2] + a[i-1] + a[i]
        }
    }
    return 0
}
```

```C [sol1-C]
int cmp(void *_a, void *_b) {
    int a = *(int *)_a, b = *(int *)_b;
    return a - b;
}

int largestPerimeter(int *A, int ASize) {
    qsort(A, ASize, sizeof(int), cmp);
    for (int i = ASize - 1; i >= 2; --i) {
        if (A[i - 2] + A[i - 1] > A[i]) {
            return A[i - 2] + A[i - 1] + A[i];
        }
    }
    return 0;
}
```

**复杂度分析**

* 时间复杂度：$O(N \log N)$，其中 $N$ 是数组 $A$ 的长度。

* 空间复杂度：$\Omega(\log N)$。
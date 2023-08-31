## [769.最多能完成排序的块 中文官方题解](https://leetcode.cn/problems/max-chunks-to-make-sorted/solutions/100000/zui-duo-neng-wan-cheng-pai-xu-de-kuai-by-gc4k)

#### 方法一：贪心

根据题意我们可以得到以下两个定理：

+ 定理一：对于某个块 $A$，它由块 $B$ 和块 $C$ 组成，即 $A = B + C$。如果块 $B$ 和块 $C$ 分别排序后都与原数组排序后的结果一致，那么块 $A$ 排序后与原数组排序后的结果一致。

> 证明：因为块 $B$ 和块 $C$ 分别排序后都与原数组排序后的结果一致，所以块 $B$ 的元素和块 $C$ 的元素的并集为原数组排序后在对应区间的所有元素。而 $A = B + C$，因此将块 $A$ 排序后与原数组排序后的结果一致。

+ 定理二：对于某个块 $A$，它由块 $B$ 和块 $C$ 组成，即 $A = B + C$。如果块 $A$ 和块 $B$ 分别排序后都与原数组排序后的结果一致，那么块 $C$ 排序后与原数组排序后的结果一致。

> 证明：如果块 $C$ 排序后与原数组排序后的结果不一致，那么块 $B$ 的元素和块 $C$ 的元素的并集不等同于原数组排序后在对应区间的所有元素。而块 $A$ 排序后与原数组排序后的结果一致，说明块 $A$ 的元素等同于原数组排序后在对应区间的所有元素。这与块 $A$ 的元素由块 $B$ 的元素和 块 $C$ 的元素组成矛盾，因此块 $C$ 排序后与原数组排序后的结果一致。

假设数组 $\textit{arr}$ 一种分割方案为：$[a_0, a_{i_1}], [a_{i_1+1}, a_{i_2}], \ldots, [a_{i_m+1}, a_{n-1}]$，那么由定理一可知 $[a_0, a_{i_1}], [a_0, a_{i_2}], \ldots, [a_0, a_{n-1}]$ 分别排序后与原数组排序后的结果一致。反之如果 $[a_0, a_{i_1}], [a_0, a_{i_2}], \ldots, [a_0, a_{n-1}]$ 分别排序后与原数组排序后的结果一致，那么由定理二可知 $[a_0, a_{i_1}], [a_{i_1+1}, a_{i_2}], \ldots, [a_{i_m+1}, a_{n-1}]$ 是数组 $\textit{arr}$ 一种分割块方案。

因此我们只需要找到 $[a_0, a_{i_1}], [a_0, a_{i_2}], \ldots, [a_0, a_{n-1}]$ 的最大数目，就能找到最大分割块数目。因为数组 $\textit{arr}$ 的元素在区间 $[0, n - 1]$ 之间且互不相同，所以数组排序后有 $\textit{arr}[i] = i$。如果数组 $\textit{arr}$ 的某个长为 $i+1$ 的前缀块 $[a_0, a_i]$ 的最大值等于 $i$，那么说明它排序后与原数组排序后的结果一致。统计这些前缀块的数目，就可以得到最大分割块数目。

```Python [sol1-Python3]
class Solution:
    def maxChunksToSorted(self, arr: List[int]) -> int:
        ans = mx = 0
        for i, x in enumerate(arr):
            mx = max(mx, x)
            ans += mx == i
        return ans
```

```C++ [sol1-C++]
class Solution {
public:
    int maxChunksToSorted(vector<int>& arr) {
        int m = 0, res = 0;
        for (int i = 0; i < arr.size(); i++) {
            m = max(m, arr[i]);
            if (m == i) {
                res++;
            }
        }
        return res;
    }
};
```

```Java [sol1-Java]
class Solution {
    public int maxChunksToSorted(int[] arr) {
        int m = 0, res = 0;
        for (int i = 0; i < arr.length; i++) {
            m = Math.max(m, arr[i]);
            if (m == i) {
                res++;
            }
        }
        return res;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int MaxChunksToSorted(int[] arr) {
        int m = 0, res = 0;
        for (int i = 0; i < arr.Length; i++) {
            m = Math.Max(m, arr[i]);
            if (m == i) {
                res++;
            }
        }
        return res;
    }
}
```

```C [sol1-C]
#define MAX(a, b) ((a) > (b) ? (a) : (b))

int maxChunksToSorted(int* arr, int arrSize) {
    int m = 0, res = 0;
    for (int i = 0; i < arrSize; i++) {
        m = MAX(m, arr[i]);
        if (m == i) {
            res++;
        }
    }
    return res;
}
```

```go [sol1-Golang]
func maxChunksToSorted(arr []int) (ans int) {
    mx := 0
    for i, x := range arr {
        if x > mx {
            mx = x
        }
        if mx == i {
            ans++
        }
    }
    return
}
```

```JavaScript [sol1-JavaScript]
var maxChunksToSorted = function(arr) {
    let m = 0, res = 0;
    for (let i = 0; i < arr.length; i++) {
        m = Math.max(m, arr[i]);
        if (m === i) {
            res++;
        }
    }
    return res;
};
```

**复杂度分析**

+ 时间复杂度：$O(n)$，其中 $n$ 是数组 $\textit{arr}$ 的长度。

+ 空间复杂度：$O(1)$。
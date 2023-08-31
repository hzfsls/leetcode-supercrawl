## [1562.查找大小为 M 的最新分组 中文官方题解](https://leetcode.cn/problems/find-latest-group-of-size-m/solutions/100000/cha-zhao-da-xiao-wei-m-de-zui-xin-fen-zu-by-leetco)

#### 方法一：模拟

**思路与算法**

首先，我们考虑维护一个与原数组等大的数组 $\textit{endpoints}$，其中 $\textit{endpoints}[i]$ 表示数组中包含位置 $i$ 的连续 $1$ 的分组的起点和终点。如果 $\textit{arr}[i]$ 为 $0$，则记起点和终点均为 $-1$。

例如，如果数组当前的取值为 $[0, 1, 1, 1, 0, 1, 1]$，则数组 $\textit{endpoints}$ 的取值为：

$$
[(-1, -1), (2, 4), (2, 4), (2, 4), (-1, -1), (6, 7), (6,7)]
$$

注意本题中数组下标是从 $1$ 开始的。

起始时，数组 $\textit{arr}$ 的值都为 $0$。随后当进行每一步操作时，如果该步骤为将 $\textit{arr}[i]$ 的值设为 $1$，则有以下三种情况：
- 如果 $\textit{arr}[i]$ 的左右两个相邻元素（如果有）的值均为 $-1$，则此时生成了一个新的长度为 $1$ 的分组；
- 如果左右两个相邻元素（如果有）的之一的取值为 $1$，则此时会生成一个新的分组，该分组取代了已有的某个分组，其长度为该已有分组的长度加 $1$；
- 如果左右两个相邻元素的取值都为 $1$，则此时会将左右两个分组合并成一个新的分组，新分组的长度为两个分组的长度之和再加上 $1$。同时，原本的两个分组会随之消失。

在每种情况下，我们都会修改数组 $\textit{endpoints}$。不过对于一个新生成的分组，我们无需修改其中每个位置的取值：只需修改该分组左右端点处的取值即可。这是因为，在进行每一步操作时，都不会在一个已有的分组内部做修改，只会考虑已有分组的端点处的取值。

与此同时，我们也需要统计长度为 $m$ 的分组数量。如果进行完第 $i$ 次操作后，长度为 $m$ 的分组数量大于 $0$，则更新返回值为 $i$。遍历结束后，就能得到答案。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    int findLatestStep(vector<int>& arr, int m) {
        int n = arr.size();
        vector<pair<int, int>> endpoints(n + 1, make_pair(-1, -1));
        int cnt = 0;
        int ret = -1;

        for (int i = 0; i < n; i++) {
            int left = arr[i], right = arr[i];
            if (arr[i] > 1 && endpoints[arr[i] - 1].first != -1) {
                left = endpoints[arr[i] - 1].first;
                int leftLength = endpoints[arr[i] - 1].second - endpoints[arr[i] - 1].first + 1;
                if (leftLength == m) {
                    cnt--;
                }
            }
            if (arr[i] < n && endpoints[arr[i] + 1].second != -1) {
                right = endpoints[arr[i] + 1].second;
                int rightLength = endpoints[arr[i] + 1].second - endpoints[arr[i] + 1].first + 1;
                if (rightLength == m) {
                    cnt--;
                }
            }
            int length = right - left + 1;
            if (length == m) {
                cnt++;
            }
            if (cnt > 0) {
                ret = i + 1;
            }
            endpoints[left] = endpoints[right] = make_pair(left, right);
        }
        return ret;
    }
};
```

```Java [sol1-Java]
class Solution {
    public int findLatestStep(int[] arr, int m) {
        int n = arr.length;
        int[][] endpoints = new int[n + 1][2];
        for (int i = 0; i <= n; i++) {
            Arrays.fill(endpoints[i], -1);
        }
        int cnt = 0;
        int ret = -1;

        for (int i = 0; i < n; i++) {
            int left = arr[i], right = arr[i];
            if (arr[i] > 1 && endpoints[arr[i] - 1][0] != -1) {
                left = endpoints[arr[i] - 1][0];
                int leftLength = endpoints[arr[i] - 1][1] - endpoints[arr[i] - 1][0] + 1;
                if (leftLength == m) {
                    cnt--;
                }
            }
            if (arr[i] < n && endpoints[arr[i] + 1][1] != -1) {
                right = endpoints[arr[i] + 1][1];
                int rightLength = endpoints[arr[i] + 1][1] - endpoints[arr[i] + 1][0] + 1;
                if (rightLength == m) {
                    cnt--;
                }
            }
            int length = right - left + 1;
            if (length == m) {
                cnt++;
            }
            if (cnt > 0) {
                ret = i + 1;
            }
            endpoints[left][0] = endpoints[right][0] = left;
            endpoints[left][1] = endpoints[right][1] = right;
        }
        return ret;
    }
}
```

```Python [sol1-Python3]
class Solution:
    def findLatestStep(self, arr: List[int], m: int) -> int:
        n = len(arr)
        endpoints = [(-1, -1) for _ in range(n + 1)]
        cnt = 0
        ret = -1

        for i in range(n):
            left = right = arr[i]
            if arr[i] > 1 and endpoints[arr[i] - 1][0] != -1:
                left = endpoints[arr[i] - 1][0]
                leftLength = endpoints[arr[i] - 1][1] - endpoints[arr[i] - 1][0] + 1;
                if leftLength == m:
                    cnt -= 1
            if arr[i] < n and endpoints[arr[i] + 1][1] != -1:
                right = endpoints[arr[i] + 1][1]
                rightLength = endpoints[arr[i] + 1][1] - endpoints[arr[i] + 1][0] + 1;
                if rightLength == m:
                    cnt -= 1
            
            length = right - left + 1
            if length == m:
                cnt += 1
            if cnt > 0:
                ret = i + 1
            endpoints[left] = endpoints[right] = (left, right)

        return ret
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 为数组的长度。在处理每个步骤的时候，我们仅访问了左右两个相邻元素的取值，也仅修改了新分组左右端点处的取值，因此每个步骤的耗时都是 $O(1)$ 的。

- 空间复杂度：$O(n)$。我们需要开辟一个与原数组长度相同的数组 $\textit{endpoints}$。
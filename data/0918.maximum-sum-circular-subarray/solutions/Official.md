#### 方法一：动态规划

**思路与算法**

本题为「[53. 最大子数组和](https://leetcode.cn/problems/maximum-subarray/description/)」的进阶版，建议读者先完成该题之后，再尝试解决本题。

求解普通数组的最大子数组和是求解环形数组的最大子数组和问题的子集。设数组长度为 $n$，下标从 $0$ 开始，在环形情况中，答案可能包括以下两种情况：

1. 构成最大子数组和的子数组为 $\textit{nums}[i:j]$，包括 $\textit{nums}[i]$ 到 $\textit{nums}[j - 1]$ 共 $j - i$ 个元素，其中 $0 \le i \lt j \le n$。
2. 构成最大子数组和的子数组为 $\textit{nums}[0:i]$ 和 $\textit{nums}[j:n]$，其中 $0 \lt i \lt j \lt n$。

![pic2](https://assets.leetcode-cn.com/solution-static/918/918_2.png)

第一种情况的求解方法与求解普通数组的最大子数组和方法完全相同，读者可以参考 $53$ 号题目的题解：[最大子序和](https://leetcode.cn/problems/maximum-subarray/solutions/228009/zui-da-zi-xu-he-by-leetcode-solution/)。

第二种情况中，答案可以分为两部分，$\textit{nums}[0:i]$ 为数组的某一前缀，$\textit{nums}[j:n]$ 为数组的某一后缀。求解时，我们可以枚举 $j$，固定 $\textit{sum}(\textit{nums}[j:n])$ 的值，然后找到右端点坐标范围在 $[0, j - 1]$ 的最大前缀和，将它们相加更新答案。

右端点坐标范围在 $[0, i]$ 的最大前缀和可以用 $\textit{leftMax}[i]$ 表示，递推方程为：

$$\textit{leftMax}[i] = \max(\textit{leftMax}[i - 1], \textit{sum}(\textit{nums}[0:i+1])$$

![pic3](https://assets.leetcode-cn.com/solution-static/918/918_3.png)

至此，我们可以使用以上方法求解出环形数组的最大子数组和。特别需要注意的是，本题要求子数组不能为空，我们需要在代码中做出相应的调整。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    int maxSubarraySumCircular(vector<int>& nums) {
        int n = nums.size();
        vector<int> leftMax(n);
        // 对坐标为 0 处的元素单独处理，避免考虑子数组为空的情况
        leftMax[0] = nums[0];
        int leftSum = nums[0];
        int pre = nums[0];
        int res = nums[0];
        for (int i = 1; i < n; i++) {
            pre = max(pre + nums[i], nums[i]);
            res = max(res, pre);
            leftSum += nums[i];
            leftMax[i] = max(leftMax[i - 1], leftSum);
        }

        // 从右到左枚举后缀，固定后缀，选择最大前缀
        int rightSum = 0;
        for (int i = n - 1; i > 0; i--) {
            rightSum += nums[i];
            res = max(res, rightSum + leftMax[i - 1]);
        }
        return res;
    }
};
```

```Java [sol1-Java]
class Solution {
    public int maxSubarraySumCircular(int[] nums) {
        int n = nums.length;
        int[] leftMax = new int[n];
        // 对坐标为 0 处的元素单独处理，避免考虑子数组为空的情况
        leftMax[0] = nums[0];
        int leftSum = nums[0];
        int pre = nums[0];
        int res = nums[0];
        for (int i = 1; i < n; i++) {
            pre = Math.max(pre + nums[i], nums[i]);
            res = Math.max(res, pre);
            leftSum += nums[i];
            leftMax[i] = Math.max(leftMax[i - 1], leftSum);
        }

        // 从右到左枚举后缀，固定后缀，选择最大前缀
        int rightSum = 0;
        for (int i = n - 1; i > 0; i--) {
            rightSum += nums[i];
            res = Math.max(res, rightSum + leftMax[i - 1]);
        }
        return res;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int MaxSubarraySumCircular(int[] nums) {
        int n = nums.Length;
        int[] leftMax = new int[n];
        // 对坐标为 0 处的元素单独处理，避免考虑子数组为空的情况
        leftMax[0] = nums[0];
        int leftSum = nums[0];
        int pre = nums[0];
        int res = nums[0];
        for (int i = 1; i < n; i++) {
            pre = Math.Max(pre + nums[i], nums[i]);
            res = Math.Max(res, pre);
            leftSum += nums[i];
            leftMax[i] = Math.Max(leftMax[i - 1], leftSum);
        }

        // 从右到左枚举后缀，固定后缀，选择最大前缀
        int rightSum = 0;
        for (int i = n - 1; i > 0; i--) {
            rightSum += nums[i];
            res = Math.Max(res, rightSum + leftMax[i - 1]);
        }
        return res;
    }
}
```

```C [sol1-C]
int maxSubarraySumCircular(int* nums, int numsSize) {
    int n = numsSize;
    int leftMax[n];
    // 对坐标为 0 处的元素单独处理，避免考虑子数组为空的情况
    leftMax[0] = nums[0];
    int leftSum = nums[0];
    int pre = nums[0];
    int res = nums[0];
    for (int i = 1; i < n; i++) {
        pre = fmax(pre + nums[i], nums[i]);
        res = fmax(res, pre);
        leftSum += nums[i];
        leftMax[i] = fmax(leftMax[i - 1], leftSum);
    }

    // 从右到左枚举后缀，固定后缀，选择最大前缀
    int rightSum = 0;
    for (int i = n - 1; i > 0; i--) {
        rightSum += nums[i];
        res = fmax(res, rightSum + leftMax[i - 1]);
    }
    return res;
}
```

```Python [sol1-Python3]
class Solution:
    def maxSubarraySumCircular(self, nums: List[int]) -> int:
        n = len(nums)
        leftMax = [0] * n
        # 对坐标为 0 处的元素单独处理，避免考虑子数组为空的情况
        leftMax[0], leftSum = nums[0], nums[0] 
        pre, res = nums[0], nums[0]
        for i in range(1, n):
            pre = max(pre + nums[i], nums[i])
            res = max(res, pre)
            leftSum += nums[i]
            leftMax[i] = max(leftMax[i - 1], leftSum)
        # 从右到左枚举后缀，固定后缀，选择最大前缀
        rightSum = 0
        for i in range(n - 1, 0, -1):
            rightSum += nums[i]
            res = max(res, rightSum + leftMax[i - 1])
        return res
```

```Go [sol1-Go]
func maxSubarraySumCircular(nums []int) int {
    n := len(nums)
    leftMax := make([]int, n)
    // 对坐标为 0 处的元素单独处理，避免考虑子数组为空的情况
    leftMax[0] = nums[0]
    leftSum, pre, res := nums[0], nums[0], nums[0]
    for i := 1; i < n; i++ {
        pre = max(pre + nums[i], nums[i])
        res = max(res, pre)
        leftSum += nums[i]
        leftMax[i] = max(leftMax[i - 1], leftSum)
    }        
    // 从右到左枚举后缀，固定后缀，选择最大前缀
    rightSum := 0
    for i := n - 1; i > 0; i-- {
        rightSum += nums[i]
        res = max(res, rightSum + leftMax[i - 1])
    }             
    return res
}

func max(a, b int) int {
    if a > b {
        return a
    }; 
    return b
}

func min(a, b int) int {
    if a < b {
        return a
    }; 
    return b
}
```

```JavaScript [sol1-JavaScript]
var maxSubarraySumCircular = function(nums) {
    let n = nums.length;
    const leftMax = new Array(n).fill(0);
    // 对坐标为 0 处的元素单独处理，避免考虑子数组为空的情况
    leftMax[0] = nums[0];
    let leftSum = nums[0];
    let pre = nums[0];
    let res = nums[0];
    for (let i = 1; i < n; i++) {
        pre = Math.max(pre + nums[i], nums[i]);
        res = Math.max(res, pre);
        leftSum += nums[i];
        leftMax[i] = Math.max(leftMax[i - 1], leftSum);
    }

    // 从右到左枚举后缀，固定后缀，选择最大前缀
    let rightSum = 0;
    for (let i = n - 1; i > 0; i--) {
        rightSum += nums[i];
        res = Math.max(res, rightSum + leftMax[i - 1]);
    }
    return res;
};
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 是 $\textit{nums}$ 的长度。求解第一种情况的时间复杂度为 $O(n)$，求解 $\textit{leftMax}$ 数组和枚举后缀的时间复杂度为 $O(n)$，因此总的时间复杂度为 $O(n)$。

- 空间复杂度：$O(n)$，其中 $n$ 是 $\textit{nums}$ 的长度。过程中我们使用 $\textit{leftMax}$ 来存放最大前缀和。

#### 方法二：取反

**思路与算法**

对于第二种情况，即环形数组的最大子数组和为 $\textit{nums}[0:i]$ 和 $\textit{nums}[j:n]$，我们可以找到普通数组最小的子数组 $\textit{nums}[i:j]$ 即可。而求解普通数组最小子数组和的方法与求解最大子数组和的方法完全相同。

令 $\textit{maxRes}$ 是普通数组的最大子数组和，$\textit{minRes}$ 是普通数组的最小子数组和，我们可以将 $\textit{maxRes}$ 与 $\sum_{i=0}^n \textit{nums}[i] - \textit{minRes}$ 取最大作为答案。

需要注意的是，如果 $\textit{maxRes} \lt 0$，数组中不包含大于等于 $0$ 的元素，$\textit{minRes}$ 将包括数组中的所有元素，导致我们实际取到的子数组为空。在这种情况下，我们只能取 $\textit{maxRes}$ 作为答案。

**代码**

```C++ [sol2-C++]
class Solution {
public:
    int maxSubarraySumCircular(vector<int>& nums) {
        int n = nums.size();
        int preMax = nums[0], maxRes = nums[0];
        int preMin = nums[0], minRes = nums[0];
        int sum = nums[0];
        for (int i = 1; i < n; i++) {
            preMax = max(preMax + nums[i], nums[i]);
            maxRes = max(maxRes, preMax);
            preMin = min(preMin + nums[i], nums[i]);
            minRes = min(minRes, preMin);
            sum += nums[i];
        }
        if (maxRes < 0) {
            return maxRes;
        } else {
            return max(maxRes, sum - minRes);
        }
    }
};
```

```Java [sol2-Java]
class Solution {
    public int maxSubarraySumCircular(int[] nums) {
        int n = nums.length;
        int preMax = nums[0], maxRes = nums[0];
        int preMin = nums[0], minRes = nums[0];
        int sum = nums[0];
        for (int i = 1; i < n; i++) {
            preMax = Math.max(preMax + nums[i], nums[i]);
            maxRes = Math.max(maxRes, preMax);
            preMin = Math.min(preMin + nums[i], nums[i]);
            minRes = Math.min(minRes, preMin);
            sum += nums[i];
        }
        if (maxRes < 0) {
            return maxRes;
        } else {
            return Math.max(maxRes, sum - minRes);
        }
    }
}
```

```C# [sol2-C#]
public class Solution {
    public int MaxSubarraySumCircular(int[] nums) {
        int n = nums.Length;
        int preMax = nums[0], maxRes = nums[0];
        int preMin = nums[0], minRes = nums[0];
        int sum = nums[0];
        for (int i = 1; i < n; i++) {
            preMax = Math.Max(preMax + nums[i], nums[i]);
            maxRes = Math.Max(maxRes, preMax);
            preMin = Math.Min(preMin + nums[i], nums[i]);
            minRes = Math.Min(minRes, preMin);
            sum += nums[i];
        }
        if (maxRes < 0) {
            return maxRes;
        } else {
            return Math.Max(maxRes, sum - minRes);
        }
    }
}
```

```C [sol2-C]
int maxSubarraySumCircular(int* nums, int numsSize) {
    int preMax = nums[0], maxRes = nums[0];
    int preMin = nums[0], minRes = nums[0];
    int sum = nums[0];
    for (int i = 1; i < numsSize; i++) {
        preMax = fmax(preMax + nums[i], nums[i]);
        maxRes = fmax(maxRes, preMax);
        preMin = fmin(preMin + nums[i], nums[i]);
        minRes = fmin(minRes, preMin);
        sum += nums[i];
    }
    if (maxRes < 0) {
        return maxRes;
    } else {
        return fmax(maxRes, sum - minRes);
    }
}
```

```Python [sol2-Python3]
class Solution:
    def maxSubarraySumCircular(self, nums: List[int]) -> int:
        n = len(nums)
        preMax, maxRes = nums[0], nums[0]
        preMin, minRes = nums[0], nums[0]
        sum = nums[0]
        for i in range(1, n):
            preMax = max(preMax + nums[i], nums[i])
            maxRes = max(maxRes, preMax)
            preMin = min(preMin + nums[i], nums[i])
            minRes = min(minRes, preMin)
            sum += nums[i]
        if maxRes < 0:
            return maxRes
        else:
            return max(maxRes, sum - minRes)

```

```Go [sol2-Go]
func maxSubarraySumCircular(nums []int) int {
    n := len(nums)
    preMax, maxRes := nums[0], nums[0]
    preMin, minRes := nums[0], nums[0]
    sum := nums[0]
    for i := 1; i < n; i++ {
        preMax = max(preMax + nums[i], nums[i])
        maxRes = max(maxRes, preMax)
        preMin = min(preMin + nums[i], nums[i])
        minRes = min(minRes, preMin)
        sum += nums[i]
    }
    if maxRes < 0 {
        return maxRes
    } else {
        return max(maxRes, sum - minRes)
    }
}

func max(a, b int) int {
    if a > b {
        return a
    }; 
    return b
}

func min(a, b int) int {
    if a < b {
        return a
    }; 
    return b
}
```

```JavaScript [sol2-JavaScript]
var maxSubarraySumCircular = function(nums) {
    const n = nums.length;
    let preMax = nums[0], maxRes = nums[0];
    let preMin = nums[0], minRes = nums[0];
    let sum = nums[0];
    for (let i = 1; i < n; i++) {
        preMax = Math.max(preMax + nums[i], nums[i]);
        maxRes = Math.max(maxRes, preMax);
        preMin = Math.min(preMin + nums[i], nums[i]);
        minRes = Math.min(minRes, preMin);
        sum += nums[i];
    }
    if (maxRes < 0) {
        return maxRes;
    } else {
        return Math.max(maxRes, sum - minRes);
    }
};
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 是 $\textit{nums}$ 的长度。

- 空间复杂度：$O(1)$。过程中只是用到了常数个变量。

#### 方法三：单调队列

**思路与算法**

我们可以将数组延长一倍，即对于 $i \ge n$ 的元素，令 $\textit{nums}[i] = \textit{nums}[i - n]$。

然后，对于第二种情况，$\textit{nums}[0:i]$ 和 $\textit{nums}[j:n]$ 可以组成成连续的一段：

![pic1](https://assets.leetcode-cn.com/solution-static/918/918_1.png)

因此，问题转换为了在一个长度为 $2n$ 的数组上，寻找长度不超过 $n$ 的最大子数组和。

我们令 $s_i = \sum_{i=0}^i \textit{nums}[i]$ 为前缀和，如果不规定子数组的长度，只需找到最大的 $s_i - s_j$，其中 $j \lt i$。

现在，我们只能考虑所有满足 $i - n \le j \lt i$ 的 $j$，用单调队列维护该集合。具体的：

1. 遍历到 $i$ 时，单调队列头部元素下标若小于 $i - n$，则出队。该过程一直进行，直至队列为空或者队头下标大于等于 $i - n$。
2. 取队头元素作为 $j$，计算 $s_i - s_j$，并更新答案。
3. 若队列尾部元素 $k$ 满足 $s_k \ge s_i$，则出队，该过程一直进行，直至队列为空或者条件不被满足。因为 $k \lt i$，$k$ 更容易被步骤 $1$ 剔出，并且作为被减项，$s_k$ 比 $s_i$ 更大，更不具有优势。综上 $s_i$ 要全面优于 $s_k$。

**代码**

```C++ [sol3-C++]
class Solution {
public:
    int maxSubarraySumCircular(vector<int>& nums) {
        int n = nums.size();
        deque<pair<int, int>> q;
        int pre = nums[0], res = nums[0];
        q.push_back({0, pre});
        for (int i = 1; i < 2 * n; i++) {
            while (!q.empty() && q.front().first < i - n) {
                q.pop_front();
            }
            pre += nums[i % n];
            res = max(res, pre - q.front().second);
            while (!q.empty() && q.back().second >= pre) {
                q.pop_back();
            }
            q.push_back({i, pre});
        }
        return res;
    }
};
```

```Java [sol3-Java]
class Solution {
    public int maxSubarraySumCircular(int[] nums) {
        int n = nums.length;
        Deque<int[]> queue = new ArrayDeque<int[]>();
        int pre = nums[0], res = nums[0];
        queue.offerLast(new int[]{0, pre});
        for (int i = 1; i < 2 * n; i++) {
            while (!queue.isEmpty() && queue.peekFirst()[0] < i - n) {
                queue.pollFirst();
            }
            pre += nums[i % n];
            res = Math.max(res, pre - queue.peekFirst()[1]);
            while (!queue.isEmpty() && queue.peekLast()[1] >= pre) {
                queue.pollLast();
            }
            queue.offerLast(new int[]{i, pre});
        }
        return res;
    }
}
```

```C [sol3-C]
int maxSubarraySumCircular(int* nums, int numsSize) {
    int n = numsSize;
    int deque[n * 2][2];
    int pre = nums[0], res = nums[0];
    int head = 0, tail = 0;
    deque[tail][0] = 0;
    deque[tail][1] = pre;
    tail++;
    for (int i = 1; i < 2 * n; i++) {
        while (head != tail && deque[head][0] < i - n) {
            head++;
        }
        pre += nums[i % n];
        res = fmax(res, pre - deque[head][1]);
        while (head != tail && deque[tail - 1][1] >= pre) {
            tail--;
        }
        deque[tail][0] = i;
        deque[tail][1] = pre;
        tail++;
    }
    return res;
}
```

```Python [sol3-Python3]
class Solution:
    def maxSubarraySumCircular(self, nums: List[int]) -> int:
        n = len(nums)
        q = deque()
        pre, res = nums[0], nums[0]
        q.append((0, pre))
        for i in range(1, 2 * n):
            while len(q) > 0 and q[0][0] < i - n:
                q.popleft()
            pre += nums[i % n]
            res = max(res, pre - q[0][1])
            while len(q) > 0 and q[-1][1] >= pre:
                q.pop()
            q.append((i, pre))
        return res

```

```Go [sol3-Go]
func maxSubarraySumCircular(nums []int) int {
    type pair struct{ idx, val int}
    n := len(nums)
    pre, res := nums[0], nums[0]
    q := []pair{{0, pre}}
    for i := 1; i < 2 * n; i++ {
        for len(q) > 0 && q[0].idx < i - n {
            q = q[1:]
        }
        pre += nums[i % n]
        res = max(res, pre - q[0].val)
        for len(q) > 0 && q[len(q) - 1].val >= pre {
            q = q[:len(q) - 1]
        }
        q = append(q, pair{i, pre})
    }
    return res
}

func max(a, b int) int {
    if a > b {
        return a
    }; 
    return b
}

func min(a, b int) int {
    if a < b {
        return a
    }; 
    return b
}
```

```JavaScript [sol3-JavaScript]
var maxSubarraySumCircular = function(nums) {
    const n = nums.length;
    const queue = [];
    let pre = nums[0], res = nums[0];
    queue.push([0, pre]);
    for (let i = 1; i < 2 * n; i++) {
        while (queue.length !== 0 && queue[0][0] < i - n) {
            queue.shift();
        }
        pre += nums[i % n];
        res = Math.max(res, pre - queue[0][1]);
        while (queue.length !== 0 && queue[queue.length - 1][1] >= pre) {
            queue.pop();
        }
        queue.push([i, pre]);
    }
    return res;
};
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 是 $\textit{nums}$ 的长度。我们遍历 $2n$ 个元素，每个元素最多入队出队一次，因此总的时间复杂度为 $O(n)$。

- 空间复杂度：$O(n)$，其中 $n$ 是 $\textit{nums}$ 的长度。
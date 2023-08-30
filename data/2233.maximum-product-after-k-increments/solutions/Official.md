#### 方法一：最小堆（优先队列）

**提示 $1$**

我们首先考虑简化版的问题：数组中有两个元素，我们可以执行一次增加操作，那么选择**较小**的元素进行增加操作会使得最终乘积最大。

**提示 $1$ 解释**

我们用 $x, y (x \ge y)$ 来表示两个元素，对较大元素进行操作后的乘积为 $(x + 1)y = xy + y$，而对较小元素进行操作后的乘积为 $x(y + 1) = xy + x$，两者相减有：

$$
(x + 1)y - x(y + 1) = xy + y - (xy + x) = y - x \le 0.
$$

因此选择较小的元素进行增加操作会使得最终乘积最大。

**提示 $2$**

对于一般的情况，为了使得最终数组元素乘积最大，我们需要在**每次**操作时都选择数值**最小**的元素进行增加操作。

**提示 $2$ 解释**

首先，**提示 $1$** 的结论可以很容易地推广到 $n$ 个元素，即对于 $n$ 个元素的数组，在 $k = 1$ 的情况下，选择最小的元素操作可以使得结果最大。

我们假设某一步操作没有选择数值最小的元素（记为 $\textit{opt}$）进行操作，而是选择了 $\textit{num} (\textit{num} > \textit{opt})$，那么后续可能有两种情况：

- 第一种，如果后续的某一步中选择了对 $\textit{opt}$ 进行增加操作，那么我们可以交换这两步的操作，最终数组的乘积不变；

- 第二种，如果后续没有对 $\textit{opt}$ 进行过增加操作，那么将这一次对 $\textit{num}$ 进行的增加操作换成 $\textit{opt}$，最终数组的乘积也会增大。

将上述论证**推广至每一步**可得，每次选择数值最小的元素进行操作是最优的。

**思路与算法**

根据 **提示 $1$**，每一次增加操作可以被拆分为两个部分：

- 从**当前**数组中**寻找到**最小值；

- 将该值进行修改（增加 $1$）。

假设**数组** $\textit{nums}$ 的长度为 $n$，那么单次操作的时间复杂度为 $O(n)$，无法通过本题。因此我们可以将增加操作的两个部分进行如下修改：

- 从当前数组中**记录并弹出**最小值；

- 将该值加上 $1$，并**重新添加**至数组中。

同时寻找一个可以在较好的时间复杂度下实现「查询并移除最小值」与「插入元素」的数据结构。

我们可以用一个**最小堆**实现的优先队列来维护数组 $\textit{nums}$，它可以在 $O(\log n)$ 的时间复杂度下实现「查询并移除最小值」与「插入元素」这两个操作。

接下来，我们需要进行 $k$ 次上文的增加操作，最终优先队列中的元素即为最大乘积对应数组的元素。

我们用 $\textit{res}$ 来维护取模后的最终数组的乘积，$\textit{res}$ 的初值为 $1$，我们遍历 $\textit{nums}$ 的元素，对于每一个元素，我们都将 $\textit{res}$ 乘上该数值，并对 $10^9 + 7$ 取模。最终，我们返回 $\textit{res}$ 作为答案。

**细节**

首先需要注意的是，$\texttt{C++}$ 的二叉堆默认为**最大堆**，但$\texttt{Python}$ 的二叉堆默认为**最小堆**，因此对于 $\texttt{C++}$ 等语言，我们需要自定义比较函数。

其次，在遍历元素计算乘积时，取模前的中间值有可能超过 $32$ 位有符号整数的上限，因此对于 $\texttt{C++}$ 等语言，我们需要转化为 $64$ 位整数再进行计算。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    int maximumProduct(vector<int>& nums, int k) {
        int mod = 1000000007;
        make_heap(nums.begin(), nums.end(), greater<int>());   // 建立最小堆
        while (k--){
            // 每次操作：弹出最小值，增加 1 并重新添加
            pop_heap(nums.begin(), nums.end(), greater<int>());
            ++nums.back();
            push_heap(nums.begin(), nums.end(), greater<int>());
        }
        int res = 1;
        for (int num: nums) {
            res = (long long) num * res % mod;
        }
        return res;
    }
};
```


```Python [sol1-Python3]
class Solution:
    def maximumProduct(self, nums: List[int], k: int) -> int:
        mod = 10 ** 9 + 7
        heapq.heapify(nums)   # 建立最小堆
        while k:
            k -= 1
            # 每次操作：弹出最小值，增加 1 并重新添加
            num = heapq.heappop(nums)
            heapq.heappush(nums, num + 1)
        res = 1
        for num in nums:
            res *= num
            res %= mod
        return res
```


**复杂度分析**

- 时间复杂度：$O(n + k\log n)$，其中 $n$ 为 $\textit{nums}$ 的长度。建堆的复杂度为 $O(n)$；每次弹出最小值与添加新值的时间复杂度为 $O(\log n)$，共需进行 $k$ 次。

- 空间复杂度：$O(1)$。


#### 方法二：数学

**思路与算法**

对于 $k$ 较大的情况下，模拟每次增加操作会贡献较大的时间复杂度，因此我们可以对于「计算最终数组元素」的操作进行一定的简化。

我们首先将数组按照元素数值升序排序，随后从左到右遍历每一个元素，并尝试更新数组元素，并更新当前的**剩余操作次数** $k$。

具体而言，当遍历至下标为 $i$ 的元素时，此时下标闭区间 $[0, i]$ 的元素的数值均为 $\textit{nums}[i]$。我们需要判断剩余次数是否能够让这些元素**全部增加**至 $\textit{nums}[i + 1]$，即比较 $k$ 与所需次数 $\textit{tmp} = (i + 1) \times (\textit{nums}[i + 1] - \textit{nums}[i])$ 的大小。此时有两种情况：

- $k \ge \textit{tmp}$，此时说明可以将这些元素全部增加至 $\textit{nums}[i + 1]$，我们将 $k$ 减去 $\textit{tmp}$，并继续遍历剩余元素；

- $k < \textit{tmp}$，此时我们无法将这些元素全部增加至 $\textit{nums}[i + 1]$，我们需要计算这些元素可能达到的最终值。
  
  根据上文，我们需要将 $k$ **尽可能均匀分配**给这 $i + 1$ 个元素。因此，我们将 $k$ 对 $i + 1$ 做带余除法，对应得到商数 $d$ 和余数 $m$。这说明这些元素中有 $m$ 个数的最终数值为 $\textit{nums}[i] + d + 1$，其余为 $\textit{nums}[i] + d$。我们遍历这些元素并更新对应的元素数值，然后结束遍历过程。

最终，我们可以得到更新完成的 $\textit{nums}$ 数组，我们可以类似地计算数组的取模乘积并返回。

**细节**

在 $k$ 足够大的时候，有可能出现所有元素都会被更新的情况。为了避免对于边界条件的过多讨论，我们可以在排序后的数组尾部添加一个**足够大**的元素。该元素至少需要**大于最终数组所有元素的最小值**。同时，在计算取模乘积时，我们需要将该元素**弹出**或**跳过**计算该元素。

其次，在遍历元素时，$\textit{tmp}$ 有可能超过 $32$ 位有符号整数的上限，因此对于 $\texttt{C++}$ 等语言，我们需要用 $64$ 位整数存储该数值。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    int maximumProduct(vector<int>& nums, int k) {
        int mod = 1000000007;
        sort(nums.begin(), nums.end());
        int n = nums.size();
        nums.push_back(INT_MAX);
        // 遍历数组，优化模拟更新的过程
        for (int i = 0; i < n; ++i) {
            // 判断是否可以将数组下标 [0, i] 的元素更新为 nums[i+1]
            long long tmp = (long long) (i + 1) * (nums[i+1] - nums[i]);
            if (k >= tmp) {
                // 可以，则更新剩余的操作次数
                k -= tmp;
                continue;
            }
            // 不可以，则计算最终数组的元素
            int d = k / (i + 1);
            int m = k % (i + 1);
            for (int j = 0; j <= i; ++j) {
                nums[j] = nums[i] + d;
                if (j < m) {
                    ++nums[j];
                }
            }
            break;
        }
        nums.pop_back();
        int res = 1;
        for (int num: nums) {
            res = (long long) num * res % mod;
        }
        return res;
    }
};
```


```Python [sol1-Python3]
class Solution:
    def maximumProduct(self, nums: List[int], k: int) -> int:
        mod = 10 ** 9 + 7
        nums.sort()
        n = len(nums)
        nums.append(float("INF"))
        # 遍历数组，优化模拟更新的过程
        for i in range(n):
            # 判断是否可以将数组下标 [0, i] 的元素更新为 nums[i+1]
            tmp = (i + 1) * (nums[i+1] - nums[i])
            if k >= tmp:
                # 可以，则更新剩余的操作次数
                k -= tmp
                continue
            # 不可以，则计算最终数组的元素
            d = k // (i + 1)
            m = k % (i + 1)
            for j in range(i + 1):
                nums[j] = nums[i] + d
                if j < m:
                    nums[j] += 1
            break
        nums.pop()
        res = 1
        for num in nums:
            res *= num
            res %= mod
        return res
```


**复杂度分析**

- 时间复杂度：$O(n \log n)$，其中 $n$ 为 $\textit{nums}$ 的长度。其中对数组排序的时间复杂度为 $O(n \log n)$，计算最终数组的时间复杂度为 $O(n)$。

- 空间复杂度：$O(\log n)$，即为排序的栈空间复杂度。
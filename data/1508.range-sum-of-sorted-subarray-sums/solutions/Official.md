## [1508.子数组和排序后的区间和 中文官方题解](https://leetcode.cn/problems/range-sum-of-sorted-subarray-sums/solutions/100000/zi-shu-zu-he-pai-xu-hou-de-qu-jian-he-by-leetcode-)

#### 方法一：排序

对于长度为 $n$ 的数组，其中的非空连续子数组一共有 $\frac{n(n+1)}{2}$ 个，对应的子数组的和也一共有 $\frac{n(n+1)}{2}$ 个。

创建一个长度为 $\frac{n(n+1)}{2}$ 的数组 $\textit{sums}$ 存储所有的子数组的和。计算子数组的和时，将 $i$ 从 $0$ 到 $n-1$ 依次遍历，对于每个 $i$，将 $i$ 作为子数组最左侧的下标，分别计算每个子数组的和，将子数组的和存入数组 $\textit{sums}$ 中。

得到所有的子数组的和之后，对数组 $\textit{sums}$ 排序，然后计算 $\textit{sums}$ 中的指定的下标范围内的元素之和。需要注意题目中给的下标 $\textit{left}$ 和 $\textit{right}$ 是从 $1$ 开始的，因此应该计算 $\textit{sums}$ 中的下标 $\textit{left}-1$ 到下标 $\textit{right}-1$ 范围内的元素之和，并且计算元素之和的过程中需要对 $10^9+7$ 取模。

```Java [sol1-Java]
class Solution {
    public int rangeSum(int[] nums, int n, int left, int right) {
        final int MODULO = 1000000007;
        int sumsLength = n * (n + 1) / 2;
        int[] sums = new int[sumsLength];
        int index = 0;
        for (int i = 0; i < n; i++) {
            int sum = 0;
            for (int j = i; j < n; j++) {
                sum += nums[j];
                sums[index++] = sum;
            }
        }
        Arrays.sort(sums);
        int ans = 0;
        for (int i = left - 1; i < right; i++) {
            ans = (ans + sums[i]) % MODULO;
        }
        return ans;
    }
}
```

```csharp [sol1-C#]
public class Solution 
{
    public int RangeSum(int[] nums, int n, int left, int right) 
    {
        const int MODULO = 1000000007;

        int sumsLength = n * (n + 1) / 2;
        int[] sums = new int[sumsLength];
        int index = 0;
        for (int i = 0; i < n; i++) 
        {
            int sum = 0;
            for (int j = i; j < n; j++) 
            {
                sum += nums[j];
                sums[index++] = sum;
            }
        }

        Array.Sort(sums);
        int ans = 0;
        for (int i = left - 1; i < right; i++) 
        {
            ans = (ans + sums[i]) % MODULO;
        }

        return ans;
    }
}
```

```cpp [sol1-C++]
class Solution {
public:
    int rangeSum(vector<int>& nums, int n, int left, int right) {
        const int MODULO = 1000000007;
        int sumsLength = n * (n + 1) / 2;
        auto sums = vector <int> (sumsLength);
        int index = 0;
        for (int i = 0; i < n; i++) {
            int sum = 0;
            for (int j = i; j < n; j++) {
                sum += nums[j];
                sums[index++] = sum;
            }
        }
        sort(sums.begin(), sums.end());
        int ans = 0;
        for (int i = left - 1; i < right; i++) {
            ans = (ans + sums[i]) % MODULO;
        }
        return ans;
    }
};
```

```Python [sol1-Python3]
class Solution:
    def rangeSum(self, nums: List[int], n: int, left: int, right: int) -> int:
        MODULO = 10**9 + 7
        sumsLength = n * (n + 1) // 2
        sums = list()
        index = 0

        for i in range(n):
            total = 0
            for j in range(i, n):
                total += nums[j]
                sums.append(total)
        
        sums.sort()
        ans = sum(sums[left-1:right]) % MODULO
        return ans
```

**复杂度分析**

- 时间复杂度：$O(n^2 \log n)$，其中 $n$ 是数组的长度。
  长度为 $n$ 的数组有 $\frac{n(n+1)}{2}$ 个非空连续子数组，因此需要计算 $\frac{n(n+1)}{2}$ 个子数组的和，计算子数组的和的时间复杂度是 $O(n^2)$。
  得到所有的子数组的和之后需要对子数组的和进行排序，排序的时间复杂度是 $O(n^2 \log n^2)=O(2n^2 \log n)=O(n^2 \log n)$。

- 空间复杂度：$O(n^2)$，其中 $n$ 是数组的长度。需要创建一个长度为 $\frac{n(n+1)}{2}$ 的数组存储所有的子数组的和。

#### 方法二：二分查找 + 双指针

方法一中，首先计算每个连续子数组的和，然后计算区间和。其实，并不需要计算每个连续子数组的和，而是可以将问题转化成求所有的子数组的和当中的最小的 $k$ 个元素之和，对于这道题，分别计算 $k=\textit{right}$ 和 $k=\textit{left}-1$ 的结果，然后计算两者之差，即可得到区间和。

构造两个数组，第一个数组 $\textit{prefixSums}$ 存储原始数组的前缀和，第二个数组 $\textit{prefixPrefixSums}$ 存储第一个数组的前缀和。

要求出所有的子数组的和当中的最小的 $k$ 个元素之和，首先需要得到第 $k$ 小的元素，即第 $k$ 小的子数组的和。可以通过对第一个数组使用二分查找 + 双指针的方法得到第 $k$ 小的子数组的和，其思想与「[378. 有序矩阵中第K小的元素](https://leetcode-cn.com/problems/kth-smallest-element-in-a-sorted-matrix/)」类似。

「有序矩阵中第K小的元素」使用双指针在每行和每列元素均按升序排序的二维矩阵中寻找不超过目标值的元素个数，这道题则是使用双指针借助第一个数组寻找有多少个子数组的和不超过目标值。具体做法是，对于从 $0$ 到 $n-1$ 的每个下标 $i$，找到最大的下标 $j$ 使得原始数组从下标 $i$ 到下标 $j-1$ 范围的子数组的元素之和不超过目标值（子数组的元素之和可以通过第一个数组在 $O(1)$ 的时间内计算得到结果），由于原始数组的元素都是正整数，因此对于任意从下标 $i$ 开始且长度不超过 $j-i$ 的子数组，其元素之和都不超过目标值，这样就能得到 $j-i$ 个和不超过目标值的子数组。遍历完 $i$ 的所有可能取值之后，即可知道有多少个子数组的和不超过目标值。目标值的选取则使用二分查找的方式，目标值的最终取值即为第 $k$ 小的子数组的和。

得到第 $k$ 小的子数组的和之后，即可求所有的子数组的和当中的最小的 $k$ 个值之和。令第 $k$ 小的子数组的和是 $\textit{num}$，考虑到可能有多个子数组的和都等于第 $k$ 小的子数组的和，因此分成两步计算。

第一步计算所有**严格小于** $\textit{num}$ 的子数组的和的个数以及它们的和，假设有 $\textit{count}$ 个**严格小于** $\textit{num}$ 的子数组的和，它们的和是 $\textit{sum}$，可以借助构造的两个数组，使用双指针计算得到 $\textit{count}$ 和 $\textit{sum}$ 的值。具体做法是，对于从 $0$ 到 $n-1$ 的每个下标 $i$，找到最大的下标 $j$ 使得原始数组从下标 $i$ 到下标 $j-1$ 范围的子数组的元素之和不超过 $\textit{num}$（子数组的元素之和可以通过第一个数组在 $O(1)$ 的时间内计算得到结果），由于原始数组的元素都是正整数，因此对于任意从下标 $i$ 开始且长度不超过 $j-i$ 的子数组，其元素之和都不超过目标值，这样就能得到 $j-i$ 个和不超过目标值的子数组，这些子数组的和之和计算如下：

$$
\textit{prefixPrefixSums}[j] - \textit{prefixPrefixSums}[i] - \textit{prefixSums}[i] \times (j-i)
$$

其中，$\textit{prefixPrefixSums}[j] - \textit{prefixPrefixSums}[i]$ 的结果等价于 $\textit{prefixSums}$ 从下标 $i+1$ 到下标 $j$ 范围内的所有元素之和，对于 $i+1 \le m \le j$，$\textit{prefixSums}[m]$ 表示原始数组从下标 $0$ 到下标 $m-1$ 范围内的所有元素之和，因此，$\textit{prefixPrefixSums}[j] - \textit{prefixPrefixSums}[i]$ 的结果为原始数组的 $j-i$ 个前缀之和，每个前缀的结束下标依次从 $i$ 到 $j-1$。由于只需要计算原始数组的从下标 $i$ 开始且长度不超过 $j-i$ 的子数组，因此还需要对这 $j-1$ 个前缀中的每一项减去原始数组从下标 $0$ 到下标 $i-1$ 范围内的所有元素之和才能得到对应的子数组之和，原始数组从下标 $0$ 到下标 $i-1$ 范围内的所有元素之和为 $\textit{prefixSums}[i]$，因此要减去 $\textit{prefixSums}[i] \times (j-i)$，才能得到 $j-i$ 个和不超过目标值的子数组的和之和。

遍历完 $i$ 的所有可能取值之后，即可得到所有**严格小于** $\textit{num}$ 的子数组的和的个数以及它们的和。

第二步考虑最小的 $k$ 个子数组的和当中剩下的等于 $\textit{num}$ 的子数组的和，这些子数组的和之和等于 $\textit{num} \times (k-\textit{count})$。在第一步计算得到的 $\textit{sum}$ 的基础上令 $\textit{sum}=\textit{sum}+\textit{num} \times (k-\textit{count})$，则 $\textit{sum}$ 的值即为所有的子数组的和当中的最小的 $k$ 个元素之和。

```Java [sol2-Java]
class Solution {
    static final int MODULO = 1000000007;

    public int rangeSum(int[] nums, int n, int left, int right) {
        int[] prefixSums = new int[n + 1];
        prefixSums[0] = 0;
        for (int i = 0; i < n; i++) {
            prefixSums[i + 1] = prefixSums[i] + nums[i];
        }
        int[] prefixPrefixSums = new int[n + 1];
        prefixPrefixSums[0] = 0;
        for (int i = 0; i < n; i++) {
            prefixPrefixSums[i + 1] = prefixPrefixSums[i] + prefixSums[i + 1];
        }
        return (getSum(prefixSums, prefixPrefixSums, n, right) - getSum(prefixSums, prefixPrefixSums, n, left - 1)) % MODULO;
    }

    public int getSum(int[] prefixSums, int[] prefixPrefixSums, int n, int k) {
        int num = getKth(prefixSums, n, k);
        int sum = 0;
        int count = 0;
        for (int i = 0, j = 1; i < n; i++) {
            while (j <= n && prefixSums[j] - prefixSums[i] < num) {
                j++;
            }
            j--;
            sum = (sum + prefixPrefixSums[j] - prefixPrefixSums[i] - prefixSums[i] * (j - i)) % MODULO;
            count += j - i;
        }
        sum = (sum + num * (k - count)) % MODULO;
        return sum;
    }

    public int getKth(int[] prefixSums, int n, int k) {
        int low = 0, high = prefixSums[n];
        while (low < high) {
            int mid = (high - low) / 2 + low;
            int count = getCount(prefixSums, n, mid);
            if (count < k) {
                low = mid + 1;
            } else {
                high = mid;
            }
        }
        return low;
    }

    public int getCount(int[] prefixSums, int n, int x) {
        int count = 0;
        for (int i = 0, j = 1; i < n; i++) {
            while (j <= n && prefixSums[j] - prefixSums[i] <= x) {
                j++;
            }
            j--;
            count += j - i;
        }
        return count;
    }
}
```

```csharp [sol2-C#]
public class Solution 
{
    public int RangeSum(int[] nums, int n, int left, int right) 
    {
        const int MODULO = 1000000007;
        int[] prefixSums = new int[n + 1];
        prefixSums[0] = 0;
        for (int i = 0; i < n; i++) 
        {
            prefixSums[i + 1] = prefixSums[i] + nums[i];
        }

        int[] prefixPrefixSums = new int[n + 1];
        prefixPrefixSums[0] = 0;
        for (int i = 0; i < n; i++) 
        {
            prefixPrefixSums[i + 1] = prefixPrefixSums[i] + prefixSums[i + 1];
        }

        return (GetSum(prefixSums, prefixPrefixSums, n, right) - GetSum(prefixSums, prefixPrefixSums, n, left - 1)) % MODULO;
    }

    public int GetSum(int[] prefixSums, int[] prefixPrefixSums, int n, int k) 
    {
        int num = GetKth(prefixSums, n, k);
        int sum = 0;
        int count = 0;
        for (int i = 0, j = 1; i < n; i++) 
        {
            while (j <= n && prefixSums[j] - prefixSums[i] < num) 
            {
                j++;
            }

            j--;
            sum += prefixPrefixSums[j] - prefixPrefixSums[i] - prefixSums[i] * (j - i);
            sum %= MODULO;
            count += j - i;
        }

        sum += num * (k - count);
        return sum;
    }

    public int GetKth(int[] prefixSums, int n, int k) 
    {
        int low = 0, high = prefixSums[n];
        while (low < high) 
        {
            int mid = (high - low) / 2 + low;
            int count = GetCount(prefixSums, n, mid);
            if (count < k) 
            {
                low = mid + 1;
            }
            else 
            {
                high = mid;
            }
        }
        return low;
    }

    public int GetCount(int[] prefixSums, int n, int x) 
    {
        int count = 0;
        for (int i = 0, j = 1; i < n; i++) 
        {
            while (j <= n && prefixSums[j] - prefixSums[i] <= x) 
            {
                j++;
            }

            j--;
            count += j - i;
        }
        
        return count;
    }
}
```

```cpp [sol2-C++]
class Solution {
public:
    static constexpr int MODULO = 1000000007;

    int rangeSum(vector<int>& nums, int n, int left, int right) {
        vector<int> prefixSums = vector<int>(n + 1);
        prefixSums[0] = 0;
        for (int i = 0; i < n; i++) {
            prefixSums[i + 1] = prefixSums[i] + nums[i];
        }
        vector<int> prefixPrefixSums = vector<int>(n + 1);
        prefixPrefixSums[0] = 0;
        for (int i = 0; i < n; i++) {
            prefixPrefixSums[i + 1] = prefixPrefixSums[i] + prefixSums[i + 1];
        }
        return (getSum(prefixSums, prefixPrefixSums, n, right) - getSum(prefixSums, prefixPrefixSums, n, left - 1)) % MODULO;
    }

    int getSum(vector<int>& prefixSums, vector<int>& prefixPrefixSums, int n, int k) {
        int num = getKth(prefixSums, n, k);
        int sum = 0;
        int count = 0;
        for (int i = 0, j = 1; i < n; i++) {
            while (j <= n && prefixSums[j] - prefixSums[i] < num) {
                j++;
            }
            j--;
            sum += prefixPrefixSums[j] - prefixPrefixSums[i] - prefixSums[i] * (j - i);
            sum %= MODULO;
            count += j - i;
        }
        sum += num * (k - count);
        return sum;
    }

    int getKth(vector<int>& prefixSums, int n, int k) {
        int low = 0, high = prefixSums[n];
        while (low < high) {
            int mid = (high - low) / 2 + low;
            int count = getCount(prefixSums, n, mid);
            if (count < k) {
                low = mid + 1;
            } else {
                high = mid;
            }
        }
        return low;
    }

    int getCount(vector<int>& prefixSums, int n, int x) {
        int count = 0;
        for (int i = 0, j = 1; i < n; i++) {
            while (j <= n && prefixSums[j] - prefixSums[i] <= x) {
                j++;
            }
            j--;
            count += j - i;
        }
        return count;
    }
};
```

```Python [sol2-Python3]
class Solution:
    def rangeSum(self, nums: List[int], n: int, left: int, right: int) -> int:
        MODULO = 10**9 + 7
        prefixSums = [0]
        for i in range(n):
            prefixSums.append(prefixSums[-1] + nums[i])
        
        prefixPrefixSums = [0]
        for i in range(n):
            prefixPrefixSums.append(prefixPrefixSums[-1] + prefixSums[i + 1])

        def getCount(x: int) -> int:
            count = 0
            j = 1
            for i in range(n):
                while j <= n and prefixSums[j] - prefixSums[i] <= x:
                    j += 1
                j -= 1
                count += j - i
            return count

        def getKth(k: int) -> int:
            low, high = 0, prefixSums[n]
            while low < high:
                mid = (low + high) // 2
                count = getCount(mid)
                if count < k:
                    low = mid + 1
                else:
                    high = mid
            return low

        def getSum(k: int) -> int:
            num = getKth(k)
            total, count = 0, 0
            j = 1
            for i in range(n):
                while j <= n and prefixSums[j] - prefixSums[i] < num:
                    j += 1
                j -= 1
                total += prefixPrefixSums[j] - prefixPrefixSums[i] - prefixSums[i] * (j - i)
                count += j - i
            total += num * (k - count)
            return total

        return (getSum(right) - getSum(left - 1)) % MODULO
```

**复杂度分析**

- 时间复杂度：$O(n \log S)$，其中 $n$ 是数组的长度，$S$ 是数组中的元素之和。
  时间复杂度主要取决于二分查找的部分。每次二分查找的上界是 $S$，因此迭代次数是 $O(\log S)$，每次迭代需要通过双指针进行计数，时间复杂度为 $O(n)$，因此二分查找的总时间复杂度是 $O(n \log S)$。
  除了二分查找以外，双指针操作的时间复杂度是 $O(n)$。

- 空间复杂度：$O(n)$，其中 $n$ 是数组的长度。需要创建两个长度为 $n+1$ 的数组，分别用于存储原始数组的前缀和与前缀和的前缀和。
## [740.删除并获得点数 中文官方题解](https://leetcode.cn/problems/delete-and-earn/solutions/100000/shan-chu-bing-huo-de-dian-shu-by-leetcod-x1pu)

#### 方法一：动态规划

**思路**

根据题意，在选择了元素 $x$ 后，该元素以及所有等于 $x-1$ 或 $x+1$ 的元素会从数组中删去。若还有多个值为 $x$ 的元素，由于所有等于 $x-1$ 或 $x+1$ 的元素已经被删除，我们可以直接删除 $x$ 并获得其点数。因此若选择了 $x$，所有等于 $x$ 的元素也应一同被选择，以尽可能多地获得点数。

记元素 $x$ 在数组中出现的次数为 $c_x$，我们可以用一个数组 $sum$ 记录数组 $\textit{nums}$ 中所有相同元素之和，即 $\textit{sum}[x]=x\cdot c_x$。若选择了 $x$，则可以获取 $\textit{sum}[x]$ 的点数，且无法再选择 $x-1$ 和 $x+1$。这与「[198. 打家劫舍](https://leetcode-cn.com/problems/house-robber/)」是一样的，在统计出 $\textit{sum}$ 数组后，读者可参考「[198. 打家劫舍的官方题解](https://leetcode-cn.com/problems/house-robber/solution/da-jia-jie-she-by-leetcode-solution/)」中的动态规划过程计算出答案。

**代码**

```C++ [sol1-C++]
class Solution {
private:
    int rob(vector<int> &nums) {
        int size = nums.size();
        int first = nums[0], second = max(nums[0], nums[1]);
        for (int i = 2; i < size; i++) {
            int temp = second;
            second = max(first + nums[i], second);
            first = temp;
        }
        return second;
    }

public:
    int deleteAndEarn(vector<int> &nums) {
        int maxVal = 0;
        for (int val : nums) {
            maxVal = max(maxVal, val);
        }
        vector<int> sum(maxVal + 1);
        for (int val : nums) {
            sum[val] += val;
        }
        return rob(sum);
    }
};
```

```Java [sol1-Java]
class Solution {
    public int deleteAndEarn(int[] nums) {
        int maxVal = 0;
        for (int val : nums) {
            maxVal = Math.max(maxVal, val);
        }
        int[] sum = new int[maxVal + 1];
        for (int val : nums) {
            sum[val] += val;
        }
        return rob(sum);
    }

    public int rob(int[] nums) {
        int size = nums.length;
        int first = nums[0], second = Math.max(nums[0], nums[1]);
        for (int i = 2; i < size; i++) {
            int temp = second;
            second = Math.max(first + nums[i], second);
            first = temp;
        }
        return second;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int DeleteAndEarn(int[] nums) {
        int maxVal = 0;
        foreach (int val in nums) {
            maxVal = Math.Max(maxVal, val);
        }
        int[] sum = new int[maxVal + 1];
        foreach (int val in nums) {
            sum[val] += val;
        }
        return Rob(sum);
    }

    public int Rob(int[] nums) {
        int size = nums.Length;
        int first = nums[0], second = Math.Max(nums[0], nums[1]);
        for (int i = 2; i < size; i++) {
            int temp = second;
            second = Math.Max(first + nums[i], second);
            first = temp;
        }
        return second;
    }
}
```

```go [sol1-Golang]
func deleteAndEarn(nums []int) int {
    maxVal := 0
    for _, val := range nums {
        maxVal = max(maxVal, val)
    }
    sum := make([]int, maxVal+1)
    for _, val := range nums {
        sum[val] += val
    }
    return rob(sum)
}

func rob(nums []int) int {
    first, second := nums[0], max(nums[0], nums[1])
    for i := 2; i < len(nums); i++ {
        first, second = second, max(first+nums[i], second)
    }
    return second
}

func max(a, b int) int {
    if a > b {
        return a
    }
    return b
}
```

```Python [sol1-Python3]
class Solution:
    def deleteAndEarn(self, nums: List[int]) -> int:
        maxVal = max(nums)
        total = [0] * (maxVal + 1)
        for val in nums:
            total[val] += val
        
        def rob(nums: List[int]) -> int:
            size = len(nums)
            first, second = nums[0], max(nums[0], nums[1])
            for i in range(2, size):
                first, second = second, max(first + nums[i], second)
            return second
        
        return rob(total)
```

```C [sol1-C]
int rob(int *nums, int numsSize) {
    int first = nums[0], second = fmax(nums[0], nums[1]);
    for (int i = 2; i < numsSize; i++) {
        int temp = second;
        second = fmax(first + nums[i], second);
        first = temp;
    }
    return second;
}

int deleteAndEarn(int *nums, int numsSize) {
    int maxVal = 0;
    for (int i = 0; i < numsSize; i++) {
        maxVal = fmax(maxVal, nums[i]);
    }
    int sum[maxVal + 1];
    memset(sum, 0, sizeof(sum));
    for (int i = 0; i < numsSize; i++) {
        sum[nums[i]] += nums[i];
    }
    return rob(sum, maxVal + 1);
}
```

```JavaScript [sol1-JavaScript]
var deleteAndEarn = function(nums) {
    let maxVal = 0;
    for (const val of nums) {
        maxVal = Math.max(maxVal, val);
    }
    const sum = new Array(maxVal + 1).fill(0);
    for (const val of nums) {
        sum[val] += val;
    }
    return rob(sum);
};

const rob = (nums) => {
    const size = nums.length;
    let first = nums[0], second = Math.max(nums[0], nums[1]);
    for (let i = 2; i < size; i++) {
        let temp = second;
        second = Math.max(first + nums[i], second);
        first = temp;
    }
    return second;
}
```

**复杂度分析**

- 时间复杂度：$O(N+M)$，其中 $N$ 是数组 $\textit{nums}$ 的长度，$M$ 是 $\textit{nums}$ 中元素的最大值。

- 空间复杂度：$O(M)$。

#### 方法二：排序 + 动态规划

注意到若 $\textit{nums}$ 中不存在某个元素 $x$，则选择任一小于 $x$ 的元素不会影响到大于 $x$ 的元素的选择。因此我们可以将 $\textit{nums}$ 排序后，将其划分成若干连续子数组，子数组内任意相邻元素之差不超过 $1$。对每个子数组按照方法一的动态规划过程计算出结果，累加所有结果即为答案。

**代码**

```C++ [sol2-C++]
class Solution {
private:
    int rob(vector<int> &nums) {
        int size = nums.size();
        if (size == 1) {
            return nums[0];
        }
        int first = nums[0], second = max(nums[0], nums[1]);
        for (int i = 2; i < size; i++) {
            int temp = second;
            second = max(first + nums[i], second);
            first = temp;
        }
        return second;
    }

public:
    int deleteAndEarn(vector<int> &nums) {
        int n = nums.size();
        int ans = 0;
        sort(nums.begin(), nums.end());
        vector<int> sum = {nums[0]};
        for (int i = 1; i < n; ++i) {
            int val = nums[i];
            if (val == nums[i - 1]) {
                sum.back() += val;
            } else if (val == nums[i - 1] + 1) {
                sum.push_back(val);
            } else {
                ans += rob(sum);
                sum = {val};
            }
        }
        ans += rob(sum);
        return ans;
    }
};
```

```Java [sol2-Java]
class Solution {
    public int deleteAndEarn(int[] nums) {
        int n = nums.length;
        int ans = 0;
        Arrays.sort(nums);
        List<Integer> sum = new ArrayList<Integer>();
        sum.add(nums[0]);
        int size = 1;
        for (int i = 1; i < n; ++i) {
            int val = nums[i];
            if (val == nums[i - 1]) {
                sum.set(size - 1, sum.get(size - 1) + val);
            } else if (val == nums[i - 1] + 1) {
                sum.add(val);
                ++size;
            } else {
                ans += rob(sum);
                sum.clear();
                sum.add(val);
                size = 1;
            }
        }
        ans += rob(sum);
        return ans;
    }

    public int rob(List<Integer> nums) {
        int size = nums.size();
        if (size == 1) {
            return nums.get(0);
        }
        int first = nums.get(0), second = Math.max(nums.get(0), nums.get(1));
        for (int i = 2; i < size; i++) {
            int temp = second;
            second = Math.max(first + nums.get(i), second);
            first = temp;
        }
        return second;
    }
}
```

```C# [sol2-C#]
public class Solution {
    public int DeleteAndEarn(int[] nums) {
        int n = nums.Length;
        int ans = 0;
        Array.Sort(nums);
        IList<int> sum = new List<int>();
        sum.Add(nums[0]);
        int size = 1;
        for (int i = 1; i < n; ++i) {
            int val = nums[i];
            if (val == nums[i - 1]) {
                sum[size - 1] += val;
            } else if (val == nums[i - 1] + 1) {
                sum.Add(val);
                ++size;
            } else {
                ans += Rob(sum);
                sum.Clear();
                sum.Add(val);
                size = 1;
            }
        }
        ans += Rob(sum);
        return ans;
    }

    public int Rob(IList<int> nums) {
        int size = nums.Count;
        if (size == 1) {
            return nums[0];
        }
        int first = nums[0], second = Math.Max(nums[0], nums[1]);
        for (int i = 2; i < size; i++) {
            int temp = second;
            second = Math.Max(first + nums[i], second);
            first = temp;
        }
        return second;
    }
}
```

```go [sol2-Golang]
func deleteAndEarn(nums []int) (ans int) {
    sort.Ints(nums)
    sum := []int{nums[0]}
    for i := 1; i < len(nums); i++ {
        if val := nums[i]; val == nums[i-1] {
            sum[len(sum)-1] += val
        } else if val == nums[i-1]+1 {
            sum = append(sum, val)
        } else {
            ans += rob(sum)
            sum = []int{val}
        }
    }
    ans += rob(sum)
    return
}

func rob(nums []int) int {
    if len(nums) == 1 {
        return nums[0]
    }
    first, second := nums[0], max(nums[0], nums[1])
    for i := 2; i < len(nums); i++ {
        first, second = second, max(first+nums[i], second)
    }
    return second
}

func max(a, b int) int {
    if a > b {
        return a
    }
    return b
}
```

```Python [sol2-Python3]
class Solution:
    def deleteAndEarn(self, nums: List[int]) -> int:
        def rob(nums: List[int]) -> int:
            size = len(nums)
            if size == 1:
                return nums[0]

            first, second = nums[0], max(nums[0], nums[1])
            for i in range(2, size):
                first, second = second, max(first + nums[i], second)
            return second
        
        n = len(nums)
        ans = 0
        nums.sort()
        total = [nums[0]]

        for i in range(1, n):
            val = nums[i]
            if val == nums[i - 1]:
                total[-1] += val
            elif val == nums[i - 1] + 1:
                total.append(val)
            else:
                ans += rob(total)
                total = [val]
        
        ans += rob(total)
        return ans
```

```C [sol2-C]
int rob(int *nums, int numsSize) {
    if (numsSize == 1) {
        return nums[0];
    }
    int first = nums[0], second = fmax(nums[0], nums[1]);
    for (int i = 2; i < numsSize; i++) {
        int temp = second;
        second = fmax(first + nums[i], second);
        first = temp;
    }
    return second;
}

int cmp(int *a, int *b) {
    return *a - *b;
}

int deleteAndEarn(int *nums, int numsSize) {
    int ans = 0;
    qsort(nums, numsSize, sizeof(int), cmp);
    int sum[numsSize], sumSize = 0;
    sum[sumSize++] = nums[0];
    for (int i = 1; i < numsSize; ++i) {
        int val = nums[i];
        if (val == nums[i - 1]) {
            sum[sumSize - 1] += val;
        } else if (val == nums[i - 1] + 1) {
            sum[sumSize++] = val;
        } else {
            ans += rob(sum, sumSize);
            sumSize = 0;
            sum[sumSize++] = val;
        }
    }
    ans += rob(sum, sumSize);
    return ans;
}
```

```JavaScript [sol2-JavaScript]
var deleteAndEarn = function(nums) {
    const rob = (nums) => {
        const size = nums.length;
        if (size === 1) {
            return nums[0];
        }

        let [first, second] = [nums[0], Math.max(nums[0], nums[1])];
        for (let i = 2; i < size; i++) {
            [first, second] = [second, Math.max(first + nums[i], second)];
        }
        return second;
    }

    const n = nums.length;
    let ans = 0;
    nums.sort((a, b) => a - b);
    total = [nums[0]];

    for (let i = 1; i < n; i++) {
        const val = nums[i];
        if (val === nums[i - 1]) {
            total[total.length - 1] += val;
        } else if (val === nums[i - 1] + 1) {
            total.push(val);
        } else {
            ans += rob(total);
            total = [val];
        }
    }
    ans += rob(total);
    return ans;
};
```

**复杂度分析**

- 时间复杂度：$O(N\log N)$，其中 $N$ 是数组 $\textit{nums}$ 的长度。对 $\textit{nums}$ 排序需要花费 $O(N\log N)$ 的时间，遍历计算需要花费 $O(N)$ 的时间，故总的时间复杂度为 $O(N\log N)$。

- 空间复杂度：$O(N)$。统计 $\textit{sum}$ 至多需要花费 $O(N)$ 的空间。
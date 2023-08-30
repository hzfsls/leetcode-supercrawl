#### 方法一：差分

注意到一个预订记录实际上代表了一个区间的增量。我们的任务是将这些增量叠加得到答案。因此，我们可以使用差分解决本题。

差分数组对应的概念是前缀和数组，对于数组 $[1,2,2,4]$，其差分数组为 $[1,1,0,2]$，差分数组的第 $i$ 个数即为原数组的第 $i-1$ 个元素和第 $i$ 个元素的差值，也就是说我们对差分数组求前缀和即可得到原数组。

差分数组的性质是，当我们希望对原数组的某一个区间 $[l,r]$ 施加一个增量$\textit{inc}$ 时，差分数组 $d$ 对应的改变是：$d[l]$ 增加 $\textit{inc}$，$d[r+1]$ 减少 $\textit{inc}$。这样对于区间的修改就变为了对于两个位置的修改。并且这种修改是可以叠加的，即当我们多次对原数组的不同区间施加不同的增量，我们只要按规则修改差分数组即可。

在本题中，我们可以遍历给定的预定记录数组，每次 $O(1)$ 地完成对差分数组的修改即可。当我们完成了差分数组的修改，只需要最后求出差分数组的前缀和即可得到目标数组。

注意本题中日期从 $1$ 开始，因此我们需要相应的调整数组下标对应关系，对于预定记录 $\textit{booking}=[l,r,\textit{inc}]$，我们需要让 $d[l-1]$ 增加 $\textit{inc}$，$d[r]$ 减少 $\textit{inc}$。特别地，当 $r$ 为 $n$ 时，我们无需修改 $d[r]$，因为这个位置溢出了下标范围。如果求前缀和时考虑该位置，那么该位置对应的前缀和值必定为 $0$。读者们可以自行思考原因，以加深对差分数组的理解。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    vector<int> corpFlightBookings(vector<vector<int>>& bookings, int n) {
        vector<int> nums(n);
        for (auto& booking : bookings) {
            nums[booking[0] - 1] += booking[2];
            if (booking[1] < n) {
                nums[booking[1]] -= booking[2];
            }
        }
        for (int i = 1; i < n; i++) {
            nums[i] += nums[i - 1];
        }
        return nums;
    }
};
```

```Java [sol1-Java]
class Solution {
    public int[] corpFlightBookings(int[][] bookings, int n) {
        int[] nums = new int[n];
        for (int[] booking : bookings) {
            nums[booking[0] - 1] += booking[2];
            if (booking[1] < n) {
                nums[booking[1]] -= booking[2];
            }
        }
        for (int i = 1; i < n; i++) {
            nums[i] += nums[i - 1];
        }
        return nums;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int[] CorpFlightBookings(int[][] bookings, int n) {
        int[] nums = new int[n];
        foreach (int[] booking in bookings) {
            nums[booking[0] - 1] += booking[2];
            if (booking[1] < n) {
                nums[booking[1]] -= booking[2];
            }
        }
        for (int i = 1; i < n; i++) {
            nums[i] += nums[i - 1];
        }
        return nums;
    }
}
```

```C [sol1-C]
int* corpFlightBookings(int** bookings, int bookingsSize, int* bookingsColSize, int n, int* returnSize) {
    int* nums = malloc(sizeof(int) * n);
    memset(nums, 0, sizeof(int) * n);
    *returnSize = n;
    for (int i = 0; i < bookingsSize; i++) {
        nums[bookings[i][0] - 1] += bookings[i][2];
        if (bookings[i][1] < n) {
            nums[bookings[i][1]] -= bookings[i][2];
        }
    }
    for (int i = 1; i < n; i++) {
        nums[i] += nums[i - 1];
    }
    return nums;
}
```

```JavaScript [sol1-JavaScript]
var corpFlightBookings = function(bookings, n) {
    const nums = new Array(n).fill(0);
    for (const booking of bookings) {
        nums[booking[0] - 1] += booking[2];
        if (booking[1] < n) {
            nums[booking[1]] -= booking[2];
        }
    }
    for (let i = 1; i < n; i++) {
        nums[i] += nums[i - 1];
    }
    return nums;
};
```

```Python [sol1-Python3]
class Solution:
    def corpFlightBookings(self, bookings: List[List[int]], n: int) -> List[int]:
        nums = [0] * n
        for left, right, inc in bookings:
            nums[left - 1] += inc
            if right < n:
                nums[right] -= inc
    
        for i in range(1, n):
            nums[i] += nums[i - 1]
        
        return nums
```

```go [sol1-Golang]
func corpFlightBookings(bookings [][]int, n int) []int {
    nums := make([]int, n)
    for _, booking := range bookings {
        nums[booking[0]-1] += booking[2]
        if booking[1] < n {
            nums[booking[1]] -= booking[2]
        }
    }
    for i := 1; i < n; i++ {
        nums[i] += nums[i-1]
    }
    return nums
}
```

**复杂度分析**

- 时间复杂度：$O(n+m)$，其中 $n$ 为要求的数组长度，$m$ 为预定记录的数量。我们需要对于每一条预定记录处理一次差分数组，并最后对差分数组求前缀和。

- 空间复杂度：$O(1)$。我们只需要常数的空间保存若干变量，注意返回值不计入空间复杂度。
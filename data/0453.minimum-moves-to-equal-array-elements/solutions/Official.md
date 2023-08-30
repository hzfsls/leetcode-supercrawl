#### 方法一：数学

**思路和算法**

因为只需要找出让数组所有元素相等的最小操作次数，所以我们不需要考虑数组中各个元素的绝对大小，即不需要真正算出数组中所有元素相等时的元素值，只需要考虑数组中元素相对大小的变化即可。

因此，每次操作既可以理解为使 $n-1$ 个元素增加 $1$，也可以理解使 $1$ 个元素减少 $1$。显然，后者更利于我们的计算。

于是，要计算让数组中所有元素相等的操作数，我们只需要计算将数组中所有元素都减少到数组中元素最小值所需的操作数，即计算
$$
\sum_{i=0}^{n-1} \textit{nums}[i] - min(\textit{nums}) * n
$$
其中 $n$ 为数组 $\textit{nums}$ 的长度，$\textit{min}(\textit{nums})$为数组 $\textit{nums}$ 中元素的最小值。

在实现中，为避免溢出，我们可以逐个累加每个元素与数组中元素最小值的差，即计算
$$
\sum_{i=0}^{n-1} (\textit{nums}[i] - \textit{min}(\textit{nums}))
$$
**代码**

```Python [sol1-Python3]
class Solution:
    def minMoves(self, nums: List[int]) -> int:
        min_num = min(nums)
        res = 0
        for num in nums:
            res += num - min_num
        return res
```

```Java [sol1-Java]
class Solution {
    public int minMoves(int[] nums) {
        int minNum = Arrays.stream(nums).min().getAsInt();
        int res = 0;
        for (int num : nums) {
            res += num - minNum;
        }
        return res;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int MinMoves(int[] nums) {
        int minNum = nums.Min();
        int res = 0;
        foreach (int num in nums) {
            res += num - minNum;
        }
        return res;
    }
}
```

```C++ [sol1-C++]
class Solution {
public:
    int minMoves(vector<int>& nums) {
        int minNum = *min_element(nums.begin(),nums.end());
        int res = 0;
        for (int num : nums) {
            res += num - minNum;
        }
        return res;
    }
};
```

```go [sol1-Golang]
func minMoves(nums []int) (ans int) {
    min := nums[0]
    for _, num := range nums[1:] {
        if num < min {
            min = num
        }
    }
    for _, num := range nums {
        ans += num - min
    }
    return
}
```

```JavaScript [sol1-JavaScript]
var minMoves = function(nums) {
    const minNum = Math.min(...nums);
    let res = 0;
    for (const num of nums) {
        res += num - minNum;
    }
    return res;
};
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 为数组中的元素数量。我们需要一次遍历求出最小值，一次遍历计算操作次数。

- 空间复杂度：$O(1)$。
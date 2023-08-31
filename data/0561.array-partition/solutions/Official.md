## [561.数组拆分 中文官方题解](https://leetcode.cn/problems/array-partition/solutions/100000/shu-zu-chai-fen-i-by-leetcode-solution-9m9y)
#### 方法一：排序

**思路与算法**

不失一般性，我们令每一组 $(a_i, b_i)$ 满足 $a_i \leq b_i$（若不满足，交换二者即可），这样我们需要求得的总和

$$
\sum_{i=1}^n \min(a_i, b_i)
$$

就等于所有 $a_i$ 的和

$$
\sum_{i=1}^n a_i \tag{1}
$$

接下来，我们将所有的 $(a_i, b_i)$ 按照升序排序，使得 $a_1 \leq a_2 \leq \cdots \leq a_n$。这样一来，对于任意的 $a_j$

- 它不大于 $a_{j+1}, a_{j+2}, \cdots, a_n$；

- 它不大于 $b_j$；

- 由于 $a_i \leq b_i$ 对于任意的 $i$ 恒成立，因此它不大于 $b_{j+1}, b_{j+2}, \cdots, b_n$。

由于 $a_j$ 不大于 $\{a\}$ 中的 $n-j$ 个元素，也不大于 $\{b\}$ 中的 $n-j+1$ 个元素，而这些元素都是从 $\textit{nums}$ 中而来的，因此 $a_j$ 在数组 $\textit{nums}$ 中「从大到小」至少排在第 $(n-j) + (n-j+1) + 1 = 2(n-j+1)$ 个位置，也就是「从小到大」至多排在第 $2n - 2(n-j+1) + 1 = 2(j-1) + 1$ 个位置，这里位置的编号从 $1$ 开始，即

$$
a_j \leq c_{2(j-1)+1}
$$

其中数组 $c$ 是将数组 $\textit{nums}$ 升序排序得到的结果，代入 $(1)$ 式即可得到

$$
\sum_{i=1}^n a_i \leq \sum_{i=1}^n c_{2(i-1)+1} \tag{2}
$$

另一方面，令 $(a_1, b_1) = (c_1, c_2), (a_2, b_2) = (c_3, c_4), \cdots, (a_n, b_n) = (c_{2n-1}, c_{2n})$，此时每一组 $(a_i, b_i)$ 都满足 $a_i \leq b_i$ 的要求，并且有 $a_1 \leq a_2 \leq \cdots \leq a_n$，此时

$$
\sum_{i=1}^n a_i = \sum_{i=1}^n c_{2(i-1)+1}
$$

即 $(2)$ 式的等号是可满足的。因此所要求得的最大总和即为

$$
\sum_{i=1}^n c_{2(i-1)+1}
$$

**代码**

需要注意大部分语言的数组编号是从 $0$（而不是上文中的 $1$）开始的。

```C++ [sol1-C++]
class Solution {
public:
    int arrayPairSum(vector<int>& nums) {
        sort(nums.begin(), nums.end());
        int ans = 0;
        for (int i = 0; i < nums.size(); i += 2) {
            ans += nums[i];
        }
        return ans;
    }
};
```

```Java [sol1-Java]
class Solution {
    public int arrayPairSum(int[] nums) {
        Arrays.sort(nums);
        int ans = 0;
        for (int i = 0; i < nums.length; i += 2) {
            ans += nums[i];
        }
        return ans;
    }
}
```

```Python [sol1-Python3]
class Solution:
    def arrayPairSum(self, nums: List[int]) -> int:
        nums.sort()
        return sum(nums[::2])
```

```JavaScript [sol1-JavaScript]
var arrayPairSum = function(nums) {
    nums.sort((a, b) => a - b);
    let ans = 0;
    for (let i = 0; i < nums.length; i += 2) {
        ans += nums[i];
    }
    return ans;
};
```

```go [sol1-Golang]
func arrayPairSum(nums []int) (ans int) {
    sort.Ints(nums)
    for i := 0; i < len(nums); i += 2 {
        ans += nums[i]
    }
    return
}
```

```C [sol1-C]
int cmp(int *a, int *b) {
    return *a - *b;
}

int arrayPairSum(int *nums, int numsSize) {
    qsort(nums, numsSize, sizeof(int), cmp);
    int ans = 0;
    for (int i = 0; i < numsSize; i += 2) {
        ans += nums[i];
    }
    return ans;
}
```

**复杂度分析**

- 时间复杂度：$O(n\log n)$，即为对数组 $\textit{nums}$ 进行排序的时间复杂度。

- 空间复杂度：$O(\log n)$，即为排序需要使用的栈空间。
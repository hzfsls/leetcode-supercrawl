## [992.K 个不同整数的子数组 中文官方题解](https://leetcode.cn/problems/subarrays-with-k-different-integers/solutions/100000/k-ge-bu-tong-zheng-shu-de-zi-shu-zu-by-l-9ylo)
#### 方法一：滑动窗口

**思路及算法**

我们容易发现，对于任意一个右端点，可能存在一系列左端点与其对应，满足两端点所指区间对应的子数组内恰有 $k$ 个不同整数。因此可能有 $O(n^2)$ 个子数组满足条件。因此无法暴力解决该题。

分析这些左端点，我们可以证明：对于任意一个右端点，能够与其对应的左端点们必然相邻。

证明非常直观，假设区间 $[l_1,r]$ 和 $[l_2,r]$ 为满足条件的数组（不失一般性，设 $l_1\leq l_2$）。现在我们设存在一个 $l$ 满足 $l_1 \leq l \leq l_2$，那么区间 $[l,r]$ 作为 $[l_1,r]$ 的子数组，其中的不同整数数量必然不超过 $k$。同理，区间 $[l,r]$ 作为 $[l_2,r]$ 的父数组，其中的不同整数数量必然不少于 $k$。那么可知区间 $[l,r]$ 中的不同整数数量即为 $k$。

这样我们就可以用一个区间 $[l_1,l_2]$ 来代表能够与右端点 $r$ 对应的左端点们。

同时，我们可以发现：当右端点向右移动时，左端点区间也同样向右移动。因为当我们在原有区间的右侧添加元素时，区间中的不同整数数量不会减少而只会不变或增加，因此我们需要在区间左侧删除一定元素，以保证区间内整数数量仍然为 $k$。

于是我们可以用滑动窗口解决本题，和普通的滑动窗口解法的不同之处在于，我们需要记录两个左指针 $\textit{left}_1$ 与 $\textit{left}_2$ 来表示左端点区间 $[\textit{left}_1,\textit{left}_2)$。第一个左指针表示极大的包含 $k$ 个不同整数的区间的左端点，第二个左指针则表示极大的包含 $k-1$ 个不同整数的区间的左端点。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    int subarraysWithKDistinct(vector<int>& nums, int k) {
        int n = nums.size();
        vector<int> num1(n + 1), num2(n + 1);
        int tot1 = 0, tot2 = 0;
        int left1 = 0, left2 = 0, right = 0;
        int ret = 0;
        while (right < n) {
            if (!num1[nums[right]]) {
                tot1++;
            }
            num1[nums[right]]++;
            if (!num2[nums[right]]) {
                tot2++;
            }
            num2[nums[right]]++;
            while (tot1 > k) {
                num1[nums[left1]]--;
                if (!num1[nums[left1]]) {
                    tot1--;
                }
                left1++;
            }
            while (tot2 > k - 1) {
                num2[nums[left2]]--;
                if (!num2[nums[left2]]) {
                    tot2--;
                }
                left2++;
            }
            ret += left2 - left1;
            right++;
        }
        return ret;
    }
};
```

```Java [sol1-Java]
class Solution {
    public int subarraysWithKDistinct(int[] nums, int k) {
        int n = nums.length;
        int[] num1 = new int[n + 1];
        int[] num2 = new int[n + 1];
        int tot1 = 0, tot2 = 0;
        int left1 = 0, left2 = 0, right = 0;
        int ret = 0;
        while (right < n) {
            if (num1[nums[right]] == 0) {
                tot1++;
            }
            num1[nums[right]]++;
            if (num2[nums[right]] == 0) {
                tot2++;
            }
            num2[nums[right]]++;
            while (tot1 > k) {
                num1[nums[left1]]--;
                if (num1[nums[left1]] == 0) {
                    tot1--;
                }
                left1++;
            }
            while (tot2 > k - 1) {
                num2[nums[left2]]--;
                if (num2[nums[left2]] == 0) {
                    tot2--;
                }
                left2++;
            }
            ret += left2 - left1;
            right++;
        }
        return ret;
    }
}
```

```JavaScript [sol1-JavaScript]
var subarraysWithKDistinct = function(nums, k) {
    const n = nums.length;
    const num1 = new Array(n + 1).fill(0);
    const num2 = new Array(n + 1).fill(0);
    let tot1 = 0, tot2 = 0;
    let left1 = 0, left2 = 0, right = 0;
    let ret = 0;
    while (right < n) {
        if (num1[nums[right]] == 0) {
            tot1++;
        }
        num1[nums[right]]++;
        if (num2[nums[right]] == 0) {
            tot2++;
        }
        num2[nums[right]]++;
        while (tot1 > k) {
            num1[nums[left1]]--;
            if (num1[nums[left1]] == 0) {
                tot1--;
            }
            left1++;
        }
        while (tot2 > k - 1) {
            num2[nums[left2]]--;
            if (num2[nums[left2]] == 0) {
                tot2--;
            }
            left2++;
        }
        ret += left2 - left1;
        right++;
    }
    return ret;
};
```

```Python [sol1-Python3]
class Solution:
    def subarraysWithKDistinct(self, nums: List[int], k: int) -> int:
        n = len(nums)
        num1, num2 = collections.Counter(), collections.Counter()
        tot1 = tot2 = 0
        left1 = left2 = right = 0
        ret = 0

        for right, num in enumerate(nums):
            if num1[num] == 0:
                tot1 += 1
            num1[num] += 1
            if num2[num] == 0:
                tot2 += 1
            num2[num] += 1
            
            while tot1 > k:
                num1[nums[left1]] -= 1
                if num1[nums[left1]] == 0:
                    tot1 -= 1
                left1 += 1
            while tot2 > k - 1:
                num2[nums[left2]] -= 1
                if num2[nums[left2]] == 0:
                    tot2 -= 1
                left2 += 1
            
            ret += left2 - left1
        
        return ret
```

```go [sol1-Golang]
func subarraysWithKDistinct(nums []int, k int) (ans int) {
    n := len(nums)
    num1 := make([]int, n+1)
    num2 := make([]int, n+1)
    var tot1, tot2, left1, left2 int
    for _, v := range nums {
        if num1[v] == 0 {
            tot1++
        }
        num1[v]++
        if num2[v] == 0 {
            tot2++
        }
        num2[v]++
        for tot1 > k {
            num1[nums[left1]]--
            if num1[nums[left1]] == 0 {
                tot1--
            }
            left1++
        }
        for tot2 > k-1 {
            num2[nums[left2]]--
            if num2[nums[left2]] == 0 {
                tot2--
            }
            left2++
        }
        ans += left2 - left1
    }
    return ans
}
```

```C [sol1-C]
int subarraysWithKDistinct(int* nums, int numsSize, int k) {
    int num1[numsSize + 1], num2[numsSize + 1];
    memset(num1, 0, sizeof(int) * (numsSize + 1));
    memset(num2, 0, sizeof(int) * (numsSize + 1));
    int tot1 = 0, tot2 = 0;
    int left1 = 0, left2 = 0, right = 0;
    int ret = 0;
    while (right < numsSize) {
        if (!num1[nums[right]]) {
            tot1++;
        }
        num1[nums[right]]++;
        if (!num2[nums[right]]) {
            tot2++;
        }
        num2[nums[right]]++;
        while (tot1 > k) {
            num1[nums[left1]]--;
            if (!num1[nums[left1]]) {
                tot1--;
            }
            left1++;
        }
        while (tot2 > k - 1) {
            num2[nums[left2]]--;
            if (!num2[nums[left2]]) {
                tot2--;
            }
            left2++;
        }
        ret += left2 - left1;
        right++;
    }
    return ret;
}
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 是数组长度。我们至多只需要遍历该数组三次（右指针和两个左指针各一次）。

- 空间复杂度：$O(n)$，其中 $n$ 是数组长度。我们需要记录每一个数的出现次数，本题中数的大小不超过数组长度。
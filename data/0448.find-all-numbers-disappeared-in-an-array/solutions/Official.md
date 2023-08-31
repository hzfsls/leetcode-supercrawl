## [448.找到所有数组中消失的数字 中文官方题解](https://leetcode.cn/problems/find-all-numbers-disappeared-in-an-array/solutions/100000/zhao-dao-suo-you-shu-zu-zhong-xiao-shi-d-mabl)
#### 方法一：原地修改

**思路及解法**

我们可以用一个哈希表记录数组 $\textit{nums}$ 中的数字，由于数字范围均在 $[1,n]$ 中，记录数字后我们再利用哈希表检查 $[1,n]$ 中的每一个数是否出现，从而找到缺失的数字。

由于数字范围均在 $[1,n]$ 中，我们也可以用一个长度为 $n$ 的数组来代替哈希表。这一做法的空间复杂度是 $O(n)$ 的。我们的目标是优化空间复杂度到 $O(1)$。

注意到 $\textit{nums}$ 的长度恰好也为 $n$，能否让 $\textit{nums}$ 充当哈希表呢？

由于 $\textit{nums}$ 的数字范围均在 $[1,n]$ 中，我们可以利用这一范围**之外**的数字，来表达「是否存在」的含义。

具体来说，遍历 $\textit{nums}$，每遇到一个数 $x$，就让 $\textit{nums}[x-1]$ 增加 $n$。由于 $\textit{nums}$ 中所有数均在 $[1,n]$ 中，增加以后，这些数必然大于 $n$。最后我们遍历 $\textit{nums}$，若 $\textit{nums}[i]$ 未大于 $n$，就说明没有遇到过数 $i+1$。这样我们就找到了缺失的数字。

注意，当我们遍历到某个位置时，其中的数可能已经被增加过，因此需要对 $n$ 取模来还原出它本来的值。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    vector<int> findDisappearedNumbers(vector<int>& nums) {
        int n = nums.size();
        for (auto& num : nums) {
            int x = (num - 1) % n;
            nums[x] += n;
        }
        vector<int> ret;
        for (int i = 0; i < n; i++) {
            if (nums[i] <= n) {
                ret.push_back(i + 1);
            }
        }
        return ret;
    }
};
```

```Java [sol1-Java]
class Solution {
    public List<Integer> findDisappearedNumbers(int[] nums) {
        int n = nums.length;
        for (int num : nums) {
            int x = (num - 1) % n;
            nums[x] += n;
        }
        List<Integer> ret = new ArrayList<Integer>();
        for (int i = 0; i < n; i++) {
            if (nums[i] <= n) {
                ret.add(i + 1);
            }
        }
        return ret;
    }
}
```

```Python [sol1-Python3]
class Solution:
    def findDisappearedNumbers(self, nums: List[int]) -> List[int]:
        n = len(nums)
        for num in nums:
            x = (num - 1) % n
            nums[x] += n
        
        ret = [i + 1 for i, num in enumerate(nums) if num <= n]
        return ret
```

```go [sol1-Golang]
func findDisappearedNumbers(nums []int) (ans []int) {
    n := len(nums)
    for _, v := range nums {
        v = (v - 1) % n
        nums[v] += n
    }
    for i, v := range nums {
        if v <= n {
            ans = append(ans, i+1)
        }
    }
    return
}
```

```C [sol1-C]
int* findDisappearedNumbers(int* nums, int numsSize, int* returnSize) {
    for (int i = 0; i < numsSize; i++) {
        int x = (nums[i] - 1) % numsSize;
        nums[x] += numsSize;
    }
    int* ret = malloc(sizeof(int) * numsSize);
    *returnSize = 0;
    for (int i = 0; i < numsSize; i++) {
        if (nums[i] <= numsSize) {
            ret[(*returnSize)++] = i + 1;
        }
    }
    return ret;
}
```

```JavaScript [sol1-JavaScript]
var findDisappearedNumbers = function(nums) {
    const n = nums.length;
    for (const num of nums) {
        const x = (num - 1) % n;
        nums[x] += n;
    }
    const ret = [];
    for (const [i, num] of nums.entries()) {
        if (num <= n) {
            ret.push(i + 1);
        }
    }
    return ret;
};
```

**复杂度分析**

- 时间复杂度：$O(n)$。其中 $n$ 是数组 $\textit{nums}$ 的长度。

- 空间复杂度：$O(1)$。返回值不计入空间复杂度。
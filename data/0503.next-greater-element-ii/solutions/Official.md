#### 方法一：单调栈 + 循环数组

**思路及算法**

我们可以使用单调栈解决本题。单调栈中保存的是下标，从栈底到栈顶的下标在数组 $\textit{nums}$ 中对应的值是单调不升的。

每次我们移动到数组中的一个新的位置 $i$，我们就将当前单调栈中所有对应值小于 $\textit{nums}[i]$ 的下标弹出单调栈，这些值的下一个更大元素即为 $\textit{nums}[i]$（证明很简单：如果有更靠前的更大元素，那么这些位置将被提前弹出栈）。随后我们将位置 $i$ 入栈。

但是注意到只遍历一次序列是不够的，例如序列 $[2,3,1]$，最后单调栈中将剩余 $[3,1]$，其中元素 $[1]$ 的下一个更大元素还是不知道的。

一个朴素的思想是，我们可以把这个循环数组「拉直」，即复制该序列的前 $n-1$ 个元素拼接在原序列的后面。这样我们就可以将这个新序列当作普通序列，用上文的方法来处理。

而在本题中，我们不需要显性地将该循环数组「拉直」，而只需要在处理时对下标取模即可。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    vector<int> nextGreaterElements(vector<int>& nums) {
        int n = nums.size();
        vector<int> ret(n, -1);
        stack<int> stk;
        for (int i = 0; i < n * 2 - 1; i++) {
            while (!stk.empty() && nums[stk.top()] < nums[i % n]) {
                ret[stk.top()] = nums[i % n];
                stk.pop();
            }
            stk.push(i % n);
        }
        return ret;
    }
};
```

```Java [sol1-Java]
class Solution {
    public int[] nextGreaterElements(int[] nums) {
        int n = nums.length;
        int[] ret = new int[n];
        Arrays.fill(ret, -1);
        Deque<Integer> stack = new LinkedList<Integer>();
        for (int i = 0; i < n * 2 - 1; i++) {
            while (!stack.isEmpty() && nums[stack.peek()] < nums[i % n]) {
                ret[stack.pop()] = nums[i % n];
            }
            stack.push(i % n);
        }
        return ret;
    }
}
```

```JavaScript [sol1-JavaScript]
var nextGreaterElements = function(nums) {
    const n = nums.length;
    const ret = new Array(n).fill(-1);
    const stk = [];
    for (let i = 0; i < n * 2 - 1; i++) {
        while (stk.length && nums[stk[stk.length - 1]] < nums[i % n]) {
            ret[stk[stk.length - 1]] = nums[i % n];
            stk.pop();
        }
        stk.push(i % n);
    }
    return ret;
};
```

```Python [sol1-Python3]
class Solution:
    def nextGreaterElements(self, nums: List[int]) -> List[int]:
        n = len(nums)
        ret = [-1] * n
        stk = list()

        for i in range(n * 2 - 1):
            while stk and nums[stk[-1]] < nums[i % n]:
                ret[stk.pop()] = nums[i % n]
            stk.append(i % n)
        
        return ret
```

```go [sol1-Golang]
func nextGreaterElements(nums []int) []int {
    n := len(nums)
    ans := make([]int, n)
    for i := range ans {
        ans[i] = -1
    }
    stack := []int{}
    for i := 0; i < n*2-1; i++ {
        for len(stack) > 0 && nums[stack[len(stack)-1]] < nums[i%n] {
            ans[stack[len(stack)-1]] = nums[i%n]
            stack = stack[:len(stack)-1]
        }
        stack = append(stack, i%n)
    }
    return ans
}
```

```C [sol1-C]
int* nextGreaterElements(int* nums, int numsSize, int* returnSize) {
    *returnSize = numsSize;
    if (numsSize == 0) {
        return NULL;
    }
    int* ret = malloc(sizeof(int) * numsSize);
    memset(ret, -1, sizeof(int) * numsSize);

    int stk[numsSize * 2 - 1], top = 0;
    for (int i = 0; i < numsSize * 2 - 1; i++) {
        while (top > 0 && nums[stk[top - 1]] < nums[i % numsSize]) {
            ret[stk[top - 1]] = nums[i % numsSize];
            top--;
        }
        stk[top++] = i % numsSize;
    }
    return ret;
}
```

**复杂度分析**

- 时间复杂度: $O(n)$，其中 $n$ 是序列的长度。我们需要遍历该数组中每个元素最多 $2$ 次，每个元素出栈与入栈的总次数也不超过 $4$ 次。

- 空间复杂度: $O(n)$，其中 $n$ 是序列的长度。空间复杂度主要取决于栈的大小，栈的大小至多为 $2n-1$。
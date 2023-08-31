## [376.摆动序列 中文官方题解](https://leetcode.cn/problems/wiggle-subsequence/solutions/100000/bai-dong-xu-lie-by-leetcode-solution-yh2m)
#### 写在前面

解决本题前，我们先进行一些约定：

1. 某个序列被称为「上升摆动序列」，当且仅当该序列是摆动序列，且最后一个元素呈上升趋势。如序列 $[1,3,2,4]$ 即为「上升摆动序列」。

2. 某个序列被称为「下降摆动序列」，当且仅当该序列是摆动序列，且最后一个元素呈下降趋势。如序列 $[4,2,3,1]$ 即为「下降摆动序列」。

3. 特别地，对于长度为 $1$ 的序列，它既是「上升摆动序列」，也是「下降摆动序列」。

4. 序列中的某个元素被称为「峰」，当且仅当该元素两侧的相邻元素均小于它。如序列 $[1,3,2,4]$ 中，$3$ 就是一个「峰」。

5. 序列中的某个元素被称为「谷」，当且仅当该元素两侧的相邻元素均大于它。如序列 $[1,3,2,4]$ 中，$2$ 就是一个「谷」。

6. 特别地，对于位于序列两端的元素，只有一侧的相邻元素小于或大于它，我们也称其为「峰」或「谷」。如序列 $[1,3,2,4]$ 中，$1$ 也是一个「谷」，$4$ 也是一个「峰」。

7. 因为一段相邻的相同元素中我们最多只能选择其中的一个，所以我们可以忽略相邻的相同元素。现在我们假定序列中任意两个相邻元素都不相同，即要么左侧大于右侧，要么右侧大于左侧。对于序列中既非「峰」也非「谷」的元素，我们称其为「过渡元素」。如序列 $[1,2,3,4]$ 中，$2$ 和 $3$ 都是「过渡元素」。

#### 方法一：动态规划

**思路及解法**

每当我们选择一个元素作为摆动序列的一部分时，这个元素要么是上升的，要么是下降的，这取决于前一个元素的大小。那么列出状态表达式为：

1. $\textit{up}[i]$ 表示以前 $i$ 个元素中的某一个为结尾的最长的「上升摆动序列」的长度。

2. $\textit{down}[i]$ 表示以前 $i$ 个元素中的某一个为结尾的最长的「下降摆动序列」的长度。

下面以 $\textit{up}[i]$ 为例，说明其状态转移规则：

1. 当 $\textit{nums}[i] \leq \textit{nums}[i - 1]$ 时，我们无法选出更长的「上升摆动序列」的方案。因为对于任何以 $\textit{nums}[i]$ 结尾的「上升摆动序列」，我们都可以将 $\textit{nums}[i]$ 替换为 $\textit{nums}[i - 1]$，使其成为以 $\textit{nums}[i - 1]$ 结尾的「上升摆动序列」。

2. 当 $\textit{nums}[i] > \textit{nums}[i - 1]$ 时，我们既可以从 $up[i - 1]$ 进行转移，也可以从 $\textit{down}[i - 1]$ 进行转移。下面我们证明从 $\textit{down}[i - 1]$ 转移是必然合法的，即必然存在一个 $\textit{down}[i - 1]$ 对应的最长的「下降摆动序列」的末尾元素小于 $\textit{nums}[i]$。

   - 我们记这个末尾元素在原序列中的下标为 $j$，假设从 $j$ 往前的第一个「谷」为 $\textit{nums}[k]$，我们总可以让 $j$ 移动到 $k$，使得这个最长的「下降摆动序列」的末尾元素为「谷」。

   - 然后我们可以证明在这个末尾元素为「谷」的情况下，这个末尾元素必然是从 $\textit{nums}[i]$ 往前的第一个「谷」。证明非常简单，我们使用反证法，如果这个末尾元素不是从 $\textit{nums}[i]$ 往前的第一个「谷」，那么我们总可以在末尾元素和 $\textit{nums}[i]$ 之间取得一对「峰」与「谷」，接在这个「下降摆动序列」后，使其更长。
   
   - 这样我们知道必然存在一个 $\textit{down}[i - 1]$ 对应的最长的「下降摆动序列」的末尾元素为 $\textit{nums}[i]$ 往前的第一个「谷」。这个「谷」必然小于 $\textit{nums}[i]$。证毕。

这样我们可以用同样的方法说明 $\textit{down}[i]$ 的状态转移规则，最终的状态转移方程为：

$$
\begin{aligned}
&\textit{up}[i]=
\begin{cases}
    \textit{up}[i - 1],& \textit{nums}[i] \leq \textit{nums}[i - 1] \\
    \max(\textit{up}[i - 1], \textit{down}[i - 1] + 1),& \textit{nums}[i] > \textit{nums}[i - 1]
\end{cases} \\\\
&\textit{down}[i]=
\begin{cases}
    \textit{down}[i - 1],& \textit{nums}[i] \geq \textit{nums}[i - 1] \\
    \max(\textit{up}[i - 1] + 1, \textit{down}[i - 1]),& \textit{nums}[i] < \textit{nums}[i - 1]
\end{cases}
\end{aligned}
$$

最终的答案即为 $\textit{up}[n-1]$ 和 $\textit{down}[n-1]$ 中的较大值，其中 $n$ 是序列的长度。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    int wiggleMaxLength(vector<int>& nums) {
        int n = nums.size();
        if (n < 2) {
            return n;
        }
        vector<int> up(n), down(n);
        up[0] = down[0] = 1;
        for (int i = 1; i < n; i++) {
            if (nums[i] > nums[i - 1]) {
                up[i] = max(up[i - 1], down[i - 1] + 1);
                down[i] = down[i - 1];
            } else if (nums[i] < nums[i - 1]) {
                up[i] = up[i - 1];
                down[i] = max(up[i - 1] + 1, down[i - 1]);
            } else {
                up[i] = up[i - 1];
                down[i] = down[i - 1];
            }
        }
        return max(up[n - 1], down[n - 1]);
    }
};
```

```Java [sol1-Java]
class Solution {
    public int wiggleMaxLength(int[] nums) {
        int n = nums.length;
        if (n < 2) {
            return n;
        }
        int[] up = new int[n];
        int[] down = new int[n];
        up[0] = down[0] = 1;
        for (int i = 1; i < n; i++) {
            if (nums[i] > nums[i - 1]) {
                up[i] = Math.max(up[i - 1], down[i - 1] + 1);
                down[i] = down[i - 1];
            } else if (nums[i] < nums[i - 1]) {
                up[i] = up[i - 1];
                down[i] = Math.max(up[i - 1] + 1, down[i - 1]);
            } else {
                up[i] = up[i - 1];
                down[i] = down[i - 1];
            }
        }
        return Math.max(up[n - 1], down[n - 1]);
    }
}
```

```JavaScript [sol1-JavaScript]
var wiggleMaxLength = function(nums) {
    const n = nums.length;
    if (n < 2) return n;
    const up = new Array(n).fill(0);
    const down = new Array(n).fill(0);
    up[0] = down[0] = 1;
    for (let i = 1; i < n; i++) {
        if (nums[i] > nums[i - 1]) {
            up[i] = Math.max(up[i - 1], down[i - 1] + 1);
            down[i] = down[i - 1];
        } else if (nums[i] < nums[i - 1]) {
            up[i] = up[i - 1];
            down[i] = Math.max(up[i - 1] + 1, down[i - 1]);
        } else {
            up[i] = up[i - 1];
            down[i] = down[i - 1];
        }
    }
    return Math.max(up[n - 1], down[n - 1]);
};
```

```Python [sol1-Python3]
class Solution:
    def wiggleMaxLength(self, nums: List[int]) -> int:
        n = len(nums)
        if n < 2:
            return n
        
        up = [1] + [0] * (n - 1)
        down = [1] + [0] * (n - 1)
        for i in range(1, n):
            if nums[i] > nums[i - 1]:
                up[i] = max(up[i - 1], down[i - 1] + 1)
                down[i] = down[i - 1]
            elif nums[i] < nums[i - 1]:
                up[i] = up[i - 1]
                down[i] = max(up[i - 1] + 1, down[i - 1])
            else:
                up[i] = up[i - 1]
                down[i] = down[i - 1]
        
        return max(up[n - 1], down[n - 1])
```

```Golang [sol1-Golang]
func wiggleMaxLength(nums []int) int {
    n := len(nums)
    if n < 2 {
        return n
    }
    up := make([]int, n)
    down := make([]int, n)
    up[0] = 1
    down[0] = 1
    for i := 1; i < n; i++ {
        if nums[i] > nums[i-1] {
            up[i] = max(up[i-1], down[i-1]+1)
            down[i] = down[i-1]
        } else if nums[i] < nums[i-1] {
            up[i] = up[i-1]
            down[i] = max(up[i-1]+1, down[i-1])
        } else {
            up[i] = up[i-1]
            down[i] = down[i-1]
        }
    }
    return max(up[n-1], down[n-1])
}

func max(a, b int) int {
    if a > b {
        return a
    }
    return b
}
```

```C [sol1-C]
int wiggleMaxLength(int* nums, int numsSize) {
    if (numsSize < 2) {
        return numsSize;
    }
    int up[numsSize], down[numsSize];
    up[0] = down[0] = 1;
    for (int i = 1; i < numsSize; i++) {
        if (nums[i] > nums[i - 1]) {
            up[i] = fmax(up[i - 1], down[i - 1] + 1);
            down[i] = down[i - 1];
        } else if (nums[i] < nums[i - 1]) {
            up[i] = up[i - 1];
            down[i] = fmax(up[i - 1] + 1, down[i - 1]);
        } else {
            up[i] = up[i - 1];
            down[i] = down[i - 1];
        }
    }
    return fmax(up[numsSize - 1], down[numsSize - 1]);
}
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 是序列的长度。我们只需要遍历该序列一次。

- 空间复杂度：$O(n)$，其中 $n$ 是序列的长度。我们需要开辟两个长度为 $n$ 的数组。

#### 方法二：优化的动态规划

**思路及解法**

注意到方法一中，我们仅需要前一个状态来进行转移，所以我们维护两个变量即可。这样我们可以写出如下的代码：

```C++ [sol21-C++]
class Solution {
public:
    int wiggleMaxLength(vector<int>& nums) {
        int n = nums.size();
        if (n < 2) {
            return n;
        }
        int up = 1, down = 1;
        for (int i = 1; i < n; i++) {
            if (nums[i] > nums[i - 1]) {
                up = max(up, down + 1);
            } else if (nums[i] < nums[i - 1]) {
                down = max(up + 1, down);
            }
        }
        return max(up, down);
    }
};
```

```Java [sol21-Java]
class Solution {
    public int wiggleMaxLength(int[] nums) {
        int n = nums.length;
        if (n < 2) {
            return n;
        }
        int up = 1, down = 1;
        for (int i = 1; i < n; i++) {
            if (nums[i] > nums[i - 1]) {
                up = Math.max(up, down + 1);
            } else if (nums[i] < nums[i - 1]) {
                down = Math.max(up + 1, down);
            }
        }
        return Math.max(up, down);
    }
}
```

```Python [sol21-Python3]
class Solution:
    def wiggleMaxLength(self, nums: List[int]) -> int:
        n = len(nums)
        if n < 2:
            return n
        
        up = down = 1
        for i in range(1, n):
            if nums[i] > nums[i - 1]:
                up = max(up, down + 1)
            elif nums[i] < nums[i - 1]:
                down = max(up + 1, down)
        
        return max(up, down)
```

```Golang [sol21-Golang]
func wiggleMaxLength(nums []int) int {
    n := len(nums)
    if n < 2 {
        return n
    }
    up, down := 1, 1
    for i := 1; i < n; i++ {
        if nums[i] > nums[i-1] {
            up = max(up, down+1)
        } else if nums[i] < nums[i-1] {
            down = max(up+1, down)
        }
    }
    return max(up, down)
}

func max(a, b int) int {
    if a > b {
        return a
    }
    return b
}
```

```C [sol21-C]
int wiggleMaxLength(int* nums, int numsSize) {
    if (numsSize < 2) {
        return numsSize;
    }
    int up = 1, down = 1;
    for (int i = 1; i < numsSize; i++) {
        if (nums[i] > nums[i - 1]) {
            up = fmax(up, down + 1);
        } else if (nums[i] < nums[i - 1]) {
            down = fmax(up + 1, down);
        }
    }
    return fmax(up, down);
}
```

```JavaScript [sol21-JavaScript]
var wiggleMaxLength = function(nums) {
    const n = nums.length;
    if (n < 2) {
        return n;
    }

    let up = down = 1;
    for (let i = 1; i < n; i++) {
        if (nums[i] > nums[i - 1]) {
            up = Math.max(up, down + 1);
        } else if (nums[i] < nums[i - 1]) {
            down = Math.max(up + 1, down);
        }
    }
    return Math.max(up, down);
};
```

注意到每有一个「峰」到「谷」的下降趋势，$\textit{down}$ 值才会增加，每有一个「谷」到「峰」的上升趋势，$\textit{up}$ 值才会增加。且过程中 $\textit{down}$ 与 $\textit{up}$ 的差的绝对值值恒不大于 $1$，即 $\textit{up} \leq \textit{down} + 1$ 且 $\textit{down} \leq \textit{up} + 1$，于是有 $\max(\textit{up}, \textit{down} + 1) = \textit{down} + 1$ 且 $\max(\textit{up} + 1, \textit{down}) = \textit{up} + 1$。这样我们可以省去不必要的比较大小的过程。

**代码**

```C++ [sol22-C++]
class Solution {
public:
    int wiggleMaxLength(vector<int>& nums) {
        int n = nums.size();
        if (n < 2) {
            return n;
        }
        int up = 1, down = 1;
        for (int i = 1; i < n; i++) {
            if (nums[i] > nums[i - 1]) {
                up = down + 1;
            } else if (nums[i] < nums[i - 1]) {
                down = up + 1;
            }
        }
        return max(up, down);
    }
};
```

```Java [sol22-Java]
class Solution {
    public int wiggleMaxLength(int[] nums) {
        int n = nums.length;
        if (n < 2) {
            return n;
        }
        int up = 1, down = 1;
        for (int i = 1; i < n; i++) {
            if (nums[i] > nums[i - 1]) {
                up = down + 1;
            } else if (nums[i] < nums[i - 1]) {
                down = up + 1;
            }
        }
        return Math.max(up, down);
    }
}
```

```Python [sol22-Python3]
class Solution:
    def wiggleMaxLength(self, nums: List[int]) -> int:
        n = len(nums)
        if n < 2:
            return n
        
        up = down = 1
        for i in range(1, n):
            if nums[i] > nums[i - 1]:
                up = down + 1
            elif nums[i] < nums[i - 1]:
                down = up + 1
        
        return max(up, down)
```

```Golang [sol22-Golang]
func wiggleMaxLength(nums []int) int {
    n := len(nums)
    if n < 2 {
        return n
    }
    up, down := 1, 1
    for i := 1; i < n; i++ {
        if nums[i] > nums[i-1] {
            up = down + 1
        } else if nums[i] < nums[i-1] {
            down = up + 1
        }
    }
    return max(up, down)
}

func max(a, b int) int {
    if a > b {
        return a
    }
    return b
}
```

```C [sol22-C]
int wiggleMaxLength(int* nums, int numsSize) {
    if (numsSize < 2) {
        return numsSize;
    }
    int up = 1, down = 1;
    for (int i = 1; i < numsSize; i++) {
        if (nums[i] > nums[i - 1]) {
            up = down + 1;
        } else if (nums[i] < nums[i - 1]) {
            down = up + 1;
        }
    }
    return fmax(up, down);
}
```
```JavaScript [sol22-JavaScript]
var wiggleMaxLength = function(nums) {
    const n = nums.length;
    if (n < 2) { 
        return n;
    }

    let up = down = 1;
    for (let i = 1; i < n; i++) {
        if (nums[i] > nums[i - 1]) {
            up = down + 1;
        } else if (nums[i] < nums[i - 1]) {
            down = up + 1;
        }
    }
    return Math.max(up, down);
};
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 是序列的长度。我们只需要遍历该序列一次。

- 空间复杂度：$O(1)$。我们只需要常数空间来存放若干变量。

#### 方法三：贪心

**思路及解法**

观察这个序列可以发现，我们不断地交错选择「峰」与「谷」，可以使得该序列尽可能长。证明非常简单：如果我们选择了一个「过渡元素」，那么在原序列中，这个「过渡元素」的两侧有一个「峰」和一个「谷」。不失一般性，我们假设在原序列中的出现顺序为「峰」「过渡元素」「谷」。如果「过渡元素」在选择的序列中小于其两侧的元素，那么「谷」一定没有在选择的序列中出现，我们可以将「过渡元素」替换成「谷」；同理，如果「过渡元素」在选择的序列中大于其两侧的元素，那么「峰」一定没有在选择的序列中出现，我们可以将「过渡元素」替换成「峰」。这样一来，我们总可以将任意满足要求的序列中的所有「过渡元素」替换成「峰」或「谷」。并且由于我们不断地交错选择「峰」与「谷」的方法就可以满足要求，因此这种选择方法就一定可以达到可选元素数量的最大值。

这样，我们只需要统计该序列中「峰」与「谷」的数量即可（注意序列两端的数也是「峰」或「谷」），但需要注意处理相邻的相同元素。

在实际代码中，我们记录当前序列的上升下降趋势。每次加入一个新元素时，用新的上升下降趋势与之前对比，如果出现了「峰」或「谷」，答案加一，并更新当前序列的上升下降趋势。

**代码**

```C++ [sol3-C++]
class Solution {
public:
    int wiggleMaxLength(vector<int>& nums) {
        int n = nums.size();
        if (n < 2) {
            return n;
        }
        int prevdiff = nums[1] - nums[0];
        int ret = prevdiff != 0 ? 2 : 1;
        for (int i = 2; i < n; i++) {
            int diff = nums[i] - nums[i - 1];
            if ((diff > 0 && prevdiff <= 0) || (diff < 0 && prevdiff >= 0)) {
                ret++;
                prevdiff = diff;
            }
        }
        return ret;
    }
};
```

```Java [sol3-Java]
class Solution {
    public int wiggleMaxLength(int[] nums) {
        int n = nums.length;
        if (n < 2) {
            return n;
        }
        int prevdiff = nums[1] - nums[0];
        int ret = prevdiff != 0 ? 2 : 1;
        for (int i = 2; i < n; i++) {
            int diff = nums[i] - nums[i - 1];
            if ((diff > 0 && prevdiff <= 0) || (diff < 0 && prevdiff >= 0)) {
                ret++;
                prevdiff = diff;
            }
        }
        return ret;
    }
}
```

```JavaScript [sol3-JavaScript]
var wiggleMaxLength = function(nums) {
    const n = nums.length;
    if (n < 2) {
        return n;
    }
    let prevdiff = nums[1] - nums[0];
    let ret = prevdiff !== 0 ? 2 : 1;
    for (let i = 2; i < n; i++) {
        const diff = nums[i] - nums[i - 1];
        if ((diff > 0 && prevdiff <= 0) || (diff < 0 && prevdiff >= 0)) {
            ret++;
            prevdiff = diff;
        }
    }
    return ret;
};
```

```Python [sol3-Python3]
class Solution:
    def wiggleMaxLength(self, nums: List[int]) -> int:
        n = len(nums)
        if n < 2:
            return n
        
        prevdiff = nums[1] - nums[0]
        ret = (2 if prevdiff != 0 else 1)
        for i in range(2, n):
            diff = nums[i] - nums[i - 1]
            if (diff > 0 and prevdiff <= 0) or (diff < 0 and prevdiff >= 0):
                ret += 1
                prevdiff = diff
        
        return ret
```

```Golang [sol3-Golang]
func wiggleMaxLength(nums []int) int {
    n := len(nums)
    if n < 2 {
        return n
    }
    ans := 1
    prevDiff := nums[1] - nums[0]
    if prevDiff != 0 {
        ans = 2
    }
    for i := 2; i < n; i++ {
        diff := nums[i] - nums[i-1]
        if diff > 0 && prevDiff <= 0 || diff < 0 && prevDiff >= 0 {
            ans++
            prevDiff = diff
        }
    }
    return ans
}
```

```C [sol3-C]
int wiggleMaxLength(int* nums, int numsSize) {
    if (numsSize < 2) {
        return numsSize;
    }
    int prevdiff = nums[1] - nums[0];
    int ret = prevdiff != 0 ? 2 : 1;
    for (int i = 2; i < numsSize; i++) {
        int diff = nums[i] - nums[i - 1];
        if ((diff > 0 && prevdiff <= 0) || (diff < 0 && prevdiff >= 0)) {
            ret++;
            prevdiff = diff;
        }
    }
    return ret;
}
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 是序列的长度。我们只需要遍历该序列一次。

- 空间复杂度：$O(1)$。我们只需要常数空间来存放若干变量。
## [1764.通过连接另一个数组的子数组得到一个数组 中文官方题解](https://leetcode.cn/problems/form-array-by-concatenating-subarrays-of-another-array/solutions/100000/tong-guo-lian-jie-ling-yi-ge-shu-zu-de-z-xsvx)
#### 方法一：贪心 + 双指针

使用变量 $i$ 指向需要匹配的数组，即 $\textit{groups}[i]$。遍历数组 $\textit{nums}$，假设当前遍历到第 $k$ 个元素：

+ 以 $\textit{nums}[k]$ 为首元素的子数组与 $\textit{groups}[i]$ 相同，那么 $\textit{groups}[i]$ 可以找到对应的子数组。为了满足不相交的要求，我们将 $k$ 加上数组 $\textit{groups}[i]$ 的长度，并且将 $i$ 加 $1$；

+ 以 $\textit{nums}[k]$ 为首元素的子数组与 $\textit{groups}[i]$ 不相同，那么我们直接将 $k$ 加 $1$。

遍历结束时，如果 $\textit{groups}$ 的所有数组都找到对应的子数组，即 $i = n$ 成立，返回 $\text{true}$；否则返回 $\text{false}$。

> **贪心的正确性**
>
> 证明：假设存在 $n$ 个不相交的子数组，使得第 $i$ 个子数组与 $\textit{groups}[i]$ 完全相同，并且第 $i$ 个子数组的首元素下标为 $k$，那么在匹配查找的过程中，如果存在下标 $k_1 \lt k$ 也满足第 $i$ 个子数组的要求，显然我们将 $k_1$ 替代 $k$ 是不影响后续的匹配的。

```Python [sol1-Python3]
class Solution:
    def canChoose(self, groups: List[List[int]], nums: List[int]) -> bool:
        k = 0
        for g in groups:
            while k + len(g) <= len(nums):
                if nums[k: k + len(g)] == g:
                    k += len(g)
                    break
                k += 1
            else:
                return False
        return True
```

```C++ [sol1-C++]
class Solution {
public:
    bool check(vector<int> &g, vector<int> &nums, int k) {
        if (k + g.size() > nums.size()) {
            return false;
        }
        for (int j = 0; j < g.size(); j++) {
            if (g[j] != nums[k + j]) {
                return false;
            }
        }
        return true;
    }

    bool canChoose(vector<vector<int>>& groups, vector<int>& nums) {
        int i = 0;
        for (int k = 0; k < nums.size() && i < groups.size();) {
            if (check(groups[i], nums, k)) {
                k += groups[i].size();
                i++;
            } else {
                k++;
            }
        }
        return i == groups.size();
    }
};
```

```Java [sol1-Java]
class Solution {
    public boolean canChoose(int[][] groups, int[] nums) {
        int i = 0;
        for (int k = 0; k < nums.length && i < groups.length;) {
            if (check(groups[i], nums, k)) {
                k += groups[i].length;
                i++;
            } else {
                k++;
            }
        }
        return i == groups.length;
    }

    public boolean check(int[] g, int[] nums, int k) {
        if (k + g.length > nums.length) {
            return false;
        }
        for (int j = 0; j < g.length; j++) {
            if (g[j] != nums[k + j]) {
                return false;
            }
        }
        return true;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public bool CanChoose(int[][] groups, int[] nums) {
        int i = 0;
        for (int k = 0; k < nums.Length && i < groups.Length;) {
            if (Check(groups[i], nums, k)) {
                k += groups[i].Length;
                i++;
            } else {
                k++;
            }
        }
        return i == groups.Length;
    }

    public bool Check(int[] g, int[] nums, int k) {
        if (k + g.Length > nums.Length) {
            return false;
        }
        for (int j = 0; j < g.Length; j++) {
            if (g[j] != nums[k + j]) {
                return false;
            }
        }
        return true;
    }
}
```

```C [sol1-C]
bool check(const int *g, int gSize, const int *nums, int numsSize, int k) {
    if (k + gSize > numsSize) {
        return false;
    }
    for (int j = 0; j < gSize; j++) {
        if (g[j] != nums[k + j]) {
            return false;
        }
    }
    return true;
}

bool canChoose(int** groups, int groupsSize, int* groupsColSize, int* nums, int numsSize) {
    int i = 0;
    for (int k = 0; k < numsSize && i < groupsSize;) {
        if (check(groups[i], groupsColSize[i], nums, numsSize, k)) {
            k += groupsColSize[i];
            i++;
        } else {
            k++;
        }
    }
    return i == groupsSize;
}
```

```JavaScript [sol1-JavaScript]
var canChoose = function(groups, nums) {
    let i = 0;
    for (let k = 0; k < nums.length && i < groups.length;) {
        if (check(groups[i], nums, k)) {
            k += groups[i].length;
            i++;
        } else {
            k++;
        }
    }
    return i === groups.length;
}

const check = (g, nums, k) => {
    if (k + g.length > nums.length) {
        return false;
    }
    for (let j = 0; j < g.length; j++) {
        if (g[j] !== nums[k + j]) {
            return false;
        }
    }
    return true;
};
```

```go [sol1-Golang]
func canChoose(groups [][]int, nums []int) bool {
next:
	for _, g := range groups {
		for len(nums) >= len(g) {
			if equal(nums[:len(g)], g) {
				nums = nums[len(g):]
				continue next
			}
			nums = nums[1:]
		}
		return false
	}
	return true
}

func equal(a, b []int) bool {
	for i, x := range a {
		if x != b[i] {
			return false
		}
	}
	return true
}
```

**复杂度分析**

+ 时间复杂度：$O(m \times \max g_i)$，其中 $m$ 是数组 $\textit{nums}$ 的长度，$g_i$ 是数组 $\textit{groups}[i]$ 的长度。最坏情况下，数组 $\textit{nums}$ 在每个位置都调用一次 $\text{check}$ 函数，因此总时间复杂度为 $O(m \times \max g_i)$。

+ 空间复杂度：$O(1)$。

#### 方法二：KMP 匹配算法

关于 KMP 算法的详细说明可以参考官方题解「[实现 strStr()](https://leetcode.cn/problems/find-the-index-of-the-first-occurrence-in-a-string/solutions/732236/shi-xian-strstr-by-leetcode-solution-ds6y/)」，本文不作详细说明。类似于字符串的匹配查找，数组也可以使用 KMP 算法进行匹配。我们依次枚举数组 $\textit{groups}[i]$，并且使用变量 $k$ 表示 $\textit{nums}$ 开始匹配查找的起点，初始时 $k=0$，如果匹配查找成功，那么将 $k$ 设为查找到的下标加上 $\textit{groups}[i]$ 的长度，否则直接返回 $\text{false}$，匹配到最后直接返回 $\text{true}$。

```C++ [sol2-C++]
class Solution {
public:
    int find(vector<int> &nums, int k, vector<int> &g) {
        int m = g.size(), n = nums.size();
        if (k + g.size() > nums.size()) {
            return -1;
        }
        vector<int> pi(m);
        for (int i = 1, j = 0; i < m; i++) {
            while (j > 0 && g[i] != g[j]) {
                j = pi[j - 1];
            }
            if (g[i] == g[j]) {
                j++;
            }
            pi[i] = j;
        }
        for (int i = k, j = 0; i < n; i++) {
            while (j > 0 && nums[i] != g[j]) {
                j = pi[j - 1];
            }
            if (nums[i] == g[j]) {
                j++;
            }
            if (j == m) {
                return i - m + 1;
            }
        }
        return -1;
    }

    bool canChoose(vector<vector<int>>& groups, vector<int>& nums) {
        int k = 0;
        for (int i = 0; i < groups.size(); i++) {
            k = find(nums, k, groups[i]);
            if (k == -1) {
                return false;
            }
            k += groups[i].size();
        }
        return true;
    }
};
```

```Java [sol2-Java]
class Solution {
    public boolean canChoose(int[][] groups, int[] nums) {
        int k = 0;
        for (int i = 0; i < groups.length; i++) {
            k = find(nums, k, groups[i]);
            if (k == -1) {
                return false;
            }
            k += groups[i].length;
        }
        return true;
    }

    public int find(int[] nums, int k, int[] g) {
        int m = g.length, n = nums.length;
        if (k + g.length > nums.length) {
            return -1;
        }
        int[] pi = new int[m];
        for (int i = 1, j = 0; i < m; i++) {
            while (j > 0 && g[i] != g[j]) {
                j = pi[j - 1];
            }
            if (g[i] == g[j]) {
                j++;
            }
            pi[i] = j;
        }
        for (int i = k, j = 0; i < n; i++) {
            while (j > 0 && nums[i] != g[j]) {
                j = pi[j - 1];
            }
            if (nums[i] == g[j]) {
                j++;
            }
            if (j == m) {
                return i - m + 1;
            }
        }
        return -1;
    }
}
```

```C# [sol2-C#]
public class Solution {
    public bool CanChoose(int[][] groups, int[] nums) {
        int k = 0;
        for (int i = 0; i < groups.Length; i++) {
            k = Find(nums, k, groups[i]);
            if (k == -1) {
                return false;
            }
            k += groups[i].Length;
        }
        return true;
    }

    public int Find(int[] nums, int k, int[] g) {
        int m = g.Length, n = nums.Length;
        if (k + g.Length > nums.Length) {
            return -1;
        }
        int[] pi = new int[m];
        for (int i = 1, j = 0; i < m; i++) {
            while (j > 0 && g[i] != g[j]) {
                j = pi[j - 1];
            }
            if (g[i] == g[j]) {
                j++;
            }
            pi[i] = j;
        }
        for (int i = k, j = 0; i < n; i++) {
            while (j > 0 && nums[i] != g[j]) {
                j = pi[j - 1];
            }
            if (nums[i] == g[j]) {
                j++;
            }
            if (j == m) {
                return i - m + 1;
            }
        }
        return -1;
    }
}
```

```C [sol2-C]
int find(const int *nums, int numsSize, int k, const int *g, int gSize) {
    int m = gSize, n = numsSize;
    if (k + m > n) {
        return -1;
    }
    int pi[m];
    pi[0] = 0;
    for (int i = 1, j = 0; i < m; i++) {
        while (j > 0 && g[i] != g[j]) {
            j = pi[j - 1];
        }
        if (g[i] == g[j]) {
            j++;
        }
        pi[i] = j;
    }
    for (int i = k, j = 0; i < n; i++) {
        while (j > 0 && nums[i] != g[j]) {
            j = pi[j - 1];
        }
        if (nums[i] == g[j]) {
            j++;
        }
        if (j == m) {
            return i - m + 1;
        }
    }
    return -1;
}

bool canChoose(int** groups, int groupsSize, int* groupsColSize, int* nums, int numsSize) {
    int k = 0;
    for (int i = 0; i < groupsSize; i++) {
        k = find(nums, numsSize, k, groups[i], groupsColSize[i]);
        if (k == -1) {
            return false;
        }
        k += groupsColSize[i];
    }
    return true;
}
```

```JavaScript [sol2-JavaScript]
var canChoose = function(groups, nums) {
    let k = 0;
    for (let i = 0; i < groups.length; i++) {
        k = find(nums, k, groups[i]);
        if (k == -1) {
            return false;
        }
        k += groups[i].length;
    }
    return true;
}

const find = (nums, k, g) => {
    let m = g.length, n = nums.length;
    if (k + g.length > nums.length) {
        return -1;
    }
    const pi = new Array(m).fill(0);
    for (let i = 1, j = 0; i < m; i++) {
        while (j > 0 && g[i] !== g[j]) {
            j = pi[j - 1];
        }
        if (g[i] === g[j]) {
            j++;
        }
        pi[i] = j;
    }
    for (let i = k, j = 0; i < n; i++) {
        while (j > 0 && nums[i] !== g[j]) {
            j = pi[j - 1];
        }
        if (nums[i] === g[j]) {
            j++;
        }
        if (j === m) {
            return i - m + 1;
        }
    }
    return -1;
};
```

**复杂度分析**

+ 时间复杂度：$O(m + \sum g_i)$，其中 $m$ 是数组 $\textit{nums}$ 的长度，$g_i$ 是数组 $\textit{groups}[i]$ 的长度。最坏情况下，每一个 $\textit{groups}[i]$ 都调用一次 $\text{find}$，因此总时间复杂度为 $O(m + \sum g_i)$。

+ 空间复杂度：$O(\max g_i)$。对 $\textit{groups}[i]$ 调用一次 KMP 算法需要申请 $O(g_i)$ 的空间。
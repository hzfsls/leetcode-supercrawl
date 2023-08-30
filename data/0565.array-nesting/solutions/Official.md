#### 方法一：图

遍历数组，从 $i$ 向 $\textit{nums}[i]$ 连边，我们可以得到一张有向图。

由于题目保证 $\textit{nums}$ 中不含有重复的元素，因此有向图中每个点的出度和入度均为 $1$。

在这种情况下，有向图必然由一个或多个环组成。我们可以遍历 $\textit{nums}$，找到节点个数最大的环。

代码实现时需要用一个 $\textit{vis}$ 数组来标记访问过的节点。

```Python [sol1-Python3]
class Solution:
    def arrayNesting(self, nums: List[int]) -> int:
        ans, n = 0, len(nums)
        vis = [False] * n
        for i in range(n):
            cnt = 0
            while not vis[i]:
                vis[i] = True
                i = nums[i]
                cnt += 1
            ans = max(ans, cnt)
        return ans
```

```C++ [sol1-C++]
class Solution {
public:
    int arrayNesting(vector<int> &nums) {
        int ans = 0, n = nums.size();
        vector<int> vis(n);
        for (int i = 0; i < n; ++i) {
            int cnt = 0;
            while (!vis[i]) {
                vis[i] = true;
                i = nums[i];
                ++cnt;
            }
            ans = max(ans, cnt);
        }
        return ans;
    }
};
```

```Java [sol1-Java]
class Solution {
    public int arrayNesting(int[] nums) {
        int ans = 0, n = nums.length;
        boolean[] vis = new boolean[n];
        for (int i = 0; i < n; ++i) {
            int cnt = 0;
            while (!vis[i]) {
                vis[i] = true;
                i = nums[i];
                ++cnt;
            }
            ans = Math.max(ans, cnt);
        }
        return ans;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int ArrayNesting(int[] nums) {
        int ans = 0, n = nums.Length;
        bool[] vis = new bool[n];
        for (int i = 0; i < n; ++i) {
            int cnt = 0;
            while (!vis[i]) {
                vis[i] = true;
                i = nums[i];
                ++cnt;
            }
            ans = Math.Max(ans, cnt);
        }
        return ans;
    }
}
```

```go [sol1-Golang]
func arrayNesting(nums []int) (ans int) {
    vis := make([]bool, len(nums))
    for i := range vis {
        cnt := 0
        for !vis[i] {
            vis[i] = true
            i = nums[i]
            cnt++
        }
        if cnt > ans {
            ans = cnt
        }
    }
    return
}
```

```C [sol1-C]
#define MAX(a, b) ((a) > (b) ? (a) : (b))

int arrayNesting(int* nums, int numsSize){
    int ans = 0;
    bool *vis = (bool *)malloc(sizeof(bool) * numsSize);
    memset(vis, 0, sizeof(bool) * numsSize);
    for (int i = 0; i < numsSize; ++i) {
        int cnt = 0;
        while (!vis[i]) {
            vis[i] = true;
            i = nums[i];
            ++cnt;
        }
        ans = MAX(ans, cnt);
    }
    free(vis);
    return ans;
}
```

```JavaScript [sol1-JavaScript]
var arrayNesting = function(nums) {
    let ans = 0, n = nums.length;
    const vis = new Array(n).fill(0);
    for (let i = 0; i < n; ++i) {
        let cnt = 0;
        while (!vis[i]) {
            vis[i] = true;
            i = nums[i];
            ++cnt;
        }
        ans = Math.max(ans, cnt);
    }
    return ans;
};
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 是数组 $\textit{nums}$ 的长度。

- 空间复杂度：$O(n)$。

#### 方法二：原地标记

利用「$\textit{nums}$ 中的元素大小在 $[0, n-1]$ 之间」这一条件，我们可以省略 $\textit{vis}$ 数组，改为标记 $\textit{nums}[i] = n$，来实现和 $\textit{vis}$ 数组同样的功能。

```Python [sol2-Python3]
class Solution:
    def arrayNesting(self, nums: List[int]) -> int:
        ans, n = 0, len(nums)
        for i in range(n):
            cnt = 0
            while nums[i] < n:
                num = nums[i]
                nums[i] = n
                i = num
                cnt += 1
            ans = max(ans, cnt)
        return ans
```

```C++ [sol2-C++]
class Solution {
public:
    int arrayNesting(vector<int> &nums) {
        int ans = 0, n = nums.size();
        for (int i = 0; i < n; ++i) {
            int cnt = 0;
            while (nums[i] < n) {
                int num = nums[i];
                nums[i] = n;
                i = num;
                ++cnt;
            }
            ans = max(ans, cnt);
        }
        return ans;
    }
};
```

```Java [sol2-Java]
class Solution {
    public int arrayNesting(int[] nums) {
        int ans = 0, n = nums.length;
        for (int i = 0; i < n; ++i) {
            int cnt = 0;
            while (nums[i] < n) {
                int num = nums[i];
                nums[i] = n;
                i = num;
                ++cnt;
            }
            ans = Math.max(ans, cnt);
        }
        return ans;
    }
}
```

```C# [sol2-C#]
public class Solution {
    public int ArrayNesting(int[] nums) {
        int ans = 0, n = nums.Length;
        for (int i = 0; i < n; ++i) {
            int cnt = 0;
            while (nums[i] < n) {
                int num = nums[i];
                nums[i] = n;
                i = num;
                ++cnt;
            }
            ans = Math.Max(ans, cnt);
        }
        return ans;
    }
}
```

```go [sol2-Golang]
func arrayNesting(nums []int) (ans int) {
    n := len(nums)
    for i := range nums {
        cnt := 0
        for nums[i] < n {
            i, nums[i] = nums[i], n
            cnt++
        }
        if cnt > ans {
            ans = cnt
        }
    }
    return
}
```

```C [sol2-C]
#define MAX(a, b) ((a) > (b) ? (a) : (b))

int arrayNesting(int* nums, int numsSize){
    int ans = 0;
    for (int i = 0; i < numsSize; ++i) {
        int cnt = 0;
        while (nums[i] < numsSize) {
            int num = nums[i];
            nums[i] = numsSize;
            i = num;
            ++cnt;
        }
        ans = MAX(ans, cnt);
    }
    return ans;
}
```

```JavaScript [sol2-JavaScript]
var arrayNesting = function(nums) {
    let ans = 0, n = nums.length;
    for (let i = 0; i < n; ++i) {
        let cnt = 0;
        while (nums[i] < n) {
            const num = nums[i];
            nums[i] = n;
            i = num;
            ++cnt;
        }
        ans = Math.max(ans, cnt);
    }
    return ans;
};
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 是数组 $\textit{nums}$ 的长度。

- 空间复杂度：$O(1)$，我们只需要常数的空间保存若干变量。
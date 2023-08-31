## [1995.统计特殊四元组 中文官方题解](https://leetcode.cn/problems/count-special-quadruplets/solutions/100000/tong-ji-te-shu-si-yuan-zu-by-leetcode-so-50e2)
#### 方法一：直接枚举

**思路与算法**

最简单的方法是直接枚举四个下标 $a, b, c, d$ 并进行判断。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    int countQuadruplets(vector<int>& nums) {
        int n = nums.size();
        int ans = 0;
        for (int a = 0; a < n; ++a) {
            for (int b = a + 1; b < n; ++b) {
                for (int c = b + 1; c < n; ++c) {
                    for (int d = c + 1; d < n; ++d) {
                        if (nums[a] + nums[b] + nums[c] == nums[d]) {
                            ++ans;
                        }
                    }
                }
            }
        }
        return ans;
    }
};
```

```Java [sol1-Java]
class Solution {
    public int countQuadruplets(int[] nums) {
        int n = nums.length;
        int ans = 0;
        for (int a = 0; a < n; ++a) {
            for (int b = a + 1; b < n; ++b) {
                for (int c = b + 1; c < n; ++c) {
                    for (int d = c + 1; d < n; ++d) {
                        if (nums[a] + nums[b] + nums[c] == nums[d]) {
                            ++ans;
                        }
                    }
                }
            }
        }
        return ans;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int CountQuadruplets(int[] nums) {
        int n = nums.Length;
        int ans = 0;
        for (int a = 0; a < n; ++a) {
            for (int b = a + 1; b < n; ++b) {
                for (int c = b + 1; c < n; ++c) {
                    for (int d = c + 1; d < n; ++d) {
                        if (nums[a] + nums[b] + nums[c] == nums[d]) {
                            ++ans;
                        }
                    }
                }
            }
        }
        return ans;
    }
}
```

```Python [sol1-Python3]
class Solution:
    def countQuadruplets(self, nums: List[int]) -> int:
        n = len(nums)
        ans = 0
        for a in range(n):
            for b in range(a + 1, n):
                for c in range(b + 1, n):
                    for d in range(c + 1, n):
                        if nums[a] + nums[b] + nums[c] == nums[d]:
                            ans += 1
        return ans
```

```go [sol1-Golang]
func countQuadruplets(nums []int) (ans int) {
    for a, x := range nums {
        for b := a + 1; b < len(nums); b++ {
            for c := b + 1; c < len(nums); c++ {
                for _, y := range nums[c+1:] {
                    if x+nums[b]+nums[c] == y {
                        ans++
                    }
                }
            }
        }
    }
    return
}
```

```C [sol1-C]
int countQuadruplets(int* nums, int numsSize){
    int ans = 0;
    for (int a = 0; a < numsSize; ++a) {
        for (int b = a + 1; b < numsSize; ++b) {
            for (int c = b + 1; c < numsSize; ++c) {
                for (int d = c + 1; d < numsSize; ++d) {
                    if (nums[a] + nums[b] + nums[c] == nums[d]) {
                        ++ans;
                    }
                }
            }
        }
    }
    return ans;
}
```

**复杂度分析**

- 时间复杂度：$O(n^4)$，其中 $n$ 是数组 $\textit{nums}$ 的长度。

- 空间复杂度：$O(1)$。

#### 方法二：使用哈希表存储 $\textit{nums}[d]$

**思路与算法**

如果我们已经枚举了前三个下标 $a, b, c$，那么就已经知道了等式左侧 $\textit{nums}[a] + \textit{nums}[b] + \textit{nums}[c]$ 的值，即为 $\textit{nums}[d]$ 的值。对于下标 $d$ 而言，它的取值范围是 $c < d < n$，那么我们可以使用哈希表统计数组 $\textit{nums}[c + 1]$ 到 $\textit{nums}[n - 1]$ 中每个元素出现的次数。这样一来，我们就可以直接从哈希表中获得满足等式的 $d$ 的个数，而不需要在 $[c+1, n-1]$ 的范围内进行枚举了。

**细节**

在枚举前三个下标 $a, b, c$ 时，我们可以先**逆序**枚举 $c$。在 $c$ 减小的过程中，$d$ 的取值范围是逐渐增大的：即从 $c+1$ 减小到 $c$ 时，$d$ 的取值范围中多了 $c+1$ 这一项，而其余的项不变。因此我们只需要将 $\textit{nums}[c + 1]$ 加入哈希表即可。

在这之后，我们就可以枚举 $a, b$ 并使用哈希表计算答案了。

**代码**

```C++ [sol2-C++]
class Solution {
public:
    int countQuadruplets(vector<int>& nums) {
        int n = nums.size();
        int ans = 0;
        unordered_map<int, int> cnt;
        for (int c = n - 2; c >= 2; --c) {
            ++cnt[nums[c + 1]];
            for (int a = 0; a < c; ++a) {
                for (int b = a + 1; b < c; ++b) {
                    if (int sum = nums[a] + nums[b] + nums[c]; cnt.count(sum)) {
                        ans += cnt[sum];
                    }
                }
            }
        }
        return ans;
    }
};
```

```Java [sol2-Java]
class Solution {
    public int countQuadruplets(int[] nums) {
        int n = nums.length;
        int ans = 0;
        Map<Integer, Integer> cnt = new HashMap<Integer, Integer>();
        for (int c = n - 2; c >= 2; --c) {
            cnt.put(nums[c + 1], cnt.getOrDefault(nums[c + 1], 0) + 1);
            for (int a = 0; a < c; ++a) {
                for (int b = a + 1; b < c; ++b) {
                    ans += cnt.getOrDefault(nums[a] + nums[b] + nums[c], 0);
                }
            }
        }
        return ans;
    }
}
```

```C# [sol2-C#]
public class Solution {
    public int CountQuadruplets(int[] nums) {
        int n = nums.Length;
        int ans = 0;
        Dictionary<int, int> cnt = new Dictionary<int, int>();
        for (int c = n - 2; c >= 2; --c) {
            if (!cnt.ContainsKey(nums[c + 1])) {
                cnt.Add(nums[c + 1], 1);
            } else {
                ++cnt[nums[c + 1]];
            }
            for (int a = 0; a < c; ++a) {
                for (int b = a + 1; b < c; ++b) {
                    int sum = nums[a] + nums[b] + nums[c];
                    if (cnt.ContainsKey(sum)) {
                        ans += cnt[sum];
                    }
                }
            }
        }
        return ans;
    }
}
```

```Python [sol2-Python3]
class Solution:
    def countQuadruplets(self, nums: List[int]) -> int:
        n = len(nums)
        ans = 0
        cnt = Counter()
        for c in range(n - 2, 1, -1):
            cnt[nums[c + 1]] += 1
            for a in range(c):
                for b in range(a + 1, c):
                    if (total := nums[a] + nums[b] + nums[c]) in cnt:
                        ans += cnt[total]
        return ans
```

```go [sol2-Golang]
func countQuadruplets(nums []int) (ans int) {
    cnt := map[int]int{}
    for c := len(nums) - 2; c >= 2; c-- {
        cnt[nums[c+1]]++
        for a, x := range nums[:c] {
            for _, y := range nums[a+1 : c] {
                if sum := x + y + nums[c]; cnt[sum] > 0 {
                    ans += cnt[sum]
                }
            }
        }
    }
    return
}
```

```C [sol2-C]
#define MAXN 500

int countQuadruplets(int* nums, int numsSize){
    int ans = 0;
    int * cnt = (int *)malloc(sizeof(int) * MAXN);
    memset(cnt, 0, sizeof(int) * MAXN);
    for (int c = numsSize - 2; c >= 2; --c) {
        cnt[nums[c + 1]]++;
        for (int a = 0; a < c; ++a) {
            for (int b = a + 1; b < c; ++b) {
                ans += cnt[nums[a] + nums[b] + nums[c]];
            }
        }
    }
    free(cnt);
    return ans;
}
```

**复杂度分析**

- 时间复杂度：$O(n^3)$，其中 $n$ 是数组 $\textit{nums}$ 的长度。我们只需要枚举 $a, b, c$。

- 空间复杂度：$O(\min(n, C))$，其中 $C$ 是数组 $\textit{nums}$ 中的元素范围，在本题中 $C = 100$。在返回最终答案前，哈希表中会存储数组 $\textit{nums}$ 中的所有元素，种类不会超过 $\min(n, C)$ 个。

#### 方法三：使用哈希表存储 $\textit{nums}[d] - \textit{nums}[c]$

**思路与算法**

我们将等式左侧的 $\textit{nums}[c]$ 移动到右侧，变为：

$$
\textit{nums}[a] + \textit{nums}[b] = \textit{nums}[d] - \textit{nums}[c]
$$

如果我们已经枚举了前两个下标 $a, b$，那么就已经知道了等式左侧 $\textit{nums}[a] + \textit{nums}[b]$ 的值，即为 $\textit{nums}[d] - \textit{nums}[c]$ 的值。对于下标 $c, d$ 而言，它的取值范围是 $b < c < d < n$，那么我们可以使用哈希表统计满足上述要求的每一种 $\textit{nums}[d] - \textit{nums}[c]$ 出现的次数。这样一来，我们就可以直接从哈希表中获得满足等式的 $c, d$ 的个数，而不需要在 $[b+1, n-1]$ 的范围内进行枚举了。

**细节**

在枚举前两个下标 $a, b$ 时，我们可以先**逆序**枚举 $b$。在 $b$ 减小的过程中，$c$ 的取值范围是逐渐增大的：即从 $b+1$ 减小到 $b$ 时，$c$ 的取值范围中多了 $b+1$ 这一项，而其余的项不变。因此我们只需要将所有满足 $c=b+1$ 且 $d>c$ 的 $c, d$ 对应的 $\textit{nums}[d] - \textit{nums}[c]$ 加入哈希表即可。

在这之后，我们就可以枚举 $a$ 并使用哈希表计算答案了。

**代码**

```C++ [sol3-C++]
class Solution {
public:
    int countQuadruplets(vector<int>& nums) {
        int n = nums.size();
        int ans = 0;
        unordered_map<int, int> cnt;
        for (int b = n - 3; b >= 1; --b) {
            for (int d = b + 2; d < n; ++d) {
                ++cnt[nums[d] - nums[b + 1]];
            }
            for (int a = 0; a < b; ++a) {
                if (int sum = nums[a] + nums[b]; cnt.count(sum)) {
                    ans += cnt[sum];
                }
            }
        }
        return ans;
    }
};
```

```Java [sol3-Java]
class Solution {
    public int countQuadruplets(int[] nums) {
        int n = nums.length;
        int ans = 0;
        Map<Integer, Integer> cnt = new HashMap<Integer, Integer>();
        for (int b = n - 3; b >= 1; --b) {
            for (int d = b + 2; d < n; ++d) {
                cnt.put(nums[d] - nums[b + 1], cnt.getOrDefault(nums[d] - nums[b + 1], 0) + 1);
            }
            for (int a = 0; a < b; ++a) {
                ans += cnt.getOrDefault(nums[a] + nums[b], 0);
            }
        }
        return ans;
    }
}
```

```C# [sol3-C#]
public class Solution {
    public int CountQuadruplets(int[] nums) {
        int n = nums.Length;
        int ans = 0;
        Dictionary<int, int> cnt = new Dictionary<int, int>();
        for (int b = n - 3; b >= 1; --b) {
            for (int d = b + 2; d < n; ++d) {
                int difference = nums[d] - nums[b + 1];
                if (!cnt.ContainsKey(difference)) {
                    cnt.Add(difference, 1);
                } else {
                    ++cnt[difference];
                }
            }
            for (int a = 0; a < b; ++a) {
                int sum = nums[a] + nums[b];
                if (cnt.ContainsKey(sum)) {
                    ans += cnt[sum];
                }
            }
        }
        return ans;
    }
}
```

```Python [sol3-Python3]
class Solution:
    def countQuadruplets(self, nums: List[int]) -> int:
        n = len(nums)
        ans = 0
        cnt = Counter()
        for b in range(n - 3, 0, -1):
            for d in range(b + 2, n):
                cnt[nums[d] - nums[b + 1]] += 1
            for a in range(b):
                if (total := nums[a] + nums[b]) in cnt:
                    ans += cnt[total]
        return ans
```

```go [sol3-Golang]
func countQuadruplets(nums []int) (ans int) {
    cnt := map[int]int{}
    for b := len(nums) - 3; b >= 1; b-- {
        for _, x := range nums[b+2:] {
            cnt[x-nums[b+1]]++
        }
        for _, x := range nums[:b] {
            if sum := x + nums[b]; cnt[sum] > 0 {
                ans += cnt[sum]
            }
        }
    }
    return
}
```

```C [sol3-C]
#define MAXN 500

int countQuadruplets(int* nums, int numsSize){
    int ans = 0;
    int * cnt = (int *)malloc(sizeof(int) * MAXN);
    memset(cnt, 0, sizeof(int) * MAXN);
    for (int b = numsSize - 3; b >= 1; --b) {
        for (int d = b + 2; d < numsSize; ++d) {
            if (nums[d] >= nums[b + 1]) {
                ++cnt[nums[d] - nums[b + 1]];
            }
        }
        for (int a = 0; a < b; ++a) {
            ans += cnt[nums[a] + nums[b]];
        }
    }
    free(cnt);
    return ans;
}
```

**复杂度分析**

- 时间复杂度：$O(n^2)$，其中 $n$ 是数组 $\textit{nums}$ 的长度。我们只需要枚举 $a, b, d$，并且 $a$ 和 $d$ 的枚举没有嵌套关系。

- 空间复杂度：$O(\min(n, C)^2)$，其中 $C$ 是数组 $\textit{nums}$ 中的元素范围，在本题中 $C = 100$。在返回最终答案前，哈希表中会存储数组 $\textit{nums}$ 中两个下标不同元素的差值，种类不会超过 $\dfrac{\min(n, C)(\min(n, C) - 1)}{2} = O(\min(n, C)^2)$ 个。
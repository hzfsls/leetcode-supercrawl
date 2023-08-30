#### 方法一：多次遍历 + 枚举

**思路与算法**

要想判断某个子数组是否可以重新排列成等差数列，最简单的方法是建立一个等长度的临时数组，将子数组进行拷贝并排序。对于排完序后的子数组，我们只需要进行一次遍历，判断相邻两个元素的差值是否保持不变，就能判断出它是否为等差数列。

然而这样做的单次时间复杂度是 $O(l \log l)$，其中 $l$ 是子数组的长度。我们可以给出时间复杂度更低的 $O(l)$ 算法。

我们首先进行一次遍历，找到子数组中的**最小值** $a$ 和**最大值** $b$。显然，$a$ 和 $b$ 就是等差数列的**首项**和**末项**，并且 $d = \dfrac{b-a}{l-1}$ 就是等差数列的**公差**。如果 $b-a$ 不能被 $l-1$ 整除，那么我们直接知道子数组不可能重新排列成等差数列。

如果 $a = b$（即 $d=0$），那么子数组中的每个元素都应该相同，说明它是一个等差数列。

否则，我们已经知道了等差数列的**首项**、**公差**和**长度**，这个等差数列**唯一确定**。我们再进行一次遍历，对于遍历到的元素 $x$，我们可以通过：

$$
t = \frac{x-a}{d}
$$

获取它是等差数列中的第 $t~(0 \leq t < l)$ 项。如果 $x-a$ 不能被 $d$ 整除，那么我们同样知道子数组不可能重新排列成等差数列，可以退出遍历。否则，当我们遍历完整个子数组后，第 $0, 1, 2, \cdots, l-1$ 项应该均出现了一次，这里我们可以使用哈希表或者一个长度为 $l$ 的数组进行判断。

这样一来，我们使用两次遍历以及一个长度为 $l$ 的辅助数组，就可以判断子数组是否可以重新排列成等差数列，时间复杂度为 $O(l)$。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    vector<bool> checkArithmeticSubarrays(vector<int>& nums, vector<int>& l, vector<int>& r) {
        int n = l.size();
        vector<bool> ans;
        for (int i = 0; i < n; ++i) {
            int left = l[i], right = r[i];
            int minv = *min_element(nums.begin() + left, nums.begin() + right + 1);
            int maxv = *max_element(nums.begin() + left, nums.begin() + right + 1);

            if (minv == maxv) {
                ans.push_back(true);
                continue;
            }
            if ((maxv - minv) % (right - left) != 0) {
                ans.push_back(false);
                continue;
            }

            int d = (maxv - minv) / (right - left);
            bool flag = true;
            vector<int> seen(right - left + 1);
            for (int j = left; j <= right; ++j) {
                if ((nums[j] - minv) % d != 0) {
                    flag = false;
                    break;
                }
                int t = (nums[j] - minv) / d;
                if (seen[t]) {
                    flag = false;
                    break;
                }
                seen[t] = true;
            }
            ans.push_back(flag);
        }
        return ans;
    }
};
```

```Java [sol1-Java]
class Solution {
    public List<Boolean> checkArithmeticSubarrays(int[] nums, int[] l, int[] r) {
        int n = l.length;
        List<Boolean> ans = new ArrayList<Boolean>();
        for (int i = 0; i < n; ++i) {
            int left = l[i], right = r[i];
            int minv = nums[left], maxv = nums[left];
            for (int j = left + 1; j <= right; ++j) {
                minv = Math.min(minv, nums[j]);
                maxv = Math.max(maxv, nums[j]);
            }

            if (minv == maxv) {
                ans.add(true);
                continue;
            }
            if ((maxv - minv) % (right - left) != 0) {
                ans.add(false);
                continue;
            }

            int d = (maxv - minv) / (right - left);
            boolean flag = true;
            boolean[] seen = new boolean[right - left + 1];
            for (int j = left; j <= right; ++j) {
                if ((nums[j] - minv) % d != 0) {
                    flag = false;
                    break;
                }
                int t = (nums[j] - minv) / d;
                if (seen[t]) {
                    flag = false;
                    break;
                }
                seen[t] = true;
            }
            ans.add(flag);
        }
        return ans;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public IList<bool> CheckArithmeticSubarrays(int[] nums, int[] l, int[] r) {
        int n = l.Length;
        IList<bool> ans = new List<bool>();
        for (int i = 0; i < n; ++i) {
            int left = l[i], right = r[i];
            int minv = nums[left], maxv = nums[left];
            for (int j = left + 1; j <= right; ++j) {
                minv = Math.Min(minv, nums[j]);
                maxv = Math.Max(maxv, nums[j]);
            }

            if (minv == maxv) {
                ans.Add(true);
                continue;
            }
            if ((maxv - minv) % (right - left) != 0) {
                ans.Add(false);
                continue;
            }

            int d = (maxv - minv) / (right - left);
            bool flag = true;
            bool[] seen = new bool[right - left + 1];
            for (int j = left; j <= right; ++j) {
                if ((nums[j] - minv) % d != 0) {
                    flag = false;
                    break;
                }
                int t = (nums[j] - minv) / d;
                if (seen[t]) {
                    flag = false;
                    break;
                }
                seen[t] = true;
            }
            ans.Add(flag);
        }
        return ans;
    }
}
```

```Python [sol1-Python3]
class Solution:
    def checkArithmeticSubarrays(self, nums: List[int], l: List[int], r: List[int]) -> List[bool]:
        ans = list()
        for left, right in zip(l, r):
            minv = min(nums[left:right+1])
            maxv = max(nums[left:right+1])
            
            if minv == maxv:
                ans.append(True)
                continue
            if (maxv - minv) % (right - left) != 0:
                ans.append(False)
                continue
            
            d = (maxv - minv) // (right - left)
            flag = True
            seen = set()
            for j in range(left, right + 1):
                if (nums[j] - minv) % d != 0:
                    flag = False
                    break
                t = (nums[j] - minv) // d
                if t in seen:
                    flag = False
                    break
                seen.add(t)
            ans.append(flag)
        
        return ans
```

```C [sol1-C]
#define MAX(a, b) ((a) > (b) ? (a) : (b))
#define MIN(a, b) ((a) < (b) ? (a) : (b))

bool* checkArithmeticSubarrays(int* nums, int numsSize, int* l, int lSize, int* r, int rSize, int* returnSize){
    int n = lSize;
    bool *ans = (bool *)calloc(n, sizeof(bool));
    int pos = 0;
    for (int i = 0; i < n; ++i) {
        int left = l[i], right = r[i];
        int minv = INT_MAX, maxv = INT_MIN;
        for (int j = left; j <= right; j++) {
            minv = MIN(minv, nums[j]);
            maxv = MAX(maxv, nums[j]);
        }        
        if (minv == maxv) {
            ans[pos++] = true;
            continue;
        }
        if ((maxv - minv) % (right - left) != 0) {
            ans[pos++] = false;
            continue;
        }
        
        int d = (maxv - minv) / (right - left);
        bool flag = true;
        int seen[right - left + 1];
        memset(seen, 0, sizeof(seen));
        for (int j = left; j <= right; ++j) {
            if ((nums[j] - minv) % d != 0) {
                flag = false;
                break;
            }
            int t = (nums[j] - minv) / d;
            if (seen[t]) {
                flag = false;
                break;
            }
            seen[t] = true;
        }
        ans[pos++] = flag;
    }
    *returnSize = pos;
    return ans;
}
```

```JavaScript [sol1-JavaScript]
var checkArithmeticSubarrays = function(nums, l, r) {
    const n = l.length;
    const ans = [];
    for (let i = 0; i < n; ++i) {
        let left = l[i], right = r[i];
        let minv = nums[left], maxv = nums[left];
        for (let j = left + 1; j <= right; ++j) {
            minv = Math.min(minv, nums[j]);
            maxv = Math.max(maxv, nums[j]);
        }

        if (minv === maxv) {
            ans.push(true);
            continue;
        }
        if ((maxv - minv) % (right - left) !== 0) {
            ans.push(false);
            continue;
        }

        const d = (maxv - minv) / (right - left);
        let flag = true;
        const seen = new Array(right - left + 1).fill(0);
        for (let j = left; j <= right; ++j) {
            if ((nums[j] - minv) % d !== 0) {
                flag = false;
                break;
            }
            const t = Math.floor((nums[j] - minv) / d);
            if (seen[t]) {
                flag = false;
                break;
            }
            seen[t] = true;
        }
        ans.push(flag);
    }
    return ans;
};
```

```go [sol1-Golang]
func checkArithmeticSubarrays(nums []int, l []int, r []int) []bool {
    ans := make([]bool, len(l))
    for i := range l {
        ans[i] = isArithmetic(nums[l[i] : r[i]+1])
    }
    return ans
}

func isArithmetic(nums []int) bool {
    n := len(nums)
    max, min := nums[0], nums[0]
    for _, v := range nums {
        if v > max {
            max = v
        }
        if v < min {
            min = v
        }
    }
    if max == min {
        return true
    }
    d := (max - min) / (n - 1)
    if (max - min) != d*(n-1) {
        return false
    }
    m := make(map[int]struct{})
    for _, v := range nums {
        m[v] = struct{}{}
    }
    for n--; n > 0; n-- {
        min += d
        if _, ok := m[min]; !ok {
            return false
        }
    }
    return true
}
```

**复杂度分析**

- 时间复杂度：$O(nm)$。其中 $n$ 是数组 $\textit{nums}$ 的长度，$m$ 是查询的次数。

- 空间复杂度：$O(n)$，即为辅助数组或哈希表需要使用的空间。
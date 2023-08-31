## [594.最长和谐子序列 中文官方题解](https://leetcode.cn/problems/longest-harmonious-subsequence/solutions/100000/zui-chang-he-xie-zi-xu-lie-by-leetcode-s-8cyr)
#### 方法一：枚举

**思路与算法**

我们可以枚举数组中的每一个元素，对于当前枚举的元素 $x$，它可以和 $x + 1$ 组成和谐子序列。我们只需要在数组中找出等于 $x$ 或 $x + 1$ 的元素个数，就可以得到以 $x$ 为最小值的和谐子序列的长度。
+ 实际处理时，我们可以将数组按照从小到大进行排序，我们只需要依次找到相邻两个连续相同元素的子序列，检查该这两个子序列的元素的之差是否为 $1$。
+ 利用类似与滑动窗口的做法，$\textit{begin}$ 指向第一个连续相同元素的子序列的第一个元素，$\textit{end}$ 指向相邻的第二个连续相同元素的子序列的末尾元素，如果满足二者的元素之差为 $1$，则当前的和谐子序列的长度即为两个子序列的长度之和，等于 $\textit{end} - \textit{begin} + 1$。

**代码**

```Java [sol1-Java]
class Solution {
    public int findLHS(int[] nums) {
        Arrays.sort(nums);
        int begin = 0;
        int res = 0;
        for (int end = 0; end < nums.length; end++) {
            while (nums[end] - nums[begin] > 1) {
                begin++;
            }
            if (nums[end] - nums[begin] == 1) {
                res = Math.max(res, end - begin + 1);
            }
        }
        return res;
    }
}
```

```C++ [sol1-C++]
class Solution {
public:
    int findLHS(vector<int>& nums) {
        sort(nums.begin(),nums.end());
        int begin = 0;
        int res = 0;
        for (int end = 0; end < nums.size(); end++) {
            while (nums[end] - nums[begin] > 1) {
                begin++;
            }
            if (nums[end] - nums[begin] == 1) {
                res = max(res, end - begin + 1);
            }
        }
        return res;
    }
};
```

```C# [sol1-C#]
public class Solution {
    public int FindLHS(int[] nums) {
        Array.Sort(nums);
        int begin = 0;
        int res = 0;
        for (int end = 0; end < nums.Length; end++) {
            while (nums[end] - nums[begin] > 1) {
                begin++;
            }
            if (nums[end] - nums[begin] == 1) {
                res = Math.Max(res, end - begin + 1);
            }
        }
        return res;
    }
}
```

```Python [sol1-Python3]
class Solution:
    def findLHS(self, nums: List[int]) -> int:
        nums.sort()
        res, begin = 0, 0
        for end in range(len(nums)):
            while nums[end] - nums[begin] > 1:
                begin += 1
            if nums[end] - nums[begin] == 1:
                res = max(res, end - begin + 1)
        return res
```

```JavaScript [sol1-JavaScript]
var findLHS = function(nums) {
    nums.sort((a, b) => a - b);
    let begin = 0;
    let res = 0;
    for (let end = 0; end < nums.length; end++) {
        while (nums[end] - nums[begin] > 1) {
            begin++;
        }
        if (nums[end] - nums[begin] === 1) {
            res = Math.max(res, end - begin + 1);
        }
    }
    return res;
};
```

```go [sol1-Golang]
func findLHS(nums []int) (ans int) {
    sort.Ints(nums)
    begin := 0
    for end, num := range nums {
        for num-nums[begin] > 1 {
            begin++
        }
        if num-nums[begin] == 1 && end-begin+1 > ans {
            ans = end - begin + 1
        }
    }
    return
}
```

**复杂度分析**

- 时间复杂度：$O(N\log N)$，其中 $N$ 为数组的长度。我们首先需要对数组进行排序，花费的时间复杂度为 $O(N\log N)$，我们需要利用双指针遍历数组花费的时间为 $O(2N)$，总的时间复杂度 $T(N) = O(N\log N) + O(2N) = O(N\log N)$。

- 空间复杂度：$O(1)$，需要常数个空间保存中间变量。

#### 方法二：哈希表

**思路与算法**

在方法一中，我们枚举了 $x$ 后，遍历数组找出所有的 $x$ 和 $x + 1$的出现的次数。我们也可以用一个哈希映射来存储每个数出现的次数，这样就能在 $O(1)$ 的时间内得到 $x$ 和 $x + 1$ 出现的次数。

我们首先遍历一遍数组，得到哈希映射。随后遍历哈希映射，设当前遍历到的键值对为 $(x, \textit{value})$，那么我们就查询 $x + 1$ 在哈希映射中对应的统计次数，就得到了 $x$ 和 $x + 1$ 出现的次数，和谐子序列的长度等于 $x$ 和 $x + 1$ 出现的次数之和。

**代码**

```Java [sol2-Java]
class Solution {
    public int findLHS(int[] nums) {
        HashMap <Integer, Integer> cnt = new HashMap <>();
        int res = 0;
        for (int num : nums) {
            cnt.put(num, cnt.getOrDefault(num, 0) + 1);
        }
        for (int key : cnt.keySet()) {
            if (cnt.containsKey(key + 1)) {
                res = Math.max(res, cnt.get(key) + cnt.get(key + 1));
            }
        }
        return res;
    }
}
```

```C++ [sol2-C++]
class Solution {
public:
    int findLHS(vector<int>& nums) {
        unordered_map<int, int> cnt;
        int res = 0;
        for (int num : nums) {
            cnt[num]++;
        }
        for (auto [key, val] : cnt) {
            if (cnt.count(key + 1)) {
                res = max(res, val + cnt[key + 1]);
            }
        }
        return res;
    }
};
```

```C# [sol2-C#]
public class Solution {
    public int FindLHS(int[] nums) {
        Dictionary<int, int> dictionary = new Dictionary<int, int>();
        int res = 0;
        foreach (int num in nums) {
            if (dictionary.ContainsKey(num)) {
                dictionary[num]++;
            } else {
                dictionary.Add(num, 1);
            }
        }
        foreach (int key in dictionary.Keys) {
            if (dictionary.ContainsKey(key + 1)) {
                res = Math.Max(res, dictionary[key] + dictionary[key + 1]);
            }
        }
        return res;
    }
}
```

```Python [sol2-Python3]
class Solution:
    def findLHS(self, nums: List[int]) -> int:
        cnt = Counter(nums)
        return max((val + cnt[key + 1] for key, val in cnt.items() if key + 1 in cnt), default=0)
```

```JavaScript [sol2-JavaScript]
var findLHS = function(nums) {
    const cnt = new Map();
    let res = 0;
    for (const num of nums) {
        cnt.set(num, (cnt.get(num) || 0) + 1);
    }
    for (const key of cnt.keys()) {
        if (cnt.has(key + 1)) {
            res = Math.max(res, cnt.get(key) + cnt.get(key + 1));
        }
    }
    return res;
};
```

```go [sol2-Golang]
func findLHS(nums []int) (ans int) {
    cnt := map[int]int{}
    for _, num := range nums {
        cnt[num]++
    }
    for num, c := range cnt {
        if c1 := cnt[num+1]; c1 > 0 && c+c1 > ans {
            ans = c + c1
        }
    }
    return
}
```

**复杂度分析**

- 时间复杂度：$O(N)$，其中 $N$ 为数组的长度。

- 空间复杂度：$O(N)$，其中 $N$ 为数组的长度。数组中最多有 $N$ 个不同元素，因此哈希表最多存储 $N$ 个数据。
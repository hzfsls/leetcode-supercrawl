#### 方法一：哈希表

**思路及算法**

假设原数组的前缀和数组为 $\textit{sum}$，且子数组 $(i,j]$ 的区间和为 $\textit{goal}$，那么 $\textit{sum}[j]-\textit{sum}[i]=\textit{goal}$。因此我们可以枚举 $j$ ，每次查询满足该等式的 $i$ 的数量。

具体地，我们用哈希表记录每一种前缀和出现的次数，假设我们当前枚举到元素 $\textit{nums}[j]$，我们只需要查询哈希表中元素 $\textit{sum}[j]-\textit{goal}$ 的数量即可，这些元素的数量即对应了以当前 $j$ 值为右边界的满足条件的子数组的数量。最后这些元素的总数量即为所有和为 $\textit{goal}$ 的子数组数量。

在实际代码中，我们实时地更新哈希表，以防止出现 $i \geq j$ 的情况。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    int numSubarraysWithSum(vector<int>& nums, int goal) {
        int sum = 0;
        unordered_map<int, int> cnt;
        int ret = 0;
        for (auto& num : nums) {
            cnt[sum]++;
            sum += num;
            ret += cnt[sum - goal];
        }
        return ret;
    }
};
```

```Java [sol1-Java]
class Solution {
    public int numSubarraysWithSum(int[] nums, int goal) {
        int sum = 0;
        Map<Integer, Integer> cnt = new HashMap<Integer, Integer>();
        int ret = 0;
        for (int num : nums) {
            cnt.put(sum, cnt.getOrDefault(sum, 0) + 1);
            sum += num;
            ret += cnt.getOrDefault(sum - goal, 0);
        }
        return ret;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int NumSubarraysWithSum(int[] nums, int goal) {
        int sum = 0;
        Dictionary<int, int> cnt = new Dictionary<int, int>();
        int ret = 0;
        foreach (int num in nums) {
            if (cnt.ContainsKey(sum)) {
                cnt[sum]++;
            } else {
                cnt.Add(sum, 1);
            }
            sum += num;
            int val = 0;
            cnt.TryGetValue(sum - goal, out val);
            ret += val;
        }
        return ret;
    }
}
```

```go [sol1-Golang]
func numSubarraysWithSum(nums []int, goal int) (ans int) {
    cnt := map[int]int{}
    sum := 0
    for _, num := range nums {
        cnt[sum]++
        sum += num
        ans += cnt[sum-goal]
    }
    return
}
```

```JavaScript [sol1-JavaScript]
var numSubarraysWithSum = function(nums, goal) {
    let sum = 0;
    const cnt = new Map();
    let ret = 0;
    for (const num of nums) {
        cnt.set(sum, (cnt.get(sum) || 0) + 1);
        sum += num;
        ret += cnt.get(sum - goal) || 0;
    }
    return ret;
};
```

```C [sol1-C]
struct HashTable {
    int key, val;
    UT_hash_handle hh;
};

int numSubarraysWithSum(int* nums, int numsSize, int goal) {
    int sum = 0;
    struct HashTable* cnt = NULL;
    int ret = 0;
    for (int i = 0; i < numsSize; i++) {
        struct HashTable* tmp;
        HASH_FIND_INT(cnt, &sum, tmp);
        if (tmp == NULL) {
            tmp = malloc(sizeof(struct HashTable));
            tmp->key = sum, tmp->val = 1;
            HASH_ADD_INT(cnt, key, tmp);
        } else {
            tmp->val++;
        }
        sum += nums[i];
        int target = sum - goal;
        HASH_FIND_INT(cnt, &target, tmp);
        if (tmp != NULL) {
            ret += tmp->val;
        }
    }
    return ret;
}
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 为给定数组的长度。对于数组中的每个元素，我们至多只需要插入到哈希表中中一次。

- 空间复杂度：$O(n)$，其中 $n$ 为给定数组的长度。哈希表中至多只存储 $O(n)$ 个元素。

#### 方法二：滑动窗口

**思路及算法**

注意到对于方法一中每一个 $j$，满足 $\textit{sum}[j]-\textit{sum}[i]=\textit{goal}$ 的 $i$ 总是落在一个连续的区间中，$i$ 值取区间中每一个数都满足条件。并且随着 $j$ 右移，其对应的区间的左右端点也将右移，这样我们即可使用滑动窗口解决本题。

具体地，我们令滑动窗口右边界为 $\textit{right}$，使用两个左边界 $\textit{left}_1$ 和 $\textit{left}_2$ 表示左区间 $[\textit{left}_1,\textit{left}_2)$，此时有  $\textit{left}_2-\textit{left}_1$ 个区间满足条件。

在实际代码中，我们需要注意 $\textit{left}_1 \leq \textit{left}_2 \leq \textit{right} + 1$，因此需要在代码中限制 $\textit{left}_1$ 和 $\textit{left}_2$ 不超出范围。

**代码**

```C++ [sol2-C++]
class Solution {
public:
    int numSubarraysWithSum(vector<int>& nums, int goal) {
        int n = nums.size();
        int left1 = 0, left2 = 0, right = 0;
        int sum1 = 0, sum2 = 0;
        int ret = 0;
        while (right < n) {
            sum1 += nums[right];
            while (left1 <= right && sum1 > goal) {
                sum1 -= nums[left1];
                left1++;
            }
            sum2 += nums[right];
            while (left2 <= right && sum2 >= goal) {
                sum2 -= nums[left2];
                left2++;
            }
            ret += left2 - left1;
            right++;
        }
        return ret;
    }
};
```

```Java [sol2-Java]
class Solution {
    public int numSubarraysWithSum(int[] nums, int goal) {
        int n = nums.length;
        int left1 = 0, left2 = 0, right = 0;
        int sum1 = 0, sum2 = 0;
        int ret = 0;
        while (right < n) {
            sum1 += nums[right];
            while (left1 <= right && sum1 > goal) {
                sum1 -= nums[left1];
                left1++;
            }
            sum2 += nums[right];
            while (left2 <= right && sum2 >= goal) {
                sum2 -= nums[left2];
                left2++;
            }
            ret += left2 - left1;
            right++;
        }
        return ret;
    }
}
```

```C# [sol2-C#]
public class Solution {
    public int NumSubarraysWithSum(int[] nums, int goal) {
        int n = nums.Length;
        int left1 = 0, left2 = 0, right = 0;
        int sum1 = 0, sum2 = 0;
        int ret = 0;
        while (right < n) {
            sum1 += nums[right];
            while (left1 <= right && sum1 > goal) {
                sum1 -= nums[left1];
                left1++;
            }
            sum2 += nums[right];
            while (left2 <= right && sum2 >= goal) {
                sum2 -= nums[left2];
                left2++;
            }
            ret += left2 - left1;
            right++;
        }
        return ret;
    }
}
```

```go [sol2-Golang]
func numSubarraysWithSum(nums []int, goal int) (ans int) {
    left1, left2 := 0, 0
    sum1, sum2 := 0, 0
    for right, num := range nums {
        sum1 += num
        for left1 <= right && sum1 > goal {
            sum1 -= nums[left1]
            left1++
        }
        sum2 += num
        for left2 <= right && sum2 >= goal {
            sum2 -= nums[left2]
            left2++
        }
        ans += left2 - left1
    }
    return
}
```

```JavaScript [sol2-JavaScript]
var numSubarraysWithSum = function(nums, goal) {
    const n = nums.length;
    let left1 = 0, left2 = 0, right = 0;
    let sum1 = 0, sum2 = 0;
    let ret = 0;
    while (right < n) {
        sum1 += nums[right];
        while (left1 <= right && sum1 > goal) {
            sum1 -= nums[left1];
            left1++;
        }
        sum2 += nums[right];
        while (left2 <= right && sum2 >= goal) {
            sum2 -= nums[left2];
            left2++;
        }
        ret += left2 - left1;
        right++;
    }
    return ret;
};
```

```C [sol2-C]
int numSubarraysWithSum(int* nums, int numsSize, int goal) {
    int left1 = 0, left2 = 0, right = 0;
    int sum1 = 0, sum2 = 0;
    int ret = 0;
    while (right < numsSize) {
        sum1 += nums[right];
        while (left1 <= right && sum1 > goal) {
            sum1 -= nums[left1];
            left1++;
        }
        sum2 += nums[right];
        while (left2 <= right && sum2 >= goal) {
            sum2 -= nums[left2];
            left2++;
        }
        ret += left2 - left1;
        right++;
    }
    return ret;
}
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 为给定数组的长度。我们至多只需要遍历一次该数组。

- 空间复杂度：$O(1)$。我们只需要常数的空间保存若干变量。
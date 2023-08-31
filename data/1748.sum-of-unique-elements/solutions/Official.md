## [1748.唯一元素的和 中文官方题解](https://leetcode.cn/problems/sum-of-unique-elements/solutions/100000/wei-yi-yuan-su-de-he-by-leetcode-solutio-tueh)
#### 方法一：记录每个元素的出现次数

根据题意，我们可以用一个哈希表记录每个元素值的出现次数，然后遍历哈希表，累加恰好出现一次的元素值，即为答案。

```Python [sol1-Python3]
class Solution:
    def sumOfUnique(self, nums: List[int]) -> int:
        return sum(num for num, cnt in Counter(nums).items() if cnt == 1)
```

```C++ [sol1-C++]
class Solution {
public:
    int sumOfUnique(vector<int> &nums) {
        unordered_map<int, int> cnt;
        for (int num : nums) {
            ++cnt[num];
        }
        int ans = 0;
        for (auto &[num, c] : cnt) {
            if (c == 1) {
                ans += num;
            }
        }
        return ans;
    }
};
```

```Java [sol1-Java]
class Solution {
    public int sumOfUnique(int[] nums) {
        Map<Integer, Integer> cnt = new HashMap<Integer, Integer>();
        for (int num : nums) {
            cnt.put(num, cnt.getOrDefault(num, 0) + 1);
        }
        int ans = 0;
        for (Map.Entry<Integer, Integer> entry : cnt.entrySet()) {
            int num = entry.getKey(), c = entry.getValue();
            if (c == 1) {
                ans += num;
            }
        }
        return ans;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int SumOfUnique(int[] nums) {
        Dictionary<int, int> cnt = new Dictionary<int, int>();
        foreach (int num in nums) {
            if (!cnt.ContainsKey(num)) {
                cnt.Add(num, 0);
            }
            ++cnt[num];
        }
        int ans = 0;
        foreach (KeyValuePair<int, int> pair in cnt) {
            int num = pair.Key, c = pair.Value;
            if (c == 1) {
                ans += num;
            }
        }
        return ans;
    }
}
```

```go [sol1-Golang]
func sumOfUnique(nums []int) (ans int) {
    cnt := map[int]int{}
    for _, num := range nums {
        cnt[num]++
    }
    for num, c := range cnt {
        if c == 1 {
            ans += num
        }
    }
    return
}
```

```C [sol1-C]
typedef struct {
    int key;                  
    int val;
    UT_hash_handle hh;         
} HashEntry;

int sumOfUnique(int* nums, int numsSize){
    HashEntry * cnt = NULL; 
    for (int i = 0; i < numsSize; ++i) {
        HashEntry * pEntry = NULL;
        HASH_FIND(hh, cnt, &nums[i], sizeof(int), pEntry);
        if (NULL == pEntry) {
            pEntry = (HashEntry *)malloc(sizeof(HashEntry));
            pEntry->key = nums[i];
            pEntry->val = 1;
            HASH_ADD(hh, cnt, key, sizeof(int), pEntry);
        } else {
            ++pEntry->val;
        }
    }
    int ans = 0;
    HashEntry *curr, *next;
    HASH_ITER(hh, cnt, curr, next) {
        if (curr->val == 1) {
            ans += curr->key;
        } 
    }
    HASH_ITER(hh, cnt, curr, next)
    {
        HASH_DEL(cnt, curr);  
        free(curr);      
    }
    return ans;
}
```

```JavaScript [sol1-JavaScript]
var sumOfUnique = function(nums) {
    const cnt = new Map();
    for (const num of nums) {
        cnt.set(num, (cnt.get(num) || 0) + 1);
    }
    let ans = 0;
    for (const [num, c] of cnt.entries()) {
        if (c === 1) {
            ans += num;
        }
    }
    return ans;
};
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 是数组 $\textit{nums}$ 的长度。

- 空间复杂度：$O(n)$。哈希表需要 $O(n)$ 的空间。

#### 方法二：记录每个元素的状态 + 一次遍历

方法一需要遍历数组和哈希表各一次，能否做到仅执行一次遍历呢？

我们可以赋给每个元素三个状态：

- $0$：该元素尚未被访问；
- $1$：该元素被访问过一次；
- $2$：该元素被访问超过一次。

我们可以在首次访问一个元素时，将该元素加入答案，然后将该元素状态标记为 $1$。在访问到一个标记为 $1$ 的元素时，由于这意味着该元素出现不止一次，因此将其从答案中减去，并将该元素状态标记为 $2$。

```Python [sol2-Python3]
class Solution:
    def sumOfUnique(self, nums: List[int]) -> int:
        ans = 0
        state = {}
        for num in nums:
            if num not in state:
                ans += num
                state[num] = 1
            elif state[num] == 1:
                ans -= num
                state[num] = 2
        return ans
```

```C++ [sol2-C++]
class Solution {
public:
    int sumOfUnique(vector<int> &nums) {
        int ans = 0;
        unordered_map<int, int> state;
        for (int num : nums) {
            if (state[num] == 0) {
                ans += num;
                state[num] = 1;
            } else if (state[num] == 1) {
                ans -= num;
                state[num] = 2;
            }
        }
        return ans;
    }
};
```

```Java [sol2-Java]
class Solution {
    public int sumOfUnique(int[] nums) {
        int ans = 0;
        Map<Integer, Integer> state = new HashMap<Integer, Integer>();
        for (int num : nums) {
            if (!state.containsKey(num)) {
                ans += num;
                state.put(num, 1);
            } else if (state.get(num) == 1) {
                ans -= num;
                state.put(num, 2);
            }
        }
        return ans;
    }
}
```

```C# [sol2-C#]
public class Solution {
    public int SumOfUnique(int[] nums) {
        int ans = 0;
        Dictionary<int, int> state = new Dictionary<int, int>();
        foreach (int num in nums) {
            if (!state.ContainsKey(num)) {
                ans += num;
                state.Add(num, 1);
            } else if (state[num] == 1) {
                ans -= num;
                state[num] = 2;
            }
        }
        return ans;
    }
}
```

```go [sol2-Golang]
func sumOfUnique(nums []int) (ans int) {
    state := map[int]int{}
    for _, num := range nums {
        if state[num] == 0 {
            ans += num
            state[num] = 1
        } else if state[num] == 1 {
            ans -= num
            state[num] = 2
        }
    }
    return
}
```

```C [sol2-C]
typedef struct {
    int key;                  
    int val;
    UT_hash_handle hh;         
} HashEntry;

int sumOfUnique(int* nums, int numsSize){
    HashEntry * cnt = NULL; 
    int ans = 0;
    for (int i = 0; i < numsSize; ++i) {
        HashEntry * pEntry = NULL;
        HASH_FIND(hh, cnt, &nums[i], sizeof(int), pEntry);
        if (NULL == pEntry) {
            pEntry = (HashEntry *)malloc(sizeof(HashEntry));
            pEntry->key = nums[i];
            pEntry->val = 1;
            ans += nums[i];
            HASH_ADD(hh, cnt, key, sizeof(int), pEntry);
        } else if (pEntry->val == 1){
            ans -= nums[i];
            pEntry->val = 2;
        }
    }
    HashEntry *curr = NULL, *next = NULL;
    HASH_ITER(hh, cnt, curr, next)
    {
        HASH_DEL(cnt, curr);  
        free(curr);      
    }
    return ans;
}
```

```JavaScript [sol2-JavaScript]
var sumOfUnique = function(nums) {
    let ans = 0;
    const state = new Map();
    for (const num of nums) {
        if (!state.has(num)) {
            ans += num;
            state.set(num, 1);
        } else if (state.get(num) === 1) {
            ans -= num;
            state.set(num, 2);
        }
    }
    return ans;
};
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 是数组 $\textit{nums}$ 的长度。

- 空间复杂度：$O(n)$。哈希表需要 $O(n)$ 的空间。
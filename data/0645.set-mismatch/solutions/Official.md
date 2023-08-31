## [645.错误的集合 中文官方题解](https://leetcode.cn/problems/set-mismatch/solutions/100000/cuo-wu-de-ji-he-by-leetcode-solution-1ea4)

#### 方法一：排序

将数组排序之后，比较每对相邻的元素，即可找到错误的集合。

寻找重复的数字较为简单，如果相邻的两个元素相等，则该元素为重复的数字。

寻找丢失的数字相对复杂，可能有以下两种情况：

- 如果丢失的数字大于 $1$ 且小于 $n$，则一定存在相邻的两个元素的差等于 $2$，这两个元素之间的值即为丢失的数字；

- 如果丢失的数字是 $1$ 或 $n$，则需要另外判断。

为了寻找丢失的数字，需要在遍历已排序数组的同时记录上一个元素，然后计算当前元素与上一个元素的差。考虑到丢失的数字可能是 $1$，因此需要将上一个元素初始化为 $0$。

- 当丢失的数字小于 $n$ 时，通过计算当前元素与上一个元素的差，即可得到丢失的数字；

- 如果 $\textit{nums}[n-1] \ne n$，则丢失的数字是 $n$。

```Java [sol1-Java]
class Solution {
    public int[] findErrorNums(int[] nums) {
        int[] errorNums = new int[2];
        int n = nums.length;
        Arrays.sort(nums);
        int prev = 0;
        for (int i = 0; i < n; i++) {
            int curr = nums[i];
            if (curr == prev) {
                errorNums[0] = prev;
            } else if (curr - prev > 1) {
                errorNums[1] = prev + 1;
            }
            prev = curr;
        }
        if (nums[n - 1] != n) {
            errorNums[1] = n;
        }
        return errorNums;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int[] FindErrorNums(int[] nums) {
        int[] errorNums = new int[2];
        int n = nums.Length;
        Array.Sort(nums);
        int prev = 0;
        for (int i = 0; i < n; i++) {
            int curr = nums[i];
            if (curr == prev) {
                errorNums[0] = prev;
            } else if (curr - prev > 1) {
                errorNums[1] = prev + 1;
            }
            prev = curr;
        }
        if (nums[n - 1] != n) {
            errorNums[1] = n;
        }
        return errorNums;
    }
}
```

```C++ [sol1-C++]
class Solution {
public:
    vector<int> findErrorNums(vector<int>& nums) {
        vector<int> errorNums(2);
        int n = nums.size();
        sort(nums.begin(), nums.end());
        int prev = 0;
        for (int i = 0; i < n; i++) {
            int curr = nums[i];
            if (curr == prev) {
                errorNums[0] = prev;
            } else if (curr - prev > 1) {
                errorNums[1] = prev + 1;
            }
            prev = curr;
        }
        if (nums[n - 1] != n) {
            errorNums[1] = n;
        }
        return errorNums;
    }
};
```

```C [sol1-C]
int cmp(int* a, int* b) {
    return *a - *b;
}

int* findErrorNums(int* nums, int numsSize, int* returnSize) {
    int* errorNums = malloc(sizeof(int) * 2);
    *returnSize = 2;
    qsort(nums, numsSize, sizeof(int), cmp);
    int prev = 0;
    for (int i = 0; i < numsSize; i++) {
        int curr = nums[i];
        if (curr == prev) {
            errorNums[0] = prev;
        } else if (curr - prev > 1) {
            errorNums[1] = prev + 1;
        }
        prev = curr;
    }
    if (nums[numsSize - 1] != numsSize) {
        errorNums[1] = numsSize;
    }
    return errorNums;
}
```

```JavaScript [sol1-JavaScript]
var findErrorNums = function(nums) {
    const errorNums = new Array(2).fill(0);
    const n = nums.length;
    nums.sort((a, b) => a - b);
    let prev = 0;
    for (let i = 0; i < n; i++) {
        const curr = nums[i];
        if (curr === prev) {
            errorNums[0] = prev;
        } else if (curr - prev > 1) {
            errorNums[1] = prev + 1;
        }
        prev = curr;
    }
    if (nums[n - 1] !== n) {
        errorNums[1] = n;
    }
    return errorNums;
};
```

```go [sol1-Golang]
func findErrorNums(nums []int) []int {
    ans := make([]int, 2)
    sort.Ints(nums)
    pre := 0
    for _, v := range nums {
        if v == pre {
            ans[0] = v
        } else if v-pre > 1 {
            ans[1] = pre + 1
        }
        pre = v
    }
    n := len(nums)
    if nums[n-1] != n {
        ans[1] = n
    }
    return ans
}
```

**复杂度分析**

- 时间复杂度：$O(n \log n)$，其中 $n$ 是数组 $\textit{nums}$ 的长度。排序需要 $O(n \log n)$ 的时间，遍历数组找到错误的集合需要 $O(n)$ 的时间，因此总时间复杂度是 $O(n \log n)$。

- 空间复杂度：$O(\log n)$，其中 $n$ 是数组 $\textit{nums}$ 的长度。排序需要 $O(\log n)$ 的空间。

#### 方法二：哈希表

重复的数字在数组中出现 $2$ 次，丢失的数字在数组中出现 $0$ 次，其余的每个数字在数组中出现 $1$ 次。因此可以使用哈希表记录每个元素在数组中出现的次数，然后遍历从 $1$ 到 $n$ 的每个数字，分别找到出现 $2$ 次和出现 $0$ 次的数字，即为重复的数字和丢失的数字。

```Java [sol2-Java]
class Solution {
    public int[] findErrorNums(int[] nums) {
        int[] errorNums = new int[2];
        int n = nums.length;
        Map<Integer, Integer> map = new HashMap<Integer, Integer>();
        for (int num : nums) {
            map.put(num, map.getOrDefault(num, 0) + 1);
        }
        for (int i = 1; i <= n; i++) {
            int count = map.getOrDefault(i, 0);
            if (count == 2) {
                errorNums[0] = i;
            } else if (count == 0) {
                errorNums[1] = i;
            }
        }
        return errorNums;
    }
}
```

```C# [sol2-C#]
public class Solution {
    public int[] FindErrorNums(int[] nums) {
        int[] errorNums = new int[2];
        int n = nums.Length;
        Dictionary<int, int> dictionary = new Dictionary<int, int>();
        foreach (int num in nums) {
            if (!dictionary.ContainsKey(num)) {
                dictionary.Add(num, 1);
            } else {
                dictionary[num]++;
            }
        }
        for (int i = 1; i <= n; i++) {
            int count = 0;
            dictionary.TryGetValue(i, out count);
            if (count == 2) {
                errorNums[0] = i;
            } else if (count == 0) {
                errorNums[1] = i;
            }
        }
        return errorNums;
    }
}
```

```C++ [sol2-C++]
class Solution {
public:
    vector<int> findErrorNums(vector<int>& nums) {
        vector<int> errorNums(2);
        int n = nums.size();
        unordered_map<int, int> mp;
        for (auto& num : nums) {
            mp[num]++;
        }
        for (int i = 1; i <= n; i++) {
            int count = mp[i];
            if (count == 2) {
                errorNums[0] = i;
            } else if (count == 0) {
                errorNums[1] = i;
            }
        }
        return errorNums;
    }
};
```

```C [sol2-C]
struct HashTable {
    int key, val;
    UT_hash_handle hh;
};

int cmp(int* a, int* b) {
    return *a - *b;
}

int* findErrorNums(int* nums, int numsSize, int* returnSize) {
    int* errorNums = malloc(sizeof(int) * 2);
    *returnSize = 2;
    struct HashTable* hashTable = NULL;
    for (int i = 0; i < numsSize; i++) {
        struct HashTable* tmp;
        HASH_FIND_INT(hashTable, &nums[i], tmp);
        if (tmp == NULL) {
            tmp = malloc(sizeof(struct HashTable));
            tmp->key = nums[i], tmp->val = 1;
            HASH_ADD_INT(hashTable, key, tmp);
        } else {
            tmp->val++;
        }
    }
    for (int i = 1; i <= numsSize; i++) {
        struct HashTable* tmp;
        HASH_FIND_INT(hashTable, &i, tmp);
        if (tmp == NULL) {
            errorNums[1] = i;
        } else if (tmp->val == 2) {
            errorNums[0] = i;
        }
    }
    return errorNums;
}
```

```JavaScript [sol2-JavaScript]
var findErrorNums = function(nums) {
    const errorNums = new Array(2).fill(0);
    const n = nums.length;
    const map = new Map();
    for (const num of nums) {
        map.set(num, (map.get(num) || 0) + 1);
    }
    for (let i = 1; i <= n; i++) {
        const count = map.get(i) || 0;
        if (count === 2) {
            errorNums[0] = i;
        } else if (count === 0) {
            errorNums[1] = i;
        }
    }
    return errorNums;
};
```

```go [sol2-Golang]
func findErrorNums(nums []int) []int {
    cnt := map[int]int{}
    for _, v := range nums {
        cnt[v]++
    }
    ans := make([]int, 2)
    for i := 1; i <= len(nums); i++ {
        if c := cnt[i]; c == 2 {
            ans[0] = i
        } else if c == 0 {
            ans[1] = i
        }
    }
    return ans
}
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 是数组 $\textit{nums}$ 的长度。需要遍历数组并填入哈希表，然后遍历从 $1$ 到 $n$ 的每个数寻找错误的集合。

- 空间复杂度：$O(n)$，其中 $n$ 是数组 $\textit{nums}$ 的长度。需要创建大小为 $O(n)$ 的哈希表。

#### 方法三：位运算

使用位运算，可以达到 $O(n)$ 的时间复杂度和 $O(1)$ 的空间复杂度。

重复的数字在数组中出现 $2$ 次，丢失的数字在数组中出现 $0$ 次，其余的每个数字在数组中出现 $1$ 次。由此可见，重复的数字和丢失的数字的出现次数的奇偶性相同，且和其余的每个数字的出现次数的奇偶性不同。如果在数组的 $n$ 个数字后面再添加从 $1$ 到 $n$ 的每个数字，得到 $2n$ 个数字，则在 $2n$ 个数字中，重复的数字出现 $3$ 次，丢失的数字出现 $1$ 次，其余的每个数字出现 $2$ 次。根据出现次数的奇偶性，可以使用异或运算求解。

用 $x$ 和 $y$ 分别表示重复的数字和丢失的数字。考虑上述 $2n$ 个数字的异或运算结果 $\textit{xor}$，由于异或运算 $\oplus$ 满足交换律和结合律，且对任何数字 $a$ 都满足 $a \oplus a = 0$ 和 $0 \oplus a = a$，因此 $\textit{xor} = x \oplus x \oplus x \oplus y = x \oplus y$，即 $x$ 和 $y$ 的异或运算的结果。

由于 $x \ne y$，因此 $\textit{xor} \ne 0$，令 $\textit{lowbit} = \textit{xor}~\&~(-\textit{xor})$，则 $\textit{lowbit}$ 为 $x$ 和 $y$ 的二进制表示中的最低不同位，可以用 $\textit{lowbit}$ 区分 $x$ 和 $y$。

得到 $\textit{lowbit}$ 之后，可以将上述 $2n$ 个数字分成两组，第一组的每个数字 $a$ 都满足 $a~\&~\textit{lowbit} = 0$，第二组的每个数字 $b$ 都满足 $b~\&~\textit{lowbit} \ne 0$。

创建两个变量 $\textit{num}_1$ 和 $\textit{num}_2$，初始值都为 $0$，然后再次遍历上述 $2n$ 个数字，对于每个数字 $a$，如果 $a~\&~\textit{lowbit} = 0$，则令 $\textit{num}_1 = \textit{num}_1 \oplus a$，否则令 $\textit{num}_2 = \textit{num}_2 \oplus a$。

遍历结束之后，$\textit{num}_1$ 为第一组的全部数字的异或结果，$\textit{num}_2$ 为第二组的全部数字的异或结果。由于同一个数字只可能出现在其中的一组，且除了 $x$ 和 $y$ 以外，每个数字一定在其中的一组出现 $2$ 次，因此 $\textit{num}_1$ 和 $\textit{num}_2$ 分别对应 $x$ 和 $y$ 中的一个数字，但是具体对应哪个数还未知。

为了知道 $\textit{num}_1$ 和 $\textit{num}_2$ 分别对应 $x$ 和 $y$ 中的哪一个数字，只需要再次遍历数组 $\textit{nums}$ 即可。如果数组中存在元素等于 $\textit{num}_1$，则有 $x=\textit{num}_1$ 和 $y=\textit{num}_2$，否则有 $x=\textit{num}_2$ 和 $y=\textit{num}_1$。

```Java [sol3-Java]
class Solution {
    public int[] findErrorNums(int[] nums) {
        int n = nums.length;
        int xor = 0;
        for (int num : nums) {
            xor ^= num;
        }
        for (int i = 1; i <= n; i++) {
            xor ^= i;
        }
        int lowbit = xor & (-xor);
        int num1 = 0, num2 = 0;
        for (int num : nums) {
            if ((num & lowbit) == 0) {
                num1 ^= num;
            } else {
                num2 ^= num;
            }
        }
        for (int i = 1; i <= n; i++) {
            if ((i & lowbit) == 0) {
                num1 ^= i;
            } else {
                num2 ^= i;
            }
        }
        for (int num : nums) {
            if (num == num1) {
                return new int[]{num1, num2};
            }
        }
        return new int[]{num2, num1};
    }
}
```

```C# [sol3-C#]
public class Solution {
    public int[] FindErrorNums(int[] nums) {
        int n = nums.Length;
        int xor = 0;
        foreach (int num in nums) {
            xor ^= num;
        }
        for (int i = 1; i <= n; i++) {
            xor ^= i;
        }
        int lowbit = xor & (-xor);
        int num1 = 0, num2 = 0;
        foreach (int num in nums) {
            if ((num & lowbit) == 0) {
                num1 ^= num;
            } else {
                num2 ^= num;
            }
        }
        for (int i = 1; i <= n; i++) {
            if ((i & lowbit) == 0) {
                num1 ^= i;
            } else {
                num2 ^= i;
            }
        }
        foreach (int num in nums) {
            if (num == num1) {
                return new int[]{num1, num2};
            }
        }
        return new int[]{num2, num1};
    }
}
```

``` C++ [sol3-C++]
class Solution {
public:
    vector<int> findErrorNums(vector<int>& nums) {
        int n = nums.size();
        int xorSum = 0;
        for (int num : nums) {
            xorSum ^= num;
        }
        for (int i = 1; i <= n; i++) {
            xorSum ^= i;
        }
        int lowbit = xorSum & (-xorSum);
        int num1 = 0, num2 = 0;
        for (int &num : nums) {
            if ((num & lowbit) == 0) {
                num1 ^= num;
            } else {
                num2 ^= num;
            }
        }
        for (int i = 1; i <= n; i++) {
            if ((i & lowbit) == 0) {
                num1 ^= i;
            } else {
                num2 ^= i;
            }
        }
        for (int num : nums) {
            if (num == num1) {
                return vector<int>{num1, num2};
            }
        }
        return vector<int>{num2, num1};
    }
};
```

```C [sol3-C]
int* findErrorNums(int* nums, int numsSize, int* returnSize) {
    int* errorNums = malloc(sizeof(int) * 2);
    int xorSum = 0;
    for (int i = 1; i <= numsSize; i++) {
        xorSum ^= i;
        xorSum ^= nums[i - 1];
    }
    int lowbit = xorSum & (-xorSum);
    int num1 = 0, num2 = 0;
    for (int i = 0; i < numsSize; i++) {
        if ((nums[i] & lowbit) == 0) {
            num1 ^= nums[i];
        } else {
            num2 ^= nums[i];
        }
    }
    for (int i = 1; i <= numsSize; i++) {
        if ((i & lowbit) == 0) {
            num1 ^= i;
        } else {
            num2 ^= i;
        }
    }
    int* ret = malloc(sizeof(int) * 2);
    *returnSize = 2;
    for (int i = 0; i < numsSize; i++) {
        if (nums[i] == num1) {
            ret[0] = num1, ret[1] = num2;
            return ret;
        }
    }
    ret[0] = num2, ret[1] = num1;
    return ret;
}
```

```JavaScript [sol3-JavaScript]
var findErrorNums = function(nums) {
    const n = nums.length;
    let xor = 0;
    for (const num of nums) {
        xor ^= num;
    }
    for (let i = 1; i <= n; i++) {
        xor ^= i;
    }
    const lowbit = xor & (-xor);
    let num1 = 0, num2 = 0;
    for (const num of nums) {
        if ((num & lowbit) === 0) {
            num1 ^= num;
        } else {
            num2 ^= num;
        }
    }
    for (let i = 1; i <= n; i++) {
        if ((i & lowbit) === 0) {
            num1 ^= i;
        } else {
            num2 ^= i;
        }
    }
    for (const num of nums) {
        if (num === num1) {
            return [num1, num2];
        }
    }
    return [num2, num1];
};
```

```go [sol3-Golang]
func findErrorNums(nums []int) []int {
    xor := 0
    for _, v := range nums {
        xor ^= v
    }
    n := len(nums)
    for i := 1; i <= n; i++ {
        xor ^= i
    }
    lowbit := xor & -xor
    num1, num2 := 0, 0
    for _, v := range nums {
        if v&lowbit == 0 {
            num1 ^= v
        } else {
            num2 ^= v
        }
    }
    for i := 1; i <= n; i++ {
        if i&lowbit == 0 {
            num1 ^= i
        } else {
            num2 ^= i
        }
    }
    for _, v := range nums {
        if v == num1 {
            return []int{num1, num2}
        }
    }
    return []int{num2, num1}
}
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 是数组 $\textit{nums}$ 的长度。整个过程需要对数组 $\textit{nums}$ 遍历 $3$ 次，以及遍历从 $1$ 到 $n$ 的每个数 $2$ 次。

- 空间复杂度：$O(1)$。只需要常数的额外空间。
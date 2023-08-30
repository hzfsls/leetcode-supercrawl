#### 方法一：暴力

比较容易想到的一个方法是，对于数组中的每一个元素，我们都遍历数组一次，统计小于当前元素的数的数目。

```C++ [sol1-C++]
class Solution {
public:
    vector<int> smallerNumbersThanCurrent(vector<int>& nums) {
        vector<int> ret;
        int n = nums.size();
        for (int i = 0; i < n; i++) {
            int cnt = 0;
            for (int j = 0; j < n; j++) {
                if (nums[j] < nums[i]) {
                    cnt++;
                }
            }
            ret.push_back(cnt);
        }
        return ret;
    }
};
```

```Java [sol1-Java]
class Solution {
    public int[] smallerNumbersThanCurrent(int[] nums) {
        int n = nums.length;
        int[] ret = new int[n];
        for (int i = 0; i < n; i++) {
            int cnt = 0;
            for (int j = 0; j < n; j++) {
                if (nums[j] < nums[i]) {
                    cnt++;
                }
            }
            ret[i] = cnt;
        }
        return ret;
    }
}
```

```Golang [sol1-Golang]
func smallerNumbersThanCurrent(nums []int) (ans []int) {
    for _, v := range nums {
        cnt := 0
        for _, w := range nums {
            if w < v {
                cnt++
            }
        }
        ans = append(ans, cnt)
    }
    return
}
```

```C [sol1-C]
int* smallerNumbersThanCurrent(int* nums, int numsSize, int* returnSize) {
    int* ret = malloc(sizeof(int) * numsSize);
    *returnSize = numsSize;
    for (int i = 0; i < numsSize; i++) {
        int cnt = 0;
        for (int j = 0; j < numsSize; j++) {
            if (nums[j] < nums[i]) {
                cnt++;
            }
        }
        ret[i] = cnt;
    }
    return ret;
}
```

```JavaScript [sol1-JavaScript]
var smallerNumbersThanCurrent = function(nums) {
    const n = nums.length;
    const ret = [];
    for (let i = 0; i < n; ++i) {
        let cnt = 0;
        for (let j = 0; j < n; ++j) {
            if (nums[j] < nums[i]) {
                cnt++;
            }
        }
        ret[i] = cnt;
    }
    return ret;
};
```

**复杂度分析**

- 时间复杂度：$O(N^2)$，其中 $N$ 为数组的长度。
- 空间复杂度：$O(1)$。注意我们不计算答案数组的空间占用。

#### 方法二：排序

我们也可以将数组排序，并记录每一个数在原数组中的位置。对于排序后的数组中的每一个数，我们找出其左侧第一个小于它的数，这样就能够知道数组中小于该数的数量。

```C++ [sol2-C++]
class Solution {
public:
    vector<int> smallerNumbersThanCurrent(vector<int>& nums) {
        vector<pair<int, int>> data;
        int n = nums.size();
        for (int i = 0; i < n; i++) {
            data.emplace_back(nums[i], i);
        }
        sort(data.begin(), data.end());

        vector<int> ret(n, 0);
        int prev = -1;
        for (int i = 0; i < n; i++) {
            if (prev == -1 || data[i].first != data[i - 1].first) {
                prev = i;
            }
            ret[data[i].second] = prev;
        }
        return ret;
    }
};
```

```Java [sol2-Java]
class Solution {
    public int[] smallerNumbersThanCurrent(int[] nums) {
        int n = nums.length;
        int[][] data = new int[n][2];
        for (int i = 0; i < n; i++) {
            data[i][0] = nums[i];
            data[i][1] = i;
        }
        Arrays.sort(data, new Comparator<int[]>() {
            public int compare(int[] data1, int[] data2) {
                return data1[0] - data2[0];
            }
        });

        int[] ret = new int[n];
        int prev = -1;
        for (int i = 0; i < n; i++) {
            if (prev == -1 || data[i][0] != data[i - 1][0]) {
                prev = i;
            }
            ret[data[i][1]] = prev;
        }
        return ret;
    }
}
```

```Golang [sol2-Golang]
type pair struct{ v, pos int }

func smallerNumbersThanCurrent(nums []int) []int {
    n := len(nums)
    data := make([]pair, n)
    for i, v := range nums {
        data[i] = pair{v, i}
    }
    sort.Slice(data, func(i, j int) bool { return data[i].v < data[j].v })
    ans := make([]int, n)
    prev := -1
    for i, d := range data {
        if prev == -1 || d.v != data[i-1].v {
            prev = i
        }
        ans[d.pos] = prev
    }
    return ans
}
```

```C [sol2-C]
int cmp(const void* a, const void* b) {
    return ((*(int**)a)[0] - (*(int**)b)[0]);
}

int* smallerNumbersThanCurrent(int* nums, int numsSize, int* returnSize) {
    int* data[numsSize];
    for (int i = 0; i < numsSize; i++) {
        data[i] = malloc(sizeof(int) * 2);
        data[i][0] = nums[i], data[i][1] = i;
    }
    qsort(data, numsSize, sizeof(int*), cmp);

    int* ret = malloc(sizeof(int) * numsSize);
    *returnSize = numsSize;
    int prev = -1;
    for (int i = 0; i < numsSize; i++) {
        if (prev == -1 || data[i][0] != data[i - 1][0]) {
            prev = i;
        }
        ret[data[i][1]] = prev;
    }
    return ret;
}
```

```JavaScript [sol2-JavaScript]
var smallerNumbersThanCurrent = function(nums) {
    const n = nums.length;
    const data = new Array(n).fill(0).map(v => new Array(2).fill(0));
    for (let i = 0; i < n; ++i) {
        data[i][0] = nums[i];
        data[i][1] = i;
    }
    data.sort((a, b) => a[0] - b[0]);

    const ret = new Array(n);
    let prev = -1;
    for (let i = 0; i < n; ++i) {
        if (prev == -1 || data[i][0] !== data[i - 1][0]) {
            prev = i;
        }
        ret[data[i][1]] = prev;
    }
    return ret;
};
```

**复杂度分析**

- 时间复杂度：$O(N\log N)$，其中 $N$ 为数组的长度。排序需要 $O(N\log N)$ 的时间，随后需要 $O(N)$ 时间来遍历。

- 空间复杂度：$O(N)$。因为要额外开辟一个数组。


#### 方法三：计数排序

注意到数组元素的值域为 $[0,100]$，所以可以考虑建立一个频次数组 $cnt$ ，$cnt[i]$ 表示数字 $i$ 出现的次数。那么对于数字 $i$ 而言，小于它的数目就为 $cnt[0...i-1]$ 的总和。

```C++ [sol3-C++]
class Solution {
public:
    vector<int> smallerNumbersThanCurrent(vector<int>& nums) {
        vector<int> cnt(101, 0);
        int n = nums.size();
        for (int i = 0; i < n; i++) {
            cnt[nums[i]]++;
        }
        for (int i = 1; i <= 100; i++) {
            cnt[i] += cnt[i - 1];
        }
        vector<int> ret;
        for (int i = 0; i < n; i++) {
            ret.push_back(nums[i] == 0 ? 0: cnt[nums[i]-1]);
        }
        return ret;
    }
};
```

```Java [sol3-Java]
class Solution {
    public int[] smallerNumbersThanCurrent(int[] nums) {
        int[] cnt = new int[101];
        int n = nums.length;
        for (int i = 0; i < n; i++) {
            cnt[nums[i]]++;
        }
        for (int i = 1; i <= 100; i++) {
            cnt[i] += cnt[i - 1];
        }
        int[] ret = new int[n];
        for (int i = 0; i < n; i++) {
            ret[i] = nums[i] == 0 ? 0 : cnt[nums[i] - 1];
        }
        return ret;
    }
}
```

```Golang [sol3-Golang]
func smallerNumbersThanCurrent(nums []int) []int {
    cnt := [101]int{}
    for _, v := range nums {
        cnt[v]++
    }
    for i := 0; i < 100; i++ {
        cnt[i+1] += cnt[i]
    }
    ans := make([]int, len(nums))
    for i, v := range nums {
        if v > 0 {
            ans[i] = cnt[v-1]
        }
    }
    return ans
}
```

```C [sol3-C]
int* smallerNumbersThanCurrent(int* nums, int numsSize, int* returnSize) {
    int cnt[101];
    memset(cnt, 0, sizeof(cnt));
    for (int i = 0; i < numsSize; i++) {
        cnt[nums[i]]++;
    }
    for (int i = 1; i <= 100; i++) {
        cnt[i] += cnt[i - 1];
    }

    int* ret = malloc(sizeof(int) * numsSize);
    *returnSize = numsSize;
    for (int i = 0; i < numsSize; i++) {
        ret[i] = nums[i] == 0 ? 0 : cnt[nums[i] - 1];
    }
    return ret;
}
```

```JavaScript [sol3-JavaScript]
var smallerNumbersThanCurrent = function(nums) {
    const cnt = new Array(101).fill(0);
    const n = nums.length;
    for (let i = 0; i < n; ++i) {
        cnt[nums[i]] += 1;
    }
    for (let i = 1; i <= 100; ++i) {
        cnt[i] += cnt[i - 1];
    }
    const ret = [];
    for (let i = 0; i < n; ++i) {
        ret.push(nums[i] ? cnt[nums[i] - 1] : 0);
    }
    return ret;
};
```

**复杂度分析**

- 时间复杂度：$O(N + K)$，其中 $K$ 为值域大小。需要遍历两次原数组，同时遍历一次频次数组 $cnt$ 找出前缀和。

- 空间复杂度：$O(K)$。因为要额外开辟一个值域大小的数组。
## [697.数组的度 中文官方题解](https://leetcode.cn/problems/degree-of-an-array/solutions/100000/shu-zu-de-du-by-leetcode-solution-ig97)
#### 方法一：哈希表

**思路及解法**

记原数组中出现次数最多的数为 $x$，那么和原数组的度相同的最短连续子数组，必然包含了原数组中的全部 $x$，且两端恰为 $x$ 第一次出现和最后一次出现的位置。

因为符合条件的 $x$ 可能有多个，即多个不同的数在原数组中出现次数相同。所以为了找到这个子数组，我们需要统计每一个数出现的次数，同时还需要统计每一个数第一次出现和最后一次出现的位置。

在实际代码中，我们使用哈希表实现该功能，每一个数映射到一个长度为 $3$ 的数组，数组中的三个元素分别代表这个数出现的次数、这个数在原数组中第一次出现的位置和这个数在原数组中最后一次出现的位置。当我们记录完所有信息后，我们需要遍历该哈希表，找到元素出现次数最多，且前后位置差最小的数。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    int findShortestSubArray(vector<int>& nums) {
        unordered_map<int, vector<int>> mp;
        int n = nums.size();
        for (int i = 0; i < n; i++) {
            if (mp.count(nums[i])) {
                mp[nums[i]][0]++;
                mp[nums[i]][2] = i;
            } else {
                mp[nums[i]] = {1, i, i};
            }
        }
        int maxNum = 0, minLen = 0;
        for (auto& [_, vec] : mp) {
            if (maxNum < vec[0]) {
                maxNum = vec[0];
                minLen = vec[2] - vec[1] + 1;
            } else if (maxNum == vec[0]) {
                if (minLen > vec[2] - vec[1] + 1) {
                    minLen = vec[2] - vec[1] + 1;
                }
            }
        }
        return minLen;
    }
};
```

```Java [sol1-Java]
class Solution {
    public int findShortestSubArray(int[] nums) {
        Map<Integer, int[]> map = new HashMap<Integer, int[]>();
        int n = nums.length;
        for (int i = 0; i < n; i++) {
            if (map.containsKey(nums[i])) {
                map.get(nums[i])[0]++;
                map.get(nums[i])[2] = i;
            } else {
                map.put(nums[i], new int[]{1, i, i});
            }
        }
        int maxNum = 0, minLen = 0;
        for (Map.Entry<Integer, int[]> entry : map.entrySet()) {
            int[] arr = entry.getValue();
            if (maxNum < arr[0]) {
                maxNum = arr[0];
                minLen = arr[2] - arr[1] + 1;
            } else if (maxNum == arr[0]) {
                if (minLen > arr[2] - arr[1] + 1) {
                    minLen = arr[2] - arr[1] + 1;
                }
            }
        }
        return minLen;
    }
}
```

```Python [sol1-Python3]
class Solution:
    def findShortestSubArray(self, nums: List[int]) -> int:
        mp = dict()

        for i, num in enumerate(nums):
            if num in mp:
                mp[num][0] += 1
                mp[num][2] = i
            else:
                mp[num] = [1, i, i]
        
        maxNum = minLen = 0
        for count, left, right in mp.values():
            if maxNum < count:
                maxNum = count
                minLen = right - left + 1
            elif maxNum == count:
                if minLen > (span := right - left + 1):
                    minLen = span
        
        return minLen
```

```JavaScript [sol1-JavaScript]
var findShortestSubArray = function(nums) {
    const mp = {};

    for (const [i, num] of nums.entries()) {
        if (num in mp) {
            mp[num][0]++;
            mp[num][2] = i;
        } else {
            mp[num] = [1, i, i];
        }
    }
    
    let maxNum = 0, minLen = 0;
    for (const [count, left, right] of Object.values(mp)) {
        if (maxNum < count) {
            maxNum = count;
            minLen = right - left + 1;
        } else if (maxNum === count) {
            if (minLen > (right - left + 1)) {
                minLen = right - left + 1;
            }
        }
    }
    return minLen;
};
```

```go [sol1-Golang]
type entry struct{ cnt, l, r int }

func findShortestSubArray(nums []int) (ans int) {
    mp := map[int]entry{}
    for i, v := range nums {
        if e, has := mp[v]; has {
            e.cnt++
            e.r = i
            mp[v] = e
        } else {
            mp[v] = entry{1, i, i}
        }
    }
    maxCnt := 0
    for _, e := range mp {
        if e.cnt > maxCnt {
            maxCnt, ans = e.cnt, e.r-e.l+1
        } else if e.cnt == maxCnt {
            ans = min(ans, e.r-e.l+1)
        }
    }
    return
}

func min(a, b int) int {
    if a < b {
        return a
    }
    return b
}
```

```C [sol1-C]
struct HashTable {
    int key;
    int num, add1, add2;
    UT_hash_handle hh;
};

int findShortestSubArray(int* nums, int numsSize) {
    struct HashTable* hashTable = NULL;
    for (int i = 0; i < numsSize; i++) {
        struct HashTable* tmp;
        HASH_FIND_INT(hashTable, &nums[i], tmp);
        if (tmp != NULL) {
            tmp->num++;
            tmp->add2 = i;
        } else {
            tmp = malloc(sizeof(struct HashTable));
            tmp->key = nums[i];
            tmp->num = 1;
            tmp->add1 = i;
            tmp->add2 = i;
            HASH_ADD_INT(hashTable, key, tmp);
        }
    }
    int maxNum = 0, minLen = 0;
    struct HashTable *s, *tmp;
    HASH_ITER(hh, hashTable, s, tmp) {
        if (maxNum < s->num) {
            maxNum = s->num;
            minLen = s->add2 - s->add1 + 1;
        } else if (maxNum == s->num) {
            if (minLen > s->add2 - s->add1 + 1) {
                minLen = s->add2 - s->add1 + 1;
            }
        }
    }
    return minLen;
}
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 是原数组的长度，我们需要遍历原数组和哈希表各一次，它们的大小均为 $O(n)$。

- 空间复杂度：$O(n)$，其中 $n$ 是原数组的长度，最坏情况下，哈希表和原数组等大。
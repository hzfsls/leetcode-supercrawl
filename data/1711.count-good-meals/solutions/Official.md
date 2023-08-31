## [1711.大餐计数 中文官方题解](https://leetcode.cn/problems/count-good-meals/solutions/100000/da-can-ji-shu-by-leetcode-solution-fvg9)
#### 方法一：哈希表

朴素的解法是遍历数组 $\textit{deliciousness}$ 中的每对元素，对于每对元素，计算两个元素之和是否等于 $2$ 的幂。该解法的时间复杂度为 $O(n^2)$，会超出时间限制。

上述朴素解法存在同一个元素被重复计算的情况，因此可以使用哈希表减少重复计算，降低时间复杂度。具体做法是，使用哈希表存储数组中的每个元素的出现次数，遍历到数组 $\textit{deliciousness}$ 中的某个元素时，在哈希表中寻找与当前元素的和等于 $2$ 的幂的元素个数，然后用当前元素更新哈希表。由于遍历数组时，哈希表中已有的元素的下标一定小于当前元素的下标，因此任意一对元素之和等于 $2$ 的幂的元素都不会被重复计算。

令 $\textit{maxVal}$ 表示数组 $\textit{deliciousness}$ 中的最大元素，则数组中的任意两个元素之和都不会超过 $\textit{maxVal} \times 2$。令 $\textit{maxSum} = \textit{maxVal} \times 2$，则任意一顿大餐的美味程度之和为不超过 $\textit{maxSum}$ 的某个 $2$ 的幂。

对于某个特定的 $2$ 的幂 $\textit{sum}$，可以在 $O(n)$ 的时间内计算数组 $\textit{deliciousness}$ 中元素之和等于 $\textit{sum}$ 的元素对的数量。数组 $\textit{deliciousness}$ 中的最大元素 $\textit{maxVal}$ 满足 $\textit{maxVal} \le C$，其中 $C=2^{20}$，则不超过 $\textit{maxSum}$ 的 $2$ 的幂有 $O(\log \textit{maxSum})=O(\log \textit{maxVal})=O(\log C)$ 个，因此可以在 $O(n \log C)$ 的时间内计算数组 $\textit{deliciousness}$ 中的大餐数量。

```Java [sol1-Java]
class Solution {
    public int countPairs(int[] deliciousness) {
        final int MOD = 1000000007;
        int maxVal = 0;
        for (int val : deliciousness) {
            maxVal = Math.max(maxVal, val);
        }
        int maxSum = maxVal * 2;
        int pairs = 0;
        Map<Integer, Integer> map = new HashMap<Integer, Integer>();
        int n = deliciousness.length;
        for (int i = 0; i < n; i++) {
            int val = deliciousness[i];
            for (int sum = 1; sum <= maxSum; sum <<= 1) {
                int count = map.getOrDefault(sum - val, 0);
                pairs = (pairs + count) % MOD;
            }
            map.put(val, map.getOrDefault(val, 0) + 1);
        }
        return pairs;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int CountPairs(int[] deliciousness) {
        const int MOD = 1000000007;
        int maxVal = 0;
        foreach (int val in deliciousness) {
            maxVal = Math.Max(maxVal, val);
        }
        int maxSum = maxVal * 2;
        int pairs = 0;
        Dictionary<int, int> dictionary = new Dictionary<int, int>();
        int n = deliciousness.Length;
        for (int i = 0; i < n; i++) {
            int val = deliciousness[i];
            for (int sum = 1; sum <= maxSum; sum <<= 1) {
                int count = 0;
                dictionary.TryGetValue(sum - val, out count);
                pairs = (pairs + count) % MOD;
            }
            if (dictionary.ContainsKey(val)) {
                dictionary[val]++;
            } else {
                dictionary.Add(val, 1);
            }
        }
        return pairs;
    }
}
```

```JavaScript [sol1-JavaScript]
var countPairs = function(deliciousness) {
    const MOD = 1000000007;
    let maxVal = 0;
    for (const val of deliciousness) {
        maxVal = Math.max(maxVal, val);
    }
    const maxSum = maxVal * 2;
    let pairs = 0;
    const map = new Map();
    const n = deliciousness.length;
    for (let i = 0; i < n; i++) {
        const val = deliciousness[i];
        for (let sum = 1; sum <= maxSum; sum <<= 1) {
            const count = map.get(sum - val) || 0;
            pairs = (pairs + count) % MOD;
        }
        map.set(val, (map.get(val) || 0) + 1);
    }
    return pairs;
};
```

```C++ [sol1-C++]
class Solution {
public:
    static constexpr int MOD = 1'000'000'007;

    int countPairs(vector<int>& deliciousness) {
        int maxVal = *max_element(deliciousness.begin(), deliciousness.end());
        int maxSum = maxVal * 2;
        int pairs = 0;
        unordered_map<int, int> mp;
        int n = deliciousness.size();
        for (auto& val : deliciousness) {
            for (int sum = 1; sum <= maxSum; sum <<= 1) {
                int count = mp.count(sum - val) ? mp[sum - val] : 0;
                pairs = (pairs + count) % MOD;
            }
            mp[val]++;
        }
        return pairs;
    }
};
```

```C [sol1-C]
struct HashTable {
    int key, val;
    UT_hash_handle hh;
};

const int MOD = 1000000007;

int countPairs(int* deliciousness, int deliciousnessSize) {
    int maxVal = 0;
    for (int i = 0; i < deliciousnessSize; i++) {
        maxVal = fmax(maxVal, deliciousness[i]);
    }
    int maxSum = maxVal * 2;
    int pairs = 0;
    struct HashTable *hashTable = NULL, *tmp;
    int n = deliciousnessSize;
    for (int i = 0; i < deliciousnessSize; i++) {
        int val = deliciousness[i];
        for (int sum = 1; sum <= maxSum; sum <<= 1) {
            int target = sum - val;
            HASH_FIND_INT(hashTable, &target, tmp);
            int count = tmp == NULL ? 0 : tmp->val;
            pairs = (pairs + count) % MOD;
        }
        HASH_FIND_INT(hashTable, &val, tmp);
        if (tmp == NULL) {
            tmp = malloc(sizeof(struct HashTable));
            tmp->key = val, tmp->val = 1;
            HASH_ADD_INT(hashTable, key, tmp);
        } else {
            tmp->val++;
        }
    }
    return pairs;
}
```

```go [sol1-Golang]
func countPairs(deliciousness []int) (ans int) {
    maxVal := deliciousness[0]
    for _, val := range deliciousness[1:] {
        if val > maxVal {
            maxVal = val
        }
    }
    maxSum := maxVal * 2
    cnt := map[int]int{}
    for _, val := range deliciousness {
        for sum := 1; sum <= maxSum; sum <<= 1 {
            ans += cnt[sum-val]
        }
        cnt[val]++
    }
    return ans % (1e9 + 7)
}
```

**复杂度分析**

- 时间复杂度：$O(n \log C)$，其中 $n$ 是数组 $\textit{deliciousness}$ 的长度，$C$ 是数组 $\textit{deliciousness}$ 中的元素值上限，这道题中 $C=2^{20}$。需要遍历数组 $\textit{deliciousness}$ 一次，对于其中的每个元素，需要 $O(\log C)$ 的时间计算包含该元素的大餐数量，因此总时间复杂度是 $O(n \log C)$。

- 空间复杂度：$O(n)$，其中 $n$ 是数组 $\textit{deliciousness}$ 的长度。需要创建哈希表，哈希表的大小不超过 $n$。
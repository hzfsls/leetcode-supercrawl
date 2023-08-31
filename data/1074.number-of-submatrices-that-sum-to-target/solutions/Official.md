## [1074.元素和为目标值的子矩阵数量 中文官方题解](https://leetcode.cn/problems/number-of-submatrices-that-sum-to-target/solutions/100000/yuan-su-he-wei-mu-biao-zhi-de-zi-ju-zhen-8ym2)

#### 方法一：前缀和 + 哈希表

我们枚举子矩阵的上下边界，并计算出该边界内每列的元素和，则原问题转换成了如下一维问题：

> 给定一个整数数组和一个整数 $\textit{target}$，计算该数组中子数组和等于 $\textit{target}$ 的子数组个数。

力扣上已有该问题：[560. 和为K的子数组](https://leetcode-cn.com/problems/subarray-sum-equals-k/)，读者可以参考其[官方题解](https://leetcode-cn.com/problems/subarray-sum-equals-k/solution/he-wei-kde-zi-shu-zu-by-leetcode-solution/)，并掌握使用前缀和+哈希表的线性做法。

对于每列的元素和 $\textit{sum}$ 的计算，我们在枚举子矩阵上边界 $i$ 时，初始下边界 $j$ 为 $i$，此时 $\textit{sum}$ 就是矩阵第 $i$ 行的元素。每次向下延长下边界 $j$ 时，我们可以将矩阵第 $j$ 行的元素累加到 $\textit{sum}$ 中。

```C++ [sol1-C++]
class Solution {
private:
    int subarraySum(vector<int> &nums, int k) {
        unordered_map<int, int> mp;
        mp[0] = 1;
        int count = 0, pre = 0;
        for (auto &x:nums) {
            pre += x;
            if (mp.find(pre - k) != mp.end()) {
                count += mp[pre - k];
            }
            mp[pre]++;
        }
        return count;
    }

public:
    int numSubmatrixSumTarget(vector<vector<int>> &matrix, int target) {
        int ans = 0;
        int m = matrix.size(), n = matrix[0].size();
        for (int i = 0; i < m; ++i) { // 枚举上边界
            vector<int> sum(n);
            for (int j = i; j < m; ++j) { // 枚举下边界
                for (int c = 0; c < n; ++c) {
                    sum[c] += matrix[j][c]; // 更新每列的元素和
                }
                ans += subarraySum(sum, target);
            }
        }
        return ans;
    }
};
```

```Java [sol1-Java]
class Solution {
    public int numSubmatrixSumTarget(int[][] matrix, int target) {
        int ans = 0;
        int m = matrix.length, n = matrix[0].length;
        for (int i = 0; i < m; ++i) { // 枚举上边界
            int[] sum = new int[n];
            for (int j = i; j < m; ++j) { // 枚举下边界
                for (int c = 0; c < n; ++c) {
                    sum[c] += matrix[j][c]; // 更新每列的元素和
                }
                ans += subarraySum(sum, target);
            }
        }
        return ans;
    }

    public int subarraySum(int[] nums, int k) {
        Map<Integer, Integer> map = new HashMap<Integer, Integer>();
        map.put(0, 1);
        int count = 0, pre = 0;
        for (int x : nums) {
            pre += x;
            if (map.containsKey(pre - k)) {
                count += map.get(pre - k);
            }
            map.put(pre, map.getOrDefault(pre, 0) + 1);
        }
        return count;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int NumSubmatrixSumTarget(int[][] matrix, int target) {

        int ans = 0;
        int m = matrix.Length, n = matrix[0].Length;
        for (int i = 0; i < m; ++i) { // 枚举上边界
            int[] sum = new int[n];
            for (int j = i; j < m; ++j) { // 枚举下边界
                for (int c = 0; c < n; ++c) {
                    sum[c] += matrix[j][c]; // 更新每列的元素和
                }
                ans += SubarraySum(sum, target);
            }
        }
        return ans;
    }

    public int SubarraySum(int[] nums, int k) {
        Dictionary<int, int> dictionary = new Dictionary<int, int>();
        dictionary.Add(0, 1);
        int count = 0, pre = 0;
        foreach (int x in nums) {
            pre += x;
            if (dictionary.ContainsKey(pre - k)) {
                count += dictionary[pre - k];
            }
            if (!dictionary.ContainsKey(pre)) {
                dictionary.Add(pre, 1);
            } else {
                ++dictionary[pre];
            }
        }
        return count;
    }
}
```

```go [sol1-Golang]
func subarraySum(nums []int, k int) (ans int) {
    mp := map[int]int{0: 1}
    for i, pre := 0, 0; i < len(nums); i++ {
        pre += nums[i]
        if _, ok := mp[pre-k]; ok {
            ans += mp[pre-k]
        }
        mp[pre]++
    }
    return
}

func numSubmatrixSumTarget(matrix [][]int, target int) (ans int) {
    for i := range matrix { // 枚举上边界
        sum := make([]int, len(matrix[0]))
        for _, row := range matrix[i:] { // 枚举下边界
            for c, v := range row {
                sum[c] += v // 更新每列的元素和
            }
            ans += subarraySum(sum, target)
        }
    }
    return
}
```

```Python [sol1-Python3]
class Solution:
    def numSubmatrixSumTarget(self, matrix: List[List[int]], target: int) -> int:
        def subarraySum(nums: List[int], k: int) -> int:
            mp = Counter([0])
            count = pre = 0
            for x in nums:
                pre += x
                if pre - k in mp:
                    count += mp[pre - k]
                mp[pre] += 1
            return count
        
        m, n = len(matrix), len(matrix[0])
        ans = 0
        # 枚举上边界
        for i in range(m):
            total = [0] * n
            # 枚举下边界
            for j in range(i, m):
                for c in range(n):
                    # 更新每列的元素和
                    total[c] += matrix[j][c]
                ans += subarraySum(total, target)
        
        return ans
```

```C [sol1-C]
struct HashTable {
    int key, val;
    UT_hash_handle hh;
};

int subarraySum(int* nums, int numsSize, int k) {
    struct HashTable* hashTable = NULL;
    struct HashTable* tmp = malloc(sizeof(struct HashTable));
    tmp->key = 0, tmp->val = 1;
    HASH_ADD_INT(hashTable, key, tmp);
    int count = 0, pre = 0;
    for (int i = 0; i < numsSize; i++) {
        pre += nums[i];
        int x = pre - k;
        HASH_FIND_INT(hashTable, &x, tmp);
        if (tmp != NULL) {
            count += tmp->val;
        }
        HASH_FIND_INT(hashTable, &pre, tmp);
        if (tmp != NULL) {
            tmp->val++;
        } else {
            tmp = malloc(sizeof(struct HashTable));
            tmp->key = pre, tmp->val = 1;
            HASH_ADD_INT(hashTable, key, tmp);
        }
    }
    return count;
}

int numSubmatrixSumTarget(int** matrix, int matrixSize, int* matrixColSize, int target) {
    int ans = 0;
    int m = matrixSize, n = matrixColSize[0];
    for (int i = 0; i < m; ++i) {  // 枚举上边界
        int sum[n];
        memset(sum, 0, sizeof(sum));
        for (int j = i; j < m; ++j) {  // 枚举下边界
            for (int c = 0; c < n; ++c) {
                sum[c] += matrix[j][c];  // 更新每列的元素和
            }
            ans += subarraySum(sum, n, target);
        }
    }
    return ans;
}
```

```JavaScript [sol1-JavaScript]
var numSubmatrixSumTarget = function(matrix, target) {
    let ans = 0;
    const m = matrix.length, n = matrix[0].length;
    for (let i = 0; i < m; ++i) { // 枚举上边界
        const sum = new Array(n).fill(0);
        for (let j = i; j < m; ++j) { // 枚举下边界
            for (let c = 0; c < n; ++c) {
                sum[c] += matrix[j][c]; // 更新每列的元素和
            }
            ans += subarraySum(sum, target);
        }
    }
    return ans;
}

const subarraySum = (nums, k) => {
    const map = new Map();
    map.set(0, 1);
    let count = 0, pre = 0;
    for (const x of nums) {
        pre += x;
        if (map.has(pre - k)) {
            count += map.get(pre - k);
        }
        map.set(pre, (map.get(pre) || 0) + 1);
    }
    return count;
}
```

**复杂度分析**

- 时间复杂度：$O(m^2\cdot n)$。其中 $m$ 和 $n$ 分别是矩阵 $\textit{matrix}$ 的行数和列数。

- 空间复杂度：$O(n)$。

**优化**

若行数大于列数，枚举矩形的左右边界更优，对应的时间复杂度为 $O(n^2\cdot m)$。

总之，根据 $m$ 和 $n$ 的大小来细化枚举策略，我们可以做到 $O(\min(m,n)^2\cdot\max(m,n))$ 的时间复杂度。

---
## ✨扣友帮帮团 - 互动答疑

[![讨论.jpg](https://pic.leetcode-cn.com/1621178600-MKHFrl-%E8%AE%A8%E8%AE%BA.jpg){:width=260px}](https://leetcode-cn.com/topic/kou-you-bang-bang-tuan/discuss/latest/)


即日起 - 5 月 30 日，点击 [这里](https://leetcode-cn.com/topic/kou-you-bang-bang-tuan/discuss/latest/) 前往「[扣友帮帮团](https://leetcode-cn.com/topic/kou-you-bang-bang-tuan/discuss/latest/)」活动页，把你遇到的问题大胆地提出来，让扣友为你解答～

### 🎁 奖励规则
被采纳数量排名 1～3 名：「力扣极客套装」 *1 并将获得「力扣神秘应援团」内测资格
被采纳数量排名 4～10 名：「力扣鼠标垫」 *1 并将获得「力扣神秘应援团」内测资格
「诲人不倦」：活动期间「解惑者」只要有 1 个回答被采纳，即可获得 20 LeetCoins 奖励！
「求知若渴」：活动期间「求知者」在活动页发起一次符合要求的疑问帖并至少采纳一次「解惑者」的回答，即可获得 20 LeetCoins 奖励！

活动详情猛戳链接了解更多：[🐞 你有 BUG 我来帮 - 力扣互动答疑季](https://leetcode-cn.com/circle/discuss/xtliW6/)
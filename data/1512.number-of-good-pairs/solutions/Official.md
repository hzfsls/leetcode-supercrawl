#### 方法一：暴力统计

**思路与算法**

对于每个 $a_i$，枚举所有的 $a_j (j > i)$，检查是否满足 $a_i = a_j$，如果是就计入答案。

**代码**

```cpp [sol1-C++]
class Solution {
public:
    int numIdenticalPairs(vector<int>& nums) {
        int ans = 0;
        for (int i = 0; i < nums.size(); ++i) {
            for (int j = i + 1; j < nums.size(); ++j) {
                if (nums[i] == nums[j]) {
                    ++ans;
                }
            }
        }
        return ans;
    }
};
```

```Java [sol1-Java]
class Solution {
    public int numIdenticalPairs(int[] nums) {
        int ans = 0;
        for (int i = 0; i < nums.length; ++i) {
            for (int j = i + 1; j < nums.length; ++j) {
                if (nums[i] == nums[j]) {
                    ++ans;
                }
            }
        }
        return ans;
    }
}
```

```Python [sol1-Python3]
class Solution:
    def numIdenticalPairs(self, nums: List[int]) -> int:
        ans = 0
        for i in range(len(nums)):
            for j in range(i + 1, len(nums)):
                if nums[i] == nums[j]:
                    ans += 1
        return ans
```

**复杂度分析**

+ 时间复杂度：$O(n^2)$。
+ 空间复杂度：$O(1)$。

#### 方法二：组合计数

**思路与算法**

用哈希表统计每个数在序列中出现的次数，假设数字 $k$ 在序列中出现的次数为 $v$，那么满足题目中所说的 ${\rm nums}[i] = {\rm nums}[j] = k(i < j)$ 的 $(i, j)$ 的数量就是 $\frac{v(v - 1)}{2}$，即 $k$ 这个数值对答案的贡献是 $\frac{v(v - 1)}{2}$。我们只需要把所有数值的贡献相加，即可得到答案。

**代码**

```cpp [sol2-C++]
class Solution {
public:
    int numIdenticalPairs(vector<int>& nums) {
        unordered_map <int, int> m;
        for (int num: nums) {
            ++m[num];
        }

        int ans = 0;
        for (const auto &[k, v]: m) {
            ans += v * (v - 1) / 2;
        }

        return ans;
    }
};
```

```Java [sol2-Java]
class Solution {
    public int numIdenticalPairs(int[] nums) {
        Map<Integer, Integer> m = new HashMap<Integer, Integer>();
        for (int num : nums) {
            m.put(num, m.getOrDefault(num, 0) + 1);
        }

        int ans = 0;
        for (Map.Entry<Integer, Integer> entry : m.entrySet()) {
            int v = entry.getValue();
            ans += v * (v - 1) / 2;
        }

        return ans;
    }
}
```

```Python [sol2-Python3]
class Solution:
    def numIdenticalPairs(self, nums: List[int]) -> int:
        m = collections.Counter(nums)
        return sum(v * (v - 1) // 2 for k, v in m.items())
```

**复杂度分析**

+ 时间复杂度：$O(n)$。
+ 空间复杂度：$O(n)$，即哈希表使用到的辅助空间的空间代价。
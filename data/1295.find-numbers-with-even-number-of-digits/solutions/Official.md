### 方法一：枚举 + 字符串

我们枚举数组 `nums` 中的整数，并依次判断每个整数 `x` 是否包含偶数个数字。

一种简单的方法是使用语言内置的整数转字符串函数，将 `x` 转换为字符串后，判断其长度是否为偶数即可。

```C++ [sol1-C++]
class Solution {
public:
    int findNumbers(vector<int>& nums) {
        int ans = 0;
        for (int num: nums) {
            if (to_string(num).size() % 2 == 0) {
                ++ans;
            }
        }
        return ans;
    }
};
```

```C++ [sol1-C++17]
class Solution {
public:
    int findNumbers(vector<int>& nums) {
        return accumulate(nums.begin(), nums.end(), 0, [](int ans, int num) {
            return ans + (to_string(num).size() % 2 == 0);
        });
    }
};
```

```Python [sol1-Python3]
class Solution:
    def findNumbers(self, nums: List[int]) -> int:
        return sum(1 for num in nums if len(str(num)) % 2 == 0)
```

**复杂度分析**

- 时间复杂度：$O(N)$，其中 $N$ 是数组 `nums` 的长度。这里假设将整数转换为字符串的时间复杂度为 $O(1)$。

- 空间复杂度：$O(1)$。

### 方法二：枚举 + 数学

我们也可以使用语言内置的以 `10` 为底的对数函数 `log10()` 来得到整数 `x` 包含的数字个数。

一个包含 `k` 个数字的整数 `x` 满足不等式 $10^{k-1} \leq x < 10^k$。将不等式取对数，得到 $k - 1 \leq \log_{10}(x) < k$，因此我们可以用 $k = \lfloor\log_{10}(x) + 1\rfloor$ 得到 `x` 包含的数字个数 `k`，其中 $\lfloor a \rfloor$ 表示将 $a$ 进行下取整，例如 $\lfloor 5.2 \rfloor = 5$。

```C++ [sol2-C++]
class Solution {
public:
    int findNumbers(vector<int>& nums) {
        int ans = 0;
        for (int num: nums) {
            if ((int)(log10(num) + 1) % 2 == 0) {
                ++ans;
            }
        }
        return ans;
    }
};
```

```C++ [sol2-C++17]
class Solution {
public:
    int findNumbers(vector<int>& nums) {
        return accumulate(nums.begin(), nums.end(), 0, [](int ans, int num) {
            return ans + ((int)(log10(num) + 1) % 2 == 0);
        });
    }
};
```

```Python [sol2-Python3]
class Solution:
    def findNumbers(self, nums: List[int]) -> int:
        return sum(1 for num in nums if int(math.log10(num) + 1) % 2 == 0)
```

**复杂度分析**

- 时间复杂度：$O(N)$，其中 $N$ 是数组 `nums` 的长度。

- 空间复杂度：$O(1)$。
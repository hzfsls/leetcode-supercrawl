## [1509.三次操作后最大值与最小值的最小差 中文官方题解](https://leetcode.cn/problems/minimum-difference-between-largest-and-smallest-value-in-three-moves/solutions/100000/san-ci-cao-zuo-hou-zui-da-zhi-yu-zui-xiao-zhi-de-2)
#### 前言

当给定的数组长度不超过 $4$ 时，我们总可以让所有的数字相同，所以我们直接考虑长度超过 $4$ 的数组。

我们注意到，每次修改必然是将最大值改小，或者将最小值改大，这样才能让最大值与最小值的差尽可能小。

这样我们只需要找到最大的四个数与最小的四个数即可。当我们删去最小的 $k(0 \le k \le 3)$ 个数，还需要删去 $3-k$ 个最大值。枚举这四种情况即可。

#### 方法一：直接排序

**思路及算法**

直接对这个数组排序，即可直接得到其中最大的四个数与最小的四个数。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    int minDifference(vector<int>& nums) {
        int n = nums.size();
        if (n <= 4) {
            return 0;
        }

        sort(nums.begin(), nums.end());
        int ret = 2e9;
        for (int i = 0; i < 4; i++) {
            ret = min(ret, nums[n - 4 + i] - nums[i]);
        }
        return ret;
    }
};
```

```Java [sol1-Java]
class Solution {
    public int minDifference(int[] nums) {
        int n = nums.length;
        if (n <= 4) {
            return 0;
        }

        Arrays.sort(nums);
        int ret = Integer.MAX_VALUE;
        for (int i = 0; i < 4; i++) {
            ret = Math.min(ret, nums[n - 4 + i] - nums[i]);
        }
        return ret;
    }
}
```

```Python [sol1-Python3]
class Solution:
    def minDifference(self, nums: List[int]) -> int:
        if len(nums) <= 4:
            return 0
        
        n = len(nums)
        nums.sort()
        ret = min(nums[n - 4 + i] - nums[i] for i in range(4))
        return ret
```

**复杂度分析**

- 时间复杂度：$O(n \log{n})$，其中 $n$ 为给定数组的长度。
- 空间复杂度：$O(1)$。

#### 方法二：贪心

**思路及算法**

直接维护最大的四个数与最小的四个数即可，我们用两个数组分别记录最大值与最小值，不断更新这两个最值数组。

**代码**

```C++ [sol2-C++]
class Solution {
public:
    int minDifference(vector<int>& nums) {
        int n = nums.size();
        if (n <= 4) {
            return 0;
        }

        vector<int> maxn(4, -1e9), minn(4, 1e9);
        for (int i = 0; i < n; i++) {
            int add = 0;
            while (add < 4 && maxn[add] > nums[i]) {
                add++;
            }
            if (add < 4) {
                for (int j = 3; j > add; j--) {
                    maxn[j] = maxn[j - 1];
                }
                maxn[add] = nums[i];
            }
            add = 0;
            while (add < 4 && minn[add] < nums[i]) {
                add++;
            }
            if (add < 4) {
                for (int j = 3; j > add; j--) {
                    minn[j] = minn[j - 1];
                }
                minn[add] = nums[i];
            }
        }
        int ret = 2e9;
        for (int i = 0; i < 4; i++) {
            ret = min(ret, maxn[i] - minn[3 - i]);
        }
        return ret;
    }
};
```

```Java [sol2-Java]
class Solution {
    public int minDifference(int[] nums) {
        int n = nums.length;
        if (n <= 4) {
            return 0;
        }

        int[] maxn = new int[4];
        int[] minn = new int[4];
        Arrays.fill(maxn, -1000000000);
        Arrays.fill(minn, 1000000000);
        for (int i = 0; i < n; i++) {
            int add = 0;
            while (add < 4 && maxn[add] > nums[i]) {
                add++;
            }
            if (add < 4) {
                for (int j = 3; j > add; j--) {
                    maxn[j] = maxn[j - 1];
                }
                maxn[add] = nums[i];
            }
            add = 0;
            while (add < 4 && minn[add] < nums[i]) {
                add++;
            }
            if (add < 4) {
                for (int j = 3; j > add; j--) {
                    minn[j] = minn[j - 1];
                }
                minn[add] = nums[i];
            }
        }
        int ret = Integer.MAX_VALUE;
        for (int i = 0; i < 4; i++) {
            ret = Math.min(ret, maxn[i] - minn[3 - i]);
        }
        return ret;
    }
}
```

```Python [sol2-Python3]
class Solution:
    def minDifference(self, nums: List[int]) -> int:
        if len(nums) <= 4:
            return 0

        n = len(nums)
        maxn = [-10**9] * 4
        minn = [10**9] * 4

        for i in range(n):
            add = 0
            while add < 4 and maxn[add] > nums[i]:
                add += 1
            if add < 4:
                maxn[add:] = [nums[i]] + maxn[add:-1]
            
            add = 0
            while add < 4 and minn[add] < nums[i]:
                add += 1
            if add < 4:
                minn[add:] = [nums[i]] + minn[add:-1]
        
        ret = min(maxn[i] - minn[3 - i] for i in range(4))
        return ret
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 为给定数组的长度。注意本题中只需要维护 $8$ 个数，因此更新最值数组的时间复杂度可以看作 $O(1)$，如果要求维护 $k$ 个数，则可以使用堆优化时间复杂度。
- 空间复杂度：$O(1)$。
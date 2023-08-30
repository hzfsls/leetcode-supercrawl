### 方法一：哈希表

#### 思路

根据题意找到两个需要解决的重点：

1. **出现一次**
2. **最大数**

我们只需要使用哈希表统计所有数字出现的次数，然后遍历哈希表，找出所有只出现一次的数字中最大的数字就能解决上面的两个问题。

#### 代码

```Golang [sol1] 
func largestUniqueNumber(A []int) int {
    m := make(map[int]int)
    for i := 0; i < len(A); i++ {
        m[A[i]]++
    }
    max := -1
    for k, v := range m {
        if v == 1 && k > max {
            max = k
        }
    }
    return max
}
```
```C++ [sol1]
class Solution {
public:
    int largestUniqueNumber(vector<int>& A) {
        unordered_map<int, int> m;
        for (int num: A) {
            ++m[num];
        }

        int mx = -1;
        for (auto& [k, v]: m) {
            if (v == 1 && k > mx) {
                mx = k;
            }
        }
        return mx;
    }
};
```
```Python [sol1]
class Solution:
    def largestUniqueNumber(self, A: List[int]) -> int:
        m = collections.defaultdict(int)
        for num in A:
            m[num] += 1
        
        mx = -1
        for k, v in m.items():
            if v == 1 and k > mx:
                mx = k
        return mx
```

#### 复杂度分析

- 时间复杂度：$O(n)$，一次遍历数组 `A`，再一次遍历哈希表，哈希表中 `key` 的个数为数组中不重复数字的个数，最大为 `len(A)`。其中 $n$ 为数组 `A` 的长度。

- 空间复杂度：$O(n)$，哈希表的大小为数组中不重复数字的个数，最大为 `len(A)`。其中 n 为数组 `A` 的长度。

### 方法二：计数排序

#### 思路

方法一在 `A[i]` 是任意值时都可以完美解决，不过本题给了一个提示：`0 <= A[i] <= 1000`。这个提示告诉我们 `A[i]` 的范围很小，那么我们完全可以用计数排序一次遍历统计数字个数并排好序。计数排序和哈希表类似，不同之处是所有值的位置已经按照顺序排好，只需要在特定的位置计数即可。排完序后再从尾到头找到第一个只出现一次的数字即可返回，速度相对于使用哈希表更快，但是会牺牲空间。

小贴士：
计数排序是一个非基于比较的排序算法。它的优势在于在对一定范围内的整数排序时，它的复杂度为 $Ο(n+k)$（其中 $k$ 是整数的范围），快于任何比较排序算法。

#### 代码

```Golang [sol2]
func largestUniqueNumber(A []int) int {
    r := [1001]int{}
    for i := 0; i < len(A); i++ {
        r[A[i]]++
    }
    for i := 1000; i >= 0; i-- {
        if r[i] == 1 {
            return i
        }
    }
    return -1
}
```
```Java [sol2]
class Solution {
    public int largestUniqueNumber(int[] A) {
        int[] r = new int[1001];
        for (int i = 0; i < A.length; i++) {
            r[A[i]]++;
        }
        for(int i = 1000; i >= 0; i--) {
            if (r[i] == 1) {
                return i;
            }
        }
        return -1;
    }
}
```
```C++ [sol2]
class Solution {
public:
    int largestUniqueNumber(vector<int>& A) {
        vector<int> r(1001);
        for (int num: A) {
            ++r[num];
        }
        for (int i = 1000; i >= 0; --i) {
            if (r[i] == 1) {
                return i;
            }
        }
        return -1;
    }
};
```
```Python [sol2]
class Solution:
    def largestUniqueNumber(self, A: List[int]) -> int:
        r = [0] * 1001
        for num in A:
            r[num] += 1
        for i in range(1000, -1, -1):
            if r[i] == 1:
                return i
        return -1
```

#### 复杂度分析

- 时间复杂度：$O(n + c)$，一次遍历数组 `A`，再从尾到头遍历新的数组，其中 $n$ 为数组 `A` 的长度，$c$ 表示数据范围的长度，在本题中不超过 `1000`。

- 空间复杂度：$O(c)$，使用的空间与数据范围的长度成正比，在本题中为 $c$ 不超过 `1000`。
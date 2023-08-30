#### 方法一：暴力法

直接遍历所有的数字对，判断一个数字是否是另一个数字的两倍。注意要用乘法判断，除法判断会有除零的问题。

```python []
class Solution:
    def checkIfExist(self, arr: List[int]) -> bool:
        for i, a in enumerate(arr):
            for j, b in enumerate(arr):
                if i != j and a * 2 == b:
                    return True
        return False
```

```C++ []
class Solution {
public:
    bool checkIfExist(vector<int>& arr) {
        for (auto i = arr.begin(); i != arr.end(); ++i)
            for (auto j = arr.begin(); j != arr.end(); ++j)
                if (i != j && *i * 2 == *j)
                    return true;
        return false;
    }
};
```

##### 复杂度分析：

  * 时间复杂度：$O(n^2)$
  * 空间复杂度：$O(1)$

#### 方法二：排序 + 双指针

先对所有数字进行排序。然后维护两个指针：指针 $p$ 遍历数字 $x$，指针 $q$ 寻找 $2x$。

* 对于 $x>0$ 的情况，指针只需要一直前进。若 $q$ 在前进过程中找到一个比 $2x$ 大的数字，那么 $2x$ 必然不存在。在 $p$ 前进的过程中 $p$ 所指向的 $x$ 会不断递增，$2x$ 也会不断递增，因此指针 $q$ 不需要后退。
* 对于 $x<0$ 的情况，指针只需要一直后退。若 $q$ 在后退过程中找到一个比 $2x$ 小的数字，那么 $2x$ 必然不存在。在 $p$ 后退的过程中 $p$ 所指向的 $x$ 会不断递减，$2x$ 也会不断递减，因此指针 $q$ 不需要前进。

```python []
class Solution:
    def checkIfExist(self, arr: List[int]) -> bool:
        arr.sort()
        q = 0
        for p in range(len(arr)):
            while q < len(arr) and arr[p] * 2 > arr[q]:
                q += 1
            if q != len(arr) and p != q and arr[p] * 2 == arr[q]:
                return True
        q = len(arr) - 1
        for p in range(len(arr) - 1, -1, -1):
            while q > -1 and arr[p] * 2 < arr[q]:
                q -= 1
            if q != -1 and p != q and arr[p] * 2 == arr[q]:
                return True
        return False
```

```C++ []
class Solution {
public:
    bool checkIfExist(vector<int>& arr) {
        sort(arr.begin(), arr.end());
        for (auto i = arr.begin(), j = arr.begin(); i != arr.end(); ++i) {
            while (j != arr.end() && *i * 2 > *j)
                ++j;
            if (j != arr.end() && i != j && *i * 2 == *j)
                return true;
        }
        for (auto i = arr.rbegin(), j = arr.rbegin(); i != arr.rend(); ++i) {
            while (j != arr.rend() && *i * 2 < *j)
                ++j;
            if (j != arr.rend() && i != j && *i * 2 == *j)
                return true;
        }
        return false;
    }
};
```

##### 复杂度分析：

  * 时间复杂度：$O(nlogn)$
    排序的时间复杂度为 $O(nlogn)$，两次指针遍历的过程时间复杂度为 $O(n)$，综合起来，复杂度为 $O(nlogn)$。
  * 空间复杂度：$O(n)$
    Python 的 sort 函数空间复杂度为 $O(n)$，双指针遍历的空间复杂度为 $O(1)$，综合起来，复杂度为 $O(n)$。

#### 方法三：哈希表

先将所有数字存入哈希表，再遍历所有的数字 $x$，判断 $2x$ 是否在哈希表中。注意数字 0 需要特殊考虑。可以通过计数来解决数字 0 的问题：若 $x\neq0$，则 $2x$ 只需要出现一次，否则需要出现两次。
对于 C++ 代码，由于数字范围是 $[-1000， 1000]$，$2x$ 的范围为 $[-2000， 2000]$ 我们只需要创建一个长度为 4001 的数组 $cnt$。为了解决下标为负时越界的问题，我们不直接使用数组 $cnt$，而是设置一个指向 $cnt[2000]$ 的指针 $hash\_set$ 作为哈希表的抽象。这样，取 $hash\_set[i]$ 时会实际取用 $cnt[i + 2000]$，避免了下标越界。

```python []
class Solution:
    def checkIfExist(self, arr: List[int]) -> bool:
        counter = collections.Counter(arr)
        for n in arr:
            if n != 0 and counter[2 * n] >= 1:
                return True
            if n == 0 and counter[2 * n] >= 2:
                return True
        return False
```

```C++ []
class Solution {
public:
    bool checkIfExist(vector<int>& arr) {
        int cnt[4001] = {0};
        int* hash_set = cnt + 2000;
        for (int n : arr)
            ++hash_set[n];
        for (int n : arr)
            if (n != 0 && hash_set[2 * n] >= 1)
                return true;
            else if (n == 0 && hash_set[2 * n] >= 2)
                return true;
        return false;
    }
};
```

##### 复杂度分析：

  * 时间复杂度：$O(n)$
    哈希表的查询时间复杂度为 $O(1)$，查询次数为 $O(n)$，综合起来，时间复杂度为 $O(n)$。
  * 空间复杂度：$O(n)$
    哈希表最多需要存储 $n$ 个元素。
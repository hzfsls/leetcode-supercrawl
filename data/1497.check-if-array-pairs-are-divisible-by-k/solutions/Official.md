#### 方法一：按照余数进行统计

两个数 $x$ 和 $y$ 的和能被 $k$ 整除，当且仅当这两个数对 $k$ 取模的结果 $x_k$ 和 $y_k$ 的和就能被 $k$ 整除。这里我们规定取模的结果大于等于 $0$，无论 $x$ 和 $y$ 的正负性。因此，我们将数组 $\it arr$ 中的每个数 $x$ 对 $k$ 进行取模，并将得到的余数 $x_k$ 进行配对：

- 配对要求 $1$：如果 $x_k = 0$，那么需要找到另一个满足 $y_k = 0$ 的 $y$ 进行配对；

- 配对要求 $2$：如果 $x_k > 0$，那么需要找到另一个满足 $y_k = k - x_k$ 的 $y$ 进行配对。

我们可以使用哈希映射（HashMap）统计取模的结果。对于哈希映射中的每个键值对，键表示一个余数，值表示这个余数出现的次数。在统计完成之后，为了满足题目的要求，将所有的数都进行配对，我们需要保证：

- 统计要求 $1$：哈希映射中键 $0$ 对应的值为偶数，参照第一条配对要求；

- 统计要求 $2$：哈希映射中键 $t~(t>0)$ 和键 $k-t$ 对应的值相等，参照第二条配对要求。

注意在第二条统计要求中，如果 $k$ 为偶数并且 $t = k/2$，那么实际上我们需要键 $t$ 对应的值也为偶数。实际上，如果第一条统计要求满足，那么对应的数有偶数个；如果第二条统计要求除了 $t = k/2$ 的键都满足，那么对应的数也有偶数个。由于题目保证了 $n$ 也为偶数，因此键 $t$ 对应的值也为偶数，我们可以不用对键 $t$ 进行判断。

**细节**

在 `C++` 和 `Java` 语言中，将负数 $x$ 对一个正数 $k$ 进行取模操作，得到的结果小于等于 $0$（即在 $[-k+1, 0]$ 的范围内）。我们可以通过：

```
xk = (x % k + k) % k
```

得到在 $[0, k-1]$ 的范围内的余数。

**代码**

由于哈希映射中的键的范围为 $[0, k-1]$，因此我们可以使用一个长度为 $k$ 的数组代替哈希表，减少编码难度。

```C++ [sol1-C++]
class Solution {
public:
    bool canArrange(vector<int>& arr, int k) {
        vector<int> mod(k);
        for (int num: arr) {
            ++mod[(num % k + k) % k];
        }
        for (int i = 1; i + i < k; ++i) {
            if (mod[i] != mod[k - i]) {
                return false;
            }
        }
        return mod[0] % 2 == 0;
    }
};
```

```Java [sol1-Java]
class Solution {
    public boolean canArrange(int[] arr, int k) {
        int[] mod = new int[k];
        for (int num : arr) {
            ++mod[(num % k + k) % k];
        }
        for (int i = 1; i + i < k; ++i) {
            if (mod[i] != mod[k - i]) {
                return false;
            }
        }
        return mod[0] % 2 == 0;
    }
}
```

```Python [sol1-Python3]
class Solution:
    def canArrange(self, arr: List[int], k: int) -> bool:
        mod = [0] * k
        for num in arr:
            mod[num % k] += 1
        if any(mod[i] != mod[k - i] for i in range(1, k // 2 + 1)):
            return False
        return mod[0] % 2 == 0
```

由于我们需要 $O(n)$ 的时间对余数进行统计，以及 $O(k)$ 的时间对数组进行遍历，这种方法的时间复杂度为 $O(n+k)$。

当然我们也可以使用哈希表。

```C++ [sol2-C++]
class Solution {
public:
    bool canArrange(vector<int>& arr, int k) {
        unordered_map<int, int> mod;
        for (int num: arr) {
            ++mod[(num % k + k) % k];
        }
        for (auto [t, occ]: mod) {
            if (t > 0 && (!mod.count(k - t) || mod[k - t] != occ)) {
                return false;
            }
        }
        return mod[0] % 2 == 0;
    }
};
```

```Java [sol2-Java]
class Solution {
    public boolean canArrange(int[] arr, int k) {
        Map<Integer, Integer> mod = new HashMap<Integer, Integer>();
        for (int num : arr) {
            mod.put((num % k + k) % k, mod.getOrDefault((num % k + k) % k, 0) + 1);
        }
        for (Map.Entry<Integer, Integer> entry : mod.entrySet()) {
            int t = entry.getKey(), occ = entry.getValue();
            if (t > 0 && mod.getOrDefault(k - t, 0) != occ) {
                return false;
            }
        }
        return mod.getOrDefault(0, 0) % 2 == 0;
    }
}
```

```Python [sol2-Python3]
class Solution:
    def canArrange(self, arr: List[int], k: int) -> bool:
        mod = collections.Counter(num % k for num in arr)
        for t, occ in mod.items():
            if t > 0 and (k - t not in mod or mod[k - t] != occ):
                return False
        return mod[0] % 2 == 0
```

遍历数组的时间复杂度为 $O(n)$。当 $n \geq k$ 时，遍历哈希表的时间复杂度为 $O(k)$；当 $n < k$ 时，哈希表中最多只会有 $n$ 个键值对，遍历哈希表的时间复杂度为 $O(n)$，因此总时间复杂度为 $O(n)$。

**复杂度分析**

- 时间复杂度：$O(n + k)$ 或 $O(n)$。

- 空间复杂度：$O(n)$，即为哈希表需要的空间。
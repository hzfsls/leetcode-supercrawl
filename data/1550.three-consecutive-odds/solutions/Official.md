#### 方法一：枚举

**思路与算法**

枚举所有的连续的三个元素，判断这三个元素是否都是奇数，如果是，则返回 `true`。如果所有的连续的三个元素中，没有一个满足条件，返回 `false`。

**代码**

```cpp [sol1-C++]
class Solution {
public:
    bool threeConsecutiveOdds(vector<int>& arr) {
        int n = arr.size();
        for (int i = 0; i <= n - 3; ++i) {
            if ((arr[i] & 1) & (arr[i + 1] & 1) & (arr[i + 2] & 1)) {
                return true;
            }
        }
        return false;
    }
};
```

```Java [sol1-Java]
class Solution {
    public boolean threeConsecutiveOdds(int[] arr) {
        int n = arr.length;
        for (int i = 0; i <= n - 3; ++i) {
            if ((arr[i] & 1) != 0 && (arr[i + 1] & 1) != 0 && (arr[i + 2] & 1) != 0) {
                return true;
            }
        }
        return false;
    }
}
```

```JavaScript [sol1-JavaScript]
var threeConsecutiveOdds = function(arr) {
    const n = arr.length;
    for (let i = 0; i <= n - 3; ++i) {
        if ((arr[i] & 1) & (arr[i + 1] & 1) & (arr[i + 2] & 1)) {
            return true;
        }
    }
    return false;
};
```

```Python [sol1-Python3]
class Solution:
    def threeConsecutiveOdds(self, arr: List[int]) -> bool:
        n = len(arr)
        return n >= 3 and \
            any(arr[i] & 1 and arr[i + 1] & 1 and arr[i + 2] & 1 \
                for i in range(n - 2))
```

**复杂度分析**

记原序列的长度为 $n$。

+ 时间复杂度：$O(n)$。
+ 空间复杂度：$O(1)$。
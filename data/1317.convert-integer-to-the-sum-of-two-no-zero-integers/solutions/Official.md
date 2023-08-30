#### 方法一：枚举

由于题目中给出的 `n` 的范围 `[2, 10000]` 较小，因此我们可以直接在 `[1, n)` 的范围内枚举 `A`，并通过 `n - A` 得到 `B`，再判断 `A` 和 `B` 是否均不包含 `0` 即可。

```C++ [sol1-C++]
class Solution {
public:
    vector<int> getNoZeroIntegers(int n) {
        for (int A = 1; A < n; ++A) {
            int B = n - A;
            if ((to_string(A) + to_string(B)).find('0') == string::npos) {
                return {A, B};
            }
        }
        return {};
    }
};
```

```Python [sol1-Python3]
class Solution:
    def getNoZeroIntegers(self, n: int) -> List[int]:
        for A in range(1, n):
            B = n - A
            if '0' not in str(A) + str(B):
                return [A, B]
        return []
```

**复杂度分析**

- 时间复杂度：$O(N\log N)$，枚举 `A` 的时间复杂度为 $O(N)$，判断 `A` 和 `B` 是否均不包含 `0` 的时间复杂度为 $O(\log N)$，即 `A` 与 `B` 的位数之和。

- 空间复杂度：$O(1)$。
#### 方法一：暴力遍历因数[超出时间限制]

对于想要分解的数字，暴力遍历所有比它小的数字，尝试分解。

```python []
class Solution:
    def divide(self, n):
        ans = [0, int(1e9)]
        for i in range(1, n + 1):
            if n % i == 0:
                if abs(n // i - i) < abs(ans[0] - ans[1]):
                    ans = [n // i, i]
        return ans

    def closestDivisors(self, num: int) -> List[int]:
        ans = [0, int(1e9)]
        for i in range(num + 1, num + 3):
            cur = self.divide(i)
            if abs(cur[0] - cur[1]) < abs(ans[0] - ans[1]):
                ans = cur
        return ans
```

```C++ []
class Solution {
    vector<int> ans{};
public:
    void divide(int n) {
        for (int i = 1; i != n + 1; ++i)
            if (n % i == 0)
                if (abs(n / i - i) < abs(ans[0] - ans[1])) {
                    ans[0] = n / i;
                    ans[1] = i;
                }
    }
    vector<int> closestDivisors(int num) {
        ans.push_back(0);
        ans.push_back(1e9);
        divide(num + 1);
        divide(num + 2);
        return ans;
    }
};
```

##### 复杂度分析

  * 时间复杂度：$O(n)$
  * 空间复杂度：$O(1)$

#### 方法二：以平方根为起点遍历因数

观察问题性质可知，对任意一个在 $[\sqrt n, n]$ 范围内的因数，一定有一个与其对称的在 $[1, \sqrt n]$ 范围内的因数。因此，遍历因数只需要遍历 $[1, \sqrt n]$ 范围即可。
另外，当 $[1, \sqrt n]$ 范围内的因数最大时，与其对称的 $[\sqrt n, n]$ 范围内的因数也最小，此时这两个数字之间的差值一定是所有可能性中最小的。因此，我们只需要找到 $[1, \sqrt n]$ 中的最大因数即可停止。

```python []
class Solution:
    def divide(self, n):
        for i in range(int(math.sqrt(n)), 0, -1):
            if n % i == 0:
                return [i, n // i]

    def closestDivisors(self, num: int) -> List[int]:
        ans = [0, int(1e9)]
        for i in range(num + 1, num + 3):
            cur = self.divide(i)
            if abs(cur[0] - cur[1]) < abs(ans[0] - ans[1]):
                ans = cur
        return ans
```

```C++ []
class Solution {
    vector<int> ans{};
public:
    void divide(int n) {
        for (int i = int(sqrt(n)); i != 0; --i)
            if (n % i == 0)
                if (abs(n / i - i) < abs(ans[0] - ans[1])) {
                    ans[0] = n / i;
                    ans[1] = i;
                }
    }
    vector<int> closestDivisors(int num) {
        ans.push_back(0);
        ans.push_back(1e9);
        divide(num + 1);
        divide(num + 2);
        return ans;
    }
};
```

##### 复杂度分析

  * 时间复杂度：$O(\sqrt n)$
  * 空间复杂度：$O(1)$
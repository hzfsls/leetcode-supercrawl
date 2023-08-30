#### 方法一：模拟

**思路**

阿姆斯特朗数定义：`k` 位数 `N`，其每一位上的数字的 `k` 次幂的总和也是 `N`。


所以只需要计算数字的长度 `k`，再计算每一位对应的值。

**算法**

根据上面的定义，首先需要求出这个数字的位数 `k`，有两种方法：
1. 使用除 10 法求数字的位数，当数字大于 0 时，除以 10 并且位数加一，算法如下：
```
k := 0
for N > 0
    k++
    N = N/10
```
2. 将数字 `N` 转化为字符串，直接求字符串长度。这种方法显然没有上面的方法好，但是简单明了，算法如下：
```
 k = string(N).len()
```

得到位数 `k` 后，只需要再遍历 `N` 上每一个数字，计算数字的 `k` 次幂并累加。同样我们可以使用除 10 法遍历数字的每一位，遍历过程中除 10 取余的结果就是当前的位数。

最后把求出的数和 `N` 比较是否相等。

第一步的第二种方法将 `N` 转化为字符串求 `k`。我们还可以使用此方法一步到底，在第二步同样遍历字符串，把每一位直接转换成数字求值（`python` 代码给出了此解法）。

**代码**

```Golang []
func isArmstrong(N int) bool {
    k := 0
    for t := N; t > 0; t /= 10 {
        k++
    }
    ret := 0
    for t := N; t > 0; t /= 10 {
        mod := t%10
        ret += int(math.Pow(float64(mod), float64(k)))
    }
    return ret == N
}
```

```Java []
class Solution {
    public boolean isArmstrong(int N) {
        int tmp = N, sum = 0;
        int k = String.valueOf(N).length();
        for (int i = 0; i < k; i++) {
            sum += Math.pow(tmp%10, k);
            tmp /= 10;
        }
        return sum == N;
    }
}
```

```Python []
class Solution(object):
    def isArmstrong(self, N):
        """
        :type N: int
        :rtype: bool
        """
        k = len(str(N))
        sum = 0
        for i in str(N):
            sum += int(i)**k
        return sum == N
```

```C++ []
class Solution {
public:
    bool isArmstrong(int N) {
        int k = 0, n = N;
        while (n) {
            ++k;
            n /= 10;
        }
        n = N;
        int sum = 0;
        while (n) {
            sum += pow(n % 10, k);
            n /= 10;
        }
        return sum == N;
    }
};
```

```javascript []
var isArmstrong = function(N) {
    var ori = N
    var bit = String(N).split('')
    var sum = 0, len = bit.length
    for (var i = 0; i < len; ++i) {
        sum = sum + Math.pow(Number(bit[i]), len)
    }
    return sum == ori
};
```

**复杂度分析**

- 时间复杂度：$O(k)$，两次遍历数字 `N`，时间复杂度为 $O(2k)$，其中 $k$ 为数字 `N` 的位数。

- 空间复杂度：$O(1)$，没有使用额外的空间。
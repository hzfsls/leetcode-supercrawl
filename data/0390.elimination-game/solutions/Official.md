## [390.消除游戏 中文官方题解](https://leetcode.cn/problems/elimination-game/solutions/100000/xiao-chu-you-xi-by-leetcode-solution-ydpb)

#### 方法一：等差数列模拟

**思路与算法**

依照题意，我们每次都将整数列表进行间隔删除，因此每次删除后剩余的整数列表都是等差数列。假设第 $k$ 次删除后的等差数列的首元素为 $a_1^k$，末尾元素为 $a_n^k$，公差为 $\textit{step}_k$，元素数目为 $\textit{cnt}_k$，则第 $k+1$ 次删除后的等差数列满足：

$$\textit{step}_{k+1}=\textit{step}_k \times 2$$
$$\textit{cnt}_{k+1}=\Big\lfloor \frac{\textit{cnt}_k}{2} \Big\rfloor$$

初始时 $k=0$，表示尚未删除任何元素。

* 如果 $\textit{k}$ 是偶数，则从左向右删除。

    * 如果元素数目 $\textit{cnt}_k$ 为奇数，则两端的元素都会被删除。
    
    $$
    \begin{aligned}
    a_1^{k+1}&=a_1^k+\textit{step}_k \\
    a_n^{k+1}&=a_n^k-\textit{step}_k
    \end{aligned}
    $$
    
    * 如果元素数目 $\textit{cnt}_k$ 为偶数，则首端元素会被删除，末端元素不会被删除。
    
    $$
    \begin{aligned}
    a_1^{k+1}&=a_1^k+\textit{step}_k \\
    a_n^{k+1}&=a_n^k
    \end{aligned}
    $$

* 如果 $k$ 是奇数，则从右向左删除。

    * 如果元素数目 $\textit{cnt}_k$ 为奇数，则两端的元素都会被删除。
    
    $$
    \begin{aligned}
    a_1^{k+1}&=a_1^k+\textit{step}_k \\
    a_n^{k+1}&=a_n^k-\textit{step}_k
    \end{aligned}
    $$

    * 如果元素数目 $\textit{cnt}_k$ 为偶数，则首端元素不会被删除，末端元素会被删除。
    
    $$
    \begin{aligned}
    a_1^{k+1}&=a_1^k \\
    a_n^{k+1}&=a_n^k-\textit{step}_k
    \end{aligned}
    $$

当等差数列只剩一个元素，即 $\textit{cnt}_k=1$ 时，返回首元素 $a_1^k$ 即可。

注意到末尾元素 $a_n^k$ 可以使用首元素 $a_1^k$、公差 $\textit{step}_k$ 和元素数目 $\textit{cnt}_k$ 表示：

$$a_n^k=a_1^k+\textit{step}_k \times (\textit{cnt}_k-1)$$

因此可以省略末尾元素 $a_n^k$。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    int lastRemaining(int n) {
        int a1 = 1;
        int k = 0, cnt = n, step = 1;
        while (cnt > 1) {
            if (k % 2 == 0) { // 正向
                a1 = a1 + step;
            } else { // 反向
                a1 = (cnt % 2 == 0) ? a1 : a1 + step;
            }
            k++;
            cnt = cnt >> 1;
            step = step << 1;
        }
        return a1;
    }
};
```

```Java [sol1-Java]
class Solution {
    public int lastRemaining(int n) {
        int a1 = 1;
        int k = 0, cnt = n, step = 1;
        while (cnt > 1) {
            if (k % 2 == 0) { // 正向
                a1 = a1 + step;
            } else { // 反向
                a1 = (cnt % 2 == 0) ? a1 : a1 + step;
            }
            k++;
            cnt = cnt >> 1;
            step = step << 1;
        }
        return a1;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int LastRemaining(int n) {
        int a1 = 1;
        int k = 0, cnt = n, step = 1;
        while (cnt > 1) {
            if (k % 2 == 0) { // 正向
                a1 = a1 + step;
            } else { // 反向
                a1 = (cnt % 2 == 0) ? a1 : a1 + step;
            }
            k++;
            cnt = cnt >> 1;
            step = step << 1;
        }
        return a1;
    }
}
```

```C [sol1-C]
int lastRemaining(int n) {
    int a1 = 1;
    int k = 0, cnt = n, step = 1;
    while (cnt > 1) {
        if (k % 2 == 0) { // 正向
            a1 = a1 + step;
        } else { // 反向
            a1 = (cnt % 2 == 0) ? a1 : a1 + step;
        }
        k++;
        cnt = cnt >> 1;
        step = step << 1;
    }
    return a1;
}
```

```Python [sol1-Python3]
class Solution:
    def lastRemaining(self, n: int) -> int:
        a1 = 1
        k, cnt, step = 0, n, 1
        while cnt > 1:
            if k % 2 == 0:  # 正向
                a1 += step
            else:  # 反向
                if cnt % 2:
                    a1 += step
            k += 1
            cnt >>= 1
            step <<= 1
        return a1
```

```go [sol1-Golang]
func lastRemaining(n int) int {
    a1 := 1
    k, cnt, step := 0, n, 1
    for cnt > 1 {
        if k%2 == 0 { // 正向
            a1 += step
        } else { // 反向
            if cnt%2 == 1 {
                a1 += step
            }
        }
        k++
        cnt >>= 1
        step <<= 1
    }
    return a1
}
```

```JavaScript [sol1-JavaScript]
var lastRemaining = function(n) {
    let a1 = 1;
    let k = 0, cnt = n, step = 1;
    while (cnt > 1) {
        if (k % 2 === 0) { // 正向
            a1 = a1 + step;
        } else { // 反向
            a1 = (cnt % 2 === 0) ? a1 : a1 + step;
        }
        k++;
        cnt = cnt >> 1;
        step = step << 1;
    }
    return a1;
};
```

**复杂度分析**

+ 时间复杂度：$O(\log n)$，其中 $n$ 为初始整数列表的元素数目。每次删除都会将元素数目减半，所以时间复杂度为 $O(\log n)$。

+ 空间复杂度：$O(1)$。只需要使用常数的额外空间。
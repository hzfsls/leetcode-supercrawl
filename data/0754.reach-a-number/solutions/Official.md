## [754.到达终点数字 中文官方题解](https://leetcode.cn/problems/reach-a-number/solutions/100000/dao-da-zhong-dian-shu-zi-by-leetcode-sol-ak90)

#### 方法一：分析 + 数学

**思路**

假设移动了 $k$ 次，每次任意地向左或向右移动，那么最终达到的位置实际上就是将 $1,2,3,\ldots,k$ 这 $k$ 个整数添加正号或负号后求和的值。如果 $\textit{target} < 0$，可以将这 $k$ 个数的符号全部取反，这样求和的值为 $-\textit{target} > 0$。因此我们可以只考虑 $\textit{target} > 0$ 的情况。

设 $k$ 为最小的满足 $s = \sum_{i=1}^{k} \geq \textit{target}$ 的正整数。如果 $s = \textit{target}$，那么答案即为 $k$。如果 $s > \textit{target}$，需要在部分整数前添加负号来将和凑到 $\textit{target}$。

如果 $\textit{delta} = s - \textit{target}$ 为偶数，则目标为从 $1$ 到 $k$ 中找出若干个整数使得他们的和为 $\dfrac{\textit{delta}}{2}$，下面证明一定能到找这样的若干个整数。

- 如果 $k \geq \dfrac{\textit{delta}}{2}$，那么只需要选出一个 $\dfrac{\textit{delta}}{2}$。

- 否则，可以先选出 $k$，再从剩余的 $1$ 到 $k-1$ 中选出和为 $\dfrac{\textit{delta}}{2} - k$ 的若干个数即可，这样就把原问题变成了一个规模更小的问题。因为 $\dfrac{\textit{delta}}{2} < s$，因此一定可以找出若干个数使得和为 $\dfrac{\textit{delta}}{2}$。

如果 $\textit{delta}$ 为奇数，那么就无法凑出这样的若干个数字。考虑 $k+1$ 和 $k+2$，$\sum_{i=1}^{k+1}$ 和 $\sum_{i=1}^{k+2}$ 中必有一个和 $s$ 的奇偶性相同，使得此时的 $\textit{delta}$ 为偶数。此时也满足 $\Big\lfloor \dfrac{\textit{delta}}{2} \Big\rfloor < \sum$，因此也可以找到若干个数的和为 $\Big\lfloor \dfrac{\textit{delta}}{2} \Big\rfloor$。

**代码**

```Python [sol1-Python3]
class Solution:
    def reachNumber(self, target: int) -> int:
        target = abs(target)
        k = 0
        while target > 0:
            k += 1
            target -= k
        return k if target % 2 == 0 else k + 1 + k % 2
```

```Java [sol1-Java]
class Solution {
    public int reachNumber(int target) {
        target = Math.abs(target);
        int k = 0;
        while (target > 0) {
            k++;
            target -= k;
        }
        return target % 2 == 0 ? k : k + 1 + k % 2;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int ReachNumber(int target) {
        target = Math.Abs(target);
        int k = 0;
        while (target > 0) {
            k++;
            target -= k;
        }
        return target % 2 == 0 ? k : k + 1 + k % 2;
    }
}
```

```C++ [sol1-C++]
class Solution {
public:
    int reachNumber(int target) {
        target = abs(target);
        int k = 0;
        while (target > 0) {
            k++;
            target -= k;
        }
        return target % 2 == 0 ? k : k + 1 + k % 2;
    }
};
```

```C [sol1-C]
int reachNumber(int target){
    target = abs(target);
    int k = 0;
    while (target > 0) {
        k++;
        target -= k;
    }
    return target % 2 == 0 ? k : k + 1 + k % 2;
}
```

```JavaScript [sol1-JavaScript]
var reachNumber = function(target) {
    target = Math.abs(target);
    let k = 0;
    while (target > 0) {
        k++;
        target -= k;
    }
    return target % 2 === 0 ? k : k + 1 + k % 2;
};
```

```go [sol1-Golang]
func reachNumber(target int) int {
    if target < 0 {
        target = -target
    }
    k := 0
    for target > 0 {
        k++
        target -= k
    }
    if target%2 == 0 {
        return k
    }
    return k + 1 + k%2
}
```

**复杂度分析**

- 时间复杂度：$O(\sqrt{\textit{target}})$。循环内最多执行 $O(\sqrt{\textit{target}})$ 次。

- 空间复杂度：$O(1)$。只使用常数空间。
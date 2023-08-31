## [810.黑板异或游戏 中文官方题解](https://leetcode.cn/problems/chalkboard-xor-game/solutions/100000/hei-ban-yi-huo-you-xi-by-leetcode-soluti-eb0c)
#### 方法一：数学

下文将「按位异或运算」简称为「异或」。

根据游戏规则，轮到某个玩家时，如果当前黑板上所有数字异或结果等于 $0$，则当前玩家获胜。由于 $\text{Alice}$ 是先手，因此如果初始时黑板上所有数字异或结果等于 $0$，则 $\text{Alice}$ 获胜。

下面讨论初始时黑板上所有数字异或结果不等于 $0$ 的情况。

由于两人交替擦除数字，且每次都恰好擦掉一个数字，因此对于这两人中的任意一人，其每次在擦除数字前，黑板上剩余数字的个数的奇偶性一定都是相同的。

这启发我们从数组 $\textit{nums}$ 长度的奇偶性来讨论。如果 $\textit{nums}$ 的长度是偶数，先手 $\text{Alice}$ 是否有可能失败呢？假设 $\text{Alice}$ 面临失败的状态，则只有一种情况，即无论擦掉哪一个数字，剩余所有数字的异或结果都等于 $0$。

下面证明这是不可能的。设数组 $\textit{nums}$ 的长度为 $n$，$n$ 是偶数，用 $\oplus$ 表示异或，记 $S$ 为数组 $\textit{nums}$ 的全部元素的异或结果，则有

$$
S=\textit{nums}[0] \oplus \textit{nums}[1] \oplus \ldots \oplus \textit{nums}[n-1] \ne 0
$$

记 $S_i$ 为擦掉 $\textit{nums}[i]$ 之后，剩余所有数字的异或结果，则有

$$
S_i \oplus \textit{nums}[i] = S
$$

等式两边同时异或 $\textit{nums}[i]$，由于对任意整数 $x$ 都有 $x \oplus x=0$，得

$$
S_i = S \oplus \textit{nums}[i]
$$

如果无论擦掉哪一个数字，剩余的所有数字异或结果都等于 $0$，即对任意 $0 \le i<n$，都有 $S_i=0$。因此对所有的 $S_i$ 异或结果也等于 $0$，即

$$
S_0 \oplus S_1 \oplus \ldots \oplus S_{n-1} = 0
$$

将 $S_i=S \oplus \textit{nums}[i]$ 代入上式，并根据异或运算的交换律和结合律化简，有

$$
\begin{aligned}
0 &= S_0 \oplus S_1 \oplus \ldots \oplus S_{n-1} \\
&= (S \oplus \textit{nums}[0]) \oplus (S \oplus \textit{nums}[1]) \oplus \ldots \oplus (S \oplus \textit{nums}[n-1]) \\
&= (S \oplus S \oplus \ldots \oplus S) \oplus (\textit{nums}[0] \oplus \textit{nums}[1] \oplus \ldots \oplus \textit{nums}[n-1]) \\
&= 0 \oplus S \\
&= S
\end{aligned}
$$

上述计算中，第 $3$ 行的左边括号为 $n$ 个 $S$ 异或，由于 $n$ 是偶数，因此 $n$ 个 $S$ 异或的结果是 $0$。

根据上述计算，可以得到 $S=0$，与实际情况 $S \ne 0$ 矛盾。

**因此当数组的长度是偶数时，先手 $\text{Alice}$ 总能找到一个数字，在擦掉这个数字之后剩余的所有数字异或结果不等于 $0$。**

在 $\text{Alice}$ 擦掉这个数字后，黑板上剩下奇数个数字，无论 $\text{Bob}$ 擦掉哪个数字，留给 $\text{Alice}$ 的一定是黑板上剩下偶数个数字，此时 $\text{Alice}$ 要么获胜，要么仍可以找到一个数字，在擦掉这个数字之后剩余的所有数字异或结果不等于 $0$，因此 $\text{Alice}$ 总能立于不败之地。

同理可得，当数组的长度是奇数时，$\text{Alice}$ 在擦掉一个数字之后，留给 $\text{Bob}$ 的一定是黑板上剩下偶数个数字，因此 $\text{Bob}$ 必胜。

综上所述，当且仅当以下两个条件至少满足一个时，$\text{Alice}$ 必胜：

- 数组 $\textit{nums}$ 的全部元素的异或结果等于 $0$；

- 数组 $\textit{nums}$ 的长度是偶数。

代码实现时，可以先判断数组 $\textit{nums}$ 的长度是否是偶数，当长度是偶数时直接返回 $\text{true}$，当长度是奇数时才需要遍历数组计算全部元素的异或结果。该实现方法在数组长度是偶数时只需要 $O(1)$ 的时间即可得到答案。

```Java [sol1-Java]
class Solution {
    public boolean xorGame(int[] nums) {
        if (nums.length % 2 == 0) {
            return true;
        }
        int xor = 0;
        for (int num : nums) {
            xor ^= num;
        }
        return xor == 0;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public bool XorGame(int[] nums) {
        if (nums.Length % 2 == 0) {
            return true;
        }
        int xor = 0;
        foreach (int num in nums) {
            xor ^= num;
        }
        return xor == 0;
    }
}
```

```JavaScript [sol1-JavaScript]
var xorGame = function(nums) {
    if (nums.length % 2 == 0) {
        return true;
    }
    let xor = 0;
    for (const num of nums) {
        xor ^= num;
    }
    return xor == 0;
};
```

```go [sol1-Golang]
func xorGame(nums []int) bool {
    if len(nums)%2 == 0 {
        return true
    }
    xor := 0
    for _, num := range nums {
        xor ^= num
    }
    return xor == 0
}
```

```Python [sol1-Python3]
class Solution:
    def xorGame(self, nums: List[int]) -> bool:
        if len(nums) % 2 == 0:
            return True
        
        xorsum = reduce(xor, nums)
        return xorsum == 0
```

```C++ [sol1-C++]
class Solution {
public:
    bool xorGame(vector<int>& nums) {
        if (nums.size() % 2 == 0) {
            return true;
        }
        int xorsum = 0;
        for (int num : nums) {
            xorsum ^= num;
        }
        return xorsum == 0;
    }
};
```

```C [sol1-C]
bool xorGame(int* nums, int numsSize) {
    if (numsSize % 2 == 0) {
        return true;
    }
    int xorsum = 0;
    for (int i = 0; i < numsSize; i++) {
        xorsum ^= nums[i];
    }
    return xorsum == 0;
}
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 是数组 $\textit{nums}$ 的长度。最坏情况下，需要遍历数组一次，计算全部元素的异或结果。

- 空间复杂度：$O(1)$。
## [2126.摧毁小行星 中文官方题解](https://leetcode.cn/problems/destroying-asteroids/solutions/100000/cui-hui-xiao-xing-xing-by-leetcode-solut-ng2v)

#### 方法一：贪心

**提示 $1$**

对于两个不同质量的小行星，优先摧毁质量较小的小行星可以摧毁更多的小行星。

**提示 $1$ 解释**

我们假设质量较小的小行星质量为 $m_1$，较大的为 $m_2$。

对于优先摧毁质量较小的小行星的情况，摧毁**第一颗**的充要条件为：

$$
\textit{mass} \ge m_1,
$$

（在摧毁第一颗的前提下）摧毁第二颗的充要条件是：

$$
\textit{mass} + m_1 \ge m_2,
$$

将上述条件结合，可以发现能够**摧毁两颗**的充要条件为：

$$
\textit{mass} \ge \max(m_1, m_2 - m_1);
$$

同理，对于优先摧毁质量较大小行星的情况，摧毁**第一颗**的充要条件为

$$
\textit{mass} \ge m_2,
$$

能够**摧毁两颗**的充要条件为（注意到 $m_1 < m_2$）：

$$
\textit{mass} \ge \max(m_2, m_1 - m_2) = m_2.
$$

由于 $m_1 < m_2$，显然有：

$$
m_2 > \max(m_1, m_2 - m_1).
$$

因此，无论是摧毁第一颗还是全部摧毁，「优先摧毁质量较小的小行星」这一方案对行星质量的要求都更低。这也意味着优先摧毁质量较小的小行星能够摧毁更多的小行星。

**思路与算法**

我们可以类似 **提示 $1$** 对所有行星的**最优摧毁顺序**建立**全序关系**，即质量从小到大。那么，我们对数组 $\textit{asteroids}$ 升序排序，并从左至右模拟并维护行星质量 $\textit{mass}$，进而判断是否可以摧毁全部小行星。

具体地，遍历到下标 $i$ 时，我们首先比较当前小行星质量 $\textit{asteroids}[i]$ 与 $\textit{mass}$ 的关系，此时有两种情况：

- $\textit{mass} \ge \textit{asteroids}[i]$，此时行星可以摧毁该小行星，摧毁后行星质量变为 $\textit{mass} + \textit{asteroids}[i]$；

- $\textit{mass} < \textit{asteroids}[i]$，此时行星无法摧毁该小行星，我们返回 $\texttt{false}$。

如果遍历完成，则说明所有小行星均可摧毁，此时我们返回 $\texttt{true}$。

**细节**

所有小行星的质量总和可能超过 $32$ 位有符号整数的上界，因此对于 $\texttt{C++}$ 等语言，我们可以考虑使用 $64$ 位整数来维护行星的质量。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    bool asteroidsDestroyed(int mass, vector<int>& asteroids) {
        sort(asteroids.begin(), asteroids.end());   // 按照质量升序排序
        long long mass1 = mass;
        for (const int asteroid: asteroids) {
            // 按顺序遍历小行星，尝试摧毁并更新质量或者返回结果
            if (mass1 < asteroid){
                return false;
            }
            mass1 += asteroid;
        }
        return true;   // 成功摧毁所有小行星
    }
};
```


```Python [sol1-Python3]
class Solution:
    def asteroidsDestroyed(self, mass: int, asteroids: List[int]) -> bool:
        asteroids.sort()   # 按照质量升序排序
        for asteroid in asteroids:
            # 按顺序遍历小行星，尝试摧毁并更新质量或者返回结果
            if mass < asteroid:
                return False
            mass += asteroid
        return True   # 成功摧毁所有小行星
```


**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 为数组 $\textit{asteroids}$ 的长度。对数组 $\textit{asteroids}$ 排序的时间复杂度为 $O(n \log n)$，判断是否可以摧毁全部小行星的时间复杂度为 $O(n)$。

- 空间复杂度：$O(\log n)$，即为排序的栈空间开销。
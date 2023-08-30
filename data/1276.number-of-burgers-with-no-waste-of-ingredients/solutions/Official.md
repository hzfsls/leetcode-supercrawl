### 方法一：数学

设巨无霸汉堡有 $x$ 个，皇堡有 $y$ 个，由于所有的材料都需要用完，因此我们可以得到二元一次方程组：

$$
\begin{cases}
4x + 2y = \text{tomatoSlices} \\
x + y = \text{cheeseSlices}
\end{cases}
$$

解得：

$$
\begin{cases}
x = \frac{1}{2} * \text{tomatoSlices} - \text{cheeseSlices} \\
y = 2 * \text{cheeseSlices} - \frac{1}{2} * \text{tomatoSlices}
\end{cases}
$$

根据题意，$x, y \geq 0$ 且 $x, y \in \mathbb{N}$，因此需要满足：

$$
\begin{cases}
\text{tomatoSlices} = 2k, \quad k \in \mathbb{N} \\
\text{tomatoSlices} \geq 2 * \text{cheeseSlices} \\
4 * \text{cheeseSlices} \geq \text{tomatoSlices}
\end{cases}
$$

若不满足，则无解。

```C++ [sol1]
class Solution {
public:
    vector<int> numOfBurgers(int tomatoSlices, int cheeseSlices) {
        if (tomatoSlices % 2 != 0 || tomatoSlices < cheeseSlices * 2 || cheeseSlices * 4 < tomatoSlices) {
            return {};
        }
        return {tomatoSlices / 2 - cheeseSlices, cheeseSlices * 2 - tomatoSlices / 2};
    }
};
```

```Python [sol1]
class Solution:
    def numOfBurgers(self, tomatoSlices: int, cheeseSlices: int) -> List[int]:
        if tomatoSlices % 2 != 0 or tomatoSlices < cheeseSlices * 2 or cheeseSlices * 4 < tomatoSlices:
            return []
        return [tomatoSlices // 2 - cheeseSlices, cheeseSlices * 2 - tomatoSlices // 2]
```

**复杂度分析**

- 时间复杂度：$O(1)$。

- 空间复杂度：$O(1)$。
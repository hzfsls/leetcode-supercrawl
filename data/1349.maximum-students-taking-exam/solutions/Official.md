#### 方法一：记忆化递归 + 状态压缩

##### 递归

以题目中的实例一为例，座位的排布为：

```
 #.##.#
 .####.
 #.##.#
```

将此排布记为 $A$。建模函数 $f(X)$，$f(X)$ 的参数为座位排布，返回值为此种排布最多可能容纳的学生数量。$f(A)$ 即为题目所求。

从第一排开始考虑。我们用数字 1 表示“学生坐在这里”，用数字 0 表示“学生不坐在这里”。第一排可能的安排方式有三种：`010010`，`000010`或者`010000`

当第一排安排方式为`010010`时，第一排容纳了 2 名学生，此时第二排有些座位不可以再坐人。去掉不可以坐人的位置，后排的座位排布为

```
 ######
 #.##.#
```

将此排布记为 $A'_1$。则此时可以容纳的学生数量为 $2+f(A'_1)$。

当第一排安排方式为`000010`时，第一排容纳了 1 名学生，此时第二排有些座位不可以再坐人。去掉不可以坐人的位置，后排的座位排布为

```
 .#####
 #.##.#
```

将此排布记为 $A'_2$。则此时可以容纳的学生数量为 $1+f(A'_2)$。

当第一排安排方式为`010000`时，第一排容纳了 1 名学生，此时第二排有些座位不可以再坐人。去掉不可以坐人的位置，后排的座位排布为

```
 #####.
 #.##.#
```

将此排布记为 $A'_3$。则此时可以容纳的学生数量为 $1+f(A'_3)$。

综合起来，可得
$$f(A)=max(2+f(A'_1),1+f(A'_2),1+f(A'_3))$$

同样，$f(A'_1),f(A'_2),f(A'_3)$ 也可以如此递归求解。对于任意一种座位排布 $X$，函数 $f$ 只需遍历第一排的所有可能安排方式，对于每一种可能性递归求解，取其中的最大结果即可。

此递归的终止条件为：当 $X$ 所剩排数为 1 时，$f(X)$ 可直接返回此排可容纳的最大学生数，而不需要再递归到下一排。

此外可以看到，作为 $f$ 的参数的 $X$，$X$ 只有第一排可能与初始座位排布不同。这是由于后排的座位可用情况不会被 $X$ 的第一排之前的座位情况影响。因此 $f$ 的参数不需要记录后排的所有座位情况，只需要有 $X$ 的第一排的座位情况，以及已经被安排的座位排数即可。

##### 记忆化递归

可以想到，在 $f$ 的递归过程中，会有一些重复情况，比如 $f(A'_1)$ 与 $f(A'_2)$ 都有可能选择`100000`的安排方式，此时它们都会递归到如下情况：

```
 ####.#
```

为了防止对这种递归过程中的重复情况进行多次计算，影响性能，需要采用记忆化递归。即对于任意一个 $X$，在第一次计算 $f(X)$ 时将 $f(X)$ 的值保存在数组中，下次再计算 $f(X)$ 时，直接将数组中保存的值返回，不需要重新计算。采用记忆化递归的方法可以大大降低时间复杂度。

##### 状态压缩

至此，问题只有剩下一个：如何高效地表示 $f$ 的参数 $X$？题目中使用字符串表示座位情况，但字符串处理起来不太方便，代码冗长且效率低下。

观察问题的性质可以发现，对于一个位置，座位情况与可能的学生安排都只有两种：座位情况可能是“可坐”或者“不可坐”，学生安排只可能是“有学生”或者“无学生”。因此，我们可以分别用一个二进制串来表示一排的座位情况，1 表示“可坐”，0 表示“不可坐”，以及这排的可能的学生安排，1 表示“有学生”，0 表示“无学生”。二进制串可以直接用一个整数来存储。这样，就将一排座位的状态由一个字符串压缩成了一个整数。

那么，对于座位情况的判断和操作如何完成呢？记座位情况的数字为 $seats$，学生安排的数字为 $scheme$，我们使用位运算解决：

  * 首先是判断学生安排与本排的座位情况是否冲突，即“不可坐”的座位不可以安排为“有学生”。抽象为二进制运算，即对任意一位， `seats=0,scheme=1` 的情况不合法。因此可以得出结论，`scheme&~seats!=0` 时，座位安排不合法。
  * 其次是判断学生是否有相邻的情况。即对于 $scheme$ 的二进制表示，不可以出现相邻的 1。对于这种情况，可以计算 `(scheme<<1)&scheme`，不为 0 时说明 $scheme$ 中存在相邻的 1.
  * 最后是要根据本排的学生安排来决定下一排的座位情况。即如果 $scheme$ 中某一位为 1，那么下一排的 $seats$ 中，相邻的位需要置为 0.这一目的可以使用如下操作达成：

```python
  seats &= ~(scheme << 1)
  seats &= ~(scheme >> 1)
```

至此，问题就解决了。

```python []
import functools
class Solution:
    @functools.lru_cache(8 * 2 ** 8)
    def f(self, X, row_num, width):
        ans = 0
        for scheme in range(1 << width):
            if scheme & ~X or scheme & (scheme << 1):
                continue
            curans = 0
            for j in range(8):
                if (1 << j) & scheme:
                    curans += 1
            if row_num == len(self.seats) - 1:
                ans = max(ans, curans)
            else:
                next_seats = self.seats[row_num + 1]
                next_seats &= ~(scheme << 1)
                next_seats &= ~(scheme >> 1)
                ans = max(ans, curans + self.f(next_seats, row_num + 1, width))
        return ans

    def compress(self, row):
        ans = 0
        for c in row:
            ans <<= 1
            if c == '.':
                ans += 1
        return ans

    def maxStudents(self, seats: List[List[str]]) -> int:
        self.seats = [self.compress(row) for row in seats]
        return self.f(self.seats[0], 0, len(seats[0]))
```

```C++ []
class Solution {
    int memory[8][1 << 8];
    vector<int> compressed_seats;
    int f(int X, int row_num, int width) {
        if (memory[row_num][X] != -1)
            return memory[row_num][X];
        int ans = 0;
        for (int scheme = 0; scheme != (1 << width); ++scheme) {
            if (scheme & ~X || scheme & (scheme << 1))
                continue;
            int curans = 0;
            for (int j = 0; j != width; ++j)
                if ((1 << j) & scheme)
                    ++curans;
            if (row_num == compressed_seats.size() - 1)
                ans = max(ans, curans);
            else {
                int next_seats = compressed_seats[row_num + 1];
                next_seats &= ~(scheme << 1);
                next_seats &= ~(scheme >> 1);
                ans = max(ans, curans + f(next_seats, row_num + 1, width));
            }
        }
        memory[row_num][X] = ans;
        return ans;
    }
    
    int compress(vector<char>& row) {
        int ans = 0;
        for (char c : row) {
            ans <<= 1;
            if (c == '.')
                ++ans;
        }
        return ans;
    }

public:
    int maxStudents(vector<vector<char>>& seats) {
        for (int i = 0; i != seats.size(); ++i)
            for (int j = 0; j != (1 << seats[0].size()); ++j)
                memory[i][j] = -1;
        for (auto row: seats)
            compressed_seats.push_back(compress(row));
        return f(compressed_seats[0], 0, seats[0].size());
    }
};
```

##### 复杂度分析

  * 时间复杂度：$O(4^nmn)$
  * 空间复杂度：$O(2^nm)$
    需要求解的情况最多有 $2^nm$ 种，求解每个情况所需的时间是 $O(2^nn)$，因此时间复杂度为$O(4^nmn)$，空间复杂度为 $O(2^nm)$ 。
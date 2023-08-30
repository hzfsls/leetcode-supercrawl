#### 方法一：两次遍历

**思路及解法**

我们可以将「相邻的孩子中，评分高的孩子必须获得更多的糖果」这句话拆分为两个规则，分别处理。

- 左规则：当 $\textit{ratings}[i - 1] < \textit{ratings}[i]$ 时，$i$ 号学生的糖果数量将比 $i - 1$ 号孩子的糖果数量多。

- 右规则：当 $\textit{ratings}[i] > \textit{ratings}[i + 1]$ 时，$i$ 号学生的糖果数量将比 $i + 1$ 号孩子的糖果数量多。

我们遍历该数组两次，处理出每一个学生分别满足左规则或右规则时，最少需要被分得的糖果数量。每个人最终分得的糖果数量即为这两个数量的最大值。

具体地，以左规则为例：我们从左到右遍历该数组，假设当前遍历到位置 $i$，如果有 $\textit{ratings}[i - 1] < \textit{ratings}[i]$ 那么 $i$ 号学生的糖果数量将比 $i - 1$ 号孩子的糖果数量多，我们令 $\textit{left}[i] = \textit{left}[i - 1] + 1$ 即可，否则我们令 $\textit{left}[i] = 1$。

在实际代码中，我们先计算出左规则 $\textit{left}$ 数组，在计算右规则的时候只需要用单个变量记录当前位置的右规则，同时计算答案即可。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    int candy(vector<int>& ratings) {
        int n = ratings.size();
        vector<int> left(n);
        for (int i = 0; i < n; i++) {
            if (i > 0 && ratings[i] > ratings[i - 1]) {
                left[i] = left[i - 1] + 1;
            } else {
                left[i] = 1;
            }
        }
        int right = 0, ret = 0;
        for (int i = n - 1; i >= 0; i--) {
            if (i < n - 1 && ratings[i] > ratings[i + 1]) {
                right++;
            } else {
                right = 1;
            }
            ret += max(left[i], right);
        }
        return ret;
    }
};
```

```Java [sol1-Java]
class Solution {
    public int candy(int[] ratings) {
        int n = ratings.length;
        int[] left = new int[n];
        for (int i = 0; i < n; i++) {
            if (i > 0 && ratings[i] > ratings[i - 1]) {
                left[i] = left[i - 1] + 1;
            } else {
                left[i] = 1;
            }
        }
        int right = 0, ret = 0;
        for (int i = n - 1; i >= 0; i--) {
            if (i < n - 1 && ratings[i] > ratings[i + 1]) {
                right++;
            } else {
                right = 1;
            }
            ret += Math.max(left[i], right);
        }
        return ret;
    }
}
```

```go [sol1-Golang]
func candy(ratings []int) (ans int) {
    n := len(ratings)
    left := make([]int, n)
    for i, r := range ratings {
        if i > 0 && r > ratings[i-1] {
            left[i] = left[i-1] + 1
        } else {
            left[i] = 1
        }
    }
    right := 0
    for i := n - 1; i >= 0; i-- {
        if i < n-1 && ratings[i] > ratings[i+1] {
            right++
        } else {
            right = 1
        }
        ans += max(left[i], right)
    }
    return
}

func max(a, b int) int {
    if a > b {
        return a
    }
    return b
}
```

```Python [sol1-Python3]
class Solution:
    def candy(self, ratings: List[int]) -> int:
        n = len(ratings)
        left = [0] * n
        for i in range(n):
            if i > 0 and ratings[i] > ratings[i - 1]:
                left[i] = left[i - 1] + 1
            else:
                left[i] = 1
        
        right = ret = 0
        for i in range(n - 1, -1, -1):
            if i < n - 1 and ratings[i] > ratings[i + 1]:
                right += 1
            else:
                right = 1
            ret += max(left[i], right)
        
        return ret
```

```JavaScript [sol1-JavaScript]
var candy = function(ratings) {
    const n = ratings.length;
    const left = new Array(n).fill(0);
    for (let i = 0; i < n; i++) {
        if (i > 0 && ratings[i] > ratings[i - 1]) {
            left[i] = left[i - 1] + 1;
        } else {
            left[i] = 1;
        }
    }

    let right = 0, ret = 0;
    for (let i = n - 1; i > -1; i--) {
        if (i < n - 1 && ratings[i] > ratings[i + 1]) {
            right++;
        } else {
            right = 1;
        }
        ret += Math.max(left[i], right);
    }
    return ret;
};
```

```C [sol1-C]
int candy(int* ratings, int ratingsSize) {
    int left[ratingsSize];
    for (int i = 0; i < ratingsSize; i++) {
        if (i > 0 && ratings[i] > ratings[i - 1]) {
            left[i] = left[i - 1] + 1;
        } else {
            left[i] = 1;
        }
    }
    int right = 0, ret = 0;
    for (int i = ratingsSize - 1; i >= 0; i--) {
        if (i < ratingsSize - 1 && ratings[i] > ratings[i + 1]) {
            right++;
        } else {
            right = 1;
        }
        ret += fmax(left[i], right);
    }
    return ret;
}
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 是孩子的数量。我们需要遍历两次数组以分别计算满足左规则或右规则的最少糖果数量。

- 空间复杂度：$O(n)$，其中 $n$ 是孩子的数量。我们需要保存所有的左规则对应的糖果数量。

#### 方法二：常数空间遍历

**思路及解法**

注意到糖果总是尽量少给，且从 $1$ 开始累计，每次要么比相邻的同学多给一个，要么重新置为 $1$。依据此规则，我们可以画出下图：

![fig1](https://assets.leetcode-cn.com/solution-static/135/1.png)

其中相同颜色的柱状图的高度总恰好为 $1,2,3 \dots$。

而高度也不一定一定是升序，也可能是 $\dots 3,2,1$ 的降序：

![fig2](https://assets.leetcode-cn.com/solution-static/135/2.png)

注意到在上图中，对于第三个同学，他既可以被认为是属于绿色的升序部分，也可以被认为是属于蓝色的降序部分。因为他同时比两边的同学评分更高。我们对序列稍作修改：

![fig3](https://assets.leetcode-cn.com/solution-static/135/3.png)

注意到右边的升序部分变长了，使得第三个同学不得不被分配 $4$ 个糖果。

依据前面总结的规律，我们可以提出本题的解法。我们从左到右枚举每一个同学，记前一个同学分得的糖果数量为 $\textit{pre}$：

- 如果当前同学比上一个同学评分高，说明我们就在最近的递增序列中，直接分配给该同学 $\textit{pre} + 1$ 个糖果即可。

- 否则我们就在一个递减序列中，我们直接分配给当前同学一个糖果，并把该同学所在的递减序列中所有的同学都再多分配一个糖果，以保证糖果数量还是满足条件。

  - 我们无需显式地额外分配糖果，只需要记录当前的递减序列长度，即可知道需要额外分配的糖果数量。

  - 同时注意当当前的递减序列长度和上一个递增序列等长时，需要把最近的递增序列的最后一个同学也并进递减序列中。

这样，我们只要记录当前递减序列的长度 $\textit{dec}$，最近的递增序列的长度 $\textit{inc}$ 和前一个同学分得的糖果数量 $\textit{pre}$ 即可。

**代码**

```C++ [sol2-C++]
class Solution {
public:
    int candy(vector<int>& ratings) {
        int n = ratings.size();
        int ret = 1;
        int inc = 1, dec = 0, pre = 1;
        for (int i = 1; i < n; i++) {
            if (ratings[i] >= ratings[i - 1]) {
                dec = 0;
                pre = ratings[i] == ratings[i - 1] ? 1 : pre + 1;
                ret += pre;
                inc = pre;
            } else {
                dec++;
                if (dec == inc) {
                    dec++;
                }
                ret += dec;
                pre = 1;
            }
        }
        return ret;
    }
};
```

```Java [sol2-Java]
class Solution {
    public int candy(int[] ratings) {
        int n = ratings.length;
        int ret = 1;
        int inc = 1, dec = 0, pre = 1;
        for (int i = 1; i < n; i++) {
            if (ratings[i] >= ratings[i - 1]) {
                dec = 0;
                pre = ratings[i] == ratings[i - 1] ? 1 : pre + 1;
                ret += pre;
                inc = pre;
            } else {
                dec++;
                if (dec == inc) {
                    dec++;
                }
                ret += dec;
                pre = 1;
            }
        }
        return ret;
    }
}
```

```go [sol2-Golang]
func candy(ratings []int) int {
    n := len(ratings)
    ans, inc, dec, pre := 1, 1, 0, 1
    for i := 1; i < n; i++ {
        if ratings[i] >= ratings[i-1] {
            dec = 0
            if ratings[i] == ratings[i-1] {
                pre = 1
            } else {
                pre++
            }
            ans += pre
            inc = pre
        } else {
            dec++
            if dec == inc {
                dec++
            }
            ans += dec
            pre = 1
        }
    }
    return ans
}
```

```Python [sol2-Python3]
class Solution:
    def candy(self, ratings: List[int]) -> int:
        n = len(ratings)
        ret = 1
        inc, dec, pre = 1, 0, 1

        for i in range(1, n):
            if ratings[i] >= ratings[i - 1]:
                dec = 0
                pre = (1 if ratings[i] == ratings[i - 1] else pre + 1)
                ret += pre
                inc = pre
            else:
                dec += 1
                if dec == inc:
                    dec += 1
                ret += dec
                pre = 1
        
        return ret
```

```JavaScript [sol2-JavaScript]
var candy = function(ratings) {
    const n = ratings.length;
    let ret = 1;
    let inc = 1, dec = 0, pre = 1;

    for (let i = 1; i < n; i++) {
        if (ratings[i] >= ratings[i - 1]) {
            dec = 0;
            if (ratings[i] === ratings[i - 1]) pre = 1;
            else pre++;
            ret += pre;
            inc = pre;
        } else {
            dec++;
            if (dec === inc) {
                dec++;
            }
            ret += dec;
            pre = 1;
        }
    }
    return ret;
};
```

```C [sol2-C]
int candy(int* ratings, int ratingsSize) {
    int ret = 1;
    int inc = 1, dec = 0, pre = 1;
    for (int i = 1; i < ratingsSize; i++) {
        if (ratings[i] >= ratings[i - 1]) {
            dec = 0;
            pre = ratings[i] == ratings[i - 1] ? 1 : pre + 1;
            ret += pre;
            inc = pre;
        } else {
            dec++;
            if (dec == inc) {
                dec++;
            }
            ret += dec;
            pre = 1;
        }
    }
    return ret;
}
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 是孩子的数量。我们需要遍历两次数组以分别计算满足左规则或右规则的最少糖果数量。

- 空间复杂度：$O(1)$。我们只需要常数的空间保存若干变量。
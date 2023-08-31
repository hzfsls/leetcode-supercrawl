## [1799.N 次操作后的最大分数和 中文官方题解](https://leetcode.cn/problems/maximize-score-after-n-operations/solutions/100000/n-ci-cao-zuo-hou-de-zui-da-fen-shu-he-by-i9k5)
#### 方法一：状态压缩 + 动态规划

**思路与算法**

首先题目给出一个长度为 $m = 2 \times n$ 的正整数数组 $\textit{nums}$，现在我们需要对这个数组进行 $n$ 次操作——在第 $i$ 次操作（操作编号从 $1$ 开始），我们需要：选择两个元素 $x$ 和 $y$，并得到分数 $i \times \gcd(x, y)$，其中 $\gcd(x, y)$ 为 $x$ 和 $y$ 的最大公约数，然后把 $x$ 和 $y$ 从 $\textit{nums}$ 中删除。现在我们需要求进行 $n$ 次操作后能获得的最大分数。

因为 $1 \le n \le 7$，所以我们可以用一个整数 $s$ 来表示数组 $\textit{nums}$ 中未删除的数字状态——若数字 $s$ 的二进制串从右往左的第 $i$ 位为 $1$ 则说明原数组中的第 $i$ 位未被删除，否则表示被删除。然后我们设 $\textit{dp}[i]$ 表示对于未删除的数字状态为 $i$ 时，我们往下进行操作能获得的最大分数，因为每次操作都需要删除两个元素，所以对于未删除的数字有奇数个的状态为非法状态，我们可以不做处理。那么我们思考如果进行状态转移——然后对于每个存在偶数个未删除数字的状态 $s$，假设其中有 $t_s$ 个未删除的数字，那么我们需要进行 $\dfrac{t_s}{2}$ 次操作将全部数字删除。那么我们枚举第 $\dfrac{t_s}{2}$ 次操作删除的两个元素可以得到：

$$\textit{dp}[s] = \max\left\{\textit{dp}[s \oplus 2^i \oplus 2^j] + \frac{t_s}{2} \times \gcd(\textit{nums}[i], \textit{nums}[j])\right\} ~,~ i, j \in s \And i < j$$

其中 $s \oplus 2^i \oplus 2^j$ 表示从状态 $s$ 中删除元素 $\textit{nums}[i]$ 和 $\textit{nums}[j]$ 的状态，$\gcd(\textit{nums}[i], \textit{nums}[j])$ 表示 $\textit{nums}[i]$ 和 $\textit{nums}[j]$ 的最大公约数，为了避免重复运算每一对数字的最大公约数，我们可以在「动态规划」前对数组中的每一对数字的最大公约数进行预处理操作。当没有剩下的数字时，即 $s = 0$ 时，我们不能继续往下操作，此时能获得的分数为 $\textit{dp}[0] = 0$。然后我们可以「自底向上」来计算每一个状态，最后我们返回 $\textit{dp}[2 ^ m - 1]$ 即可。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    int maxScore(vector<int>& nums) {
        int m = nums.size();
        vector<int> dp(1 << m, 0);
        vector<vector<int>> gcd_tmp(m, vector<int>(m, 0));
        for (int i = 0; i < m; ++i) {
            for (int j = i + 1; j < m; ++j) {
                gcd_tmp[i][j] = gcd(nums[i], nums[j]);
            }
        }
        int all = 1 << m;
        for (int s = 1; s < all; ++s) {
            int t = __builtin_popcount(s);
            if (t & 1) {
                continue;
            }
            for (int i = 0; i < m; ++i) {
                if ((s >> i) & 1) {
                    for (int j = i + 1; j < m; ++j) {
                        if ((s >> j) & 1) {
                            dp[s] = max(dp[s], dp[s ^ (1 << i) ^ (1 << j)] + t / 2 * gcd_tmp[i][j]);
                        }
                    }
                }
            }
        }
        return dp[all - 1];
    }
};
```

```Java [sol1-Java]
class Solution {
    public int maxScore(int[] nums) {
        int m = nums.length;
        int[] dp = new int[1 << m];
        int[][] gcdTmp = new int[m][m];
        for (int i = 0; i < m; ++i) {
            for (int j = i + 1; j < m; ++j) {
                gcdTmp[i][j] = gcd(nums[i], nums[j]);
            }
        }
        int all = 1 << m;
        for (int s = 1; s < all; ++s) {
            int t = Integer.bitCount(s);
            if ((t & 1) != 0) {
                continue;
            }
            for (int i = 0; i < m; ++i) {
                if (((s >> i) & 1) != 0) {
                    for (int j = i + 1; j < m; ++j) {
                        if (((s >> j) & 1) != 0) {
                            dp[s] = Math.max(dp[s], dp[s ^ (1 << i) ^ (1 << j)] + t / 2 * gcdTmp[i][j]);
                        }
                    }
                }
            }
        }
        return dp[all - 1];
    }

    public int gcd(int num1, int num2) {
        while (num2 != 0) {
            int temp = num1;
            num1 = num2;
            num2 = temp % num2;
        }
        return num1;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int MaxScore(int[] nums) {
        int m = nums.Length;
        int[] dp = new int[1 << m];
        int[][] gcdTmp = new int[m][];
        for (int i = 0; i < m; ++i) {
            gcdTmp[i] = new int[m];
            for (int j = i + 1; j < m; ++j) {
                gcdTmp[i][j] = GCD(nums[i], nums[j]);
            }
        }
        int all = 1 << m;
        for (int s = 1; s < all; ++s) {
            int t = BitCount(s);
            if ((t & 1) != 0) {
                continue;
            }
            for (int i = 0; i < m; ++i) {
                if (((s >> i) & 1) != 0) {
                    for (int j = i + 1; j < m; ++j) {
                        if (((s >> j) & 1) != 0) {
                            dp[s] = Math.Max(dp[s], dp[s ^ (1 << i) ^ (1 << j)] + t / 2 * gcdTmp[i][j]);
                        }
                    }
                }
            }
        }
        return dp[all - 1];
    }

    public int GCD(int num1, int num2) {
        while (num2 != 0) {
            int temp = num1;
            num1 = num2;
            num2 = temp % num2;
        }
        return num1;
    }

    private static int BitCount(int i) {
        i = i - ((i >> 1) & 0x55555555);
        i = (i & 0x33333333) + ((i >> 2) & 0x33333333);
        i = (i + (i >> 4)) & 0x0f0f0f0f;
        i = i + (i >> 8);
        i = i + (i >> 16);
        return i & 0x3f;
    }
}
```

```C [sol1-C]
#define MAX(a, b) ((a) > (b) ? (a) : (b))

int gcd(int num1, int num2) {
    while (num2 != 0) {
        int temp = num1;
        num1 = num2;
        num2 = temp % num2;
    }
    return num1;
}

int maxScore(int* nums, int numsSize) {
    int dp[1 << numsSize];
    int gcd_tmp[numsSize][numsSize];
    memset(dp, 0, sizeof(dp));
    memset(gcd_tmp, 0, sizeof(gcd_tmp));
    for (int i = 0; i < numsSize; ++i) {
        for (int j = i + 1; j < numsSize; ++j) {
            gcd_tmp[i][j] = gcd(nums[i], nums[j]);
        }
    }
    int all = 1 << numsSize;
    for (int s = 1; s < all; ++s) {
        int t = __builtin_popcount(s);
        if (t & 1) {
            continue;
        }
        for (int i = 0; i < numsSize; ++i) {
            if ((s >> i) & 1) {
                for (int j = i + 1; j < numsSize; ++j) {
                    if ((s >> j) & 1) {
                        dp[s] = MAX(dp[s], dp[s ^ (1 << i) ^ (1 << j)] + t / 2 * gcd_tmp[i][j]);
                    }
                }
            }
        }
    }
    return dp[all - 1];
}
```

```JavaScript [sol1-JavaScript]
var maxScore = function(nums) {
    const m = nums.length;
    const dp = new Array(1 << m).fill(0);
    const gcdTmp = new Array(m).fill(0).map(() => new Array(m).fill(0));
    for (let i = 0; i < m; ++i) {
        for (let j = i + 1; j < m; ++j) {
            gcdTmp[i][j] = gcd(nums[i], nums[j]);
        }
    }
    let all = 1 << m;
    for (let s = 1; s < all; ++s) {
        let t = bitCount(s);
        if ((t & 1) !== 0) {
            continue;
        }
        for (let i = 0; i < m; ++i) {
            if (((s >> i) & 1) !== 0) {
                for (let j = i + 1; j < m; ++j) {
                    if (((s >> j) & 1) !== 0) {
                        dp[s] = Math.max(dp[s], dp[s ^ (1 << i) ^ (1 << j)] + Math.floor(t / 2) * gcdTmp[i][j]);
                    }
                }
            }
        }
    }
    return dp[all - 1];
}

const gcd = (num1, num2) => {
    while (num2 !== 0) {
        const temp = num1;
        num1 = num2;
        num2 = temp % num2;
    }
    return num1;
};

const bitCount = (n) => {
    return n.toString(2).split('0').join('').length;
}
```

**复杂度分析**

- 时间复杂度：$O(2 ^ m \times m ^ 2 + \log C \times m ^ 2)$，其中 $m$ 为数组 $\textit{nums}$ 的长度，$C=\max(\textit{nums})$。主要为「动态规划」的求解以及预处理每一对数字最大公约数的时间复杂度。 
- 空间复杂度：$O(2 ^ m + m ^ 2)$，其中 $m$ 为数组 $\textit{nums}$ 的长度，主要为「动态规划」存储每一个状态和预处理中存储原数组中每一对元素最大公约数的空间开销。
## [788.旋转数字 中文官方题解](https://leetcode.cn/problems/rotated-digits/solutions/100000/xuan-zhuan-shu-zi-by-leetcode-solution-q9bh)

#### 方法一：枚举每一个数

**思路与算法**

根据题目的要求，一个数是好数，当且仅当：

- 数中没有出现 $3, 4, 7$；

- 数中至少出现一次 $2$ 或 $5$ 或 $6$ 或 $9$；

- 对于 $0, 1, 8$ 则没有要求。

因此，我们可以枚举 $[1, n]$ 的每一个正整数，并以此判断它们是否满足上述要求即可。在下面的代码中，我们用 $\textit{valid}$ 记录数是否满足第一条要求，$\textit{diff}$ 记录数是否满足第二条要求。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    int rotatedDigits(int n) {
        int ans = 0;
        for (int i = 1; i <= n; ++i) {
            string num = to_string(i);
            bool valid = true, diff = false;
            for (char ch: num) {
                if (check[ch - '0'] == -1) {
                    valid = false;
                }
                else if (check[ch - '0'] == 1) {
                    diff = true;
                }
            }
            if (valid && diff) {
                ++ans;
            }
        }
        return ans;
    }

private:
    static constexpr int check[10] = {0, 0, 1, -1, -1, 1, 1, -1, 0, 1};
};
```

```Java [sol1-Java]
class Solution {
    static int[] check = {0, 0, 1, -1, -1, 1, 1, -1, 0, 1};

    public int rotatedDigits(int n) {
        int ans = 0;
        for (int i = 1; i <= n; ++i) {
            String num = String.valueOf(i);
            boolean valid = true, diff = false;
            for (int j = 0; j < num.length(); ++j) {
                char ch = num.charAt(j);
                if (check[ch - '0'] == -1) {
                    valid = false;
                } else if (check[ch - '0'] == 1) {
                    diff = true;
                }
            }
            if (valid && diff) {
                ++ans;
            }
        }
        return ans;
    }
}
```

```C# [sol1-C#]
public class Solution {
    static int[] check = {0, 0, 1, -1, -1, 1, 1, -1, 0, 1};

    public int RotatedDigits(int n) {
        int ans = 0;
        for (int i = 1; i <= n; ++i) {
            string num = i.ToString();
            bool valid = true, diff = false;
            foreach (char ch in num) {
                if (check[ch - '0'] == -1) {
                    valid = false;
                } else if (check[ch - '0'] == 1) {
                    diff = true;
                }
            }
            if (valid && diff) {
                ++ans;
            }
        }
        return ans;
    }
}
```

```Python [sol1-Python3]
class Solution:
    def rotatedDigits(self, n: int) -> int:
        check = [0, 0, 1, -1, -1, 1, 1, -1, 0, 1]

        ans = 0
        for i in range(1, n + 1):
            num = [int(digit) for digit in str(i)]
            valid, diff = True, False
            for digit in num:
                if check[digit] == -1:
                    valid = False
                elif check[digit] == 1:
                    diff = True
            if valid and diff:
                ans += 1
        
        return ans
```

```C [sol1-C]
const int check[10] = {0, 0, 1, -1, -1, 1, 1, -1, 0, 1};

int rotatedDigits(int n){
    int ans = 0;
    for (int i = 1; i <= n; ++i) {
        char num[8];
        sprintf(num, "%d", i);
        bool valid = true, diff = false;
        for (int j = 0; num[j]; j++) {
            if (check[num[j] - '0'] == -1) {
                valid = false;
            }
            else if (check[num[j] - '0'] == 1) {
                diff = true;
            }
        }
        if (valid && diff) {
            ++ans;
        }
    }
    return ans;
}
```

```JavaScript [sol1-JavaScript]
const check = [0, 0, 1, -1, -1, 1, 1, -1, 0, 1];
var rotatedDigits = function(n) {
    let ans = 0;
    for (let i = 1; i <= n; ++i) {
        const num = '' + i;
        let valid = true, diff = false;
        for (let j = 0; j < num.length; ++j) {
            const ch = num[j];
            if (check[ch.charCodeAt() - '0'.charCodeAt()] === -1) {
                valid = false;
            } else if (check[ch.charCodeAt() - '0'.charCodeAt()] === 1) {
                diff = true;
            }
        }
        if (valid && diff) {
            ++ans;
        }
    }
    return ans;
};
```

```go [sol1-Golang]
var check = [10]int{0, 0, 1, -1, -1, 1, 1, -1, 0, 1}

func rotatedDigits(n int) (ans int) {
    for i := 1; i <= n; i++ {
        valid, diff := true, false
        for _, c := range strconv.Itoa(i) {
            if check[c-'0'] == -1 {
                valid = false
            } else if check[c-'0'] == 1 {
                diff = true
            }
        }
        if valid && diff {
            ans++
        }
    }
    return
}
```

**复杂度分析**

- 时间复杂度：$O(n \log n)$。数 $n$ 的数位有 $\lceil \log_{10} n \rceil + 1 = O(\log n)$ 个，其中 $\lceil \cdot \rceil$ 表示向上取整。因此总时间复杂度为 $O(n \log n)$。

- 空间复杂度：$O(\log n)$。使用的空间分为两部分，第一部分为代码中记录每一个数位类型的数组 $\textit{check}$ 需要使用的 $O(10)=O(1)$ 的空间，第二部分为将数 $i$ 转化为字符串需要使用的临时空间，大小为 $O(\log n)$。这一部分的空间也可以优化至 $O(1)$，只需要每次将 $i$ 对 $10$ 进行取模，从低位到高位获取 $i$ 的每一个数位即可。

#### 方法二：数位动态规划

**思路与算法**

我们也可以用数位动态规划的思路解决本题。由于在一个数之前填加前导零不会改变数本身的好坏，因此我们只需要考虑所有位数与 $n$ 相同并且小于等于 $n$ 的数（可以有前导零）即可。

记 $f(\textit{pos}, \textit{bound}, \textit{diff})$ 为满足如下要求的好数的个数：

- 只从第 $\textit{pos}$ 位开始考虑。这里数的最高位为第 $0$ 位，最低位为第 $\textit{len}-1$ 位，其中 $\textit{len}$ 是数 $n$ 的长度。在计算 $f(\textit{pos}, \textit{bound}, \textit{diff})$ 时，会假设第 $0$ 位到第 $\textit{pos}-1$ 位已经固定，并且会用 $\textit{bound}$ 和 $\textit{diff}$ 两个布尔变量表示这些数位的「状态」；

- 从第 $0$ 位到第 $\textit{pos}-1$ 位的数是否「贴着」$n$，记为 $\textit{bound}$。例如当 $n=12345$，$\textit{pos}=3$ 时，如果前面的数位是 $123$，那就表示贴着 $n$，如果是 $122, 121, \cdots$，那就表示没有贴着 $n$。区分是否「贴着」$n$ 的作用是，如果 $\textit{bound}$ 为真，第 $\textit{pos}$ 位只能在 $0$ 到 $n$ 的第 $\textit{pos}$ 位进行选择，否则构造出的数就超过 $n$ 了；如果 $\textit{bound}$ 为假，那么第 $\textit{pos}$ 位可以在 $0$ 到 $9$ 之间任意选择；

- 从第 $0$ 位到第 $\textit{pos}-1$ 位的数中是否至少出现了一次 $2$ 或 $5$ 或 $6$ 或 $9$，记为 $\textit{diff}$。在进行状态转移时，我们只会枚举（第 $\textit{pos}$ 位的数）$0/1/2/5/6/8/9$ 而不枚举 $3/4/7$，这样可以保证数一定是可以旋转的，只需要额外的状态 $\textit{diff}$ 就能表示其是否为好数。

根据上述的定义，我们需要求出的答案即为 $f(0, \text{True}, \text{False})$。

在进行状态转移时，我们只需要枚举第 $\textit{pos}$ 位选择的数，其可以选择的范围根据 $\textit{bound}$ 的不同而不同（上述定义中已经详细阐述过）。我们可以写出如下的状态转移方程：

$$
f(\textit{pos}, \textit{bound}, \textit{diff}) = \sum f(\textit{pos}+1, \textit{bound'}, \textit{diff'})
$$

那么如何根据选择的数，确定 $\textit{bound'}$ 和 $\textit{diff'}$ 呢？我们可以发现：

- $\textit{bound'}$ 为真，当且仅当 $\textit{bound}$ 为真，并且选择的数恰好与 $n$ 的第 $\textit{pos}$ 个数位相同；

- $\textit{diff'}$ 为真，当且仅当 $\textit{diff}$ 为真，或者选择的数在 $2/5/6/9$ 中。

动态规划的边界情况为出现在 $\textit{pos}$ 等于 $n$ 的长度时，此时所有数位已经确定，那么我们通过 $\textit{diff}$ 就可以知道其是否为好数：如果 $\textit{diff}$ 为真，那么 $f(\textit{pos}, \textit{bound}, \textit{diff})$ 的值为 $1$，否则为 $0$。

该方法使用记忆化搜索编写代码更为方便。

**代码**

```C++ [sol2-C++]
class Solution {
public:
    int rotatedDigits(int n) {
        vector<int> digits;
        while (n) {
            digits.push_back(n % 10);
            n /= 10;
        }
        reverse(digits.begin(), digits.end());
        
        memset(memo, -1, sizeof(memo));
        function<int(int, bool, bool)> dfs = [&](int pos, bool bound, bool diff) -> int {
            if (pos == digits.size()) {
                return diff;
            }
            if (memo[pos][bound][diff] != -1) {
                return memo[pos][bound][diff];
            }

            int ret = 0;
            for (int i = 0; i <= (bound ? digits[pos] : 9); ++i) {
                if (check[i] != -1) {
                    ret += dfs(
                        pos + 1,
                        bound && (i == digits[pos]),
                        diff || (check[i] == 1)
                    );
                }
            }
            return memo[pos][bound][diff] = ret;
        };
        
        int ans = dfs(0, true, false);
        return ans;
    }

private:
    static constexpr int check[10] = {0, 0, 1, -1, -1, 1, 1, -1, 0, 1};
    int memo[5][2][2];
};
```

```Java [sol2-Java]
class Solution {
    static int[] check = {0, 0, 1, -1, -1, 1, 1, -1, 0, 1};
    int[][][] memo = new int[5][2][2];
    List<Integer> digits = new ArrayList<Integer>();

    public int rotatedDigits(int n) {
        while (n != 0) {
            digits.add(n % 10);
            n /= 10;
        }
        Collections.reverse(digits);

        for (int i = 0; i < 5; ++i) {
            for (int j = 0; j < 2; ++j) {
                Arrays.fill(memo[i][j], -1);
            }
        }

        int ans = dfs(0, 1, 0);
        return ans;
    }

    public int dfs(int pos, int bound, int diff) {
        if (pos == digits.size()) {
            return diff;
        }
        if (memo[pos][bound][diff] != -1) {
            return memo[pos][bound][diff];
        }

        int ret = 0;
        for (int i = 0; i <= (bound != 0 ? digits.get(pos) : 9); ++i) {
            if (check[i] != -1) {
                ret += dfs(
                    pos + 1,
                    bound != 0 && i == digits.get(pos) ? 1 : 0,
                    diff != 0 || check[i] == 1 ? 1 : 0
                );
            }
        }
        return memo[pos][bound][diff] = ret;
    }
}
```

```C# [sol2-C#]
public class Solution {
    static int[] check = {0, 0, 1, -1, -1, 1, 1, -1, 0, 1};
    int[,,] memo = new int[5, 2, 2];
    IList<int> digits = new List<int>();

    public int RotatedDigits(int n) {
        while (n != 0) {
            digits.Add(n % 10);
            n /= 10;
        }
        for (int i = 0, j = digits.Count - 1; i < j; ++i, --j) {
            int temp = digits[i];
            digits[i] = digits[j];
            digits[j] = temp;
        }

        for (int i = 0; i < 5; ++i) {
            for (int j = 0; j < 2; ++j) {
                for (int k = 0; k < 2; ++k) {
                    memo[i, j, k] = -1;
                }
            }
        }

        int ans = DFS(0, 1, 0);
        return ans;
    }

    public int DFS(int pos, int bound, int diff) {
        if (pos == digits.Count) {
            return diff;
        }
        if (memo[pos, bound, diff] != -1) {
            return memo[pos, bound, diff];
        }

        int ret = 0;
        for (int i = 0; i <= (bound != 0 ? digits[pos] : 9); ++i) {
            if (check[i] != -1) {
                ret += DFS(
                    pos + 1,
                    bound != 0 && i == digits[pos] ? 1 : 0,
                    diff != 0 || check[i] == 1 ? 1 : 0
                );
            }
        }
        return memo[pos, bound, diff] = ret;
    }
}
```

```Python [sol2-Python3]
class Solution:
    def rotatedDigits(self, n: int) -> int:
        check = [0, 0, 1, -1, -1, 1, 1, -1, 0, 1]
        digits = [int(digit) for digit in str(n)]

        @cache
        def dfs(pos: int, bound: bool, diff: bool) -> int:
            if pos == len(digits):
                return int(diff)
            
            ret = 0
            for i in range(0, (digits[pos] if bound else 9) + 1):
                if check[i] != -1:
                    ret += dfs(
                        pos + 1,
                        bound and i == digits[pos],
                        diff or check[i] == 1
                    )
            
            return ret
            
        
        ans = dfs(0, True, False)
        dfs.cache_clear()
        return ans
```

```C [sol2-C]
static const int check[10] = {0, 0, 1, -1, -1, 1, 1, -1, 0, 1};
int memo[5][2][2];

void reverse(int *arr, int l, int r) {
    while (l < r) {
        int element = arr[l];
        arr[l] = arr[r];
        arr[r] = element;
        l++, r--;
    }
}

int dfs(int pos, bool bound, bool diff, int *digits, int digitsSize) {
    if (pos == digitsSize) {
        return diff;
    }
    if (memo[pos][bound][diff] != -1) {
        return memo[pos][bound][diff];
    }

    int ret = 0;
    for (int i = 0; i <= (bound ? digits[pos] : 9); ++i) {
        if (check[i] != -1) {
            ret += dfs(pos + 1, bound && (i == digits[pos]), diff || (check[i] == 1), digits, digitsSize);
        }
    }
    return memo[pos][bound][diff] = ret;
};

int rotatedDigits(int n) {
    int digits[8];
    int pos = 0;
    while (n) {
        digits[pos++] = n % 10;
        n /= 10;
    }
    reverse(digits, 0, pos - 1);    
    memset(memo, -1, sizeof(memo));
    return dfs(0, true, false, digits, pos);
}
```

```JavaScript [sol2-JavaScript]
var rotatedDigits = function(n) {
    const check = [0, 0, 1, -1, -1, 1, 1, -1, 0, 1];
    const memo = new Array(5).fill(0).map(() => new Array(2).fill(0).map(() => new Array(2).fill(-1)));
    let digits = [];

    const dfs = (pos, bound, diff) => {
        if (pos === digits.length) {
            return diff;
        }
        if (memo[pos][bound][diff] !== -1) {
            return memo[pos][bound][diff];
        }

        let ret = 0;
        for (let i = 0; i <= (bound !== 0 ? digits[pos] : 9); ++i) {
            if (check[i] != -1) {
                ret += dfs(
                    pos + 1,
                    bound !== 0 && i === digits[pos] ? 1 : 0,
                    diff !== 0 || check[i] === 1 ? 1 : 0
                );
            }
        }
        return memo[pos][bound][diff] = ret;
    }

    while (n !== 0) {
        digits.push(n % 10);
        n = Math.floor(n / 10);
    }
    digits = _.reverse(digits);

    const ans = dfs(0, 1, 0);
    return ans;
};
```

```go [sol2-Golang]
var check = [10]int{0, 0, 1, -1, -1, 1, 1, -1, 0, 1}

func rotatedDigits(n int) int {
    digits := strconv.Itoa(n)
    memo := [5][2][2]int{}
    for i := 0; i < 5; i++ {
        memo[i] = [2][2]int{{-1, -1}, {-1, -1}}
    }
    var dfs func(int, bool, bool) int
    dfs = func(pos int, bound, diff bool) (res int) {
        if pos == len(digits) {
            return bool2int(diff)
        }
        ptr := &memo[pos][bool2int(bound)][bool2int(diff)]
        if *ptr != -1 {
            return *ptr
        }
        lim := 9
        if bound {
            lim = int(digits[pos] - '0')
        }
        for i := 0; i <= lim; i++ {
            if check[i] != -1 {
                res += dfs(pos+1, bound && i == int(digits[pos]-'0'), diff || check[i] == 1)
            }
        }
        *ptr = res
        return
    }
    return dfs(0, true, false)
}

func bool2int(b bool) int {
    if b {
        return 1
    }
    return 0
}
```

**复杂度分析**

- 时间复杂度：$O(\log n)$。数 $n$ 的数位有 $\lceil \log_{10} n \rceil + 1 = O(\log n)$ 个，那么动态规划的状态有 $O(\log n \times 2 \times 2) = O(\log n)$ 个，每个状态需要 $O(10) = O(1)$ 的时间进行转移，因此总时间复杂度为 $O(\log n)$。

- 空间复杂度：$O(\log n)$，即为动态规划中存储状态需要使用的空间。
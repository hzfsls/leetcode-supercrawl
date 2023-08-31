## [869.重新排序得到 2 的幂 中文官方题解](https://leetcode.cn/problems/reordered-power-of-2/solutions/100000/zhong-xin-pai-xu-de-dao-2-de-mi-by-leetc-4fvs)

#### 方法一：搜索回溯 + 位运算

将 $n$ 的十进制表示视作一个字符数组，我们可以枚举该数组的所有排列，对每个不含前导零的排列判断其对应的整数是否为 $2$ 的幂。

这可以拆分成两个子问题：

1. 枚举可能包含重复字符的数组的全排列，读者可参考[「47. 全排列 II」的官方题解](https://leetcode-cn.com/problems/permutations-ii/solution/quan-pai-lie-ii-by-leetcode-solution/)；
2. 判断一个整数是否为 $2$ 的幂，读者可参考[「231. 2 的幂」的官方题解](https://leetcode-cn.com/problems/power-of-two/solution/2de-mi-by-leetcode-solution-rny3/)。

对于本题的具体实现，我们可以在递归搜索全排列的同时，计算出当前排列的已枚举的部分所对应的整数 $\textit{num}$。在我们枚举当前排列的下一个字符 $\textit{ch}$ 时，将 $\textit{ch}$ 加到 $\textit{num}$ 的末尾，即 `num = num * 10 + ch - '0'`，然后递归进入下一层。

```Python [sol1-Python3]
def isPowerOfTwo(n: int) -> bool:
    return (n & (n - 1)) == 0

class Solution:
    def reorderedPowerOf2(self, n: int) -> bool:
        nums = sorted(list(str(n)))
        m = len(nums)
        vis = [False] * m

        def backtrack(idx: int, num: int) -> bool:
            if idx == m:
                return isPowerOfTwo(num)
            for i, ch in enumerate(nums):
                # 不能有前导零
                if (num == 0 and ch == '0') or vis[i] or (i > 0 and not vis[i - 1] and ch == nums[i - 1]):
                    continue
                vis[i] = True
                if backtrack(idx + 1, num * 10 + ord(ch) - ord('0')):
                    return True
                vis[i] = False
            return False

        return backtrack(0, 0)
```

```C++ [sol1-C++]
class Solution {
    vector<int> vis;

    bool isPowerOfTwo(int n) {
        return (n & (n - 1)) == 0;
    }

    bool backtrack(string &nums, int idx, int num) {
        if (idx == nums.length()) {
            return isPowerOfTwo(num);
        }
        for (int i = 0; i < nums.length(); ++i) {
            // 不能有前导零
            if ((num == 0 && nums[i] == '0') || vis[i] || (i > 0 && !vis[i - 1] && nums[i] == nums[i - 1])) {
                continue;
            }
            vis[i] = 1;
            if (backtrack(nums, idx + 1, num * 10 + nums[i] - '0')) {
                return true;
            }
            vis[i] = 0;
        }
        return false;
    }

public:
    bool reorderedPowerOf2(int n) {
        string nums = to_string(n);
        sort(nums.begin(), nums.end());
        vis.resize(nums.length());
        return backtrack(nums, 0, 0);
    }
};
```

```Java [sol1-Java]
class Solution {
    boolean[] vis;

    public boolean reorderedPowerOf2(int n) {
        char[] nums = Integer.toString(n).toCharArray();
        Arrays.sort(nums);
        vis = new boolean[nums.length];
        return backtrack(nums, 0, 0);
    }

    public boolean backtrack(char[] nums, int idx, int num) {
        if (idx == nums.length) {
            return isPowerOfTwo(num);
        }
        for (int i = 0; i < nums.length; ++i) {
            // 不能有前导零
            if ((num == 0 && nums[i] == '0') || vis[i] || (i > 0 && !vis[i - 1] && nums[i] == nums[i - 1])) {
                continue;
            }
            vis[i] = true;
            if (backtrack(nums, idx + 1, num * 10 + nums[i] - '0')) {
                return true;
            }
            vis[i] = false;
        }
        return false;
    }

    public boolean isPowerOfTwo(int n) {
        return (n & (n - 1)) == 0;
    }
}
```

```C# [sol1-C#]
public class Solution {
    bool[] vis;

    public bool ReorderedPowerOf2(int n) {
        char[] nums = n.ToString().ToCharArray();
        Array.Sort(nums);
        vis = new bool[nums.Length];
        return Backtrack(nums, 0, 0);
    }

    public bool Backtrack(char[] nums, int idx, int num) {
        if (idx == nums.Length) {
            return IsPowerOfTwo(num);
        }
        for (int i = 0; i < nums.Length; ++i) {
            // 不能有前导零
            if ((num == 0 && nums[i] == '0') || vis[i] || (i > 0 && !vis[i - 1] && nums[i] == nums[i - 1])) {
                continue;
            }
            vis[i] = true;
            if (Backtrack(nums, idx + 1, num * 10 + nums[i] - '0')) {
                return true;
            }
            vis[i] = false;
        }
        return false;
    }

    public bool IsPowerOfTwo(int n) {
        return (n & (n - 1)) == 0;
    }
}
```

```go [sol1-Golang]
func isPowerOfTwo(n int) bool {
    return n&(n-1) == 0
}

func reorderedPowerOf2(n int) bool {
    nums := []byte(strconv.Itoa(n))
    sort.Slice(nums, func(i, j int) bool { return nums[i] < nums[j] })

    m := len(nums)
    vis := make([]bool, m)
    var backtrack func(int, int) bool
    backtrack = func(idx, num int) bool {
        if idx == m {
            return isPowerOfTwo(num)
        }
        for i, ch := range nums {
            // 不能有前导零
            if num == 0 && ch == '0' || vis[i] || i > 0 && !vis[i-1] && ch == nums[i-1] {
                continue
            }
            vis[i] = true
            if backtrack(idx+1, num*10+int(ch-'0')) {
                return true
            }
            vis[i] = false
        }
        return false
    }
    return backtrack(0, 0)
}
```

```JavaScript [sol1-JavaScript]
const reorderedPowerOf2 = (n) => {
    const backtrack = (nums, idx, num) => {
        if (idx === nums.length) {
            return isPowerOfTwo(num);
        }
        for (let i = 0; i < nums.length; ++i) {
            // 不能有前导零
            if ((num === 0 && nums[i] === '0') || vis[i] || (i > 0 && !vis[i - 1] && nums[i] === nums[i - 1])) {
                continue;
            }
            vis[i] = true;
            if (backtrack(nums, idx + 1, num * 10 + nums[i].charCodeAt() - '0'.charCodeAt())) {
                return true;
            }
            vis[i] = false;
        }
        return false;
    }

    const nums = Array.from('' + n);
    nums.sort();
    const vis = new Array(nums.length).fill(false);
    return backtrack(nums, 0, 0);
}

const isPowerOfTwo = (n) => {
    return (n & (n - 1)) === 0;
}
```

**复杂度分析**

- 时间复杂度：$O(m!)$，其中 $m=\lfloor\log_{10} n\rfloor+1$，即 $n$ 的十进制表示的长度。

  算法的复杂度首先受 `backtrack` 的调用次数制约，`backtrack` 的调用次数为 $\sum_{k = 1}^{m}{P(m, k)}$ 次，其中 $P(m, k) = \dfrac{m!}{(m - k)!} = m (m - 1) ... (m - k + 1)$，该式被称作 [$m$ 的 $k$ - 排列，或者部分排列](https://baike.baidu.com/item/%E6%8E%92%E5%88%97/7804523)。

  而 $\sum_{k = 1}^{m}{P(m, k)} = m! + \dfrac{m!}{1!} + \dfrac{m!}{2!} + \dfrac{m!}{3!} + ... + \dfrac{m!}{(m-1)!} < 2m! + \dfrac{m!}{2} + \dfrac{m!}{2^2} + \dfrac{m!}{2^{m-2}} < 3m!$

  这说明 `backtrack` 的调用次数是 $O(m!)$ 的。

  而对于 `backtrack` 调用的每个叶结点（最坏情况下没有重复数字共 $m!$ 个），我们可以用 $O(1)$ 的时间判断 $\textit{num}$ 是否为 $2$ 的幂。

  因此总的时间复杂度为 $O(m!)$。

- 空间复杂度：$O(m)$。我们需要 $O(m)$ 的标记数组，同时在递归的时候栈深度会达到 $O(m)$，因此总空间复杂度为 $O(m+m)=O(2m)=O(m)$。

#### 方法二：预处理 + 哈希表

由于我们可以按任何顺序将数字重新排序，因此对于两个不同的整数 $a$ 和 $b$，如果其十进制表示的字符数组，从小到大排序后的结果是相同的，那么若 $a$ 能够重排得到 $2$ 的幂，$b$ 也可以；若 $a$ 不能重排得到 $2$ 的幂，那么 $b$ 也不能。

进一步地，只要 $a$ 和 $b$ 的十进制表示的字符数组中，从 $\texttt{0}$ 到 $\texttt{9}$ 每个字符的出现次数，在 $a$ 和 $b$ 中都是一样的，那么 $a$ 和 $b$ 能否重排得到 $2$ 的幂的结果是一样的。

由于 $2^{29} < 10^9 < 2^{30}$，因此在 $[1,10^9]$ 范围内有 $2^0,2^1,\cdots,2^{29}$ 一共 $30$ 个 $2$ 的幂。对这 $30$ 个数的每个数，我们可以预处理其十进制表示的字符数组中从 $\texttt{0}$ 到 $\texttt{9}$ 每个字符的出现次数，记在一个长度为 $10$ 的数组中，并用一哈希表记录这些数组。对于数字 $n$，我们同样统计其十进制表示的字符数组中从 $\texttt{0}$ 到 $\texttt{9}$ 每个字符的出现次数，然后去哈希表中查找，若存在则说明 $n$ 可以通过重排得到 $2$ 的幂，否则不能。

```Python [sol2-Python3]
def countDigits(n: int) -> Tuple[int]:
    cnt = [0] * 10
    while n:
        cnt[n % 10] += 1
        n //= 10
    return tuple(cnt)

powerOf2Digits = {countDigits(1 << i) for i in range(30)}

class Solution:
    def reorderedPowerOf2(self, n: int) -> bool:
        return countDigits(n) in powerOf2Digits
```

```C++ [sol2-C++]
string countDigits(int n) {
    string cnt(10, 0);
    while (n) {
        ++cnt[n % 10];
        n /= 10;
    }
    return cnt;
}

unordered_set<string> powerOf2Digits;

int init = []() {
    for (int n = 1; n <= 1e9; n <<= 1) {
        powerOf2Digits.insert(countDigits(n));
    }
    return 0;
}();

class Solution {
public:
    bool reorderedPowerOf2(int n) {
        return powerOf2Digits.count(countDigits(n));
    }
};
```

```Java [sol2-Java]
class Solution {
    Set<String> powerOf2Digits = new HashSet<String>();

    public boolean reorderedPowerOf2(int n) {
        init();
        return powerOf2Digits.contains(countDigits(n));
    }

    public void init() {
        for (int n = 1; n <= 1e9; n <<= 1) {
            powerOf2Digits.add(countDigits(n));
        }
    }

    public String countDigits(int n) {
        char[] cnt = new char[10];
        while (n > 0) {
            ++cnt[n % 10];
            n /= 10;
        }
        return new String(cnt);
    }
}
```

```C# [sol2-C#]
public class Solution {
    ISet<string> powerOf2Digits = new HashSet<string>();

    public bool ReorderedPowerOf2(int n) {
        Init();
        return powerOf2Digits.Contains(CountDigits(n));
    }

    public void Init() {
        for (int n = 1; n <= 1e9; n <<= 1) {
            powerOf2Digits.Add(CountDigits(n));
        }
    }

    public string CountDigits(int n) {
        char[] cnt = new char[10];
        while (n > 0) {
            ++cnt[n % 10];
            n /= 10;
        }
        return new string(cnt);
    }
}
```

```go [sol2-Golang]
func countDigits(n int) (cnt [10]int) {
    for n > 0 {
        cnt[n%10]++
        n /= 10
    }
    return
}

var powerOf2Digits = map[[10]int]bool{}

func init() {
    for n := 1; n <= 1e9; n <<= 1 {
        powerOf2Digits[countDigits(n)] = true
    }
}

func reorderedPowerOf2(n int) bool {
    return powerOf2Digits[countDigits(n)]
}
```

```JavaScript [sol2-JavaScript]
const countDigits = (n) => {
    const cnt = new Array(10).fill(0);
    while (n) {
        cnt[n % 10]++;
        n = Math.floor(n / 10);
    }
    return cnt.join('');
}



var reorderedPowerOf2 = function(n) {
    const powerOf2Digits = new Set();

    for (let n = 1; n <= 1e9; n <<= 1) {
        powerOf2Digits.add(countDigits(n));
    }

    return powerOf2Digits.has(countDigits(n));
};
```

**复杂度分析**

- 时间复杂度：$O(\log n)$。统计 $n$ 的每个数字的出现次数需要 $O(\log n)$ 的时间。

- 空间复杂度：$O(1)$。
#### 方法一：回溯 + 枚举

我们可以通过回溯的方式枚举每一个请求是否被选择。

定义函数 $\text{dfs}(\textit{pos})$ 表示我们正在枚举第 $\textit{pos}$ 个请求。同时，我们使用数组 $\textit{delta}$ 记录每一栋楼的员工变化量，以及变量 $\textit{cnt}$ 记录被选择的请求数量。

对于第 $\textit{pos}$ 个请求 $[x,y]$，如果选择该请求，那么就需要将 $\textit{delta}[x]$ 的值减 $1$，$\textit{delta}[y]$ 的值加 $1$，$\textit{cnt}$ 的值加 $1$；如果不选择该请求，则不需要进行任何操作。在这之后，我们调用 $\text{dfs}(\textit{pos}+1)$ 枚举下一个请求。

如果我们枚举完了全部请求，则需要判断是否满足要求，也就是判断 $\textit{delta}$ 中的所有值是否均为 $0$。若满足要求，则更新答案的最大值。

代码实现时，可以在修改 $\textit{delta}$ 的同时维护 $\textit{delta}$ 中的 $0$ 的个数，记作 $\textit{zero}$，初始值为 $n$。如果 $\textit{delta}[x]$ 增加或减少前为 $0$，则将 $\textit{zero}$ 减 $1$；如果 $\textit{delta}[x]$ 增加或减少后为 $0$，则将 $\textit{zero}$ 加 $1$。

```Python [sol1-Python3]
class Solution:
    def maximumRequests(self, n: int, requests: List[List[int]]) -> int:
        delta = [0] * n
        ans, cnt, zero = 0, 0, n

        def dfs(pos: int) -> None:
            nonlocal ans, cnt, zero
            if pos == len(requests):
                if zero == n:
                    ans = max(ans, cnt)
                return

            # 不选 requests[pos]
            dfs(pos + 1)

            # 选 requests[pos]
            z = zero
            cnt += 1
            x, y = requests[pos]
            zero -= delta[x] == 0
            delta[x] -= 1
            zero += delta[x] == 0
            zero -= delta[y] == 0
            delta[y] += 1
            zero += delta[y] == 0
            dfs(pos + 1)
            delta[y] -= 1
            delta[x] += 1
            cnt -= 1
            zero = z

        dfs(0)
        return ans
```

```C++ [sol1-C++]
class Solution {
private:
    vector<int> delta;
    int ans = 0, cnt = 0, zero, n;

public:
    void dfs(vector<vector<int>> &requests, int pos) {
        if (pos == requests.size()) {
            if (zero == n) {
                ans = max(ans, cnt);
            }
            return;
        }

        // 不选 requests[pos]
        dfs(requests, pos + 1);

        // 选 requests[pos]
        int z = zero;
        ++cnt;
        auto &r = requests[pos];
        int x = r[0], y = r[1];
        zero -= delta[x] == 0;
        --delta[x];
        zero += delta[x] == 0;
        zero -= delta[y] == 0;
        ++delta[y];
        zero += delta[y] == 0;
        dfs(requests, pos + 1);
        --delta[y];
        ++delta[x];
        --cnt;
        zero = z;
    }

    int maximumRequests(int n, vector<vector<int>> &requests) {
        delta.resize(n);
        zero = n;
        this->n = n;
        dfs(requests, 0);
        return ans;
    }
};
```

```Java [sol1-Java]
class Solution {
    int[] delta;
    int ans = 0, cnt = 0, zero, n;

    public int maximumRequests(int n, int[][] requests) {
        delta = new int[n];
        zero = n;
        this.n = n;
        dfs(requests, 0);
        return ans;
    }

    public void dfs(int[][] requests, int pos) {
        if (pos == requests.length) {
            if (zero == n) {
                ans = Math.max(ans, cnt);
            }
            return;
        }

        // 不选 requests[pos]
        dfs(requests, pos + 1);

        // 选 requests[pos]
        int z = zero;
        ++cnt;
        int[] r = requests[pos];
        int x = r[0], y = r[1];
        zero -= delta[x] == 0 ? 1 : 0;
        --delta[x];
        zero += delta[x] == 0 ? 1 : 0;
        zero -= delta[y] == 0 ? 1 : 0;
        ++delta[y];
        zero += delta[y] == 0 ? 1 : 0;
        dfs(requests, pos + 1);
        --delta[y];
        ++delta[x];
        --cnt;
        zero = z;
    }
}
```

```C# [sol1-C#]
public class Solution {
    int[] delta;
    int ans = 0, cnt = 0, zero, n;

    public int MaximumRequests(int n, int[][] requests) {
        delta = new int[n];
        zero = n;
        this.n = n;
        DFS(requests, 0);
        return ans;
    }

    public void DFS(int[][] requests, int pos) {
        if (pos == requests.Length) {
            if (zero == n) {
                ans = Math.Max(ans, cnt);
            }
            return;
        }

        // 不选 requests[pos]
        DFS(requests, pos + 1);

        // 选 requests[pos]
        int z = zero;
        ++cnt;
        int[] r = requests[pos];
        int x = r[0], y = r[1];
        zero -= delta[x] == 0 ? 1 : 0;
        --delta[x];
        zero += delta[x] == 0 ? 1 : 0;
        zero -= delta[y] == 0 ? 1 : 0;
        ++delta[y];
        zero += delta[y] == 0 ? 1 : 0;
        DFS(requests, pos + 1);
        --delta[y];
        ++delta[x];
        --cnt;
        zero = z;
    }
}
```

```go [sol1-Golang]
func maximumRequests(n int, requests [][]int) (ans int) {
	delta := make([]int, n)
	cnt, zero := 0, n
	var dfs func(int)
	dfs = func(pos int) {
		if pos == len(requests) {
			if zero == n && cnt > ans {
				ans = cnt
			}
			return
		}

		// 不选 requests[pos]
		dfs(pos + 1)

		// 选 requests[pos]
		z := zero
		cnt++
		r := requests[pos]
		x, y := r[0], r[1]
		if delta[x] == 0 {
			zero--
		}
		delta[x]--
		if delta[x] == 0 {
			zero++
		}
		if delta[y] == 0 {
			zero--
		}
		delta[y]++
		if delta[y] == 0 {
			zero++
		}
		dfs(pos + 1)
		delta[y]--
		delta[x]++
		cnt--
		zero = z
	}
	dfs(0)
	return
}
```

```C [sol1-C]
#define MAX(a, b) ((a) > (b) ? (a) : (b))

void dfs(const int** requests, int requestsSize,int n, int pos, int * delta, int * ans, int * cnt, int * zero) {
    if (pos == requestsSize) {
        if (*zero == n) {
            *ans = MAX(*ans, *cnt);
        }
        return;
    }

    // 不选 requests[pos]
    dfs(requests, requestsSize, n, pos + 1, delta, ans, cnt, zero);

    // 选 requests[pos]
    int z = *zero;
    ++*cnt;
    const int * r = requests[pos];
    int x = r[0], y = r[1];
    *zero -= delta[x] == 0;
    --delta[x];
    *zero += delta[x] == 0;
    *zero -= delta[y] == 0;
    ++delta[y];
    *zero += delta[y] == 0;
    dfs(requests, requestsSize, n, pos + 1, delta, ans, cnt, zero);
    --delta[y];
    ++delta[x];
    --*cnt;
    *zero = z;
}

int maximumRequests(int n, int** requests, int requestsSize, int* requestsColSize) {
    int * delta = (int *)malloc(sizeof(int) * n);
    memset(delta, 0, sizeof(int) * n);
    int ans = 0, cnt = 0, zero = n;
    dfs(requests, requestsSize, n, 0, delta, &ans, &cnt, &zero);
    return ans;
}
```

```JavaScript [sol1-JavaScript]
var maximumRequests = function(n, requests) {
    const delta = new Array(n).fill(0);
    let zero = n, ans = 0, cnt = 0;
    const dfs = (requests, pos) => {
        if (pos === requests.length) {
            if (zero === n) {
                ans = Math.max(ans, cnt);
            }
            return;
        }

        // 不选 requests[pos]
        dfs(requests, pos + 1);

        // 选 requests[pos]
        let z = zero;
        ++cnt;
        const r = requests[pos];
        let x = r[0], y = r[1];
        zero -= delta[x] == 0 ? 1 : 0;
        --delta[x];
        zero += delta[x] == 0 ? 1 : 0;
        zero -= delta[y] == 0 ? 1 : 0;
        ++delta[y];
        zero += delta[y] == 0 ? 1 : 0;
        dfs(requests, pos + 1);
        --delta[y];
        ++delta[x];
        --cnt;
        zero = z;
    }
    dfs(requests, 0);
    return ans;
};
```

**复杂度分析**

- 时间复杂度：$O(2^m)$，其中 $m$ 是数组 $\textit{requests}$ 的长度，即请求的数量。从 $m$ 个请求中任意选择请求的方案数为 $2^m$，对于每一种方案，我们需要 $O(1)$ 的时间判断其是否满足要求。

- 空间复杂度：$O(m+n)$。递归需要 $O(m)$ 的栈空间，数组 $\textit{delta}$ 需要 $O(n)$ 的空间。

#### 方法二：二进制枚举

我们可以使用一个长度为 $m$ 的二进制数 $\textit{mask}$ 表示所有的请求，其中 $\textit{mask}$ 从低到高的第 $i$ 位为 $1$ 表示选择第 $i$ 个请求，为 $0$ 表示不选第 $i$ 个请求。我们可以枚举 $[0,2^m-1]$ 范围内的所有 $\textit{mask}$，对于每个 $\textit{mask}$，依次枚举其每一位，判断是否为 $1$，并使用与方法一相同的数组 $\textit{delta}$ 以及变量 $\textit{cnt}$ 进行统计，在满足要求时更新答案。

```Python [sol2-Python3]
class Solution:
    def maximumRequests(self, n: int, requests: List[List[int]]) -> int:
        ans = 0
        for mask in range(1 << len(requests)):
            cnt = mask.bit_count()
            if cnt <= ans:
                continue
            delta = [0] * n
            for i, (x, y) in enumerate(requests):
                if mask & (1 << i):
                    delta[x] += 1
                    delta[y] -= 1
            if all(x == 0 for x in delta):
                ans = cnt
        return ans
```

```C++ [sol2-C++]
class Solution {
public:
    int maximumRequests(int n, vector<vector<int>> &requests) {
        vector<int> delta(n);
        int ans = 0, m = requests.size();
        for (int mask = 0; mask < (1 << m); ++mask) {
            int cnt = __builtin_popcount(mask);
            if (cnt <= ans) {
                continue;
            }
            fill(delta.begin(), delta.end(), 0);
            for (int i = 0; i < m; ++i) {
                if (mask & (1 << i)) {
                    ++delta[requests[i][0]];
                    --delta[requests[i][1]];
                }
            }
            if (all_of(delta.begin(), delta.end(), [](int x) { return x == 0; })) {
                ans = cnt;
            }
        }
        return ans;
    }
};
```

```Java [sol2-Java]
class Solution {
    public int maximumRequests(int n, int[][] requests) {
        int[] delta = new int[n];
        int ans = 0, m = requests.length;
        for (int mask = 0; mask < (1 << m); ++mask) {
            int cnt = Integer.bitCount(mask);
            if (cnt <= ans) {
                continue;
            }
            Arrays.fill(delta, 0);
            for (int i = 0; i < m; ++i) {
                if ((mask & (1 << i)) != 0) {
                    ++delta[requests[i][0]];
                    --delta[requests[i][1]];
                }
            }
            boolean flag = true;
            for (int x : delta) {
                if (x != 0) {
                    flag = false;
                    break;
                }
            }
            if (flag) {
                ans = cnt;
            }
        }
        return ans;
    }
}
```

```C# [sol2-C#]
public class Solution {
    public int MaximumRequests(int n, int[][] requests) {
        int[] delta = new int[n];
        int ans = 0, m = requests.Length;
        for (int mask = 0; mask < (1 << m); ++mask) {
            int cnt = BitCount(mask);
            if (cnt <= ans) {
                continue;
            }
            Array.Fill(delta, 0);
            for (int i = 0; i < m; ++i) {
                if ((mask & (1 << i)) != 0) {
                    ++delta[requests[i][0]];
                    --delta[requests[i][1]];
                }
            }
            bool flag = true;
            foreach (int x in delta) {
                if (x != 0) {
                    flag = false;
                    break;
                }
            }
            if (flag) {
                ans = cnt;
            }
        }
        return ans;
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

```go [sol2-Golang]
func maximumRequests(n int, requests [][]int) (ans int) {
next:
    for mask := 0; mask < 1<<len(requests); mask++ {
        cnt := bits.OnesCount(uint(mask))
        if cnt <= ans {
            continue
        }
        delta := make([]int, n)
        for i, r := range requests {
            if mask>>i&1 == 1 {
                delta[r[0]]++
                delta[r[1]]--
            }
        }
        for _, d := range delta {
            if d != 0 {
                continue next
            }
        }
        ans = cnt
    }
    return
}
```

```C [sol2-C]
int maximumRequests(int n, int** requests, int requestsSize, int* requestsColSize) {
    int * delta = (int *)malloc(sizeof(int) * n);
    int ans = 0, m = requestsSize;
    for (int mask = 0; mask < (1 << m); ++mask) {
        int cnt = __builtin_popcount(mask);
        if (cnt <= ans) {
            continue;
        }
        memset(delta, 0, sizeof(int) * n);
        for (int i = 0; i < m; ++i) {
            if (mask & (1 << i)) {
                ++delta[requests[i][0]];
                --delta[requests[i][1]];
            }
        }
        bool flag = true;
        for (int i = 0; i < n; i++) {
            if (delta[i] != 0) {
                flag = false;
                break;
            }
        }
        if (flag) {
            ans = cnt;
        }
    }
    return ans;
}
```

```JavaScript [sol2-JavaScript]
var maximumRequests = function(n, requests) {
    const delta = new Array(n).fill(0);
    let ans = 0, m = requests.length;
    for (let mask = 0; mask < (1 << m); ++mask) {
        let cnt = mask.toString(2).split('0').join('').length;
        if (cnt <= ans) {
            continue;
        }
        delta.fill(0);
        for (let i = 0; i < m; ++i) {
            if ((mask & (1 << i)) !== 0) {
                ++delta[requests[i][0]];
                --delta[requests[i][1]];
            }
        }
        let flag = true;
        for (const x of delta) {
            if (x !== 0) {
                flag = false;
                break;
            }
        }
        if (flag) {
            ans = cnt;
        }
    }
    return ans;
};
```

**复杂度分析**

- 时间复杂度：$O(2^m \times n)$，其中 $m$ 是数组 $\textit{requests}$ 的长度，即请求的数量。从 $m$ 个请求中任意选择请求的方案数为 $2^m$，对于每一种方案，我们需要 $O(n)$ 的时间判断其是否满足要求。

- 空间复杂度：$O(n)$。数组 $\textit{delta}$ 需要 $O(n)$ 的空间。
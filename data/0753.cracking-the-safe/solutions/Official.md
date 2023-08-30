#### 前言

本题和「[332. 重新安排行程](https://leetcode-cn.com/problems/reconstruct-itinerary/)」类似，是力扣平台上为数不多的求解欧拉回路 / 欧拉通路的题目。读者可以配合着进行练习。

#### 方法一：$\text{Hierholzer}$ 算法

$\text{Hierholzer}$ 算法可以在一个欧拉图中找出欧拉回路。

具体地，我们将所有的 $n-1$ 位数作为节点，共有 $k^{n-1}$ 个节点，每个节点有 $k$ 条入边和出边。如果当前节点对应的数为 $a_1 a_2 \cdots a_{n-1}$，那么它的第 $x$ 条出边就连向数 $a_2 \cdots a_{n-1} x$ 对应的节点。这样我们从一个节点顺着第 $x$ 条边走到另一个节点，就相当于输入了数字 $x$。

在某个节点对应的数的末尾放上它的某条出边的编号，就形成了一个 $n$ 位数，并且每个节点都能用这样的方式形成 $k$ 个 $n$ 位数。

> 例如 $k=4$，$n=3$ 时，节点分别为 $00, 01, 02, \cdots, 32, 33$，每个节点的出边的编号分别为 $0, 1, 2, 3$，那么 $00$ 和它的出边形成了 $000, 001, 002, 003$ 这 $4$ 个 $3$ 位数，$32$ 和它的出边形成了 $320, 321, 322, 323$ 这 $4$ 个 $3$ 位数。

这样共计有 $k^{n-1} \times k = k^n$ 个 $n$ 位数，恰好就是所有可能的密码。

由于这个图的每个节点都有 $k$ 条入边和出边，因此它一定存在一个欧拉回路，即可以从任意一个节点开始，一次性不重复地走完所有的边且回到该节点。因此，我们可以用 $\text{Hierholzer}$ 算法找出这条欧拉回路：

设起始节点对应的数为 $u$，欧拉回路中每条边的编号为 $x_1, x_2, x_3, \cdots$，那么最终的字符串即为

$$
u ~ x_1 ~ x_2 ~ x_3 \cdots
$$

$\text{Hierholzer}$ 算法如下：

- 我们从节点 $u$ 开始，**任意地**经过还未经过的边，直到我们「无路可走」。此时我们一定回到了节点 $u$，这是因为所有节点的入度和出度都相等。

- 回到节点 $u$ 之后，我们得到了一条从 $u$ 开始到 $u$ 结束的回路，这条回路上仍然有些节点有未经过的出边。我么从某个这样的节点 $v$ 开始，继续得到一条从 $v$ 开始到 $v$ 结束的回路，再嵌入之前的回路中，即

$$
u \to \cdots \to v \to \cdots \to u
$$

变为

$$
u \to \cdots \to v \to \cdots \to v \to \cdots \to u
$$

以此类推，直到没有节点有未经过的出边，此时我们就找到了一条欧拉回路。

实际的代码编写具有一定的技巧性。

```C++ [sol1-C++]
class Solution {
private:
    unordered_set<int> seen;
    string ans;
    int highest;
    int k;

public:
    void dfs(int node) {
        for (int x = 0; x < k; ++x) {
            int nei = node * 10 + x;
            if (!seen.count(nei)) {
                seen.insert(nei);
                dfs(nei % highest);
                ans += (x + '0');
            }
        }
    }

    string crackSafe(int n, int k) {
        highest = pow(10, n - 1);
        this->k = k;
        dfs(0);
        ans += string(n - 1, '0');
        return ans;
    }
};
```

```Java [sol1-Java]
class Solution {
    Set<Integer> seen = new HashSet<Integer>();
    StringBuffer ans = new StringBuffer();
    int highest;
    int k;

    public String crackSafe(int n, int k) {
        highest = (int) Math.pow(10, n - 1);
        this.k = k;
        dfs(0);
        for (int i = 1; i < n; i++) {
            ans.append('0');
        }
        return ans.toString();
    }

    public void dfs(int node) {
        for (int x = 0; x < k; ++x) {
            int nei = node * 10 + x;
            if (!seen.contains(nei)) {
                seen.add(nei);
                dfs(nei % highest);
                ans.append(x);
            }
        }
    }
}
```

```C# [sol1-C#]
public class Solution {
    ISet<int> seen = new HashSet<int>();
    StringBuilder ans = new StringBuilder();
    int highest;
    int k;

    public string CrackSafe(int n, int k) {
        highest = (int) Math.Pow(10, n - 1);
        this.k = k;
        DFS(0);
        for (int i = 1; i < n; i++) {
            ans.Append('0');
        }
        return ans.ToString();
    }

    public void DFS(int node) {
        for (int x = 0; x < k; ++x) {
            int nei = node * 10 + x;
            if (!seen.Contains(nei)) {
                seen.Add(nei);
                DFS(nei % highest);
                ans.Append(x);
            }
        }
    }
}
```

```Python [sol1-Python3]
class Solution:
    def crackSafe(self, n: int, k: int) -> str:
        seen = set()
        ans = list()
        highest = 10 ** (n - 1)

        def dfs(node: int):
            for x in range(k):
                nei = node * 10 + x
                if nei not in seen:
                    seen.add(nei)
                    dfs(nei % highest)
                    ans.append(str(x))

        dfs(0)
        return "".join(ans) + "0" * (n - 1)
```

```C [sol1-C]
#define N 10000
int visited[N];
char str[N];
int len, k_rec;
int highest;

void dfs(int node) {
    for (int x = 0; x < k_rec; ++x) {
        int nei = node * 10 + x;
        if (!visited[nei]) {
            visited[nei] = 1;
            dfs(nei % highest);
            str[len++] = x + '0';
        }
    }
}

char *crackSafe(int n, int k) {
    memset(visited, 0, sizeof(visited));
    memset(str, 0, sizeof(str));
    k_rec = k, len = 0;
    visited[0] = true;
    highest = pow(10, n - 1);
    dfs(0);
    for (int i = 0; i < n; i++) {
        str[len++] = '0';
    }
    return str;
}
```

```golang [sol1-Golang]
func crackSafe(n int, k int) string {
    seen := map[int]bool{}
    ans := ""
    highest := int(math.Pow(10, float64(n - 1)))
    
    var dfs func(int)
    dfs = func(node int) {
        for x := 0; x < k; x++ {
            nei := node * 10 + x
            if !seen[nei] {
                seen[nei] = true
                dfs(nei % highest)
                ans += strconv.Itoa(x)
            }
        }
    }
    dfs(0)
    for i := 1; i < n; i++ {
        ans += "0"
    }
    return ans
}
```

```JavaScript [sol1-JavaScript]
var crackSafe = function(n, k) {
    highest = Math.pow(10, n - 1);
    let ans = '';
    const seen = new Set();
    const dfs = (node) => {
        for (let x = 0; x < k; ++x) {
            let nei = node * 10 + x;
            if (!seen.has(nei)) {
                seen.add(nei);
                dfs(nei % highest);
                ans += x;
            }
        }
    };

    dfs(0);
    for (let i = 1; i < n; i++) {
        ans += '0';
    }
    return ans;
}
```

**复杂度分析**

- 时间复杂度：$O(n \times k^n)$。

- 空间复杂度：$O(n \times k^n)$。
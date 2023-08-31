## [1652.拆炸弹 中文官方题解](https://leetcode.cn/problems/defuse-the-bomb/solutions/100000/chai-zha-dan-by-leetcode-solution-01x3)
#### 方法一：滑动窗口

**思路与算法**

题目给定了一个长度为 $n$ 的循环数组 $\textit{code}$，和密钥 $k$，我们需要通过 $\textit{code}$ 和 $k$ 来计算正确的密码：

- 当 $k = 0$ 时：对于原数组中的每一个数需要用 $0$ 来替代。
- 当 $k > 0$ 时：对于原数组中的每一个数用该数之后的连续 $k$ 的数字来替代。
- 当 $k < 0$ 时：对于原数组中的每一个数用该数之前的连续 $k$ 的数字来替代。

1. 当 $k = 0$ 时将 $\textit{code}$ 中元素全部置零返回即可。
2. 当 $k \ne 0$ 时：为了说明和编码方便，我们将原数组进行拼接操作 $\textit{code} = \textit{code} + \textit{code}$，并记 $\textit{code}[i,j]$ 表示区间 $[\textit{code}_i,\textit{code}_{i+1},\cdots,\textit{code}_j]$。然后我们用 $l_i$，$r_i$ 来对应 $\textit{code}[i]$ 解密需要的数组区间的左右端点，此时对于 $\forall i \in [0,n)$ 有 $l_i + 1 = l_{i + 1}$，$r_i + 1 = r_{i + 1}$ 成立，那么我们只需要在从左往右遍历的过程中维护 $\textit{code}[l_i,r_i]$ 的和即可。如果不进行拼接，我们也仅需要在维护区间端点时进行取模映射操作，即 $l_{i+1} = (l_i + 1) \pmod n$，$r_{i+1} = (r_i + 1) \pmod n$，使空间复杂度降到 $O(1)$。

**代码**

```Python [sol1-Python3]
class Solution:
    def decrypt(self, code: List[int], k: int) -> List[int]:
        if k == 0:
            return [0] * len(code)
        res = []
        n = len(code)
        code += code
        if k > 0:
            l, r = 1, k
        else:
            l, r = n + k, n - 1
        w = sum(code[l:r+1])
        for i in range(n):
            res.append(w)
            w -= code[l]
            w += code[r + 1]
            l, r = l + 1, r + 1
        return res
```

```Java [sol1-Java]
class Solution {
    public int[] decrypt(int[] code, int k) {
        int n = code.length;
        if (k == 0) {
            return new int[n];
        }
        int[] res = new int[n];
        int[] newCode = new int[n * 2];
        System.arraycopy(code, 0, newCode, 0, n);
        System.arraycopy(code, 0, newCode, n, n);
        code = newCode;
        int l = k > 0 ? 1 : n + k;
        int r = k > 0 ? k : n - 1;
        int w = 0;
        for (int i = l; i <= r; i++) {
            w += code[i];
        }
        for (int i = 0; i < n; i++) {
            res[i] = w;
            w -= code[l];
            w += code[r + 1];
            l++;
            r++;
        }
        return res;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int[] Decrypt(int[] code, int k) {
        int n = code.Length;
        if (k == 0) {
            return new int[n];
        }
        int[] res = new int[n];
        int[] newCode = new int[n * 2];
        Array.Copy(code, 0, newCode, 0, n);
        Array.Copy(code, 0, newCode, n, n);
        code = newCode;
        int l = k > 0 ? 1 : n + k;
        int r = k > 0 ? k : n - 1;
        int w = 0;
        for (int i = l; i <= r; i++) {
            w += code[i];
        }
        for (int i = 0; i < n; i++) {
            res[i] = w;
            w -= code[l];
            w += code[r + 1];
            l++;
            r++;
        }
        return res;
    }
}
```

```C++ [sol1-C++]
class Solution {
public:
    vector<int> decrypt(vector<int>& code, int k) {
        int n = code.size();
        vector<int> res(n);
        if (k == 0) {
            return res;
        }
        code.resize(n * 2);
        copy(code.begin(), code.begin() + n, code.begin() + n);
        int l = k > 0 ? 1 : n + k;
        int r = k > 0 ? k : n - 1;
        int w = 0;
        for (int i = l; i <= r; i++) {
            w += code[i];
        }
        for (int i = 0; i < n; i++) {
            res[i] = w;
            w -= code[l];
            w += code[r + 1];
            l++;
            r++;
        }
        return res;
    }
};
```

```C [sol1-C]
int* decrypt(int* code, int codeSize, int k, int* returnSize) {
    int *newCode = (int *)malloc(sizeof(int) * codeSize * 2);
    memcpy(newCode, code, sizeof(int) * codeSize);
    memcpy(newCode + codeSize, code, sizeof(int) * codeSize);
    int *res = (int *)malloc(sizeof(int) * codeSize);
    memset(res, 0, sizeof(int) * codeSize);
    *returnSize = codeSize;
    code = newCode;
    if (k == 0) {
        return res;
    }
    int l = k > 0 ? 1 : codeSize + k;
    int r = k > 0 ? k : codeSize - 1;
    int w = 0;
    for (int i = l; i <= r; i++) {
        w += code[i];
    }
    for (int i = 0; i < codeSize; i++) {
        res[i] = w;
        w -= code[l];
        w += code[r + 1];
        l++;
        r++;
    }
    free(code);
    return res;
}
```

```JavaScript [sol1-JavaScript]
var decrypt = function(code, k) {
    const n = code.length;
    if (k === 0) {
        return new Array(n).fill(0);
    }
    const res = new Array(n).fill(0);
    const newCode = new Array(n * 2).fill(0).map((_, idx) => {
        return code[idx % code.length];
    });
    code = newCode;
    let l = k > 0 ? 1 : n + k;
    let r = k > 0 ? k : n - 1;
    let w = 0;
    for (let i = l; i <= r; i++) {
        w += code[i];
    }
    for (let i = 0; i < n; i++) {
        res[i] = w;
        w -= code[l];
        w += code[r + 1];
        l++;
        r++;
    }
    return res;
};
```

```go [sol1-Golang]
func decrypt(code []int, k int) []int {
    n := len(code)
    ans := make([]int, n)
    if k == 0 {
        return ans
    }
    code = append(code, code...)
    l, r := 1, k
    if k < 0 {
        l, r = n+k, n-1
    }
    sum := 0
    for _, v := range code[l : r+1] {
        sum += v
    }
    for i := range ans {
        ans[i] = sum
        sum -= code[l]
        sum += code[r+1]
        l, r = l+1, r+1
    }
    return ans
}
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 为数组 $\textit{code}$ 的长度。
- 空间复杂度：$O(n)$，其中 $n$ 为数组 $\textit{code}$ 的长度，主要为数组拼接后的空间开销，也可以通过取模映射操作来将空间复杂度降到 $O(1)$。
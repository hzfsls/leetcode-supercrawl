## [1769.移动所有球到每个盒子所需的最小操作数 中文官方题解](https://leetcode.cn/problems/minimum-number-of-operations-to-move-all-balls-to-each-box/solutions/100000/yi-dong-suo-you-qiu-dao-mei-ge-he-zi-suo-y50e)

#### 方法一：双重循环模拟

**思路**

使用双重循环，第一层循环是遍历所有小球的目的地，第二层循环是计算把所有小球转移到某个目的地盒子的最小操作数，最后返回结果。

**代码**

```Python [sol1-Python3]
class Solution:
    def minOperations(self, boxes: str) -> List[int]:
        res = []
        for i in range(len(boxes)):
            s = sum(abs(j - i) for j, c in enumerate(boxes) if c == '1')
            res.append(s)
        return res
```

```Java [sol1-Java]
class Solution {
    public int[] minOperations(String boxes) {
        int n = boxes.length();
        int[] res = new int[n];
        for (int i = 0; i < n; i++) {
            int sm = 0;
            for (int j = 0; j < n; j++) {
                if (boxes.charAt(j) == '1') {
                    sm += Math.abs(j - i);
                }
            }
            res[i] = sm;
        }
        return res;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int[] MinOperations(string boxes) {
        int n = boxes.Length;
        int[] res = new int[n];
        for (int i = 0; i < n; i++) {
            int sm = 0;
            for (int j = 0; j < n; j++) {
                if (boxes[j] == '1') {
                    sm += Math.Abs(j - i);
                }
            }
            res[i] = sm;
        }
        return res;
    }
}
```

```C++ [sol1-C++]
class Solution {
public:
    vector<int> minOperations(string boxes) {
        int n = boxes.size();
        vector<int> res(n);
        for (int i = 0; i < n; i++) {
            int sm = 0;
            for (int j = 0; j < n; j++) {
                if (boxes[j] == '1') {
                    sm += abs(j - i);
                }
            }
            res[i] = sm;
        }
        return res;
    }
};
```

```C [sol1-C]
int* minOperations(char * boxes, int* returnSize) {
    int n = strlen(boxes);
    int *res = (int *)malloc(sizeof(int) * n);
    for (int i = 0; i < n; i++) {
        int sm = 0;
        for (int j = 0; j < n; j++) {
            if (boxes[j] == '1') {
                sm += abs(j - i);
            }
        }
        res[i] = sm;
    }
    *returnSize = n;
    return res;
}
```

```JavaScript [sol1-JavaScript]
var minOperations = function(boxes) {
    const n = boxes.length;
    const res = [];
    for (let i = 0; i < n; i++) {
        let sm = 0;
        for (let j = 0; j < n; j++) {
            if (boxes[j] === '1') {
                sm += Math.abs(j - i);
            }
        }
        res.push(sm);
    }
    return res;
};
```

```go [sol1-Golang]
func minOperations(boxes string) []int {
    ans := make([]int, len(boxes))
    for i := range boxes {
        for j, c := range boxes {
            if c == '1' {
                ans[i] += abs(i - j)
            }
        }
    }
    return ans
}

func abs(x int) int {
    if x < 0 {
        return -x
    }
    return x
}
```

**复杂度分析**

- 时间复杂度：$O(n^2)$，需要二重循环。

- 空间复杂度：$O(1)$，除了结果数组外，只需要常数空间。

#### 方法二：根据前一个盒子的操作数得到下一个盒子的操作数

**思路**

记把所有球转移到当前下标为 $i$ 的盒子的操作数为 $\textit{operation}_i$，初始情况下当前盒子及其左侧有 $\textit{left}_i$ 个球，右侧有 $\textit{right}_i$ 个球。那么，已知这三者的情况下，把所有球转移到当前下标为 $i+1$ 的盒子的操作数 $\textit{operation}_{i+1}$ 就可以由 $\textit{operation}_i + \textit{left}_i - \textit{right}_i$ 快速得出，因为原来左侧的 $\textit{left}_i$ 个球各需要多操作一步，原来右侧的 $\textit{right}_i$ 个球可以各少操作一步。计算完 $\textit{operation}_{i+1}$ 后，需要更新 $\textit{left}_{i+1}$ 和 $\textit{right}_{i+1}$。而初始的 $\textit{operation}_{0}$，$\textit{left}_{0}$ 和 $\textit{right}_{0}$ 可以通过模拟计算。

**代码**

```Python [sol2-Python3]
class Solution:
    def minOperations(self, boxes: str) -> List[int]:
        left, right, operations = int(boxes[0]), 0, 0
        for i in range(1, len(boxes)):
            if boxes[i] == '1':
                right += 1
                operations += i
        res = [operations]
        for i in range(1, len(boxes)):
            operations += left - right
            if boxes[i] == '1':
                left += 1
                right -= 1
            res.append(operations)
        return res
```

```Java [sol2-Java]
class Solution {
    public int[] minOperations(String boxes) {
        int left = boxes.charAt(0) - '0', right = 0, operations = 0;
        int n = boxes.length();
        for (int i = 1; i < n; i++) {
            if (boxes.charAt(i) == '1') {
                right++;
                operations += i;
            }
        }
        int[] res = new int[n];
        res[0] = operations;
        for (int i = 1; i < n; i++) {
            operations += left - right;
            if (boxes.charAt(i) == '1') {
                left++;
                right--;
            }
            res[i] = operations;
        }
        return res;
    }
}
```

```C# [sol2-C#]
public class Solution {
    public int[] MinOperations(string boxes) {
        int left = boxes[0] - '0', right = 0, operations = 0;
        int n = boxes.Length;
        for (int i = 1; i < n; i++) {
            if (boxes[i] == '1') {
                right++;
                operations += i;
            }
        }
        int[] res = new int[n];
        res[0] = operations;
        for (int i = 1; i < n; i++) {
            operations += left - right;
            if (boxes[i] == '1') {
                left++;
                right--;
            }
            res[i] = operations;
        }
        return res;
    }
}
```

```C++ [sol2-C++]
class Solution {
public:
    vector<int> minOperations(string boxes) {
        int left = boxes[0] - '0', right = 0, operations = 0;
        int n = boxes.size();
        for (int i = 1; i < n; i++) {
            if (boxes[i] == '1') {
                right++;
                operations += i;
            }
        }
        vector<int> res(n);
        res[0] = operations;
        for (int i = 1; i < n; i++) {
            operations += left - right;
            if (boxes[i] == '1') {
                left++;
                right--;
            }
            res[i] = operations;
        }
        return res;
    }
};
```

```C [sol2-C]
int* minOperations(char * boxes, int* returnSize) {
    int left = boxes[0] - '0', right = 0, operations = 0;
    int n = strlen(boxes);
    for (int i = 1; i < n; i++) {
        if (boxes[i] == '1') {
            right++;
            operations += i;
        }
    }
    int *res = (int *)malloc(sizeof(int) * n);
    res[0] = operations;
    for (int i = 1; i < n; i++) {
        operations += left - right;
        if (boxes[i] == '1') {
            left++;
            right--;
        }
        res[i] = operations;
    }
    *returnSize = n;
    return res;
}
```

```JavaScript [sol2-JavaScript]
var minOperations = function(boxes) {
    let left = boxes[0].charCodeAt() - '0'.charCodeAt(), right = 0, operations = 0;
    const n = boxes.length;
    for (let i = 1; i < n; i++) {
        if (boxes[i] === '1') {
            right++;
            operations += i;
        }
    }
    const res = new Array(n).fill(0);
    res[0] = operations;
    for (let i = 1; i < n; i++) {
        operations += left - right;
        if (boxes[i] === '1') {
            left++;
            right--;
        }
        res[i] = operations;
    }
    return res;
}
```

```go [sol2-Golang]
func minOperations(boxes string) []int {
    left := int(boxes[0] - '0')
    right := 0
    operations := 0
    n := len(boxes)
    for i := 1; i < n; i++ {
        if boxes[i] == '1' {
            right++
            operations += i
        }
    }
    ans := make([]int, n)
    ans[0] = operations
    for i := 1; i < n; i++ {
        operations += left - right
        if boxes[i] == '1' {
            left++
            right--
        }
        ans[i] = operations
    }
    return ans
}
```

**复杂度分析**

- 时间复杂度：$O(n)$，只需要遍历两次输入。

- 空间复杂度：$O(1)$，除了结果数组外，只需要常数空间。
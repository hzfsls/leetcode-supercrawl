## [553.最优除法 中文官方题解](https://leetcode.cn/problems/optimal-division/solutions/100000/zui-you-chu-fa-by-leetcode-solution-lf4c)

#### 方法一：动态规划

**思路**

设 $\textit{dp}[i][j]$ 表示数组 $\textit{nums}$ 索引区间 $[i,j]$ 通过添加不同的符号从而可以获取的最小值与最大值为 $\textit{minVal}_{(i,j)},\textit{maxVal}_{(i,j)}$，以及它们对应的表达式字符串为 $\textit{minStr}_{(i,j)},\textit{maxStr}_{(i,j)}$。可以通过枚举不同的索引 $k$ 且满足 $k \in [i,j]$，从而获取区间 $[i,j]$ 最大值与最小值以及对应的字符串表达式。

+ 通过枚举 $k$ 满足 $k \in [i,j)$ 将区间 $[i,j]$ 分为 $[i,k],[k+1,j]$ 左右两部分，则区间 $[i,j]$ 的最小值可以通过左边部分的最小值除以右边部分的最大值得到，最大值可以通过左边部分的最大值除以右边部分的最小值得到。

+ 通过以上推论可以知道其中区间 $[i,j]$ 最大值与最小值动态规划的递推公式如下：
$$
\textit{minVal}_{(i,j)} = \min(\dfrac{\textit{minVal}_{(i,k)}}{\textit{maxVal}_{(k+1,j)}}) \qquad k \in [i,j) \\
\textit{maxVal}_{(i,j)} = \max(\dfrac{\textit{maxVal}_{(i,k)}}{\textit{minVal}_{(k+1,j)}}) \qquad k \in [i,j) \\
$$

+ 枚举不同的 $k$ 时，当找到区间 $[i,j]$ 的最小值与最大值时，还需要同时记录最大值与最小值时对应的表达式字符串 $\textit{minStr}_{(i,j)},\textit{maxStr}_{(i,j)}$。由于除法运算是从左到右的，也就是最左边的除法默认先执行，所以不需要给左边部分添加括号，但需要给右边部分添加括号。比方假设左边部分是 $\texttt{"2"}$ ，右边部分是 $\texttt{"3/4"}$，那么结果字符串 $\texttt{"2/(3/4)"}$。如果右边部分只有一个数字，题目要求返回结果不含有冗余括号，此时也不需要添加括号。假如左边部分是 $\texttt{"2"}$ 且右边部分是 $\texttt{"3"}$ （只包含单个数字），那么答案应该是 $\texttt{"2/3"}$ 而不是 $\texttt{"2/(3)"}$。

**代码**

```Python [sol1-Python3]
class Node:
    def __init__(self):
        self.minVal = 1e4
        self.maxVal = 0
        self.minStr = ""
        self.maxStr = ""

class Solution:
    def optimalDivision(self, nums: List[int]) -> str:
        n = len(nums)
        dp = [[Node() for _ in range(n)] for _ in range(n)]
        for i, num in enumerate(nums):
            dp[i][i].minVal = num
            dp[i][i].maxVal = num
            dp[i][i].minStr = str(num)
            dp[i][i].maxStr = str(num)
        for i in range(n):
            for j in range(n - i):
                for k in range(j, j + i):
                    if dp[j][j + i].maxVal < dp[j][k].maxVal / dp[k + 1][j + i].minVal:
                        dp[j][j + i].maxVal = dp[j][k].maxVal / dp[k + 1][j + i].minVal
                        if k + 1 == j + i:
                            dp[j][j + i].maxStr = dp[j][k].maxStr + "/" + dp[k + 1][j + i].minStr
                        else:
                            dp[j][j + i].maxStr = dp[j][k].maxStr + "/(" + dp[k + 1][j + i].minStr + ")"
                    if dp[j][j + i].minVal > dp[j][k].minVal / dp[k + 1][j + i].maxVal:
                        dp[j][j + i].minVal = dp[j][k].minVal / dp[k + 1][j + i].maxVal
                        if k + 1 == j + i:
                            dp[j][j + i].minStr = dp[j][k].minStr + "/" + dp[k + 1][j + i].maxStr
                        else:
                            dp[j][j + i].minStr = dp[j][k].minStr + "/(" + dp[k + 1][j + i].maxStr + ")"
        return dp[0][n - 1].maxStr
```

```C++ [sol1-C++]
struct Node {
    double maxVal, minVal;
    string minStr, maxStr;
    Node() {
        this->minVal = 10000.0;
        this->maxVal = 0.0;
    }
};

class Solution {
public:
    string optimalDivision(vector<int>& nums) {
        int n = nums.size();
        vector<vector<Node>> dp(n, vector<Node>(n));

        for (int i = 0; i < n; i++) {
            dp[i][i].minVal = nums[i];
            dp[i][i].maxVal = nums[i];
            dp[i][i].minStr = to_string(nums[i]);
            dp[i][i].maxStr = to_string(nums[i]);
        }
        for (int i = 1; i < n; i++) {
            for (int j = 0; j + i < n; j++) {
                for (int k = j; k < j + i; k++) {
                    if (dp[j][j + i].maxVal < dp[j][k].maxVal / dp[k + 1][j + i].minVal) {
                        dp[j][j + i].maxVal = dp[j][k].maxVal / dp[k + 1][j + i].minVal;
                        if (k + 1 == j + i) {
                            dp[j][j + i].maxStr = dp[j][k].maxStr + "/" + dp[k + 1][j + i].minStr;
                        } else {
                            dp[j][j + i].maxStr = dp[j][k].maxStr + "/(" + dp[k + 1][j + i].minStr + ")";
                        }
                    }
                    if (dp[j][j + i].minVal > dp[j][k].minVal / dp[k + 1][j + i].maxVal) {
                        dp[j][j + i].minVal = dp[j][k].minVal / dp[k + 1][j + i].maxVal;
                        if (k + 1 == j + i) {
                            dp[j][j + i].minStr = dp[j][k].minStr + "/" + dp[k + 1][j + i].maxStr; 
                        } else {
                            dp[j][j + i].minStr = dp[j][k].minStr + "/(" + dp[k + 1][j + i].maxStr + ")"; 
                        }
                    }
                }
            }
        }
        return dp[0][n - 1].maxStr;
    }
};
```

```Java [sol1-Java]
class Solution {
    public String optimalDivision(int[] nums) {
        int n = nums.length;
        Node[][] dp = new Node[n][n];
        for (int i = 0; i < n; i++) {
            for (int j = i; j < n; j++) {
                dp[i][j] = new Node();
            }
        }

        for (int i = 0; i < n; i++) {
            dp[i][i].minVal = nums[i];
            dp[i][i].maxVal = nums[i];
            dp[i][i].minStr = String.valueOf(nums[i]);
            dp[i][i].maxStr = String.valueOf(nums[i]);
        }
        for (int i = 1; i < n; i++) {
            for (int j = 0; j + i < n; j++) {
                for (int k = j; k < j + i; k++) {
                    if (dp[j][j + i].maxVal < dp[j][k].maxVal / dp[k + 1][j + i].minVal) {
                        dp[j][j + i].maxVal = dp[j][k].maxVal / dp[k + 1][j + i].minVal;
                        if (k + 1 == j + i) {
                            dp[j][j + i].maxStr = dp[j][k].maxStr + "/" + dp[k + 1][j + i].minStr;
                        } else {
                            dp[j][j + i].maxStr = dp[j][k].maxStr + "/(" + dp[k + 1][j + i].minStr + ")";
                        }
                    }
                    if (dp[j][j + i].minVal > dp[j][k].minVal / dp[k + 1][j + i].maxVal) {
                        dp[j][j + i].minVal = dp[j][k].minVal / dp[k + 1][j + i].maxVal;
                        if (k + 1 == j + i) {
                            dp[j][j + i].minStr = dp[j][k].minStr + "/" + dp[k + 1][j + i].maxStr; 
                        } else {
                            dp[j][j + i].minStr = dp[j][k].minStr + "/(" + dp[k + 1][j + i].maxStr + ")"; 
                        }
                    }
                }
            }
        }
        return dp[0][n - 1].maxStr;
    }
}

class Node {
    double maxVal, minVal;
    String minStr, maxStr;

    public Node() {
        this.minVal = 10000.0;
        this.maxVal = 0.0;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public string OptimalDivision(int[] nums) {
        int n = nums.Length;
        Node[,] dp = new Node[n, n];
        for (int i = 0; i < n; i++) {
            for (int j = i; j < n; j++) {
                dp[i, j] = new Node();
            }
        }

        for (int i = 0; i < n; i++) {
            dp[i, i].MinVal = nums[i];
            dp[i, i].MaxVal = nums[i];
            dp[i, i].MinStr = nums[i].ToString();
            dp[i, i].MaxStr = nums[i].ToString();
        }
        for (int i = 1; i < n; i++) {
            for (int j = 0; j + i < n; j++) {
                for (int k = j; k < j + i; k++) {
                    if (dp[j, j + i].MaxVal < dp[j, k].MaxVal / dp[k + 1, j + i].MinVal) {
                        dp[j, j + i].MaxVal = dp[j, k].MaxVal / dp[k + 1, j + i].MinVal;
                        if (k + 1 == j + i) {
                            dp[j, j + i].MaxStr = dp[j, k].MaxStr + "/" + dp[k + 1, j + i].MinStr;
                        } else {
                            dp[j, j + i].MaxStr = dp[j, k].MaxStr + "/(" + dp[k + 1, j + i].MinStr + ")";
                        }
                    }
                    if (dp[j, j + i].MinVal > dp[j, k].MinVal / dp[k + 1, j + i].MaxVal) {
                        dp[j, j + i].MinVal = dp[j, k].MinVal / dp[k + 1, j + i].MaxVal;
                        if (k + 1 == j + i) {
                            dp[j, j + i].MinStr = dp[j, k].MinStr + "/" + dp[k + 1, j + i].MaxStr; 
                        } else {
                            dp[j, j + i].MinStr = dp[j, k].MinStr + "/(" + dp[k + 1, j + i].MaxStr + ")"; 
                        }
                    }
                }
            }
        }
        return dp[0, n - 1].MaxStr;
    }
}

class Node {
    public double MaxVal { get; set; }
    public double MinVal { get; set; }
    public string MinStr { get; set; }
    public string MaxStr { get; set; }

    public Node() {
        this.MinVal = 10000.0;
        this.MaxVal = 0.0;
    }
}
```

```C [sol1-C]
#define MAX_STR_LEN 64

typedef struct {
    double maxVal, minVal;
    char minStr[MAX_STR_LEN], maxStr[MAX_STR_LEN];
} Node;

char * optimalDivision(int* nums, int numsSize){
    Node ** dp = (Node **)malloc(sizeof(Node *) * numsSize);
    for (int i = 0; i < numsSize; i++) {
        dp[i] = (Node *)malloc(sizeof(Node) * numsSize);
    }
    for (int i = 0; i < numsSize; i++) {
        for (int j = 0; j < numsSize; j++) {
            dp[i][j].minVal = 10000.0;
            dp[i][j].maxVal = 0.0;
        }
        dp[i][i].minVal = nums[i];
        dp[i][i].maxVal = nums[i];
        snprintf(dp[i][i].minStr, MAX_STR_LEN, "%d", nums[i]);
        snprintf(dp[i][i].maxStr, MAX_STR_LEN, "%d", nums[i]);
    }
    for (int i = 1; i < numsSize; i++) {
        for (int j = 0; j + i < numsSize; j++) {
            for (int k = j ; k < j + i; k++) {
                if (dp[j][j + i].maxVal < dp[j][k].maxVal / dp[k + 1][j + i].minVal) {
                    dp[j][j + i].maxVal = dp[j][k].maxVal / dp[k + 1][j + i].minVal;
                    if (k + 1 == j + i) {
                        snprintf(dp[j][j + i].maxStr, MAX_STR_LEN, "%s/%s", dp[j][k].maxStr, dp[k + 1][j + i].minStr);
                    } else {
                        snprintf(dp[j][j + i].maxStr, MAX_STR_LEN, "%s/(%s)", dp[j][k].maxStr, dp[k + 1][j + i].minStr);
                    }
                }
                if (dp[j][j + i].minVal > dp[j][k].minVal / dp[k + 1][j + i].maxVal) {
                    dp[j][j + i].minVal = dp[j][k].minVal / dp[k + 1][j + i].maxVal;
                    if (k + 1 == j + i) {
                        snprintf(dp[j][j + i].minStr, MAX_STR_LEN, "%s/%s", dp[j][k].minStr, dp[k + 1][j + i].maxStr);
                    } else {
                        snprintf(dp[j][j + i].minStr, MAX_STR_LEN, "%s/(%s)", dp[j][k].minStr, dp[k + 1][j + i].maxStr);
                    }
                }
            }
        }
    };
    char * ans = (char *)malloc(sizeof(char) * (strlen(dp[0][numsSize-1].maxStr) + 1));
    strcpy(ans, dp[0][numsSize-1].maxStr);
    for (int i = 0; i < numsSize; i++) {
        free(dp[i]);
    }
    free(dp);
    return ans;
}
```

```JavaScript [sol1-JavaScript]
var optimalDivision = function(nums) {
    const n = nums.length;
    const dp = new Array(n).fill(0).map(() => new Array(n).fill(0));
    for (let i = 0; i < n; i++) {
        for (let j = i; j < n; j++) {
            dp[i][j] = new Node();
        }
    }

    for (let i = 0; i < n; i++) {
        dp[i][i].minVal = nums[i];
        dp[i][i].maxVal = nums[i];
        dp[i][i].minStr = '' + nums[i];
        dp[i][i].maxStr = '' + nums[i];
    }
    for (let i = 1; i < n; i++) {
        for (let j = 0; j + i < n; j++) {
            for (let k = j; k < j + i; k++) {
                if (dp[j][j + i].maxVal < dp[j][k].maxVal / dp[k + 1][j + i].minVal) {
                    dp[j][j + i].maxVal = dp[j][k].maxVal / dp[k + 1][j + i].minVal;
                    if (k + 1 === j + i) {
                        dp[j][j + i].maxStr = dp[j][k].maxStr + "/" + dp[k + 1][j + i].minStr;
                    } else {
                        dp[j][j + i].maxStr = dp[j][k].maxStr + "/(" + dp[k + 1][j + i].minStr + ")";
                    }
                }
                if (dp[j][j + i].minVal > dp[j][k].minVal / dp[k + 1][j + i].maxVal) {
                    dp[j][j + i].minVal = dp[j][k].minVal / dp[k + 1][j + i].maxVal;
                    if (k + 1 === j + i) {
                        dp[j][j + i].minStr = dp[j][k].minStr + "/" + dp[k + 1][j + i].maxStr; 
                    } else {
                        dp[j][j + i].minStr = dp[j][k].minStr + "/(" + dp[k + 1][j + i].maxStr + ")"; 
                    }
                }
            }
        }
    }
    return dp[0][n - 1].maxStr;
};

class Node {
    constructor() {
        this.maxStr;
        this.minStr;
        this.minVal = 10000.0;
        this.maxVal = 0.0;
    }
}
```

```go [sol1-Golang]
type node struct {
    minVal, maxVal float64
    minStr, maxStr string
}

func optimalDivision(nums []int) string {
    n := len(nums)
    dp := make([][]node, n)
    for i := range dp {
        dp[i] = make([]node, n)
        for j := range dp[i] {
            dp[i][j].minVal = 1e4
        }
    }

    for i, num := range nums {
        dp[i][i].minVal = float64(num)
        dp[i][i].maxVal = float64(num)
        dp[i][i].minStr = strconv.Itoa(num)
        dp[i][i].maxStr = strconv.Itoa(num)
    }
    for i := 1; i < n; i++ {
        for j := 0; j+i < n; j++ {
            for k := j; k < j+i; k++ {
                if dp[j][j+i].maxVal < dp[j][k].maxVal/dp[k+1][j+i].minVal {
                    dp[j][j+i].maxVal = dp[j][k].maxVal / dp[k+1][j+i].minVal
                    if k+1 == j+i {
                        dp[j][j+i].maxStr = dp[j][k].maxStr + "/" + dp[k+1][j+i].minStr
                    } else {
                        dp[j][j+i].maxStr = dp[j][k].maxStr + "/(" + dp[k+1][j+i].minStr + ")"
                    }
                }
                if dp[j][j+i].minVal > dp[j][k].minVal/dp[k+1][j+i].maxVal {
                    dp[j][j+i].minVal = dp[j][k].minVal / dp[k+1][j+i].maxVal
                    if k+1 == j+i {
                        dp[j][j+i].minStr = dp[j][k].minStr + "/" + dp[k+1][j+i].maxStr
                    } else {
                        dp[j][j+i].minStr = dp[j][k].minStr + "/(" + dp[k+1][j+i].maxStr + ")"
                    }
                }
            }
        }
    }
    return dp[0][n-1].maxStr
}
```

**复杂度分析**

- 时间复杂度：$O(n^3)$，其中 $n$ 为数组的长度。$\textit{dp}$ 数组的大小为 $n^2$，计算 $\textit{dp}$ 中的每一项元素需要 $O(n)$ 的时间复杂度。

- 空间复杂度：$O(n^3)$，其中 $n$ 表示数组的长度。$\textit{dp}$ 数组的长度为 $n^2$，其中数组中元素的长度最长为 $O(n)$。

#### 方法二：数学

**思路**

使用一些简单的数学技巧，我们可以找到解决这个问题的简单解法。考虑到除法运算用分数 $\dfrac{x}{y}$ 来表示，其中分子 $x$ 为被除数，分母 $y$ 为除数，为了最大化 $\dfrac{x}{y}$，应该使分子 $x$ 尽可能的大，分母 $y$ 尽可能的小。
+ 假设当前的整数序列为 $[\textit{nums}_0, \textit{nums}_1, \cdots , \textit{nums}_{n-1}]$，相邻元素相除形式为 $[\textit{nums}_0 \div \textit{nums}_1 \div \cdots \div \textit{nums}_{n-1}]$，最终的结果一定可以表达为分数的形式 $\dfrac{x}{y}$，不论如何添加括号改变优先级可以知道分子 $x$ 的最大值为 $\textit{nums}_0$。通过添加括号使得剩余的表达式 $\textit{nums}_1 \div \textit{nums}_2 \div \cdots \div \textit{nums}_{n-1}$ 构成的分母 $y$ 最小即可。由于数组 $\textit{nums}$ 中的每个元素都大于 $1$，因此通过直观的观察可以知道 $y = \textit{nums}_1 \div \textit{nums}_2 \div \cdots \div \textit{nums}_{n-1}$ 时值最小，由上述结论可以知道当满足 $\dfrac{x}{y} = \dfrac{\textit{nums}_0}{\textit{nums}_1 \div \textit{nums}_2 \div \cdots \div \textit{nums}_{n-1}}$ 时，数组构成的表达式计算结果为最大。

**代码**

```Python [sol2-Python3]
class Solution:
    def optimalDivision(self, nums: List[int]) -> str:
        if len(nums) == 1:
            return str(nums[0])
        if len(nums) == 2:
            return str(nums[0]) + "/" + str(nums[1])
        return str(nums[0]) + "/(" + "/".join(map(str, nums[1:])) + ")"
```

```C++ [sol2-C++]
class Solution {
public:
    string optimalDivision(vector<int>& nums) {
        int n = nums.size();        
        if (n == 1) {
            return to_string(nums[0]);
        }
        if (n == 2) {
            return to_string(nums[0]) + "/" + to_string(nums[1]);
        }
        string res = to_string(nums[0]) + "/(" + to_string(nums[1]);
        for (int i = 2; i < n; i++) {
            res.append("/" + to_string(nums[i]));
        }
        res.append(")");
        return res;
    }
};
```

```Java [sol2-Java]
class Solution {
    public String optimalDivision(int[] nums) {
        int n = nums.length;        
        if (n == 1) {
            return String.valueOf(nums[0]);
        }
        if (n == 2) {
            return String.valueOf(nums[0]) + "/" + String.valueOf(nums[1]);
        }
        StringBuffer res = new StringBuffer();
        res.append(nums[0]);
        res.append("/(");
        res.append(nums[1]);
        for (int i = 2; i < n; i++) {
            res.append("/");
            res.append(nums[i]);
        }
        res.append(")");
        return res.toString();
    }
}
```

```C# [sol2-C#]
public class Solution {
    public string OptimalDivision(int[] nums) {
        int n = nums.Length;        
        if (n == 1) {
            return nums[0].ToString();
        }
        if (n == 2) {
            return nums[0].ToString() + "/" + nums[1].ToString();
        }
        StringBuilder res = new StringBuilder();
        res.Append(nums[0]);
        res.Append("/(");
        res.Append(nums[1]);
        for (int i = 2; i < n; i++) {
            res.Append("/");
            res.Append(nums[i]);
        }
        res.Append(")");
        return res.ToString();
    }
}
```

```C [sol2-C]
#define MAX_STR_LEN 64

char * optimalDivision(int* nums, int numsSize) {
    char * res = (char *)malloc(sizeof(char) * MAX_STR_LEN);
    if (numsSize == 1) {
        sprintf(res, "%d", nums[0]);
        return res;
    }
    if (numsSize == 2) {
        sprintf(res, "%d/%d", nums[0], nums[1]);
        return res;
    }
    sprintf(res, "%d/(%d", nums[0], nums[1]);
    int pos = strlen(res);
    char str[5];
    for (int i = 2; i < numsSize; i++) {
        sprintf(str, "%d", nums[i]);
        sprintf(res + pos, "/%s", str);
        pos += strlen(str) + 1;
    }
    sprintf(res + pos, "%s", ")");
    return res;
}
```

```JavaScript [sol2-JavaScript]
var optimalDivision = function(nums) {
    const n = nums.length;        
    if (n === 1) {
        return '' + nums[0];
    }
    if (n === 2) {
        return '' + nums[0] + "/" + '' + nums[1];
    }
    const res = [];
    res.push(nums[0]);
    res.push("/(");
    res.push(nums[1]);
    for (let i = 2; i < n; i++) {
        res.push("/");
        res.push(nums[i]);
    }
    res.push(")");
    return res.join('');
};
```

```go [sol2-Golang]
func optimalDivision(nums []int) string {
    n := len(nums)
    if n == 1 {
        return strconv.Itoa(nums[0])
    }
    if n == 2 {
        return fmt.Sprintf("%d/%d", nums[0], nums[1])
    }
    ans := &strings.Builder{}
    ans.WriteString(fmt.Sprintf("%d/(%d", nums[0], nums[1]))
    for _, num := range nums[2:] {
        ans.WriteByte('/')
        ans.WriteString(strconv.Itoa(num))
    }
    ans.WriteByte(')')
    return ans.String()
}
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 为数组的长度。只需要遍历一遍数组即可，所以时间复杂度为 $O(n)$。

- 空间复杂度：$O(1)$。除函数返回值以外，不需要额外的存储空间。
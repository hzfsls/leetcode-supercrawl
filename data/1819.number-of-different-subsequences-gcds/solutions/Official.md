## [1819.序列中不同最大公约数的数目 中文官方题解](https://leetcode.cn/problems/number-of-different-subsequences-gcds/solutions/100000/xu-lie-zhong-bu-tong-zui-da-gong-yue-shu-ha1j)

#### 方法一：枚举

**思路与算法**

题目要求找到所有非空子序列中不同的最大公约数的数目，我们可以尝试枚举所有的可能的最大公约数。假设 $p$ 为一个序列 $A = [a_0,a_1,\cdots,a_k]$ 的最大公约数，令 $a_i = c_i \times p$，则序列即为 $A = [c_0\times p,c_1\times p,c_2\times p,\cdots,c_k\times p]$，根据最大公约数的性质可知此时 $\gcd(a_0,a_1,a_2,\cdots,a_k) = p$，则可以推出 $\gcd(c_0,c_1,c_2,\cdots,c_k) = 1$。此时我们在序列 $A$ 中添加 $p$ 的任意倍数 $a_{k+1} = c_{k+1} \times p$ 时，则序列 $A$ 的最大公约数依然为 $p$，即此时 $\gcd(a_0,a_1,a_2,\cdots,a_k,a_{k+1}) = p$。
根据以上推论我们可以得出结论，如果 $x$ 为数组 $\textit{nums}$ 中的某个序列的最大公约数，则数组中所有能够被 $x$ 整除的元素构成的最大公约数一定为 $x$。根据上述结论，我们可以枚举所有可能的最大公约数 $x$，其中 $x\in[1,\max(\textit{nums})]$，然后对数组中所有可以整除 $x$ 的元素求最大公约数，判断最后求出的最大公约数是否等于 $x$ 即可。

**代码**

```Python [sol1-Python3]
class Solution:
    def countDifferentSubsequenceGCDs(self, nums: List[int]) -> int:
        maxVal = max(nums)
        occured = [False] * (maxVal + 1)
        for num in nums:
            occured[num] = True
        ans = 0
        for i in range(1, maxVal + 1):
            subGcd = 0
            for j in range(i, maxVal + 1, i):
                if occured[j]:
                    if subGcd == 0:
                        subGcd = j
                    else:
                        subGcd = gcd(subGcd, j)
                    if subGcd == i:
                        ans += 1
                        break
        return ans
```

```C++ [sol1-C++]
class Solution {
public:
    int countDifferentSubsequenceGCDs(vector<int>& nums) {
        int maxVal = *max_element(nums.begin(), nums.end());
        vector<bool> occured(maxVal + 1, false);
        for (int num : nums) {
            occured[num] = true;
        }
        int ans = 0;
        for (int i = 1; i <= maxVal; i++) {
            int subGcd = 0;
            for (int j = i; j <= maxVal; j += i) {
                if (occured[j]) {
                    if (subGcd == 0) {
                        subGcd = j;
                    } else {
                        subGcd = __gcd(subGcd, j);
                    }
                    if (subGcd == i) {
                        ans++;
                        break;
                    }
                }
            }
        }
        return ans;
    }
};
```

```Java [sol1-Java]
class Solution {
    public int countDifferentSubsequenceGCDs(int[] nums) {
        int maxVal = Arrays.stream(nums).max().getAsInt();
        boolean[] occured = new boolean[maxVal + 1];
        for (int num : nums) {
            occured[num] = true;
        }
        int ans = 0;
        for (int i = 1; i <= maxVal; i++) {
            int subGcd = 0;
            for (int j = i; j <= maxVal; j += i) {
                if (occured[j]) {
                    if (subGcd == 0) {
                        subGcd = j;
                    } else {
                        subGcd = gcd(subGcd, j);
                    }
                    if (subGcd == i) {
                        ans++;
                        break;
                    }
                }
            }
        }
        return ans;
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
    public int CountDifferentSubsequenceGCDs(int[] nums) {
        int maxVal = nums.Max();
        bool[] occured = new bool[maxVal + 1];
        foreach (int num in nums) {
            occured[num] = true;
        }
        int ans = 0;
        for (int i = 1; i <= maxVal; i++) {
            int subGcd = 0;
            for (int j = i; j <= maxVal; j += i) {
                if (occured[j]) {
                    if (subGcd == 0) {
                        subGcd = j;
                    } else {
                        subGcd = GCD(subGcd, j);
                    }
                    if (subGcd == i) {
                        ans++;
                        break;
                    }
                }
            }
        }
        return ans;
    }

    public int GCD(int num1, int num2) {
        while (num2 != 0) {
            int temp = num1;
            num1 = num2;
            num2 = temp % num2;
        }
        return num1;
    }
}
```

```C [sol1-C]
#define MAX(a, b) ((a) > (b) ? (a) : (b))

static int gcd(int num1, int num2) {
    while (num2 != 0) {
        int temp = num1;
        num1 = num2;
        num2 = temp % num2;
    }
    return num1;
}

int countDifferentSubsequenceGCDs(int* nums, int numsSize) {
    int maxVal = 0;
    for (int i = 0; i < numsSize; i++) {
        maxVal = MAX(maxVal, nums[i]);
    }
    bool occured[maxVal + 1];
    memset(occured, 0, sizeof(occured));
    for (int i = 0; i < numsSize; i++) {
        occured[nums[i]] = true;
    }
    int ans = 0;
    for (int i = 1; i <= maxVal; i++) {
        int subGcd = 0;
        for (int j = i; j <= maxVal; j += i) {
            if (occured[j]) {
                if (subGcd == 0) {
                    subGcd = j;
                } else {
                    subGcd = gcd(subGcd, j);
                }
                if (subGcd == i) {
                    ans++;
                    break;
                }
            }
        }
    }
    return ans;
}
```

```JavaScript [sol1-JavaScript]
var countDifferentSubsequenceGCDs = function(nums) {
    const maxVal = _.max(nums);
    const occured = new Array(maxVal + 1).fill(false);
    for (const num of nums) {
        occured[num] = true;
    }
    let ans = 0;
    for (let i = 1; i <= maxVal; i++) {
        let subGcd = 0;
        for (let j = i; j <= maxVal; j += i) {
            if (occured[j]) {
                if (subGcd === 0) {
                    subGcd = j;
                } else {
                    subGcd = gcd(subGcd, j);
                }
                if (subGcd === i) {
                    ans++;
                    break;
                }
            }
        }
    }
    return ans;
}

const gcd = (num1, num2) => {
    while (num2 !== 0) {
        let temp = num1;
        num1 = num2;
        num2 = temp % num2;
    }
    return num1;
};
```

```go [sol1-Golang]
func countDifferentSubsequenceGCDs(nums []int) (ans int) {
    maxVal := 0
    for _, num := range nums {
        maxVal = max(maxVal, num)
    }
    occured := make([]bool, maxVal+1)
    for _, num := range nums {
        occured[num] = true
    }
    for i := 1; i <= maxVal; i++ {
        subGcd := 0
        for j := i; j <= maxVal; j += i {
            if occured[j] {
                if subGcd == 0 {
                    subGcd = j
                } else {
                    subGcd = gcd(subGcd, j)
                }
                if subGcd == i {
                    ans++
                    break
                }
            }
        }
    }
    return
}

func max(a, b int) int {
    if b > a {
        return b
    }
    return a
}

func gcd(num1, num2 int) int {
    for num1 != 0 {
        num1, num2 = num2%num1, num1
    }
    return num2
}
```

**复杂度分析**

- 时间复杂度：$O(n + \max(\textit{nums}) \log (\max(\textit{nums})))$，其中 $n$ 表示数组的长度，$\max(\textit{nums})$ 表示数组中的最大元素。我们首先需要遍历一遍数组，然后从 $1$ 到 $\max(\textit{nums})$ 依次枚举每个可能的最大公约数 $x \in [1,\max(\textit{nums})]$，对于给定的数 $x$，每次检测的时间复杂度为 $\dfrac{\max(\textit{nums})}{x}$。我们知道 $n + \dfrac{n}{2} + \dfrac{n}{3} + \cdots + 1 = \sum_{i=1}^{n}\limits\dfrac{n}{i} \approx n \log n$，因此在枚举时需要的时间为 $\max(\textit{nums}) \log (\max(\textit{nums}))$，总的时间复杂度即为 $O(n + \max(\textit{nums}) \log (\max(\textit{nums})))$。

- 空间复杂度：$O(\max(\textit{nums}))$，其中 $\max(\textit{nums})$ 表示数组中的最大元素。我们需要 $O(\max(\textit{nums}))$ 空间来记录数组中的每个元素是否出现过。
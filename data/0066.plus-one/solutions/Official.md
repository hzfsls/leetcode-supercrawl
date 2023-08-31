## [66.加一 中文官方题解](https://leetcode.cn/problems/plus-one/solutions/100000/jia-yi-by-leetcode-solution-2hor)

### 📺 视频题解  
![66.加一 仲耀晖.mp4](ba7febe1-adbb-46a6-be89-66add6332ad7)

### 📖 文字题解
#### 方法一：找出最长的后缀 $9$

**思路**

当我们对数组 $\textit{digits}$ 加一时，我们只需要关注 $\textit{digits}$ 的末尾出现了多少个 $9$ 即可。我们可以考虑如下的三种情况：

- 如果 $\textit{digits}$ 的末尾没有 $9$，例如 $[1, 2, 3]$，那么我们直接将末尾的数加一，得到 $[1, 2, 4]$ 并返回；

- 如果 $\textit{digits}$ 的末尾有若干个 $9$，例如 $[1, 2, 3, 9, 9]$，那么我们只需要找出从末尾开始的**第一个**不为 $9$ 的元素，即 $3$，将该元素加一，得到 $[1, 2, 4, 9, 9]$。随后将末尾的 $9$ 全部置零，得到 $[1, 2, 4, 0, 0]$ 并返回。

- 如果 $\textit{digits}$ 的所有元素都是 $9$，例如 $[9, 9, 9, 9, 9]$，那么答案为 $[1, 0, 0, 0, 0, 0]$。我们只需要构造一个长度比 $\textit{digits}$ 多 $1$ 的新数组，将首元素置为 $1$，其余元素置为 $0$ 即可。

**算法**

们只需要对数组 $\textit{digits}$ 进行一次逆序遍历，找出第一个不为 $9$ 的元素，将其加一并将后续所有元素置零即可。如果 $\textit{digits}$ 中所有的元素均为 $9$，那么对应着「思路」部分的第三种情况，我们需要返回一个新的数组。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    vector<int> plusOne(vector<int>& digits) {
        int n = digits.size();
        for (int i = n - 1; i >= 0; --i) {
            if (digits[i] != 9) {
                ++digits[i];
                for (int j = i + 1; j < n; ++j) {
                    digits[j] = 0;
                }
                return digits;
            }
        }

        // digits 中所有的元素均为 9
        vector<int> ans(n + 1);
        ans[0] = 1;
        return ans;
    }
};
```

```Java [sol1-Java]
class Solution {
    public int[] plusOne(int[] digits) {
        int n = digits.length;
        for (int i = n - 1; i >= 0; --i) {
            if (digits[i] != 9) {
                ++digits[i];
                for (int j = i + 1; j < n; ++j) {
                    digits[j] = 0;
                }
                return digits;
            }
        }

        // digits 中所有的元素均为 9
        int[] ans = new int[n + 1];
        ans[0] = 1;
        return ans;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int[] PlusOne(int[] digits) {
        int n = digits.Length;
        for (int i = n - 1; i >= 0; --i) {
            if (digits[i] != 9) {
                ++digits[i];
                for (int j = i + 1; j < n; ++j) {
                    digits[j] = 0;
                }
                return digits;
            }
        }

        // digits 中所有的元素均为 9
        int[] ans = new int[n + 1];
        ans[0] = 1;
        return ans;
    }
}
```

```Python [sol1-Python3]
class Solution:
    def plusOne(self, digits: List[int]) -> List[int]:
        n = len(digits)
        for i in range(n - 1, -1, -1):
            if digits[i] != 9:
                digits[i] += 1
                for j in range(i + 1, n):
                    digits[j] = 0
                return digits

        # digits 中所有的元素均为 9
        return [1] + [0] * n
```

```go [sol1-Golang]
func plusOne(digits []int) []int {
    n := len(digits)
    for i := n - 1; i >= 0; i-- {
        if digits[i] != 9 {
            digits[i]++
            for j := i + 1; j < n; j++ {
                digits[j] = 0
            }
            return digits
        }
    }
    // digits 中所有的元素均为 9

    digits = make([]int, n+1)
    digits[0] = 1
    return digits
}
```

```JavaScript [sol1-JavaScript]
var plusOne = function(digits) {
    const n = digits.length;
    for (let i = n - 1; i >= 0; --i) {
        if (digits[i] !== 9) {
            ++digits[i];
            for (let j = i + 1; j < n; ++j) {
                digits[j] = 0;
            }
            return digits;
        }
    }

    // digits 中所有的元素均为 9
    const ans = new Array(n + 1).fill(0);
    ans[0] = 1;
    return ans;
};
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 是数组 $\textit{digits}$ 的长度。

- 空间复杂度：$O(1)$。返回值不计入空间复杂度。
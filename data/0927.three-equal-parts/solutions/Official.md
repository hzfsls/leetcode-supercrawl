## [927.三等分 中文官方题解](https://leetcode.cn/problems/three-equal-parts/solutions/100000/san-deng-fen-by-leetcode-solution-3l2y)

#### 方法一：将 $1$ 的数量三等分

**思路与算法**

如果存在一种分法使得三个非空部分所表示的二进制值相同，那么最终每一部分 $1$ 的数量一定是相等的。根据这个思想，我们首先统计数组 $\textit{arr}$ 中 $1$ 的个数，把它设为 $\textit{sum}$。如果 $\textit{sum}$ 不能被 $3$ 整除，那么显然不存在正确分法。否则，每一个部分都应当有 $\textit{partial} = \dfrac{\textit{sum}}{3}$ 个 $1$。

我们尝试找到 $\textit{arr}$ 中第 $1$ 个 $1$ 出现的位置 $\textit{first}$，第 $\textit{partial} + 1$ 个 $1$ 出现的位置 $\textit{second}$ 以及第 $2 \times \textit{partial} + 1$ 个 $1$ 出现的位置 $\textit{third}$。因为每一部分末尾的 $0$ 可以移动到下一部分的首部从而改变二进制值的大小, 所以每一部分的末尾难以界定。但是注意到，数组的末尾是无法改变的，因此区间 $[\textit{third}, \textit{arr.length} - 1]$ 所表示的二进制值可以固定。

设 $\textit{len} = \textit{arr.length} - \textit{third}$，表示二进制值的长度。接下来只需要判断 $[\textit{first}, \textit{first} + \textit{len})$、$[\textit{second}, \textit{second} + \textit{len})$ 和 $[\textit{third}, \textit{third} + \textit{len})$ 是否完全相同即可。前提是 $\textit{first} + \textit{len} \le \textit{second}$ 并且 $\textit{second} + \textit{len} \le \textit{third}$。

如果以上三段区间是完全相同的，那么答案就是 $[\textit{first} + \textit{len} - 1, \textit{second} + \textit{len}]$。最后需要注意到，如果 $\textit{sum} = 0$，我们需要直接返回答案 $[0, 2]$（或者其他任意合法答案）。

**代码**

```Python [sol1-Python3]
class Solution:
    def threeEqualParts(self, arr: List[int]) -> List[int]:
        s = sum(arr)
        if s % 3:
            return [-1, -1]
        if s == 0:
            return [0, 2]

        partial = s // 3
        first = second = third = cur = 0
        for i, x in enumerate(arr):
            if x:
                if cur == 0:
                    first = i
                elif cur == partial:
                    second = i
                elif cur == 2 * partial:
                    third = i
                cur += 1

        n = len(arr)
        length = n - third
        if first + length <= second and second + length <= third:
            i = 0
            while third + i < n:
                if arr[first + i] != arr[second + i] or arr[first + i] != arr[third + i]:
                    return [-1, -1]
                i += 1
            return [first + length - 1, second + length]
        return [-1, -1]
```

```C++ [sol1-C++]
class Solution {
public:
    vector<int> threeEqualParts(vector<int>& arr) {
        int sum = accumulate(arr.begin(), arr.end(), 0);
        if (sum % 3 != 0) {
            return {-1, -1};
        }
        if (sum == 0) {
            return {0, 2};
        }

        int partial = sum / 3;
        int first = 0, second = 0, third = 0, cur = 0;
        for (int i = 0; i < arr.size(); i++) {
            if (arr[i] == 1) {
                if (cur == 0) {
                    first = i;
                }
                else if (cur == partial) {
                    second = i;
                }
                else if (cur == 2 * partial) {
                    third = i;
                }
                cur++;
            }
        }

        int len = (int)arr.size() - third;
        if (first + len <= second && second + len <= third) {
            int i = 0;
            while (third + i < arr.size()) {
                if (arr[first + i] != arr[second + i] || arr[first + i] != arr[third + i]) {
                    return {-1, -1};
                }
                i++;
            }
            return {first + len - 1, second + len};
        }
        return {-1, -1};
    }
};
```

```Java [sol1-Java]
class Solution {
    public int[] threeEqualParts(int[] arr) {
        int sum = Arrays.stream(arr).sum();
        if (sum % 3 != 0) {
            return new int[]{-1, -1};
        }
        if (sum == 0) {
            return new int[]{0, 2};
        }

        int partial = sum / 3;
        int first = 0, second = 0, third = 0, cur = 0;
        for (int i = 0; i < arr.length; i++) {
            if (arr[i] == 1) {
                if (cur == 0) {
                    first = i;
                } else if (cur == partial) {
                    second = i;
                } else if (cur == 2 * partial) {
                    third = i;
                }
                cur++;
            }
        }

        int len = arr.length - third;
        if (first + len <= second && second + len <= third) {
            int i = 0;
            while (third + i < arr.length) {
                if (arr[first + i] != arr[second + i] || arr[first + i] != arr[third + i]) {
                    return new int[]{-1, -1};
                }
                i++;
            }
            return new int[]{first + len - 1, second + len};
        }
        return new int[]{-1, -1};
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int[] ThreeEqualParts(int[] arr) {
        int sum = arr.Sum();
        if (sum % 3 != 0) {
            return new int[]{-1, -1};
        }
        if (sum == 0) {
            return new int[]{0, 2};
        }

        int partial = sum / 3;
        int first = 0, second = 0, third = 0, cur = 0;
        for (int i = 0; i < arr.Length; i++) {
            if (arr[i] == 1) {
                if (cur == 0) {
                    first = i;
                } else if (cur == partial) {
                    second = i;
                } else if (cur == 2 * partial) {
                    third = i;
                }
                cur++;
            }
        }

        int len = arr.Length - third;
        if (first + len <= second && second + len <= third) {
            int i = 0;
            while (third + i < arr.Length) {
                if (arr[first + i] != arr[second + i] || arr[first + i] != arr[third + i]) {
                    return new int[]{-1, -1};
                }
                i++;
            }
            return new int[]{first + len - 1, second + len};
        }
        return new int[]{-1, -1};
    }
}
```

```C [sol1-C]
int* threeEqualParts(int* arr, int arrSize, int* returnSize) {
    int sum = 0;
    int *ans = (int *)malloc(sizeof(int) * 2);
    *returnSize = 2;
    for (int i = 0; i < arrSize; i++) {
        sum += arr[i];
    }
    if (sum % 3 != 0) {
        ans[0] = -1, ans[1] = -1;
        return ans;
    }
    if (sum == 0) {
        ans[0] = 0, ans[1] = 2;
        return ans;
    }

    int partial = sum / 3;
    int first = 0, second = 0, third = 0, cur = 0;
    for (int i = 0; i < arrSize; i++) {
        if (arr[i] == 1) {
            if (cur == 0) {
                first = i;
            }
            else if (cur == partial) {
                second = i;
            }
            else if (cur == 2 * partial) {
                third = i;
            }
            cur++;
        }
    }

    int len = (int)arrSize - third;
    if (first + len <= second && second + len <= third) {
        int i = 0;
        while (third + i < arrSize) {
            if (arr[first + i] != arr[second + i] || arr[first + i] != arr[third + i]) {
                ans[0] = -1, ans[1] = -1;
                return ans;
            }
            i++;
        }
        ans[0] = first + len - 1, ans[1] = second + len;
        return ans;
    }
    ans[0] = -1, ans[1] = -1;
    return ans;
}
```

```JavaScript [sol1-JavaScript]
var threeEqualParts = function(arr) {
    const sum = _.sum(arr);
    if (sum % 3 !== 0) {
        return [-1, -1];
    }
    if (sum === 0) {
        return [0, 2];
    }

    const partial = Math.floor(sum / 3);
    let first = 0, second = 0, third = 0, cur = 0;
    for (let i = 0; i < arr.length; i++) {
        if (arr[i] === 1) {
            if (cur === 0) {
                first = i;
            } else if (cur === partial) {
                second = i;
            } else if (cur === 2 * partial) {
                third = i;
            }
            cur++;
        }
    }

    let len = arr.length - third;
    if (first + len <= second && second + len <= third) {
        let i = 0;
        while (third + i < arr.length) {
            if (arr[first + i] !== arr[second + i] || arr[first + i] !== arr[third + i]) {
                return [-1, -1];
            }
            i++;
        }
        return [first + len - 1, second + len];
    }
    return [-1, -1];
};
```

```go [sol1-Golang]
func threeEqualParts(arr []int) []int {
    sum := 0
    for _, v := range arr {
        sum += v
    }
    if sum%3 != 0 {
        return []int{-1, -1}
    }
    if sum == 0 {
        return []int{0, 2}
    }

    partial := sum / 3
    first, second, third, cur := 0, 0, 0, 0
    for i, x := range arr {
        if x == 1 {
            if cur == 0 {
                first = i
            } else if cur == partial {
                second = i
            } else if cur == 2*partial {
                third = i
            }
            cur++
        }
    }

    n := len(arr)
    length := n - third
    if first+length <= second && second+length <= third {
        i := 0
        for third+i < n {
            if arr[first+i] != arr[second+i] || arr[first+i] != arr[third+i] {
                return []int{-1, -1}
            }
            i++
        }
        return []int{first + length - 1, second + length}
    }
    return []int{-1, -1}
}
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 是 $\textit{arr}$ 的长度。找到三个下标的时间复杂度为 $O(n)$，判断三个部分是否相同的时间复杂度也是 $O(n)$。

- 空间复杂度：$O(1)$，只用到常数个变量空间。
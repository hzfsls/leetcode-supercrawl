## [1073.负二进制数相加 中文官方题解](https://leetcode.cn/problems/adding-two-negabinary-numbers/solutions/100000/fu-er-jin-zhi-shu-xiang-jia-by-leetcode-nwktq)

#### 方法一：模拟

**思路与算法**

为了叙述方便，记 $\textit{arr}_1[i]$ 和 $\textit{arr}_2[i]$ 分别是 $\textit{arr}_1$ 和 $\textit{arr}_2$ **从低到高**的第 $i$ 个数位。在加法运算中，我们需要将它们相加。

对于普通的二进制数相加，我们可以从低位到高位进行运算，在运算的过程中维护一个变量 $\textit{carry}$ 表示进位。当运算到第 $i$ 位时，令 $x = \textit{arr}_1[i] + \textit{arr}_2[i] + \textit{carry}$：

- 如果 $x = 0, 1$，第 $i$ 位的结果就是 $x$，并且将 $\textit{carry}$ 置 $0$；

- 如果 $x = 2, 3$，第 $i$ 位的结果是 $x - 2$，需要进位，将 $\textit{carry}$ 置 $1$。

而本题中是「负二进制数」，第 $i$ 位对应的是 $(-2)^i$，而第 $i+1$ 位对应的是 $(-2)^{i+1}$，是第 $i$ 位的 $-2$ 倍。因此，当第 $i$ 位发生进位时，$\textit{carry}$ 应当置为 $-1$，而不是 $1$。

此时，由于 $\textit{arr}_1[i]$ 和 $\textit{arr}_2[i]$ 的范围都是 $\{0, 1\}$，而 $\textit{carry}$ 的范围从 $\{0, 1\}$ 变成了 $\{-1, 0\}$，因此 $x$ 的范围从 $\{0, 1, 2, 3\}$ 变成了 $\{-1, 0, 1, 2\}$。那么：

- 如果 $x = 0, 1$，第 $i$ 位的结果就是 $x$，并且将 $\textit{carry}$ 置 $0$；

- 如果 $x = 2$，第 $i$ 位的结果是 $x - 2$，需要进位，将 $\textit{carry}$ 置 $-1$；

- 如果 $x = -1$，此时第 $i$ 位的结果应该是什么呢？可以发现，由于：
$$
-(-2)^i = (-2)^{i+1} + (-2)^i
$$
等式左侧表示第 $i$ 位为 $-1$ 的值，右侧表示第 $i$ 和 $i+1$ 位为 $1$ 的值。因此，第 $i$ 位的结果应当为 $1$，同时需要进位，将 $\textit{carry}$ 置 $1$（注意这里不是 $-1$）。最终，$\textit{carry}$ 的范围为 $\{-1, 0, 1\}$，会多出 $x=3$ 的情况，但它与 $x=2$ 的情况是一致的。

**细节**

在最坏的情况下，当我们计算完 $\textit{arr}_1$ 和 $\textit{arr}_2$ 的最高位的 $x$ 时，得到的结果为 $x=3$，此时产生 $-1$ 的进位，而 $-1$ 在之后又会产生 $1$ 的进位，因此，答案的长度最多为 $\textit{arr}_1$ 和 $\textit{arr}_2$ 中较长的长度加 $2$。

由于题目描述中 $\textit{arr}_1[i]$ 和 $\textit{arr}_2[i]$ 表示的是 $\textit{arr}_1$ 和 $\textit{arr}_2$ **从高到低**的第 $i$ 个数位，与题解中的叙述相反。因此，在实际的代码编写中，我们可以使用两个指针从 $\textit{arr}_1$ 和 $\textit{arr}_2$ 的末尾同时开始进行逆序的遍历，得到逆序的答案，去除前导零，再将答案反转即可得到顺序的最终答案。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    vector<int> addNegabinary(vector<int>& arr1, vector<int>& arr2) {
        int i = arr1.size() - 1, j = arr2.size() - 1;
        int carry = 0;
        vector<int> ans;
        while (i >= 0 || j >= 0 || carry) {
            int x = carry;
            if (i >= 0) {
                x += arr1[i];
            }
            if (j >= 0) {
                x += arr2[j];
            }
            
            if (x >= 2) {
                ans.push_back(x - 2);
                carry = -1;
            }
            else if (x >= 0) {
                ans.push_back(x);
                carry = 0;
            }
            else {
                ans.push_back(1);
                carry = 1;
            }
            --i;
            --j;
        }
        while (ans.size() > 1 && ans.back() == 0) {
            ans.pop_back();
        }
        reverse(ans.begin(), ans.end());
        return ans;
    }
};
```

```Java [sol1-Java]
class Solution {
    public int[] addNegabinary(int[] arr1, int[] arr2) {
        int i = arr1.length - 1, j = arr2.length - 1;
        int carry = 0;
        List<Integer> ans = new ArrayList<Integer>();
        while (i >= 0 || j >= 0 || carry != 0) {
            int x = carry;
            if (i >= 0) {
                x += arr1[i];
            }
            if (j >= 0) {
                x += arr2[j];
            }
            if (x >= 2) {
                ans.add(x - 2);
                carry = -1;
            } else if (x >= 0) {
                ans.add(x);
                carry = 0;
            } else {
                ans.add(1);
                carry = 1;
            }
            --i;
            --j;
        }
        while (ans.size() > 1 && ans.get(ans.size() - 1) == 0) {
            ans.remove(ans.size() - 1);
        }
        int[] arr = new int[ans.size()];
        for (i = 0, j = ans.size() - 1; j >= 0; i++, j--) {
            arr[i] = ans.get(j);
        }
        return arr;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int[] AddNegabinary(int[] arr1, int[] arr2) {
        int i = arr1.Length - 1, j = arr2.Length - 1;
        int carry = 0;
        IList<int> ans = new List<int>();
        while (i >= 0 || j >= 0 || carry != 0) {
            int x = carry;
            if (i >= 0) {
                x += arr1[i];
            }
            if (j >= 0) {
                x += arr2[j];
            }
            if (x >= 2) {
                ans.Add(x - 2);
                carry = -1;
            } else if (x >= 0) {
                ans.Add(x);
                carry = 0;
            } else {
                ans.Add(1);
                carry = 1;
            }
            --i;
            --j;
        }
        while (ans.Count > 1 && ans[ans.Count - 1] == 0) {
            ans.RemoveAt(ans.Count - 1);
        }
        int[] arr = new int[ans.Count];
        for (i = 0, j = ans.Count - 1; j >= 0; i++, j--) {
            arr[i] = ans[j];
        }
        return arr;
    }
}
```

```Python [sol1-Python3]
class Solution:
    def addNegabinary(self, arr1: List[int], arr2: List[int]) -> List[int]:
        i, j = len(arr1) - 1, len(arr2) - 1
        carry = 0
        ans = list()

        while i >= 0 or j >= 0 or carry:
            x = carry
            if i >= 0:
                x += arr1[i]
            if j >= 0:
                x += arr2[j]

            if x >= 2:
                ans.append(x - 2)
                carry = -1
            elif x >= 0:
                ans.append(x)
                carry = 0
            else:
                ans.append(1)
                carry = 1
            i -= 1
            j -= 1
        
        while len(ans) > 1 and ans[-1] == 0:
            ans.pop()
        return ans[::-1]
```

```C [sol1-C]
void reverse(int *arr, int left, int right) {
    while (left < right) {
        int tmp = arr[left];
        arr[left] = arr[right];
        arr[right] = tmp;
        left++;
        right--;
    }
}

int* addNegabinary(int* arr1, int arr1Size, int* arr2, int arr2Size, int* returnSize){
    int i = arr1Size - 1, j = arr2Size - 1;
    int carry = 0;
    int *ans = (int *)calloc(arr1Size + arr2Size + 1, sizeof(int));
    int pos = 0;
    while (i >= 0 || j >= 0 || carry) {
        int x = carry;
        if (i >= 0) {
            x += arr1[i];
        }
        if (j >= 0) {
            x += arr2[j];
        }
        
        if (x >= 2) {
            ans[pos++] = x - 2;
            carry = -1;
        }
        else if (x >= 0) {
            ans[pos++] = x;
            carry = 0;
        }
        else {
            ans[pos++] = 1;
            carry = 1;
        }
        --i;
        --j;
    }
    while (pos > 1 && ans[pos - 1] == 0) {
        pos--;
    }
    *returnSize = pos;
    reverse(ans, 0, pos - 1);
    return ans;
}
```

```JavaScript [sol1-JavaScript]
var addNegabinary = function(arr1, arr2) {
    let i = arr1.length - 1, j = arr2.length - 1;
    let carry = 0;
    const ans = [];
    while (i >= 0 || j >= 0 || carry !== 0) {
        let x = carry;
        if (i >= 0) {
            x += arr1[i];
        }
        if (j >= 0) {
            x += arr2[j];
        }
        if (x >= 2) {
            ans.push(x - 2);
            carry = -1;
        } else if (x >= 0) {
            ans.push(x);
            carry = 0;
        } else {
            ans.push(1);
            carry = 1;
        }
        --i;
        --j;
    }
    while (ans.length > 1 && ans[ans.length - 1] === 0) {
        ans.splice(ans.length - 1, 1);
    }
    const arr = new Array(ans.length);
    for (i = 0, j = ans.length - 1; j >= 0; i++, j--) {
        arr[i] = ans[j];
    }
    return arr;
};
```

```go [sol1-Golang]
func addNegabinary(arr1 []int, arr2 []int) (ans []int) {
    i := len(arr1) - 1
    j := len(arr2) - 1
    carry := 0
    for i >= 0 || j >= 0 || carry != 0 {
        x := carry
        if i >= 0 {
            x += arr1[i]
        }
        if j >= 0 {
            x += arr2[j]
        }

        if x >= 2 {
            ans = append(ans, x-2)
            carry = -1
        } else if x >= 0 {
            ans = append(ans, x)
            carry = 0
        } else {
            ans = append(ans, 1)
            carry = 1
        }
        i--
        j--
    }
    for len(ans) > 1 && ans[len(ans)-1] == 0 {
        ans = ans[:len(ans)-1]
    }
    for i, n := 0, len(ans); i < n/2; i++ {
        ans[i], ans[n-1-i] = ans[n-1-i], ans[i]
    }
    return ans
}
```

**复杂度分析**

- 时间复杂度：$O(m + n)$，其中 $m$ 和 $n$ 分别是数组 $\textit{arr}_1$ 和 $\textit{arr}_2$ 的长度。

- 空间复杂度：$O(1)$ 或 $O(m + n)$。注意这里不包括返回值占用的空间。在最后将答案反转时，如果直接在原数组上进行反转，那么使用的空间为 $O(1)$；如果使用语言的 API 构造新数组进行反转（例如 $\text{Python}$ 中的切片 $\texttt{[::-1]}$ 操作），使用的空间为 $O(m + n)$。
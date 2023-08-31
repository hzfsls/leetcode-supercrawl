## [1006.笨阶乘 中文官方题解](https://leetcode.cn/problems/clumsy-factorial/solutions/100000/ben-jie-cheng-by-leetcode-solution-deh2)
#### 方法一：使用栈模拟

**思路**

根据求解问题「[150. 逆波兰表达式求值](/problems/evaluate-reverse-polish-notation)」、「[224. 基本计算器](/problems/basic-calculator)」、「[227. 基本计算器 II](/problems/basic-calculator-ii)」的经验，表达式的计算一般可以借助数据结构「栈」完成，特别是带有括号的表达式。我们将暂时还不能确定的数据存入栈，确定了优先级最高以后，一旦可以计算出结果，我们就把数据从栈里取出，**整个过程恰好符合了「后进先出」的规律**。本题也不例外。

根据题意，「笨阶乘」没有显式括号，运算优先级是先「乘除」后「加减」。我们可以从 $n$ 开始，枚举 $n-1$、$n-2$ 直到 $1$ ，枚举这些数的时候，认为它们之前的操作符按照「乘」「除」「加」「减」交替进行。

- 出现乘法、除法的时候可以把栈顶元素取出，与当前的 $n$ 进行乘法运算、除法运算（除法运算需要注意先后顺序），并将运算结果重新压入栈中；

- 出现加法、减法的时候，把减法视为加上一个数的相反数，然后压入栈，等待以后遇见「乘」「除」法的时候取出。

最后将栈中元素累加即为答案。由于加法运算交换律成立，可以将栈里的元素依次出栈相加。

**代码**

```Java [sol1-Java]
class Solution {
    public int clumsy(int n) {
        Deque<Integer> stack = new LinkedList<Integer>();
        stack.push(n);
        n--;

        int index = 0; // 用于控制乘、除、加、减
        while (n > 0) {
            if (index % 4 == 0) {
                stack.push(stack.pop() * n);
            } else if (index % 4 == 1) {
                stack.push(stack.pop() / n);
            } else if (index % 4 == 2) {
                stack.push(n);
            } else {
                stack.push(-n);
            }
            index++;
            n--;
        }

        // 把栈中所有的数字依次弹出求和
        int sum = 0;
        while (!stack.isEmpty()) {
            sum += stack.pop();
        }
        return sum;
    }
}
```

```C++ [sol1-C++]
class Solution {
public:
    int clumsy(int n) {
        stack<int> stk;
        stk.push(n);
        n--;

        int index = 0; // 用于控制乘、除、加、减
        while (n > 0) {
            if (index % 4 == 0) {
                stk.top() *= n;
            } else if (index % 4 == 1) {
                stk.top() /= n;
            } else if (index % 4 == 2) {
                stk.push(n);
            } else {
                stk.push(-n);
            }
            index++;
            n--;
        }

        // 把栈中所有的数字依次弹出求和
        int sum = 0;
        while (!stk.empty()) {
            sum += stk.top();
            stk.pop();
        }
        return sum;
    }
};
```

```go [sol1-Go]
func clumsy(n int) (ans int) {
    stk := []int{n}
    n--

    index := 0 // 用于控制乘、除、加、减
    for n > 0 {
        switch index % 4 {
        case 0:
            stk[len(stk)-1] *= n
        case 1:
            stk[len(stk)-1] /= n
        case 2:
            stk = append(stk, n)
        default:
            stk = append(stk, -n)
        }
        n--
        index++
    }

    // 累加栈中数字
    for _, v := range stk {
        ans += v
    }
    return
}
```

```C [sol1-C]
int clumsy(int n) {
    int stk[n], top = 0;
    stk[top++] = n;
    n--;

    int index = 0; // 用于控制乘、除、加、减
    while (n > 0) {
        if (index % 4 == 0) {
            stk[top - 1] *= n;
        } else if (index % 4 == 1) {
            stk[top - 1] /= n;
        } else if (index % 4 == 2) {
            stk[top++] = n;
        } else {
            stk[top++] = -n;
        }
        index++;
        n--;
    }

    // 把栈中所有的数字依次弹出求和
    int sum = 0;
    while (top) {
        sum += stk[--top];
    }
    return sum;
}
```

```JavaScript [sol1-JavaScript]
var clumsy = function(n) {
    const stack = [n--];

    let index = 0; // 用于控制乘、除、加、减
    while (n > 0) {
        if (index % 4 == 0) {
            stack.push(stack.pop() * n);
        } else if (index % 4 == 1) {
            const cur = stack.pop();
            stack.push(cur > 0 ? Math.floor(cur / n) : Math.ceil(cur / n));
        } else if (index % 4 == 2) {
            stack.push(n);
        } else {
            stack.push(-n);
        }
        index++;
        n--;
    }

    // 把栈中所有的数字依次弹出求和
    let sum = 0;
    stack.forEach((element) => {
        sum += element;
    })
    return sum;
};
```

**复杂度分析**

- 时间复杂度：$O(n)$。从 $n$ 到 $1$ 每一个元素进栈一次，出栈一次。

- 空间复杂度：$O(n)$。由于「乘」「除」运算在进栈、出栈过程中被计算出来，最后一步弹出栈之前，栈里保存的是「加」「减」法项。

#### 方法二：数学

**思路**

让我们来尝试化简「笨阶乘」的式子。

观察「笨阶乘」的前三项，有

$$
\begin{aligned}
&5\cdot4/3=6\\
&6\cdot5/4=7\\
&7\cdot6/5=8\\
&\dots
\end{aligned}
$$

一般地，有

$$
\begin{aligned}
&\quad~ n \cdot (n - 1) / (n - 2) \\ &= \cfrac{n^2 - n}{n-2} \\ 
&= \cfrac{n^2 - 2n + n}{n-2}  \\ &= \cfrac{n(n - 2) + n}{n-2} \\
&= n + \cfrac{n}{n-2} \\
&= n + \cfrac{n - 2 + 2}{n-2} \\
&= n + 1 + \cfrac{2}{n - 2}
\end{aligned}
$$

上式最后一项 $\cfrac{2}{n - 2}$，当分子严格小于分母（$2 < n - 2$，即 $n > 4$）的时候，在地板除法的定义下等于 $0$。
即当 $n > 4$ 时，有 

$$
n \cdot (n - 1) / (n - 2) = n + 1
$$

我们把「笨阶乘」的计算式多写几项：
$$
\texttt{clumsy}(n) = n \cdot (n - 1) / (n - 2) + (n - 3) - (n - 4) \cdot (n - 5) / (n - 6) + (n - 7) - \cdots
$$

就会发现其中有可以「消去」的部分，根据以上分析，当 $n > 8$ 时，有

$$
(n - 4) \cdot (n - 5) / (n - 6) = n - 3
$$

此时 $\texttt{clumsy}(n)$ 除了 $n \cdot (n - 1) / (n - 2) = n + 1$ 以外，后面每 $4$ 项的计算结果均为 $0$。即当 $n > 8$ 时，有

$$
(n - 3) - (n - 4) \cdot (n - 5) / (n - 6) = 0
$$

剩下不能够成 $4$ 个一组成对「消去」的情况需要分类讨论。由于「笨阶乘」按照「乘」「除」「加」「减」循环的顺序定义运算，我们可以将 $n$ 按照对 $4$ 取模的余数分类讨论。

下面我们分类讨论：$n$ 对 $4$ 取模的余数分别是 $0$、$1$、$2$、$3$ 时，最后一项 $1$ 的符号。

**情况一**：当 $n$ 对 $4$ 取模的余数等于 $0$ 时，有

$$
\begin{aligned}
\texttt{clumsy}(n) &= \underline{n \cdot (n - 1) / (n - 2) } + \cdots 8 \times 7 / 6 + \underline{ 5 - 4 \times 3 / 2 + 1 } \\ &= n + 1 + 5 - 6 + 1 \\
&= n + 1
\end{aligned}
$$

观察到：上式中**除了有下划线的部分，其余项的和为 $0$**。注意我们观察到数字 $8$ 后面恰好是「笨阶乘」定义的第一种运算「乘」，由它可以观察出此时 $n$ 的一般规律，即当 $n \bmod 4 = 0$ 时，最后一项 $1$ 前面是「加」。

后面的情况可以类似地进行分析。

**情况二**：当 $n$ 对 $4$ 取模的余数等于 $1$ 时，有

$$
\begin{aligned}
\texttt{clumsy}(n) &= \underline{n \cdot (n - 1) / (n - 2) } + \cdots 9 \times 8 / 7 + \underline{ 6 - 5 \times 4 / 3 + 2 - 1 } \\ 
&= n + 1 + 6 - 6 + 2 - 1 \\
&= n + 2
\end{aligned}
$$

此时最后一项 $1$ 前面是「减」。

**情况三**：当 $n$ 对 $4$ 取模的余数等于 $2$ 时，有

$$
\begin{aligned}
\texttt{clumsy}(n) &= \underline{n \cdot (n - 1) / (n - 2) } + \cdots 10 \times 9 / 8 + \underline{ 7 - 6 \times 5 / 4 + 3 - 2 \times 1 } \\
&= n + 1 + 7 - 7 + 3 - 2 \\
&= n + 2
\end{aligned}
$$

此时最后一项 $1$ 前面是「乘」。

**情况四**：当 $n$ 对 $4$ 取模的余数等于 $3$ 时，有

$$
\begin{aligned}
\texttt{clumsy}(n) &= \underline{n \cdot (n - 1) / (n - 2) } + \cdots 11 \times 10 / 9 + \underline{ 8 - 7 \times 6 / 5 + 4 - 3 \times 2 / 1 } \\
&= n + 1 + 8 - 8 + 4 - 6 \\
&= n - 1
\end{aligned}
$$
此时最后一项 $1$ 前面是「除」。

综上所述：

- 当 $n \le 4$ 时，可以分别单独计算「笨阶乘」；

- 当 $n > 4$ 时，可以根据 $n$ 对 $4$ 取模的余数进行分类讨论。

**代码**

```Java [sol2-Java]
class Solution {
    public int clumsy(int n) {
        if (n == 1) {
            return 1;
        } else if (n == 2) {
            return 2;
        } else if (n == 3) {
            return 6;
        } else if (n == 4) {
            return 7;
        }

        if (n % 4 == 0) {
            return n + 1;
        } else if (n % 4 <= 2) {
            return n + 2;
        } else {
            return n - 1;
        }
    }
}
```

```C++ [sol2-C++]
class Solution {
public:
    int clumsy(int n) {
        if (n == 1) {
            return 1;
        } else if (n == 2) {
            return 2;
        } else if (n == 3) {
            return 6;
        } else if (n == 4) {
            return 7;
        }

        if (n % 4 == 0) {
            return n + 1;
        } else if (n % 4 <= 2) {
            return n + 2;
        } else {
            return n - 1;
        }
    }
};
```

```go [sol2-Go]
func clumsy(n int) (ans int) {
    switch {
    case n == 1:
        return 1
    case n == 2:
        return 2
    case n == 3:
        return 6
    case n == 4:
        return 7

    case n%4 == 0:
        return n + 1
    case n%4 <= 2:
        return n + 2
    default:
        return n - 1
    }
}
```

```C [sol2-C]
int clumsy(int n) {
    if (n == 1) {
        return 1;
    } else if (n == 2) {
        return 2;
    } else if (n == 3) {
        return 6;
    } else if (n == 4) {
        return 7;
    }

    if (n % 4 == 0) {
        return n + 1;
    } else if (n % 4 <= 2) {
        return n + 2;
    } else {
        return n - 1;
    }
}
```

```JavaScript [sol2-JavaScript]
var clumsy = function(n) {
    if (n === 1) {
        return 1;
    } else if (n === 2) {
        return 2;
    } else if (n === 3) {
        return 6;
    } else if (n === 4) {
        return 7;
    }

    if (n % 4 === 0) {
        return n + 1;
    } else if (n % 4 <= 2) {
        return n + 2;
    } else {
        return n - 1;
    }
};
```

**复杂度分析**

- 时间复杂度：$O(1)$。对于任意的 $n$，计算时间都为常数。

- 空间复杂度：$O(1)$。
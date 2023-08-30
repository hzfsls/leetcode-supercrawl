#### 方法一：拒绝采样

**思路与算法**

我们可以用拒绝采样的方法实现 $\textit{Rand10()}$。在拒绝采样中，如果生成的随机数满足要求，那么就返回该随机数，否则会不断生成，直到生成一个满足要求的随机数为止。

+ 我们只需要能够满足等概率的生成 $10$ 个不同的数即可，具体的生成方法可以有很多种，比如我们可以利用两个 $\textit{Rand7()}$ 相乘，我们只取其中等概率的 $10$ 个不同的数的组合即可，当然还有许多其他不同的解法，可以利用各种运算和函数的组合等方式来实现。

   + 比如我们可以利用两个$\textit{Rand7()}$相乘，分别可以得到结果如下：

   |  | 1 | 2 |3|4|5|6|7|
   | :----:|:----:| :----: | :----: | :----: | :----: | :----: | :----: |
   | **1** | 1 | 2 |3|4|5|6|7|
   | **2** | 2 | 4 |6|8|10|12|14|
   | **3** | 3 | 6 |9|12|15|18|21|
   | **4** | 4 | 8 |12|16|20|24|28|
   | **5** | 5 | 10 |15|20|25|30|35|
   | **6** | 6 | 12 |18|24|30|36|42|
   | **7** | 7 | 14 |21|28|35|42|49|

   + 我们可以得到每个数生成的概率为:

   |       |   1    |   2    |   3    |   4    |   5    |   6    |   7    |   8    |   9    |
   | :---: | :----: | :----: | :----: | :----: | :----: | :----: | :----: | :----: | :----: |
   | **P** |  1/49  |  2/49  |  2/49  |  3/49  |  2/49  |  4/49  |  2/49  |  2/49  |  4/49  |
   |       | **10** | **12** | **14** | **15** | **16** | **18** | **20** | **21** | **24** |
   | **P** |  2/49  |  1/49  |  2/49  |  2/49  |  2/49  |  1/49  |  2/49  |  2/49  |  2/49  |
   |       | **25** | **28** | **30** | **35** | **36** | **42** | **49** |        |        |
   | **P** |  1/49  |  2/49  |  2/49  |  2/49  |  1/49  |  2/49  |  1/49  |        |        |

   + 我们可以从中挑选 $10$个等概率的数即可。

+ 题目中要求尽可能的减少 $\textit{Rand7()}$ 的调用次数，则我们应该尽量保证生成的每个不同的数的生成概率尽可能的大，即调用 $\textit{Rand7()}$ 期望次数尽可能的小。

+ 我们可以调用两次 $\textit{Rand7()}$，那么可以生成 $[1, 49]$ 之间的随机整数，我们只用到其中的前 $40$ 个用来实现 $\textit{Rand10()}$，而拒绝剩下的 $9$ 个数，如下图所示。

![微信图片_20210905012406.jpg](https://pic.leetcode-cn.com/1630776258-UNMORj-%E5%BE%AE%E4%BF%A1%E5%9B%BE%E7%89%87_20210905012406.jpg)

+ 我们可以看到表中的 $[1,49]$ 每个数生成的概率为 $\frac{1}{49}$。我们实际上只取 $[1,40]$ 这前 $40$ 个数，转化为 $[1,10]$ 时，这 $10$ 个数中每个数的生成概率则为 $\frac{4}{49}$。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    int rand10() {
        int row, col, idx;
        do {
            row = rand7();
            col = rand7();
            idx = col + (row - 1) * 7;
        } while (idx > 40);
        return 1 + (idx - 1) % 10;
    }
};
```

```Java [sol1-Java]
class Solution extends SolBase {
    public int rand10() {
        int row, col, idx;
        do {
            row = rand7();
            col = rand7();
            idx = col + (row - 1) * 7;
        } while (idx > 40);
        return 1 + (idx - 1) % 10;
    }
}
```

```C# [sol1-C#]
public class Solution : SolBase {
    public int Rand10() {
        int row, col, idx;
        do {
            row = Rand7();
            col = Rand7();
            idx = col + (row - 1) * 7;
        } while (idx > 40);
        return 1 + (idx - 1) % 10;
    }
}
```

```JavaScript [sol1-JavaScript]
var rand10 = function() {
    var row, col, idx;
    do {
        row = rand7();
        col = rand7();
        idx = col + (row - 1) * 7;
    } while (idx > 40);
    return 1 + (idx - 1) % 10;
};
```

```go [sol1-Golang]
func rand10() int {
    for {
        row := rand7()
        col := rand7()
        idx := (row-1)*7 + col
        if idx <= 40 {
            return 1 + (idx-1)%10
        }
    }
}
```

```Python [sol1-Python3]
class Solution:
    def rand10(self) -> int:
        while True:
            row = rand7()
            col = rand7()
            idx = (row - 1) * 7 + col
            if idx <= 40:
                return 1 + (idx - 1) % 10
```

**复杂度分析**

- 时间复杂度：期望时间复杂度为 $O(1)$，但最坏情况下会达到 $O(\infty)$（一直被拒绝）。

- 空间复杂度：$O(1)$。

#### 进阶问题

+ **函数调用次数的期望**：我们来分析这种方法在平均情况下需要调用 $\textit{Rand7()}$ 的次数。我们称连续调用两次 $\textit{Rand7()}$ 为一轮，在第一轮中，有 $\frac{40}{49}$ 的概率被接受，而有 $\frac{9}{49}$ 的概率被拒绝，进入第二轮随机；第二轮有 $(\frac{9}{49})^{2}$ 被拒绝,由此推理我们可以知道第$n$轮被拒绝的概率为 $(\frac{9}{49})^{n}$ 。因此调用 $\textit{Rand7()}$ 的期望次数为：

$$
\begin{aligned} E(\text{\# calls}) 
&= 2 + 2 \cdot \frac{9}{49} + 2 \cdot (\frac{9}{49})^2 + \ldots\\ 
&= 2 \sum_{n=0}^\infty (\frac{9}{49})^n\\ 
&= 2 \cdot \frac{1}{1 - \frac{9}{49}}\\ 
&= 2.45 
\end{aligned}
$$

+ **减少 $\textit{Rand7()}$ 的调用次数**: 我们减小随机被拒绝的概率，从而减小 $\textit{Rand7()}$ 的调用次数的期望，即可减少 $\textit{Rand7()}$ 的平均调用次数。

   + 我们可以通过合理地使用被拒绝的采样，从而对方法一进行优化。在方法一中，我们生成 $[1, 49]$ 的随机数，若生成的随机数 $x$ 在 $[41, 49]$ 中，我们则拒绝 $x$。然而在 $x$ 被拒绝的情况下，我们得到了一个 $[1, 9]$ 的随机数，如果再调用一次 $\textit{Rand7()}$，那么就可以生成 $[1, 63]$ 的随机数。我们保留 $[1, 60]$ 并拒绝 $[61, 63]$：这是 $[1, 3]$ 的随机数。我们继续调用 $Rand7()$，生成 $[1, 21]$ 的随机数，保留 $[1, 20]$ 并拒绝 $[1]$。此时 $[1]$ 已经没有任何用处，若出现了拒绝 $1$ 的情况，我们就重新开始生成 $[1, 49]$ 的随机数。我们可以算它的期望如下：

$$
\begin{aligned} E(\text{\# calls}) 
&= 2 + 1 \cdot \frac{9}{49} + 1 \cdot \frac{9}{49} \cdot \frac{3}{63} +  2 \cdot \frac{9}{49} \cdot \frac{3}{63} \cdot \frac{1}{21}  + \ldots \\ 
&= (2 + \frac{9}{49} + \frac{9}{49} \cdot \frac{3}{63}) \cdot\frac{1}{1-\frac{9}{49} \cdot \frac{3}{63} \cdot \frac{1}{21} }\\ 
&\approx 2.19333
\end{aligned}
$$

**参考代码**

```C++ [sol2-C++]
class Solution {
public:
    int rand10() {
        int a, b, idx;
        while (true) {
            a = rand7();
            b = rand7();
            idx = b + (a - 1) * 7;
            if (idx <= 40) {
                return 1 + (idx - 1) % 10;
            }
            a = idx - 40;
            b = rand7();
            // get uniform dist from 1 - 63
            idx = b + (a - 1) * 7;
            if (idx <= 60) {
                return 1 + (idx - 1) % 10;
            }
            a = idx - 60;
            b = rand7();
            // get uniform dist from 1 - 21
            idx = b + (a - 1) * 7;
            if (idx <= 20) {
                return 1 + (idx - 1) % 10;
            }
        }
    }
};
```

```Java [sol2-Java]
class Solution extends SolBase {
    public int rand10() {
        int a, b, idx;
        while (true) {
            a = rand7();
            b = rand7();
            idx = b + (a - 1) * 7;
            if (idx <= 40) {
                return 1 + (idx - 1) % 10;
            }
            a = idx - 40;
            b = rand7();
            // get uniform dist from 1 - 63
            idx = b + (a - 1) * 7;
            if (idx <= 60) {
                return 1 + (idx - 1) % 10;
            }
            a = idx - 60;
            b = rand7();
            // get uniform dist from 1 - 21
            idx = b + (a - 1) * 7;
            if (idx <= 20) {
                return 1 + (idx - 1) % 10;
            }
        }
    }
}
```

```C# [sol2-C#]
public class Solution : SolBase {
    public int Rand10() {
        int a, b, idx;
        while (true) {
            a = Rand7();
            b = Rand7();
            idx = b + (a - 1) * 7;
            if (idx <= 40) {
                return 1 + (idx - 1) % 10;
            }
            a = idx - 40;
            b = Rand7();
            // get uniform dist from 1 - 63
            idx = b + (a - 1) * 7;
            if (idx <= 60) {
                return 1 + (idx - 1) % 10;
            }
            a = idx - 60;
            b = Rand7();
            // get uniform dist from 1 - 21
            idx = b + (a - 1) * 7;
            if (idx <= 20) {
                return 1 + (idx - 1) % 10;
            }
        }
    }
}
```

```JavaScript [sol2-JavaScript]
var rand10 = function() {
    var a, b, idx;
    while (true) {
        a = rand7();
        b = rand7();
        idx = b + (a - 1) * 7;
        if (idx <= 40) {
            return 1 + (idx - 1) % 10;
        }
        a = idx - 40;
        b = rand7();
        // get uniform dist from 1 - 63
        idx = b + (a - 1) * 7;
        if (idx <= 60) {
            return 1 + (idx - 1) % 10;
        }
        a = idx - 60;
        b = rand7();
        // get uniform dist from 1 - 21
        idx = b + (a - 1) * 7;
        if (idx <= 20) {
            return 1 + (idx - 1) % 10;
        }
    }
};
```

```go [sol2-Golang]
func rand10() int {
    for {
        a := rand7()
        b := rand7()
        idx := (a-1)*7 + b
        if idx <= 40 {
            return 1 + (idx-1)%10
        }
        a = idx - 40
        b = rand7()
        // get uniform dist from 1 - 63
        idx = (a-1)*7 + b
        if idx <= 60 {
            return 1 + (idx-1)%10
        }
        a = idx - 60
        b = rand7()
        // get uniform dist from 1 - 21
        idx = (a-1)*7 + b
        if idx <= 20 {
            return 1 + (idx-1)%10
        }
    }
}
```

```Python [sol2-Python3]
class Solution:
    def rand10(self) -> int:
        while True:
            a = rand7()
            b = rand7()
            idx = (a - 1) * 7 + b
            if idx <= 40:
                return 1 + (idx - 1) % 10
            a = idx - 40
            b = rand7()
            # get uniform dist from 1 - 63
            idx = (a - 1) * 7 + b
            if idx <= 60:
                return 1 + (idx - 1) % 10
            a = idx - 60
            b = rand7()
            # get uniform dist from 1 - 21
            idx = (a - 1) * 7 + b
            if idx <= 20:
                return 1 + (idx - 1) % 10
```
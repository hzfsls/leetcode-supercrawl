#### 方法一：一次遍历

**思路与算法**

最容易想到的解法是：从头到尾遍历每个加油站，并检查以该加油站为起点，最终能否行驶一周。我们可以通过减小被检查的加油站数目，来降低总的时间复杂度。

假设我们此前发现，从加油站 $x$ 出发，每经过一个加油站就加一次油（包括起始加油站），最后一个可以到达的加油站是 $y$（不妨设 $x<y$）。这就说明：
$$
\sum_{i=x}^{y}\textit{gas}[i] < \sum_{i=x}^{y}\textit{cost}[i] \\
\sum_{i=x}^{j}gas[i] \ge \sum_{i=x}^{j}cost[i] ~ \text{(For all $j \in [x, y)$) }
$$

第一个式子表明无法到达加油站 $y$ 的下一个加油站，第二个式子表明可以到达 $y$ 以及 $y$ 之前的所有加油站。

现在，考虑任意一个位于 $x,y$ 之间的加油站 $z$（包括 $x$ 和 $y$），我们现在考察从该加油站出发，能否到达加油站 $y$ 的下一个加油站，也就是要判断 $\sum_{i=z}^{y}\textit{gas}[i]$ 与 $\sum_{i=z}^{y}\textit{cost}[i]$ 之间的大小关系。

根据上面的式子，我们得到：
$$
\begin{aligned}
\sum_{i=z}^{y}\textit{gas}[i]&=\sum_{i=x}^{y}\textit{gas}[i]-\sum_{i=x}^{z-1}\textit{gas}[i] \\
&< \sum_{i=x}^{y}\textit{cost}[i]-\sum_{i=x}^{z-1}\textit{gas}[i] \\
&< \sum_{i=x}^{y}\textit{cost}[i]-\sum_{i=x}^{z-1}cost[i] \\
&= \sum_{i=z}^{y}\textit{cost}[i]
\end{aligned}
$$

其中不等式的第二步、第三步分别利用了上面的第一个、第二个不等式。

从上面的推导中，能够得出结论：从 $x,y$ 之间的任何一个加油站出发，都无法到达加油站 $y$ 的下一个加油站。

在发现了这一个性质后，算法就很清楚了：我们首先检查第 $0$ 个加油站，并试图判断能否环绕一周；如果不能，就从第一个无法到达的加油站开始继续检查。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    int canCompleteCircuit(vector<int>& gas, vector<int>& cost) {
        int n = gas.size();
        int i = 0;
        while (i < n) {
            int sumOfGas = 0, sumOfCost = 0;
            int cnt = 0;
            while (cnt < n) {
                int j = (i + cnt) % n;
                sumOfGas += gas[j];
                sumOfCost += cost[j];
                if (sumOfCost > sumOfGas) {
                    break;
                }
                cnt++;
            }
            if (cnt == n) {
                return i;
            } else {
                i = i + cnt + 1;
            }
        }
        return -1;
    }
};
```

```Java [sol1-Java]
class Solution {
    public int canCompleteCircuit(int[] gas, int[] cost) {
        int n = gas.length;
        int i = 0;
        while (i < n) {
            int sumOfGas = 0, sumOfCost = 0;
            int cnt = 0;
            while (cnt < n) {
                int j = (i + cnt) % n;
                sumOfGas += gas[j];
                sumOfCost += cost[j];
                if (sumOfCost > sumOfGas) {
                    break;
                }
                cnt++;
            }
            if (cnt == n) {
                return i;
            } else {
                i = i + cnt + 1;
            }
        }
        return -1;
    }
}
```

```Golang [sol1-Golang]
func canCompleteCircuit(gas []int, cost []int) int {
    for i, n := 0, len(gas); i < n; {
        sumOfGas, sumOfCost, cnt := 0, 0, 0
        for cnt < n {
            j := (i + cnt) % n
            sumOfGas += gas[j]
            sumOfCost += cost[j]
            if sumOfCost > sumOfGas {
                break
            }
            cnt++
        }
        if cnt == n {
            return i
        } else {
            i += cnt + 1
        }
    }
    return -1
}
```

```C [sol1-C]
int canCompleteCircuit(int* gas, int gasSize, int* cost, int costSize) {
    int i = 0;
    while (i < gasSize) {
        int sumOfGas = 0, sumOfCost = 0;
        int cnt = 0;
        while (cnt < gasSize) {
            int j = (i + cnt) % gasSize;
            sumOfGas += gas[j];
            sumOfCost += cost[j];
            if (sumOfCost > sumOfGas) {
                break;
            }
            cnt++;
        }
        if (cnt == gasSize) {
            return i;
        } else {
            i = i + cnt + 1;
        }
    }
    return -1;
}
```

```JavaScript [sol1-JavaScript]
var canCompleteCircuit = function(gas, cost) {
    const n = gas.length;
    let i = 0;
    while (i < n) {
        let sumOfGas = 0, sumOfCost = 0;
        let cnt = 0;
        while (cnt < n) {
            const j = (i + cnt) % n;
            sumOfGas += gas[j];
            sumOfCost += cost[j];
            if (sumOfCost > sumOfGas) {
                break;
            }
            cnt++;
        }
        if (cnt === n) {
            return i;
        } else {
            i = i + cnt + 1;
        }
    }
    return -1;
};
```

**复杂度分析**

- 时间复杂度：$O(N)$，其中 $N$ 为数组的长度。我们对数组进行了单次遍历。

- 空间复杂度：$O(1)$。
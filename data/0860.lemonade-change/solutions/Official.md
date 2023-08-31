## [860.柠檬水找零 中文官方题解](https://leetcode.cn/problems/lemonade-change/solutions/100000/ning-meng-shui-zhao-ling-by-leetcode-sol-nvp7)
#### 方法一：贪心

由于顾客只可能给你三个面值的钞票，而且我们一开始没有任何钞票，因此我们拥有的钞票面值只可能是 $5$ 美元，$10$ 美元和 $20$ 美元三种。基于此，我们可以进行如下的分类讨论。

- $5$ 美元，由于柠檬水的价格也为 $5$ 美元，因此我们直接收下即可。

- $10$ 美元，我们需要找回 $5$ 美元，如果没有 $5$ 美元面值的钞票，则无法正确找零。

- $20$ 美元，我们需要找回 $15$ 美元，此时有两种组合方式，一种是一张 $10$ 美元和 $5$ 美元的钞票，一种是 $3$ 张 $5$ 美元的钞票，如果两种组合方式都没有，则无法正确找零。当可以正确找零时，两种找零的方式中我们更倾向于第一种，即如果存在 $5$ 美元和 $10$ 美元，我们就按第一种方式找零，否则按第二种方式找零，因为需要使用 $5$ 美元的找零场景会比需要使用 $10$ 美元的找零场景多，我们需要尽可能保留 $5$ 美元的钞票。

基于此，我们维护两个变量 $\textit{five}$ 和 $\textit{ten}$ 表示当前手中拥有的 $5$ 美元和 $10$ 美元钞票的张数，从前往后遍历数组分类讨论即可。

```C++ [sol1-C++]
class Solution {
public:
    bool lemonadeChange(vector<int>& bills) {
        int five = 0, ten = 0;
        for (auto& bill: bills) {
            if (bill == 5) {
                five++;
            } else if (bill == 10) {
                if (five == 0) {
                    return false;
                }
                five--;
                ten++;
            } else {
                if (five > 0 && ten > 0) {
                    five--;
                    ten--;
                } else if (five >= 3) {
                    five -= 3;
                } else {
                    return false;
                }
            }
        }
        return true;
    } 
};
```

```Java [sol1-Java]
class Solution {
    public boolean lemonadeChange(int[] bills) {
        int five = 0, ten = 0;
        for (int bill : bills) {
            if (bill == 5) {
                five++;
            } else if (bill == 10) {
                if (five == 0) {
                    return false;
                }
                five--;
                ten++;
            } else {
                if (five > 0 && ten > 0) {
                    five--;
                    ten--;
                } else if (five >= 3) {
                    five -= 3;
                } else {
                    return false;
                }
            }
        }
        return true;
    }
}
```

```JavaScript [sol1-JavaScript]
var lemonadeChange = function(bills) {
    let five = 0, ten = 0;
    for (const bill of bills) {
        if (bill === 5) {
            five += 1;
        } else if (bill === 10) {
            if (five === 0) {
                return false;
            }
            five -= 1;
            ten += 1;
        } else {
            if (five > 0 && ten > 0) {
                five -= 1;
                ten -= 1;
            } else if (five >= 3) {
                five -= 3;
            } else {
                return false;
            }
        }
    }
    return true;
};
```

```Golang [sol1-Golang]
func lemonadeChange(bills []int) bool {
    five, ten := 0, 0
    for _, bill := range bills {
        if bill == 5 {
            five++
        } else if bill == 10 {
            if five == 0 {
                return false
            }
            five--
            ten++
        } else {
            if five > 0 && ten > 0 {
                five--
                ten--
            } else if five >= 3 {
                five -= 3
            } else {
                return false
            }
        }
    }
    return true
}
```

```C [sol1-C]
bool lemonadeChange(int* bills, int billsSize) {
    int five = 0, ten = 0;
    for (int i = 0; i < billsSize; i++) {
        if (bills[i] == 5) {
            five++;
        } else if (bills[i] == 10) {
            if (five == 0) {
                return false;
            }
            five--;
            ten++;
        } else {
            if (five > 0 && ten > 0) {
                five--;
                ten--;
            } else if (five >= 3) {
                five -= 3;
            } else {
                return false;
            }
        }
    }
    return true;
}
```

**复杂度分析**

* 时间复杂度：$O(N)$，其中 $N$ 是 $\textit{bills}$ 的长度。

* 空间复杂度：$O(1)$。
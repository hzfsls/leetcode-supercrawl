## [1104.二叉树寻路 中文官方题解](https://leetcode.cn/problems/path-in-zigzag-labelled-binary-tree/solutions/100000/er-cha-shu-xun-lu-by-leetcode-solution-ryx0)
#### 方法一：数学

我们先来研究一个简单的情形：二叉树的每一行都是按从左到右的顺序进行标记。此时二叉树满足以下性质：

- 根节点位于第 $1$ 行；

- 第 $i$ 行有 $2^{i-1}$ 个节点，最左边的节点标号为 $2^{i-1}$，最右边的节点标号为 $2^i-1$；

- 对于标号为 $\textit{val}$ 的节点，其左子节点的标号为 $2 \times \textit{val}$，右子节点的标号为 $2 \times \textit{val} + 1$，当 $\textit{val}>1$ 时，其父节点的标号为 $\lfloor \frac{\textit{val}}{2} \rfloor$。

对于给定节点的标号 $\textit{label}$，可以根据上述性质得到从该节点到根节点的路径，将路径反转后，即为从根节点到标号 $\textit{label}$ 的节点的路径。

回到这题，对于偶数行按从右到左的顺序进行标记的情况，可以转换成按从左到右的顺序进行标记的情况，然后按照上述思路得到路径，只要对偶数行的标号进行转换即可。为了表述简洁，下文将按从左到右的顺序进行标记时的节点的标号称为「从左到右标号」。

首先找到标号为 $\textit{label}$ 的节点所在的行和该节点的「从左到右标号」。为了找到节点所在行，需要找到 $i$ 满足 $2^{i-1} \le \textit{label} < 2^i$，则该节点在第 $i$ 行。该节点的「从左到右标号」需要根据 $i$ 的奇偶性计算：

- 当 $i$ 是奇数时，第 $i$ 行为按从左到右的顺序进行标记，因此该节点的「从左到右标号」即为 $\textit{label}$；

- 当 $i$ 是偶数时，第 $i$ 行为按从右到左的顺序进行标记，将整行的标号左右翻转之后得到按从左到右的顺序进行标记的标号，对于同一个节点，其翻转前后的标号之和为 $2^{i-1} + 2^i - 1$，因此标号为 $\textit{label}$ 的节点的「从左到右标号」为 $2^{i-1} + 2^i - 1 - \textit{label}$。

得到标号为 $\textit{label}$ 的节点的「从左到右标号」之后，即可得到从该节点到根节点的路径，以及路径上的每个节点的「从左到右标号」。对于路径上的每个节点，需要根据节点所在行的奇偶性，得到该节点的实际标号：

- 当 $i$ 是奇数时，第 $i$ 行的每个节点的「从左到右标号」即为该节点的实际标号；

- 当 $i$ 是偶数时，如果第 $i$ 行的一个节点的「从左到右标号」为 $\textit{val}$，则该节点的实际标号为 $2^{i-1} + 2^i - 1 - \textit{val}$。

最后，将路径反转，即可得到从根节点到标号 $\textit{label}$ 的节点的路径。

<![fig1](https://assets.leetcode-cn.com/solution-static/1104/1.png),![fig2](https://assets.leetcode-cn.com/solution-static/1104/2.png),![fig3](https://assets.leetcode-cn.com/solution-static/1104/3.png),![fig4](https://assets.leetcode-cn.com/solution-static/1104/4.png),![fig5](https://assets.leetcode-cn.com/solution-static/1104/5.png),![fig6](https://assets.leetcode-cn.com/solution-static/1104/6.png),![fig7](https://assets.leetcode-cn.com/solution-static/1104/7.png),![fig8](https://assets.leetcode-cn.com/solution-static/1104/8.png),![fig9](https://assets.leetcode-cn.com/solution-static/1104/9.png),![fig10](https://assets.leetcode-cn.com/solution-static/1104/10.png),![fig11](https://assets.leetcode-cn.com/solution-static/1104/11.png)>

<![fig12](https://assets.leetcode-cn.com/solution-static/1104/12.png),![fig13](https://assets.leetcode-cn.com/solution-static/1104/13.png),![fig14](https://assets.leetcode-cn.com/solution-static/1104/14.png),![fig15](https://assets.leetcode-cn.com/solution-static/1104/15.png),![fig16](https://assets.leetcode-cn.com/solution-static/1104/16.png),![fig17](https://assets.leetcode-cn.com/solution-static/1104/17.png),![fig18](https://assets.leetcode-cn.com/solution-static/1104/18.png),![fig19](https://assets.leetcode-cn.com/solution-static/1104/19.png),![fig20](https://assets.leetcode-cn.com/solution-static/1104/20.png),![fig21](https://assets.leetcode-cn.com/solution-static/1104/21.png),![fig22](https://assets.leetcode-cn.com/solution-static/1104/22.png),![fig23](https://assets.leetcode-cn.com/solution-static/1104/23.png)>

```Java [sol1-Java]
class Solution {
    public List<Integer> pathInZigZagTree(int label) {
        int row = 1, rowStart = 1;
        while (rowStart * 2 <= label) {
            row++;
            rowStart *= 2;
        }
        if (row % 2 == 0) {
            label = getReverse(label, row);
        }
        List<Integer> path = new ArrayList<Integer>();
        while (row > 0) {
            if (row % 2 == 0) {
                path.add(getReverse(label, row));
            } else {
                path.add(label);
            }
            row--;
            label >>= 1;
        }
        Collections.reverse(path);
        return path;
    }

    public int getReverse(int label, int row) {
        return (1 << row - 1) + (1 << row) - 1 - label;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public IList<int> PathInZigZagTree(int label) {
        int row = 1, rowStart = 1;
        while (rowStart * 2 <= label) {
            row++;
            rowStart *= 2;
        }
        if (row % 2 == 0) {
            label = GetReverse(label, row);
        }
        IList<int> path = new List<int>();
        while (row > 0) {
            if (row % 2 == 0) {
                path.Add(GetReverse(label, row));
            } else {
                path.Add(label);
            }
            row--;
            label >>= 1;
        }
        path = new List<int>(path.Reverse());
        return path;
    }

    public int GetReverse(int label, int row) {
        return (1 << row - 1) + (1 << row) - 1 - label;
    }
}
```

```JavaScript [sol1-JavaScript]
var pathInZigZagTree = function(label) {
    let row = 1, rowStart = 1;
    while (rowStart * 2 <= label) {
        row++;
        rowStart *= 2;
    }
    if (row % 2 === 0) {
        label = getReverse(label, row);
    }
    const path = [];
    while (row > 0) {
        if (row % 2 === 0) {
            path.push(getReverse(label, row));
        } else {
            path.push(label);
        }
        row--;
        label >>= 1;
    }
    path.reverse();
    return path;
};

const getReverse = (label, row) => {
    return (1 << row - 1) + (1 << row) - 1 - label;
}
```

```C++ [sol1-C++]
class Solution {
public:
    int getReverse(int label, int row) {
        return (1 << row - 1) + (1 << row) - 1 - label;
    }

    vector<int> pathInZigZagTree(int label) {
        int row = 1, rowStart = 1;
        while (rowStart * 2 <= label) {
            row++;
            rowStart *= 2;
        }
        if (row % 2 == 0) {
            label = getReverse(label, row);
        }
        vector<int> path;
        while (row > 0) {
            if (row % 2 == 0) {
                path.push_back(getReverse(label, row));
            } else {
                path.push_back(label);
            }
            row--;
            label >>= 1;
        }
        reverse(path.begin(), path.end());
        return path;
    }
};
```

```C [sol1-C]
void swap(int* a, int* b) {
    int t = *a;
    *a = *b, *b = t;
}

void reverse(int* arr, int left, int right) {
    while (left < right) {
        swap(&arr[left], &arr[right]);
        left++, right--;
    }
}

int getReverse(int label, int row) {
    return (1 << row - 1) + (1 << row) - 1 - label;
}

int* pathInZigZagTree(int label, int* returnSize) {
    int row = 1, rowStart = 1;
    while (rowStart * 2 <= label) {
        row++;
        rowStart *= 2;
    }
    if (row % 2 == 0) {
        label = getReverse(label, row);
    }
    int* path = malloc(sizeof(int) * 20);
    *returnSize = 0;
    while (row > 0) {
        if (row % 2 == 0) {
            path[(*returnSize)++] = getReverse(label, row);
        } else {
            path[(*returnSize)++] = label;
        }
        row--;
        label >>= 1;
    }
    reverse(path, 0, *returnSize - 1);
    return path;
}
```

```go [sol1-Golang]
func getReverse(label, row int) int {
    return 1<<(row-1) + 1<<row - 1 - label
}

func pathInZigZagTree(label int) (path []int) {
    row, rowStart := 1, 1
    for rowStart*2 <= label {
        row++
        rowStart *= 2
    }
    if row%2 == 0 {
        label = getReverse(label, row)
    }
    for row > 0 {
        if row%2 == 0 {
            path = append(path, getReverse(label, row))
        } else {
            path = append(path, label)
        }
        row--
        label >>= 1
    }
    for i, n := 0, len(path); i < n/2; i++ {
        path[i], path[n-1-i] = path[n-1-i], path[i]
    }
    return
}
```

**复杂度分析**

- 时间复杂度：$O(\log \textit{label})$。标号为 $\textit{label}$ 的节点所在的行数为 $O(\log \textit{label})$，因此从根节点到标号 $\textit{label}$ 的节点的路径的长度为 $O(\log \textit{label})$，路径中的每个节点的标号都可以在 $O(1)$ 时间内计算得到。

- 空间复杂度：$O(1)$。除了返回值以外，额外使用的空间为常数。
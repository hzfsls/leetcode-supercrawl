## [1710.卡车上的最大单元数 中文官方题解](https://leetcode.cn/problems/maximum-units-on-a-truck/solutions/100000/qia-che-shang-de-zui-da-dan-yuan-shu-by-ynaqv)

#### 方法一：贪心

**思路**

只能装 $\textit{truckSize}$ 个箱子到卡车上，根据贪心的思路，只需要每次都拿当前剩下的箱子里单元数量最大的箱子即可。对 $\textit{boxTypes}$ 按照 $\textit{numberOfUnitsPerBox}$ 进行逆序排序，然后从左至右填充 $\textit{truckSize}$ 即可。

**代码**

```Python [sol1-Python3]
class Solution:
    def maximumUnits(self, boxTypes: List[List[int]], truckSize: int) -> int:
        boxTypes.sort(key=lambda x: x[1], reverse=True)
        res = 0
        for numberOfBoxes, numberOfUnitsPerBox in boxTypes:
            if numberOfBoxes >= truckSize:
                res += truckSize * numberOfUnitsPerBox
                break
            res += numberOfBoxes * numberOfUnitsPerBox
            truckSize -= numberOfBoxes
        return res
```

```C++ [sol1-C++]
class Solution {
public:
    int maximumUnits(vector<vector<int>>& boxTypes, int truckSize) {
        sort(boxTypes.begin(), boxTypes.end(), [](const vector<int> &a, const vector<int> &b) {
            return a[1] > b[1];
        });
        int res = 0;
        for (auto &boxType : boxTypes) {
            int numberOfBoxes = boxType[0];
            int numberOfUnitsPerBox = boxType[1];
            if (numberOfBoxes < truckSize) {
                res += numberOfBoxes * numberOfUnitsPerBox;
                truckSize -= numberOfBoxes;
            } else {
                res += truckSize * numberOfUnitsPerBox;
                break;
            }
        }
        return res;
    }
};
```

```Java [sol1-Java]
class Solution {
    public int maximumUnits(int[][] boxTypes, int truckSize) {
        Arrays.sort(boxTypes, (a, b) -> b[1] - a[1]);
        int res = 0;
        for (int[] boxType : boxTypes) {
            int numberOfBoxes = boxType[0];
            int numberOfUnitsPerBox = boxType[1];
            if (numberOfBoxes < truckSize) {
                res += numberOfBoxes * numberOfUnitsPerBox;
                truckSize -= numberOfBoxes;
            } else {
                res += truckSize * numberOfUnitsPerBox;
                break;
            }
        }
        return res;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int MaximumUnits(int[][] boxTypes, int truckSize) {
        Array.Sort(boxTypes, (a, b) => b[1] - a[1]);
        int res = 0;
        foreach (int[] boxType in boxTypes) {
            int numberOfBoxes = boxType[0];
            int numberOfUnitsPerBox = boxType[1];
            if (numberOfBoxes < truckSize) {
                res += numberOfBoxes * numberOfUnitsPerBox;
                truckSize -= numberOfBoxes;
            } else {
                res += truckSize * numberOfUnitsPerBox;
                break;
            }
        }
        return res;
    }
}
```

```C [sol1-C]
static inline int cmp(const void *pa, const void *pb) {
    return (*(int **)pb)[1] - (*(int **)pa)[1];
}

int maximumUnits(int** boxTypes, int boxTypesSize, int* boxTypesColSize, int truckSize) {
    qsort(boxTypes, boxTypesSize, sizeof(int *), cmp);
    int res = 0;
    for (int i = 0; i < boxTypesSize; i++) {
        int numberOfBoxes = boxTypes[i][0];
        int numberOfUnitsPerBox = boxTypes[i][1];
        if (numberOfBoxes < truckSize) {
            res += numberOfBoxes * numberOfUnitsPerBox;
            truckSize -= numberOfBoxes;
        } else {
            res += truckSize * numberOfUnitsPerBox;
            break;
        }
    }
    return res;
}
```

```JavaScript [sol1-JavaScript]
var maximumUnits = function(boxTypes, truckSize) {
    boxTypes.sort((a, b) => b[1] - a[1]);
    let res = 0;
    for (const boxType of boxTypes) {
        let numberOfBoxes = boxType[0];
        let numberOfUnitsPerBox = boxType[1];
        if (numberOfBoxes < truckSize) {
            res += numberOfBoxes * numberOfUnitsPerBox;
            truckSize -= numberOfBoxes;
        } else {
            res += truckSize * numberOfUnitsPerBox;
            break;
        }
    }
    return res;
};
```

```go [sol1-Golang]
func maximumUnits(boxTypes [][]int, truckSize int) (ans int) {
    sort.Slice(boxTypes, func(i, j int) bool { return boxTypes[i][1] > boxTypes[j][1] })
    for _, p := range boxTypes {
        if p[0] >= truckSize {
            ans += truckSize * p[1]
            break
        }
        truckSize -= p[0]
        ans += p[0] * p[1]
    }
    return
}
```

**复杂度分析**

- 时间复杂度：$O(n \log n)$，其中 $n$ 是 $\textit{boxTypes}$ 的长度。排序需要 $O(n \log n)$ 的时间。

- 空间复杂度：$O(\log n)$，其中 $n$ 是 $\textit{boxTypes}$ 的长度。排序需要 $O(\log n)$ 的递归调用栈空间。
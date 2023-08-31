## [2511.最多可以摧毁的敌人城堡数目 中文官方题解](https://leetcode.cn/problems/maximum-enemy-forts-that-can-be-captured/solutions/100000/zui-duo-ke-yi-cui-hui-de-di-ren-cheng-ba-5qmc)
#### 方法一：直接模拟

**思路与算法**

根据题意可以知道军队从 $i$ 处移动到 $j$ 处时需要满足如下要求：
+ 由于在 $i$ 处的城堡为你方军队控制的城堡，则一定满足 $\textit{forts}[i] = 1$；
+ 由于在 $j$ 处为空位置，则一定满足 $\textit{forts}[j] = -1$；
+ 在移动过程中如下，由于军队经过的位置只只能为敌人的城堡，因此当 $k \in (\min(i,j),max(i,j))$ 时，需满足 $\textit{forts}[k] = 0$。
+ 当军队移动时，所有途中经过的敌人城堡都会被摧毁，题目要求找到一次移动后可以摧毁敌人城堡的最大数目。

根据以上分析可以知道由于军队只能在不同位置之间连续移动，军队移动的起点为 $1$，军队移动的终点为 $-1$，军队可以向左移动也可以向右移动，因此我们只需要找到相邻的 $1$ 与 $-1$ 之间的最大距离即可，此时 $1$ 与 $-1$ 之间所有的 $0$ 都会被摧毁。查找过程如下：
+ 依次遍历为数组 $\textit{forts}$ 中的每个元素，此时我们用 $\textit{pre}$ 记录数组中前一个为 $1$ 或者 $-1$ 的位置；
+ 假设当前元素 $\textit{forts}[i]$ 为 $1$ 或者 $-1$，即当前位置可能为军队的起点为终点，此时假设 $\textit{forts}[i] \neq \textit{forts}[\textit{pre}]$，即此时可以在 $i$ 与 $\textit{pre}$ 之间可以移动，此时可以摧毁的城堡数目为 $i - \textit{pre} - 1$，更新当前的最大城堡数目，同时记录新的 $\textit{pre}$；

按照上述方法找到最大可以摧毁的城堡数目即可。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    int captureForts(vector<int>& forts) {
        int ans = 0, pre = -1;
        for (int i = 0; i < forts.size(); i++) {
            if (forts[i] == 1 || forts[i] == -1) {
                if (pre >= 0 && forts[i] != forts[pre]) {
                    ans = max(ans, i - pre - 1);
                }
                pre = i;
            }
        }
        return ans;
    }
};
```

```C# [sol1-C#]
public class Solution {
    public int CaptureForts(int[] forts) {
        int n = forts.Length;
        int ans = 0, pre = -1;
        for (int i = 0; i < n; i++) {
            if (forts[i] == 1 || forts[i] == -1) {
                if (pre >= 0 && forts[i] != forts[pre]) {
                    ans = Math.Max(ans, i - pre - 1);
                }
                pre = i;
            }
        }
        return ans;
    }
}
```

```C [sol1-C]
int captureForts(int* forts, int fortsSize) {
    int ans = 0, pre = -1;
    for (int i = 0; i < fortsSize; i++) {
        if (forts[i] == 1 || forts[i] == -1) {
            if (pre >= 0 && forts[i] != forts[pre]) {
                ans = fmax(ans, i - pre - 1);
            }
            pre = i;
        }
    }
    return ans;
}
```

```Java [sol1-Java]
class Solution {
    public int captureForts(int[] forts) {
        int n = forts.length;
        int ans = 0, pre = -1;
        for (int i = 0; i < n; i++) {
            if (forts[i] == 1 || forts[i] == -1) {
                if (pre >= 0 && forts[i] != forts[pre]) {
                    ans = Math.max(ans, i - pre - 1);
                }
                pre = i;
            }
        }
        return ans;
    }
}
```

```Python [sol1-Python3]
class Solution:
    def captureForts(self, forts: List[int]) -> int:
        ans, pre = 0, -1
        for i, fort in enumerate(forts):
            if fort == -1 or fort == 1:
                if pre >= 0 and fort != forts[pre]:
                    ans = max(ans, i - pre - 1)
                pre = i
        return ans
```

```Go [sol1-Go]
func captureForts(forts []int) int {
    ans, pre := 0, -1
    for i, fort := range forts {
        if fort == -1 || fort == 1 {
            if pre >= 0 && forts[pre] != fort {
                ans = max(ans, i - pre - 1)
            }
            pre = i
        }
    }
    return ans
}

func max(a int, b int) int {
    if a > b {
        return a
    }
    return b
}
```

```JavaScript [sol1-JavaScript]
var captureForts = function(forts) {
    let ans = 0, pre = -1;
    for (let i = 0; i < forts.length; i++) {
        if (forts[i] == 1 || forts[i] == -1) {
            if (pre >= 0 && forts[i] != forts[pre]) {
                ans = Math.max(ans, i - pre - 1);
            }
            pre = i;
        }
    }
    return ans;
};
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 表示数组 $\textit{forts}$ 的长度。在遍历 $\textit{forts}$ 时，每个元素只会遍历一次，因此时间复杂度为 $O(n)$。

- 空间复杂度：$O(1)$。
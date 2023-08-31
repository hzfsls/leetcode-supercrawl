## [1732.找到最高海拔 中文官方题解](https://leetcode.cn/problems/find-the-highest-altitude/solutions/100000/zhao-dao-zui-gao-hai-ba-by-leetcode-solu-l01c)
#### 方法一：前缀和

**思路与算法**

根据题目描述，点 $0$ 的海拔高度为 $0$，点 $i~(i > 0)$ 的海拔高度为：

$$
\sum_{k=0}^{i-1} \textit{gain}[i]
$$

因此，我们只需要对数组 $\textit{gain}$ 进行一次遍历，在遍历到第 $i$ 个元素时，使用前缀和的思想维护前 $i$ 个元素的和，并用和更新答案即可。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    int largestAltitude(vector<int>& gain) {
        int ans = 0, sum = 0;
        for (int x: gain) {
            sum += x;
            ans = max(ans, sum);
        }
        return ans;
    }
};
```

```Java [sol1-Java]
class Solution {
    public int largestAltitude(int[] gain) {
        int ans = 0, sum = 0;
        for (int x : gain) {
            sum += x;
            ans = Math.max(ans, sum);
        }
        return ans;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int LargestAltitude(int[] gain) {
        int ans = 0, sum = 0;
        foreach (int x in gain) {
            sum += x;
            ans = Math.Max(ans, sum);
        }
        return ans;
    }
}
```

```Python [sol1-Python3]
class Solution:
    def largestAltitude(self, gain: List[int]) -> int:
        ans = total = 0
        for x in gain:
            total += x
            ans = max(ans, total)
        return ans
```

```C [sol1-C]
#define MAX(a, b) ((a) > (b) ? (a) : (b))

int largestAltitude(int* gain, int gainSize){
     int ans = 0, sum = 0;
    for (int i = 0; i < gainSize; i++) {
        sum += gain[i];
        ans = MAX(ans, sum);
    }
    return ans;
}
```

```JavaScript [sol1-JavaScript]
var largestAltitude = function(gain) {
    let ans = 0, sum = 0;
    for (const x of gain) {
        sum += x;
        ans = Math.max(ans, sum);
    }
    return ans;
};
```

```go [sol1-Golang]
func largestAltitude(gain []int) (ans int) {
    total := 0
    for _, x := range gain {
        total += x
        ans = max(ans, total)
    }
    return
}

func max(a, b int) int {
    if b > a {
        return b
    }
    return a
}
```

**复杂度分析**

- 时间复杂度：$O(n)$。

- 空间复杂度：$O(1)$。
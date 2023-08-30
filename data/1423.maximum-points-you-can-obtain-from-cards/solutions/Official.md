#### 方法一：滑动窗口

**思路**

记数组 $\textit{cardPoints}$ 的长度为 $n$，由于只能从开头和末尾拿 $k$ 张卡牌，所以最后剩下的必然是**连续的** $n-k$ 张卡牌。

我们可以通过求出剩余卡牌点数之和的最小值，来求出拿走卡牌点数之和的最大值。

**算法**

由于剩余卡牌是连续的，使用一个固定长度为 $n-k$ 的滑动窗口对数组 $\textit{cardPoints}$ 进行遍历，求出滑动窗口最小值，然后用所有卡牌的点数之和减去该最小值，即得到了拿走卡牌点数之和的最大值。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    int maxScore(vector<int>& cardPoints, int k) {
        int n = cardPoints.size();
        // 滑动窗口大小为 n-k
        int windowSize = n - k;
        // 选前 n-k 个作为初始值
        int sum = accumulate(cardPoints.begin(), cardPoints.begin() + windowSize, 0);
        int minSum = sum;
        for (int i = windowSize; i < n; ++i) {
            // 滑动窗口每向右移动一格，增加从右侧进入窗口的元素值，并减少从左侧离开窗口的元素值
            sum += cardPoints[i] - cardPoints[i - windowSize];
            minSum = min(minSum, sum);
        }
        return accumulate(cardPoints.begin(), cardPoints.end(), 0) - minSum;
    }
};
```

```Python [sol1-Python3]
class Solution:
    def maxScore(self, cardPoints: List[int], k: int) -> int:
        n = len(cardPoints)
        # 滑动窗口大小为 n-k
        windowSize = n - k
        # 选前 n-k 个作为初始值
        s = sum(cardPoints[:windowSize])
        minSum = s
        for i in range(windowSize, n):
            # 滑动窗口每向右移动一格，增加从右侧进入窗口的元素值，并减少从左侧离开窗口的元素值
            s += cardPoints[i] - cardPoints[i - windowSize]
            minSum = min(minSum, s)
        return sum(cardPoints) - minSum
```

```Java [sol1-Java]
class Solution {
    public int maxScore(int[] cardPoints, int k) {
        int n = cardPoints.length;
        // 滑动窗口大小为 n-k
        int windowSize = n - k;
        // 选前 n-k 个作为初始值
        int sum = 0;
        for (int i = 0; i < windowSize; ++i) {
            sum += cardPoints[i];
        }
        int minSum = sum;
        for (int i = windowSize; i < n; ++i) {
            // 滑动窗口每向右移动一格，增加从右侧进入窗口的元素值，并减少从左侧离开窗口的元素值
            sum += cardPoints[i] - cardPoints[i - windowSize];
            minSum = Math.min(minSum, sum);
        }
        return Arrays.stream(cardPoints).sum() - minSum;
    }
}
```

```go [sol1-Golang]
func maxScore(cardPoints []int, k int) int {
    n := len(cardPoints)
    // 滑动窗口大小为 n-k
    windowSize := n - k
    // 选前 n-k 个作为初始值
    sum := 0
    for _, pt := range cardPoints[:windowSize] {
        sum += pt
    }
    minSum := sum
    for i := windowSize; i < n; i++ {
        // 滑动窗口每向右移动一格，增加从右侧进入窗口的元素值，并减少从左侧离开窗口的元素值
        sum += cardPoints[i] - cardPoints[i-windowSize]
        minSum = min(minSum, sum)
    }
    total := 0
    for _, pt := range cardPoints {
        total += pt
    }
    return total - minSum
}

func min(a, b int) int {
    if a < b {
        return a
    }
    return b
}
```

```JavaScript [sol1-JavaScript]
var maxScore = function(cardPoints, k) {
    const n = cardPoints.length;
    // 滑动窗口大小为 n-k
    const windowSize = n - k;
    // 选前 n-k 个作为初始值
    let sum = 0;
    for (let i = 0; i < windowSize; ++i) {
        sum += cardPoints[i];
    }
    let minSum = sum;
    for (let i = windowSize; i < n; ++i) {
        // 滑动窗口每向右移动一格，增加从右侧进入窗口的元素值，并减少从左侧离开窗口的元素值
        sum += cardPoints[i] - cardPoints[i - windowSize];
        minSum = Math.min(minSum, sum);
    }
    let totalSum = 0;
    for (let i = 0; i < n; i++) {
        totalSum += cardPoints[i];
    }
    return totalSum - minSum;
};
```

```C [sol1-C]
int maxScore(int* cardPoints, int cardPointsSize, int k) {
    int n = cardPointsSize;
    // 滑动窗口大小为 n-k
    int windowSize = n - k;
    // 选前 n-k 个作为初始值
    int sum = 0;
    for (int i = 0; i < windowSize; i++) {
        sum += cardPoints[i];
    }
    int ret = sum;
    int minSum = sum;
    for (int i = windowSize; i < n; ++i) {
        // 滑动窗口每向右移动一格，增加从右侧进入窗口的元素值，并减少从左侧离开窗口的元素值
        sum += cardPoints[i] - cardPoints[i - windowSize];
        minSum = fmin(minSum, sum);
        ret += cardPoints[i];
    }
    return ret - minSum;
}
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 是数组 $\textit{cardPoints}$ 的长度。

- 空间复杂度：$O(1)$。
#### 方法一：滑动窗口

**思路**

本题最直观的思路就是遍历计算每个 `k` 天内的卡路里总值，与 `low` 和 `high` 比较。这种方法的时间复杂度为 $O(k*(n-k))$ ，在本题会超时。

上面的方法每个数字都会被重复计算多次。我们可以使用滑动窗口的思想，记录当前 `k` 个数字的总和，一次遍历计算出所有窗口大小为 `k` 的子数组的卡路里总值。下面我们通过动图模拟滑动窗口的运行过程：

![fig1](https://assets.leetcode-cn.com/solution-static/1176_1.gif)

**算法**

1. 计算出前 `k` 个数字的和 `sum`。
2. 从下标 `k` 开始遍历数组。此时窗口大小为 `k` 。将 `sum` 与 `low` 和 `high` 比较。然后减去下标为 `i - k` 的数字，即窗口中最左边的数字，再加上下一个进入到窗口的数字，重复操作。

**代码**

```Golang [ ]
func dietPlanPerformance(calories []int, k int, lower int, upper int) int {
    sum, score := 0, 0
    for i := 0; i < k; i++ {
        sum += calories[i]
    }
    for i := k; ; i++ {
        if sum < lower {
            score--
        } else if sum > upper {
            score++
        }
        if i == len(calories) {
            break
        }
        sum += calories[i] - calories[i - k]
    }
    return score
}
```

```C [ ]
int dietPlanPerformance(int* calories, int caloriesSize, int k, int lower, int upper){
    int index = 0;
    int score = 0;
    int sum = 0;
    for (index; index < k; index++) {
        sum += calories[index];
    }
    for (index; ; index++) {
        if (sum < lower) {
            score--;
        } else if (sum > upper) {
            score++;
        }
        if (index == caloriesSize) {
            break;
        }
        sum += calories[index] - calories[index - k];
    }
    return score;
}
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 为数组 `calories` 的长度。滑动窗口遍历一次数组。

- 空间复杂度：$O(1)$，没有使用额外的空间。
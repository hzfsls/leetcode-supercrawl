#### 方法一：模拟

**思路**

我们可以按照题意来模拟：

+ 找到一个最大值 $\rm maxValue$；

+ 找到一个最小值 $\rm minValue$；

+ 然后对所有元素求和后减去这两个值 ${\rm sum} = (\sum_{i} {\rm salary}[i]) - {\rm maxValue} - {\rm minValue}$；

+ 求平均值 ${\rm sum} / [{\rm salary.size() - 2}]$。

因为这里保证了 $\rm salary$ 数组的长度至少是 $3$，所以我们不用特殊考虑 $\rm maxValue$ 和 $\rm minValue$ 是同一个的问题，因为如果它们相等的话（假设等于 $x$），这个序列里面所有元素都应该是 $x$，不影响计算结果。

**代码**

```cpp [sol1-C++]
class Solution {
public:
    double average(vector<int>& salary) {
        double maxValue = *max_element(salary.begin(), salary.end());
        double minValue = *min_element(salary.begin(), salary.end());
        double sum = accumulate(salary.begin(), salary.end(), - maxValue - minValue);
        return sum / int(salary.size() - 2);
    }
};
```

```java [sol1-Java]
class Solution {
    public double average(int[] salary) {
        double sum = 0;
        double maxValue = Integer.MIN_VALUE, minValue = Integer.MAX_VALUE;
        for (int num : salary) {
            sum += num;
            maxValue = Math.max(maxValue, num);
            minValue = Math.min(minValue, num);
        }
        return (sum - maxValue - minValue) / (salary.length - 2);
    }
}
```

```Python [sol1-Python3]
class Solution:
    def average(self, salary: List[int]) -> float:
        maxValue = max(salary)
        minValue = min(salary)
        total = sum(salary) - maxValue - minValue
        return total / (len(salary) - 2)
```

**复杂度**

+ 时间复杂度：$O(n)$。选取最大值、最小值和求和的过程的时间代价都是 $O(n)$，故渐进时间复杂度为 $O(n)$。

+ 空间复杂度：$O(1)$。这里只用到了常量级别的辅助空间。
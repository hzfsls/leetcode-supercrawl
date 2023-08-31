## [1716.计算力扣银行的钱 中文官方题解](https://leetcode.cn/problems/calculate-money-in-leetcode-bank/solutions/100000/ji-suan-li-kou-yin-xing-de-qian-by-leetc-xogx)
#### 方法一：暴力计算

记当前的天数是第 $\textit{week}$ 周的第 $\textit{day}$ 天。我们从第一周的星期一开始存钱，记 $\textit{week} = 1$，$\textit{day} = 1$。一周内，每一天比前一天多存 $1$ 块钱。而每个周一，会比前一个周一多存 $1$ 块钱。因此，每天存的钱等于 $\textit{week} + \textit{day} - 1$。把每天存的钱相加就可以得到答案。

```Python [sol1-Python3]
class Solution:
    def totalMoney(self, n: int) -> int:
        week, day = 1, 1
        res = 0
        for i in range(n):
            res += week + day - 1
            day += 1
            if day == 8:
                day = 1
                week += 1
        return res
```

```Java [sol1-Java]
class Solution {
    public int totalMoney(int n) {
        int week = 1, day = 1;
        int res = 0;
        for (int i = 0; i < n; ++i) {
            res += week + day - 1;
            ++day;
            if (day == 8) {
                day = 1;
                ++week;
            }
        }
        return res;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int TotalMoney(int n) {
        int week = 1, day = 1;
        int res = 0;
        for (int i = 0; i < n; ++i) {
            res += week + day - 1;
            ++day;
            if (day == 8) {
                day = 1;
                ++week;
            }
        }
        return res;
    }
}
```

```C++ [sol1-C++]
class Solution {
public:
    int totalMoney(int n) {
        int week = 1, day = 1;
        int res = 0;
        for (int i = 0; i < n; ++i) {
            res += week + day - 1;
            ++day;
            if (day == 8) {
                day = 1;
                ++week;
            }
        }
        return res;
    }
};
```

```C [sol1-C]
int totalMoney(int n){
    int week = 1, day = 1;
    int res = 0;
    for (int i = 0; i < n; ++i) {
        res += week + day - 1;
        ++day;
        if (day == 8) {
            day = 1;
            ++week;
        }
    }
    return res;
}
```

```go [sol1-Golang]
func totalMoney(n int) (ans int) {
    week, day := 1, 1
    for i := 0; i < n; i++ {
        ans += week + day - 1
        day++
        if day == 8 {
            day = 1
            week++
        }
    }
    return
}
```

```JavaScript [sol1-JavaScript]
var totalMoney = function(n) {
    let week = 1, day = 1;
    let res = 0;
    for (let i = 0; i < n; ++i) {
        res += week + day - 1;
        ++day;
        if (day === 8) {
            day = 1;
            ++week;
        }
    }
    return res;
};
```

**复杂度分析**

- 时间复杂度：$O(n)$。需要遍历一次 $n$ 得到答案。

- 空间复杂度：$O(1)$。只需要用到常数空间。

#### 方法二：等差数列求和进行优化

因为每周七天存的钱之和比上一周多 $7$ 块，因此每周存的钱之和的序列是一个等差数列，我们可以用等差数列求和公式来求出所有完整的周存的钱总和。剩下的天数里，每天存的钱也是一个等差数列，可以用相同的公式进行求和。最后把两者相加可以得到答案。

```Python [sol2-Python3]
class Solution:
    def totalMoney(self, n: int) -> int:
        # 所有完整的周存的钱
        weekNumber = n // 7
        firstWeekMoney = (1 + 7) * 7 // 2
        lastWeekMoney = firstWeekMoney + 7 * (weekNumber - 1)
        weekMoney = (firstWeekMoney + lastWeekMoney) * weekNumber // 2
        # 剩下的不能构成一个完整的周的天数里存的钱
        dayNumber = n % 7
        firstDayMoney = 1 + weekNumber
        lastDayMoney = firstDayMoney + dayNumber - 1
        dayMoney = (firstDayMoney + lastDayMoney) * dayNumber // 2
        return weekMoney + dayMoney
```

```Java [sol2-Java]
class Solution {
    public int totalMoney(int n) {
        // 所有完整的周存的钱
        int weekNumber = n / 7;
        int firstWeekMoney = (1 + 7) * 7 / 2;
        int lastWeekMoney = firstWeekMoney + 7 * (weekNumber - 1);
        int weekMoney = (firstWeekMoney + lastWeekMoney) * weekNumber / 2;
        // 剩下的不能构成一个完整的周的天数里存的钱
        int dayNumber = n % 7;
        int firstDayMoney = 1 + weekNumber;
        int lastDayMoney = firstDayMoney + dayNumber - 1;
        int dayMoney = (firstDayMoney + lastDayMoney) * dayNumber / 2;
        return weekMoney + dayMoney;
    }
}
```

```C# [sol2-C#]
public class Solution {
    public int TotalMoney(int n) {
        // 所有完整的周存的钱
        int weekNumber = n / 7;
        int firstWeekMoney = (1 + 7) * 7 / 2;
        int lastWeekMoney = firstWeekMoney + 7 * (weekNumber - 1);
        int weekMoney = (firstWeekMoney + lastWeekMoney) * weekNumber / 2;
        // 剩下的不能构成一个完整的周的天数里存的钱
        int dayNumber = n % 7;
        int firstDayMoney = 1 + weekNumber;
        int lastDayMoney = firstDayMoney + dayNumber - 1;
        int dayMoney = (firstDayMoney + lastDayMoney) * dayNumber / 2;
        return weekMoney + dayMoney;
    }
}
```

```C++ [sol2-C++]
class Solution {
public:
    int totalMoney(int n) {
        // 所有完整的周存的钱
        int weekNumber = n / 7;
        int firstWeekMoney = (1 + 7) * 7 / 2;
        int lastWeekMoney = firstWeekMoney + 7 * (weekNumber - 1);
        int weekMoney = (firstWeekMoney + lastWeekMoney) * weekNumber / 2;
        // 剩下的不能构成一个完整的周的天数里存的钱
        int dayNumber = n % 7;
        int firstDayMoney = 1 + weekNumber;
        int lastDayMoney = firstDayMoney + dayNumber - 1;
        int dayMoney = (firstDayMoney + lastDayMoney) * dayNumber / 2;
        return weekMoney + dayMoney;
    }
};
```

```C [sol2-C]
int totalMoney(int n){
    // 所有完整的周存的钱
    int weekNumber = n / 7;
    int firstWeekMoney = (1 + 7) * 7 / 2;
    int lastWeekMoney = firstWeekMoney + 7 * (weekNumber - 1);
    int weekMoney = (firstWeekMoney + lastWeekMoney) * weekNumber / 2;
    // 剩下的不能构成一个完整的周的天数里存的钱
    int dayNumber = n % 7;
    int firstDayMoney = 1 + weekNumber;
    int lastDayMoney = firstDayMoney + dayNumber - 1;
    int dayMoney = (firstDayMoney + lastDayMoney) * dayNumber / 2;
    return weekMoney + dayMoney;
}
```

```go [sol2-Golang]
func totalMoney(n int) (ans int) {
    // 所有完整的周存的钱
    weekNum := n / 7
    firstWeekMoney := (1 + 7) * 7 / 2
    lastWeekMoney := firstWeekMoney + 7*(weekNum-1)
    weekMoney := (firstWeekMoney + lastWeekMoney) * weekNum / 2
    // 剩下的不能构成一个完整的周的天数里存的钱
    dayNum := n % 7
    firstDayMoney := 1 + weekNum
    lastDayMoney := firstDayMoney + dayNum - 1
    dayMoney := (firstDayMoney + lastDayMoney) * dayNum / 2
    return weekMoney + dayMoney
}
```

```JavaScript [sol2-JavaScript]
var totalMoney = function(n) {
    // 所有完整的周存的钱
    const weekNumber = Math.floor(n / 7);
    const firstWeekMoney = Math.floor((1 + 7) * 7 / 2);
    const lastWeekMoney = firstWeekMoney + 7 * (weekNumber - 1);
    const weekMoney = Math.floor((firstWeekMoney + lastWeekMoney) * weekNumber / 2);
    // 剩下的不能构成一个完整的周的天数里存的钱
    const dayNumber = n % 7;
    const firstDayMoney = 1 + weekNumber;
    const lastDayMoney = firstDayMoney + dayNumber - 1;
    const dayMoney = Math.floor((firstDayMoney + lastDayMoney) * dayNumber / 2);
    return weekMoney + dayMoney;
};
```

**复杂度分析**

- 时间复杂度：$O(1)$。只需要用到常数时间。

- 空间复杂度：$O(1)$。只需要用到常数空间。
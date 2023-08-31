## [1154.一年中的第几天 中文官方题解](https://leetcode.cn/problems/day-of-the-year/solutions/100000/yi-nian-zhong-de-di-ji-tian-by-leetcode-2i0gr)
#### 方法一：直接计算

**思路与算法**

我们首先从给定的字符串 $\textit{date}$ 中提取出年 $\textit{year}$，月 $\textit{month}$ 以及日 $\textit{day}$。

这样一来，我们就可以首先统计到 $\textit{month}$ 的前一个月为止的天数。这一部分只需要使用一个长度为 $12$ 的数组，预先记录每一个月的天数，再进行累加即可。随后我们将答案再加上 $\textit{day}$，就可以得到 $\textit{date}$ 是一年中的第几天。

需要注意的是，如果 $\textit{year}$ 是闰年，那么二月份会多出一天。闰年的判定方法为：$\textit{year}$ 是 $400$ 的倍数，或者 $\textit{year}$ 是 $4$ 的倍数且不是 $100$ 的倍数。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    int dayOfYear(string date) {
        int year = stoi(date.substr(0, 4));
        int month = stoi(date.substr(5, 2));
        int day = stoi(date.substr(8, 2));

        int amount[] = {31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31};
        if (year % 400 == 0 || (year % 4 == 0 && year % 100 != 0)) {
            ++amount[1];
        }

        int ans = 0;
        for (int i = 0; i < month - 1; ++i) {
            ans += amount[i];
        }
        return ans + day;
    }
};
```

```Java [sol1-Java]
class Solution {
    public int dayOfYear(String date) {
        int year = Integer.parseInt(date.substring(0, 4));
        int month = Integer.parseInt(date.substring(5, 7));
        int day = Integer.parseInt(date.substring(8));

        int[] amount = {31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31};
        if (year % 400 == 0 || (year % 4 == 0 && year % 100 != 0)) {
            ++amount[1];
        }

        int ans = 0;
        for (int i = 0; i < month - 1; ++i) {
            ans += amount[i];
        }
        return ans + day;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int DayOfYear(string date) {
        int year = int.Parse(date.Substring(0, 4));
        int month = int.Parse(date.Substring(5, 2));
        int day = int.Parse(date.Substring(8));

        int[] amount = {31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31};
        if (year % 400 == 0 || (year % 4 == 0 && year % 100 != 0)) {
            ++amount[1];
        }

        int ans = 0;
        for (int i = 0; i < month - 1; ++i) {
            ans += amount[i];
        }
        return ans + day;
    }
}
```

```Python [sol1-Python3]
class Solution:
    def dayOfYear(self, date: str) -> int:
        year, month, day = [int(x) for x in date.split("-")]

        amount = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
        if year % 400 == 0 or (year % 4 == 0 and year % 100 != 0):
            amount[1] += 1

        ans = sum(amount[:month - 1])
        return ans + day
```

```C [sol1-C]
int dayOfYear(char * date){
    int year = atoi(date);
    int month = atoi(date + 5);
    int day = atoi(date + 8);
    int amount[12] = {31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31};
    if (year % 400 == 0 || (year % 4 == 0 && year % 100 != 0)) {
        ++amount[1];
    }
    int ans = 0;
    for (int i = 0; i < month - 1; ++i) {
        ans += amount[i];
    }
    return ans + day;
}
```

```go [sol1-Golang]
func dayOfYear(date string) int {
    year, _ := strconv.Atoi(date[:4])
    month, _ := strconv.Atoi(date[5:7])
    day, _ := strconv.Atoi(date[8:])

    days := []int{31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31}
    if year%400 == 0 || (year%4 == 0 && year%100 != 0) {
        days[1]++
    }

    ans := day
    for _, d := range days[:month-1] {
        ans += d
    }
    return ans
}
```

```JavaScript [sol1-JavaScript]
var dayOfYear = function(date) {
    const year = +date.slice(0, 4);
    const month = +date.slice(5, 7);
    const day = +date.slice(8);

    const amount = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
    if (year % 400 === 0 || (year % 4 === 0 && year % 100 !== 0)) {
        ++amount[1];
    }

    let ans = 0;
    for (let i = 0; i < month - 1; ++i) {
        ans += amount[i];
    }
    return ans + day;
};
```

**复杂度分析**

- 时间复杂度：$O(1)$。我们将字符串的长度（定值 $7$）以及一年的月份数 $12$ 视为常数。

- 空间复杂度：$O(1)$。
## [1185.一周中的第几天 中文官方题解](https://leetcode.cn/problems/day-of-the-week/solutions/100000/yi-zhou-zhong-de-di-ji-tian-by-leetcode-w43iw)
#### 方法一：模拟

**思路及解法**

题目规定输入的日期一定是在 $1971$ 到 $2100$ 年之间的有效日期，即在 $1971$ 年 $1$ 月 $1$ 日，到 $2100$ 年 $12$ 月 $31$ 日之间。通过查询日历可知，$1970$ 年 $12$ 月 $31$ 日是星期四，我们只需要算出输入的日期距离 $1970$ 年 $12$ 月 $31$ 日有几天，再加上 $3$ 后对 $7$ 求余，即可得到输入日期是一周中的第几天。

求输入的日期距离 $1970$ 年 $12$ 月 $31$ 日的天数，可以分为三部分分别计算后求和：

（1）输入年份之前的年份的天数贡献；
（2）输入年份中，输入月份之前的月份的天数贡献；
（3）输入月份中的天数贡献。

例如，如果输入是 $2100$ 年 $12$ 月 $31$ 日，即可分为三部分分别计算后求和：

（1）$1971$ 年 $1$ 月 $1$ 到 $2099$ 年 $12$ 月 $31$ 日之间所有的天数；
（2）$2100$ 年 $1$ 月 $1$ 日到 $2100$ 年 $11$ 月 $31$ 日之间所有的天数；
（3）$2100$ 年 $12$ 月 $1$ 日到 $2100$ 年 $12$ 月 $31$ 日之间所有的天数。

其中（1）和（2）部分的计算需要考虑到闰年的影响。当年份是 $400$ 的倍数或者是 $4$ 的倍数且不是 $100$ 的倍数时，该年会在二月份多出一天。

**代码**

```Python [sol1-Python3]
class Solution:
    def dayOfTheWeek(self, day: int, month: int, year: int) -> str:
        week = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
        monthDays = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30]
        days = 0
        # 输入年份之前的年份的天数贡献
        days += 365 * (year - 1971) + (year - 1969) // 4
        # 输入年份中，输入月份之前的月份的天数贡献
        days += sum(monthDays[:month-1])
        if (year % 400 == 0 or (year % 4 == 0 and year % 100 != 0)) and month >= 3:
            days += 1
        # 输入月份中的天数贡献
        days += day

        return week[(days + 3) % 7]
```

```C++ [sol1-C++]
class Solution {
public:
    string dayOfTheWeek(int day, int month, int year) {
        vector<string> week = {"Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"};
        vector<int> monthDays = {31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30};
        /* 输入年份之前的年份的天数贡献 */
        int days = 365 * (year - 1971) + (year - 1969) / 4;
        /* 输入年份中，输入月份之前的月份的天数贡献 */
        for (int i = 0; i < month - 1; ++i) {
            days += monthDays[i];
        }
        if ((year % 400 == 0 || (year % 4 == 0 && year % 100 != 0)) && month >= 3) {
            days += 1;
        }
        /* 输入月份中的天数贡献 */
        days += day;
        return week[(days + 3) % 7];
    }
};
```

```Java [sol1-Java]
class Solution {
    public String dayOfTheWeek(int day, int month, int year) {
        String[] week = {"Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"};
        int[] monthDays = {31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30};
        /* 输入年份之前的年份的天数贡献 */
        int days = 365 * (year - 1971) + (year - 1969) / 4;
        /* 输入年份中，输入月份之前的月份的天数贡献 */
        for (int i = 0; i < month - 1; ++i) {
            days += monthDays[i];
        }
        if ((year % 400 == 0 || (year % 4 == 0 && year % 100 != 0)) && month >= 3) {
            days += 1;
        }
        /* 输入月份中的天数贡献 */
        days += day;
        return week[(days + 3) % 7];
    }
}
```

```C# [sol1-C#]
public class Solution {
    public string DayOfTheWeek(int day, int month, int year) {
        string[] week = {"Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"};
        int[] monthDays = {31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30};
        /* 输入年份之前的年份的天数贡献 */
        int days = 365 * (year - 1971) + (year - 1969) / 4;
        /* 输入年份中，输入月份之前的月份的天数贡献 */
        for (int i = 0; i < month - 1; ++i) {
            days += monthDays[i];
        }
        if ((year % 400 == 0 || (year % 4 == 0 && year % 100 != 0)) && month >= 3) {
            days += 1;
        }
        /* 输入月份中的天数贡献 */
        days += day;
        return week[(days + 3) % 7];
    }
}
```

```C [sol1-C]
char * dayOfTheWeek(int day, int month, int year){
    char * week[7] = {"Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"};
    int monthDays[12] = {31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30};
    /* 输入年份之前的年份的天数贡献 */
    int days = 365 * (year - 1971) + (year - 1969) / 4;
    /* 输入年份中，输入月份之前的月份的天数贡献 */
    for (int i = 0; i < month - 1; ++i) {
        days += monthDays[i];
    }
    if ((year % 400 == 0 || (year % 4 == 0 && year % 100 != 0)) && month >= 3) {
        days += 1;
    }
    /* 输入月份中的天数贡献 */
    days += day;
    return week[(days + 3) % 7];
}
```

```JavaScript [sol1-JavaScript]
var dayOfTheWeek = function(day, month, year) {
    const week = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"];
    const monthDays = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30];
    /* 输入年份之前的年份的天数贡献 */
    let days = 365 * (year - 1971) + Math.floor((year - 1969) / 4);
    /* 输入年份中，输入月份之前的月份的天数贡献 */
    for (let i = 0; i < month - 1; ++i) {
        days += monthDays[i];
    }
    if ((year % 400 === 0 || (year % 4 === 0 && year % 100 !== 0)) && month >= 3) {
        days += 1;
    }
    /* 输入月份中的天数贡献 */
    days += day;
    return week[(days + 3) % 7];
};
```

```go [sol1-Golang]
var week = []string{"Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"}
var monthDays = []int{31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30}

func dayOfTheWeek(day, month, year int) string {
    days := 0
    // 输入年份之前的年份的天数贡献
    days += 365*(year-1971) + (year-1969)/4
    // 输入年份中，输入月份之前的月份的天数贡献
    for _, d := range monthDays[:month-1] {
        days += d
    }
    if month >= 3 && (year%400 == 0 || year%4 == 0 && year%100 != 0) {
        days++
    }
    // 输入月份中的天数贡献
    days += day
    return week[(days+3)%7]
}
```

**复杂度分析**

- 时间复杂度：$O(C)$，其中 $C$ 为一年中的月份数 $12$。仅需常量时间的数学计算。

- 空间复杂度：$O(C)$，其中 $C$ 为一年中的月份数 $12$。仅需常量空间的数组。
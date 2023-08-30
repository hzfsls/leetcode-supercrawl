#### 方法一：将日期转化为为整数（暴力）

由于题目中的日期不会早于 1971 年，我们可以将两个日期转化为距离 1971 年 1 月 1 日的天数。这一转化过程可以直接暴力求解：从当前日期开始，一天一天递减，直到 1971 年 1 月 1 日为止。

```python []
class Solution:
    def leap_year(self, year):
        return (year % 400 == 0) or (year % 100 != 0 and year % 4 == 0)

    def date_to_int(self, year, month, day):
        ans = 0
        month_length = [31, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30]
        while year != 1971 or month != 1 or day != 1:
            ans += 1
            day -= 1
            if day == 0:
                month -= 1
                day = month_length[month]
                if month == 2 and self.leap_year(year):
                    day += 1
            if month == 0:
                year -= 1
                month = 12
        return ans
            
    def daysBetweenDates(self, date1: str, date2: str) -> int:
        date1 = [int(i) for i in date1.split('-')]
        date2 = [int(i) for i in date2.split('-')]
        return abs(self.date_to_int(*date1) - self.date_to_int(*date2))

```

```C++ []
class Solution {
    bool leap_year(int year) {
         return ((year % 400 == 0) || (year % 100 != 0 && year % 4 == 0));
    }
    int date_to_int(string date) {
        int year, month, day;
        sscanf(date.c_str(), "%d-%d-%d", &year, &month, &day);
        int month_length[] = {31, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30};
        int ans = 0;
        while (year != 1971 or month != 1 or day != 1) {
            ++ans;
            if (--day == 0)
                if (--month == 0)
                    --year;
            if (day == 0) {
                day = month_length[month];
                if (month == 2 && leap_year(year))
                    ++day;
            }
            if (month == 0)
                month = 12;
        }
        return ans;
    }
public:
    int daysBetweenDates(string date1, string date2) {
        return abs(date_to_int(date1) - date_to_int(date2));
    }
};
```

##### 复杂度分析

  * 时间复杂度：$O(n)$，$n$ 为输入日期到 1971 年的天数。
  * 空间复杂度：$O(1)$

#### 方法二：优化日期转化过程

日期一天一天递减效率不高。可以先按日，月，年的顺序依次直接转化为 1 日，1 月，1971 年，经过的天数可以直接计算得到。其中年份部分由于有闰年的因素，用 365 乘以年份之后，要再加上闰年的数量。闰年的数量不太好计算。我们采取以下策略：

    1. 先加上所有模 4 为 0 的年份的数量。此时有些模 100 为 0 的不是闰年的年份被加上了。
    2. 再减去所有模 100 为 0 的年份的数量。此时有些模 400 为 0 的是闰年的年份被减去了。
    3. 再加上所有模 400 为 0 的年份的数量。完成。

```python []
class Solution:
    def leap_year(self, year):
        return ((year % 400 == 0) or (year % 100 != 0 and year % 4 == 0))
    def date_to_int(self, year, month, day):
        month_length = [0, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
        ans = day - 1
        while month != 0:
            month -= 1
            ans += month_length[month]
            if month == 2 and self.leap_year(year):
                ans += 1
        ans += 365 * (year - 1971)
        ans += (year - 1) // 4 - 1971 // 4
        ans -= (year - 1) // 100 - 1971 // 100
        ans += (year - 1) // 400 - 1971 // 400
        return ans
            
    def daysBetweenDates(self, date1: str, date2: str) -> int:
        date1 = [int(i) for i in date1.split('-')]
        date2 = [int(i) for i in date2.split('-')]
        return abs(self.date_to_int(*date1) - self.date_to_int(*date2))

```

```C++ []
class Solution {
    bool leap_year(int year) {
         return ((year % 400 == 0) || (year % 100 != 0 && year % 4 == 0));
    }
    int date_to_int(string date) {
        int year, month, day;
        sscanf(date.c_str(), "%d-%d-%d", &year, &month, &day);
        int month_length[] = {0, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31};
        int ans = day - 1;
        while (month != 0) {
            --month;
            ans += month_length[month];
            if (month == 2 && leap_year(year))
                ans += 1;
        }
        ans += 365 * (year - 1971);
        ans += (year - 1) / 4 - 1971 / 4;
        ans -= (year - 1) / 100 - 1971 / 100;
        ans += (year - 1) / 400 - 1971 / 400;
        return ans;
    }
public:
    int daysBetweenDates(string date1, string date2) {
        return abs(date_to_int(date1) - date_to_int(date2));
    }
};
```

##### 复杂度分析

  * 时间复杂度：$O(1)$
  * 空间复杂度：$O(1)$
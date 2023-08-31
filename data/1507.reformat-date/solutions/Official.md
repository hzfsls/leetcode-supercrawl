## [1507.转变日期格式 中文官方题解](https://leetcode.cn/problems/reformat-date/solutions/100000/zhuan-bian-ri-qi-ge-shi-by-leetcode-solution)
#### 方法一：模拟

**思路与算法**

首先，我们可以按照空格把字符串分割成三部分，分别取出日、月、年。对于他们分别做这样的事情：

+ 日：去掉结尾的两位英文字母，如果数字只有一位再补上前导零
+ 月：使用字典映射的方式把月份的英文缩写转换成对应的数字
+ 年：不用变化

最终组织成「年-月-日」的形式即可。

代码如下。

**代码**

```python [sol1-Python3]
class Solution:
    def reformatDate(self, date: str) -> str:
        s2month = {
            "Jan": "01", "Feb": "02", "Mar": "03", "Apr": "04", "May": "05", "Jun": "06", 
            "Jul": "07", "Aug": "08", "Sep": "09", "Oct": "10", "Nov": "11", "Dec": "12"
        }
        
        date = date.split(" ")
        
        date[0] = date[0][: -2].zfill(2)
        date[1] = s2month.get(date[1])
        date.reverse()
        
        return "-".join(date)
```

```Java [sol1-Java]
class Solution {
    public String reformatDate(String date) {
        String[] months = {"Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"};
        Map<String, Integer> s2month = new HashMap<String, Integer>();
        for (int i = 1; i <= 12; i++) {
            s2month.put(months[i - 1], i);
        }
        String[] array = date.split(" ");
        int year = Integer.parseInt(array[2]);
        int month = s2month.get(array[1]);
        int day = Integer.parseInt(array[0].substring(0, array[0].length() - 2));
        return String.format("%d-%02d-%02d", year, month, day);
    }
}
```

```C++ [sol1-C++]
class Solution {
public:
    string reformatDate(string date) {
        unordered_map<string, string> s2month = {
            {"Jan", "01"},
            {"Feb", "02"},
            {"Mar", "03"},
            {"Apr", "04"},
            {"May", "05"},
            {"Jun", "06"},
            {"Jul", "07"},
            {"Aug", "08"},
            {"Sep", "09"},
            {"Oct", "10"},
            {"Nov", "11"},
            {"Dec", "12"}
        };

        stringstream ss(date);
        string year, month, day;
        ss >> day >> month >> year;
        month = s2month[month];
        day.pop_back();
        day.pop_back();
        if (day.size() == 1) {
            day = "0" + day;
        }
        return year + "-" + month + "-" + day;
    }
};
```

**复杂度分析**

+ 时间复杂度：$O(1)$。
+ 空间复杂度：$O(1)$。
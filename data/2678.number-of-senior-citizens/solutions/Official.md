#### 方法一：枚举

**思路与算法**

因为每一条信息中的第 $12$ 个和第 $13$ 个字符对应乘客的年龄信息，所以我们可以枚举每一位乘客的信息，判断其年龄是否严格大于 $60$。

**代码**

```Python [sol1-Python3]
class Solution:
    def countSeniors(self, details: List[str]) -> int:
        return sum(1 for info in details if int(info[11:13]) > 60)
```

```Java [sol1-Java]
class Solution {
    public int countSeniors(String[] details) {
        int count = 0;
        for (String info : details) {
            if (Integer.parseInt(info.substring(11, 13)) > 60) {
                count++;
            }
        }
        return count;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int CountSeniors(string[] details) {
        int count = 0;
        foreach (string info in details) {
            if (int.Parse(info.Substring(11, 2)) > 60) {
                count++;
            }
        }
        return count;
    }
}
```

```C++ [sol1-C++]
class Solution {
public:
    int countSeniors(vector<string>& details) {
        int count = 0;
        for (string & info : details) {
            if (stoi(info.substr(11, 2)) > 60) {
                count++;
            }
        }
        return count;
    }
};
```

```C [sol1-C]
int countSeniors(char ** details, int detailsSize) {
    int count = 0;
    for (int i = 0; i < detailsSize; i++) {
        int age = (details[i][11] - '0') * 10 + details[i][12] - '0';
        if (age > 60) {
            count++;
        }
    }
    return count;
}
```

```Go [sol1-Go]
func countSeniors(details []string) int {
    count := 0
    for i := 0; i < len(details); i++ {
        age, _ := strconv.Atoi(details[i][11:13])
        if (age > 60) {
            count++
        }
    }
    return count
}
```

```JavaScript [sol1-JavaScript]
var countSeniors = function(details) {
    let count = 0;
    for (let i = 0; i < details.length; i++) {
        if (parseInt(details[i].substring(11, 13)) > 60) {
            count++;
        }
    }
    return count;
};
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 为数组 $\textit{details}$ 的长度。
- 空间复杂度：$O(1)$。仅使用常量空间。
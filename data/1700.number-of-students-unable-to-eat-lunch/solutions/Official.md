## [1700.无法吃午餐的学生数量 中文官方题解](https://leetcode.cn/problems/number-of-students-unable-to-eat-lunch/solutions/100000/wu-fa-chi-wu-can-de-xue-sheng-shu-liang-fv3f5)
#### 方法一：模拟

假设喜欢吃圆形三明治的学生数量为 $s_0$，喜欢吃方形三明治的学生数量为 $s_1$。根据题意，我们可以知道栈顶的三明治能否被拿走取决于队列剩余的学生中是否有喜欢它的，因此学生在队列的相对位置不影响整个过程，我们只需要记录队列剩余的学生中 $s_0$ 和 $s_1$ 的值。我们对整个过程进行模拟，如果栈顶的元素为 $0$ 并且 $s_0 \gt 0$，我们将 $s_0$ 减 $1$；如果栈顶的元素为 $1$ 并且 $s_1 \gt 0$，我们将 $s_1$ 减 $1$；否则终止过程，并返回 $s_0 + s_1$。

```Python [sol1-Python3]
class Solution:
    def countStudents(self, students: List[int], sandwiches: List[int]) -> int:
        s1 = sum(students)
        s0 = len(students) - s1
        for x in sandwiches:
            if x == 0 and s0:
                s0 -= 1
            elif x == 1 and s1:
                s1 -= 1
            else:
                break
        return s0 + s1
```

```C++ [sol1-C++]
class Solution {
public:
    int countStudents(vector<int>& students, vector<int>& sandwiches) {
        int s1 = accumulate(students.begin(), students.end(), 0);
        int s0 = students.size() - s1;
        for (int i = 0; i < sandwiches.size(); i++) {
            if (sandwiches[i] == 0 && s0 > 0) {
                s0--;
            } else if (sandwiches[i] == 1 && s1 > 0) {
                s1--;
            } else {
                break;
            }
        }
        return s0 + s1;
    }
};
```

```Java [sol1-Java]
class Solution {
    public int countStudents(int[] students, int[] sandwiches) {
        int s1 = Arrays.stream(students).sum();
        int s0 = students.length - s1;
        for (int i = 0; i < sandwiches.length; i++) {
            if (sandwiches[i] == 0 && s0 > 0) {
                s0--;
            } else if (sandwiches[i] == 1 && s1 > 0) {
                s1--;
            } else {
                break;
            }
        }
        return s0 + s1;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int CountStudents(int[] students, int[] sandwiches) {
        int s1 = students.Sum();
        int s0 = students.Length - s1;
        for (int i = 0; i < sandwiches.Length; i++) {
            if (sandwiches[i] == 0 && s0 > 0) {
                s0--;
            } else if (sandwiches[i] == 1 && s1 > 0) {
                s1--;
            } else {
                break;
            }
        }
        return s0 + s1;
    }
}
```

```C [sol1-C]
int countStudents(int* students, int studentsSize, int* sandwiches, int sandwichesSize) {
    int s1 = 0;
    for (int i = 0; i < studentsSize; i++) {
        s1 += students[i];
    }
    int s0 = studentsSize - s1;
    for (int i = 0; i < sandwichesSize; i++) {
        if (sandwiches[i] == 0 && s0 > 0) {
            s0--;
        } else if (sandwiches[i] == 1 && s1 > 0) {
            s1--;
        } else {
            break;
        }
    }
    return s0 + s1;
}
```

```JavaScript [sol1-JavaScript]
var countStudents = function(students, sandwiches) {
    let s1 = _.sum(students);
    let s0 = students.length - s1;
    for (let i = 0; i < sandwiches.length; i++) {
        if (sandwiches[i] === 0 && s0 > 0) {
            s0--;
        } else if (sandwiches[i] === 1 && s1 > 0) {
            s1--;
        } else {
            break;
        }
    }
    return s0 + s1;
};
```

```go [sol1-Golang]
func countStudents(students, sandwiches []int) int {
    s1 := 0
    for _, v := range students {
        s1 += v
    }
    s0 := len(students) - s1
    for _, x := range sandwiches {
        if x == 0 && s0 > 0 {
            s0--
        } else if x == 1 && s1 > 0 {
            s1--
        } else {
            break
        }
    }
    return s0 + s1
}
```

**复杂度分析**

+ 时间复杂度：$O(n)$，其中 $n$ 是学生的数量。

+ 空间复杂度：$O(1)$。
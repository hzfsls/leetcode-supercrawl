## [2037.使每位学生都有座位的最少移动次数 中文官方题解](https://leetcode.cn/problems/minimum-number-of-moves-to-seat-everyone/solutions/100000/shi-mei-wei-xue-sheng-du-you-zuo-wei-de-oll4i)
#### 方法一：排序

**思路与算法**

一个房间共有 $n$ 个学生和 $n$ 个座位，每个学生对应一个座位。将学生和座位的位置分别排序后，第 $i$ 个学生对应第 $i$ 个座位，即第 $i$ 个学生需要挪动的距离是 $|\textit{students}_i - \textit{seats}_i|$。由于在任何情况下，交换两个学生的对应座位并不会使得答案更优，所以对所有学生需要挪动的距离求和就是答案。

**代码**

```Python [sol1-Python3]
class Solution:
    def minMovesToSeat(self, seats: List[int], students: List[int]) -> int:
        seats.sort()
        students.sort()
        return sum(abs(x - y) for x, y in zip(seats, students))
```

```C++ [sol1-C++]
class Solution {
public:
    int minMovesToSeat(vector<int>& seats, vector<int>& students) {
        sort(seats.begin(), seats.end());
        sort(students.begin(), students.end());
        int res = 0;
        for (int i = 0; i < seats.size(); i++) {
            res += abs(seats[i] - students[i]);
        }
        return res;
    }
};
```

```Java [sol1-Java]
class Solution {
    public int minMovesToSeat(int[] seats, int[] students) {
        Arrays.sort(seats);
        Arrays.sort(students);
        int res = 0;
        for (int i = 0; i < seats.length; i++) {
            res += Math.abs(seats[i] - students[i]);
        }
        return res;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int MinMovesToSeat(int[] seats, int[] students) {
        Array.Sort(seats);
        Array.Sort(students);
        int res = 0;
        for (int i = 0; i < seats.Length; i++) {
            res += Math.Abs(seats[i] - students[i]);
        }
        return res;
    }
}
```

```C [sol1-C]
static int cmp(const void *pa, const void *pb) {
    return *(int *)pa - *(int *)pb;
}

int minMovesToSeat(int* seats, int seatsSize, int* students, int studentsSize) {
    qsort(seats, seatsSize, sizeof(int), cmp);
    qsort(students, studentsSize, sizeof(int), cmp);
    int res = 0;
    for (int i = 0; i < seatsSize; i++) {
        res += abs(seats[i] - students[i]);
    }
    return res;
}
```

```JavaScript [sol1-JavaScript]
var minMovesToSeat = function(seats, students) {
    seats.sort((a, b) => a - b);
    students.sort((a, b) => a - b);
    let res = 0;
    for (let i = 0; i < seats.length; i++) {
        res += Math.abs(seats[i] - students[i]);
    }
    return res;
};
```

```go [sol1-Golang]
func minMovesToSeat(seats, students []int) (ans int) {
	sort.Ints(seats)
	sort.Ints(students)
	for i, x := range seats {
		ans += abs(x - students[i])
	}
	return
}

func abs(x int) int {
	if x < 0 {
		return -x
	}
	return x
}
```

**复杂度分析**

- 时间复杂度：$O(n \log n)$，其中 $n$ 是学生和座位的数量。过程中分别对 $\textit{students}$ 和 $\textit{seats}$ 排序，时间复杂度为 $O(n \log n)$。然后遍历数组求和，时间复杂度为 $O(n)$。所以总体复杂度为 $O(n \log n)$。

- 空间复杂度：$O(\log n)$，其中 $n$ 是学生和座位的数量。排序需要 $O(\log n)$ 的递归调用栈空间。
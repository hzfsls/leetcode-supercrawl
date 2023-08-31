## [881.救生艇 中文官方题解](https://leetcode.cn/problems/boats-to-save-people/solutions/100000/jiu-sheng-ting-by-leetcode-solution-0nsp)
#### 方法一：贪心

要使需要的船数尽可能地少，应当使载两人的船尽可能地多。

设 $\textit{people}$ 的长度为 $n$。考虑体重最轻的人：

- 若他不能与体重最重的人同乘一艘船，那么体重最重的人无法与任何人同乘一艘船，此时应单独分配一艘船给体重最重的人。从 $\textit{people}$ 中去掉体重最重的人后，我们缩小了问题的规模，变成求解剩余 $n-1$ 个人所需的最小船数，将其加一即为原问题的答案。
- 若他能与体重最重的人同乘一艘船，那么他能与其余任何人同乘一艘船，为了尽可能地利用船的承载重量，选择与体重最重的人同乘一艘船是最优的。从 $\textit{people}$ 中去掉体重最轻和体重最重的人后，我们缩小了问题的规模，变成求解剩余 $n-2$ 个人所需的最小船数，将其加一即为原问题的答案。

在代码实现时，我们可以先对 $\textit{people}$ 排序，然后用两个指针分别指向体重最轻和体重最重的人，按照上述规则来移动指针，并统计答案。

```Python [sol1-Python3]
class Solution:
    def numRescueBoats(self, people: List[int], limit: int) -> int:
        ans = 0
        people.sort()
        light, heavy = 0, len(people) - 1
        while light <= heavy:
            if people[light] + people[heavy] > limit:
                heavy -= 1
            else:
                light += 1
                heavy -= 1
            ans += 1
        return ans
```

```C++ [sol1-C++]
class Solution {
public:
    int numRescueBoats(vector<int> &people, int limit) {
        int ans = 0;
        sort(people.begin(), people.end());
        int light = 0, heavy = people.size() - 1;
        while (light <= heavy) {
            if (people[light] + people[heavy] > limit) {
                --heavy;
            } else {
                ++light;
                --heavy;
            }
            ++ans;
        }
        return ans;
    }
};
```

```Java [sol1-Java]
class Solution {
    public int numRescueBoats(int[] people, int limit) {
        int ans = 0;
        Arrays.sort(people);
        int light = 0, heavy = people.length - 1;
        while (light <= heavy) {
            if (people[light] + people[heavy] <= limit) {
                ++light;
            }
            --heavy;
            ++ans;
        }
        return ans;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int NumRescueBoats(int[] people, int limit) {
        int ans = 0;
        Array.Sort(people);
        int light = 0, heavy = people.Length - 1;
        while (light <= heavy) {
            if (people[light] + people[heavy] <= limit) {
                ++light;
            }
            --heavy;
            ++ans;
        }
        return ans;
    }
}
```

```go [sol1-Golang]
func numRescueBoats(people []int, limit int) (ans int) {
    sort.Ints(people)
    light, heavy := 0, len(people)-1
    for light <= heavy {
        if people[light]+people[heavy] > limit {
            heavy--
        } else {
            light++
            heavy--
        }
        ans++
    }
    return
}
```

```C [sol1-C]
int cmp(int *a, int *b) {
    return *a - *b;
}

int numRescueBoats(int *people, int peopleSize, int limit) {
    int ans = 0;
    qsort(people, peopleSize, sizeof(int), cmp);
    int light = 0, heavy = peopleSize - 1;
    while (light <= heavy) {
        if (people[light] + people[heavy] > limit) {
            --heavy;
        } else {
            ++light;
            --heavy;
        }
        ++ans;
    }
    return ans;
}
```

```JavaScript [sol1-JavaScript]
var numRescueBoats = function(people, limit) {
    let ans = 0;
    people.sort((a, b) => a - b);
    let light = 0, heavy = people.length - 1;
    while (light <= heavy) {
        if (people[light] + people[heavy] <= limit) {
            ++light;
        }
        --heavy;
        ++ans;
    }
    return ans;
};
```

**复杂度分析**

- 时间复杂度：$O(n\log n)$，其中 $n$ 是数组 $\textit{people}$ 的长度。算法的时间开销主要在排序上。

- 空间复杂度：$O(\log n)$，排序所需额外的空间复杂度为 $O(\log n)$。
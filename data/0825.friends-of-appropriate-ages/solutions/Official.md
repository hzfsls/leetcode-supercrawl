## [825.适龄的朋友 中文官方题解](https://leetcode.cn/problems/friends-of-appropriate-ages/solutions/100000/gua-ling-de-peng-you-by-leetcode-solutio-v7yk)

#### 方法一：排序 + 双指针

**思路与算法**

观察题目中给定的三个条件：

1. $\textit{ages}[y] \leq 0.5 \times \textit{ages}[x] + 7$

2. $\textit{ages}[y] > \textit{ages}[x]$

3. $\textit{ages}[y] > 100 \wedge \textit{ages}[x] < 100$

可以发现，条件 $3$ 是蕴含在条件 $2$ 中的，即如果满足条件 $3$ 那么一定满足条件 $2$。因此，我们当条件 $1$ 和 $2$ 均不满足时，用户 $x$ 就会向用户 $y$ 发送好友请求，也就是用户 $y$ 需要满足：

$$
0.5 \times \textit{ages}[x] + 7 < \textit{ages}[y] \leq \textit{ages}[x]
$$

当 $\textit{ages}[x] \leq 14$ 时，不存在满足要求的 $\textit{ages}[y]$。因此我们只需要考虑 $\textit{ages}[x] \geq 15$ 的情况，此时满足要求的 $\textit{ages}[y]$ 的范围为 $\big( 0.5 \times \textit{ages}[x] + 7, \textit{ages}[x] \big]$。

当 $\textit{ages}[x]$ 增加时，上述区间的左右边界均单调递增，因此如果我们将数组 $\textit{ages}$ 进行升序排序，那么就可以在遍历 $\textit{ages}[x]$ 的同时，使用两个指针 $\textit{left}$ 和 $\textit{right}$ 维护满足要求的 $\textit{ages}[y]$ 的左右边界。当 $x$ 向后移动一个位置时：

- 如果左边界指针 $\textit{left}$ 指向的元素不满足 $\textit{ages}[\textit{left}] > 0.5 \times \textit{ages}[x] + 7$，那么就将左边界向后移动一个位置；

- 如果右边界指针 $\textit{right}$ 指向的下一个元素满足 $\textit{ages}[\textit{right} + 1] \leq \textit{ages}[x]$，那么就将右边界向后移动一个位置。

这样一来，$[\textit{left}, \textit{right}]$ 就是满足年龄要求的 $y$ 的下标。需要注意的是，$x$ 本身一定在 $[\textit{left}, \textit{right}]$ 区间内，因此 $x$ 发送的好友请求数，即为 $[\textit{left}, \textit{right}]$ 区间的长度减去 $1$。

我们将每一个 $x$ 对应的 $[\textit{left}, \textit{right}]$ 区间长度减去 $1$ 进行累加，就可以得到最终的答案。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    int numFriendRequests(vector<int>& ages) {
        int n = ages.size();
        sort(ages.begin(), ages.end());
        int left = 0, right = 0, ans = 0;
        for (int age: ages) {
            if (age < 15) {
                continue;
            }
            while (ages[left] <= 0.5 * age + 7) {
                ++left;
            }
            while (right + 1 < n && ages[right + 1] <= age) {
                ++right;
            }
            ans += right - left;
        }
        return ans;
    }
};
```

```Java [sol1-Java]
class Solution {
    public int numFriendRequests(int[] ages) {
        int n = ages.length;
        Arrays.sort(ages);
        int left = 0, right = 0, ans = 0;
        for (int age : ages) {
            if (age < 15) {
                continue;
            }
            while (ages[left] <= 0.5 * age + 7) {
                ++left;
            }
            while (right + 1 < n && ages[right + 1] <= age) {
                ++right;
            }
            ans += right - left;
        }
        return ans;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int NumFriendRequests(int[] ages) {
        int n = ages.Length;
        Array.Sort(ages);
        int left = 0, right = 0, ans = 0;
        foreach (int age in ages) {
            if (age < 15) {
                continue;
            }
            while (ages[left] <= 0.5 * age + 7) {
                ++left;
            }
            while (right + 1 < n && ages[right + 1] <= age) {
                ++right;
            }
            ans += right - left;
        }
        return ans;
    }
}
```

```Python [sol1-Python3]
class Solution:
    def numFriendRequests(self, ages: List[int]) -> int:
        n = len(ages)
        ages.sort()
        left = right = ans = 0
        for age in ages:
            if age < 15:
                continue
            while ages[left] <= 0.5 * age + 7:
                left += 1
            while right + 1 < n and ages[right + 1] <= age:
                right += 1
            ans += right - left
        return ans
```

```go [sol1-Golang]
func numFriendRequests(ages []int) (ans int) {
    sort.Ints(ages)
    left, right := 0, 0
    for _, age := range ages {
        if age < 15 {
            continue
        }
        for ages[left]*2 <= age+14 {
            left++
        }
        for right+1 < len(ages) && ages[right+1] <= age {
            right++
        }
        ans += right - left
    }
    return
}
```

```C [sol1-C]
static int cmp(const void * pa, const void * pb) {
    return *(int *)pa - *(int *)pb;
}

int numFriendRequests(int* ages, int agesSize){
    qsort(ages, agesSize, sizeof(int), cmp);
    int left = 0, right = 0, ans = 0;
    for (int i = 0; i < agesSize; ++i) {
        if (ages[i] < 15) {
            continue;
        }
        while (ages[left] <= 0.5 * ages[i] + 7) {
            ++left;
        }
        while (right + 1 < agesSize && ages[right + 1] <= ages[i]) {
            ++right;
        }
        ans += right - left;
    }
    return ans;
}
```

```JavaScript [sol1-JavaScript]
var numFriendRequests = function(ages) {
    const n = ages.length;
    ages.sort((a, b) => a - b);
    let left = 0, right = 0, ans = 0;
    for (const age of ages) {
        if (age < 15) {
            continue;
        }
        while (ages[left] <= 0.5 * age + 7) {
            ++left;
        }
        while (right + 1 < n && ages[right + 1] <= age) {
            ++right;
        }
        ans += right - left;
    }
    return ans;
};
```

**复杂度分析**

- 时间复杂度：$O(n \log n)$。排序需要的时间为 $O(n \log n)$，遍历所有的 $\textit{ages}[x]$ 以及使用双指针维护答案区间的时间复杂度为 $O(n)$。

- 空间复杂度：$O(\log n)$，即为排序需要使用的栈空间。

#### 方法二：计数排序 + 前缀和

**思路与算法**

注意到题目中给定的年龄在 $[1, 120]$ 的范围内，因此我们可以使用计数排序代替普通的排序。

记 $\textit{cnt}[\textit{age}]$ 表示年龄为 $\textit{age}$ 的用户数，那么每一个年龄为 $\textit{age}~(\textit{age} \geq 15)$ 的用户发送好友的请求数量即为：

$$
\left( \sum_{i=\lfloor 0.5 \times \textit{age} + 8 \rfloor}^\textit{age} \textit{cnt}[i] \right) - 1
$$

这里的 $\lfloor \cdot \rfloor$ 表示向下取整，$-1$ 表示减去自身，与方法一相同。

为了快速计算上式，我们可以使用数组 $\textit{pre}$ 存储数组 $\textit{cnt}$ 的前缀和，即：

$$
\textit{pre}[\textit{age}] = \sum_{i=1}^\textit{age} \textit{cnt}[i]
$$

这样一来，上式就可以简化为：

$$
(\textit{pre}[\textit{age}] - \textit{pre}[\lfloor 0.5 \times \textit{age} + 7 \rfloor]) - 1
$$

我们就可以在 $O(1)$ 的时间内计算出一个年龄为 $\textit{age}$ 的用户发送好友的请求数量，将其乘以 $\textit{cnt}[\textit{age}]$ 并累加就可以得到最终的答案。

**代码**

```C++ [sol2-C++]
class Solution {
public:
    int numFriendRequests(vector<int>& ages) {
        vector<int> cnt(121);
        for (int age: ages) {
            ++cnt[age];
        }
        vector<int> pre(121);
        for (int i = 1; i <= 120; ++i) {
            pre[i] = pre[i - 1] + cnt[i];
        }
        int ans = 0;
        for (int i = 15; i <= 120; ++i) {
            if (cnt[i]) {
                int bound = i * 0.5 + 8;
                ans += cnt[i] * (pre[i] - pre[bound - 1] - 1);
            }
        }
        return ans;
    }
};
```

```Java [sol2-Java]
class Solution {
    public int numFriendRequests(int[] ages) {
        int[] cnt = new int[121];
        for (int age : ages) {
            ++cnt[age];
        }
        int[] pre = new int[121];
        for (int i = 1; i <= 120; ++i) {
            pre[i] = pre[i - 1] + cnt[i];
        }
        int ans = 0;
        for (int i = 15; i <= 120; ++i) {
            if (cnt[i] > 0) {
                int bound = (int) (i * 0.5 + 8);
                ans += cnt[i] * (pre[i] - pre[bound - 1] - 1);
            }
        }
        return ans;
    }
}
```

```C# [sol2-C#]
public class Solution {
    public int NumFriendRequests(int[] ages) {
        int[] cnt = new int[121];
        foreach (int age in ages) {
            ++cnt[age];
        }
        int[] pre = new int[121];
        for (int i = 1; i <= 120; ++i) {
            pre[i] = pre[i - 1] + cnt[i];
        }
        int ans = 0;
        for (int i = 15; i <= 120; ++i) {
            if (cnt[i] > 0) {
                int bound = (int) (i * 0.5 + 8);
                ans += cnt[i] * (pre[i] - pre[bound - 1] - 1);
            }
        }
        return ans;
    }
}
```

```Python [sol2-Python3]
class Solution:
    def numFriendRequests(self, ages: List[int]) -> int:
        cnt = [0] * 121
        for age in ages:
            cnt[age] += 1
        pre = [0] * 121
        for i in range(1, 121):
            pre[i] = pre[i - 1] + cnt[i]
        
        ans = 0
        for i in range(15, 121):
            if cnt[i] > 0:
                bound = int(i * 0.5 + 8)
                ans += cnt[i] * (pre[i] - pre[bound - 1] - 1)
        return ans
```

```go [sol2-Golang]
func numFriendRequests(ages []int) (ans int) {
    const mx = 121
    var cnt, pre [mx]int
    for _, age := range ages {
        cnt[age]++
    }
    for i := 1; i < mx; i++ {
        pre[i] = pre[i-1] + cnt[i]
    }
    for i := 15; i < mx; i++ {
        if cnt[i] > 0 {
            bound := i/2 + 8
            ans += cnt[i] * (pre[i] - pre[bound-1] - 1)
        }
    }
    return
}
```

```C [sol2-C]
int numFriendRequests(int* ages, int agesSize){
    int * cnt = (int *)malloc(sizeof(int) * 121);
    int * pre = (int *)malloc(sizeof(int) * 121);
    memset(cnt, 0, sizeof(int) * 121);
    memset(pre, 0, sizeof(int) * 121);
    for (int i = 0; i < agesSize; ++i) {
        ++cnt[ages[i]];
    }
    for (int i = 1; i <= 120; ++i) {
        pre[i] = pre[i - 1] + cnt[i];
    }
    int ans = 0;
    for (int i = 15; i <= 120; ++i) {
        if (cnt[i]) {
            int bound = i * 0.5 + 8;
            ans += cnt[i] * (pre[i] - pre[bound - 1] - 1);
        }
    }
    free(cnt);
    free(pre);
    return ans;
}
```

```JavaScript [sol2-JavaScript]
var numFriendRequests = function(ages) {
    const cnt = new Array(121).fill(0);
    for (const age of ages) {
        ++cnt[age];
    }
    const pre = new Array(121).fill(0);
    for (let i = 1; i <= 120; ++i) {
        pre[i] = pre[i - 1] + cnt[i];
    }
    let ans = 0;
    for (let i = 15; i <= 120; ++i) {
        if (cnt[i] > 0) {
            const bound = Math.floor(i * 0.5 + 8);
            ans += cnt[i] * (pre[i] - pre[bound - 1] - 1);
        }
    }
    return ans;
};
```

**复杂度分析**

- 时间复杂度：$O(n + C)$，其中 $C$ 是用户年龄的范围，本题中 $C = 120$。计数排序需要 $O(n)$ 的时间，计算前缀和以及统计答案需要 $O(C)$ 的时间。

- 空间复杂度：$O(C)$，即为计数排序以及前缀和数组需要使用的空间。
## [728.自除数 中文官方题解](https://leetcode.cn/problems/self-dividing-numbers/solutions/100000/zi-chu-shu-by-leetcode-solution-820g)

#### 方法一：直接判断

遍历范围 $[\textit{left}, \textit{right}]$ 内的所有整数，分别判断每个整数是否为自除数。

根据自除数的定义，如果一个整数不包含 $0$ 且能被它包含的每一位数整除，则该整数是自除数。判断一个整数是否为自除数的方法是遍历整数的每一位，判断每一位数是否为 $0$ 以及是否可以整除该整数。

遍历整数的每一位的方法是，每次将当前整数对 $10$ 取模即可得到当前整数的最后一位，然后将整数除以 $10$。重复该操作，直到当前整数变成 $0$ 时即遍历了整数的每一位。

```Python [sol1-Python3]
class Solution:
    def selfDividingNumbers(self, left: int, right: int) -> List[int]:
        def isSelfDividing(num: int) -> bool:
            x = num
            while x:
                x, d = divmod(x, 10)
                if d == 0 or num % d:
                    return False
            return True
        return [i for i in range(left, right + 1) if isSelfDividing(i)]
```

```Java [sol1-Java]
class Solution {
    public List<Integer> selfDividingNumbers(int left, int right) {
        List<Integer> ans = new ArrayList<Integer>();
        for (int i = left; i <= right; i++) {
            if (isSelfDividing(i)) {
                ans.add(i);
            }
        }
        return ans;
    }

    public boolean isSelfDividing(int num) {
        int temp = num;
        while (temp > 0) {
            int digit = temp % 10;
            if (digit == 0 || num % digit != 0) {
                return false;
            }
            temp /= 10;
        }
        return true;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public IList<int> SelfDividingNumbers(int left, int right) {
        IList<int> ans = new List<int>();
        for (int i = left; i <= right; i++) {
            if (IsSelfDividing(i)) {
                ans.Add(i);
            }
        }
        return ans;
    }

    public bool IsSelfDividing(int num) {
        int temp = num;
        while (temp > 0) {
            int digit = temp % 10;
            if (digit == 0 || num % digit != 0) {
                return false;
            }
            temp /= 10;
        }
        return true;
    }
}
```

```C++ [sol1-C++]
class Solution {
public:
    bool isSelfDividing(int num) {
        int temp = num;
        while (temp > 0) {
            int digit = temp % 10;
            if (digit == 0 || num % digit != 0) {
                return false;
            }
            temp /= 10;
        }
        return true;
    }

    vector<int> selfDividingNumbers(int left, int right) {
        vector<int> ans;
        for (int i = left; i <= right; i++) {
            if (isSelfDividing(i)) {
                ans.emplace_back(i);
            }
        }
        return ans;
    }
};
```

```C [sol1-C]
bool isSelfDividing(int num) {
    int temp = num;
    while (temp > 0) {
        int digit = temp % 10;
        if (digit == 0 || num % digit != 0) {
            return false;
        }
        temp /= 10;
    }
    return true;
}

int* selfDividingNumbers(int left, int right, int* returnSize){
    int * ans = (int *)malloc(sizeof(int) * (right - left + 1));
    int pos = 0;
    for (int i = left; i <= right; i++) {
        if (isSelfDividing(i)) {
            ans[pos++] = i;
        }
    }
    *returnSize = pos;
    return ans;
}
```

```JavaScript [sol1-JavaScript]
var selfDividingNumbers = function(left, right) {
    const ans = [];
    for (let i = left; i <= right; i++) {
        if (isSelfDividing(i)) {
            ans.push(i);
        }
    }
    return ans;
}

const isSelfDividing = (num) => {
    let temp = num;
    while (temp > 0) {
        const digit = temp % 10;
        if (digit === 0 || num % digit !== 0) {
            return false;
        }
        temp = Math.floor(temp / 10);
    }
    return true;
};
```

```go [sol1-Golang]
func isSelfDividing(num int) bool {
    for x := num; x > 0; x /= 10 {
        if d := x % 10; d == 0 || num%d != 0 {
            return false
        }
    }
    return true
}

func selfDividingNumbers(left, right int) (ans []int) {
    for i := left; i <= right; i++ {
        if isSelfDividing(i) {
            ans = append(ans, i)
        }
    }
    return
}
```

**复杂度分析**

- 时间复杂度：$O(n \log \textit{right})$，其中 $n$ 是范围内的整数个数，$\textit{right}$ 是范围内的最大整数。对于范围内的每个整数，需要 $O(\log \textit{right})$ 的时间判断是否为自除数。

- 空间复杂度：$O(1)$。除了返回值以外，使用的额外空间为 $O(1)$。
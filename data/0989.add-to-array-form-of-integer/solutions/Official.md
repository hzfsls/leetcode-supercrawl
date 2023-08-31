## [989.数组形式的整数加法 中文官方题解](https://leetcode.cn/problems/add-to-array-form-of-integer/solutions/100000/shu-zu-xing-shi-de-zheng-shu-jia-fa-by-l-jljp)
#### 方法一：逐位相加

**思路**

让我们逐位将数字加在一起。例如计算 $123+912$，我们从低位到高位依次计算 $3+2$、$2+1$ 和 $1+9$。任何时候，若加法的结果大于等于 $10$，把进位的 $1$ 加入到下一位的计算中，所以最终结果为 $1035$。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    vector<int> addToArrayForm(vector<int>& num, int k) {
        vector<int> res;
        int n = num.size();
        for (int i = n - 1; i >= 0; --i) {
            int sum = num[i] + k % 10;
            k /= 10;
            if (sum >= 10) {
                k++;
                sum -= 10;
            }
            res.push_back(sum);
        }
        for (; k > 0; k /= 10) {
            res.push_back(k % 10);
        }
        reverse(res.begin(), res.end());
        return res;
    }
};
```

```Java [sol1-Java]
class Solution {
    public List<Integer> addToArrayForm(int[] num, int k) {
        List<Integer> res = new ArrayList<Integer>();
        int n = num.length;
        for (int i = n - 1; i >= 0; --i) {
            int sum = num[i] + k % 10;
            k /= 10;
            if (sum >= 10) {
                k++;
                sum -= 10;
            }
            res.add(sum);
        }
        for (; k > 0; k /= 10) {
            res.add(k % 10);
        }
        Collections.reverse(res);
        return res;
    }
}
```

```go [sol1-Golang]
func addToArrayForm(num []int, k int) (ans []int) {
    for i := len(num) - 1; i >= 0; i-- {
        sum := num[i] + k%10
        k /= 10
        if sum >= 10 {
            k++
            sum -= 10
        }
        ans = append(ans, sum)
    }
    for ; k > 0; k /= 10 {
        ans = append(ans, k%10)
    }
    reverse(ans)
    return
}

func reverse(num []int) {
    for i, n := 0, len(num); i < n/2; i++ {
        num[i], num[n-1-i] = num[n-1-i], num[i]
    }
}
```

```C [sol1-C]
int* addToArrayForm(int* num, int numSize, int k, int* returnSize) {
    int* res = malloc(sizeof(int) * fmax(10, numSize + 1));
    *returnSize = 0;
    for (int i = numSize - 1; i >= 0; --i) {
        int sum = num[i] + k % 10;
        k /= 10;
        if (sum >= 10) {
            k++;
            sum -= 10;
        }
        res[(*returnSize)++] = sum;
    }
    for (; k > 0; k /= 10) {
        res[(*returnSize)++] = k % 10;
    }
    for (int i = 0; i < (*returnSize) / 2; i++) {
        int tmp = res[i];
        res[i] = res[(*returnSize) - 1 - i];
        res[(*returnSize) - 1 - i] = tmp;
    }
    return res;
}
```

```JavaScript [sol1-JavaScript]
var addToArrayForm = function(num, k) {
    const res = [];
    const n = num.length;
    for (let i = n - 1; i >= 0; --i) {
        let sum = num[i] + k % 10;
        k = Math.floor(k / 10);
        if (sum >= 10) {
            k++;
            sum -= 10;
        }
        res.push(sum);
    }
    for (; k > 0; k = Math.floor(k / 10)) {
        res.push(k % 10);
    }
    res.reverse();
    return res;
};
```

另一个思路是将整个加数 $k$ 加入数组表示的数的最低位。

上面的例子 $123+912$，我们把它表示成 $[1,2,3+912]$。然后，我们计算 $3+912=915$。$5$ 留在当前这一位，将 $910/10=91$ 以进位的形式加入下一位。

然后，我们再重复这个过程，计算 $[1,2+91,5]$。我们得到 $93$，$3$ 留在当前位，将 $90/10=9$ 以进位的形式加入下一位。继而又得到 $[1+9,3,5]$，重复这个过程之后，最终得到结果 $[1,0,3,5]$。

```C++ [sol2-C++]
class Solution {
public:
    vector<int> addToArrayForm(vector<int>& num, int k) {
        vector<int> res;
        int n = num.size();
        for (int i = n - 1; i >= 0 || k > 0; --i, k /= 10) {
            if (i >= 0) {
                k += num[i];
            }
            res.push_back(k % 10);
        }
        reverse(res.begin(), res.end());
        return res;
    }
};
```

```Java [sol2-Java]
class Solution {
    public List<Integer> addToArrayForm(int[] num, int k) {
        List<Integer> res = new ArrayList<Integer>();
        int n = num.length;
        for (int i = n - 1; i >= 0 || k > 0; --i, k /= 10) {
            if (i >= 0) {
                k += num[i];
            }
            res.add(k % 10);
        }
        Collections.reverse(res);
        return res;
    }
}
```

```go [sol2-Golang]
func addToArrayForm(num []int, k int) (ans []int) {
    for i := len(num) - 1; i >= 0 || k > 0; i-- {
        if i >= 0 {
            k += num[i]
        }
        ans = append(ans, k%10)
        k /= 10
    }
    reverse(ans)
    return
}

func reverse(num []int) {
    for i, n := 0, len(num); i < n/2; i++ {
        num[i], num[n-1-i] = num[n-1-i], num[i]
    }
}
```

```C [sol2-C]
int* addToArrayForm(int* num, int numSize, int k, int* returnSize) {
    int* res = malloc(sizeof(int) * fmax(10, numSize + 1));
    *returnSize = 0;
    for (int i = numSize - 1; i >= 0 || k > 0; --i, k /= 10) {
        if (i >= 0) {
            k += num[i];
        }
        res[(*returnSize)++] = k % 10;
    }

    for (int i = 0; i < (*returnSize) / 2; i++) {
        int tmp = res[i];
        res[i] = res[(*returnSize) - 1 - i];
        res[(*returnSize) - 1 - i] = tmp;
    }
    return res;
}
```

```JavaScript [sol2-JavaScript]
var addToArrayForm = function(num, k) {
    const res = [];
    const n = num.length;
    for (let i = n - 1; i >= 0 || k > 0; --i, k = Math.floor(k / 10)) {
        if (i >= 0) {
            k += num[i];
        }
        res.push(k % 10);
    }
    res.reverse();
    return res;
};
```

**复杂度分析**

* 时间复杂度：$O(\max(n,\log k))$，其中 $n$ 为数组的长度。

* 空间复杂度：$O(1)$。除了返回值以外，使用的空间为常数。
#### 前言

本题和「[89. 格雷编码](https://leetcode.cn/problems/gray-code/)」非常相似，区别在于「[89. 格雷编码](https://leetcode.cn/problems/gray-code/)」要求第一个整数是 $0$，而本题要求第一个整数是 $\textit{start}$，因此只需要将求出的结果的每一项都与 $\textit{start}$ 进行按位异或运算即可。

建议读者在做本题之前首先阅读「[89. 格雷编码的官方题解](https://leetcode.cn/problems/gray-code/solution/ge-lei-bian-ma-by-leetcode-solution-cqi7/)」。

#### 方法一：归纳法

**代码**

```C++ [sol1-C++]
class Solution {
public:
    vector<int> circularPermutation(int n, int start) {
        vector<int> ret;
        ret.reserve(1 << n);
        ret.push_back(start);
        for (int i = 1; i <= n; i++) {
            int m = ret.size();
            for (int j = m - 1; j >= 0; j--) {
                ret.push_back(((ret[j] ^ start) | (1 << (i - 1))) ^ start);
            }
        }
        return ret;
    }
};
```

```Java [sol1-Java]
class Solution {
    public List<Integer> circularPermutation(int n, int start) {
        List<Integer> ret = new ArrayList<Integer>();
        ret.add(start);
        for (int i = 1; i <= n; i++) {
            int m = ret.size();
            for (int j = m - 1; j >= 0; j--) {
                ret.add(((ret.get(j) ^ start) | (1 << (i - 1))) ^ start);
            }
        }
        return ret;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public IList<int> CircularPermutation(int n, int start) {
        IList<int> ret = new List<int>();
        ret.Add(start);
        for (int i = 1; i <= n; i++) {
            int m = ret.Count;
            for (int j = m - 1; j >= 0; j--) {
                ret.Add(((ret[j] ^ start) | (1 << (i - 1))) ^ start);
            }
        }
        return ret;
    }
}
```

```C [sol1-C]
int* circularPermutation(int n, int start, int* returnSize){
    int *ret = (int *)malloc((1 << n) * sizeof(int));
    ret[0] = start;
    int ret_size = 1;
    for (int i = 1; i <= n; i++) {
        for (int j = ret_size - 1; j >= 0; j--) {
            ret[2 * ret_size - 1 - j] = ((ret[j] ^ start) | (1 << (i - 1))) ^ start;
        }
        ret_size <<= 1;
    }
    *returnSize = ret_size;
    return ret;
}
```

```go [sol1-Golang]
func circularPermutation(n int, start int) []int {
	ans := make([]int, 1, 1<<n)
	ans[0] = start
	for i := 1; i <= n; i++ {
		for j := len(ans) - 1; j >= 0; j-- {
			ans = append(ans, ((ans[j]^start)|(1<<(i-1)))^start)
		}
	}
	return ans
}
```

```Python [sol1-Python3]
class Solution:
    def circularPermutation(self, n: int, start: int) -> List[int]:
        ans = [start]
        for i in range(1, n + 1):
            for j in range(len(ans) - 1, -1, -1):
                ans.append(((ans[j] ^ start) | (1 << (i - 1))) ^ start)
        return ans
```

```JavaScript [sol1-JavaScript]
var circularPermutation = function(n, start) {
    const ret = [start];
    for (let i = 1; i <= n; i++) {
        const m = ret.length;
        for (let j = m - 1; j >= 0; j--) {
            ret.push(((ret[j] ^ start) | (1 << (i - 1))) ^ start);
        }
    }
    return ret;
};
```

**复杂度分析**

- 时间复杂度：$O(2^n)$。每一个格雷码生成的时间为 $O(1)$，总时间为 $O(2^n)$。

- 空间复杂度：$O(1)$。这里返回值不计入空间复杂度。

#### 方法二：公式法

**代码**

```C++ [sol2-C++]
class Solution {
public:
    vector<int> circularPermutation(int n, int start) {
        vector<int> ret(1 << n);
        for (int i = 0; i < ret.size(); i++) {
            ret[i] = (i >> 1) ^ i ^ start;
        }
        return ret;
    }
};
```

```Java [sol2-Java]
class Solution {
    public List<Integer> circularPermutation(int n, int start) {
        List<Integer> ret = new ArrayList<Integer>();
        for (int i = 0; i < 1 << n; i++) {
            ret.add((i >> 1) ^ i ^ start);
        }
        return ret;
    }
}
```

```C# [sol2-C#]
public class Solution {
    public IList<int> CircularPermutation(int n, int start) {
        IList<int> ret = new List<int>();
        for (int i = 0; i < 1 << n; i++) {
            ret.Add((i >> 1) ^ i ^ start);
        }
        return ret;
    }
}
```

```C [sol2-C]
int* circularPermutation(int n, int start, int* returnSize){
    int ret_size = 1 << n;
    int *ret = (int *)malloc(ret_size * sizeof(int));
    for (int i = 0; i < ret_size; i++) {
        ret[i] = (i >> 1) ^ i ^ start;
    }
    *returnSize = ret_size;
    return ret;
}
```

```go [sol2-Golang]
func circularPermutation(n int, start int) []int {
	ans := make([]int, 1<<n)
	for i := range ans {
		ans[i] = (i >> 1) ^ i ^ start
	}
	return ans
}
```

```Python [sol2-Python3]
class Solution:
    def circularPermutation(self, n: int, start: int) -> List[int]:
        ans = [0] * (1 << n)
        for i in range(1 << n):
            ans[i] = (i >> 1) ^ i ^ start
        return ans
```

```JavaScript [sol2-JavaScript]
var circularPermutation = function(n, start) {
    const ret = [];
    for (let i = 0; i < 1 << n; i++) {
        ret.push((i >> 1) ^ i ^ start);
    }
    return ret;
};
```

**复杂度分析**

- 时间复杂度：$O(2^n)$。每一个格雷码生成的时间为 $O(1)$，总时间为 $O(2^n)$。

- 空间复杂度：$O(1)$。这里返回值不计入空间复杂度。
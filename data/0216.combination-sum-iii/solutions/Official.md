#### 方法一：二进制（子集）枚举

**思路与算法**

「组合中只允许含有 $1-9$ 的正整数，并且每种组合中不存在重复的数字」意味着这个组合中最多包含 $9$ 个数字。我们可以把原问题转化成集合 $S = \{ 1,2,3,4,5,6,7,8,9 \}$，我们要找出 $S$ 的当中满足如下条件的子集：

+ 大小为 $k$
+ 集合中元素的和为 $n$

因此我们可以用子集枚举的方法来做这道题。即原序列中有 $9$ 个数，每个数都有两种状态，「被选择到子集中」和「不被选择到子集中」，所以状态的总数为 $2^9$。我们用一个 $9$ 位二进制数 $\rm mask$ 来记录当前所有位置的状态，从第到高第 $i$ 位为 $0$ 表示 $i$ 不被选择到子集中，为 $1$ 表示 $i$ 被选择到子集中。当我们按顺序枚举 $[0, 2^9 - 1]$ 中的所有整数的时候，就可以不重不漏地把每个状态枚举到，对于一个状态 $\rm mask$，我们可以用位运算的方法得到对应的子集序列，然后再判断是否满足上面的两个条件，如果满足，就记录答案。

如何通过位运算来得到 $\rm mask$ 各个位置的信息？对于第 $i$ 个位置我们可以判断 `(1 << i) & mask` 是否为 $0$，如果不为 $0$ 则说明 $i$ 在子集当中。当然，这里要注意的是，一个 $9$ 位二进制数 $i$ 的范围是 $[0, 8]$，而可选择的数字是 $[1, 9]$，所以我们需要做一个映射，最简单的办法就是当我们知道 $i$ 位置不为 $0$ 的时候将 $i + 1$ 加入子集。

当然，子集枚举也可以用递归实现。在「[77. 组合的官方题解](https://leetcode-cn.com/problems/combinations/solution/zu-he-by-leetcode-solution/)」的方法一中提及了子集枚举递归实现的基本框架，感兴趣的同学可以参考。

代码如下。

**代码**

```cpp [sol1-C++]
class Solution {
public:
    vector<int> temp;
    vector<vector<int>> ans;

    bool check(int mask, int k, int n) {
        temp.clear();
        for (int i = 0; i < 9; ++i) {
            if ((1 << i) & mask) {
                temp.push_back(i + 1);
            }
        }
        return temp.size() == k && accumulate(temp.begin(), temp.end(), 0) == n; 
    }

    vector<vector<int>> combinationSum3(int k, int n) {
        for (int mask = 0; mask < (1 << 9); ++mask) {
            if (check(mask, k, n)) {
                ans.emplace_back(temp);
            }
        }
        return ans;
    }
};
```

```Java [sol1-Java]
class Solution {
    List<Integer> temp = new ArrayList<Integer>();
    List<List<Integer>> ans = new ArrayList<List<Integer>>();

    public List<List<Integer>> combinationSum3(int k, int n) {
        for (int mask = 0; mask < (1 << 9); ++mask) {
            if (check(mask, k, n)) {
                ans.add(new ArrayList<Integer>(temp));
            }
        }
        return ans;
    }

    public boolean check(int mask, int k, int n) {
        temp.clear();
        for (int i = 0; i < 9; ++i) {
            if (((1 << i) & mask) != 0) {
                temp.add(i + 1);
            }
        }
        if (temp.size() != k) {
            return false;
        }
        int sum = 0;
        for (int num : temp) {
            sum += num;
        }
        return sum == n;
    }
}
```

```JavaScript [sol1-JavaScript]
var combinationSum3 = function(k, n) {
    let temp = [];
    const ans = [];
    const check = (mask, k, n) => {
        temp = [];
        for (let i = 0; i < 9; ++i) {
            if ((1 << i) & mask) {
                temp.push(i + 1);
            }
        }
        return temp.length === k && temp.reduce((previous, value) => previous + value, 0) === n;
    }

    for (let mask = 0; mask < (1 << 9); ++mask) {
        if (check(mask, k, n)) {
            ans.push(temp);
        }
    }
    return ans;
};
```

```Golang [sol1-Golang]
func combinationSum3(k int, n int) (ans [][]int) {
	var temp []int
	check := func(mask int) bool {
		temp = nil
		sum := 0
		for i := 0; i < 9; i++ {
			if 1<<i&mask > 0 {
				temp = append(temp, i+1)
				sum += i + 1
			}
		}
		return len(temp) == k && sum == n
	}

	for mask := 0; mask < 1<<9; mask++ {
		if check(mask) {
			ans = append(ans, append([]int(nil), temp...))
		}
	}
	return
}
```

```C [sol1-C]
int* temp;
int tempSize;

bool check(int mask, int k, int n) {
    tempSize = 0;
    int sum = 0;
    for (int i = 0; i < 9; ++i) {
        if ((1 << i) & mask) {
            temp[tempSize++] = i + 1;
            sum += i + 1;
        }
    }
    return tempSize == k && sum == n;
}

int** combinationSum3(int k, int n, int* returnSize, int** returnColumnSizes) {
    *returnColumnSizes = malloc(sizeof(int) * 2001);
    int** ret = malloc(sizeof(int*) * 2001);
    temp = malloc(sizeof(int) * 2001);
    *returnSize = 0;

    for (int mask = 0; mask < (1 << 9); ++mask) {
        if (check(mask, k, n)) {
            int* tmp = malloc(sizeof(int) * tempSize);
            memcpy(tmp, temp, sizeof(int) * tempSize);
            ret[*returnSize] = tmp;
            (*returnColumnSizes)[(*returnSize)++] = tempSize;
        }
    }
    return ret;
}
```

**复杂度分析**

+ 时间复杂度：$O(M \times 2^M)$，其中 $M$ 为集合的大小，本题中 $M$ 固定为 $9$。一共有 $2^M$ 个状态，每个状态需要 $O(M + k) = O(M)$ 的判断 （$k \leq M$），故时间复杂度为 $O(M \times 2^M)$。
+ 空间复杂度：$O(M)$。即 $\rm temp$ 的空间代价。

#### 方法二：组合枚举

**思路与算法**

我们可以换一个思路：我们需要在 $9$ 个数中选择 $k$ 个数，让它们的和为 $n$。

这样问题就变成了一个组合枚举问题。组合枚举有两种处理方法——递归法和字典序法，在「[77. 组合的官方题解](https://leetcode-cn.com/problems/combinations/solution/zu-he-by-leetcode-solution/)」中有详细的说明。

这里我们要做的是做一个「在 $9$ 个数中选择 $k$ 个数」的组合枚举，对于枚举到的所有组合，判断这个组合内元素之和是否为 $n$。

代码如下。

**代码**

```cpp [sol2-C++]
class Solution {
public:
    vector<int> temp;
    vector<vector<int>> ans;

    void dfs(int cur, int n, int k, int sum) {
        if (temp.size() + (n - cur + 1) < k || temp.size() > k) {
            return;
        }
        if (temp.size() == k && accumulate(temp.begin(), temp.end(), 0) == sum) {
            ans.push_back(temp);
            return;
        }
        temp.push_back(cur);
        dfs(cur + 1, n, k, sum);
        temp.pop_back();
        dfs(cur + 1, n, k, sum);
    }

    vector<vector<int>> combinationSum3(int k, int n) {
        dfs(1, 9, k, n);
        return ans;
    }
};
```

```Java [sol2-Java]
class Solution {
    List<Integer> temp = new ArrayList<Integer>();
    List<List<Integer>> ans = new ArrayList<List<Integer>>();

    public List<List<Integer>> combinationSum3(int k, int n) {
        dfs(1, 9, k, n);
        return ans;
    }

    public void dfs(int cur, int n, int k, int sum) {
        if (temp.size() + (n - cur + 1) < k || temp.size() > k) {
            return;
        }
        if (temp.size() == k) {
            int tempSum = 0;
            for (int num : temp) {
                tempSum += num;
            }
            if (tempSum == sum) {
                ans.add(new ArrayList<Integer>(temp));
                return;
            }
        }
        temp.add(cur);
        dfs(cur + 1, n, k, sum);
        temp.remove(temp.size() - 1);
        dfs(cur + 1, n, k, sum);
    }
}
```

```JavaScript [sol2-JavaScript]
var combinationSum3 = function(k, n) {
    const temp = [];
    const res = [];
    const dfs = (cur, n, k, sum, res) => {
        if (temp.length + (n - cur + 1) < k || temp.length > k) {
            return;
        }        
        if (temp.length === k && temp.reduce((previous, value) => previous + value, 0) === sum) {
            res.push(temp.slice());
            return;
        }
        temp.push(cur);
        dfs(cur + 1, n, k, sum, res);
        temp.pop();
        dfs(cur + 1, n, k, sum, res);
    }

    dfs(1, 9, k, n, res);
    return res;
};
```

```Golang [sol2-Golang]
func combinationSum3(k int, n int) (ans [][]int) {
	var temp []int
	var dfs func(cur, rest int)
	dfs = func(cur, rest int) {
		// 找到一个答案
		if len(temp) == k && rest == 0 {
			ans = append(ans, append([]int(nil), temp...))
			return
		}
		// 剪枝：跳过的数字过多，后面已经无法选到 k 个数字
		if len(temp)+10-cur < k || rest < 0 {
			return
		}
		// 跳过当前数字
		dfs(cur+1, rest)
		// 选当前数字
		temp = append(temp, cur)
		dfs(cur+1, rest-cur)
		temp = temp[:len(temp)-1]
	}
	dfs(1, n)
	return
}
```

```C [sol2-C]
int* temp;
int tempSize;

int** ans;
int* ansColumnSize;
int ansSize;

int accumulate(int* tmp, int tmpSize) {
    int ret = 0;
    for (int i = 0; i < tmpSize; ++i) {
        ret += tmp[i];
    }
    return ret;
}

void dfs(int cur, int n, int k, int sum) {
    if (tempSize + (n - cur + 1) < k || tempSize > k) {
        return;
    }
    if (tempSize == k && accumulate(temp, tempSize) == sum) {
        int* tmp = malloc(sizeof(int) * tempSize);
        memcpy(tmp, temp, sizeof(int) * tempSize);
        ans[ansSize] = tmp;
        ansColumnSize[ansSize++] = tempSize;
        return;
    }
    temp[tempSize++] = cur;
    dfs(cur + 1, n, k, sum);
    tempSize--;
    dfs(cur + 1, n, k, sum);
}

int** combinationSum3(int k, int n, int* returnSize, int** returnColumnSizes) {
    ansColumnSize = malloc(sizeof(int) * 2001);
    temp = malloc(sizeof(int) * 2001);
    ans = malloc(sizeof(int*) * 2001);
    ansSize = tempSize = 0;

    dfs(1, 9, k, n);
    *returnSize = ansSize;
    *returnColumnSizes = ansColumnSize;
    return ans;
}
```

**复杂度分析**

+ 时间复杂度：$O({M \choose k} \times k)$，其中 $M$ 为集合的大小，本题中 $M$ 固定为 $9$。一共有 $M \choose k$ 个组合，每次判断需要的时间代价是 $O(k)$。
+ 空间复杂度：$O(M)$。$\rm temp$ 数组的空间代价是 $O(k)$，递归栈空间的代价是 $O(M)$，故空间复杂度为 $O(M + k) = O(M)$.
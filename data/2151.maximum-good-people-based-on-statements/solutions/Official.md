## [2151.基于陈述统计最多好人数 中文官方题解](https://leetcode.cn/problems/maximum-good-people-based-on-statements/solutions/100000/ji-yu-chen-shu-tong-ji-zui-duo-hao-ren-s-lfn9)
#### 方法一：使用状态压缩枚举所有可能的情况

**思路与算法**

由于本题中 $n \leq 15$，因此我们可以使用 $O(2^n)$ 的时间枚举每一种情况：即每个人是好人或坏人有 $2$ 种情况，一共有 $n$ 个人。

我们可以使用状态压缩的方法进行枚举。具体地，我们遍历 $[0, 2^n)$ 中的每一个数 $\textit{mask}$，$\textit{mask}$ 的第 $i$ 位为 $1$ 就表示第 $i$ 个人是好人，如果为 $0$ 就表示第 $i$ 个人是坏人。这样我们就可以不重复不遗漏地枚举所有的情况。

在枚举 $\textit{mask}$ 后，我们可以根据给定的数组 $\textit{statements}$ 来判断合法性：具体地：

- 如果 $\textit{statements}[i][j] = 0$，那么 $i$ 认为 $j$ 是坏人，这说明要么 $j$ 是坏人，要么 $i$ 是坏人。因此如果 $i$ 和 $j$ 都是好人，即 $\textit{mask}$ 的第 $i$ 位和第 $j$ 位都是 $1$，那么就是不合法的；

- 如果 $\textit{statements}[i][j] = 1$，那么 $i$ 认为 $j$ 是好人，这说明要么 $j$ 是好人，要么 $i$ 是坏人。因此如果 $i$ 是好人并且 $j$ 是坏人，即 $\textit{mask}$ 的第 $i$ 位是 $1$ 并且第 $j$ 位是 $0$，那么就是不合法的；

- 如果 $\textit{statements}[i][j] = 2$，那么可以忽略。

因此我们可以在 $O(n^2)$ 的时间内判断 $\textit{mask}$ 的合法性：如果其合法，我们再统计出其包含的 $1$ 的个数，并更新答案。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    int maximumGood(vector<vector<int>>& statements) {
        int n = statements.size();
        int ans = 0;
        for (int mask = 1; mask < (1 << n); ++mask) {
            bool check = [&]() {
                for (int i = 0; i < n; ++i) {
                    for (int j = 0; j < n; ++j) {
                        if (i == j) {
                            continue;
                        }
                        if (statements[i][j] == 0) {
                            if ((mask & (1 << i)) && (mask & (1 << j))) {
                                return false;
                            }
                        }
                        else if (statements[i][j] == 1) {
                            if ((mask & (1 << i)) && !(mask & (1 << j))) {
                                return false;
                            }
                        }
                    }
                }
                return true;
            }();
            if (check) {
                ans = max(ans, __builtin_popcount(mask));
            }
        }
        return ans;
    }
};
```

```Python [sol1-Python3]
class Solution:
    def maximumGood(self, statements: List[List[int]]) -> int:
        n = len(statements)
        ans = 0
        for mask in range(1, 1 << n):
            def check() -> bool:
                for i in range(n):
                    for j in range(n):
                        if i == j:
                            continue
                        if statements[i][j] == 0:
                            if mask & (1 << i) and mask & (1 << j):
                                return False
                        elif statements[i][j] == 1:
                            if mask & (1 << i) and not mask & (1 << j):
                                return False
                return True
            
            if check():
                ans = max(ans, bin(mask).count("1"))
        return ans
```

```Golang [sol1-Golang]
func maximumGood(statements [][]int) int {
	n := len(statements)
	ans := 0
	for mask := 1; mask < (1 << n); mask++ {
		check := func() bool {
			for i := 0; i < n; i++ {
				for j := 0; j < n; j++ {
					if i == j {
						continue
					}
					if statements[i][j] == 0 {
						if ((mask & (1 << i)) > 0) && ((mask & (1 << j)) > 0) {
							return false
						}
					} else if statements[i][j] == 1 {
						if ((mask & (1 << i)) > 0) && ((mask & (1 << j)) == 0) {
							return false
						}
					}
				}
			}
			return true
		}

		if check() {
			ans = max(ans, bits.OnesCount(uint(mask)))
		}
	}
	return ans
}

func max(x, y int) int {
	if x > y {
		return x
	}
	return y
}
```

**复杂度分析**

- 时间复杂度：$O(2^n \cdot n^2)$。

- 空间复杂度：$O(1)$。
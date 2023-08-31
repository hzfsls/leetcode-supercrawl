## [2147.分隔长廊的方案数 中文官方题解](https://leetcode.cn/problems/number-of-ways-to-divide-a-long-corridor/solutions/100000/fen-ge-chang-lang-de-fang-an-shu-by-leet-p9wr)

#### 方法一：乘法原理

**思路与算法**

我们可以按照顺序将座位每两个分成一组。在相邻两组之间，如果有 $x$ 个装饰植物，那么就有 $x + 1$ 种放置屏风的方法。根据乘法原理，总方案数就是所有 $x+1$ 的乘积。

因此，我们只需要对数组 $\textit{corridor}$ 进行一次遍历就可得到答案。在遍历的过程中，我们维护当前的座位总数 $\textit{cnt}$ 和上一个座位的位置 $\textit{prev}$。当遍历到 $\textit{corridor}[i]$ 时，如果它是座位，并且包括它我们遍历到奇数（并且大于等于 $3$）个座位，那么 $\textit{corridor}[i]$ 就是一个新的座位组的开始，它和上一个组之间就有 $i - \textit{prev} - 1$ 个装饰植物，即 $i - \textit{prev}$ 种放置屏风的方法。

在遍历完成后，我们需要检查 $\textit{cnt}$ 是否为偶数并且大于等于 $2$。如果不满足，那么需要返回 $0$。

**代码**

```C++ [sol1-C++]
class Solution {
private:
    static constexpr int mod = 1000000007;
    
public:
    int numberOfWays(string corridor) {
        int n = corridor.size();
        int prev = -1, cnt = 0, ans = 1;
        for (int i = 0; i < n; ++i) {
            if (corridor[i] == 'S') {
                ++cnt;
                if (cnt >= 3 && cnt % 2 == 1) {
                    ans = static_cast<long long>(ans) * (i - prev) % mod;
                }
                prev = i;
            }
        }
        if (cnt < 2 || cnt & 1) {
            ans = 0;
        }
        return ans;
    }
};
```

```Python [sol1-Python3]
class Solution:
    def numberOfWays(self, corridor: str) -> int:
        mod = 10**9 + 7

        prev, cnt, ans = -1, 0, 1
        for i, ch in enumerate(corridor):
            if ch == "S":
                cnt += 1
                if cnt >= 3 and cnt % 2 == 1:
                    ans = ans * (i - prev) % mod
                prev = i
        
        if cnt < 2 or cnt % 2 == 1:
            ans = 0
        
        return ans
```

```Golang [sol1-Golang]
func numberOfWays(corridor string) int {
	const mod = 1e9 + 7
	prev, cnt, ans := -1, 0, 1
	for i, ch := range corridor {
		if ch == 'S' {
			cnt += 1
			if (cnt >= 3) && (cnt%2 == 1) {
				ans = ans * (i - prev) % mod
			}
			prev = i
		}
	}
	if (cnt < 2) || (cnt%2 == 1) {
		ans = 0
	}
	return ans
}
```

**复杂度分析**

- 时间复杂度：$O(n)$。

- 空间复杂度：$O(1)$。
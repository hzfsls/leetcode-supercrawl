## [2379.得到 K 个黑块的最少涂色次数 中文官方题解](https://leetcode.cn/problems/minimum-recolors-to-get-k-consecutive-black-blocks/solutions/100000/de-dao-kge-hei-kuai-de-zui-shao-tu-se-ci-gjb0)
#### 方法一：滑动窗口

**思路与算法**

首先题目给出一个下标从 $0$ 开始长度为 $n$ 的字符串 $\textit{blocks}$，其中 $\textit{blocks}[i]$ 是 $'W'$ 或 $'B'$，分别表示白色块要么是黑色块。现在我们可以执行任意次将一个白色块转变为黑色块的操作，并给出一个整数 $k$，我们需要返回至少出现一次连续 $k$ 个黑色块的最少操作次数。

我们可以用「滑动窗口」来解决该问题。我们用一个固定大小为 $k$ 的「滑动窗口」表示出现连续 $k$ 个黑色块的区间，我们需要将该区间全部变为黑色块，此时我们需要的操作次数为该区间中白色块的数目，那么我们只需要在「滑动窗口」从左向右移动的过程中维护窗口中白色块的数目，最后返回移动过程中白色块数目的最小值即为我们需要至少出现一次连续 $k$ 个黑色块的最少操作次数。

**代码**

```Python [sol1-Python3]
class Solution:
    def minimumRecolors(self, blocks: str, k: int) -> int:
        ans = inf 
        cnt = 0 
        for i, ch in enumerate(blocks): 
            if ch == 'W':
                cnt += 1
            if i >= k and blocks[i-k] == 'W':
                cnt -= 1
            if i >= k - 1:
                ans = min(ans, cnt)
        return ans 
```

```C++ [sol1-C++]
class Solution {
public:
    int minimumRecolors(string blocks, int k) {
        int l = 0, r = 0, cnt = 0;
        while (r < k) {
            cnt += blocks[r] == 'W' ? 1 : 0;
            r++;
        }
        int res = cnt;
        while (r < blocks.size()) {
            cnt += blocks[r] == 'W' ? 1 : 0;
            cnt -= blocks[l] == 'W' ? 1 : 0;
            res = min(res, cnt);
            l++;
            r++;
        }
        return res;
    }
};
```

```Java [sol1-Java]
class Solution {
    public int minimumRecolors(String blocks, int k) {
        int l = 0, r = 0, cnt = 0;
        while (r < k) {
            cnt += blocks.charAt(r) == 'W' ? 1 : 0;
            r++;
        }
        int res = cnt;
        while (r < blocks.length()) {
            cnt += blocks.charAt(r) == 'W' ? 1 : 0;
            cnt -= blocks.charAt(l) == 'W' ? 1 : 0;
            res = Math.min(res, cnt);
            l++;
            r++;
        }
        return res;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int MinimumRecolors(string blocks, int k) {
        int l = 0, r = 0, cnt = 0;
        while (r < k) {
            cnt += blocks[r] == 'W' ? 1 : 0;
            r++;
        }
        int res = cnt;
        while (r < blocks.Length) {
            cnt += blocks[r] == 'W' ? 1 : 0;
            cnt -= blocks[l] == 'W' ? 1 : 0;
            res = Math.Min(res, cnt);
            l++;
            r++;
        }
        return res;
    }
}
```

```C [sol1-C]
#define MIN(a, b) ((a) < (b) ? (a) : (b))

int minimumRecolors(char * blocks, int k) {
    int l = 0, r = 0, cnt = 0;
    while (r < k) {
        cnt += blocks[r] == 'W' ? 1 : 0;
        r++;
    }
    int res = cnt;
    int len = strlen(blocks);
    while (r < len) {
        cnt += blocks[r] == 'W' ? 1 : 0;
        cnt -= blocks[l] == 'W' ? 1 : 0;
        res = MIN(res, cnt);
        l++;
        r++;
    }
    return res;
}
```

```JavaScript [sol1-JavaScript]
var minimumRecolors = function(blocks, k) {
    let l = 0, r = 0, cnt = 0;
    while (r < k) {
        cnt += blocks[r] === 'W' ? 1 : 0;
        r++;
    }
    let res = cnt;
    while (r < blocks.length) {
        cnt += blocks[r] === 'W' ? 1 : 0;
        cnt -= blocks[l] === 'W' ? 1 : 0;
        res = Math.min(res, cnt);
        l++;
        r++;
    }
    return res;
};
```

```go [sol1-Golang]
func minimumRecolors(blocks string, k int) int {
    res := k
    left, whites := 0, 0
    for right := 0; right < len(blocks); right++ {
        if blocks[right] == 'W' {
            whites++
        }
        if right < k-1 {
            continue
        }
        res = min(res, whites)
        if blocks[left] == 'W' {
            whites--
        }
        left++
    }
    return res
}

func min(a, b int) int {
    if a < b {
        return a
    }
    return b
}
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 为字符串 $\textit{blocks}$ 的长度。
- 空间复杂度：$O(1)$，仅使用常量空间。
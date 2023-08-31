## [1010.总持续时间可被 60 整除的歌曲 中文官方题解](https://leetcode.cn/problems/pairs-of-songs-with-total-durations-divisible-by-60/solutions/100000/zong-chi-xu-shi-jian-ke-bei-60-zheng-chu-42cu)
#### 方法一：组合数学

**思路**

需要返回其总持续时间（以秒为单位）可被 $60$ 整除的歌曲对的数量，因此，每首歌曲对结果的影响因素是它的持续时间除以 $60$ 后的余数。可以用一个长度为 $60$ 的数组 $\textit{cnt}$，用来表示余数出现的次数。然后分情况统计歌曲对：

1. 余数为 $0$ 的歌曲。他们需要与余数为 $0$ 的歌曲组成对，但不能与自己组成对。歌曲对的数量为 $\textit{cnt}[0] \times (\textit{cnt}[0]-1)/2$。
2. 余数为 $30$ 的歌曲。他们需要与余数为 $30$ 的歌曲组成对，但不能与自己组成对。歌曲对的数量为 $\textit{cnt}[30] \times (\textit{cnt}[30]-1)/2$。
3. 余数为 $i, i\in[1,29]$ 的歌曲。他们需要与余数为 $60-i$ 的歌曲组成对。歌曲对的数量为 $\sum_{i=1}^{29}\textit{cnt}[i] \times \textit{cnt}[60-i]$。
4. 余数为 $i, i\in[31,59]$ 的歌曲。已经在上一部分组对过，不需要重复计算。

把这几部分求和，就可以得到最后的对数。

**代码**

```Python [sol1-Python3]
class Solution:
    def numPairsDivisibleBy60(self, time: List[int]) -> int:
        cnt = [0] * 60
        for t in time:
            cnt[t % 60] += 1
        res = 0
        for i in range(1, 30):
            res += cnt[i] * cnt[60 - i]
        res += cnt[0] * (cnt[0] - 1) // 2 + cnt[30] * (cnt[30] - 1) // 2
        return res
```

```Java [sol1-Java]
class Solution {
    public int numPairsDivisibleBy60(int[] time) {
        int[] cnt = new int[60];
        for (int t : time) {
            cnt[t % 60]++;
        }
        long res = 0;
        for (int i = 1; i < 30; i++) {
            res += cnt[i] * cnt[60 - i];
        }
        res += (long) cnt[0] * (cnt[0] - 1) / 2 + (long) cnt[30] * (cnt[30] - 1) / 2;
        return (int) res;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int NumPairsDivisibleBy60(int[] time) {
        int[] cnt = new int[60];
        foreach (int t in time) {
            cnt[t % 60]++;
        }
        long res = 0;
        for (int i = 1; i < 30; i++) {
            res += cnt[i] * cnt[60 - i];
        }
        res += (long) cnt[0] * (cnt[0] - 1) / 2 + (long) cnt[30] * (cnt[30] - 1) / 2;
        return (int) res;
    }
}
```

```C++ [sol1-C++]
class Solution {
public:
    int numPairsDivisibleBy60(vector<int>& time) {
        vector<int> cnt(60);
        for (int t : time) {
            cnt[t % 60]++;
        }
        long long res = 0;
        for (int i = 1; i < 30; i++) {
            res += cnt[i] * cnt[60 - i];
        }            
        res += (long long)cnt[0] * (cnt[0] - 1) / 2 + (long long)cnt[30] * (cnt[30] - 1) / 2;
        return (int)res;
    }
};
```

```Go [sol1-Go]
func numPairsDivisibleBy60(time []int) int {
    cnt := make([]int, 60)
    for _, t := range time {
        cnt[t % 60]++
    }
    var res int
    for i := 1; i < 30; i++ {
        res += cnt[i] * cnt[60 - i]
    }
    res += cnt[0] * (cnt[0] - 1) / 2 + cnt[30] * (cnt[30] - 1) / 2
    return res
}
```

```JavaScript [sol1-JavaScript]
var numPairsDivisibleBy60 = function(time) {
    const cnt = new Array(60).fill(0);
    for (let t of time) {
        cnt[t % 60]++;
    }
    let res = 0;
    for (let i = 1; i < 30; i++) {
        res += cnt[i] * cnt[60 - i];
    }
    res += cnt[0] * (cnt[0] - 1) / 2 + cnt[30] * (cnt[30] - 1) / 2;
    return res;
}
```

```C [sol1-C]
int numPairsDivisibleBy60(int* time, int timeSize) {
    int cnt[60];
    memset(cnt, 0, sizeof(cnt));
    for (int i = 0; i < timeSize; i++) {
        cnt[time[i] % 60]++;
    }
    long long res = 0;
    for (int i = 1; i < 30; i++) {
        res += cnt[i] * cnt[60 - i];
    }            
    res += (long long)cnt[0] * (cnt[0] - 1) / 2 + (long long)cnt[30] * (cnt[30] - 1) / 2;
    return (int)res;
}
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 是 $\textit{time}$ 的长度，需要遍历 $\textit{time}$ 一遍。

- 空间复杂度：$O(1)$，需要长度为 $60$ 的数组。
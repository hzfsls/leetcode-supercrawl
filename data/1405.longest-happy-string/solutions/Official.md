## [1405.最长快乐字符串 中文官方题解](https://leetcode.cn/problems/longest-happy-string/solutions/100000/zui-chang-kuai-le-zi-fu-chuan-by-leetcod-5nde)
#### 方法一：贪心

**思路**

题目要求找到最长的快乐字符串，且快乐字符串中不含有三个连续相同的字母。为了找到最长的字符串，我们可以使用如下贪心策略：

+ 尽可能优先使用当前数量最多的字母，因为最后同一种字母剩余的越多，越容易出现字母连续相同的情况。如果构建完成最长的快乐字符串后还存在剩余未选择的字母，则剩余的字母一定为同一种字母且该字母的总数量最多。

+ 依次从当前数量最多的字母开始尝试，如果发现加入当前字母会导致出现三个连续相同字母，则跳过当前字母，直到我们找到可以添加的字母为止。实际上每次只会在数量最多和次多的字母中选择一个。

+ 如果尝试所有的字母都无法添加，则直接退出，此时构成的字符串即为最长的快乐字符串。

**代码**

```Python [sol1-Python3]
class Solution:
    def longestDiverseString(self, a: int, b: int, c: int) -> str:
        ans = []
        cnt = [[a, 'a'], [b, 'b'], [c, 'c']]
        while True:
            cnt.sort(key=lambda x: -x[0])
            hasNext = False
            for i, (c, ch) in enumerate(cnt):
                if c <= 0:
                    break
                if len(ans) >= 2 and ans[-2] == ch and ans[-1] == ch:
                    continue
                hasNext = True
                ans.append(ch)
                cnt[i][0] -= 1
                break
            if not hasNext:
                return ''.join(ans)
```

```C++ [sol1-C++]
class Solution {
public:
    string longestDiverseString(int a, int b, int c) {
        string res;
        vector<pair<int, char>> arr = {{a, 'a'}, {b, 'b'}, {c, 'c'}};
        
        while (true) {
            sort(arr.begin(), arr.end(), [](const pair<int, char> & p1, const pair<int, char> & p2) {
                return p1.first > p2.first;
            });
            bool hasNext = false;
            for (auto & [freq, ch] : arr) {
                int m = res.size();
                if (freq <= 0) {
                    break;
                }
                if (m >= 2 && res[m - 2] == ch && res[m - 1] == ch) {
                    continue;
                }
                hasNext = true;
                res.push_back(ch);
                freq--;
                break;
            }
            if (!hasNext) {
                break;
            }
        }
      
        return res;
    }
};
```

```Java [sol1-Java]
class Solution {
    public String longestDiverseString(int a, int b, int c) {
        StringBuilder res = new StringBuilder();
        Pair[] arr = {new Pair(a, 'a'), new Pair(b, 'b'), new Pair(c, 'c')};
        
        while (true) {
            Arrays.sort(arr, (p1, p2) -> p2.freq - p1.freq);
            boolean hasNext = false;
            for (Pair pair : arr) {
                if (pair.freq <= 0) {
                    break;
                }
                int m = res.length();
                if (m >= 2 && res.charAt(m - 2) == pair.ch && res.charAt(m - 1) == pair.ch) {
                    continue;
                }
                hasNext = true;
                res.append(pair.ch);
                pair.freq--;
                break;
            }
            if (!hasNext) {
                break;
            }
        }
      
        return res.toString();
    }

    class Pair {
        int freq;
        char ch;

        public Pair(int freq, char ch) {
            this.freq = freq;
            this.ch = ch;
        }
    }
}
```

```C# [sol1-C#]
public class Solution {
    public string LongestDiverseString(int a, int b, int c) {
        StringBuilder res = new StringBuilder();
        Pair[] arr = {new Pair(a, 'a'), new Pair(b, 'b'), new Pair(c, 'c')};
        
        while (true) {
            Array.Sort(arr, (p1, p2) => p2.Freq - p1.Freq);
            bool hasNext = false;
            foreach (Pair pair in arr) {
                if (pair.Freq <= 0) {
                    break;
                }
                int m = res.Length;
                if (m >= 2 && res[m - 2] == pair.Ch && res[m - 1] == pair.Ch) {
                    continue;
                }
                hasNext = true;
                res.Append(pair.Ch);
                pair.Freq--;
                break;
            }
            if (!hasNext) {
                break;
            }
        }
      
        return res.ToString();
    }

    class Pair {
        public int Freq { get; set; }
        public char Ch { get; set; }

        public Pair(int Freq, char Ch) {
            this.Freq = Freq;
            this.Ch = Ch;
        }
    }
}
```

```C [sol1-C]
typedef struct {
    int freq;
    char ch;
} Pair;

int cmp(const void * pa, const void * pb) {
    return ((Pair *)pb)->freq - ((Pair *)pa)->freq;
}

char * longestDiverseString(int a, int b, int c){
    char * res = (char *)malloc(sizeof(char) * (a + b + c + 1));
    Pair arr[3] = {{a, 'a'}, {b, 'b'}, {c, 'c'}};
    int pos = 0;

    while (true) {
        qsort(arr, 3, sizeof(Pair), cmp);
        bool hasNext = false;
        for (int i = 0; i < 3; i++) {
            int freq = arr[i].freq;
            int ch = arr[i].ch;
            if (freq <= 0) {
                break;
            }
            if (pos >= 2 && res[pos - 2] == ch && res[pos - 1] == ch) {
                continue;
            }
            hasNext = true;
            res[pos++] = ch;
            arr[i].freq--;
            break;
        }
        if (!hasNext) {
            break;
        }
    }
    res[pos] = '\0';
    return res;
}
```

```go [sol1-Golang]
func longestDiverseString(a, b, c int) string {
    ans := []byte{}
    cnt := []struct{ c int; ch byte }{{a, 'a'}, {b, 'b'}, {c, 'c'}}
    for {
        sort.Slice(cnt, func(i, j int) bool { return cnt[i].c > cnt[j].c })
        hasNext := false
        for i, p := range cnt {
            if p.c <= 0 {
                break
            }
            m := len(ans)
            if m >= 2 && ans[m-2] == p.ch && ans[m-1] == p.ch {
                continue
            }
            hasNext = true
            ans = append(ans, p.ch)
            cnt[i].c--
            break
        }
        if !hasNext {
            return string(ans)
        }
    }
}
```

```JavaScript [sol1-JavaScript]
var longestDiverseString = function(a, b, c) {
    const res = [];
    const arr = [[a, 'a'], [b, 'b'], [c, 'c']];
    
    while (true) {
        arr.sort((a, b) => b[0] - a[0]);
        let hasNext = false;
        for (const [i, [c, ch]] of arr.entries()) {
            if (c <= 0) {
                break;
            }
            const m = res.length;
            if (m >= 2 && res[m - 2] === ch && res[m - 1] === ch) {
                continue;
            }
            hasNext = true;
            res.push(ch);
            arr[i][0]--;
            break;
        }
        if (!hasNext) {
            break;
        }
    }
    
    return res.join('');
};
```

**复杂度分析**

- 时间复杂度：$O((a + b + c) \times C \log C)$，其中 $a, b, c$ 为给定的整数，$C$ 表示字母的种类，在本题中 $C = 3$。每次从待选的字母中选择一个字母需要执行一次排序，时间复杂度为 $O(C \log C)$，最多需要选择 $a + b + c$ 个字母。

- 空间复杂度：$O(C)$，在本题中 $C = 3$。需要 $O(C)$ 的空间存储字母的当前计数。
#### 方法一：模拟

**思路和算法**

构造回文整数有一个直观的方法：用原数的较高位的数字替换其对应的较低位。例如，对于数 $12345$，我们可以用 $1$ 替换 $5$，用 $2$ 替换 $4$，这样原数即变为回文整数 $12321$。

在这种方案中，我们修改的都是较低位的数字，因此构造出的新的整数与原数较为接近。大部分情况下，这种方案是最优解，但还有部分情况我们没有考虑到。

1. 构造的回文整数大于原数时，我们可以减小该回文整数的中间部分来缩小回文整数和原数的差距。例如，对于数 $99321$，我们将构造出回文整数 $99399$，实际上 $99299$ 更接近原数。
   - 当我们减小构造的回文整数时，可能导致回文整数的位数变化。例如，对于数 $100$，我们将构造出回文整数 $101$，减小其中间部分将导致位数减少。得到的回文整数形如 $999\dots 999$（$10^{\textit{len}}-1$）。

2. 构造的回文整数小于原数时，我们可以增大该回文整数的中间部分来缩小回文整数和原数的差距。例如，对于数 $12399$，我们将构造出回文整数 $12321$，实际上 $12421$ 更接近原数。
   - 当我们增大构造的回文整数时，可能导致回文整数的位数变化。例如，对于数 $998$，我们将构造出回文整数 $999$，增大其中间部分将导致位数增加。得到的回文整数形如 $100\dots 001$（$10^{\textit{len}}+1$）。

3. 构造的回文整数等于原数时，由于题目约定，我们需要排除该回文整数，在其他的可能情况中寻找最近的回文整数。

考虑到以上所有的可能，我们可以给出最终的方案：分别计算出以下每一种可能的方案对应的回文整数，在其中找到与原数最近且不等于原数的数即为答案。

1. 用原数的前半部分替换后半部分得到的回文整数。

2. 用原数的前半部分加一后的结果替换后半部分得到的回文整数。

3. 用原数的前半部分减一后的结果替换后半部分得到的回文整数。
   
4. 为防止位数变化导致构造的回文整数错误，因此直接构造 $999\dots 999$ 和 $100\dots 001$ 作为备选答案。

**代码**

```C++ [sol1-C++]
using ULL = unsigned long long;

class Solution {
public:
    vector<ULL> getCandidates(const string& n) {
        int len = n.length();
        vector<ULL> candidates = {
            (ULL)pow(10, len - 1) - 1,
            (ULL)pow(10, len) + 1,
        };
        ULL selfPrefix = stoull(n.substr(0, (len + 1) / 2));
        for (int i : {selfPrefix - 1, selfPrefix, selfPrefix + 1}) {
            string prefix = to_string(i);
            string candidate = prefix + string(prefix.rbegin() + (len & 1), prefix.rend());
            candidates.push_back(stoull(candidate));
        }
        return candidates;
    }

    string nearestPalindromic(string n) {
        ULL selfNumber = stoull(n), ans = -1;
        const vector<ULL>& candidates = getCandidates(n);
        for (auto& candidate : candidates) {
            if (candidate != selfNumber) {
                if (ans == -1 ||
                    llabs(candidate - selfNumber) < llabs(ans - selfNumber) ||
                    llabs(candidate - selfNumber) == llabs(ans - selfNumber) && candidate < ans) {
                    ans = candidate;
                }
            }
        }
        return to_string(ans);
    }
};
```

```Java [sol1-Java]
class Solution {
    public String nearestPalindromic(String n) {
        long selfNumber = Long.parseLong(n), ans = -1;
        List<Long> candidates = getCandidates(n);
        for (long candidate : candidates) {
            if (candidate != selfNumber) {
                if (ans == -1 ||
                    Math.abs(candidate - selfNumber) < Math.abs(ans - selfNumber) ||
                    Math.abs(candidate - selfNumber) == Math.abs(ans - selfNumber) && candidate < ans) {
                    ans = candidate;
                }
            }
        }
        return Long.toString(ans);
    }

    public List<Long> getCandidates(String n) {
        int len = n.length();
        List<Long> candidates = new ArrayList<Long>() {{
            add((long) Math.pow(10, len - 1) - 1);
            add((long) Math.pow(10, len) + 1);
        }};
        long selfPrefix = Long.parseLong(n.substring(0, (len + 1) / 2));
        for (long i = selfPrefix - 1; i <= selfPrefix + 1; i++) {
            StringBuffer sb = new StringBuffer();
            String prefix = String.valueOf(i);
            sb.append(prefix);
            StringBuffer suffix = new StringBuffer(prefix).reverse();
            sb.append(suffix.substring(len & 1));
            String candidate = sb.toString();
            try {
                candidates.add(Long.parseLong(candidate));
            } catch (NumberFormatException ex) {
                continue;
            }
        }
        return candidates;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public string NearestPalindromic(string n) {
        long selfNumber = long.Parse(n), ans = -1;
        IList<long> candidates = GetCandidates(n);
        foreach (long candidate in candidates) {
            if (candidate != selfNumber) {
                if (ans == -1 ||
                    Math.Abs(candidate - selfNumber) < Math.Abs(ans - selfNumber) ||
                    Math.Abs(candidate - selfNumber) == Math.Abs(ans - selfNumber) && candidate < ans) {
                    ans = candidate;
                }
            }
        }
        return ans.ToString();
    }

    public IList<long> GetCandidates(String n) {
        int len = n.Length;
        IList<long> candidates = new List<long>();
        candidates.Add((long) Math.Pow(10, len - 1) - 1);
        candidates.Add((long) Math.Pow(10, len) + 1);
        long selfPrefix = long.Parse(n.Substring(0, (len + 1) / 2));
        for (long i = selfPrefix - 1; i <= selfPrefix + 1; i++) {
            StringBuilder sb = new StringBuilder();
            string prefix = i.ToString();
            sb.Append(prefix);
            StringBuilder suffix = new StringBuilder();
            for (int j = prefix.Length - 1 - (len & 1); j >= 0; j--) {
                suffix.Append(prefix[j]);
            }
            sb.Append(suffix);
            string candidate = sb.ToString();
            try {
                candidates.Add(long.Parse(candidate));
            } catch (OverflowException ex) {
                continue;
            }
        }
        return candidates;
    }
}
```

```C [sol1-C]
#define MAX_STR_LEN 32
typedef unsigned long long ULL;

void reverseStr(char * str) {
    int n = strlen(str);
    for (int l = 0, r = n-1; l < r; l++, r--) {
        char c = str[l];
        str[l] = str[r];
        str[r] = c;
    }
}

ULL * getCandidates(const char * n, int * returnSize) {
    int len = strlen(n);
    int pos = 0;
    ULL * candidates = (ULL *)malloc(sizeof(ULL) * 5);
    candidates[pos++] = (ULL)pow(10, len) + 1;
    candidates[pos++] = (ULL)pow(10, len - 1) - 1;
    char str[MAX_STR_LEN], prefix[MAX_STR_LEN];
    char candidate[MAX_STR_LEN];
    snprintf(str, (len + 1) / 2 + 1, "%s", n);
    ULL selfPrefix = atol(str);    
    for (ULL i = selfPrefix - 1; i <= selfPrefix + 1; i++) {
        sprintf(prefix, "%ld", i);
        sprintf(candidate, "%s", prefix);
        reverseStr(prefix);
        sprintf(candidate + strlen(candidate), "%s", prefix + (len & 1));
        candidates[pos++] = atoll(candidate);
    }
    *returnSize = pos;
    return candidates;
}

char * nearestPalindromic(char * n){
    ULL selfNumber = atoll(n), ans = -1;
    int candidatesSize = 0;
    const ULL * candidates = getCandidates(n, &candidatesSize);
    for (int i = 0; i < candidatesSize; i++) {
        if (candidates[i] != selfNumber) {
            if (ans == -1 ||
                labs(candidates[i] - selfNumber) < labs(ans - selfNumber) ||
                labs(candidates[i] - selfNumber) == labs(ans - selfNumber) && candidates[i] < ans) {
                ans = candidates[i];
            }
        }
    }
    char * str = (char *)malloc(sizeof(char) * MAX_STR_LEN);
    sprintf(str, "%ld", ans);
    free(candidates);
    return str;
}
```

```Python [sol1-Python3]
class Solution:
    def nearestPalindromic(self, n: str) -> str:
        m = len(n)
        candidates = [10 ** (m - 1) - 1, 10 ** m + 1]
        selfPrefix = int(n[:(m + 1) // 2])
        for x in range(selfPrefix - 1, selfPrefix + 2):
            y = x if m % 2 == 0 else x // 10
            while y:
                x = x * 10 + y % 10
                y //= 10
            candidates.append(x)

        ans = -1
        selfNumber = int(n)
        for candidate in candidates:
            if candidate != selfNumber:
                if ans == -1 or \
                        abs(candidate - selfNumber) < abs(ans - selfNumber) or \
                        abs(candidate - selfNumber) == abs(ans - selfNumber) and candidate < ans:
                    ans = candidate
        return str(ans)
```

```go [sol1-Golang]
func nearestPalindromic(n string) string {
    m := len(n)
    candidates := []int{int(math.Pow10(m-1)) - 1, int(math.Pow10(m)) + 1}
    selfPrefix, _ := strconv.Atoi(n[:(m+1)/2])
    for _, x := range []int{selfPrefix - 1, selfPrefix, selfPrefix + 1} {
        y := x
        if m&1 == 1 {
            y /= 10
        }
        for ; y > 0; y /= 10 {
            x = x*10 + y%10
        }
        candidates = append(candidates, x)
    }

    ans := -1
    selfNumber, _ := strconv.Atoi(n)
    for _, candidate := range candidates {
        if candidate != selfNumber {
            if ans == -1 ||
                abs(candidate-selfNumber) < abs(ans-selfNumber) ||
                abs(candidate-selfNumber) == abs(ans-selfNumber) && candidate < ans {
                ans = candidate
            }
        }
    }
    return strconv.Itoa(ans)
}

func abs(x int) int {
    if x < 0 {
        return -x
    }
    return x
}
```

**复杂度分析**

- 时间复杂度：$O(\log n)$，其中 $n$ 为给定整数的大小。我们需要 $O(\log n)$ 的时间构造所有的可能情况。

- 空间复杂度：$O(\log n)$，其中 $n$ 为给定整数的大小。我们需要 $O(\log n)$ 的空间保存所有的可能情况。
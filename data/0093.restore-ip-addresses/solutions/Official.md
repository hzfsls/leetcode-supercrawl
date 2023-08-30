#### 方法一：回溯

**思路与算法**

由于我们需要找出**所有**可能复原出的 IP 地址，因此可以考虑使用回溯的方法，对所有可能的字符串分隔方式进行搜索，并筛选出满足要求的作为答案。

设题目中给出的字符串为 $s$。我们用递归函数 $\textit{dfs}(\textit{segId}, \textit{segStart})$ 表示我们正在从 $s[\textit{segStart}]$ 的位置开始，搜索 IP 地址中的第 $\textit{segId}$ 段，其中 $\textit{segId} \in \{0, 1, 2, 3\}$。由于 IP 地址的每一段必须是 $[0, 255]$ 中的整数，因此我们从 $\textit{segStart}$ 开始，从小到大依次枚举当前这一段 IP 地址的结束位置 $\textit{segEnd}$。如果满足要求，就递归地进行下一段搜索，调用递归函数 $\textit{dfs}(\textit{segId} + 1, \textit{segEnd} + 1)$。

特别地，由于 IP 地址的每一段不能有前导零，因此如果 $s[\textit{segStart}]$ 等于字符 $0$，那么 IP 地址的第 $\textit{segId}$ 段只能为 $0$，需要作为特殊情况进行考虑。

在搜索的过程中，如果我们已经得到了全部的 $4$ 段 IP 地址（即 $\textit{segId} = 4$），并且遍历完了整个字符串（即 $\textit{segStart} = |s|$，其中 $|s|$ 表示字符串 $s$ 的长度），那么就复原出了一种满足题目要求的 IP 地址，我们将其加入答案。在其它的时刻，如果**提前**遍历完了整个字符串，那么我们需要结束搜索，回溯到上一步。

**代码**

```C++ [sol1-C++]
class Solution {
private:
    static constexpr int SEG_COUNT = 4;

private:
    vector<string> ans;
    vector<int> segments;

public:
    void dfs(const string& s, int segId, int segStart) {
        // 如果找到了 4 段 IP 地址并且遍历完了字符串，那么就是一种答案
        if (segId == SEG_COUNT) {
            if (segStart == s.size()) {
                string ipAddr;
                for (int i = 0; i < SEG_COUNT; ++i) {
                    ipAddr += to_string(segments[i]);
                    if (i != SEG_COUNT - 1) {
                        ipAddr += ".";
                    }
                }
                ans.push_back(move(ipAddr));
            }
            return;
        }

        // 如果还没有找到 4 段 IP 地址就已经遍历完了字符串，那么提前回溯
        if (segStart == s.size()) {
            return;
        }

        // 由于不能有前导零，如果当前数字为 0，那么这一段 IP 地址只能为 0
        if (s[segStart] == '0') {
            segments[segId] = 0;
            dfs(s, segId + 1, segStart + 1);
        }

        // 一般情况，枚举每一种可能性并递归
        int addr = 0;
        for (int segEnd = segStart; segEnd < s.size(); ++segEnd) {
            addr = addr * 10 + (s[segEnd] - '0');
            if (addr > 0 && addr <= 0xFF) {
                segments[segId] = addr;
                dfs(s, segId + 1, segEnd + 1);
            } else {
                break;
            }
        }
    }

    vector<string> restoreIpAddresses(string s) {
        segments.resize(SEG_COUNT);
        dfs(s, 0, 0);
        return ans;
    }
};
```

```Java [sol1-Java]
class Solution {
    static final int SEG_COUNT = 4;
    List<String> ans = new ArrayList<String>();
    int[] segments = new int[SEG_COUNT];

    public List<String> restoreIpAddresses(String s) {
        segments = new int[SEG_COUNT];
        dfs(s, 0, 0);
        return ans;
    }

    public void dfs(String s, int segId, int segStart) {
        // 如果找到了 4 段 IP 地址并且遍历完了字符串，那么就是一种答案
        if (segId == SEG_COUNT) {
            if (segStart == s.length()) {
                StringBuffer ipAddr = new StringBuffer();
                for (int i = 0; i < SEG_COUNT; ++i) {
                    ipAddr.append(segments[i]);
                    if (i != SEG_COUNT - 1) {
                        ipAddr.append('.');
                    }
                }
                ans.add(ipAddr.toString());
            }
            return;
        }

        // 如果还没有找到 4 段 IP 地址就已经遍历完了字符串，那么提前回溯
        if (segStart == s.length()) {
            return;
        }

        // 由于不能有前导零，如果当前数字为 0，那么这一段 IP 地址只能为 0
        if (s.charAt(segStart) == '0') {
            segments[segId] = 0;
            dfs(s, segId + 1, segStart + 1);
        }

        // 一般情况，枚举每一种可能性并递归
        int addr = 0;
        for (int segEnd = segStart; segEnd < s.length(); ++segEnd) {
            addr = addr * 10 + (s.charAt(segEnd) - '0');
            if (addr > 0 && addr <= 0xFF) {
                segments[segId] = addr;
                dfs(s, segId + 1, segEnd + 1);
            } else {
                break;
            }
        }
    }
}
```

```Python [sol1-Python3]
class Solution:
    def restoreIpAddresses(self, s: str) -> List[str]:
        SEG_COUNT = 4
        ans = list()
        segments = [0] * SEG_COUNT
        
        def dfs(segId: int, segStart: int):
            # 如果找到了 4 段 IP 地址并且遍历完了字符串，那么就是一种答案
            if segId == SEG_COUNT:
                if segStart == len(s):
                    ipAddr = ".".join(str(seg) for seg in segments)
                    ans.append(ipAddr)
                return
            
            # 如果还没有找到 4 段 IP 地址就已经遍历完了字符串，那么提前回溯
            if segStart == len(s):
                return

            # 由于不能有前导零，如果当前数字为 0，那么这一段 IP 地址只能为 0
            if s[segStart] == "0":
                segments[segId] = 0
                dfs(segId + 1, segStart + 1)
            
            # 一般情况，枚举每一种可能性并递归
            addr = 0
            for segEnd in range(segStart, len(s)):
                addr = addr * 10 + (ord(s[segEnd]) - ord("0"))
                if 0 < addr <= 0xFF:
                    segments[segId] = addr
                    dfs(segId + 1, segEnd + 1)
                else:
                    break
        

        dfs(0, 0)
        return ans
```

```JavaScript [sol1-JavaScript]
var restoreIpAddresses = function(s) {
    const SEG_COUNT = 4;
    const segments = new Array(SEG_COUNT);
    const ans = [];

    const dfs = (s, segId, segStart) => {
        // 如果找到了 4 段 IP 地址并且遍历完了字符串，那么就是一种答案
        if (segId === SEG_COUNT) {
            if (segStart === s.length) {
                ans.push(segments.join('.'));
            }
            return;
        }

        // 如果还没有找到 4 段 IP 地址就已经遍历完了字符串，那么提前回溯
        if (segStart === s.length) {
            return;
        }

        // 由于不能有前导零，如果当前数字为 0，那么这一段 IP 地址只能为 0
        if (s.charAt(segStart) === '0') {
            segments[segId] = 0;
            dfs(s, segId + 1, segStart + 1);
        }

        // 一般情况，枚举每一种可能性并递归
        let addr = 0;
        for (let segEnd = segStart; segEnd < s.length; ++segEnd) {
            addr = addr * 10 + (s.charAt(segEnd) - '0');
            if (addr > 0 && addr <= 0xFF) {
                segments[segId] = addr;
                dfs(s, segId + 1, segEnd + 1);
            } else {
                break;
            }
        }
    }

    dfs(s, 0, 0);
    return ans;
};
```

```C [sol1-C]
#define SEG_COUNT 4
int segments[SEG_COUNT];
char** ans;
int ans_len;

void dfs(char* s, int segId, int segStart) {
    // 如果找到了 4 段 IP 地址并且遍历完了字符串，那么就是一种答案
    int len_s = strlen(s);
    if (segId == SEG_COUNT) {
        if (segStart == len_s) {
            char* ipAddr = (char*)malloc(sizeof(char) * (len_s + 4));
            int add = 0;
            for (int i = 0; i < SEG_COUNT; ++i) {
                int number = segments[i];
                if (number >= 100) {
                    ipAddr[add++] = number / 100 + '0';
                }
                if (number >= 10) {
                    ipAddr[add++] = number % 100 / 10 + '0';
                }
                ipAddr[add++] = number % 10 + '0';
                if (i != SEG_COUNT - 1) {
                    ipAddr[add++] = '.';
                }
            }
            ipAddr[add] = 0;
            ans = realloc(ans, sizeof(char*) * (ans_len + 1));
            ans[ans_len++] = ipAddr;
        }
        return;
    }

    // 如果还没有找到 4 段 IP 地址就已经遍历完了字符串，那么提前回溯
    if (segStart == len_s) {
        return;
    }

    // 由于不能有前导零，如果当前数字为 0，那么这一段 IP 地址只能为 0
    if (s[segStart] == '0') {
        segments[segId] = 0;
        dfs(s, segId + 1, segStart + 1);
    }

    // 一般情况，枚举每一种可能性并递归
    int addr = 0;
    for (int segEnd = segStart; segEnd < len_s; ++segEnd) {
        addr = addr * 10 + (s[segEnd] - '0');
        if (addr > 0 && addr <= 0xFF) {
            segments[segId] = addr;
            dfs(s, segId + 1, segEnd + 1);
        } else {
            break;
        }
    }
}

char** restoreIpAddresses(char* s, int* returnSize) {
    ans = (char**)malloc(0);
    ans_len = 0;
    dfs(s, 0, 0);
    (*returnSize) = ans_len;
    return ans;
}
```

```golang [sol1-Golang]
const SEG_COUNT = 4

var (
    ans []string
    segments []int
)

func restoreIpAddresses(s string) []string {
    segments = make([]int, SEG_COUNT)
    ans = []string{}
    dfs(s, 0, 0)
    return ans
}

func dfs(s string, segId, segStart int) {
    // 如果找到了 4 段 IP 地址并且遍历完了字符串，那么就是一种答案
    if segId == SEG_COUNT {
        if segStart == len(s) {
            ipAddr := ""
            for i := 0; i < SEG_COUNT; i++ {
                ipAddr += strconv.Itoa(segments[i])
                if i != SEG_COUNT - 1 {
                    ipAddr += "."
                }
            }
            ans = append(ans, ipAddr)
        }
        return
    }

    // 如果还没有找到 4 段 IP 地址就已经遍历完了字符串，那么提前回溯
    if segStart == len(s) {
        return
    }
    // 由于不能有前导零，如果当前数字为 0，那么这一段 IP 地址只能为 0
    if s[segStart] == '0' {
        segments[segId] = 0
        dfs(s, segId + 1, segStart + 1)
    }
    // 一般情况，枚举每一种可能性并递归
    addr := 0
    for segEnd := segStart; segEnd < len(s); segEnd++ {
        addr = addr * 10 + int(s[segEnd] - '0')
        if addr > 0 && addr <= 0xFF {
            segments[segId] = addr
            dfs(s, segId + 1, segEnd + 1)
        } else {
            break
        }
    }
}
```

**复杂度分析**

我们用 $\text{SEG\_COUNT} = 4$ 表示 IP 地址的段数。

- 时间复杂度：$O(3^\text{SEG\_COUNT} \times |s|)$。由于 IP 地址的每一段的位数不会超过 $3$，因此在递归的每一层，我们最多只会深入到下一层的 $3$ 种情况。由于 $\text{SEG\_COUNT} = 4$，对应着递归的最大层数，所以递归本身的时间复杂度为 $O(3^\text{SEG\_COUNT})$。如果我们复原出了一种满足题目要求的 IP 地址，那么需要 $O(|s|)$ 的时间将其加入答案数组中，因此总时间复杂度为 $O(3^\text{SEG\_COUNT} \times |s|)$。

- 空间复杂度：$O(\text{SEG\_COUNT})$，这里只计入除了用来存储答案数组以外的**额外空间复杂度**。递归使用的空间与递归的最大深度 $\text{SEG\_COUNT}$ 成正比。并且在上面的代码中，我们只额外使用了长度为 $\text{SEG\_COUNT}$ 的数组 $\textit{segments}$ 存储已经搜索过的 IP 地址，因此空间复杂度为 $O(\text{SEG\_COUNT})$。
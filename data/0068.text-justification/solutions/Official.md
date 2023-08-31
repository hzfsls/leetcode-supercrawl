## [68.文本左右对齐 中文官方题解](https://leetcode.cn/problems/text-justification/solutions/100000/wen-ben-zuo-you-dui-qi-by-leetcode-solut-dyeg)

#### 方法一：模拟

根据题干描述的贪心算法，对于每一行，我们首先确定最多可以放置多少单词，这样可以得到该行的空格个数，从而确定该行单词之间的空格个数。

根据题目中填充空格的细节，我们分以下三种情况讨论：

- 当前行是最后一行：单词左对齐，且单词之间应只有一个空格，在行末填充剩余空格；
- 当前行不是最后一行，且只有一个单词：该单词左对齐，在行末填充空格；
- 当前行不是最后一行，且不只一个单词：设当前行单词数为 $\textit{numWords}$，空格数为 $\textit{numSpaces}$，我们需要将空格均匀分配在单词之间，则单词之间应至少有 
  $$\textit{avgSpaces}=\Big\lfloor\dfrac{\textit{numSpaces}}{\textit{numWords}-1}\Big\rfloor$$
  个空格，对于多出来的  
  $$\textit{extraSpaces}=\textit{numSpaces}\bmod(\textit{numWords}-1)$$ 
  个空格，应填在前 $\textit{extraSpaces}$ 个单词之间。因此，前 $\textit{extraSpaces}$ 个单词之间填充 $\textit{avgSpaces}+1$ 个空格，其余单词之间填充 $\textit{avgSpaces}$ 个空格。

```Python [sol1-Python3]
# blank 返回长度为 n 的由空格组成的字符串
def blank(n: int) -> str:
    return ' ' * n

class Solution:
    def fullJustify(self, words: List[str], maxWidth: int) -> List[str]:
        ans = []
        right, n = 0, len(words)
        while True:
            left = right  # 当前行的第一个单词在 words 的位置
            sumLen = 0  # 统计这一行单词长度之和
            # 循环确定当前行可以放多少单词，注意单词之间应至少有一个空格
            while right < n and sumLen + len(words[right]) + right - left <= maxWidth:
                sumLen += len(words[right])
                right += 1

            # 当前行是最后一行：单词左对齐，且单词之间应只有一个空格，在行末填充剩余空格
            if right == n:
                s = " ".join(words[left:])
                ans.append(s + blank(maxWidth - len(s)))
                break

            numWords = right - left
            numSpaces = maxWidth - sumLen

            # 当前行只有一个单词：该单词左对齐，在行末填充空格
            if numWords == 1:
                ans.append(words[left] + blank(numSpaces))
                continue

            # 当前行不只一个单词
            avgSpaces = numSpaces // (numWords - 1)
            extraSpaces = numSpaces % (numWords - 1)
            s1 = blank(avgSpaces + 1).join(words[left:left + extraSpaces + 1])  # 拼接额外加一个空格的单词
            s2 = blank(avgSpaces).join(words[left + extraSpaces + 1:right])  # 拼接其余单词
            ans.append(s1 + blank(avgSpaces) + s2)

        return ans
```

```C++ [sol1-C++]
class Solution {
    // blank 返回长度为 n 的由空格组成的字符串
    string blank(int n) {
        return string(n, ' ');
    }

    // join 返回用 sep 拼接 [left, right) 范围内的 words 组成的字符串
    string join(vector<string> &words, int left, int right, string sep) {
        string s = words[left];
        for (int i = left + 1; i < right; ++i) {
            s += sep + words[i];
        }
        return s;
    }

public:
    vector<string> fullJustify(vector<string> &words, int maxWidth) {
        vector<string> ans;
        int right = 0, n = words.size();
        while (true) {
            int left = right; // 当前行的第一个单词在 words 的位置
            int sumLen = 0; // 统计这一行单词长度之和
            // 循环确定当前行可以放多少单词，注意单词之间应至少有一个空格
            while (right < n && sumLen + words[right].length() + right - left <= maxWidth) {
                sumLen += words[right++].length();
            }

            // 当前行是最后一行：单词左对齐，且单词之间应只有一个空格，在行末填充剩余空格
            if (right == n) {
                string s = join(words, left, n, " ");
                ans.emplace_back(s + blank(maxWidth - s.length()));
                return ans;
            }

            int numWords = right - left;
            int numSpaces = maxWidth - sumLen;

            // 当前行只有一个单词：该单词左对齐，在行末填充剩余空格
            if (numWords == 1) {
                ans.emplace_back(words[left] + blank(numSpaces));
                continue;
            }

            // 当前行不只一个单词
            int avgSpaces = numSpaces / (numWords - 1);
            int extraSpaces = numSpaces % (numWords - 1);
            string s1 = join(words, left, left + extraSpaces + 1, blank(avgSpaces + 1)); // 拼接额外加一个空格的单词
            string s2 = join(words, left + extraSpaces + 1, right, blank(avgSpaces)); // 拼接其余单词
            ans.emplace_back(s1 + blank(avgSpaces) + s2);
        }
    }
};
```

```Java [sol1-Java]
class Solution {
    public List<String> fullJustify(String[] words, int maxWidth) {
        List<String> ans = new ArrayList<String>();
        int right = 0, n = words.length;
        while (true) {
            int left = right; // 当前行的第一个单词在 words 的位置
            int sumLen = 0; // 统计这一行单词长度之和
            // 循环确定当前行可以放多少单词，注意单词之间应至少有一个空格
            while (right < n && sumLen + words[right].length() + right - left <= maxWidth) {
                sumLen += words[right++].length();
            }

            // 当前行是最后一行：单词左对齐，且单词之间应只有一个空格，在行末填充剩余空格
            if (right == n) {
                StringBuffer sb = join(words, left, n, " ");
                sb.append(blank(maxWidth - sb.length()));
                ans.add(sb.toString());
                return ans;
            }

            int numWords = right - left;
            int numSpaces = maxWidth - sumLen;

            // 当前行只有一个单词：该单词左对齐，在行末填充剩余空格
            if (numWords == 1) {
                StringBuffer sb = new StringBuffer(words[left]);
                sb.append(blank(numSpaces));
                ans.add(sb.toString());
                continue;
            }

            // 当前行不只一个单词
            int avgSpaces = numSpaces / (numWords - 1);
            int extraSpaces = numSpaces % (numWords - 1);
            StringBuffer sb = new StringBuffer();
            sb.append(join(words, left, left + extraSpaces + 1, blank(avgSpaces + 1))); // 拼接额外加一个空格的单词
            sb.append(blank(avgSpaces));
            sb.append(join(words, left + extraSpaces + 1, right, blank(avgSpaces))); // 拼接其余单词
            ans.add(sb.toString());
        }
    }

    // blank 返回长度为 n 的由空格组成的字符串
    public String blank(int n) {
        StringBuffer sb = new StringBuffer();
        for (int i = 0; i < n; ++i) {
            sb.append(' ');
        }
        return sb.toString();
    }

    // join 返回用 sep 拼接 [left, right) 范围内的 words 组成的字符串
    public StringBuffer join(String[] words, int left, int right, String sep) {
        StringBuffer sb = new StringBuffer(words[left]);
        for (int i = left + 1; i < right; ++i) {
            sb.append(sep);
            sb.append(words[i]);
        }
        return sb;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public IList<string> FullJustify(string[] words, int maxWidth) {
        IList<string> ans = new List<string>();
        int right = 0, n = words.Length;
        while (true) {
            int left = right; // 当前行的第一个单词在 words 的位置
            int sumLen = 0; // 统计这一行单词长度之和
            // 循环确定当前行可以放多少单词，注意单词之间应至少有一个空格
            while (right < n && sumLen + words[right].Length + right - left <= maxWidth) {
                sumLen += words[right++].Length;
            }

            // 当前行是最后一行：单词左对齐，且单词之间应只有一个空格，在行末填充剩余空格
            if (right == n) {
                StringBuilder sb = Join(words, left, n, " ");
                sb.Append(Blank(maxWidth - sb.Length));
                ans.Add(sb.ToString());
                return ans;
            }

            int numWords = right - left;
            int numSpaces = maxWidth - sumLen;

            // 当前行只有一个单词：该单词左对齐，在行末填充剩余空格
            if (numWords == 1) {
                StringBuilder sb = new StringBuilder(words[left]);
                sb.Append(Blank(numSpaces));
                ans.Add(sb.ToString());
                continue;
            }

            // 当前行不只一个单词
            int avgSpaces = numSpaces / (numWords - 1);
            int extraSpaces = numSpaces % (numWords - 1);
            StringBuilder curr = new StringBuilder();
            curr.Append(Join(words, left, left + extraSpaces + 1, Blank(avgSpaces + 1))); // 拼接额外加一个空格的单词
            curr.Append(Blank(avgSpaces));
            curr.Append(Join(words, left + extraSpaces + 1, right, Blank(avgSpaces))); // 拼接其余单词
            ans.Add(curr.ToString());
        }
    }

    // Blank 返回长度为 n 的由空格组成的字符串
    public string Blank(int n) {
        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < n; ++i) {
            sb.Append(' ');
        }
        return sb.ToString();
    }

    // Join 返回用 sep 拼接 [left, right) 范围内的 words 组成的字符串
    public StringBuilder Join(string[] words, int left, int right, string sep) {
        StringBuilder sb = new StringBuilder(words[left]);
        for (int i = left + 1; i < right; ++i) {
            sb.Append(sep);
            sb.Append(words[i]);
        }
        return sb;
    }
}
```

```go [sol1-Golang]
// blank 返回长度为 n 的由空格组成的字符串
func blank(n int) string {
    return strings.Repeat(" ", n)
}

func fullJustify(words []string, maxWidth int) (ans []string) {
    right, n := 0, len(words)
    for {
        left := right // 当前行的第一个单词在 words 的位置
        sumLen := 0   // 统计这一行单词长度之和
        // 循环确定当前行可以放多少单词，注意单词之间应至少有一个空格
        for right < n && sumLen+len(words[right])+right-left <= maxWidth {
            sumLen += len(words[right])
            right++
        }

        // 当前行是最后一行：单词左对齐，且单词之间应只有一个空格，在行末填充剩余空格
        if right == n {
            s := strings.Join(words[left:], " ")
            ans = append(ans, s+blank(maxWidth-len(s)))
            return
        }

        numWords := right - left
        numSpaces := maxWidth - sumLen

        // 当前行只有一个单词：该单词左对齐，在行末填充剩余空格
        if numWords == 1 {
            ans = append(ans, words[left]+blank(numSpaces))
            continue
        }

        // 当前行不只一个单词
        avgSpaces := numSpaces / (numWords - 1)
        extraSpaces := numSpaces % (numWords - 1)
        s1 := strings.Join(words[left:left+extraSpaces+1], blank(avgSpaces+1)) // 拼接额外加一个空格的单词
        s2 := strings.Join(words[left+extraSpaces+1:right], blank(avgSpaces))  // 拼接其余单词
        ans = append(ans, s1+blank(avgSpaces)+s2)
    }
}
```

```JavaScript [sol1-JavaScript]
const fullJustify = (words, maxWidth) => {
    const ans = [];
    let right = 0, n = words.length;
    while (true) {
        const left = right; // 当前行的第一个单词在 words 的位置
        let sumLen = 0; // 统计这一行单词长度之和
        while (right < n && sumLen + words[right].length + right - left <= maxWidth) {
            sumLen += words[right].length;
            right++;
        }

        // 当前行是最后一行：单词左对齐，且单词之间应只有一个空格，在行末填充剩余空格
        if (right === n) {
            const s = words.slice(left).join(' ');
            ans.push(s + blank(maxWidth - s.length));
            break;
        }
        const numWords = right - left;
        const numSpaces = maxWidth - sumLen;

        // 当前行只有一个单词：该单词左对齐，在行末填充空格
        if (numWords === 1) {
            ans.push(words[left] + blank(numSpaces));
            continue;
        }
        
        // 当前行不只一个单词
        const avgSpaces = Math.floor(numSpaces / (numWords - 1));
        const extraSpaces = numSpaces % (numWords - 1);
        const s1 = words.slice(left, left + extraSpaces + 1).join(blank(avgSpaces + 1)); // 拼接额外加一个空格的单词
        const s2 = words.slice(left + extraSpaces + 1, right).join(blank(avgSpaces)); // 拼接其余单词
        ans.push(s1 + blank(avgSpaces) + s2);
    }
    return ans;
}

const blank = (n) => {
    return new Array(n).fill(' ').join('');
}
```

**复杂度分析**

- 时间复杂度：$O(m)$，其中 $m$ 是数组 $\textit{words}$ 中所有字符串的长度之和。

- 空间复杂度：$O(m)$。
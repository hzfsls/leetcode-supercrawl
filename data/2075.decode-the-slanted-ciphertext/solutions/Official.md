#### 方法一：模拟

**思路与算法**

我们可以通过模拟原字符串放置到矩阵的流程来从加密字符串中得到原字符串。

对于给定的编码后字符串 $\textit{encodedText}$ 和辅助矩阵的行数 $\textit{rows}$，辅助矩阵的列数满足 $\textit{cols} = \textit{len}(\textit{encodedText}) / \textit{rows}$，其中 $\textit{lens}(\dots)$ 为字符串的长度。

为了模拟编码过程，我们需要从左至右枚举每一条左上到右下的路径，并按顺序记录所有经过的字符。我们用坐标 $(r, c)$ 来记录当前位置的行数与列数，该坐标在加密字符串中对应的字符即为 $\textit{encodedText}[r \times \textit{cols} + c]$。在遍历第 $i\ (0 \le i < \textit{cols})$ 条路径时，坐标初始值为 $(0, i)$；当记录完成坐标 $(r, c)$ 对应字符后，我们需要判断当前坐标右下的坐标 $(r + 1, c + 1)$ 是否合法（即是否辅助矩阵内）：如果坐标合法，则我们继续记录该坐标的字符；反之则从头开始遍历下一条路径。

当遍历完成所有路径后，我们将得到的字符串删去末尾的空格，即为编码前的原字符串。我们将该字符串返回作为答案。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    string decodeCiphertext(string encodedText, int rows) {
        int cols = encodedText.size() / rows;   // 辅助矩阵的列数
        string res;   // 遍历到的字符
        for (int i = 0; i < cols; ++i){
            // 从左至右枚举每一条路径
            int r = 0;
            int c = i;
            while (r < rows && c < cols){
                res.push_back(encodedText[r*cols+c]);
                ++r;
                ++c;
            }
        }
        // 删去末尾空格
        while (res.size() and res.back() == ' '){
            res.pop_back();
        }
        return res;
    }
};
```


```Python [sol1-Python3]
class Solution:
    def decodeCiphertext(self, encodedText: str, rows: int) -> str:
        cols = len(encodedText) // rows   # 辅助矩阵的列数
        res = []   # 遍历到的字符
        for i in range(cols):
            # 从左至右枚举每一条路径
            r = 0
            c = i
            while r < rows and c < cols:
                res.append(encodedText[r*cols+c])
                r += 1
                c += 1
        # 删去末尾空格
        while res and res[-1] == ' ':
            res.pop()
        return "".join(res)
```


**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 为 $\textit{encodedText}$ 的长度。即为遍历加密字符串生成解密字符串的时间复杂度。

- 空间复杂度：由于不同语言的字符串实现与方法不同，空间复杂度也有所不同。对于 $\texttt{C++}$ 解法，空间复杂度为 $O(1)$；而对于 $\texttt{Python}$ 解法，空间复杂度为 $O(n)$。
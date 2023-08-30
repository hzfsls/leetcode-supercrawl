#### 方法一：模拟

**思路与算法**

创建一个新字符串 $\textit{result}$ 来存储答案。对于 $s$ 每个下标 $i$，将 $\textit{result}[\textit{indices}[i]]$ 处的字符设成 $s[i]$ 即可。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    string restoreString(string s, vector<int>& indices) {
        int length = s.length();
        string result(length, 0);

        for(int i = 0; i < length; i++) {
            result[indices[i]] = s[i];
        }
        return result;
    }
};
```

```Java [sol1-Java]
class Solution {
    public String restoreString(String s, int[] indices) {
        int length = s.length();
        char[] result = new char[length];

        for (int i = 0; i < length; i++) {
            result[indices[i]] = s.charAt(i);
        }
        return new String(result);
    }
}
```

```JavaScript [sol1-JavaScript]
var restoreString = function(s, indices) {
    const length = s.length;
    const result = new Array(length);
    
    for (let i = 0; i < length; ++i) {
        result[indices[i]] = s.charAt(i);
    }
    
    return result.join('');
};
```

```Python [sol1-Python3]
class Solution:
    def restoreString(self, s: str, indices: List[int]) -> str:
        length = len(s)
        result = [""] * length
        for i, ch in enumerate(s):
            result[indices[i]] = ch
        return "".join(result)
```

**复杂度分析**

- 时间复杂度：$O(N)$，其中 $N$ 为字符串 $s$ 的长度。我们只需对字符串 $s$ 执行一次线性扫描即可。

- 空间复杂度：$O(1)$ 或 $O(N)$。除开辟的存储答案的字符串外，我们只需要常数空间存放若干变量。如果使用的语言不允许对字符串进行修改，我们还需要 $O(N)$ 的空间临时存储答案。

#### 方法二：原地修改

**思路与算法**

本题也可以通过原地修改输入数据的方式来求解。

直观的想法是：对于下标 $i$，需要把字符 $s[i]$ 移动到 $\textit{indices}[i]$ 的位置上；然后，我们前进到位置 $\textit{indices}[i]$，并将字符 $s[\textit{indices}[i]]$ 移动到 $\textit{indices}[\textit{indices}[i]]$ 的位置上。类似的过程以此类推，直到最终回到起点 $i$。此时，封闭路径 $i \to \textit{indices}[i] \to \textit{indices}[\textit{indices}[i]] \to ... \to i$ 上的所有字符，都已经被设置成正确的值。

我们只要找到 $\textit{indices}[i]$ 中所有这样的封闭路径，并进行对应的移动操作，就能够得到最终的答案。

这样做有一个小小的问题：当在第二步试图把字符 $s[\textit{indices}[i]]$ 移动到 $\textit{indices}[\textit{indices}[i]]$ 的位置上时，会发现字符 $s[\textit{indices}[i]]$ 已经在第一步被覆写了。因此，在每一步移动前，需要先额外记录目标位置处字符的原有值。

另一个隐含的问题是如何避免处理重复的封闭路径。为了解决此问题，我们每处理一个封闭路径，就将该路径上的 $\textit{indices}$ 数组的值设置成**下标自身**。这样，当某个封闭路径被处理完毕后，扫描到该路径的另一个下标时，就不会处理该封闭路径了。

由于许多语言中的字符串类型都是**不可更改的**，实现原地修改较为麻烦，因此下面只给出 `C++` 的参考代码。

**代码**

```C++ [sol2-C++]
class Solution {
public:
    string restoreString(string s, vector<int>& indices) {
        int length = s.length();
        for (int i = 0; i < length; i++) {
            if (indices[i] != i) {
                char ch = s[i]; // 当前需要被移动的字符
                int idx = indices[i]; // 该字符需要被移动的目标位置
                while (idx != i) {
                    swap(s[idx], ch); // 使用 swap 函数，在覆写 s[idx] 之前，先将其原始值赋给变量 ch
                    swap(indices[idx], idx); // 将封闭路径中的 indices 数组的值设置成下标自身
                }
                // 退出循环后，还要再覆写起点处的字符
                s[i] = ch;
                indices[i] = i;
            }
        }
        return s;
    }
};
```

**复杂度分析**

- 时间复杂度：$O(N)$，其中 $N$ 为字符串 $s$ 的长度。尽管代码看上去有两层循环，但因为不会处理相同的封闭路径，每个下标实际上只被处理了一次，故时间复杂度是线性的。

- 空间复杂度：$O(1)$。我们只需开辟常量大小的额外空间。
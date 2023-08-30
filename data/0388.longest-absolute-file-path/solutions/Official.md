#### 方法一：栈

**思路与算法**

题目中需求出文件系统中文件绝对路径的最大长度。首先观察文件绝对路径的特征，文件名一定包含 $\texttt{`.'}$，此时文件的绝对路径为 $\texttt{x/y/.../a.b}$，其中 $\texttt{x,y}$ 代表文件夹的名称，$\texttt{a.b}$ 代表文件名。我们可以观察到文件系统实际为树形结构，文件一定为树中的叶子节点，文件夹可以为根节点也可以为叶子节点，题目中给定的文件系统字符串实际为树按照前序遍历的结果，连续的 $\texttt{`\verb|\|t'}$ 的个数代表当前节点的深度，相邻的文件名之间都以 $\texttt{`\verb|\|n'}$ 进行隔开。

假设当前的路径为 $\texttt{x/y/z}$，其中 $\texttt{x,y,z}$ 的文件名长度为分别为 $l_x,l_y,l_z$，则路径 $\texttt{x, x/y, x/y/z}$ 的长度分别为 $l_x, l_x + l_y + 1, l_x + l_y + l_z + 2$。我们利用栈保存当前已遍历路径的长度，栈中元素的个数即为当前路径的深度，栈顶元素即为当前路径的长度。设根节点的深度为 $1$，字符串中连续的 $\texttt{`\verb|\|t'}$ 的个数加 $1$ 即为当前节点的深度 $\textit{depth}$，设当前节点的文件名为 $\texttt{q}$，当前节点的文件名长度为 $l_p$，根据节点深度 $\textit{depth}$ 有以下判断：

+ 如果当前节点的深度大于当前路径的深度，则表明当前节点为栈顶节点的孩子节点，设当前栈顶节点的长度为 $\textit{t}$，栈顶节点的路径为 $\texttt{p}$，则此时当前文件的路径应该为 $\texttt{p/q}$，则此时当前文件的路径长度为 $t + l_p + 1$。

+ 如果当前节点的深度小于当前路径的深度，则表明当前节点并不是栈顶节点的孩子节点，按照先序遍历的顺序，则此时需要进行回退直到栈顶节点为当前节点的父亲节点，然后再求出当前节点的路径与长度。

+ 由于题目只需要求出文件的长度即可，因此我们在实际运算中在栈中不需要保存完整的路径名称，只需要保存每个路径的长度即可。检测当前节点的文件名的长度并标记当前的文件名是文件还是文件夹，如果当前的字符串为文件，则求出当前文件绝对路径的长度。遍历所有可能的文件长度，即可找到文件绝对路径的最大长度。

**代码**

```Python [sol1-Python3]
class Solution:
    def lengthLongestPath(self, input: str) -> int:
        st = []
        ans, i, n = 0, 0, len(input)
        while i < n:
            # 检测当前文件的深度
            depth = 1
            while i < n and input[i] == '\t':
                depth += 1
                i += 1

            # 统计当前文件名的长度
            length, isFile = 0, False
            while i < n and input[i] != '\n':
                if input[i] == '.':
                    isFile = True
                length += 1
                i += 1
            i += 1  # 跳过换行符

            while len(st) >= depth:
                st.pop()
            if st:
                length += st[-1] + 1
            if isFile:
                ans = max(ans, length)
            else:
                st.append(length)
        return ans
```

```Java [sol1-Java]
class Solution {
    public int lengthLongestPath(String input) {
        int n = input.length();
        int pos = 0;
        int ans = 0;
        Deque<Integer> stack = new ArrayDeque<Integer>();

        while (pos < n) {
            /* 检测当前文件的深度 */
            int depth = 1;
            while (pos < n && input.charAt(pos) == '\t') {
                pos++;
                depth++;
            }
            /* 统计当前文件名的长度 */
            boolean isFile = false;  
            int len = 0;   
            while (pos < n && input.charAt(pos) != '\n') {
                if (input.charAt(pos) == '.') {
                    isFile = true;
                }
                len++;
                pos++;
            }
            /* 跳过当前的换行符 */
            pos++;

            while (stack.size() >= depth) {
                stack.pop();
            }
            if (!stack.isEmpty()) {
                len += stack.peek() + 1;
            }
            if (isFile) {
                ans = Math.max(ans, len);
            } else {
                stack.push(len);
            }
        }
        return ans;
    }
}
```

```C++ [sol1-C++]
class Solution {
public:
    int lengthLongestPath(string input) {
        int n = input.size();
        int pos = 0;
        int ans = 0;
        stack<int> st;

        while (pos < n) {
            /* 检测当前文件的深度 */
            int depth = 1;
            while (pos < n && input[pos] == '\t') {
                pos++;
                depth++;
            }
            /* 统计当前文件名的长度 */   
            int len = 0; 
            bool isFile = false;     
            while (pos < n && input[pos] != '\n') {
                if (input[pos] == '.') {
                    isFile = true;
                }
                len++;
                pos++;
            }
            /* 跳过换行符 */
            pos++;

            while (st.size() >= depth) {
                st.pop();
            }
            if (!st.empty()) {
                len += st.top() + 1;
            }
            if (isFile) {
                ans = max(ans, len);
            } else {
                st.emplace(len);
            }
        }
        return ans;
    }
};
```

```C# [sol1-C#]
public class Solution {
    public int LengthLongestPath(string input) {
        int n = input.Length;
        int pos = 0;
        int ans = 0;
        Stack<int> stack = new Stack<int>();

        while (pos < n) {
            /* 检测当前文件的深度 */
            int depth = 1;
            while (pos < n && input[pos] == '\t') {
                pos++;
                depth++;
            }
            /* 统计当前文件名的长度 */
            bool isFile = false;  
            int len = 0;   
            while (pos < n && input[pos] != '\n') {
                if (input[pos] == '.') {
                    isFile = true;
                }
                len++;
                pos++;
            }
            /* 跳过当前的换行符 */
            pos++;

            while (stack.Count >= depth) {
                stack.Pop();
            }
            if (stack.Count > 0) {
                len += stack.Peek() + 1;
            }
            if (isFile) {
                ans = Math.Max(ans, len);
            } else {
                stack.Push(len);
            }
        }
        return ans;
    }
}
```

```C [sol1-C]
#define MAX(a, b) ((a) > (b) ? (a) : (b))

int lengthLongestPath(char * input){
    int n = strlen(input);
    int pos = 0;
    int ans = 0;
    int * stack = (int *)malloc(sizeof(int) * n);
    int top = 0;

    while (pos < n) {
        /* 检测当前文件的深度 */
        int depth = 1;
        while (pos < n && input[pos] == '\t') {
            pos++;
            depth++;
        }
        /* 统计当前文件名的长度 */
        bool isFile = false;  
        int len = 0;   
        while (pos < n && input[pos] != '\n') {
            if (input[pos] == '.') {
                isFile = true;
            }
            len++;
            pos++;
        }
        /* 跳过当前的换行符 */
        pos++;

        while (top >= depth) {
            top--;
        }
        if (top > 0) {
            len += stack[top - 1] + 1;
        }
        if (isFile) {
            ans = MAX(ans, len);
        } else {
            stack[top++] = len;
        }
    }
    free(stack);
    return ans;
}
```

```JavaScript [sol1-JavaScript]
var lengthLongestPath = function(input) {
    const n = input.length;
    let pos = 0;
    let ans = 0;
    const stack = [];

    while (pos < n) {
        /* 检测当前文件的深度 */
        let depth = 1;
        while (pos < n && input[pos] === '\t') {
            pos++;
            depth++;
        }
        /* 统计当前文件名的长度 */
        let isFile = false;  
        let len = 0;   
        while (pos < n && input[pos] !== '\n') {
            if (input[pos] === '.') {
                isFile = true;
            }
            len++;
            pos++;
        }
        /* 跳过当前的换行符 */
        pos++;

        while (stack.length >= depth) {
            stack.pop();
        }
        if (stack.length) {
            len += stack[stack.length - 1] + 1;
        }
        if (isFile) {
            ans = Math.max(ans, len);
        } else {
            stack.push(len);
        }
    }
    return ans;
};
```

```go [sol1-Golang]
func lengthLongestPath(input string) (ans int) {
    st := []int{}
    for i, n := 0, len(input); i < n; {
        // 检测当前文件的深度
        depth := 1
        for ; i < n && input[i] == '\t'; i++ {
            depth++
        }

        // 统计当前文件名的长度
        length, isFile := 0, false
        for ; i < n && input[i] != '\n'; i++ {
            if input[i] == '.' {
                isFile = true
            }
            length++
        }
        i++ // 跳过换行符

        for len(st) >= depth {
            st = st[:len(st)-1]
        }
        if len(st) > 0 {
            length += st[len(st)-1] + 1
        }
        if isFile {
            ans = max(ans, length)
        } else {
            st = append(st, length)
        }
    }
    return
}

func max(a, b int) int {
    if b > a {
        return b
    }
    return a
}
```

**复杂度分析**

+ 时间复杂度：$O(n)$，其中 $n$ 是字符串 $\textit{input}$ 的长度。需要遍历一遍字符串，因此时间复杂度为 $O(n)$。

+ 空间复杂度：$O(n)$，其中 $n$ 是字符串 $\textit{input}$ 的长度。需用栈保存当前路径中每个文件夹的长度，当前路径的最大深度为 $n$，因此栈中最多有 $n$ 个元素，因此空间复杂度为 $O(n)$。

#### 方法二：遍历

**思路与算法**

假设当前的路径为 $\texttt{x/y/z}$，其中 $\texttt{x,y,z}$ 的文件名长度为分别为 $l_x,l_y,l_z$，则路径 $\texttt{x, x/y, x/y/z}$ 的长度分别为 $l_x, l_x + l_y + 1, l_x + l_y + l_z + 2$。我们用 $\textit{level}[i]$ 保存当前已遍历路径中第 $i$ 层目录的长度。设根目录为第 $1$ 层，字符串中连续的 $\texttt{`\verb|\|t'}$ 的个数加 $1$ 即为当前路径的层次深度 $\textit{depth}$，设当前节点的文件名为 $\texttt{p}$，当前节点的文件名长度为 $l_p$，根据当前文件的层次深度 $\textit{depth}$ 有以下判断：

+ 当前文件绝对路径也就等于当前路径中第 $\textit{depth} - 1$ 层的绝对路径加上 $\texttt{`/'}$，然后再加上当前的文件名，当前文件绝对路径的长度也就等于 $\textit{level}[\textit{depth} - 1] + 1 + l_p$。特殊情况需要处理，当前为根目录时，不需要添加额外的 $\texttt{`/'}$。如果当前文件名为文件夹时，则需要更新当前第 $\textit{depth}$ 层的路径长度。

+ 由于每次目录按照向下遍历时，是按照层级目录往下进行遍历的，即每次只能遍历完第 $i$ 层目录，才能遍历到第 $i+1$ 层目录，因此我们在向下进行遍历第 $i$ 层目录时，实际上前 $i-1$ 层的目录路径不会发生改变。当从 $i$ 层目录回退到第 $j$ 层时，$i > j$，此时前 $i-1$ 层绝对路径是保持不变的，因此可以直接利用已经保存的前 $i-1$ 层的绝对路径长度。

+ 由于题目只需要求出文件的长度即可，因此我们在实际运算中不需要保存完整的路径名称，只需要保存每个路径的长度即可。检测当前节点的文件名的长度并标记当前的文件名是文件还是文件夹，如果当前的文件名为文件，则求出当前文件绝对路径的长度。遍历所有可能的文件路径长度，即可找到文件绝对路径的最大长度。

**代码**

```Python [sol2-Python3]
class Solution:
    def lengthLongestPath(self, input: str) -> int:
        ans, i, n = 0, 0, len(input)
        level = [0] * (n + 1)
        while i < n:
            # 检测当前文件的深度
            depth = 1
            while i < n and input[i] == '\t':
                depth += 1
                i += 1

            # 统计当前文件名的长度
            length, isFile = 0, False
            while i < n and input[i] != '\n':
                if input[i] == '.':
                    isFile = True
                length += 1
                i += 1
            i += 1  # 跳过换行符

            if depth > 1:
                length += level[depth - 1] + 1
            if isFile:
                ans = max(ans, length)
            else:
                level[depth] = length
        return ans
```

```Java [sol2-Java]
class Solution {
    public int lengthLongestPath(String input) {
        int n = input.length();
        int pos = 0;
        int ans = 0;
        int[] level = new int[n + 1];

        while (pos < n) {
            /* 检测当前文件的深度 */
            int depth = 1;
            while (pos < n && input.charAt(pos) == '\t') {
                pos++;
                depth++;
            }
            /* 统计当前文件名的长度 */   
            int len = 0; 
            boolean isFile = false;     
            while (pos < n && input.charAt(pos) != '\n') {
                if (input.charAt(pos) == '.') {
                    isFile = true;
                }
                len++;
                pos++;
            }
            /* 跳过换行符 */
            pos++;

            if (depth > 1) {
                len += level[depth - 1] + 1;
            }
            if (isFile) {
                ans = Math.max(ans, len);
            } else {
                level[depth] = len;
            }
        }
        return ans;
    }
}
```

```C++ [sol2-C++]
class Solution {
public:
    int lengthLongestPath(string input) {
        int n = input.size();
        int pos = 0;
        int ans = 0;
        vector<int> level(n + 1);

        while (pos < n) {
            /* 检测当前文件的深度 */
            int depth = 1;
            while (pos < n && input[pos] == '\t') {
                pos++;
                depth++;
            }
            /* 统计当前文件名的长度 */   
            int len = 0; 
            bool isFile = false;     
            while (pos < n && input[pos] != '\n') {
                if (input[pos] == '.') {
                    isFile = true;
                }
                len++;
                pos++;
            }
            /* 跳过换行符 */
            pos++;

            if (depth > 1) {
                len += level[depth - 1] + 1;
            }
            if (isFile) {
                ans = max(ans, len);
            } else {
                level[depth] = len;
            }
        }
        return ans;
    }
};
```

```C# [sol2-C#]
public class Solution {
    public int LengthLongestPath(string input) {
        int n = input.Length;
        int pos = 0;
        int ans = 0;
        int[] level = new int[n + 1];

        while (pos < n) {
            /* 检测当前文件的深度 */
            int depth = 1;
            while (pos < n && input[pos] == '\t') {
                pos++;
                depth++;
            }
            /* 统计当前文件名的长度 */   
            int len = 0; 
            bool isFile = false;     
            while (pos < n && input[pos] != '\n') {
                if (input[pos] == '.') {
                    isFile = true;
                }
                len++;
                pos++;
            }
            /* 跳过换行符 */
            pos++;

            if (depth > 1) {
                len += level[depth - 1] + 1;
            }
            if (isFile) {
                ans = Math.Max(ans, len);
            } else {
                level[depth] = len;
            }
        }
        return ans;
    }
}
```

```C [sol2-C]
#define MAX(a, b) ((a) > (b) ? (a) : (b))

int lengthLongestPath(char * input){
    int n = strlen(input);
    int pos = 0;
    int ans = 0;
    int * level = (int *)malloc(sizeof(int) * (n + 1));
    memset(level, 0, sizeof(int) * (n + 1));

    while (pos < n) {
        /* 检测当前文件的深度 */
        int depth = 1;
        while (pos < n && input[pos] == '\t') {
            pos++;
            depth++;
        }
        /* 统计当前文件名的长度 */
        bool isFile = false;  
        int len = 0;   
        while (pos < n && input[pos] != '\n') {
            if (input[pos] == '.') {
                isFile = true;
            }
            len++;
            pos++;
        }
        /* 跳过当前的换行符 */
        pos++;

        if (depth > 1) {
            len += level[depth - 1] + 1;
        }
        if (isFile) {
            ans = MAX(ans, len);
        } else {
            level[depth] = len;
        }
    }
    free(level);
    return ans;
}
```

```JavaScript [sol2-JavaScript]
var lengthLongestPath = function(input) {
    const n = input.length;
    let pos = 0;
    let ans = 0;
    const level = new Array(n + 1).fill(0);

    while (pos < n) {
        /* 检测当前文件的深度 */
        let depth = 1;
        while (pos < n && input[pos] === '\t') {
            pos++;
            depth++;
        }
        /* 统计当前文件名的长度 */   
        let len = 0; 
        let isFile = false;     
        while (pos < n && input[pos] !== '\n') {
            if (input[pos] === '.') {
                isFile = true;
            }
            len++;
            pos++;
        }
        /* 跳过换行符 */
        pos++;

        if (depth > 1) {
            len += level[depth - 1] + 1;
        }
        if (isFile) {
            ans = Math.max(ans, len);
        } else {
            level[depth] = len;
        }
    }
    return ans;
}
```

```go [sol2-Golang]
func lengthLongestPath(input string) (ans int) {
    n := len(input)
    level := make([]int, n+1)
    for i := 0; i < n; {
        // 检测当前文件的深度
        depth := 1
        for ; i < n && input[i] == '\t'; i++ {
            depth++
        }

        // 统计当前文件名的长度
        length, isFile := 0, false
        for ; i < n && input[i] != '\n'; i++ {
            if input[i] == '.' {
                isFile = true
            }
            length++
        }
        i++ // 跳过换行符

        if depth > 1 {
            length += level[depth-1] + 1
        }
        if isFile {
            ans = max(ans, length)
        } else {
            level[depth] = length
        }
    }
    return
}

func max(a, b int) int {
    if b > a {
        return b
    }
    return a
}
```

**复杂度分析**

+ 时间复杂度：$O(n)$，其中 $n$ 是字符串 $\textit{input}$ 的长度。需要遍历一遍字符串，因此时间复杂度为 $O(n)$。

+ 空间复杂度：$O(n)$，其中 $n$ 是字符串 $\textit{input}$ 的长度。需要保存当前路径中每一层文件的长度，路径中最大深度为 $n$，因此需要 $O(n)$ 的空间复杂度，因此空间复杂度为 $O(n)$。
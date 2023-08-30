#### 方法一：哈希表

我们遍历字符串 $s$，并用一个哈希集合（HashSet）存储所有长度为 $k$ 的子串。在遍历完成后，只需要判断哈希集合中是否有 $2^k$ 项即可，这是因为长度为 $k$ 的二进制串的数量为 $2^k$。

注意到如果 $s$ 包含 $2^k$ 个长度为 $k$ 的二进制串，那么它的长度至少为 $2^k+k-1$。因此我们可以在遍历前判断 $s$ 是否足够长。

```C++ [sol1-C++]
class Solution {
public:
    bool hasAllCodes(string s, int k) {
        if (s.size() < (1 << k) + k - 1) {
            return false;
        }

        unordered_set<string> exists;
        for (int i = 0; i + k <= s.size(); ++i) {
            exists.insert(move(s.substr(i, k)));
        }
        return exists.size() == (1 << k);
    }
};
```

```C++ [sol1-C++17]
class Solution {
public:
    bool hasAllCodes(string s, int k) {
        if (s.size() < (1 << k) + k - 1) {
            return false;
        }

        string_view sv(s);
        unordered_set<string_view> exists;
        for (int i = 0; i + k <= s.size(); ++i) {
            exists.insert(sv.substr(i, k));
        }
        return exists.size() == (1 << k);
    }
};
```

```Python [sol1-Python3]
class Solution:
    def hasAllCodes(self, s: str, k: int) -> bool:
        if len(s) < (1 << k) + k - 1:
            return False
        
        exists = set(s[i:i+k] for i in range(len(s) - k + 1))
        return len(exists) == (1 << k)
```

```Java [sol1-Java]
class Solution {
    public boolean hasAllCodes(String s, int k) {
        if (s.length() < (1 << k) + k - 1) {
            return false;
        }

        Set<String> exists = new HashSet<String>();
        for (int i = 0; i + k <= s.length(); ++i) {
            exists.add(s.substring(i, i + k));
        }
        return exists.size() == (1 << k);
    }
}
```

**复杂度分析**

- 时间复杂度：$O(k * |s|)$，其中 $|s|$ 是字符串 $s$ 的长度。将长度为 $k$ 的字符串加入哈希集合的时间复杂度为 $O(k)$，即为计算哈希值的时间。

- 空间复杂度：$O(k * 2^k)$。哈希集合中最多有 $2^k$ 项，每一项是一个长度为 $k$ 的字符串。

#### 方法二：哈希表 + 滑动窗口

我们可以借助滑动窗口，对方法一进行优化。

假设我们当前遍历到的长度为 $k$ 的子串为

$$
s_i, s_{i+1}, \cdots, s_{i+k-1}
$$

它的下一个子串为

$$
s_{i+1}, s_{i+2}, \cdots, s_{i+k}
$$

由于这些子串都是二进制串，我们可以将其表示成对应的十进制整数的形式，即

$$
\begin{aligned}
    & \textit{num}_i &= s_i * 2^{k-1} + s_{i+1} * 2^{k-2} + \cdots + s_{i+k-1} * 2^0 \\
    & \textit{num}_{i+1} &= s_{i+1} * 2^{k-1} + s_{i+2} * 2^{k-2} + \cdots + s_{i+k} * 2^0 \\
\end{aligned}
$$

那么我们可以将这些十进制整数作为哈希表中的项。由于每一个长度为 $k$ 的二进制串都唯一对应了一个十进制整数，因此这样做与方法一是一致的。与二进制串本身不同的是，我们可以在 $O(1)$ 的时间内通过 $\textit{num}_i$ 得到 $\textit{num}_{i+1}$，即：

$$
num_{i+1} = (num_{i} - s_i * 2^{k-1}) * 2 + s_{i+k}
$$

这样以来，我们在遍历 $s$ 的过程中只维护子串对应的十进制整数，而不需要对字符串进行操作，从而减少了时间复杂度。


```C++ [sol2-C++]
class Solution {
public:
    bool hasAllCodes(string s, int k) {
        if (s.size() < (1 << k) + k - 1) {
            return false;
        }

        int num = stoi(s.substr(0, k), nullptr, 2);
        unordered_set<int> exists = {num};
        
        for (int i = 1; i + k <= s.size(); ++i) {
            num = (num - ((s[i - 1] - '0') << (k - 1))) * 2 + (s[i + k - 1] - '0');
            exists.insert(num);
        }
        return exists.size() == (1 << k);
    }
};
```

```Python [sol2-Python3]
class Solution:
    def hasAllCodes(self, s: str, k: int) -> bool:
        if len(s) < (1 << k) + k - 1:
            return False
        
        num = int(s[:k], base=2)
        exists = set([num])

        for i in range(1, len(s) - k + 1):
            num = (num - ((ord(s[i - 1]) - 48) << (k - 1))) * 2 + (ord(s[i + k - 1]) - 48)
            exists.add(num)
        
        return len(exists) == (1 << k)
```

```Java [sol2-Java]
class Solution {
    public boolean hasAllCodes(String s, int k) {
        if (s.length() < (1 << k) + k - 1) {
            return false;
        }

        int num = Integer.parseInt(s.substring(0, k), 2);
        Set<Integer> exists = new HashSet<Integer>();
        exists.add(num);
        
        for (int i = 1; i + k <= s.length(); ++i) {
            num = (num - ((s.charAt(i - 1) - '0') << (k - 1))) * 2 + (s.charAt(i + k - 1) - '0');
            exists.add(num);
        }
        return exists.size() == (1 << k);
    }
}
```

**复杂度分析**

- 时间复杂度：$O(|s|)$，其中 $|s|$ 是字符串 $s$ 的长度。

- 空间复杂度：$O(2^k)$。哈希集合中最多有 $2^k$ 项，每一项是一个十进制整数。
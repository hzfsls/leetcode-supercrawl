## [421.数组中两个数的最大异或值 中文官方题解](https://leetcode.cn/problems/maximum-xor-of-two-numbers-in-an-array/solutions/100000/shu-zu-zhong-liang-ge-shu-de-zui-da-yi-h-n9m9)
#### 前言

假设我们在数组中选择了元素 $a_i$ 和 $a_j$（$i \neq j$），使得它们达到最大的按位异或运算结果 $x$：

$$
x = a_i \oplus a_j
$$

其中 $\oplus$ 表示按位异或运算。要想求出 $x$，一种简单的方法是使用二重循环枚举 $i$ 和 $j$，但这样做的时间复杂度为 $O(n^2)$，会超出时间限制。因此，我们需要寻求时间复杂度更低的做法。

根据按位异或运算的性质，$x = a_i \oplus a_j$ 等价于 $a_j = x \oplus a_i$。我们可以根据这一变换，设计一种「从高位到低位依次确定 $x$ 二进制表示的每一位」的方法，以此得到 $x$ 的值。该方法的精髓在于：

- 由于数组中的元素都在 $[0, 2^{31})$ 的范围内，那么我们可以将每一个数表示为一个长度为 $31$ 位的二进制数（如果不满 $31$ 位，在最高位之前补上若干个前导 $0$ 即可）；

- 这 $31$ 个二进制位从低位到高位依次编号为 $0, 1, \cdots, 30$。我们从最高位第 $30$ 个二进制位开始，依次确定 $x$ 的每一位是 $0$ 还是 $1$；

- 由于我们需要找出最大的 $x$，因此在枚举每一位时，我们先判断 $x$ 的这一位是否能取到 $1$。如果能，我们取这一位为 $1$，否则我们取这一位为 $0$。

「判断 $x$ 的某一位是否能取到 $1$」这一步骤并不容易。下面介绍两种判断的方法。

#### 方法一：哈希表

**思路与算法**

假设我们已经确定了 $x$ 最高的若干个二进制位，当前正在确定第 $k$ 个二进制位。根据「前言」部分的分析，我们希望第 $k$ 个二进制位能够取到 $1$。

我们用 $\textit{pre}^k(x)$ 表示 $x$ 从最高位第 $30$ 个二进制位开始，到第 $k$ 个二进制位为止的数，那么 $a_j = x \oplus a_i$ 蕴含着：

$$
\textit{pre}^k (a_j) = \textit{pre}^k (x) \oplus \textit{pre}^k (a_i)
$$

由于 $\textit{pre}^k(x)$ 对于我们来说是已知的，因此我们将所有的 $\textit{pre}^k (a_j)$ 放入哈希表中，随后枚举 $i$ 并计算 $\textit{pre}^k (x) \oplus \textit{pre}^k (a_i)$。如果其出现在哈希表中，那么说明第 $k$ 个二进制位能够取到 $1$，否则第 $k$ 个二进制位只能为 $0$。

本方法若仅阅读文字，理解起来可能较为困难，读者可以参考下面的代码以及注释。

**细节**

计算 $\textit{pre}^k(x)$ 可以使用右移运算 $\texttt{>>}$。

**代码**

```C++ [sol1-C++]
class Solution {
private:
    // 最高位的二进制位编号为 30
    static constexpr int HIGH_BIT = 30;

public:
    int findMaximumXOR(vector<int>& nums) {
        int x = 0;
        for (int k = HIGH_BIT; k >= 0; --k) {
            unordered_set<int> seen;
            // 将所有的 pre^k(a_j) 放入哈希表中
            for (int num: nums) {
                // 如果只想保留从最高位开始到第 k 个二进制位为止的部分
                // 只需将其右移 k 位
                seen.insert(num >> k);
            }

            // 目前 x 包含从最高位开始到第 k+1 个二进制位为止的部分
            // 我们将 x 的第 k 个二进制位置为 1，即为 x = x*2+1
            int x_next = x * 2 + 1;
            bool found = false;
            
            // 枚举 i
            for (int num: nums) {
                if (seen.count(x_next ^ (num >> k))) {
                    found = true;
                    break;
                }
            }

            if (found) {
                x = x_next;
            }
            else {
                // 如果没有找到满足等式的 a_i 和 a_j，那么 x 的第 k 个二进制位只能为 0
                // 即为 x = x*2
                x = x_next - 1;
            }
        }
        return x;
    }
};
```

```Java [sol1-Java]
class Solution {
    // 最高位的二进制位编号为 30
    static final int HIGH_BIT = 30;

    public int findMaximumXOR(int[] nums) {
        int x = 0;
        for (int k = HIGH_BIT; k >= 0; --k) {
            Set<Integer> seen = new HashSet<Integer>();
            // 将所有的 pre^k(a_j) 放入哈希表中
            for (int num : nums) {
                // 如果只想保留从最高位开始到第 k 个二进制位为止的部分
                // 只需将其右移 k 位
                seen.add(num >> k);
            }

            // 目前 x 包含从最高位开始到第 k+1 个二进制位为止的部分
            // 我们将 x 的第 k 个二进制位置为 1，即为 x = x*2+1
            int xNext = x * 2 + 1;
            boolean found = false;
            
            // 枚举 i
            for (int num : nums) {
                if (seen.contains(xNext ^ (num >> k))) {
                    found = true;
                    break;
                }
            }

            if (found) {
                x = xNext;
            } else {
                // 如果没有找到满足等式的 a_i 和 a_j，那么 x 的第 k 个二进制位只能为 0
                // 即为 x = x*2
                x = xNext - 1;
            }
        }
        return x;
    }
}
```

```C# [sol1-C#]
public class Solution {
    // 最高位的二进制位编号为 30
    const int HIGH_BIT = 30;

    public int FindMaximumXOR(int[] nums) {
        int x = 0;
        for (int k = HIGH_BIT; k >= 0; --k) {
            ISet<int> seen = new HashSet<int>();
            // 将所有的 pre^k(a_j) 放入哈希表中
            foreach (int num in nums) {
                // 如果只想保留从最高位开始到第 k 个二进制位为止的部分
                // 只需将其右移 k 位
                seen.Add(num >> k);
            }

            // 目前 x 包含从最高位开始到第 k+1 个二进制位为止的部分
            // 我们将 x 的第 k 个二进制位置为 1，即为 x = x*2+1
            int xNext = x * 2 + 1;
            bool found = false;
            
            // 枚举 i
            foreach (int num in nums) {
                if (seen.Contains(xNext ^ (num >> k))) {
                    found = true;
                    break;
                }
            }

            if (found) {
                x = xNext;
            } else {
                // 如果没有找到满足等式的 a_i 和 a_j，那么 x 的第 k 个二进制位只能为 0
                // 即为 x = x*2
                x = xNext - 1;
            }
        }
        return x;
    }
}
```

```Python [sol1-Python3]
class Solution:
    def findMaximumXOR(self, nums: List[int]) -> int:
        # 最高位的二进制位编号为 30
        HIGH_BIT = 30

        x = 0
        for k in range(HIGH_BIT, -1, -1):
            seen = set()
            # 将所有的 pre^k(a_j) 放入哈希表中
            for num in nums:
                # 如果只想保留从最高位开始到第 k 个二进制位为止的部分
                # 只需将其右移 k 位
                seen.add(num >> k)

            # 目前 x 包含从最高位开始到第 k+1 个二进制位为止的部分
            # 我们将 x 的第 k 个二进制位置为 1，即为 x = x*2+1
            x_next = x * 2 + 1
            found = False
            
            # 枚举 i
            for num in nums:
                if x_next ^ (num >> k) in seen:
                    found = True
                    break

            if found:
                x = x_next
            else:
                # 如果没有找到满足等式的 a_i 和 a_j，那么 x 的第 k 个二进制位只能为 0
                # 即为 x = x*2
                x = x_next - 1
        
        return x
```

```JavaScript [sol1-JavaScript]
var findMaximumXOR = function(nums) {
    const HIGH_BIT = 30;
    let x = 0;
    for (let k = HIGH_BIT; k >= 0; --k) {
        const seen = new Set();
        // 将所有的 pre^k(a_j) 放入哈希表中
        for (const num of nums) {
            // 如果只想保留从最高位开始到第 k 个二进制位为止的部分
            // 只需将其右移 k 位
            seen.add(num >> k);
        }

        // 目前 x 包含从最高位开始到第 k+1 个二进制位为止的部分
        // 我们将 x 的第 k 个二进制位置为 1，即为 x = x*2+1
        const xNext = x * 2 + 1;
        let found = false;
        
        // 枚举 i
        for (const num of nums) {
            if (seen.has(xNext ^ (num >> k))) {
                found = true;
                break;
            }
        }

        if (found) {
            x = xNext;
        } else {
            // 如果没有找到满足等式的 a_i 和 a_j，那么 x 的第 k 个二进制位只能为 0
            // 即为 x = x*2
            x = xNext - 1;
        }
    }
    return x; 
};
```

```go [sol1-Golang]
func findMaximumXOR(nums []int) (x int) {
    const highBit = 30 // 最高位的二进制位编号为 30
    for k := highBit; k >= 0; k-- {
        // 将所有的 pre^k(a_j) 放入哈希表中
        seen := map[int]bool{}
        for _, num := range nums {
            // 如果只想保留从最高位开始到第 k 个二进制位为止的部分
            // 只需将其右移 k 位
            seen[num>>k] = true
        }

        // 目前 x 包含从最高位开始到第 k+1 个二进制位为止的部分
        // 我们将 x 的第 k 个二进制位置为 1，即为 x = x*2+1
        xNext := x*2 + 1
        found := false

        // 枚举 i
        for _, num := range nums {
            if seen[num>>k^xNext] {
                found = true
                break
            }
        }

        if found {
            x = xNext
        } else {
            // 如果没有找到满足等式的 a_i 和 a_j，那么 x 的第 k 个二进制位只能为 0
            // 即为 x = x*2
            x = xNext - 1
        }
    }
    return
}
```

```C [sol1-C]
const int HIGH_BIT = 30;

struct HashTable {
    int key;
    UT_hash_handle hh;
};

int findMaximumXOR(int* nums, int numsSize) {
    int x = 0;
    for (int k = HIGH_BIT; k >= 0; --k) {
        struct HashTable* hashTable = NULL;
        // 将所有的 pre^k(a_j) 放入哈希表中
        for (int i = 0; i < numsSize; i++) {
            // 如果只想保留从最高位开始到第 k 个二进制位为止的部分
            // 只需将其右移 k 位
            int x = nums[i] >> k;
            struct HashTable* tmp;
            HASH_FIND_INT(hashTable, &x, tmp);
            if (tmp == NULL) {
                tmp = malloc(sizeof(struct HashTable));
                tmp->key = x;
                HASH_ADD_INT(hashTable, key, tmp);
            }
        }

        // 目前 x 包含从最高位开始到第 k+1 个二进制位为止的部分
        // 我们将 x 的第 k 个二进制位置为 1，即为 x = x*2+1
        int x_next = x * 2 + 1;
        bool found = false;

        // 枚举 i
        for (int i = 0; i < numsSize; i++) {
            int x = x_next ^ (nums[i] >> k);
            struct HashTable* tmp;
            HASH_FIND_INT(hashTable, &x, tmp);
            if (tmp != NULL) {
                found = true;
                break;
            }
        }

        if (found) {
            x = x_next;
        } else {
            // 如果没有找到满足等式的 a_i 和 a_j，那么 x 的第 k 个二进制位只能为 0
            // 即为 x = x*2
            x = x_next - 1;
        }
    }
    return x;
}
```

**复杂度分析**

- 时间复杂度：$O(n \log C)$，其中 $n$ 是数组 $\textit{nums}$ 的长度，$C$ 是数组中的元素范围，在本题中 $C < 2^{31}$。枚举答案 $x$ 的每一个二进制位的时间复杂度为 $O(\log C)$，在每一次枚举的过程中，我们需要 $O(n)$ 的时间进行判断，因此总时间复杂度为 $O(n \log C)$。

- 空间复杂度：$O(n)$，即为哈希表需要使用的空间。

#### 方法二：字典树

**思路与算法**

我们也可以将数组中的元素看成长度为 $31$ 的字符串，字符串中只包含 $0$ 和 $1$。如果我们将字符串放入字典树中，那么在字典树中查询一个字符串的过程，恰好就是从高位开始确定每一个二进制位的过程。字典树的具体逻辑以及实现可以参考「[208. 实现 Trie（前缀树）的官方题解](https://leetcode-cn.com/problems/implement-trie-prefix-tree/solution/shi-xian-trie-qian-zhui-shu-by-leetcode-ti500/)」，这里我们只说明如何使用字典树解决本题。

根据 $x = a_i \oplus a_j$，我们枚举 $a_i$，并将 $a_0, a_1, \cdots, a_{i-1}$ 作为 $a_j$ 放入字典树中，希望找出使得 $x$ 达到最大值的 $a_j$。

如何求出 $x$ 呢？我们可以从字典树的根节点开始进行遍历，遍历的「参照对象」为 $a_i$。在遍历的过程中，我们根据 $a_i$ 的第 $x$ 个二进制位是 $0$ 还是 $1$，确定我们应当走向哪个子节点以继续遍历。假设我们当前遍历到了第 $k$ 个二进制位：

- 如果 $a_i$ 的第 $k$ 个二进制位为 $0$，那么我们应当往表示 $1$ 的子节点走，这样 $0 \oplus 1 = 1$，可以使得 $x$ 的第 $k$ 个二进制位为 $1$。如果不存在表示 $1$ 的子节点，那么我们只能往表示 $0$ 的子节点走，$x$ 的第 $k$ 个二进制位为 $0$；

- 如果 $a_i$ 的第 $k$ 个二进制位为 $1$，那么我们应当往表示 $0$ 的子节点走，这样 $1 \oplus 0 = 1$，可以使得 $x$ 的第 $k$ 个二进制位为 $1$。如果不存在表示 $0$ 的子节点，那么我们只能往表示 $1$ 的子节点走，$x$ 的第 $k$ 个二进制位为 $0$。

当遍历完所有的 $31$ 个二进制位后，我们也就得到了 $a_i$ 可以通过异或运算得到的最大 $x$。这样一来，如果我们枚举了所有的 $a_i$，也就得到了最终的答案。

**细节**

由于字典树中的每个节点最多只有两个子节点，分别表示 $0$ 和 $1$，因此本题中的字典树是一棵二叉树。在设计字典树的数据结构时，我们可以令左子节点 $\textit{left}$ 表示 $0$，右子节点 $\textit{right}$ 表示 $1$。

**代码**

下面的 $\texttt{C++}$ 代码没有析构字典树的空间。如果在面试中遇到了本题，可以和面试官进行沟通，询问是否需要析构对应的空间。

```C++ [sol2-C++]
struct Trie {
    // 左子树指向表示 0 的子节点
    Trie* left = nullptr;
    // 右子树指向表示 1 的子节点
    Trie* right = nullptr;

    Trie() {}
};

class Solution {
private:
    // 字典树的根节点
    Trie* root = new Trie();
    // 最高位的二进制位编号为 30
    static constexpr int HIGH_BIT = 30;

public:
    void add(int num) {
        Trie* cur = root;
        for (int k = HIGH_BIT; k >= 0; --k) {
            int bit = (num >> k) & 1;
            if (bit == 0) {
                if (!cur->left) {
                    cur->left = new Trie();
                }
                cur = cur->left;
            }
            else {
                if (!cur->right) {
                    cur->right = new Trie();
                }
                cur = cur->right;
            }
        }
    }

    int check(int num) {
        Trie* cur = root;
        int x = 0;
        for (int k = HIGH_BIT; k >= 0; --k) {
            int bit = (num >> k) & 1;
            if (bit == 0) {
                // a_i 的第 k 个二进制位为 0，应当往表示 1 的子节点 right 走
                if (cur->right) {
                    cur = cur->right;
                    x = x * 2 + 1;
                }
                else {
                    cur = cur->left;
                    x = x * 2;
                }
            }
            else {
                // a_i 的第 k 个二进制位为 1，应当往表示 0 的子节点 left 走
                if (cur->left) {
                    cur = cur->left;
                    x = x * 2 + 1;
                }
                else {
                    cur = cur->right;
                    x = x * 2;
                }
            }
        }
        return x;
    }

    int findMaximumXOR(vector<int>& nums) {
        int n = nums.size();
        int x = 0;
        for (int i = 1; i < n; ++i) {
            // 将 nums[i-1] 放入字典树，此时 nums[0 .. i-1] 都在字典树中
            add(nums[i - 1]);
            // 将 nums[i] 看作 ai，找出最大的 x 更新答案
            x = max(x, check(nums[i]));
        }
        return x;
    }
};
```

```Java [sol2-Java]
class Solution {
    // 字典树的根节点
    Trie root = new Trie();
    // 最高位的二进制位编号为 30
    static final int HIGH_BIT = 30;

    public int findMaximumXOR(int[] nums) {
        int n = nums.length;
        int x = 0;
        for (int i = 1; i < n; ++i) {
            // 将 nums[i-1] 放入字典树，此时 nums[0 .. i-1] 都在字典树中
            add(nums[i - 1]);
            // 将 nums[i] 看作 ai，找出最大的 x 更新答案
            x = Math.max(x, check(nums[i]));
        }
        return x;
    }

    public void add(int num) {
        Trie cur = root;
        for (int k = HIGH_BIT; k >= 0; --k) {
            int bit = (num >> k) & 1;
            if (bit == 0) {
                if (cur.left == null) {
                    cur.left = new Trie();
                }
                cur = cur.left;
            }
            else {
                if (cur.right == null) {
                    cur.right = new Trie();
                }
                cur = cur.right;
            }
        }
    }

    public int check(int num) {
        Trie cur = root;
        int x = 0;
        for (int k = HIGH_BIT; k >= 0; --k) {
            int bit = (num >> k) & 1;
            if (bit == 0) {
                // a_i 的第 k 个二进制位为 0，应当往表示 1 的子节点 right 走
                if (cur.right != null) {
                    cur = cur.right;
                    x = x * 2 + 1;
                } else {
                    cur = cur.left;
                    x = x * 2;
                }
            } else {
                // a_i 的第 k 个二进制位为 1，应当往表示 0 的子节点 left 走
                if (cur.left != null) {
                    cur = cur.left;
                    x = x * 2 + 1;
                } else {
                    cur = cur.right;
                    x = x * 2;
                }
            }
        }
        return x;
    }
}

class Trie {
    // 左子树指向表示 0 的子节点
    Trie left = null;
    // 右子树指向表示 1 的子节点
    Trie right = null;
}
```

```C# [sol2-C#]
public class Solution {
    // 字典树的根节点
    Trie root = new Trie();
    // 最高位的二进制位编号为 30
    const int HIGH_BIT = 30;

    public int FindMaximumXOR(int[] nums) {
        int n = nums.Length;
        int x = 0;
        for (int i = 1; i < n; ++i) {
            // 将 nums[i-1] 放入字典树，此时 nums[0 .. i-1] 都在字典树中
            Add(nums[i - 1]);
            // 将 nums[i] 看作 ai，找出最大的 x 更新答案
            x = Math.Max(x, Check(nums[i]));
        }
        return x;
    }

    public void Add(int num) {
        Trie cur = root;
        for (int k = HIGH_BIT; k >= 0; --k) {
            int bit = (num >> k) & 1;
            if (bit == 0) {
                if (cur.left == null) {
                    cur.left = new Trie();
                }
                cur = cur.left;
            }
            else {
                if (cur.right == null) {
                    cur.right = new Trie();
                }
                cur = cur.right;
            }
        }
    }

    public int Check(int num) {
        Trie cur = root;
        int x = 0;
        for (int k = HIGH_BIT; k >= 0; --k) {
            int bit = (num >> k) & 1;
            if (bit == 0) {
                // a_i 的第 k 个二进制位为 0，应当往表示 1 的子节点 right 走
                if (cur.right != null) {
                    cur = cur.right;
                    x = x * 2 + 1;
                } else {
                    cur = cur.left;
                    x = x * 2;
                }
            } else {
                // a_i 的第 k 个二进制位为 1，应当往表示 0 的子节点 left 走
                if (cur.left != null) {
                    cur = cur.left;
                    x = x * 2 + 1;
                } else {
                    cur = cur.right;
                    x = x * 2;
                }
            }
        }
        return x;
    }
}

class Trie {
    // 左子树指向表示 0 的子节点
    public Trie left = null;
    // 右子树指向表示 1 的子节点
    public Trie right = null;
}
```

```Python [sol2-Python3]
class Trie:
    def __init__(self):
        # 左子树指向表示 0 的子节点
        self.left = None
        # 右子树指向表示 1 的子节点
        self.right = None

class Solution:
    def findMaximumXOR(self, nums: List[int]) -> int:
        # 字典树的根节点
        root = Trie()
        # 最高位的二进制位编号为 30
        HIGH_BIT = 30

        def add(num: int):
            cur = root
            for k in range(HIGH_BIT, -1, -1):
                bit = (num >> k) & 1
                if bit == 0:
                    if not cur.left:
                        cur.left = Trie()
                    cur = cur.left
                else:
                    if not cur.right:
                        cur.right = Trie()
                    cur = cur.right

        def check(num: int) -> int:
            cur = root
            x = 0
            for k in range(HIGH_BIT, -1, -1):
                bit = (num >> k) & 1
                if bit == 0:
                    # a_i 的第 k 个二进制位为 0，应当往表示 1 的子节点 right 走
                    if cur.right:
                        cur = cur.right
                        x = x * 2 + 1
                    else:
                        cur = cur.left
                        x = x * 2
                else:
                    # a_i 的第 k 个二进制位为 1，应当往表示 0 的子节点 left 走
                    if cur.left:
                        cur = cur.left
                        x = x * 2 + 1
                    else:
                        cur = cur.right
                        x = x * 2
            return x

        n = len(nums)
        x = 0
        for i in range(1, n):
            # 将 nums[i-1] 放入字典树，此时 nums[0 .. i-1] 都在字典树中
            add(nums[i - 1])
            # 将 nums[i] 看作 ai，找出最大的 x 更新答案
            x = max(x, check(nums[i]))

        return x
```

```go [sol2-Golang]
const highBit = 30

type trie struct {
    left, right *trie
}

func (t *trie) add(num int) {
    cur := t
    for i := highBit; i >= 0; i-- {
        bit := num >> i & 1
        if bit == 0 {
            if cur.left == nil {
                cur.left = &trie{}
            }
            cur = cur.left
        } else {
            if cur.right == nil {
                cur.right = &trie{}
            }
            cur = cur.right
        }
    }
}

func (t *trie) check(num int) (x int) {
    cur := t
    for i := highBit; i >= 0; i-- {
        bit := num >> i & 1
        if bit == 0 {
            // a_i 的第 k 个二进制位为 0，应当往表示 1 的子节点 right 走
            if cur.right != nil {
                cur = cur.right
                x = x*2 + 1
            } else {
                cur = cur.left
                x = x * 2
            }
        } else {
            // a_i 的第 k 个二进制位为 1，应当往表示 0 的子节点 left 走
            if cur.left != nil {
                cur = cur.left
                x = x*2 + 1
            } else {
                cur = cur.right
                x = x * 2
            }
        }
    }
    return
}

func findMaximumXOR(nums []int) (x int) {
    root := &trie{}
    for i := 1; i < len(nums); i++ {
        // 将 nums[i-1] 放入字典树，此时 nums[0 .. i-1] 都在字典树中
        root.add(nums[i-1])
        // 将 nums[i] 看作 ai，找出最大的 x 更新答案
        x = max(x, root.check(nums[i]))
    }
    return
}

func max(a, b int) int {
    if a > b {
        return a
    }
    return b
}
```

```C [sol2-C]
const int HIGH_BIT = 30;

struct Trie {
    // 左子树指向表示 0 的子节点
    struct Trie* left;
    // 右子树指向表示 1 的子节点
    struct Trie* right;
};

struct Trie* createTrie() {
    struct Trie* ret = malloc(sizeof(struct Trie));
    ret->left = ret->right = NULL;
    return ret;
}

void add(struct Trie* root, int num) {
    struct Trie* cur = root;
    for (int k = HIGH_BIT; k >= 0; --k) {
        int bit = (num >> k) & 1;
        if (bit == 0) {
            if (!cur->left) {
                cur->left = createTrie();
            }
            cur = cur->left;
        } else {
            if (!cur->right) {
                cur->right = createTrie();
            }
            cur = cur->right;
        }
    }
}

int check(struct Trie* root, int num) {
    struct Trie* cur = root;
    int x = 0;
    for (int k = HIGH_BIT; k >= 0; --k) {
        int bit = (num >> k) & 1;
        if (bit == 0) {
            // a_i 的第 k 个二进制位为 0，应当往表示 1 的子节点 right 走
            if (cur->right) {
                cur = cur->right;
                x = x * 2 + 1;
            } else {
                cur = cur->left;
                x = x * 2;
            }
        } else {
            // a_i 的第 k 个二进制位为 1，应当往表示 0 的子节点 left 走
            if (cur->left) {
                cur = cur->left;
                x = x * 2 + 1;
            } else {
                cur = cur->right;
                x = x * 2;
            }
        }
    }
    return x;
}

int findMaximumXOR(int* nums, int numsSize) {
    struct Trie* root = createTrie();
    int x = 0;
    for (int i = 1; i < numsSize; ++i) {
        // 将 nums[i-1] 放入字典树，此时 nums[0 .. i-1] 都在字典树中
        add(root, nums[i - 1]);
        // 将 nums[i] 看作 ai，找出最大的 x 更新答案
        x = fmax(x, check(root, nums[i]));
    }
    return x;
}
```

**复杂度分析**

- 时间复杂度：$O(n \log C)$，其中 $n$ 是数组 $\textit{nums}$ 的长度，$C$ 是数组中的元素范围，在本题中 $C < 2^{31}$。我们需要将 $a_0$ 到 $a_{n-2}$ 加入字典树中，并且需要以 $a_1$ 到 $a_{n-1}$ 作为「参照对象」在字典树上进行遍历，每一项操作的单次时间复杂度为 $O(\log C)$，因此总时间复杂度为 $O(n \log C)$。

- 空间复杂度：$O(n \log C)$。每一个元素在字典树中需要使用 $O(\log C)$ 的空间，因此总空间复杂度为 $O(n \log C)$。
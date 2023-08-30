### 问题提示
如何通过遍历找到能被 $k$ 整除的最小正整数 $n$ 的长度？
如何在遍历过程中判断出现循环并避免重复计算？
如何将原问题转化为应用该算法或定理的形式？

### 前置知识
- 理解正整数、整除、余数的概念及其运算法则。
- 掌握哈希表的基本操作。
- 数论基础知识，包括欧拉定理和取模运算等。

### 解题思路
#### 方法一：遍历

**思路与算法**

题目要求出长度最小的仅包含的 $1$ 的并且被 $k$ 整除的正整数。我们从 $n = 1$ 开始枚举，此时对 $k$ 取余得余数 $\textit{resid} = 1 \bmod k$。如果 $\textit{resid}$ 不为 $0$，则表示 $n$ 当前还不能被 $k$ 整除，我们需要增加 $n$ 的长度。令 $n_{new} = n_{old} \times 10 + 1$，$\textit{resid}_{new} = n_{new} \bmod k$。将 $n_{old}$ 代入其中可得：

$$
\begin{aligned}
\textit{resid}_{new} &= (n_{old} \times 10 + 1) \bmod k \\
&= ((n_{old} \bmod k) \times 10 + 1) \bmod k \\
&= (\textit{resid}_{old} \times 10 + 1) \bmod k
\end{aligned}
$$

从上式可以发现，新的余数 $\textit{resid}_{new}$ 可以由 $\textit{resid}_{old}$ 推导得到。因此在遍历过程中不需要记录 $n$，只需记录 $\textit{resid}$。由于 $\textit{resid}$ 是对 $k$ 取余之后的余数，因此种类数不会超过 $k$。

在遍历过程中如果出现重复的 $\textit{resid}$，表示遇到了一个循环，接着遍历下去会重复循环中的每一步，不会产生新的余数。所以我们用一个哈希表记录出现过的余数，当更新 $\textit{resid}$ 后发现该值已经在哈希表时，直接返回 $-1$。否则我们一直遍历，直到 $\textit{resid}$ 变为 $0$。最终哈希表中的元素个数或者遍历次数就是实际 $n$ 的长度。

**代码**

```C++ [sol1_1-C++]
class Solution {
public:
    int smallestRepunitDivByK(int k) {
        int resid = 1 % k, len = 1; // resid为余数，len为数字长度，初始值为1
        unordered_set<int> st; // 创建一个无序集合，用于存储余数
        st.insert(resid); // 插入余数1
        while (resid != 0) { // 当余数为0时退出循环
            resid = (resid * 10 + 1) % k; // 计算下一个余数
            len++; // 数字长度+1
            if (st.find(resid) != st.end()) { // 如果余数重复出现，则无解
                return -1;
            }
            st.insert(resid); // 将余数插入集合
        }
        return len; // 返回数字长度
    }
};
```

```Java [sol1_1-Java]
class Solution {
    public int smallestRepunitDivByK(int k) {
        int resid = 1 % k, len = 1; // resid为余数，len为数字长度，初始值为1
        Set<Integer> set = new HashSet<Integer>(); // 创建一个无序集合，用于存储余数
        set.add(resid); // 插入余数1
        while (resid != 0) { // 当余数为0时退出循环
            resid = (resid * 10 + 1) % k; // 计算下一个余数
            len++; // 数字长度+1
            if (set.contains(resid)) { // 如果余数重复出现，则无解
                return -1;
            }
            set.add(resid); // 将余数插入集合
        }
        return len; // 返回数字长度
    }
}
```

```C# [sol1_1-C#]
public class Solution {
    public int SmallestRepunitDivByK(int k) {
        int resid = 1 % k, len = 1; // resid为余数，len为数字长度，初始值为1
        ISet<int> set = new HashSet<int>(); // 创建一个无序集合，用于存储余数
        set.Add(resid); // 插入余数1
        while (resid != 0) { // 当余数为0时退出循环
            resid = (resid * 10 + 1) % k; // 计算下一个余数
            len++; // 数字长度+1
            if (set.Contains(resid)) { // 如果余数重复出现，则无解
                return -1;
            }
            set.Add(resid); // 将余数插入集合
        }
        return len; // 返回数字长度
    }
}
```

```C [sol1_1-C]
// 定义一个哈希表的元素结构体，含有键值 key 和指向哈希表的指针
typedef struct {
    int key;
    UT_hash_handle hh;
} HashItem; 

// 在哈希表中查找键值为 key 的元素，返回找到的元素指针
HashItem *hashFindItem(HashItem **obj, int key) {
    HashItem *pEntry = NULL;
    // 使用 UT_hash_handle 库中的 HASH_FIND_INT 宏实现
    HASH_FIND_INT(*obj, &key, pEntry);
    return pEntry;
}

// 在哈希表中添加键值为 key 的元素，如果已存在则返回 false，否则返回 true
bool hashAddItem(HashItem **obj, int key) {
    if (hashFindItem(obj, key)) {
        return false;
    }
    // 创建一个新的元素结构体，并设置键值
    HashItem *pEntry = (HashItem *)malloc(sizeof(HashItem));
    pEntry->key = key;
    // 使用 UT_hash_handle 库中的 HASH_ADD_INT 宏将元素添加到哈希表中
    HASH_ADD_INT(*obj, key, pEntry);
    return true;
}

// 释放哈希表 obj 中所有元素的内存
void hashFree(HashItem **obj) {
    HashItem *curr = NULL, *tmp = NULL;
    // 使用 UT_hash_handle 库中的 HASH_ITER 宏遍历哈希表
    HASH_ITER(hh, *obj, curr, tmp) {
        // 使用 UT_hash_handle 库中的 HASH_DEL 宏从哈希表中删除元素
        HASH_DEL(*obj, curr);  
        // 释放元素的内存
        free(curr);
    }
}

// 解决问题的函数
int smallestRepunitDivByK(int k) {
    // 初始化余数为 1，长度为 1，并创建一个空的哈希表
    int resid = 1 % k, len = 1;
    HashItem *st = NULL;
    // 在哈希表中添加余数
    hashAddItem(&st, resid);
    // 当余数不为 0 时，重复以下操作
    while (resid != 0) {
        // 计算下一个余数
        resid = (resid * 10 + 1) % k;
        // 长度加 1
        len++;
        // 如果哈希表中已经存在该余数，则说明已经出现循环，直接返回 -1
        if (hashFindItem(&st, resid) != NULL) {
            hashFree(&st);
            return -1;
        }
        // 在哈希表中添加余数
        hashAddItem(&st, resid);
    }
    // 释放哈希表的内存，返回长度
    hashFree(&st);
    return len;
}

```

```JavaScript [sol1_1-JavaScript]
var smallestRepunitDivByK = function(k) {
    // 初始化循环所需的余数 resid 为 1%k, 数位长度 len 为 1
    let resid = 1 % k, len = 1;
    // 使用 Set 数据结构存储出现过的余数
    const set = new Set();
    set.add(resid);
    // 当余数不为 0 时，继续循环
    while (resid != 0) {
        // 计算下一个余数
        resid = (resid * 10 + 1) % k;
        // 数位长度加 1
        len++;
        // 若该余数已经出现过，则说明出现了循环，直接返回 -1
        if (set.has(resid)) {
            return -1;
        }
        // 将新的余数加入 Set 中
        set.add(resid);
    }
    // 当余数为 0 时，表示找到了一个长度最短的可被整除的数字，返回长度 len
    return len;
};
```

**优化**

注意到当 $k$ 为 $2$ 或者 $5$ 的倍数时，能够被 $k$ 整除的数字末尾一定不为 $1$，所以此时一定无解。

那当 $k$ 不为 $2$ 或者 $5$ 的倍数时一定有解吗？我们做进一步的分析。

$\textit{resid}$ 随着 $1$ 的增加，最后一定进入循环，我们能找到两个对 $k$ 同余的 $n$ 和 $m$。假设 $n \gt m$，那么一定有以下等式成立：

$$(n - m) \equiv 0 \pmod k$$

$n - m$ 可以表示为 $11\dots 100\dots 0$ 的形式，因此有 $11\dots 100\dots 0 \equiv 0 \pmod k$。

如果此时 $k$ 不为 $2$ 或 $5$ 的倍数，则 $k$ 与 $10$ 没有公因数，$k$ 与 $10$ 互质。$n - m$ 末尾的 $0$ 可以除掉，因此 $11\dots 1 \equiv 0 \pmod k$，问题一定有解。

```C++ [sol1_2-C++]
class Solution {
public:
    int smallestRepunitDivByK(int k) {
        // 若 k 能被 2 或 5 整除，则无解，返回 -1
        if (k % 2 == 0 || k % 5 == 0) {
            return -1;
        }
        // 初始化余数为 1，表示一个数的最低位是 1
        int resid = 1 % k, len = 1;
        // 若余数不为 0，继续迭代
        while (resid != 0) {
            // 计算下一个数的余数，下一个数在当前余数后加一个 1
            resid = (resid * 10 + 1) % k;
            len++;
        }
        // 返回数字 1 的最小重复次数
        return len;
    }
};
```

```Java [sol1_2-Java]
class Solution {
    public int smallestRepunitDivByK(int k) {
        // 若 k 能被 2 或 5 整除，则无解，返回 -1
        if (k % 2 == 0 || k % 5 == 0) {
            return -1;
        }
        // 初始化余数为 1，表示一个数的最低位是 1
        int resid = 1 % k, len = 1;
        // 若余数不为 0，继续迭代
        while (resid != 0) {
            // 计算下一个数的余数，下一个数在当前余数后加一个 1
            resid = (resid * 10 + 1) % k;
            len++;
        }
        // 返回数字 1 的最小重复次数
        return len;
    }
}
```

```C# [sol1_2-C#]
public class Solution {
    public int SmallestRepunitDivByK(int k) {
        // 若 k 能被 2 或 5 整除，则无解，返回 -1
        if (k % 2 == 0 || k % 5 == 0) {
            return -1;
        }
        // 初始化余数为 1，表示一个数的最低位是 1
        int resid = 1 % k, len = 1;
        // 若余数不为 0，继续迭代
        while (resid != 0) {
            // 计算下一个数的余数，下一个数在当前余数后加一个 1
            resid = (resid * 10 + 1) % k;
            len++;
        }
        // 返回数字 1 的最小重复次数
        return len;
    }
}
```

```C [sol1_2-C]
int smallestRepunitDivByK(int k) {
    // 如果 k 是偶数或者是 5 的倍数，则无法整除，直接返回 -1
    if (k % 2 == 0 || k % 5 == 0) {
        return -1;
    }
    int resid = 1 % k, len = 1;
    while (resid != 0) {
        resid = (resid * 10 + 1) % k;
        len++;
    }
    return len;
}
```

```Python [sol1_2-Python3]
class Solution:
    def smallestRepunitDivByK(self, k: int) -> int:
        if k % 2 == 0 or k % 5 == 0:  # 如果 k 是 2 的倍数或者 5 的倍数，返回 -1
            return -1
        
        ans, resid = 1, 1  # ans 表示长度，resid 表示余数
        while resid % k != 0:  # 当余数不为 0 时
            resid = (resid % k) * (10 % k) + 1  # 模拟除法运算，计算下一次的余数
            ans += 1  # 长度加 1
            
        return ans  # 返回最小整数的长度
```

```JavaScript [sol1_2-JavaScript]
var smallestRepunitDivByK = function(k) {
    // 如果 k 是偶数或者是 5 的倍数，则无法整除，直接返回 -1
    if (k % 2 === 0 || k % 5 === 0) {
        return -1;
    }
    let resid = 1 % k, len = 1;
    while (resid !== 0) {
        resid = (resid * 10 + 1) % k;
        len++;
    }
    return len;
};
```

```go [sol1_2-Golang]
func smallestRepunitDivByK(k int) int {
    // 如果 k 是偶数或者以 5 结尾，那么一定不存在这样的正整数，直接返回 -1。
    if k % 2 == 0 || k % 5 == 0 {
        return -1
    }
    // cur 代表当前的余数，初始值为 0，res 代表数字 1 的个数，初始值为 1。
    cur, res := 0, 1
    
    // 不断计算下一个数字的余数，直到找到一个可行的解或者发现不存在可行的解。
    for {
        cur = (10 * cur + 1) % k
        if cur == 0 {
            return res
        }
        res++
    }
}
```

**复杂度分析**

- 时间复杂度：$O(k)$。过程中最多会遍历 $k$ 次。

- 空间复杂度：$O(1)$。如果使用哈希表，空间复杂度为 $O(k)$。

### 练习题目推荐
[29. 两数相除](https://leetcode.cn/problems/divide-two-integers/)
[166. 分数到小数](https://leetcode.cn/problems/fraction-to-recurring-decimal/)
[1071. 字符串的最大公因子](https://leetcode.cn/problems/greatest-common-divisor-of-strings/)

### 拓展思考
如果给定的 k 非常大，如何优化算法？
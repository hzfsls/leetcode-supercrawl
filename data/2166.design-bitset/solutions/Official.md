## [2166.设计位集 中文官方题解](https://leetcode.cn/problems/design-bitset/solutions/100000/she-ji-wei-ji-by-leetcode-solution-w8qh)
#### 方法一：利用数组实现

**思路与算法**

根据题意，我们需要在 $O(1)$ 的时间复杂度内实现 $\texttt{fix()}, \texttt{unfix()}, \texttt{flip()}, \texttt{all()}, \texttt{one()}, \texttt{count()}$ 方法，并在 $O(n)$ 的时间复杂度内实现 $\texttt{toString()}$ 方法。

我们首先考虑用一个长度为 $\textit{size}$ 的**数组** $\textit{arr}$ 来实现 bitset，其中第 $k$ 个元素的数值等于第 $k$ 位的数值。它支持在 $O(1)$ 的时间复杂度内实现 $\texttt{fix()}, \texttt{unfix()}$ 这两个方法，但其他方法都需要 $O(n)$ 来实现。

进一步地，考虑到每一次执行 $\texttt{fix()}, \texttt{unfix()}$ 操作时，都最多只有一个位被翻转，因此 $1$ 的位数最多改变 $1$。同时，在 $\texttt{flip()}$ 操作前后 $1$ 的位数之和即为 $\textit{size}$。

那么我们可以用额外的**整数** $\textit{cnt}$ 来维护 **$1$ 的位数**。$\textit{cnt}$ 的初始值为 $0$，在每次更新 $\textit{arr}$ 时，我们都对应更新 $\textit{cnt}$ 的数值。基于此，我们可以在不影响其余方法的复杂度时，在 $O(1)$ 的时间复杂度内实现 $\texttt{all()}, \texttt{one()}, \texttt{count()}$ 这三个方法。

至此，我们只剩 $\texttt{flip()}$ 方法的复杂度不符合要求。由于反转两次等于不变，且反转和赋值操作可交换，因此我们也可以通过一个**二进制位** $\textit{reversed}$ 来表示**反转操作的次数奇偶性**。$\textit{reversed}$ 的初值为 $0$；在每次 $\texttt{flip()}$ 时，我们可以通过对 $\textit{reversed}$ 与 $1$ 取异或来代替翻转整个数组。除此以外，第 $k$ 位的数值即为 $\textit{arr}[k] \oplus \textit{reversed}$，其中 $\oplus$ 为按位异或。同理，在执行某一位赋值操作时，如果该位的数值会发生变化，我们只需要将该数值与 $1$ 取异或即可。

按照上面的方法，我们就可以在不影响其余操作的时间复杂度下，将 $\texttt{flip()}$ 方法的复杂度也降低为 $O(1)$。

综上，我们可以通过以下三个元素来实现 $\texttt{Bitset}$ 类：

- $\textit{arr}$：长度为 $\textit{size}$ 的数组，用来存储每一位的取值；

- $\textit{cnt}$：整数，用来统计 $1$ 的位数；

- $\textit{reversed}$：二进制位，用来统计反转操作的次数奇偶性。

各个方法的具体实现详见代码。

**代码**

```C++ [sol1-C++]
class Bitset {
private:
    vector<int> arr;   // 存储每一位的数组
    int cnt = 0;   // 1 的个数
    int reversed = 0;   // 反转操作的次数奇偶性
public:
    Bitset(int size) {
        arr.resize(size);
        cnt = 0;
        reversed = 0;
    }
    
    void fix(int idx) {
        if ((arr[idx] ^ reversed) == 0) {
            arr[idx] ^= 1;
            ++cnt;
        }
    }
    
    void unfix(int idx) {
        if ((arr[idx] ^ reversed) == 1) {
            arr[idx] ^= 1;
            --cnt;
        }
    }
    
    void flip() {
        reversed ^= 1;
        cnt = arr.size() - cnt;
    }
    
    bool all() {
        return cnt == arr.size();
    }
    
    bool one() {
        return cnt > 0;
    }
    
    int count() {
        return cnt;
    }
    
    string toString() {
        string res;
        for (int bit: arr) {
            res.push_back('0' + (bit ^ reversed));
        }
        return res;
    }
};
```


```Python [sol1-Python3]
class Bitset:

    def __init__(self, size: int):
        self.arr = [0] * size   # 存储每一位的数组
        self.cnt = 0   # 1 的个数
        self.reversed = 0   # 反转操作的次数奇偶性

    def fix(self, idx: int) -> None:
        if self.arr[idx] ^ self.reversed == 0:
            self.arr[idx] ^= 1
            self.cnt += 1

    def unfix(self, idx: int) -> None:
        if self.arr[idx] ^ self.reversed == 1:
            self.arr[idx] ^= 1
            self.cnt -= 1

    def flip(self) -> None:
        self.reversed ^= 1
        self.cnt = len(self.arr) - self.cnt

    def all(self) -> bool:
        return self.cnt == len(self.arr)

    def one(self) -> bool:
        return self.cnt > 0

    def count(self) -> int:
        return self.cnt

    def toString(self) -> str:
        res = ""
        for bit in self.arr:
            res += str(bit ^ self.reversed) 
        return res
```


**复杂度分析**

- 时间复杂度：$O(k_1n + k_2)$，其中 $n$ 为位集的长度$\textit{size}$，$k_1$ 为 $\texttt{toString()}$ 操作的次数，$k_2$ 为其他操作的次数。预处理和单次 $\texttt{toString()}$ 操作的时间复杂度均为 $O(n)$，其余单次操作的时间复杂度为 $O(1)$。

- 空间复杂度：$O(n)$，即为辅助数组的空间开销。
#### 方法一：维护每种钞票的剩余数目

**思路与算法**

首先我们尝试分析各个方法对应的需求：

- 对于 $\texttt{deposit}()$ 方法，我们需要更新每张钞票的数目；

- 对于 $\texttt{withdraw}()$ 方法，我们需要模拟机器从高面额至低面额尝试取钱的过程，判断是否可行，并尝试更新每张钞票的数目，以及返回取出各种面额钞票的数目。

我们可以用一个数组 $\textit{cnt}$ 来维护每种钞票的剩余数目，同时用数组 $\textit{value}$ 来维护 $\textit{cnt}$ 数组对应下标钞票的面额。为了方便起见，我们需要让 $\textit{value}$ 数组保持升序。

那么，对于 $\texttt{deposit}()$ 方法，我们只需要遍历输入数组，并将每个元素的值加在 $\textit{cnt}$ 中的对应元素上即可。

而对于 $\texttt{withdraw}()$ 方法，我们需要倒序（即从高面额至低面额）遍历 $\textit{cnt}$ 数组，并模拟取钱操作。

具体而言，我们用数组 $\textit{res}$ 表示（如果可行）取出各种钞票的数目，同时倒序遍历 $\textit{cnt}$ 数组，并更新还需要取的金额数目 $\textit{amount}$。当遍历到下标 $i$ 时，我们首先计算该面额钞票需要取出的数量 $\textit{res}[i]$。对应钞票的数量不能多余取款机中该种钞票的数量，且总面额不能高于还需取出的金额数目。因此我们有 $\textit{res}[i] = \min(\textit{cnt}[i], \lfloor \textit{amount} / \min(\textit{value}[i] \rfloor)$（其中 $\lfloor \dots \rfloor$ 代表向下取整）。同时，我们需要对应地将 $\textit{amount}$ 减去 $\textit{res}[i] \times \textit{value}[i]$。

当遍历完成后，如果 $\textit{amount} = 0$，即代表可以进行该取出操作，我们将 $\textit{cnt}$ 数组地每个元素减去 $\textit{res}$ 数组的对应元素，并返回 $\textit{res}$ 作为答案；而如果 $\textit{amount} > 0$，则说明无法进行取出操作，我们应当不进行任何操作，直接返回 $[-1]$。

**细节**

在操作过程中，$\textit{cnt}$ 数组的元素数值有可能超过 $32$ 位有符号整数的上限，因此对于 $\texttt{C++}$ 等语言，我们需要用 $64$ 位整数存储每种钞票的剩余数目。

**代码**

```C++ [sol1-C++]
class ATM {
private:
    vector<long long> cnt;   // 每张钞票剩余数量
    vector<long long> value;   // 每张钞票面额
    
public:
    ATM() {
        cnt = {0, 0, 0, 0, 0};
        value = {20, 50, 100, 200, 500};
    }
    
    void deposit(vector<int> banknotesCount) {
        for (int i = 0; i < 5; ++i) {
            cnt[i] += banknotesCount[i];
        }
    }
    
    vector<int> withdraw(int amount) {
        vector<int> res(5);
        // 模拟尝试取出钞票的过程
        for (int i = 4; i >= 0; --i) {
            res[i] = min(cnt[i], amount / value[i]);
            amount -= res[i] * value[i];
        }
        if (amount) {
            // 无法完成该操作
            return {-1};
        } else {
            // 可以完成该操作
            for (int i = 0; i < 5; ++i) {
                cnt[i] -= res[i];
            }
            return res;
        }
    }
};
```


```Python [sol1-Python3]
class ATM:

    def __init__(self):
        self.cnt = [0] * 5   # 每张钞票剩余数量
        self.value = [20, 50, 100, 200, 500]   # 每张钞票面额


    def deposit(self, banknotesCount: List[int]) -> None:
        for i in range(5):
            self.cnt[i] += banknotesCount[i]


    def withdraw(self, amount: int) -> List[int]:
        res = [0] * 5
        # 模拟尝试取出钞票的过程
        for i in range(4, -1, -1):
            res[i] = min(self.cnt[i], amount // self.value[i])
            amount -= res[i] * self.value[i]
        if amount:
            # 无法完成该操作
            return [-1]
        else:
            # 可以完成该操作
            for i in range(5):
                self.cnt[i] -= res[i]
            return res
```


**复杂度分析**

- 时间复杂度：$O(nk)$，其中 $n$ 为 $\texttt{withdraw}()$ 和 $\texttt{deposit}()$ 操作的次数，$k = 5$ 为不同面值钞票的数量。每一次 $\texttt{withdraw}()$ 或 $\texttt{deposit}()$ 操作的时间复杂度为 $O(k)$。

- 空间复杂度：$O(k)$，即为存储每种钞票面额和剩余数量数组的空间开销。
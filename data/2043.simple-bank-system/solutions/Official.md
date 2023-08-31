## [2043.简易银行系统 中文官方题解](https://leetcode.cn/problems/simple-bank-system/solutions/100000/jian-yi-yin-xing-xi-tong-by-leetcode-sol-q3o7)
#### 方法一：模拟

**思路与算法**

已有的帐号为 $1$ 到 $n$，分别对三种操作进行分析：

+ $\textit{transfer}$ 操作

    如果要进行操作的帐号不在已有的帐号中，即 $\textit{account1} > n$ 或者 $\textit{account2} > n$，那么交易无效。如果账号 $\textit{account1}$ 的余额小于 $\textit{money}$，那么交易无效。交易有效时，我们将账号 $\textit{account1}$ 的余额减少 $\textit{money}$，账号 $\textit{account2}$ 的余额增加 $\textit{money}$。

+ $\textit{deposit}$ 操作

    如果要进行操作的帐号不在已有的帐号中，即 $\textit{account} > n$，那么交易无效。交易有效时，我们将账号 $\textit{account}$ 的余额增加 $\textit{money}$。

+ $\textit{withdraw}$ 操作

    如果要进行操作的帐号不在已有的帐号中，即 $\textit{account} > n$，那么交易无效。如果账号 $\textit{account}$ 的余额小于 $\textit{money}$，那么交易无效。交易有效时，我们将账号 $\textit{account}$ 的余额减少 $\textit{money}$。

**代码**

```Python [sol1-Python3]
class Bank:
    def __init__(self, balance: List[int]):
        self.balance = balance

    def transfer(self, account1: int, account2: int, money: int) -> bool:
        if account1 > len(self.balance) or account2 > len(self.balance) or self.balance[account1 - 1] < money:
            return False
        self.balance[account1 - 1] -= money
        self.balance[account2 - 1] += money
        return True

    def deposit(self, account: int, money: int) -> bool:
        if account > len(self.balance):
            return False
        self.balance[account - 1] += money
        return True

    def withdraw(self, account: int, money: int) -> bool:
        if account > len(self.balance) or self.balance[account - 1] < money:
            return False
        self.balance[account - 1] -= money
        return True
```

```C++ [sol1-C++]
class Bank {
private:
    vector<long long> balance;

public:
    Bank(vector<long long>& balance) : balance(balance) {}

    bool transfer(int account1, int account2, long long money) {
        if (account1 > balance.size() || account2 > balance.size() || balance[account1 - 1] < money) {
            return false;
        }
        balance[account1 - 1] -= money;
        balance[account2 - 1] += money;
        return true;
    }

    bool deposit(int account, long long money) {
        if (account > balance.size()) {
            return false;
        }
        balance[account - 1] += money;
        return true;
    }

    bool withdraw(int account, long long money) {
        if (account > balance.size() || balance[account - 1] < money) {
            return false;
        }
        balance[account - 1] -= money;
        return true;
    }
};
```

```Java [sol1-Java]
class Bank {
    long[] balance;

    public Bank(long[] balance) {
        this.balance = balance;
    }

    public boolean transfer(int account1, int account2, long money) {
        if (account1 > balance.length || account2 > balance.length || balance[account1 - 1] < money) {
            return false;
        }
        balance[account1 - 1] -= money;
        balance[account2 - 1] += money;
        return true;
    }

    public boolean deposit(int account, long money) {
        if (account > balance.length) {
            return false;
        }
        balance[account - 1] += money;
        return true;
    }

    public boolean withdraw(int account, long money) {
        if (account > balance.length || balance[account - 1] < money) {
            return false;
        }
        balance[account - 1] -= money;
        return true;
    }
}
```

```C# [sol1-C#]
public class Bank {
    long[] balance;

    public Bank(long[] balance) {
        this.balance = balance;
    }

    public bool Transfer(int account1, int account2, long money) {
        if (account1 > balance.Length || account2 > balance.Length || balance[account1 - 1] < money) {
            return false;
        }
        balance[account1 - 1] -= money;
        balance[account2 - 1] += money;
        return true;
    }

    public bool Deposit(int account, long money) {
        if (account > balance.Length) {
            return false;
        }
        balance[account - 1] += money;
        return true;
    }

    public bool Withdraw(int account, long money) {
        if (account > balance.Length || balance[account - 1] < money) {
            return false;
        }
        balance[account - 1] -= money;
        return true;
    }
}
```

```C [sol1-C]
typedef struct {
    long long * balance;
    int balanceSize;
} Bank;

Bank* bankCreate(long long* balance, int balanceSize) {
    Bank * obj = (Bank *)malloc(sizeof(Bank));
    obj->balance = (long long *)malloc(sizeof(long long) * balanceSize);
    obj->balanceSize = balanceSize;
    memcpy(obj->balance, balance, sizeof(long long) * balanceSize);
    return obj;
}

bool bankTransfer(Bank* obj, int account1, int account2, long long money) {
    if (account1 > obj->balanceSize || account2 > obj->balanceSize || obj->balance[account1 - 1] < money) {
        return false;
    }
    obj->balance[account1 - 1] -= money;
    obj->balance[account2 - 1] += money;
    return true;
}

bool bankDeposit(Bank* obj, int account, long long money) {
    if (account > obj->balanceSize) {
        return false;
    }
    obj->balance[account - 1] += money;
    return true;
}

bool bankWithdraw(Bank* obj, int account, long long money) {
    if (account > obj->balanceSize || obj->balance[account - 1] < money) {
        return false;
    }
    obj->balance[account - 1] -= money;
    return true;
}

void bankFree(Bank* obj) {
    free(obj->balance);
}
```

```JavaScript [sol1-JavaScript]
var Bank = function(balance) {
    this.balance = balance;
};

Bank.prototype.transfer = function(account1, account2, money) {
    if (account1 > this.balance.length || account2 > this.balance.length || this.balance[account1 - 1] < money) {
        return false;
    }
    this.balance[account1 - 1] -= money;
    this.balance[account2 - 1] += money;
    return true;
};

Bank.prototype.deposit = function(account, money) {
    if (account > this.balance.length) {
        return false;
    }
    this.balance[account - 1] += money;
    return true;
};

Bank.prototype.withdraw = function(account, money) {
    if (account > this.balance.length || this.balance[account - 1] < money) {
        return false;
    }
    this.balance[account - 1] -= money;
    return true;
};
```

```go [sol1-Golang]
type Bank []int64

func Constructor(balance []int64) Bank {
    return balance
}

func (b Bank) Transfer(account1, account2 int, money int64) bool {
    if account1 > len(b) || account2 > len(b) || b[account1-1] < money {
        return false
    }
    b[account1-1] -= money
    b[account2-1] += money
    return true
}

func (b Bank) Deposit(account int, money int64) bool {
    if account > len(b) {
        return false
    }
    b[account-1] += money
    return true
}

func (b Bank) Withdraw(account int, money int64) bool {
    if account > len(b) || b[account-1] < money {
        return false
    }
    b[account-1] -= money
    return true
}
```

**复杂度分析**

+ 时间复杂度：
  + $\textit{transfer}$：$O(1)$；
  + $\textit{deposit}$：$O(1)$；
  + $\textit{withdraw}$：$O(1)$。

+ 空间复杂度：
  + 初始化：$O(n)$，其中 $n$ 为已有的帐号数目。
  + $\textit{transfer}$：$O(1)$；
  + $\textit{deposit}$：$O(1)$；
  + $\textit{withdraw}$：$O(1)$。
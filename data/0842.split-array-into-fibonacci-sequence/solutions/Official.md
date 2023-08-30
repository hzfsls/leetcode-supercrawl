#### 方法一：回溯 + 剪枝

将给定的字符串拆分成斐波那契式序列，可以通过回溯的方法实现。

使用列表存储拆分出的数，回溯过程中维护该列表的元素，列表初始为空。遍历字符串的所有可能的前缀，作为当前被拆分出的数，然后对剩余部分继续拆分，直到整个字符串拆分完毕。

根据斐波那契式序列的要求，从第 $3$ 个数开始，每个数都等于前 $2$ 个数的和，因此从第 $3$ 个数开始，需要判断拆分出的数是否等于前 $2$ 个数的和，只有满足要求时才进行拆分，否则不进行拆分。

回溯过程中，还有三处可以进行剪枝操作。

- 拆分出的数如果不是 $0$，则不能以 $0$ 开头，因此如果字符串剩下的部分以 $0$ 开头，就不需要考虑拆分出长度大于 $1$ 的数，因为长度大于 $1$ 的数以 $0$ 开头是不符合要求的，不可能继续拆分得到斐波那契式序列；

- 拆分出的数必须符合 $32$ 位有符号整数类型，即每个数必须在 $[0,2^{31}-1]$ 的范围内，如果拆分出的数大于 $2^{31}-1$，则不符合要求，长度更大的数的数值也一定更大，一定也大于 $2^{31}-1$，因此不可能继续拆分得到斐波那契式序列；

- 如果列表中至少有 $2$ 个数，并且拆分出的数已经大于最后 $2$ 个数的和，就不需要继续尝试拆分了。

当整个字符串拆分完毕时，如果列表中至少有 $3$ 个数，则得到一个符合要求的斐波那契式序列，返回列表。如果没有找到符合要求的斐波那契式序列，则返回空列表。

实现方面，回溯需要带返回值，表示是否存在符合要求的斐波那契式序列。

```Java [sol1-Java]
class Solution {
    public List<Integer> splitIntoFibonacci(String num) {
        List<Integer> list = new ArrayList<Integer>();
        backtrack(list, num, num.length(), 0, 0, 0);
        return list;
    }

    public boolean backtrack(List<Integer> list, String num, int length, int index, int sum, int prev) {
        if (index == length) {
            return list.size() >= 3;
        }
        long currLong = 0;
        for (int i = index; i < length; i++) {
            if (i > index && num.charAt(index) == '0') {
                break;
            }
            currLong = currLong * 10 + num.charAt(i) - '0';
            if (currLong > Integer.MAX_VALUE) {
                break;
            }
            int curr = (int) currLong;
            if (list.size() >= 2) {
                if (curr < sum) {
                    continue;
                } else if (curr > sum) {
                    break;
                }
            }
            list.add(curr);
            if (backtrack(list, num, length, i + 1, prev + curr, curr)) {
                return true;
            } else {
                list.remove(list.size() - 1);
            }
        }
        return false;
    }
}
```

```C++ [sol1-C++]
class Solution {
public:
    vector<int> splitIntoFibonacci(string num) {
        vector<int> list;
        backtrack(list, num, num.length(), 0, 0, 0);
        return list;
    }

    bool backtrack(vector<int>& list, string num, int length, int index, long long sum, int prev) {
        if (index == length) {
            return list.size() >= 3;
        }
        long long curr = 0;
        for (int i = index; i < length; i++) {
            if (i > index && num[index] == '0') {
                break;
            }
            curr = curr * 10 + num[i] - '0';
            if (curr > INT_MAX) {
                break;
            }
            if (list.size() >= 2) {
                if (curr < sum) {
                    continue;
                }
                else if (curr > sum) {
                    break;
                }
            }
            list.push_back(curr);
            if (backtrack(list, num, length, i + 1, prev + curr, curr)) {
                return true;
            }
            list.pop_back();
        }
        return false;
    }
};
```

```JavaScript [sol1-JavaScript]
var splitIntoFibonacci = function(num) {
    const list = new Array().fill(0);
    backtrack(list, num, num.length, 0, 0, 0);
    return list;
};

const backtrack = (list, num, length, index, sum, prev) => {
    if (index === length) {
        return list.length >= 3;
    }
    let currLong = 0;
    for (let i = index; i < length; i++) {
        if (i > index && num[index] === '0') {
            break;
        }
        currLong = currLong * 10 + num[i].charCodeAt() - '0'.charCodeAt();
        if (currLong > Math.pow(2, 31) - 1) {
            break;
        }
        let curr = currLong;
        if (list.length >= 2) {
            if (curr < sum) {
                continue;
            } else if (curr > sum) {
                break;
            }
        }
        list.push(curr);
        if (backtrack(list, num, length, i + 1, prev + curr, curr)) {
            return true;
        } else {
            list.splice(list.length - 1, 1);
        }
    }
    return false;
}
```

```Python [sol1-Python3]
class Solution:
    def splitIntoFibonacci(self, num: str) -> List[int]:
        ans = list()

        def backtrack(index: int):
            if index == len(num):
                return len(ans) >= 3
            
            curr = 0
            for i in range(index, len(num)):
                if i > index and num[index] == "0":
                    break
                curr = curr * 10 + ord(num[i]) - ord("0")
                if curr > 2**31 - 1:
                    break
                
                if len(ans) < 2 or curr == ans[-2] + ans[-1]:
                    ans.append(curr)
                    if backtrack(i + 1):
                        return True
                    ans.pop()
                elif len(ans) > 2 and curr > ans[-2] + ans[-1]:
                    break
        
            return False
        
        backtrack(0)
        return ans
```

```Golang [sol1-Golang]
func splitIntoFibonacci(num string) (F []int) {
    n := len(num)
    var backtrack func(index, sum, prev int) bool
    backtrack = func(index, sum, prev int) bool {
        if index == n {
            return len(F) >= 3
        }

        cur := 0
        for i := index; i < n; i++ {
            // 每个块的数字一定不要以零开头，除非这个块是数字 0 本身
            if i > index && num[index] == '0' {
                break
            }

            cur = cur*10 + int(num[i]-'0')
            // 拆出的整数要符合 32 位有符号整数类型
            if cur > math.MaxInt32 {
                break
            }

            // F[i] + F[i+1] = F[i+2]
            if len(F) >= 2 {
                if cur < sum {
                    continue
                }
                if cur > sum {
                    break
                }
            }

            // cur 符合要求，加入序列 F
            F = append(F, cur)
            if backtrack(i+1, prev+cur, cur) {
                return true
            }
            F = F[:len(F)-1]
        }
        return false
    }
    backtrack(0, 0, 0)
    return
}
```

```C [sol1-C]
bool backtrack(int* list, int* listSize, char* num, int length, int index, long long sum, int prev) {
    if (index == length) {
        return (*listSize) >= 3;
    }
    long long curr = 0;
    for (int i = index; i < length; i++) {
        if (i > index && num[index] == '0') {
            break;
        }
        curr = curr * 10 + num[i] - '0';
        if (curr > INT_MAX) {
            break;
        }
        if ((*listSize) >= 2) {
            if (curr < sum) {
                continue;
            } else if (curr > sum) {
                break;
            }
        }
        list[(*listSize)++] = curr;
        if (backtrack(list, listSize, num, length, i + 1, prev + curr, curr)) {
            return true;
        }
        (*listSize)--;
    }
    return false;
}

int* splitIntoFibonacci(char* num, int* returnSize) {
    int n = strlen(num);
    int* list = malloc(sizeof(int) * n);
    *returnSize = 0;
    backtrack(list, returnSize, num, strlen(num), 0, 0, 0);
    return list;
}
```

**复杂度分析**

- 时间复杂度：$O(n \log^2 C)$，其中 $n$ 是字符串的长度，$C$ 是题目规定的整数范围 $2^{31}-1$。在回溯的过程中，实际上真正进行「回溯」的只有前 $2$ 个数，而从第 $3$ 个数开始，整个斐波那契数列是可以被唯一确定的，整个回溯过程只起到验证（而不是枚举）的作用。对于前 $2$ 个数，它们的位数不能超过 $\lfloor \log_{10} C \rfloor$，那么枚举的空间为 $O(\log^2 C)$；对于后面的所有数，回溯的过程是没有「分支」的，因此时间复杂度为 $O(n)$，相乘即可得到总时间复杂度 $O(n \log^2 C)$。

- 空间复杂度：$O(n)$，其中 $n$ 是字符串的长度。除了返回值以外，空间复杂度主要取决于回溯过程中的递归调用层数，最大为 $n$。
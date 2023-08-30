#### 方法一：位运算

**思路**

记 $n$ 是数组 $\textit{nums}$ 的长度，数组中的每个元素都可以选取或者不选取，因此数组的非空子集数目一共有 $(2^n-1)$ 个。可以用一个长度为 $n$ 比特的整数来表示不同的子集，在整数的二进制表示中，$n$ 个比特的值代表了对数组不同元素的取舍。第 $i$ 位值为 $1$ 则表示该子集选取对应元素，第 $i$ 位值为 $0$ 则表示该子集不选取对应元素。求出每个子集的按位或的值，并计算取到最大值时的子集个数。

**代码**

```Python [sol1-Python3]
class Solution:
    def countMaxOrSubsets(self, nums: List[int]) -> int:
        maxOr, cnt = 0, 0
        for i in range(1, 1 << len(nums)):
            orVal = reduce(or_, (num for j, num in enumerate(nums) if (i >> j) & 1), 0)
            if orVal > maxOr:
                maxOr, cnt = orVal, 1
            elif orVal == maxOr:
                cnt += 1
        return cnt
```

```Java [sol1-Java]
class Solution {
    public int countMaxOrSubsets(int[] nums) {
        int maxOr = 0, cnt = 0;
        for (int i = 0; i < 1 << nums.length; i++) {
            int orVal = 0;
            for (int j = 0; j < nums.length; j++) {
                if (((i >> j) & 1) == 1) {
                    orVal |= nums[j];
                }
            }
            if (orVal > maxOr) {
                maxOr = orVal;
                cnt = 1;
            } else if (orVal == maxOr) {
                cnt++;
            }
        }
        return cnt;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int CountMaxOrSubsets(int[] nums) {
        int maxOr = 0, cnt = 0;
        for (int i = 0; i < 1 << nums.Length; i++) {
            int orVal = 0;
            for (int j = 0; j < nums.Length; j++) {
                if (((i >> j) & 1) == 1) {
                    orVal |= nums[j];
                }
            }
            if (orVal > maxOr) {
                maxOr = orVal;
                cnt = 1;
            } else if (orVal == maxOr) {
                cnt++;
            }
        }
        return cnt;
    }
}
```

```C++ [sol1-C++]
class Solution {
public:
    int countMaxOrSubsets(vector<int>& nums) {
        int n = nums.size(), maxValue = 0, cnt = 0, stateNumber = 1 << n;
        for (int i = 0; i < stateNumber; i++) {
            int cur = 0;
            for (int j = 0; j < n; j++) {
                if (((i >> j) & 1) == 1) {
                    cur |= nums[j];
                }
            }
            if (cur == maxValue) {
                cnt++;
            } else if (cur > maxValue) {
                maxValue = cur;
                cnt = 1;
            }
        }
        return cnt;
    }
};
```

```C [sol1-C]
int countMaxOrSubsets(int* nums, int numsSize){
    int n = numsSize, maxValue = 0, cnt = 0, stateNumber = 1 << n;
    for (int i = 0; i < stateNumber; i++) {
        int cur = 0;
        for (int j = 0; j < n; j++) {
            if (((i >> j) & 1) == 1) {
                cur |= nums[j];
            }
        }
        if (cur == maxValue) {
            cnt++;
        } else if (cur > maxValue) {
            maxValue = cur;
            cnt = 1;
        }
    }
    return cnt;
}
```

```go [sol1-Golang]
func countMaxOrSubsets(nums []int) (ans int) {
    maxOr := 0
    for i := 1; i < 1<<len(nums); i++ {
        or := 0
        for j, num := range nums {
            if i>>j&1 == 1 {
                or |= num
            }
        }
        if or > maxOr {
            maxOr = or
            ans = 1
        } else if or == maxOr {
            ans++
        }
    }
    return
}
```

```JavaScript [sol1-JavaScript]
var countMaxOrSubsets = function(nums) {
    let maxOr = 0, cnt = 0;
    for (let i = 0; i < 1 << nums.length; i++) {
        let orVal = 0;
        for (let j = 0; j < nums.length; j++) {
            if (((i >> j) & 1) === 1) {
                orVal |= nums[j];
            }
        }
        if (orVal > maxOr) {
            maxOr = orVal;
            cnt = 1;
        } else if (orVal === maxOr) {
            cnt++;
        }
    }
    return cnt;
};
```

**复杂度分析**

- 时间复杂度：$O(2^n \times n)$，其中 $n$ 是数组 $\textit{nums}$ 的长度。需要遍历 $O(2^n)$ 个状态，遍历每个状态时需要遍历 $O(n)$ 位。

- 空间复杂度：$O(1)$。仅使用常量空间。

#### 方法二：回溯

**思路**

记 $n$ 是数组 $\textit{nums}$ 的长度。方法一的缺点是，计算不同状态的按位或的值，都需要消耗 $O(n)$ 的时间。这一步部分可以进行优化。每个长度为 $n$ 比特的状态的按位或的值，都是可以在长度为 $n - 1$ 比特的状态的按位或的值上计算出来的，而这个计算只需要消耗常数时间。以此类推，边界情况是长度为 $0$ 比特的状态的按位或的值。我们定义一个搜索函数，参数 $\textit{pos}$ 表示当前下标，$\textit{orVal}$ 表示当前下标之前的某个子集按位或值，这样就可以保存子集按位或的值的信息，并根据当前元素选择与否更新 $\textit{orVal}$。当搜索到最后位置时，更新最大值和子集个数。

**代码**

```Python [sol2-Python3]
class Solution:
    def countMaxOrSubsets(self, nums: List[int]) -> int:
        maxOr, cnt = 0, 0
        def dfs(pos: int, orVal: int) -> None:
            if pos == len(nums):
                nonlocal maxOr, cnt
                if orVal > maxOr:
                    maxOr, cnt = orVal, 1
                elif orVal == maxOr:
                    cnt += 1
                return
            dfs(pos + 1, orVal | nums[pos])
            dfs(pos + 1, orVal)
        dfs(0, 0)
        return cnt
```

```Java [sol2-Java]
class Solution {
    int[] nums;
    int maxOr, cnt;

    public int countMaxOrSubsets(int[] nums) {
        this.nums = nums;
        this.maxOr = 0;
        this.cnt = 0;
        dfs(0, 0);
        return cnt;
    }

    public void dfs(int pos, int orVal) {
        if (pos == nums.length) {
            if (orVal > maxOr) {
                maxOr = orVal;
                cnt = 1;
            } else if (orVal == maxOr) {
                cnt++;
            }
            return;
        }
        dfs(pos + 1, orVal | nums[pos]);
        dfs(pos + 1, orVal);
    }
}
```

```C# [sol2-C#]
public class Solution {
    int[] nums;
    int maxOr, cnt;

    public int CountMaxOrSubsets(int[] nums) {
        this.nums = nums;
        this.maxOr = 0;
        this.cnt = 0;
        DFS(0, 0);
        return cnt;
    }

    public void DFS(int pos, int orVal) {
        if (pos == nums.Length) {
            if (orVal > maxOr) {
                maxOr = orVal;
                cnt = 1;
            } else if (orVal == maxOr) {
                cnt++;
            }
            return;
        }
        DFS(pos + 1, orVal | nums[pos]);
        DFS(pos + 1, orVal);
    }
}
```

```C++ [sol2-C++]
class Solution {
public:
    int countMaxOrSubsets(vector<int>& nums) {
        this->nums = nums;
        this->maxOr = 0;
        this->cnt = 0;
        dfs(0, 0);
        return cnt;
    }

    void dfs(int pos, int orVal) {
        if (pos == nums.size()) {
            if (orVal > maxOr) {
                maxOr = orVal;
                cnt = 1;
            } else if (orVal == maxOr) {
                cnt++;
            }
            return;
        }
        dfs(pos + 1, orVal| nums[pos]);
        dfs(pos + 1, orVal);
    }

private:
    vector<int> nums;
    int maxOr, cnt;
};
```

```C [sol2-C]
void dfs(int pos, int orVal, const int* nums, int numsSize, int* maxOr, int* cnt) {
    if (pos == numsSize) {
        if (orVal > *maxOr) {
            *maxOr = orVal;
            *cnt = 1;
        } else if (orVal == *maxOr) {
            (*cnt)++;
        }
        return;
    }
    dfs(pos + 1, orVal | nums[pos], nums, numsSize, maxOr, cnt);
    dfs(pos + 1, orVal, nums, numsSize, maxOr, cnt);
}

int countMaxOrSubsets(int* nums, int numsSize) {
    int cnt = 0;
    int maxOr = 0;
    dfs(0, 0, nums, numsSize, &maxOr, &cnt);
    return cnt;
}
```

```go [sol2-Golang]
func countMaxOrSubsets(nums []int) (ans int) {
    maxOr := 0
    var dfs func(int, int)
    dfs = func(pos, or int) {
        if pos == len(nums) {
            if or > maxOr {
                maxOr = or
                ans = 1
            } else if or == maxOr {
                ans++
            }
            return
        }
        dfs(pos+1, or|nums[pos])
        dfs(pos+1, or)
    }
    dfs(0, 0)
    return
}
```

```JavaScript [sol2-JavaScript]
var countMaxOrSubsets = function(nums) {
    this.nums = nums;
    this.maxOr = 0;
    this.cnt = 0;
    dfs(0, 0);
    return cnt;
};

const dfs = (pos, orVal) => {
    if (pos === nums.length) {
        if (orVal > maxOr) {
            maxOr = orVal;
            cnt = 1;
        } else if (orVal === maxOr) {
            cnt++;
        }
        return;
    }
    dfs(pos + 1, orVal | nums[pos]);
    dfs(pos + 1, orVal);
}
```

**复杂度分析**

- 时间复杂度：$O(2^n)$，其中 $n$ 是数组 $\textit{nums}$ 的长度。状态数一共有 $O(2^0 + 2^1 + ... + 2^n) = O(2\times2^n) = O(2^n)$ 种，每次计算只消耗常数时间。

- 空间复杂度：$O(n)$，其中 $n$ 是数组 $\textit{nums}$ 的长度。搜索深度最多为 $n$。
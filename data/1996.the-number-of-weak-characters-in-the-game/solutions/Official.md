## [1996.游戏中弱角色的数量 中文官方题解](https://leetcode.cn/problems/the-number-of-weak-characters-in-the-game/solutions/100000/you-xi-zhong-ruo-jiao-se-de-shu-liang-by-3d2g)

#### 方法一：排序

**思路**

对于每个角色，我们需要判断是否存在一个攻击值和防御值都高于它的角色，从而确定该角色是否为弱角色。我们可以按角色的某个属性（比如攻击值）从大到小的顺序遍历，同时记录已经遍历过的角色防御值的最大值 $\textit{maxDef}$。对于当前角色 $p$，如果 $p$ 的防御值严格小于 $\textit{maxDef}$，那么说明存在防御值比 $p$ 高的角色（记作 $q$），如果此时 $q$ 的攻击值也严格大于 $p$，则可以确定 $p$ 为弱角色。

如何保证当 $q$ 的防御值 $\textit{maxDef}$ 严格大于 $p$ 的防御值时，$q$ 的攻击值一定大于 $p$ 的攻击值，这是比较难处理的一点，因为可能存在攻击值相同的角色。
+ 最简单的处理办法就是将攻击值相同的角色进行单独分组，严格保证攻击值相同的角色被分到同一组，遍历时记录攻击值严格大于当前分组且防御值最大的角色 $q$。遍历当前分组时，如果发现角色 $p$ 的防御值严格小于 $q$ 的防御值，则此时可以肯定角色 $p$ 属于弱角色。
+ 实际处理时，对于攻击值相同的角色，我们按照其防御值从小到大进行排序且按照攻击值从大到小开始遍历，这样就可以保证当前已经遍历过的最大防御值角色 $q$ 的防御值 $\textit{maxDef}$ 严格大于当前角色 $p$ 的防御值时，则此时 $q$ 的攻击值一定严格大于 $p$ 的攻击值。因为相同的攻击值按照防御值从大到小进行排列，如果出现已经遍历过的角色 $q$ 的防御值大于 $p$ 的防御值，则此时我们可以肯定可以推理出角色 $q$ 与角色 $p$ 攻击值一定不相同。

**代码**

```Java [sol1-Java]
class Solution {
    public int numberOfWeakCharacters(int[][] properties) {
        Arrays.sort(properties, (o1, o2) -> {
            return o1[0] == o2[0] ? (o1[1] - o2[1]) : (o2[0] - o1[0]);
        });
        int maxDef = 0;
        int ans = 0;
        for (int[] p : properties) {
            if (p[1] < maxDef) {
                ans++;
            } else {
                maxDef = p[1];
            }
        }
        return ans;
    }
}
```

```C++ [sol1-C++]
class Solution {
public:
    int numberOfWeakCharacters(vector<vector<int>>& properties) {
        sort(properties.begin(), properties.end(), [](const vector<int> & a, const vector<int> & b) {
            return a[0] == b[0] ? (a[1] < b[1]) : (a[0] > b[0]);
        });
        
        int maxDef = 0;
        int ans = 0;
        for (auto & p : properties) {
            if (p[1] < maxDef) {
                ans++;
            } else {
                maxDef = p[1];
            }
        }
        return ans;
    }
};
```

```C# [sol1-C#]
public class Solution {
    public int NumberOfWeakCharacters(int[][] properties) {
        Array.Sort(properties, (o1, o2) => {
            return o1[0] == o2[0] ? (o1[1] - o2[1]) : (o2[0] - o1[0]);
        });
        int maxDef = 0;
        int ans = 0;
        foreach (int[] p in properties) {
            if (p[1] < maxDef) {
                ans++;
            } else {
                maxDef = p[1];
            }
        }
        return ans;
    }
}
```

```Python [sol1-Python3]
class Solution:
    def numberOfWeakCharacters(self, properties: List[List[int]]) -> int:
        properties.sort(key=lambda x: (-x[0], x[1]))
        ans = 0
        maxDef = 0
        for _, def_ in properties:
            if maxDef > def_:
                ans += 1
            else:
                maxDef = max(maxDef, def_)
        return ans
```

```C [sol1-C]
#define MAX(a, b) ((a) > (b) ? (a) : (b))

int cmp(const void * pa, const void *pb) {
    int * a = *((int**)pa);
    int * b = *((int**)pb);
    return a[0] == b[0] ? (a[1] - b[1]) : (b[0] - a[0]);
}

int numberOfWeakCharacters(int** properties, int propertiesSize, int* propertiesColSize){
    qsort(properties, propertiesSize, sizeof(int *), cmp);
    int ans = 0;
    int maxDef = 0;
    for (int i = 0; i < propertiesSize; i++) {
        if (properties[i][1] < maxDef) {
            ans++;
        } else {
            maxDef = MAX(maxDef, properties[i][1]);
        }
    }
    return ans;
}
```

```go [sol1-Golang]
func numberOfWeakCharacters(properties [][]int) (ans int) {
    sort.Slice(properties, func(i, j int) bool {
        p, q := properties[i], properties[j]
        return p[0] > q[0] || p[0] == q[0] && p[1] < q[1]
    })
    maxDef := 0
    for _, p := range properties {
        if p[1] < maxDef {
            ans++
        } else {
            maxDef = p[1]
        }
    }
    return
}
```

```JavaScript [sol1-JavaScript]
var numberOfWeakCharacters = function(properties) {
    properties.sort((o1, o2) => {
        return o1[0] === o2[0] ? (o1[1] - o2[1]) : (o2[0] - o1[0]);
    });
    let maxDef = 0;
    let ans = 0;
    for (const p of properties) {
        if (p[1] < maxDef) {
            ans++;
        } else {
            maxDef = p[1];
        }
    }
    return ans;
};
```

**复杂度分析**

- 时间复杂度：$O(n \log n)$，其中 $n$ 为数组的长度。排序的时间复杂度为 $O(n \log n)$，遍历数组的时间为 $O(n)$，总的时间复杂度为 $O(n \log n + n) = O(n \log n)$。

- 空间复杂度：$O(\log n)$，其中 $n$ 为数组的长度。排序时使用的栈空间为 $O(\log n)$。

#### 方法二：单调栈

**思路**

对于角色 $p$，如果我们找到一个角色 $q$ 的防御值与攻击值都严格高于 $p$ 的攻击值和防御值，则我们认为角色 $p$ 为弱角色。
+ 我们联想到使用单调递增栈的解法，单调递增栈中保证栈内所有的元素都按照从小到大进行排列。按照角色攻击值的大小从低到高依次遍历每个元素，使用单调递增栈保存所有角色的防御值，遍历时如果发现栈顶的角色 $p$ 的防御值小于当前的角色 $q$ 的防御值，则可以认为找到攻击值和防御值都严格大于 $p$ 的角色 $q$。
+ 如果所有角色的攻击值都不相同，则上述的单调递增栈的解法比较简单，难点在于如何处理攻击值相同但防御值不同的角色比较问题。我们按照攻击值相同时防御值从大到小进行排序，这样即可保证攻击值相同但防御值不同时的角色在进行比较时不会产生计数。

**代码**

```Java [sol2-Java]
class Solution {
    public int numberOfWeakCharacters(int[][] properties) {
        Arrays.sort(properties, (o1, o2) -> {
            return o1[0] == o2[0] ? (o2[1] - o1[1]) : (o1[0] - o2[0]);
        });
        int ans = 0;
        Deque<Integer> st = new ArrayDeque<Integer>();
        for (int[] p : properties) {
            while (!st.isEmpty() && st.peek() < p[1]) {
                st.pop();
                ans++;
            }
            st.push(p[1]);
        }
        return ans;
    }
}
```

```C++ [sol2-C++]
class Solution {
public:
    int numberOfWeakCharacters(vector<vector<int>>& properties) {
        sort(begin(properties), end(properties), [](const vector<int> & a, const vector<int> & b) {
            return a[0] == b[0] ? (a[1] > b[1]) : (a[0] < b[0]);
        });
        stack<int> st;
        int ans = 0;
        for (auto & p: properties) {
            while (!st.empty() && st.top() < p[1]) {
                ++ans;
                st.pop();
            }
            st.push(p[1]);
        }
        return ans;
    }
};
```

```C# [sol2-C#]
public class Solution {
    public int NumberOfWeakCharacters(int[][] properties) {
        Array.Sort(properties, (o1, o2) => {
            return o1[0] == o2[0] ? (o2[1] - o1[1]) : (o1[0] - o2[0]);
        });
        int ans = 0;
        Stack<int> st = new Stack<int>();
        foreach (int[] p in properties) {
            while (st.Count > 0 && st.Peek() < p[1]) {
                st.Pop();
                ans++;
            }
            st.Push(p[1]);
        }
        return ans;
    }
}
```

```Python [sol2-Python3]
class Solution:
    def numberOfWeakCharacters(self, properties: List[List[int]]) -> int:
        properties.sort(key = lambda x: (x[0], -x[1]))
        ans = 0
        st = []
        for _, def_ in properties:
            while st and st[-1] < def_:
                st.pop()
                ans += 1
            st.append(def_)
        return ans
```

```C [sol2-C]
int cmp(const void * pa, const void *pb) {
    int * a = *((int**)pa);
    int * b = *((int**)pb);
    return a[0] == b[0] ? (b[1] - a[1]) : (a[0] - b[0]);
}

int numberOfWeakCharacters(int** properties, int propertiesSize, int* propertiesColSize){
    qsort(properties, propertiesSize, sizeof(int *), cmp);
    int * stack = (int *)malloc(sizeof(int) * propertiesSize);
    int ans = 0;
    int stackSize = 0;
    for (int i = 0; i < propertiesSize; i++) {
        while (stackSize > 0 && stack[stackSize - 1] < properties[i][1]) {
            stackSize--;
            ans++;
        }
        stack[stackSize++] = properties[i][1];
    }
    free(stack);
    return ans;
}
```

```go [sol2-Golang]
func numberOfWeakCharacters(properties [][]int) (ans int) {
    sort.Slice(properties, func(i, j int) bool {
        p, q := properties[i], properties[j]
        return p[0] < q[0] || p[0] == q[0] && p[1] > q[1]
    })
    st := []int{}
    for _, p := range properties {
        for len(st) > 0 && st[len(st)-1] < p[1] {
            st = st[:len(st)-1]
            ans++
        }
        st = append(st, p[1])
    }
    return
}
```

```JavaScript [sol2-JavaScript]
var numberOfWeakCharacters = function(properties) {
    properties.sort((o1, o2) => {
        return o1[0] === o2[0] ? (o2[1] - o1[1]) : (o1[0] - o2[0]);
    });
    let ans = 0;
    const st = [];
    for (const p of properties) {
        while (st.length && st[st.length - 1] < p[1]) {
            st.pop();
            ans++;
        }
        st.push(p[1]);
    }
    return ans;
};
```

**复杂度分析**

- 时间复杂度：$O(n \log n)$，其中 $n$ 为数组的长度。排序的时间复杂度为 $O(n \log n)$，然后需要一次遍历的时间为 $O(n)$，总的时间复杂度 $O(n \log n + n) = O(n \log n)$。

- 空间复杂度：$O(n)$，其中 $n$ 为数组的长度。需要栈来保存中间变量。
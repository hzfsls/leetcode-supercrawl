#### 方法一：哈希表

如果不考虑数组的大小，我们可以在构造函数中，用一个哈希表 $\textit{pos}$ 记录 $\textit{nums}$ 中相同元素的下标。

对于 $\text{pick}$ 操作，我们可以从 $\textit{pos}$ 中取出 $\textit{target}$ 对应的下标列表，然后随机选择其中一个下标并返回。

```Python [sol1-Python3]
class Solution:
    def __init__(self, nums: List[int]):
        self.pos = defaultdict(list)
        for i, num in enumerate(nums):
            self.pos[num].append(i)

    def pick(self, target: int) -> int:
        return choice(self.pos[target])
```

```C++ [sol1-C++]
class Solution {
    unordered_map<int, vector<int>> pos;
public:
    Solution(vector<int> &nums) {
        for (int i = 0; i < nums.size(); ++i) {
            pos[nums[i]].push_back(i);
        }
    }

    int pick(int target) {
        auto &indices = pos[target];
        return indices[rand() % indices.size()];
    }
};
```

```Java [sol1-Java]
class Solution {
    Map<Integer, List<Integer>> pos;
    Random random;

    public Solution(int[] nums) {
        pos = new HashMap<Integer, List<Integer>>();
        random = new Random();
        for (int i = 0; i < nums.length; ++i) {
            pos.putIfAbsent(nums[i], new ArrayList<Integer>());
            pos.get(nums[i]).add(i);
        }
    }

    public int pick(int target) {
        List<Integer> indices = pos.get(target);
        return indices.get(random.nextInt(indices.size()));
    }
}
```

```C# [sol1-C#]
public class Solution {
    Dictionary<int, IList<int>> pos;
    Random random;

    public Solution(int[] nums) {
        pos = new Dictionary<int, IList<int>>();
        random = new Random();
        for (int i = 0; i < nums.Length; ++i) {
            if (!pos.ContainsKey(nums[i])) {
                pos.Add(nums[i], new List<int>());
            }
            pos[nums[i]].Add(i);
        }
    }

    public int Pick(int target) {
        IList<int> indices = pos[target];
        return indices[random.Next(indices.Count)];
    }
}
```

```go [sol1-Golang]
type Solution map[int][]int

func Constructor(nums []int) Solution {
    pos := map[int][]int{}
    for i, v := range nums {
        pos[v] = append(pos[v], i)
    }
    return pos
}

func (pos Solution) Pick(target int) int {
    indices := pos[target]
    return indices[rand.Intn(len(indices))]
}
```

```C [sol1-C]
typedef struct {
    int key;
    int *array;
    int capacity;
    int size;
    UT_hash_handle hh;
} HashItem;

typedef struct {
    HashItem *pos;
} Solution;

void hashInsert(HashItem **obj, int key, int idx) {
    HashItem * pEntry = NULL;
    HASH_FIND_INT(*obj, &key, pEntry);
    if (!pEntry) {
        pEntry = malloc(sizeof(HashItem));
        pEntry->key = key;
        pEntry->capacity = 64;
        pEntry->size = 0;
        pEntry->array = calloc(pEntry->capacity, sizeof(int));
        HASH_ADD_INT(*obj, key, pEntry);
    }
    if (pEntry->size == pEntry->capacity) {
        pEntry->capacity *= 2; 
        pEntry->array = realloc(pEntry->array, pEntry->capacity * sizeof(int));
    }
    pEntry->array[(pEntry->size)++] = idx;
}

Solution* solutionCreate(int* nums, int numsSize) {
    Solution *obj = malloc(sizeof(Solution));
    obj->pos = NULL;
    for (int i = 0; i < numsSize; ++i) {
        hashInsert(&obj->pos, nums[i], i);
    }
    return obj;
}

int solutionPick(Solution* obj, int target) {
    HashItem *pEntry = NULL;
    HASH_FIND_INT(obj->pos, &target, pEntry);
    if (!pEntry) {
        return -1;
    }
    return pEntry->array[rand() % pEntry->size];
}

void solutionFree(Solution* obj) {
    HashItem *curr, *tmp;
    HASH_ITER(hh, obj->pos, curr, tmp) {
        HASH_DEL(obj->pos, curr);
        free(curr->array);
        free(curr);
    }
    free(obj);
}
```

```JavaScript [sol1-JavaScript]
var Solution = function(nums) {
    this.pos = new Map();
    for (let i = 0; i < nums.length; ++i) {
        if (!this.pos.has(nums[i])) {
            this.pos.set(nums[i], []);
        }
        
        this.pos.get(nums[i]).push(i);
    }
};

Solution.prototype.pick = function(target) {
    const indices = this.pos.get(target);
    return indices[Math.floor(Math.random() * indices.length)];
};
```

**复杂度分析**

- 时间复杂度：初始化为 $O(n)$，$\text{pick}$ 为 $O(1)$，其中 $n$ 是 $\textit{nums}$ 的长度。
        
- 空间复杂度：$O(n)$。我们需要 $O(n)$ 的空间存储 $n$ 个下标。

#### 方法二：水塘抽样

如果数组以文件形式存储（读者可假设构造函数传入的是个文件路径），且文件大小远超内存大小，我们是无法通过读文件的方式，将所有下标保存在内存中的，因此需要找到一种空间复杂度更低的算法。

我们可以设计如下算法实现 $\text{pick}$ 操作：

遍历 $\textit{nums}$，当我们第 $i$ 次遇到值为 $\textit{target}$ 的元素时，随机选择区间 $[0,i)$ 内的一个整数，如果其等于 $0$，则将返回值置为该元素的下标，否则返回值不变。

设 $\textit{nums}$ 中有 $k$ 个值为 $\textit{target}$ 的元素，该算法会保证这 $k$ 个元素的下标成为最终返回值的概率均为 $\dfrac{1}{k}$，证明如下：

$$
\begin{aligned} 
&P(第\ i\ 次遇到值为\ \textit{target}\ \ 的元素的下标成为最终返回值)\\
=&P(第\ i\ 次随机选择的值= 0) \times P(第\ i+1\ 次随机选择的值\ne 0) \times \cdots \times P(第\ k\ 次随机选择的值\ne 0)\\
=&\dfrac{1}{i} \times (1-\dfrac{1}{i+1}) \times \cdots \times (1-\dfrac{1}{k})\\
=&\dfrac{1}{i} \times \dfrac{i}{i+1} \times \cdots \times \dfrac{k-1}{k}\\
=&\dfrac{1}{k}
\end{aligned}
$$

```Python [sol2-Python3]
class Solution:
    def __init__(self, nums: List[int]):
        self.nums = nums

    def pick(self, target: int) -> int:
        ans = cnt = 0
        for i, num in enumerate(self.nums):
            if num == target:
                cnt += 1  # 第 cnt 次遇到 target
                if randrange(cnt) == 0:
                    ans = i
        return ans
```

```C++ [sol2-C++]
class Solution {
    vector<int> &nums;
public:
    Solution(vector<int> &nums) : nums(nums) {}

    int pick(int target) {
        int ans;
        for (int i = 0, cnt = 0; i < nums.size(); ++i) {
            if (nums[i] == target) {
                ++cnt; // 第 cnt 次遇到 target
                if (rand() % cnt == 0) {
                    ans = i;
                }
            }
        }
        return ans;
    }
};
```

```Java [sol2-Java]
class Solution {
    int[] nums;
    Random random;

    public Solution(int[] nums) {
        this.nums = nums;
        random = new Random();
    }

    public int pick(int target) {
        int ans = 0;
        for (int i = 0, cnt = 0; i < nums.length; ++i) {
            if (nums[i] == target) {
                ++cnt; // 第 cnt 次遇到 target
                if (random.nextInt(cnt) == 0) {
                    ans = i;
                }
            }
        }
        return ans;
    }
}
```

```C# [sol2-C#]
public class Solution {
    int[] nums;
    Random random;

    public Solution(int[] nums) {
        this.nums = nums;
        random = new Random();
    }

    public int Pick(int target) {
        int ans = 0;
        for (int i = 0, cnt = 0; i < nums.Length; ++i) {
            if (nums[i] == target) {
                ++cnt; // 第 cnt 次遇到 target
                if (random.Next(cnt) == 0) {
                    ans = i;
                }
            }
        }
        return ans;
    }
}
```

```go [sol2-Golang]
type Solution []int

func Constructor(nums []int) Solution {
    return nums
}

func (nums Solution) Pick(target int) (ans int) {
    cnt := 0
    for i, num := range nums {
        if num == target {
            cnt++ // 第 cnt 次遇到 target
            if rand.Intn(cnt) == 0 {
                ans = i
            }
        }
    }
    return
}
```

```C [sol2-C]
typedef struct {
    int *nums;
    int numsSize;
} Solution;


Solution* solutionCreate(int* nums, int numsSize) {
    Solution *obj = (Solution *)malloc(sizeof(Solution));
    obj->nums = nums;
    obj->numsSize = numsSize;
    return obj;
}

int solutionPick(Solution* obj, int target) {
    int ans;
    for (int i = 0, cnt = 0; i < obj->numsSize; ++i) {
        if (obj->nums[i] == target) {
            ++cnt; 
            if (rand() % cnt == 0) {
                ans = i;
            }
        }
    }
    return ans;
}

void solutionFree(Solution* obj) {
    free(obj);
}
```

```JavaScript [sol2-JavaScript]
var Solution = function(nums) {
    this.nums = nums;
};

Solution.prototype.pick = function(target) {
    let ans = 0;
    for (let i = 0, cnt = 0; i < this.nums.length; ++i) {
        if (this.nums[i] == target) {
            ++cnt; // 第 cnt 次遇到 target
            if (Math.floor(Math.random() * cnt) === 0) {
                ans = i;
            }
        }
    }
    return ans;
};
```

- 时间复杂度：初始化为 $O(1)$，$\text{pick}$ 为 $O(n)$，其中 $n$ 是 $\textit{nums}$ 的长度。

- 空间复杂度：$O(1)$。我们只需要常数的空间保存若干变量。
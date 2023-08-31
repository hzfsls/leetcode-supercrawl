## [1282.用户分组 中文官方题解](https://leetcode.cn/problems/group-the-people-given-the-group-size-they-belong-to/solutions/100000/yong-hu-fen-zu-by-leetcode-solution)
#### 方法一：哈希表

由于给定的输入一定存在有效的解，因此对于数组 $\textit{groupSizes}$ 中的每个元素 $x$，当 $x$ 在数组中出现 $y$ 次时，$y$ 一定能被 $x$ 整除，且大小为 $x$ 的组有 $\dfrac{y}{x}$ 个。

首先将每个人的编号按照组的大小划分，使用哈希表记录每个组的大小对应的所有人的编号。然后遍历哈希表，对于大小为 $x$ 的组，得到对应的所有人编号列表，将列表的大小记为 $y$，则 $y$ 一定能被 $x$ 整除，将列表分成 $\dfrac{y}{x}$ 个大小为 $x$ 的组，并将每个组添加到答案中。遍历结束之后，即完成分组。

考虑示例 1 的分组。

1. 根据数组 $\textit{groupSizes}$ 得到每个组的大小对应的所有人的编号：大小为 $1$ 的组对应的编号列表是 $[5]$，大小为 $3$ 的组对应的编号列表是 $[0, 1, 2, 3, 4, 6]$。

2. 将每个组的大小对应的编号列表分成特定大小的列表。

   - 大小为 $1$ 的组对应的编号列表的长度是 $1$，因此有 $1$ 个大小为 $1$ 的组：$[5]$。

   - 大小为 $3$ 的组对应的编号列表的长度是 $6$，因此有 $2$ 个大小为 $3$ 的组：$[0, 1, 2], [3, 4, 6]$。

3. 最终分组情况是 $[[5], [0, 1, 2], [3, 4, 6]$。

```Python [sol1-Python3]
class Solution:
    def groupThePeople(self, groupSizes: List[int]) -> List[List[int]]:
        groups = defaultdict(list)
        for i, size in enumerate(groupSizes):
            groups[size].append(i)
        ans = []
        for size, people in groups.items():
            ans.extend(people[i: i + size] for i in range(0, len(people), size))
        return ans
```

```Java [sol1-Java]
class Solution {
    public List<List<Integer>> groupThePeople(int[] groupSizes) {
        Map<Integer, List<Integer>> groups = new HashMap<Integer, List<Integer>>();
        int n = groupSizes.length;
        for (int i = 0; i < n; i++) {
            int size = groupSizes[i];
            groups.putIfAbsent(size, new ArrayList<Integer>());
            groups.get(size).add(i);
        }
        List<List<Integer>> groupList = new ArrayList<List<Integer>>();
        for (Map.Entry<Integer, List<Integer>> entry : groups.entrySet()) {
            int size = entry.getKey();
            List<Integer> people = entry.getValue();
            int groupCount = people.size() / size;
            for (int i = 0; i < groupCount; i++) {
                List<Integer> group = new ArrayList<Integer>();
                int start = i * size;
                for (int j = 0; j < size; j++) {
                    group.add(people.get(start + j));
                }
                groupList.add(group);
            }
        }
        return groupList;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public IList<IList<int>> GroupThePeople(int[] groupSizes) {
        Dictionary<int, IList<int>> groups = new Dictionary<int, IList<int>>();
        int n = groupSizes.Length;
        for (int i = 0; i < n; i++) {
            int size = groupSizes[i];
            groups.TryAdd(size, new List<int>());
            groups[size].Add(i);
        }
        IList<IList<int>> groupList = new List<IList<int>>();
        foreach (KeyValuePair<int, IList<int>> pair in groups) {
            int size = pair.Key;
            IList<int> people = pair.Value;
            int groupCount = people.Count / size;
            for (int i = 0; i < groupCount; i++) {
                IList<int> group = new List<int>();
                int start = i * size;
                for (int j = 0; j < size; j++) {
                    group.Add(people[start + j]);
                }
                groupList.Add(group);
            }
        }
        return groupList;
    }
}
```

```C++ [sol1-C++]
class Solution {
public:
    vector<vector<int>> groupThePeople(vector<int>& groupSizes) {
        unordered_map<int, vector<int>> groups;
        int n = groupSizes.size();
        for (int i = 0; i < n; i++) {
            int size = groupSizes[i];
            groups[size].emplace_back(i);
        }
        vector<vector<int>> groupList;
        for (auto &[size, people] : groups) {
            int groupCount = people.size() / size;
            for (int i = 0; i < groupCount; i++) {
                vector<int> group;
                int start = i * size;
                for (int j = 0; j < size; j++) {
                    group.emplace_back(people[start + j]);
                }
                groupList.emplace_back(group);
            }
        }
        return groupList;
    }
};
```

```C [sol1-C]
typedef struct Array {
    int *arr;
    int pos;
    int size;
} Array;

Array* creatArray(int size) {
    Array *obj = (Array *)malloc(sizeof(Array));
    obj->arr = (int *)malloc(sizeof(int) * size);
    obj->size = size;
    obj->pos = 0;
    return obj;
}

void freeArray(Array *obj) {
    free(obj->arr);
    free(obj);
}

int** groupThePeople(int* groupSizes, int groupSizesSize, int* returnSize, int** returnColumnSizes){
    Array **groups = (Array **)malloc(sizeof(Array *) * (groupSizesSize + 1));
    for (int i = 0; i <= groupSizesSize; i++) {
        groups[i] = creatArray(groupSizesSize);
    }
    for (int i = 0; i < groupSizesSize; i++) {
        int size = groupSizes[i];
        groups[size]->arr[groups[size]->pos++] = i;
    }
    int **groupList = (int **)malloc(sizeof(int *) * groupSizesSize);
    *returnColumnSizes = (int *)malloc(sizeof(int) * groupSizesSize);
    int pos = 0;
    for (int k = 0; k <= groupSizesSize; k++) {
        if (groups[k]->pos == 0) {
            continue;
        }
        int size = k;
        int groupCount = groups[k]->pos / size;
        for (int i = 0; i < groupCount; i++) {
            int *group = (int *)malloc(sizeof(int) * size);
            int start = i * size, index = 0;
            for (int j = 0; j < size; j++) {
                group[index++] = groups[k]->arr[start + j];
            }
            (*returnColumnSizes)[pos] = size;
            groupList[pos++] = group;
        }
    }
    *returnSize = pos;
    for (int i = 0; i <= groupSizesSize; i++) {
        freeArray(groups[i]);
    }
    return groupList;
}
```

```JavaScript [sol1-JavaScript]
var groupThePeople = function(groupSizes) {
    const groups = new Map();
    const n = groupSizes.length;
    for (let i = 0; i < n; i++) {
        const size = groupSizes[i];
        if (!groups.has(size)) {
            groups.set(size, []);
        }
        groups.get(size).push(i);
    }
    const groupList = [];
    for (const [size, people] of groups.entries()) {
        const groupCount = Math.floor(people.length / size);
        for (let i = 0; i < groupCount; i++) {
            const group = [];
            const start = i * size;
            for (let j = 0; j < size; j++) {
                group.push(people[start + j]);
            }
            groupList.push(group);
        }
    }
    return groupList;
};
```

```go [sol1-Golang]
func groupThePeople(groupSizes []int) (ans [][]int) {
    groups := map[int][]int{}
    for i, size := range groupSizes {
        groups[size] = append(groups[size], i)
    }
    for size, people := range groups {
        for i := 0; i < len(people); i += size {
            ans = append(ans, people[i:i+size])
        }
    }
    return
}
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 是数组 $\textit{groupSize}$ 的长度。需要遍历数组一次得到每个组的大小对应的所有人的编号，然后需要遍历所有元素完成分组。

- 空间复杂度：$O(n)$，其中 $n$ 是数组 $\textit{groupSize}$ 的长度。空间复杂度主要取决于哈希表，哈希表需要 $O(n)$ 的空间记录每个组的大小对应的所有人的编号。
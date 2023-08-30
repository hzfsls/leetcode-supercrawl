#### 方法一：排序

**思路与算法**

我们可以将 $\textit{names}[i]$ 和 $\textit{heights}[i]$ 绑定为一个二元组，然后对所有的二元组按照 $\textit{heights}$ 排序。最后取出其中的 $\textit{names}$ 即为答案。

除了以上方法，我们还可以创建一个索引数组 $\textit{indices}$，其中 $\textit{indices}[i] = i$。排序完成后，对于所有的 $i, j~(i\lt j)$ 都有 $\textit{heights}[\textit{indices}[i]] > \textit{heights}[\textit{indices}[j]]$。然后我们遍历 $i$ 从 $0$ 到 $n-1$，将 $\textit{names}[\textit{indices}[i]]$ 追加到答案数组中。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    vector<string> sortPeople(vector<string>& names, vector<int>& heights) {
        int n = names.size();
        vector<int> indices(n);
        iota(indices.begin(), indices.end(), 0);
        sort(indices.begin(), indices.end(), [&](int x, int y) {
            return heights[x] > heights[y];
        });
        vector<string> res(n);
        for (int i = 0; i < n; i++) {
            res[i] = names[indices[i]];
        }
        return res;
    }
};
```

```Java [sol1-Java]
class Solution {
    public String[] sortPeople(String[] names, int[] heights) {
        int n = names.length;
        Integer[] indices = new Integer[n];
        for (int i = 0; i < n; i++) {
            indices[i] = i;
        }
        Arrays.sort(indices, (a, b) -> heights[b] - heights[a]);
        String[] res = new String[n];
        for (int i = 0; i < n; i++) {
            res[i] = names[indices[i]];
        }
        return res;
    }
}
```

```Python [sol1-Python3]
class Solution:
    def sortPeople(self, names: List[str], heights: List[int]) -> List[str]:
        n = len(names)
        indices = list(range(n))
        indices.sort(key=lambda x: heights[x], reverse=True)
        res = []
        for i in indices:
            res.append(names[i])
        return res
```

```Go [sol1-Go]
func sortPeople(names []string, heights []int) []string {
    n := len(names)
    indices := make([]int, n)
    for i := 0; i < n; i++ {
        indices[i] = i
    }
    sort.Slice(indices, func(i, j int) bool {
        return heights[indices[j]] < heights[indices[i]]
    })
    res := make([]string, n)
    for i := 0; i < n; i++ {
        res[i] = names[indices[i]]
    }
    return res
}

```

```JavaScript [sol1-JavaScript]
var sortPeople = function(names, heights) {
    const n = names.length;
    const indices = Array.from({length: n}, (_, i) => i);
    indices.sort((a, b) => heights[b] - heights[a]);
    const res = new Array(n);
    for (let i = 0; i < n; i++) {
        res[i] = names[indices[i]];
    }
    return res;
};
```

```C# [sol1-C#]
public class Solution {
    public string[] SortPeople(string[] names, int[] heights) {
        int n = names.Length;
        int[] indices = new int[n];
        for (int i = 0; i < n; i++) {
            indices[i] = i;
        }
        Array.Sort(indices, (a, b) => heights[b] - heights[a]);
        string[] res = new string[n];
        for (int i = 0; i < n; i++) {
            res[i] = names[indices[i]];
        }
        return res;
    }
}
```

```C [sol1-C]
int cmp(const void *pa, const void *pb) {
    int *a = (int *)pa;
    int *b = (int *)pb;
    return b[0] - a[0];
}

char ** sortPeople(char ** names, int namesSize, int* heights, int heightsSize, int* returnSize) {
    int indices[heightsSize][2];
    for (int i = 0; i < heightsSize; i++) {
        indices[i][0] = heights[i];
        indices[i][1] = i;
    }
    qsort(indices, heightsSize, sizeof(indices[0]), cmp);
    int **res = (int **)malloc(sizeof(char *) * heightsSize);
    for (int i = 0; i < heightsSize; i++) {
        int index = indices[i][1];
        res[i] = names[index];
    }
    *returnSize = heightsSize;
    return res;
}
```

**复杂度分析**

- 时间复杂度：$O(n\log n)$，其中 $n$ 是 $\textit{names}$ 和 $\textit{heights}$ 的长度。对 $\textit{indices}$ 数组排序的时间复杂度为 $O(n\log n)$。

- 空间复杂度：$O(n)$，其中 $n$ 是 $\textit{names}$ 和 $\textit{heights}$ 的长度。排序过程中所需要的栈空间为 $O(\log n)$，创建 $\textit{indices}$ 数组所需要的空间是 $O(n)$，对它们求和后空间复杂度渐进意义下等于 $O(n)$。
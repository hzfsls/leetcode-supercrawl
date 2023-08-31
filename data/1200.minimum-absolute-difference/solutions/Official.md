## [1200.最小绝对差 中文官方题解](https://leetcode.cn/problems/minimum-absolute-difference/solutions/100000/zui-xiao-jue-dui-chai-by-leetcode-soluti-7g0e)
#### 方法一：排序 + 一次遍历

**思路与算法**

首先我们对数组 $\textit{arr}$ 进行升序排序。这样一来，拥有「最小绝对差」的元素对只能由有序数组中相邻的两个元素构成。

随后我们对数组 $\textit{arr}$ 进行一次遍历。当遍历到 $\textit{arr}[i]$ 和 $\textit{arr}[i+1]$ 时，它们的差为 $\delta = \textit{arr}[i+1] - \textit{arr}[i]$。我们使用一个变量 $\textit{best}$ 存储当前遇到的最小差，以及一个数组 $\textit{ans}$ 存储答案：

- 如果 $\delta < \textit{best}$，那么说明我们遇到了更小的差值，需要更新 $\textit{best}$，同时 $\textit{ans}$ 清空并放入 $\textit{arr}[i]$ 和 $\textit{arr}[i+1]$；

- 如果 $\delta = \textit{best}$，那么我们只需要将 $\textit{arr}[i]$ 和 $\textit{arr}[i+1]$ 放入答案数组即可。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    vector<vector<int>> minimumAbsDifference(vector<int>& arr) {
        int n = arr.size();
        sort(arr.begin(), arr.end());

        int best = INT_MAX;
        vector<vector<int>> ans;
        for (int i = 0; i < n - 1; ++i) {
            if (int delta = arr[i + 1] - arr[i]; delta < best) {
                best = delta;
                ans = {{arr[i], arr[i + 1]}};
            }
            else if (delta == best) {
                ans.emplace_back(initializer_list<int>{arr[i], arr[i + 1]});
            }
        }

        return ans;
    }
};
```

```Java [sol1-Java]
class Solution {
    public List<List<Integer>> minimumAbsDifference(int[] arr) {
        int n = arr.length;
        Arrays.sort(arr);

        int best = Integer.MAX_VALUE;
        List<List<Integer>> ans = new ArrayList<List<Integer>>();
        for (int i = 0; i < n - 1; ++i) {
            int delta = arr[i + 1] - arr[i];
            if (delta < best) {
                best = delta;
                ans.clear();
                List<Integer> pair = new ArrayList<Integer>();
                pair.add(arr[i]);
                pair.add(arr[i + 1]);
                ans.add(pair);
            } else if (delta == best) {
                List<Integer> pair = new ArrayList<Integer>();
                pair.add(arr[i]);
                pair.add(arr[i + 1]);
                ans.add(pair);
            }
        }

        return ans;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public IList<IList<int>> MinimumAbsDifference(int[] arr) {
        int n = arr.Length;
        Array.Sort(arr);

        int best = int.MaxValue;
        IList<IList<int>> ans = new List<IList<int>>();
        for (int i = 0; i < n - 1; ++i) {
            int delta = arr[i + 1] - arr[i];
            if (delta < best) {
                best = delta;
                ans.Clear();
                IList<int> pair = new List<int>();
                pair.Add(arr[i]);
                pair.Add(arr[i + 1]);
                ans.Add(pair);
            } else if (delta == best) {
                IList<int> pair = new List<int>();
                pair.Add(arr[i]);
                pair.Add(arr[i + 1]);
                ans.Add(pair);
            }
        }

        return ans;
    }
}
```

```Python [sol1-Python3]
class Solution:
    def minimumAbsDifference(self, arr: List[int]) -> List[List[int]]:
        n = len(arr)
        arr.sort()

        best, ans = float('inf'), list()
        for i in range(n - 1):
            if (delta := arr[i + 1] - arr[i]) < best:
                best = delta
                ans = [[arr[i], arr[i + 1]]]
            elif delta == best:
                ans.append([arr[i], arr[i + 1]])
        
        return ans
```

```C [sol1-C]
static inline int cmp(const void *pa, const void *pb) {
    return *(int *)pa - *(int *)pb;
}

int** minimumAbsDifference(int* arr, int arrSize, int* returnSize, int** returnColumnSizes){
    qsort(arr, arrSize, sizeof(int), cmp);
    int best = INT_MAX;
    int **ans = (int **)malloc(sizeof(int *) * (arrSize - 1));
    int pos = 0;
    for (int i = 0; i < arrSize - 1; ++i) {
        int delta = arr[i + 1] - arr[i];
        if (delta < best) {
            best = delta;
            for (int j = 0; j < pos; j++) {
                free(ans[j]);
            }
            pos = 0;
            ans[pos] = (int *)malloc(sizeof(int) * 2);
            memcpy(ans[pos], arr + i, sizeof(int) * 2);
            pos++;
        }
        else if (delta == best) {
            ans[pos] = (int *)malloc(sizeof(int) * 2);
            memcpy(ans[pos], arr + i, sizeof(int) * 2);
            pos++;
        }
    }
    *returnSize = pos;
    *returnColumnSizes = (int *)malloc(sizeof(int) * pos);
    for (int i = 0; i < pos; i++) {
        (*returnColumnSizes)[i] = 2;
    }
    return ans;
}
```

```JavaScript [sol1-JavaScript]
var minimumAbsDifference = function(arr) {
    const n = arr.length;
    arr.sort((a, b) => a - b);

    let best = Number.MAX_VALUE;
    let ans = [];
    for (let i = 0; i < n - 1; ++i) {
        let delta = arr[i + 1] - arr[i];
        if (delta < best) {
            best = delta;
            ans = [];
            const pair = [];
            pair.push(arr[i]);
            pair.push(arr[i + 1]);
            ans.push(pair);
        } else if (delta === best) {
            const pair = [];
            pair.push(arr[i]);
            pair.push(arr[i + 1]);
            ans.push(pair);
        }
    }

    return ans;
};
```

```go [sol1-Golang]
func minimumAbsDifference(arr []int) (ans [][]int) {
    sort.Ints(arr)
    for i, best := 0, math.MaxInt32; i < len(arr)-1; i++ {
        if delta := arr[i+1] - arr[i]; delta < best {
            best = delta
            ans = [][]int{{arr[i], arr[i+1]}}
        } else if delta == best {
            ans = append(ans, []int{arr[i], arr[i+1]})
        }
    }
    return
}
```

**复杂度分析**

- 时间复杂度：$O(n \log n)$，其中 $n$ 是数组 $\textit{arr}$ 的长度。排序需要的时间为 $O(n \log n)$，遍历需要的是时间为 $O(n)$，因此总时间复杂度为 $O(n \log n)$。

- 空间复杂度：$O(\log n)$，即为排序需要使用的栈空间。这里不计入返回值需要使用的空间。
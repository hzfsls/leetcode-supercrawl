#### 方法一：一次遍历

我们从数组的位置 $0$ 出发，向右遍历。每次遇到相邻元素之间的差值大于 $1$ 时，我们就找到了一个区间。遍历完数组之后，就能得到一系列的区间的列表。

在遍历过程中，维护下标 $\textit{low}$ 和 $\textit{high}$ 分别记录区间的起点和终点，对于任何区间都有 $\textit{low} \le \textit{high}$。当得到一个区间时，根据 $\textit{low}$ 和 $\textit{high}$ 的值生成区间的字符串表示。

- 当 $\textit{low}<\textit{high}$ 时，区间的字符串表示为 $``\textit{low} \rightarrow \textit{high}"$；

- 当 $\textit{low}=\textit{high}$ 时，区间的字符串表示为 $``\textit{low}"$。

```C++ [sol1-C++]
class Solution {
public:
    vector<string> summaryRanges(vector<int>& nums) {
        vector<string> ret;
        int i = 0;
        int n = nums.size();
        while (i < n) {
            int low = i;
            i++;
            while (i < n && nums[i] == nums[i - 1] + 1) {
                i++;
            }
            int high = i - 1;
            string temp = to_string(nums[low]);
            if (low < high) {
                temp.append("->");
                temp.append(to_string(nums[high]));
            }
            ret.push_back(move(temp));
        }
        return ret;
    }
};
```

```Java [sol1-Java]
class Solution {
    public List<String> summaryRanges(int[] nums) {
        List<String> ret = new ArrayList<String>();
        int i = 0;
        int n = nums.length;
        while (i < n) {
            int low = i;
            i++;
            while (i < n && nums[i] == nums[i - 1] + 1) {
                i++;
            }
            int high = i - 1;
            StringBuffer temp = new StringBuffer(Integer.toString(nums[low]));
            if (low < high) {
                temp.append("->");
                temp.append(Integer.toString(nums[high]));
            }
            ret.add(temp.toString());
        }
        return ret;
    }
}
```

```go [sol1-Golang]
func summaryRanges(nums []int) (ans []string) {
    for i, n := 0, len(nums); i < n; {
        left := i
        for i++; i < n && nums[i-1]+1 == nums[i]; i++ {
        }
        s := strconv.Itoa(nums[left])
        if left < i-1 {
            s += "->" + strconv.Itoa(nums[i-1])
        }
        ans = append(ans, s)
    }
    return
}
```

```C [sol1-C]
char** summaryRanges(int* nums, int numsSize, int* returnSize) {
    char** ret = malloc(sizeof(char*) * numsSize);
    *returnSize = 0;
    int i = 0;
    while (i < numsSize) {
        int low = i;
        i++;
        while (i < numsSize && nums[i] == nums[i - 1] + 1) {
            i++;
        }
        int high = i - 1;
        char* temp = malloc(sizeof(char) * 25);
        sprintf(temp, "%d", nums[low]);
        if (low < high) {
            sprintf(temp + strlen(temp), "->");
            sprintf(temp + strlen(temp), "%d", nums[high]);
        }
        ret[(*returnSize)++] = temp;
    }
    return ret;
}
```

```JavaScript [sol1-JavaScript]
var summaryRanges = function(nums) {
    const ret = [];
    let i = 0;
    const n = nums.length;
    while (i < n) {
        const low = i;
        i++;
        while (i < n && nums[i] === nums[i - 1] + 1) {
            i++;
        }
        const high = i - 1;
        const temp = ['' + nums[low]];
        if (low < high) {
            temp.push('->');
            temp.push('' + nums[high]);
        }
        ret.push(temp.join(''));
    }
    return ret;
};
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 为数组的长度。

- 空间复杂度：$O(1)$。除了用于输出的空间外，额外使用的空间为常数。
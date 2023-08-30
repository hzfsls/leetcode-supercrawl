#### 方法一：排序

题目要求找到每个运动员的相对名次，并同时给前三名标记为 $\texttt{"Gold Medal", "Silver Medal", "Bronze Medal"}$，其余的运动员则标记为其相对名次。
将所有的运动员按照成绩的高低进行排序，然后将按照名次进行标记即可。

**代码**

```Java [sol1-Java]
class Solution {
    public String[] findRelativeRanks(int[] score) {
        int n = score.length;
        String[] desc = {"Gold Medal", "Silver Medal", "Bronze Medal"};
        int[][] arr = new int[n][2];

        for (int i = 0; i < n; ++i) {
            arr[i][0] = score[i];
            arr[i][1] = i;
        }
        Arrays.sort(arr, (a, b) -> b[0] - a[0]);
        String[] ans = new String[n];
        for (int i = 0; i < n; ++i) {
            if (i >= 3) {
                ans[arr[i][1]] = Integer.toString(i + 1);
            } else {
                ans[arr[i][1]] = desc[i];
            }
        }
        return ans;
    }
}
```

```C++ [sol1-C++]
class Solution {
public:
    vector<string> findRelativeRanks(vector<int>& score) {
        int n = score.size();
        string desc[3] = {"Gold Medal", "Silver Medal", "Bronze Medal"};
        vector<pair<int, int>> arr;

        for (int i = 0; i < n; ++i) {
            arr.emplace_back(make_pair(-score[i], i));
        }
        sort(arr.begin(), arr.end());
        vector<string> ans(n);
        for (int i = 0; i < n; ++i) {
            if (i >= 3) {
                ans[arr[i].second] = to_string(i + 1);
            } else {
                ans[arr[i].second] = desc[i];
            }
        }
        return ans;
    }
};
```

```C# [sol1-C#]
public class Solution {
    public string[] FindRelativeRanks(int[] score) {
        int n = score.Length;
        string[] desc = {"Gold Medal", "Silver Medal", "Bronze Medal"};
        int[][] arr = new int[n][];

        for (int i = 0; i < n; ++i) {
            arr[i] = new int[2];
            arr[i][0] = score[i];
            arr[i][1] = i;
        }
        Array.Sort(arr, (a, b) => b[0] - a[0]);
        string[] ans = new string[n];
        for (int i = 0; i < n; ++i) {
            if (i >= 3) {
                ans[arr[i][1]] = (i + 1).ToString();
            } else {
                ans[arr[i][1]] = desc[i];
            }
        }
        return ans;
    }
}
```

```JavaScript [sol1-JavaScript]
var findRelativeRanks = function(score) {
    const n = score.length;
    const desc = ["Gold Medal", "Silver Medal", "Bronze Medal"];
    const arr = new Array(n).fill(0).map(() => new Array(2).fill(0));

    for (let i = 0; i < n; ++i) {
        arr[i][0] = score[i];
        arr[i][1] = i;
    }
    arr.sort((a, b) => b[0] - a[0]);
    const ans = new Array(n).fill(0);
    for (let i = 0; i < n; ++i) {
        if (i >= 3) {
            ans[arr[i][1]] = '' + (i + 1);
        } else {
            ans[arr[i][1]] = desc[i];
        }
    }
    return ans;
};
```

```Python [sol1-Python3]
class Solution:
    desc = ("Gold Medal", "Silver Medal", "Bronze Medal")

    def findRelativeRanks(self, score: List[int]) -> List[str]:
        ans = [""] * len(score)
        arr = sorted(enumerate(score), key=lambda x: -x[1])
        for i, (idx, _) in enumerate(arr):
            ans[idx] = self.desc[i] if i < 3 else str(i + 1)
        return ans
```

```go [sol1-Golang]
var desc = [3]string{"Gold Medal", "Silver Medal", "Bronze Medal"}

func findRelativeRanks(score []int) []string {
    n := len(score)
    type pair struct{ score, idx int }
    arr := make([]pair, n)
    for i, s := range score {
        arr[i] = pair{s, i}
    }
    sort.Slice(arr, func(i, j int) bool { return arr[i].score > arr[j].score })

    ans := make([]string, n)
    for i, p := range arr {
        if i < 3 {
            ans[p.idx] = desc[i]
        } else {
            ans[p.idx] = strconv.Itoa(i + 1)
        }
    }
    return ans
}
```

**复杂度分析**

- 时间复杂度：$O(n \log n)$，其中 $n$ 为数组的长度。我们需要对数组进行一次排序，因此时间复杂度为 $O(n \log n)$。

- 空间复杂度：$O(n)$，其中 $n$ 为数组的长度。
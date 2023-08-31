## [40.组合总和 II 中文官方题解](https://leetcode.cn/problems/combination-sum-ii/solutions/100000/zu-he-zong-he-ii-by-leetcode-solution)

#### 方法一：回溯

**思路与算法**

由于我们需要求出所有和为 $\textit{target}$ 的组合，并且每个数只能使用一次，因此我们可以使用递归 + 回溯的方法来解决这个问题：

- 我们用 $\textit{dfs}(\textit{pos}, \textit{rest})$ 表示递归的函数，其中 $\textit{pos}$ 表示我们当前递归到了数组 $\textit{candidates}$ 中的第 $\textit{pos}$ 个数，而 $\textit{rest}$ 表示我们还需要选择和为 $\textit{rest}$ 的数放入列表作为一个组合；

- 对于当前的第 $\textit{pos}$ 个数，我们有两种方法：选或者不选。如果我们选了这个数，那么我们调用 $\textit{dfs}(\textit{pos} + 1, \textit{rest} - \textit{candidates}[\textit{pos}])$ 进行递归，注意这里必须满足 $\textit{rest} \geq \textit{candidates}[\textit{pos}]$。如果我们不选这个数，那么我们调用 $\textit{dfs}(\textit{pos} + 1, \textit{rest})$ 进行递归；

- 在某次递归开始前，如果 $\textit{rest}$ 的值为 $0$，说明我们找到了一个和为 $\textit{target}$ 的组合，将其放入答案中。每次调用递归函数前，如果我们选了那个数，就需要将其放入列表的末尾，该列表中存储了我们选的所有数。在回溯时，如果我们选了那个数，就要将其从列表的末尾删除。

上述算法就是一个标准的递归 + 回溯算法，但是它并不适用于本题。这是因为题目描述中规定了**解集不能包含重复的组合**，而上述的算法中并没有去除重复的组合。

> 例如当 $\textit{candidates} = [2, 2]$，$\textit{target} = 2$ 时，上述算法会将列表 $[2]$ 放入答案两次。

因此，我们需要改进上述算法，在求出组合的过程中就进行去重的操作。我们可以考虑**将相同的数放在一起进行处理**，也就是说，如果数 $\textit{x}$ 出现了 $y$ 次，那么在递归时一次性地处理它们，即分别调用选择 $0, 1, \cdots, y$ 次 $x$ 的递归函数。这样我们就不会得到重复的组合。具体地：

- 我们使用一个哈希映射（HashMap）统计数组 $\textit{candidates}$ 中每个数出现的次数。在统计完成之后，我们将结果放入一个列表 $\textit{freq}$ 中，方便后续的递归使用。

    - 列表 $\textit{freq}$ 的长度即为数组 $\textit{candidates}$ 中不同数的个数。其中的每一项对应着哈希映射中的一个键值对，即某个数以及它出现的次数。

- 在递归时，对于当前的第 $\textit{pos}$ 个数，它的值为 $\textit{freq}[\textit{pos}][0]$，出现的次数为 $\textit{freq}[\textit{pos}][1]$，那么我们可以调用

    $$
    \textit{dfs}(\textit{pos} + 1, \textit{rest} - i \times \textit{freq}[\textit{pos}][0])
    $$

    即我们选择了这个数 $i$ 次。这里 $i$ 不能大于这个数出现的次数，并且 $i \times \textit{freq}[\textit{pos}][0]$ 也不能大于 $\textit{rest}$。同时，我们需要将 $i$ 个 $\textit{freq}[\textit{pos}][0]$ 放入列表中。

这样一来，我们就可以不重复地枚举所有的组合了。

我们还可以进行什么优化（剪枝）呢？一种比较常用的优化方法是，我们将 $\textit{freq}$ 根据数从小到大排序，这样我们在递归时会先选择小的数，再选择大的数。这样做的好处是，当我们递归到 $\textit{dfs}(\textit{pos}, \textit{rest})$ 时，如果 $\textit{freq}[\textit{pos}][0]$ 已经大于 $\textit{rest}$，那么后面还没有递归到的数也都大于 $\textit{rest}$，这就说明不可能再选择若干个和为 $\textit{rest}$ 的数放入列表了。此时，我们就可以直接回溯。

**代码**

```C++ [sol1-C++]
class Solution {
private:
    vector<pair<int, int>> freq;
    vector<vector<int>> ans;
    vector<int> sequence;

public:
    void dfs(int pos, int rest) {
        if (rest == 0) {
            ans.push_back(sequence);
            return;
        }
        if (pos == freq.size() || rest < freq[pos].first) {
            return;
        }

        dfs(pos + 1, rest);

        int most = min(rest / freq[pos].first, freq[pos].second);
        for (int i = 1; i <= most; ++i) {
            sequence.push_back(freq[pos].first);
            dfs(pos + 1, rest - i * freq[pos].first);
        }
        for (int i = 1; i <= most; ++i) {
            sequence.pop_back();
        }
    }

    vector<vector<int>> combinationSum2(vector<int>& candidates, int target) {
        sort(candidates.begin(), candidates.end());
        for (int num: candidates) {
            if (freq.empty() || num != freq.back().first) {
                freq.emplace_back(num, 1);
            } else {
                ++freq.back().second;
            }
        }
        dfs(0, target);
        return ans;
    }
};
```

```Java [sol1-Java]
class Solution {
    List<int[]> freq = new ArrayList<int[]>();
    List<List<Integer>> ans = new ArrayList<List<Integer>>();
    List<Integer> sequence = new ArrayList<Integer>();

    public List<List<Integer>> combinationSum2(int[] candidates, int target) {
        Arrays.sort(candidates);
        for (int num : candidates) {
            int size = freq.size();
            if (freq.isEmpty() || num != freq.get(size - 1)[0]) {
                freq.add(new int[]{num, 1});
            } else {
                ++freq.get(size - 1)[1];
            }
        }
        dfs(0, target);
        return ans;
    }

    public void dfs(int pos, int rest) {
        if (rest == 0) {
            ans.add(new ArrayList<Integer>(sequence));
            return;
        }
        if (pos == freq.size() || rest < freq.get(pos)[0]) {
            return;
        }

        dfs(pos + 1, rest);

        int most = Math.min(rest / freq.get(pos)[0], freq.get(pos)[1]);
        for (int i = 1; i <= most; ++i) {
            sequence.add(freq.get(pos)[0]);
            dfs(pos + 1, rest - i * freq.get(pos)[0]);
        }
        for (int i = 1; i <= most; ++i) {
            sequence.remove(sequence.size() - 1);
        }
    }
}
```

```Python [sol1-Python3]
class Solution:
    def combinationSum2(self, candidates: List[int], target: int) -> List[List[int]]:
        def dfs(pos: int, rest: int):
            nonlocal sequence
            if rest == 0:
                ans.append(sequence[:])
                return
            if pos == len(freq) or rest < freq[pos][0]:
                return
            
            dfs(pos + 1, rest)

            most = min(rest // freq[pos][0], freq[pos][1])
            for i in range(1, most + 1):
                sequence.append(freq[pos][0])
                dfs(pos + 1, rest - i * freq[pos][0])
            sequence = sequence[:-most]
        
        freq = sorted(collections.Counter(candidates).items())
        ans = list()
        sequence = list()
        dfs(0, target)
        return ans
```

```Golang [sol1-Golang]
func combinationSum2(candidates []int, target int) (ans [][]int) {
    sort.Ints(candidates)
    var freq [][2]int
    for _, num := range candidates {
        if freq == nil || num != freq[len(freq)-1][0] {
            freq = append(freq, [2]int{num, 1})
        } else {
            freq[len(freq)-1][1]++
        }
    }

    var sequence []int
    var dfs func(pos, rest int)
    dfs = func(pos, rest int) {
        if rest == 0 {
            ans = append(ans, append([]int(nil), sequence...))
            return
        }
        if pos == len(freq) || rest < freq[pos][0] {
            return
        }

        dfs(pos+1, rest)

        most := min(rest/freq[pos][0], freq[pos][1])
        for i := 1; i <= most; i++ {
            sequence = append(sequence, freq[pos][0])
            dfs(pos+1, rest-i*freq[pos][0])
        }
        sequence = sequence[:len(sequence)-most]
    }
    dfs(0, target)
    return
}

func min(a, b int) int {
    if a < b {
        return a
    }
    return b
}
```

```C [sol1-C]
int** ans;
int* ansColumnSizes;
int ansSize;

int* sequence;
int sequenceSize;

int** freq;
int freqSize;

void dfs(int pos, int rest) {
    if (rest == 0) {
        int* tmp = malloc(sizeof(int) * sequenceSize);
        memcpy(tmp, sequence, sizeof(int) * sequenceSize);
        ans[ansSize] = tmp;
        ansColumnSizes[ansSize++] = sequenceSize;
        return;
    }
    if (pos == freqSize || rest < freq[pos][0]) {
        return;
    }

    dfs(pos + 1, rest);

    int most = fmin(rest / freq[pos][0], freq[pos][1]);
    for (int i = 1; i <= most; ++i) {
        sequence[sequenceSize++] = freq[pos][0];
        dfs(pos + 1, rest - i * freq[pos][0]);
    }
    sequenceSize -= most;
}

int comp(const void* a, const void* b) {
    return *(int*)a - *(int*)b;
}

int** combinationSum2(int* candidates, int candidatesSize, int target, int* returnSize, int** returnColumnSizes) {
    ans = malloc(sizeof(int*) * 2001);
    ansColumnSizes = malloc(sizeof(int) * 2001);
    sequence = malloc(sizeof(int) * 2001);
    freq = malloc(sizeof(int*) * 2001);
    ansSize = sequenceSize = freqSize = 0;

    qsort(candidates, candidatesSize, sizeof(int), comp);
    for (int i = 0; i < candidatesSize; ++i) {
        if (freqSize == 0 || candidates[i] != freq[freqSize - 1][0]) {
            freq[freqSize] = malloc(sizeof(int) * 2);
            freq[freqSize][0] = candidates[i];
            freq[freqSize++][1] = 1;
        } else {
            ++freq[freqSize - 1][1];
        }
    }
    dfs(0, target);
    *returnSize = ansSize;
    *returnColumnSizes = ansColumnSizes;
    return ans;
}
```

**复杂度分析**

- 时间复杂度：$O(2^n \times n)$，其中 $n$ 是数组 $\textit{candidates}$ 的长度。在大部分递归 + 回溯的题目中，我们无法给出一个严格的渐进紧界，故这里只分析一个较为宽松的渐进上界。在最坏的情况下，数组中的每个数都不相同，那么列表 $\textit{freq}$ 的长度同样为 $n$。在递归时，每个位置可以选或不选，如果数组中所有数的和不超过 $\textit{target}$，那么 $2^n$ 种组合都会被枚举到；在 $\textit{target}$ 小于数组中所有数的和时，我们并不能解析地算出满足题目要求的组合的数量，但我们知道每得到一个满足要求的组合，需要 $O(n)$ 的时间将其放入答案中，因此我们将 $O(2^n)$ 与 $O(n)$ 相乘，即可估算出一个宽松的时间复杂度上界。

    - 由于 $O(2^n \times n)$ 在渐进意义下大于排序的时间复杂度 $O(n \log n)$，因此后者可以忽略不计。

- 空间复杂度：$O(n)$。除了存储答案的数组外，我们需要 $O(n)$ 的空间存储列表 $\textit{freq}$、递归中存储当前选择的数的列表、以及递归需要的栈。
#### 方法一：排序

设参与排名的人数为 $n$（即数组 $\textit{votes}$ 中任一字符串的长度），我们可以用一个哈希映射（HashMap）存储每一个人的排名情况。对于哈希映射中的每个键值对，键为一个在数组 $\textit{votes}$ 中出现的大写英文字母，表示一个参与排名的人；值为一个长度为 $n$ 的数组 $\textit{rank}$，表示这个人的排名情况，其中 $\textit{rank}[i]$ 表示这个人排名为 $i$ 的次数。

我们遍历数组 $\textit{votes}$ 中的每一个字符串并进行统计，就可以得到上述存储了每一个人排名情况的哈希映射。随后我们将这些键值对取出，并放入数组中进行排序。记每一个键值对为 $(\textit{vid}, \textit{rank})$，根据题目要求，我们需要以 $\textit{rank}$ 为第一关键字进行降序排序。在大部分语言中，我们是可以对变长的数组（例如 `C++` 中的 `vector`，`Python` 中的 `list`）直接进行比较排序的，比较的方式是从首部的元素开始，依次比较两个数组同一位置的元素的大小，若相等则继续比较下一位置，直至数组的尾部（此时长度较长的数组较大，若长度相同，则这两个数组同样大）。因此第一关键字可以直接进行比较。在 $\textit{rank}$ 相等的情况下，我们需要以 $\textit{vid}$ 为第二关键字进行升序排序。在 `C++` 中，我们可以自定义比较函数，完成多关键字的排序，而在 `Python` 中进行多关键字排序时，不同关键字的排序方式必须保持一致。我们可以将 $\textit{vid}$ 从字符转换为对应的 `ASCII` 码，并用其相反数作为第二关键字，这样就与第一关键字保持一致，即都进行降序排序。

在排序完成后，我们将每一个键值对中的键 $\textit{vid}$ 依次加入到答案字符串 $\textit{ans}$ 中，即可得到最终的答案。

```C++ [sol1-C++]
class Solution {
public:
    string rankTeams(vector<string>& votes) {
        int n = votes.size();
        // 初始化哈希映射
        unordered_map<char, vector<int>> ranking;
        for (char vid: votes[0]) {
            ranking[vid].resize(votes[0].size());
        }
        // 遍历统计
        for (const string& vote: votes) {
            for (int i = 0; i < vote.size(); ++i) {
                ++ranking[vote[i]][i];
            }
        }
        
        // 取出所有的键值对
        using PCV = pair<char, vector<int>>;
        vector<PCV> result(ranking.begin(), ranking.end());
        // 排序
        sort(result.begin(), result.end(), [](const PCV& l, const PCV& r) {
            return l.second > r.second || (l.second == r.second && l.first < r.first);
        });
        string ans;
        for (auto& [vid, rank]: result) {
            ans += vid;
        }
        return ans;
    }
};
```

```Python [sol1-Python3]
class Solution:
    def rankTeams(self, votes: List[str]) -> str:
        n = len(votes[0])
        # 初始化哈希映射
        ranking = collections.defaultdict(lambda: [0] * n)
        # 遍历统计
        for vote in votes:
            for i, vid in enumerate(vote):
                ranking[vid][i] += 1
        
        # 取出所有的键值对
        result = list(ranking.items())
        # 排序
        result.sort(key=lambda x: (x[1], -ord(x[0])), reverse=True)
        return "".join([vid for vid, rank in result])
```

**复杂度分析**

- 时间复杂度：$O(NK + N^2\log N)$，其中 $N$ 是数组 $\textit{votes}$ 中每一个字符串的长度（参与排名的人数），$K$ 是数组 $\textit{votes}$ 的长度（参与投票的人数）。「遍历统计」的时间复杂度为 $O(NK)$，「排序」的时间复杂度为 $O(N^2\log N)$（其中 $O(N\log N)$ 为排序本身的时间，还需要额外的比较两个键值对大小的 $O(N)$ 时间），建立最终答案字符串的时间复杂度为 $O(N)$，因此总时间复杂度为 $O(NK + N^2\log N)$。

- 空间复杂度：$O(N^2)$。哈希映射中键值对的数量为 $N$，每个键使用 $O(1)$ 的空间，每个值使用 $O(N)$ 的空间，空间复杂度为 $O(N^2)$。存储排序的结果同样需要使用 $O(N^2)$ 的空间，因此总空间复杂度为 $O(N^2)$。
#### 方法一：使用哈希表存储挖掘的位置

**思路与算法**

我们首先遍历数组 $\textit{digs}$，并使用哈希集合存储其中的每一个位置。

随后我们遍历数组 $\textit{artifacts}$ 中的每一个工件，由于「每个工件最多只覆盖 $4$ 个单元格」，我们可以直接遍历每一个工件的每一个单元格，如果该工件的所有单元格都在哈希集合中，我们就可以提取该工件。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    int digArtifacts(int n, vector<vector<int>>& artifacts, vector<vector<int>>& dig) {
        auto pair_hash = [&n, fn = hash<int>()](const pair<int, int>& o) -> size_t {
            return fn(o.first * n + o.second);
        };

        unordered_set<pair<int, int>, decltype(pair_hash)> valid(0, pair_hash);
        for (const auto& pos: dig) {
            int r = pos[0], c = pos[1];
            valid.emplace(r, c);
        }

        int ans = 0;
        for (const auto& artifact: artifacts) {
            int r1 = artifact[0], c1 = artifact[1], r2 = artifact[2], c2 = artifact[3];
            bool check = true;
            for (int r = r1; r <= r2; ++r) {
                for (int c = c1; c <= c2; ++c) {
                    if (!valid.count({r, c})) {
                        check = false;
                        break;
                    }
                }
                if (!check) {
                    break;
                }
            }
            if (check) {
                ++ans;
            }
        }

        return ans;
    }
};
```

```Python [sol1-Python3]
class Solution:
    def digArtifacts(self, n: int, artifacts: List[List[int]], dig: List[List[int]]) -> int:
        valid = {tuple(pos) for pos in dig}
        
        ans = 0
        for (r1, c1, r2, c2) in artifacts:
            check = True
            for r in range(r1, r2 + 1):
                for c in range(c1, c2 + 1):
                    if (r, c) not in valid:
                        check = False
                        break
                if not check:
                    break
            
            if check:
                ans += 1

        return ans
```

**复杂度分析**

- 时间复杂度：$O(C \cdot a + d)$，其中 $a$ 和 $d$ 分别是数组 $\textit{artifacts}$ 和 $\textit{dig}$ 的长度，$C$ 是每个工件最多覆盖的单元格数，在本题中 $C=4$。

- 空间复杂度：$O(d)$，即为哈希表需要使用的空间。
### 📺 视频题解  
![72. 编辑距离.mp4](6b7a342c-64a1-4591-aa34-e36a752ed178)

### 📖 文字题解

#### 想法

编辑距离算法被数据科学家广泛应用，是用作机器翻译和语音识别评价标准的基本算法。

最直观的方法是暴力检查所有可能的编辑方法，取最短的一个。所有可能的编辑方法达到指数级，但我们不需要进行这么多计算，因为我们只需要找到距离最短的序列而不是所有可能的序列。

#### 方法一：动态规划

**思路和算法**

我们可以对任意一个单词进行三种操作：

- 插入一个字符；

- 删除一个字符；

- 替换一个字符。

题目给定了两个单词，设为 `A` 和 `B`，这样我们就能够六种操作方法。

但我们可以发现，如果我们有单词 `A` 和单词 `B`：

- 对单词 `A` 删除一个字符和对单词 `B` 插入一个字符是等价的。例如当单词 `A` 为 `doge`，单词 `B` 为 `dog` 时，我们既可以删除单词 `A` 的最后一个字符 `e`，得到相同的 `dog`，也可以在单词 `B` 末尾添加一个字符 `e`，得到相同的 `doge`；

- 同理，对单词 `B` 删除一个字符和对单词 `A` 插入一个字符也是等价的；

- 对单词 `A` 替换一个字符和对单词 `B` 替换一个字符是等价的。例如当单词 `A` 为 `bat`，单词 `B` 为 `cat` 时，我们修改单词 `A` 的第一个字母 `b -> c`，和修改单词 `B` 的第一个字母 `c -> b` 是等价的。

这样以来，本质不同的操作实际上只有三种：

- 在单词 `A` 中插入一个字符；

- 在单词 `B` 中插入一个字符；

- 修改单词 `A` 的一个字符。

这样以来，我们就可以把原问题转化为规模较小的子问题。我们用 `A = horse`，`B = ros` 作为例子，来看一看是如何把这个问题转化为规模较小的若干子问题的。

- **在单词 `A` 中插入一个字符**：如果我们知道 `horse` 到 `ro` 的编辑距离为 `a`，那么显然 `horse` 到 `ros` 的编辑距离不会超过 `a + 1`。这是因为我们可以在 `a` 次操作后将 `horse` 和 `ro` 变为相同的字符串，只需要额外的 `1` 次操作，在单词 `A` 的末尾添加字符 `s`，就能在 `a + 1` 次操作后将 `horse` 和 `ro` 变为相同的字符串；

- **在单词 `B` 中插入一个字符**：如果我们知道 `hors` 到 `ros` 的编辑距离为 `b`，那么显然 `horse` 到 `ros` 的编辑距离不会超过 `b + 1`，原因同上；

- **修改单词 `A` 的一个字符**：如果我们知道 `hors` 到 `ro` 的编辑距离为 `c`，那么显然 `horse` 到 `ros` 的编辑距离不会超过 `c + 1`，原因同上。

那么从 `horse` 变成 `ros` 的编辑距离应该为 `min(a + 1, b + 1, c + 1)`。

**注意**：为什么我们总是在单词 `A` 和 `B` 的末尾插入或者修改字符，能不能在其它的地方进行操作呢？答案是可以的，但是我们知道，操作的顺序是不影响最终的结果的。例如对于单词 `cat`，我们希望在 `c` 和 `a` 之间添加字符 `d` 并且将字符 `t` 修改为字符 `b`，那么这两个操作无论为什么顺序，都会得到最终的结果 `cdab`。

你可能觉得 `horse` 到 `ro` 这个问题也很难解决。但是没关系，我们可以继续用上面的方法拆分这个问题，对于这个问题拆分出来的所有子问题，我们也可以继续拆分，直到：

- 字符串 `A` 为空，如从 ` ` 转换到 `ro`，显然编辑距离为字符串 `B` 的长度，这里是 `2`；

- 字符串 `B` 为空，如从 `horse` 转换到 ` `，显然编辑距离为字符串 `A` 的长度，这里是 `5`。

因此，我们就可以使用动态规划来解决这个问题了。我们用 `D[i][j]` 表示 `A` 的前 `i` 个字母和 `B` 的前 `j` 个字母之间的编辑距离。

![72_fig1.PNG](https://pic.leetcode-cn.com/426564dbe63a8cdec3de2ebe83ea2a2640bbff41d18c1bac739c9ae4542854af-72_fig1.PNG)

如上所述，当我们获得 `D[i][j-1]`，`D[i-1][j]` 和 `D[i-1][j-1]` 的值之后就可以计算出 `D[i][j]`。

- `D[i][j-1]` 为 `A` 的前 `i` 个字符和 `B` 的前 `j - 1` 个字符编辑距离的子问题。即对于 `B` 的第 `j` 个字符，我们在 `A` 的末尾添加了一个相同的字符，那么 `D[i][j]` 最小可以为 `D[i][j-1] + 1`；

- `D[i-1][j]` 为 `A` 的前 `i - 1` 个字符和 `B` 的前 `j` 个字符编辑距离的子问题。即对于 `A` 的第 `i` 个字符，我们在 `B` 的末尾添加了一个相同的字符，那么 `D[i][j]` 最小可以为 `D[i-1][j] + 1`；

- `D[i-1][j-1]` 为 `A` 前 `i - 1` 个字符和 `B` 的前 `j - 1` 个字符编辑距离的子问题。即对于 `B` 的第 `j` 个字符，我们修改 `A` 的第 `i` 个字符使它们相同，那么 `D[i][j]` 最小可以为 `D[i-1][j-1] + 1`。特别地，如果 `A` 的第 `i` 个字符和 `B` 的第 `j` 个字符原本就相同，那么我们实际上不需要进行修改操作。在这种情况下，`D[i][j]` 最小可以为 `D[i-1][j-1]`。

那么我们可以写出如下的状态转移方程：

- 若 `A` 和 `B` 的最后一个字母相同：

  $$
  \begin{aligned}
  D[i][j] &= \min(D[i][j - 1] + 1, D[i - 1][j]+1, D[i - 1][j - 1])\\
  &= 1 +  \min(D[i][j - 1], D[i - 1][j], D[i - 1][j - 1] - 1)
  \end{aligned}
  $$

- 若 `A` 和 `B` 的最后一个字母不同：

  $$
  D[i][j] = 1 + \min(D[i][j - 1], D[i - 1][j], D[i - 1][j - 1])
  $$

所以每一步结果都将基于上一步的计算结果，示意如下：

![72_fig2.PNG](https://pic.leetcode-cn.com/3241789f2634b72b917d769a92d4f6e38c341833247391fb1b45eb0441fe5cd2-72_fig2.PNG)

对于边界情况，一个空串和一个非空串的编辑距离为 `D[i][0] = i` 和 `D[0][j] = j`，`D[i][0]` 相当于对 `word1` 执行 `i` 次删除操作，`D[0][j]` 相当于对 `word1`执行 `j` 次插入操作。

综上我们得到了算法的全部流程。

<![1.PNG](https://pic.leetcode-cn.com/789c8780345198976ed5d00dc9ae6dc4d7081825d596c14a720b3e0d875a95cd-%E5%B9%BB%E7%81%AF%E7%89%871.PNG),![2.PNG](https://pic.leetcode-cn.com/8704230781a0bc6f11ff317757c73505e8c4cb2c1ca1dcdfb9b0c84eb08d901f-%E5%B9%BB%E7%81%AF%E7%89%872.PNG),![3.PNG](https://pic.leetcode-cn.com/bfc8d2232a17c8999b7d700806bf0048ad4727b567ee756e01fa16750e9e0d07-%E5%B9%BB%E7%81%AF%E7%89%873.PNG),![4.PNG](https://pic.leetcode-cn.com/0e81d8994ffa586183a32f545c259f81d7b33baa753275a4ffb9587c65a55c15-%E5%B9%BB%E7%81%AF%E7%89%874.PNG),![5.PNG](https://pic.leetcode-cn.com/860fb6ce901f4de52b8bac17131d74bab4cb2b8d633e288ddb36bab1bc20249c-%E5%B9%BB%E7%81%AF%E7%89%875.PNG),![6.PNG](https://pic.leetcode-cn.com/f254a89172c460d91c1b454142c599f2389049bf21a7060f50f0d0aabfe09b5e-%E5%B9%BB%E7%81%AF%E7%89%876.PNG),![7.PNG](https://pic.leetcode-cn.com/c49fad2770eba17d15a5257aba379b675db8e8152da1883673c71822c68c9ba4-%E5%B9%BB%E7%81%AF%E7%89%877.PNG),![8.PNG](https://pic.leetcode-cn.com/77fa15a23a169df7f33ccd0b5445ceb0ab22ad4f77c70064944cac55affb2c49-%E5%B9%BB%E7%81%AF%E7%89%878.PNG),![9.PNG](https://pic.leetcode-cn.com/6f9b5036460105d06b7c98c7c2dd72389d0379e73f6621079c1db00b643c17a0-%E5%B9%BB%E7%81%AF%E7%89%879.PNG),![10.PNG](https://pic.leetcode-cn.com/dfa6b2c2c466502a383d60e5eadd557687e64b11f4ab3789a4d75d0bbf69d720-%E5%B9%BB%E7%81%AF%E7%89%8710.PNG),![11.PNG](https://pic.leetcode-cn.com/78d17699e393ec5417b5da2be35d995da9bea7e802b25d16ef6bf56b82cb3277-%E5%B9%BB%E7%81%AF%E7%89%8711.PNG),![12.PNG](https://pic.leetcode-cn.com/4dfdfe1748e5081aa36ccab5ec6e2737a2d38419e8cd51b2fed4611917836562-%E5%B9%BB%E7%81%AF%E7%89%8712.PNG),![13.PNG](https://pic.leetcode-cn.com/47d2a9d6226203e41733c89a1b72fe4c1aaa51ef09d4c20734c3e92c7a977228-%E5%B9%BB%E7%81%AF%E7%89%8713.PNG),![14.PNG](https://pic.leetcode-cn.com/1e3391bc602c292daa057bfa281af9f5ba53d675fe8aa08da64196518fb30ea9-%E5%B9%BB%E7%81%AF%E7%89%8714.PNG),![15.PNG](https://pic.leetcode-cn.com/bed40ddda779d9e7224097b4ee684f5d48707fd334310d96ecff83d78297f6d5-%E5%B9%BB%E7%81%AF%E7%89%8715.PNG),![16.PNG](https://pic.leetcode-cn.com/9c02287ab77434d502a57310383507623ad5adcf12c5295ed29418fe8a2c8beb-%E5%B9%BB%E7%81%AF%E7%89%8716.PNG),![17.PNG](https://pic.leetcode-cn.com/8c08e736fecc8c4d8b28b95b48d77609d957c7a42ef558901112f81eec6223b6-%E5%B9%BB%E7%81%AF%E7%89%8717.PNG),![18.PNG](https://pic.leetcode-cn.com/03ed835002669d8b1128cd5d57cd908f17cfbf8891d5f979985a6e3a07bb5a7d-%E5%B9%BB%E7%81%AF%E7%89%8718.PNG),![19.PNG](https://pic.leetcode-cn.com/d80ab86b923d5d0bb9ccc13c060b374c30fe714aef10ebe34ba00d8c2c427733-%E5%B9%BB%E7%81%AF%E7%89%8719.PNG)>


```Java [sol1-Java]
class Solution {
    public int minDistance(String word1, String word2) {
        int n = word1.length();
        int m = word2.length();

        // 有一个字符串为空串
        if (n * m == 0) {
            return n + m;
        }

        // DP 数组
        int[][] D = new int[n + 1][m + 1];

        // 边界状态初始化
        for (int i = 0; i < n + 1; i++) {
            D[i][0] = i;
        }
        for (int j = 0; j < m + 1; j++) {
            D[0][j] = j;
        }

        // 计算所有 DP 值
        for (int i = 1; i < n + 1; i++) {
            for (int j = 1; j < m + 1; j++) {
                int left = D[i - 1][j] + 1;
                int down = D[i][j - 1] + 1;
                int left_down = D[i - 1][j - 1];
                if (word1.charAt(i - 1) != word2.charAt(j - 1)) {
                    left_down += 1;
                }
                D[i][j] = Math.min(left, Math.min(down, left_down));
            }
        }
        return D[n][m];
    }
}
```

```Python [sol1-Python3]
class Solution:
    def minDistance(self, word1: str, word2: str) -> int:
        n = len(word1)
        m = len(word2)
        
        # 有一个字符串为空串
        if n * m == 0:
            return n + m
        
        # DP 数组
        D = [ [0] * (m + 1) for _ in range(n + 1)]
        
        # 边界状态初始化
        for i in range(n + 1):
            D[i][0] = i
        for j in range(m + 1):
            D[0][j] = j
        
        # 计算所有 DP 值
        for i in range(1, n + 1):
            for j in range(1, m + 1):
                left = D[i - 1][j] + 1
                down = D[i][j - 1] + 1
                left_down = D[i - 1][j - 1] 
                if word1[i - 1] != word2[j - 1]:
                    left_down += 1
                D[i][j] = min(left, down, left_down)
        
        return D[n][m]
```

```C++ [sol1-C++]
class Solution {
public:
    int minDistance(string word1, string word2) {
        int n = word1.length();
        int m = word2.length();

        // 有一个字符串为空串
        if (n * m == 0) return n + m;

        // DP 数组
        vector<vector<int>> D(n + 1, vector<int>(m + 1));

        // 边界状态初始化
        for (int i = 0; i < n + 1; i++) {
            D[i][0] = i;
        }
        for (int j = 0; j < m + 1; j++) {
            D[0][j] = j;
        }

        // 计算所有 DP 值
        for (int i = 1; i < n + 1; i++) {
            for (int j = 1; j < m + 1; j++) {
                int left = D[i - 1][j] + 1;
                int down = D[i][j - 1] + 1;
                int left_down = D[i - 1][j - 1];
                if (word1[i - 1] != word2[j - 1]) left_down += 1;
                D[i][j] = min(left, min(down, left_down));

            }
        }
        return D[n][m];
    }
};
```

**复杂度分析**

* 时间复杂度 ：$O(mn)$，其中 $m$ 为 `word1` 的长度，$n$ 为 `word2` 的长度。

* 空间复杂度 ：$O(mn)$，我们需要大小为 $O(mn)$ 的 $D$ 数组来记录状态值。
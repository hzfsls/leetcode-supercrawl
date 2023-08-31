## [1178.猜字谜 中文官方题解](https://leetcode.cn/problems/number-of-valid-words-for-each-puzzle/solutions/100000/cai-zi-mi-by-leetcode-solution-345u)

#### 前言

我们首先需要理解清楚题目中的字谜规则：

> 对于单词 $\textit{word}$ 以及谜面 $\textit{puzzle}$，设 $S_w$ 表示 $\textit{word}$ 中出现的字母组成的「不重复」集合，$S_p$ 表示 $\textit{puzzle}$ 中出现的字母组成的集合（由于题目中规定了 $\textit{puzzle}$ 中出现的字母是不重复的，因此这个集合本身也是「不重复」的）。
>
> 如果存在 $S_p$ 的一个子集 $S'_p$，并且 $S'_p$ 包含 $\textit{puzzle}$ 中的首字母，使得 $S_w = S'_p$，那么 $\textit{word}$ 就是 $\textit{puzzle}$ 的谜底。

因此，我们可以设计出解决该字谜问题的一个算法流程：

- 首先我们计算出每一个 $\textit{word}$ 对应的集合 $S_w$，存放在某一「数据结构」中，便于后续操作中的快速查找；

- 随后我们依次枚举每一个 $\textit{puzzle}$，计算出其对应的集合 $S_p$，并枚举满足要求的子集 $S'_p$。对于每一个 $S'_p$，我们在「数据结构」中查找其出现的次数，那么所有的 $S'_p$ 出现次数之和就是 $\textit{puzzle}$ 对应的谜底个数。

存放 $S_w$ 对应的「数据结构」可以有多种选择，本篇题解中会介绍较为常用的两种。

#### 方法一：二进制状态压缩

**思路与算法**

由于题目中规定 $\textit{word}$ 和 $\textit{puzzle}$ 均只包含小写字母，因此 $S_w$ 和 $S_p$ 的大小最多为 $26$，我们可以考虑使用一个长度为 $26$ 的二进制数 $b_w$ 或 $b_p$ 来表示这一集合。

> 对于 $b_w$ 从低到高的第 $i$ 个二进制位（$i$ 从 $0$ 开始编号），如果 $S_w$ 中包含第 $i$ 个小写字母，那么对应的二进制位为 $1$，否则为 $0$。 

因此我们可以使用一个哈希映射来表示需要的「数据结构」：对于哈希映射中的每一个键值对，其中的键表示一个长度为 $26$ 的二进制数，值表示其出现的次数，即数组 $\textit{words}$ 中多少个 $\textit{word}$ 压缩成的二进制数等于键。构造哈希映射的过程也很简单：我们只需要遍历每一个 $\textit{word}$，并遍历 $\textit{word}$ 中的每一个字母，将对应位置的二进制位标记为 $1$，这样就计算出了 $\textit{word}$ 对应的二进制表示，将其在哈希映射中作为键对应的值增加 $1$ 即可。

对于 $\textit{puzzle}$ 对应的 $b_p$，我们可以通过相同的方法求出，那么接下来就需要枚举 $b_p$ 的子集 $b'_p$ 了。枚举一个二进制数的子集也有多种方法，这里介绍常用的两种：

- 第一种：由于题目中规定 $\textit{puzzle}$ 的长度恰好为 $7$，因此我们可以枚举所有 $6$ 位的二进制数（因为 $\textit{puzzle}$ 中的首字母必须要出现，因此最高位必须是 $1$，我们只需要枚举剩余的 $6$ 位就行了）。对于每个枚举出的 $6$ 位二进制数，我们遍历 $\textit{puzzle}$ 中除了首字母以外的其余 $6$ 个字母，只有当二进制位为 $1$ 时，我们才将 $\textit{puzzle}$ 中的字母在二进制表示中的二进制位标记位 $1$。这样我们就得到了每一个 $b'_p$ 对应的二进制表示。

- 第二种：我们也可以使用通用的「枚举二进制子集」的方法，下面给出伪代码：

    ```
    function get_subset(bitmask)
        subset = bitmask
        answer = [bitmask]
        while subset != 0
            subset = (subset - 1) & bitmask
            put subset into the answer list
        end while
        return answer
    end function
    ```

    其中 $\texttt{bitmask}$ 表示一个二进制数，$\texttt{subset}$ 会遍历所有 $\texttt{bitmask}$ 的子集，并将所有的子集放入 $\texttt{answer}$ 中。需要注意的是，$\texttt{bitmask}$ 本身也是 $\texttt{bitmask}$ 的一个子集，因此 $\texttt{answer}$ 在初始时就包含 $\texttt{bitmask}$ 本身。

    与第一种方法类似，我们需要保证 $\textit{puzzle}$ 中的首字母必须要出现，因此在使用第二种方法枚举子集时，我们先将首字母对应的二进制位标记为 $0$，每枚举到一个子集，就将首字母对应的二进制位标记为 $1$，这样得到的子集都是满足要求的。

在得到了 $b_p$ 的子集 $b'_p$ 后，我们将 $b'_p$ 在哈希映射中对应的值累计入答案，这样 $b_p$ 的所有子集的累加和就是其作为谜面的谜底数量。

**细节**

在遍历 $\textit{word}$ 时，如果 $b_w$ 中包含的 $1$ 的数量大于 $7$，那么它一定无法作为谜底，因此我们无需将其加入哈希映射中。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    vector<int> findNumOfValidWords(vector<string>& words, vector<string>& puzzles) {
        unordered_map<int, int> frequency;

        for (const string& word: words) {
            int mask = 0;
            for (char ch: word) {
                mask |= (1 << (ch - 'a'));
            }
            if (__builtin_popcount(mask) <= 7) {
                ++frequency[mask];
            }
        }

        vector<int> ans;
        for (const string& puzzle: puzzles) {
            int total = 0;

            // 枚举子集方法一
            // for (int choose = 0; choose < (1 << 6); ++choose) {
            //     int mask = 0;
            //     for (int i = 0; i < 6; ++i) {
            //         if (choose & (1 << i)) {
            //             mask |= (1 << (puzzle[i + 1] - 'a'));
            //         }
            //     }
            //     mask |= (1 << (puzzle[0] - 'a'));
            //     if (frequency.count(mask)) {
            //         total += frequency[mask];
            //     }
            // }

            // 枚举子集方法二
            int mask = 0;
            for (int i = 1; i < 7; ++i) {
                mask |= (1 << (puzzle[i] - 'a'));
            }
            int subset = mask;
            do {
                int s = subset | (1 << (puzzle[0] - 'a'));
                if (frequency.count(s)) {
                    total += frequency[s];
                }
                subset = (subset - 1) & mask;
            } while (subset != mask);
            
            ans.push_back(total);
        }
        return ans;
    }
};
```

```Java [sol1-Java]
class Solution {
    public List<Integer> findNumOfValidWords(String[] words, String[] puzzles) {
        Map<Integer, Integer> frequency = new HashMap<Integer, Integer>();

        for (String word : words) {
            int mask = 0;
            for (int i = 0; i < word.length(); ++i) {
                char ch = word.charAt(i);
                mask |= (1 << (ch - 'a'));
            }
            if (Integer.bitCount(mask) <= 7) {
                frequency.put(mask, frequency.getOrDefault(mask, 0) + 1);
            }
        }

        List<Integer> ans = new ArrayList<Integer>();
        for (String puzzle : puzzles) {
            int total = 0;

            // 枚举子集方法一
            // for (int choose = 0; choose < (1 << 6); ++choose) {
            //     int mask = 0;
            //     for (int i = 0; i < 6; ++i) {
            //         if ((choose & (1 << i)) != 0) {
            //             mask |= (1 << (puzzle.charAt(i + 1) - 'a'));
            //         }
            //     }
            //     mask |= (1 << (puzzle.charAt(0) - 'a'));
            //     if (frequency.containsKey(mask)) {
            //         total += frequency.get(mask);
            //     }
            // }

            // 枚举子集方法二
            int mask = 0;
            for (int i = 1; i < 7; ++i) {
                mask |= (1 << (puzzle.charAt(i) - 'a'));
            }
            int subset = mask;
            do {
                int s = subset | (1 << (puzzle.charAt(0) - 'a'));
                if (frequency.containsKey(s)) {
                    total += frequency.get(s);
                }
                subset = (subset - 1) & mask;
            } while (subset != mask);
            
            ans.add(total);
        }
        return ans;
    }
}
```

```Python [sol1-Python3]
class Solution:
    def findNumOfValidWords(self, words: List[str], puzzles: List[str]) -> List[int]:
        frequency = collections.Counter()

        for word in words:
            mask = 0
            for ch in word:
                mask |= (1 << (ord(ch) - ord("a")))
            if str(bin(mask)).count("1") <= 7:
                frequency[mask] += 1
        
        ans = list()
        for puzzle in puzzles:
            total = 0

            # 枚举子集方法一
            # for choose in range(1 << 6):
            #     mask = 0
            #     for i in range(6):
            #         if choose & (1 << i):
            #             mask |= (1 << (ord(puzzle[i + 1]) - ord("a")))
            #     mask |= (1 << (ord(puzzle[0]) - ord("a")))
            #     if mask in frequency:
            #         total += frequency[mask]

            # 枚举子集方法二
            mask = 0
            for i in range(1, 7):
                mask |= (1 << (ord(puzzle[i]) - ord("a")))
            
            subset = mask
            while subset:
                s = subset | (1 << (ord(puzzle[0]) - ord("a")))
                if s in frequency:
                    total += frequency[s]
                subset = (subset - 1) & mask
            
            # 在枚举子集的过程中，要么会漏掉全集 mask，要么会漏掉空集
            # 这里会漏掉空集，因此需要额外判断空集
            if (1 << (ord(puzzle[0]) - ord("a"))) in frequency:
                total += frequency[1 << (ord(puzzle[0]) - ord("a"))]

            ans.append(total)
        
        return ans
```

```JavaScript [sol1-JavaScript]
var findNumOfValidWords = function(words, puzzles) {
    const frequency = new Map();

    for (const word of words) {
        let mask = 0;
        for (const ch of word) {
            mask |= (1 << (ch.charCodeAt() - 'a'.charCodeAt()));
        }
        if (CountOne(mask) <= 7) {
            frequency.set(mask, (frequency.get(mask) || 0) + 1);
        }
    }

    const ans = [];
    for (const puzzle of puzzles) {
        let total = 0;

        // 枚举子集方法一
        // for (let choose = 0; choose < (1 << 6); ++choose) {
        //     let mask = 0;
        //     for (let i = 0; i < 6; ++i) {
        //         if (choose & (1 << i)) {
        //             mask |= (1 << (puzzle[i + 1].charCodeAt() - 'a'.charCodeAt()));
        //         }
        //     }
        //     mask |= (1 << (puzzle[0].charCodeAt() - 'a'.charCodeAt()));
        //     if (frequency.has(mask)) {
        //         total += frequency.get(mask);
        //     }
        // }
        // 枚举子集方法二
        let mask = 0;
        for (let i = 1; i < 7; ++i) {
            mask |= (1 << (puzzle[i].charCodeAt() - 'a'.charCodeAt()));
        }
        let subset = mask;
        while (subset) {
            let s = subset | (1 << (puzzle[0].charCodeAt() - 'a'.charCodeAt()));
            if (frequency.has(s)) {
                total += frequency.get(s);
            }
            subset = (subset - 1) & mask;
        }
        // 在枚举子集的过程中，要么会漏掉全集 mask，要么会漏掉空集
        // 这里会漏掉空集，因此需要额外判断空集
        if (frequency.has(1 << (puzzle[0].charCodeAt() - 'a'.charCodeAt()))) {
            total += frequency.get(1 << (puzzle[0].charCodeAt() - 'a'.charCodeAt()));
        }
        ans.push(total);
    }
    return ans;
};

function CountOne(n) {
    const str = n.toString(2);
    let count = 0;
    for (const ch of str) {
        if (parseInt(ch) === 1) {
            count++;
        }
    }
    return count;
}
```

```go [sol1-Golang]
func findNumOfValidWords(words []string, puzzles []string) []int {
    const puzzleLength = 7
    cnt := map[int]int{}
    for _, s := range words {
        mask := 0
        for _, ch := range s {
            mask |= 1 << (ch - 'a')
        }
        if bits.OnesCount(uint(mask)) <= puzzleLength {
            cnt[mask]++
        }
    }

    ans := make([]int, len(puzzles))
    for i, s := range puzzles {
        first := 1 << (s[0] - 'a')

        // 枚举子集方法一
        //for choose := 0; choose < 1<<(puzzleLength-1); choose++ {
        //    mask := 0
        //    for j := 0; j < puzzleLength-1; j++ {
        //        if choose>>j&1 == 1 {
        //            mask |= 1 << (s[j+1] - 'a')
        //        }
        //    }
        //    ans[i] += cnt[mask|first]
        //}

        // 枚举子集方法二
        mask := 0
        for _, ch := range s[1:] {
            mask |= 1 << (ch - 'a')
        }
        subset := mask
        for {
            ans[i] += cnt[subset|first]
            subset = (subset - 1) & mask
            if subset == mask {
                break
            }
        }
    }
    return ans
}
```

```C [sol1-C]
struct unordered_map {
    int key, val;
    UT_hash_handle hh;
};

int* findNumOfValidWords(char** words, int wordsSize, char** puzzles, int puzzlesSize, int* returnSize) {
    struct unordered_map* frequency = NULL;

    for (int i = 0; i < wordsSize; i++) {
        int n = strlen(words[i]);
        int mask = 0;
        for (int j = 0; j < n; j++) {
            mask |= (1 << (words[i][j] - 'a'));
        }
        if (__builtin_popcount(mask) <= 7) {
            struct unordered_map* tmp;
            HASH_FIND_INT(frequency, &mask, tmp);
            if (tmp == NULL) {
                tmp = malloc(sizeof(struct unordered_map));
                tmp->key = mask;
                tmp->val = 1;
                HASH_ADD_INT(frequency, key, tmp);
            } else {
                tmp->val++;
            }
        }
    }

    int* ans = malloc(sizeof(int) * puzzlesSize);
    *returnSize = 0;

    for (int i = 0; i < puzzlesSize; i++) {
        int total = 0;

        // 枚举子集方法一
        // for (int choose = 0; choose < (1 << 6); ++choose) {
        //     int mask = 0;
        //     for (int j = 0; j < 6; ++j) {
        //         if (choose & (1 << j)) {
        //             mask |= (1 << (puzzles[i][j + 1] - 'a'));
        //         }
        //     }
        //     mask |= (1 << (puzzles[i][0] - 'a'));
        //     struct unordered_map* tmp;
        //     HASH_FIND_INT(frequency, &mask, tmp);
        //     if (tmp != NULL) {
        //         total += tmp->val;
        //     }
        // }

        // 枚举子集方法二
        int mask = 0;
        for (int j = 1; j < 7; ++j) {
            mask |= (1 << (puzzles[i][j] - 'a'));
        }
        int subset = mask;
        do {
            int s = subset | (1 << (puzzles[i][0] - 'a'));
            struct unordered_map* tmp;
            HASH_FIND_INT(frequency, &s, tmp);
            if (tmp != NULL) {
                total += tmp->val;
            }
            subset = (subset - 1) & mask;
        } while (subset != mask);
        ans[(*returnSize)++] = total;
    }
    return ans;
}
```

**复杂度分析**

- 时间复杂度：$O(m|w| + n2^{|p|})$，其中 $m$ 和 $n$ 分别是数组 $\textit{words}$ 和 $\textit{puzzles}$ 的长度，$|w|$ 是 $\textit{word}$ 的最大长度 $50$，$|p|$ 是 $\textit{puzzle}$ 的最大长度 $7$。时间复杂度分为三部分：

    - 计算所有 $\textit{word}$ 对应的二进制表示的时间复杂度为 $O(m|w|)$；

    - 计算所有 $\textit{puzzle}$ 对应的二进制表示的时间复杂度为 $O(n|p|)$；

    - 枚举 $\textit{puzzle}$ 的子集的时间复杂度为 $O(n2^{|p|-1})$，这里为使用第二种方法的时间复杂度，如果使用第一种方法，那么时间复杂度略高，为 $O(n(|p|-1)2^{|p|-1})$。

    由于 $|p|-1$ 与 $|p|$ 同阶，因此写成 $O(|p|)$ 更加简洁。并且由于第三部分的时间复杂度在渐进意义下严格大于第二部分，因此总时间复杂度即为第一部分与第三部分之和 $O(m|w| + n2^{|p|})$。

- 空间复杂度：$O(m)$，即为哈希映射需要使用的空间，其中最多只包含 $m$ 个键值对。

#### 方法二：字典树

**思路与算法**

由于题目中规定 $\textit{word}$ 和 $\textit{puzzle}$ 均只包含小写字母，我们也可以考虑使用字典树来表示需要的「数据结构」。由于方法一中已经详细介绍了每一步的做法，因此方法二中只介绍与方法一不同的地方。

对于每一个 $\textit{word}$ 对应的集合 $S_w$，我们将 $S_w$ 中的的字母按照字典序进行排序，组成一个字符串，加入字典树中。与方法一中的哈希映射类似，我们需要统计每个字符串在字典树中的出现次数。

对于每一个 $\textit{puzzle}$ 对应的集合 $S_p$，我们枚举 $S_p$ 的子集，并将子集中的字母按照字典序进行排序，组成一个字符串，在字典树中查询得到其出现次数。需要注意的是，由于 $S_p$ 只是一个普通的集合，而不是二进制表示，因此我们可以使用回溯的方法，在枚举子集的同时维护可以在字典树上进行查询的指针。详细的实现可以见下面的代码。

**细节**

在实际的实现中，我们无需显式地构造出加入字典树以及在字典树中查询需要的字符串，可以考虑使用一些等价的简单数据结构（例如列表）表示字符串。

**代码**

下面给出的 $\texttt{C++}$ 代码中并未析构字典树申请的堆空间。

```C++ [sol2-C++]
struct TrieNode {
    int frequency = 0;
    TrieNode* child[26];

    TrieNode() {
        for (int i = 0; i < 26; ++i) {
            child[i] = nullptr;
        }
    }
};

class Solution {
private:
    TrieNode* root;

public:
    vector<int> findNumOfValidWords(vector<string>& words, vector<string>& puzzles) {
        root = new TrieNode();

        auto add = [&](const string& word) {
            TrieNode* cur = root;
            for (char ch: word) {
                if (!cur->child[ch - 'a']) {
                    cur->child[ch - 'a'] = new TrieNode();
                }
                cur = cur->child[ch - 'a'];
            }
            ++cur->frequency;
        };

        // 在回溯的过程中枚举 puzzle 的所有子集并统计答案
        // find(puzzle, required, cur, pos) 表示 puzzle 的首字母为 required, 当前搜索到字典树上的 cur 节点，并且准备枚举 puzzle 的第 pos 个字母是否选择（放入子集中）
        // find 函数的返回值即为谜底的数量
        function<int(const string&, char, TrieNode*, int)> find = [&](const string& puzzle, char required, TrieNode* cur, int pos) {
            // 搜索到空节点，不合法，返回 0
            if (!cur) {
                return 0;
            }
            // 整个 puzzle 搜索完毕，返回谜底的数量
            if (pos == 7) {
                return cur->frequency;
            }
            
            // 选择第 pos 个字母
            int ret = find(puzzle, required, cur->child[puzzle[pos] - 'a'], pos + 1);

            // 当 puzzle[pos] 不为首字母时，可以不选择第 pos 个字母
            if (puzzle[pos] != required) {
                ret += find(puzzle, required, cur, pos + 1);
            }
            
            return ret;
        };
        
        for (string word: words) {
            // 将 word 中的字母按照字典序排序并去重
            sort(word.begin(), word.end());
            word.erase(unique(word.begin(), word.end()), word.end());
            // 加入字典树中
            add(word);
        }

        vector<int> ans;
        for (string puzzle: puzzles) {
            char required = puzzle[0];
            sort(puzzle.begin(), puzzle.end());
            ans.push_back(find(puzzle, required, root, 0));
        }
        return ans;
    }
};
```

```Java [sol2-Java]
class Solution {
    TrieNode root;

    public List<Integer> findNumOfValidWords(String[] words, String[] puzzles) {
        root = new TrieNode();
        
        for (String word : words) {
            // 将 word 中的字母按照字典序排序并去重
            char[] arr = word.toCharArray();
            Arrays.sort(arr);
            StringBuffer sb = new StringBuffer();
            for (int i = 0; i < arr.length; ++i) {
                if (i == 0 || arr[i] != arr[i - 1]) {
                    sb.append(arr[i]);
                }
            }
            // 加入字典树中
            add(root, sb.toString());
        }

        List<Integer> ans = new ArrayList<Integer>();
        for (String puzzle : puzzles) {
            char required = puzzle.charAt(0);
            char[] arr = puzzle.toCharArray();
            Arrays.sort(arr);
            ans.add(find(new String(arr), required, root, 0));
        }
        return ans;
    }

    public void add(TrieNode root, String word) {
        TrieNode cur = root;
        for (int i = 0; i < word.length(); ++i) {
            char ch = word.charAt(i);
            if (cur.child[ch - 'a'] == null) {
                cur.child[ch - 'a'] = new TrieNode();
            }
            cur = cur.child[ch - 'a'];
        }
        ++cur.frequency;
    }

    // 在回溯的过程中枚举 puzzle 的所有子集并统计答案
    // find(puzzle, required, cur, pos) 表示 puzzle 的首字母为 required, 当前搜索到字典树上的 cur 节点，并且准备枚举 puzzle 的第 pos 个字母是否选择（放入子集中）
    // find 函数的返回值即为谜底的数量
    public int find(String puzzle, char required, TrieNode cur, int pos) {
        // 搜索到空节点，不合法，返回 0
        if (cur == null) {
            return 0;
        }
        // 整个 puzzle 搜索完毕，返回谜底的数量
        if (pos == 7) {
            return cur.frequency;
        }

        // 选择第 pos 个字母
        int ret = find(puzzle, required, cur.child[puzzle.charAt(pos) - 'a'], pos + 1);

        // 当 puzzle.charAt(pos) 不为首字母时，可以不选择第 pos 个字母
        if (puzzle.charAt(pos) != required) {
            ret += find(puzzle, required, cur, pos + 1);
        }

        return ret;
    }
}

class TrieNode {
    int frequency;
    TrieNode[] child;

    public TrieNode() {
        frequency = 0;
        child = new TrieNode[26];
    }
}
```

```Python [sol2-Python3]
class TrieNode:
    def __init__(self):
        self.frequency = 0
        self.child = dict()

class Solution:
    def findNumOfValidWords(self, words: List[str], puzzles: List[str]) -> List[int]:
        root = TrieNode()

        def add(word: List[str]):
            cur = root
            for ch in word:
                idx = ord(ch) - ord("a")
                if idx not in cur.child:
                    cur.child[idx] = TrieNode()
                cur = cur.child[idx]
            cur.frequency += 1

        # 在回溯的过程中枚举 puzzle 的所有子集并统计答案
        # find(puzzle, required, cur, pos) 表示 puzzle 的首字母为 required, 当前搜索到字典树上的 cur 节点，并且准备枚举 puzzle 的第 pos 个字母是否选择（放入子集中）
        # find 函数的返回值即为谜底的数量
        def find(puzzle: List[str], required: str, cur: TrieNode, pos: int) -> int:
            # 搜索到空节点，不合法，返回 0
            if not cur:
                return 0
            # 整个 puzzle 搜索完毕，返回谜底的数量
            if pos == 7:
                return cur.frequency
            
            ret = 0
            # 选择第 pos 个字母
            if (idx := ord(puzzle[pos]) - ord("a")) in cur.child:
                ret += find(puzzle, required, cur.child[idx], pos + 1)

            # 当 puzzle[pos] 不为首字母时，可以不选择第 pos 个字母
            if puzzle[pos] != required:
                ret += find(puzzle, required, cur, pos + 1)
            
            return ret
        
        for word in words:
            # 将 word 中的字母按照字典序排序并去重
            word = sorted(set(word))
            # 加入字典树中
            add(word)

        ans = list()
        for puzzle in puzzles:
            required = puzzle[0]
            puzzle = sorted(puzzle)
            ans.append(find(puzzle, required, root, 0))
        
        return ans
```

```go [sol2-Golang]
type trieNode struct {
    son [26]*trieNode
    cnt int
}

func findNumOfValidWords(words []string, puzzles []string) []int {
    root := &trieNode{}
    for _, word := range words {
        // 将 word 中的字母按照字典序排序并去重
        w := []byte(word)
        sort.Slice(w, func(i, j int) bool { return w[i] < w[j] })
        i := 0
        for _, ch := range w[1:] {
            if w[i] != ch {
                i++
                w[i] = ch
            }
        }
        w = w[:i+1]

        // 加入字典树中
        cur := root
        for _, ch := range w {
            ch -= 'a'
            if cur.son[ch] == nil {
                cur.son[ch] = &trieNode{}
            }
            cur = cur.son[ch]
        }
        cur.cnt++
    }

    ans := make([]int, len(puzzles))
    for i, puzzle := range puzzles {
        pz := []byte(puzzle)
        first := pz[0]
        sort.Slice(pz, func(i, j int) bool { return pz[i] < pz[j] })

        // 在回溯的过程中枚举 pz 的所有子集并统计答案
        var find func(int, *trieNode) int
        find = func(pos int, cur *trieNode) int {
            // 搜索到空节点，不合法，返回 0
            if cur == nil {
                return 0
            }

            // 整个 pz 搜索完毕，返回谜底的数量
            if pos == len(pz) {
                return cur.cnt
            }

            // 选择第 pos 个字母
            res := find(pos+1, cur.son[pz[pos]-'a'])

            // 当 pz[pos] 不为首字母时，可以不选择第 pos 个字母
            if pz[pos] != first {
                res += find(pos+1, cur)
            }

            return res
        }

        ans[i] = find(0, root)
    }

    return ans
}
```

```C [sol2-C]
struct TrieNode {
    int frequency;
    struct TrieNode* child[26];
};

void init(struct TrieNode* obj) {
    obj->frequency = 0;
    for (int i = 0; i < 26; ++i) {
        obj->child[i] = NULL;
    }
}

// 在回溯的过程中枚举 puzzle 的所有子集并统计答案
// find(puzzle, required, cur, pos) 表示 puzzle 的首字母为 required, 当前搜索到字典树上的 cur 节点，并且准备枚举 puzzle 的第 pos
// 个字母是否选择（放入子集中） find 函数的返回值即为谜底的数量
void add(struct TrieNode** root, char* word, int wordSize) {
    struct TrieNode* cur = *root;
    for (int i = 0; i < wordSize; ++i) {
        if (!cur->child[word[i] - 'a']) {
            cur->child[word[i] - 'a'] = malloc(sizeof(struct TrieNode));
            init(cur->child[word[i] - 'a']);
        }
        cur = cur->child[word[i] - 'a'];
    }
    ++cur->frequency;
}

int find(char* puzzle, char required, struct TrieNode* cur, int pos) {
    // 搜索到空节点，不合法，返回 0
    if (!cur) {
        return 0;
    }
    // 整个 puzzle 搜索完毕，返回谜底的数量
    if (pos == 7) {
        return cur->frequency;
    }

    // 选择第 pos 个字母
    int ret = find(puzzle, required, cur->child[puzzle[pos] - 'a'], pos + 1);

    // 当 puzzle[pos] 不为首字母时，可以不选择第 pos 个字母
    if (puzzle[pos] != required) {
        ret += find(puzzle, required, cur, pos + 1);
    }

    return ret;
};

int cmp(char* a, char* b) {
    return *a - *b;
}

int* findNumOfValidWords(char** words, int wordsSize, char** puzzles, int puzzlesSize, int* returnSize) {
    struct TrieNode* root = malloc(sizeof(struct TrieNode));
    init(root);

    for (int i = 0; i < wordsSize; i++) {
        // 将 word 中的字母按照字典序排序并去重
        int len = strlen(words[i]);
        char* word = malloc(sizeof(char) * (len + 1));
        strcpy(word, words[i]);
        qsort(word, len, sizeof(char), cmp);
        int wordSize = 1;
        for (int j = 1; j < len; j++) {
            if (word[wordSize - 1] != word[j]) {
                word[wordSize++] = word[j];
            }
        }

        // 加入字典树中
        add(&root, word, wordSize);
    }

    int* ans = malloc(sizeof(int) * puzzlesSize);
    *returnSize = 0;

    for (int i = 0; i < puzzlesSize; i++) {
        int len = strlen(puzzles[i]);
        char* puzzle = malloc(sizeof(char) * (len + 1));
        strcpy(puzzle, puzzles[i]);
        char required = puzzle[0];
        qsort(puzzle, len, sizeof(char), cmp);
        ans[(*returnSize)++] = find(puzzle, required, root, 0);
    }
    return ans;
}
```

**复杂度分析**

- 时间复杂度：$O(m|w|\log|w| + n2^{|p|})$，其中 $m$ 和 $n$ 分别是数组 $\textit{words}$ 和 $\textit{puzzles}$ 的长度，$|w|$ 是 $\textit{word}$ 的最大长度 $50$，$|p|$ 是 $\textit{puzzle}$ 的最大长度 $7$。时间复杂度分为四部分：

    - 计算所有 $\textit{word}$ 对应的集合，进行排序的时间复杂度为 $O(m|w|\log|w|)$；

    - 将第一部分加入字典树的时间复杂度为 $O(m|w|)$；

    - 计算所有 $\textit{puzzle}$ 对应的集合，进行排序的时间复杂度为 $O(n|p|\log|p|)$；

    - 枚举 $\textit{puzzle}$ 的子集并在字典树中查询子集的复杂度为 $O(n2^{|p|-1})$。

    由于 $|p|-1$ 与 $|p|$ 同阶，因此写成 $O(|p|)$ 更加简洁。并且由于第一部分的时间复杂度在渐进意义下严格大于第二部分，第四部分的时间复杂度在渐进意义下严格大于第三部分，因此总时间复杂度即为第一部分与第四部分之和 $O(m|w|\log|w| + n2^{|p|})$。

- 空间复杂度：$O(m|w| + |p|)$。字典树需要使用的空间为 $O(m|w|)$，将 $\textit{word}$ 加入字典树时，需要用 $O(|w|)$ 的空间存储 $\textit{word}$ 按照字典序排序后的结果，其在渐进意义下严格小于 $O(m|w|)$ 可忽略。在使用回溯的方法在字典树中查询 $\textit{puzzle}$ 的子集时，需要使用 $O(|p|)$ 的空间存储 $\textit{puzzle}$ 按照字典序排序后的结果，并且需要 $O(|p|)$ 的栈空间，因此总空间复杂度为 $O(m|w| + |p|)$。
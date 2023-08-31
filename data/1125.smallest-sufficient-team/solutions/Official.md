## [1125.最小的必要团队 中文官方题解](https://leetcode.cn/problems/smallest-sufficient-team/solutions/100000/zui-xiao-de-bi-yao-tuan-dui-by-leetcode-2mbmz)
#### 方法一：动态规划

**思路与算法**

题目输入数组 $\textit{req\_skills}$ 的长度最大为 $16$，$\textit{req\_skills}$ 中的每一项，被选择或者不被选择，总共的组合情况为 $2^{16}$ 种。因此可以通过「状态压缩」来表示一个技能集合。

我们将每一个技能 $\textit{req\_skills}[i]$ 映射到一个二进制数的第 $i$ 位。例如：
- $\textit{req\_skills}[0]$ 用 $2^{0} = (1 << 0) = 1$ 来表示。
- $\textit{req\_skills}[1]$ 用 $2^{1} = (1 << 1) = 2$ 来表示。

以此类推，如此一来我们就可以用一个数字来表示一个技能集合。同时两个集合的并集计算，就可以转化为两个整数的或运算。

我们采用自下而上的「动态规划」的思路来解题，用 $\textit{dp}[i]$ 来表示状态，状态含义是满足技能集合为 $i$ 的最小人数的数组。初始化状态是 $\textit{dp}[0]$，为空数组，因为如果不需要任何技能，不用任何人就可以完成。

我们首先依次遍历 $\textit{peoples}$，求出当前这个人所有的技能集合 $\textit{cur\_skill}$。然后遍历 $\textit{dp}$ 表中的结果 $\textit{dp}[\textit{prev}]$，其中原来的技能集合用 $\textit{prev}$ 来表示。设加入当前这个人后新的技能集合是 $\textit{comb}$，由原来的技能集合和当前技能集合求并集后，可以得到：$\textit{comb} = \textit{prev} ~|~ \textit{cur\_skill}$。状态转移的规则是，如果 $\textit{dp}[\textit{comb}]$ 不存在，或 $\textit{dp}[\textit{prev}]$ 的长度加上 $1$ 小于 $\textit{dp}[\textit{comb}].\textit{size}()$，那么我们就需要更新 $\textit{dp}[\textit{comb}]$ 为 $\textit{dp}[\textit{prev}]$，再将当前人加入到 $\textit{dp}[\textit{comb}]$。这里我们更新 $\textit{dp}[\textit{comb}]$ 时候，可以采用直接覆盖的方式，因为更新后的结果因为已经包含了当前员工的技能，所以不会再次满足转移规则，而发生重复转移。

最后，所有技能的集合用 $(1 << n) - 1$ 来表示，其中 $n$ 是 $\textit{req\_skills}$ 的长度，我们只需要返回最终答案 $\textit{dp}[(1 << n) - 1]$。

**代码**

```Java [sol1-Java]
class Solution {
    public int[] smallestSufficientTeam(String[] req_skills, List<List<String>> people) {
        int n = req_skills.length, m = people.size();
        HashMap<String, Integer> skill_index = new HashMap<>();
        for (int i = 0; i < n; ++i) {
            skill_index.put(req_skills[i], i);
        }
        List<Integer>[] dp = new List[1 << n];
        dp[0] = new ArrayList<>();
        for (int i = 0; i < m; ++i) {
            int cur_skill = 0;
            for (String s : people.get(i)) {
                cur_skill |= 1 << skill_index.get(s);
            }
            for (int prev = 0; prev < dp.length; ++prev) {
                if (dp[prev] == null) {
                    continue;
                }
                int comb = prev | cur_skill;
                if (dp[comb] == null || dp[prev].size() + 1 < dp[comb].size()) {
                    dp[comb] = new ArrayList<>(dp[prev]);
                    dp[comb].add(i);
                }
            }
        }
        return dp[(1 << n) - 1].stream().mapToInt(i -> i).toArray();
    }
}
```

```C++ [sol1-C++]
class Solution {
public:
    vector<int> smallestSufficientTeam(vector<string>& req_skills, vector<vector<string>>& people) {
        int n = req_skills.size(), m = people.size();
        unordered_map<string, int> skill_index;
        for (int i = 0; i < n; ++i) {
            skill_index[req_skills[i]] = i;
        }
        vector<vector<int>> dp(1 << n);
        for (int i = 0; i < m; ++i) {
            int cur_skill = 0;
            for (string& s : people[i]) {
                cur_skill |= 1 << skill_index[s];
            }
            for (int prev = 0; prev < dp.size(); ++prev) {
                if (prev > 0 && dp[prev].empty()) {
                    continue;
                }
                int comb = prev | cur_skill;
                if (comb == prev) {
                    continue;
                }
                if (dp[comb].empty() || dp[prev].size() + 1 < dp[comb].size()) {
                    dp[comb] = dp[prev];
                    dp[comb].push_back(i);
                }
            }
        }
        return dp[(1 << n) - 1];
    }
};
```

```C# [sol1-C#]
public class Solution {
    public int[] SmallestSufficientTeam(string[] req_skills, IList<IList<string>> people) {
        int n = req_skills.Length, m = people.Count;
        IDictionary<string, int> skill_index = new Dictionary<string, int>();
        for (int i = 0; i < n; ++i) {
            skill_index.Add(req_skills[i], i);
        }
        IList<int>[] dp = new IList<int>[1 << n];
        dp[0] = new List<int>();
        for (int i = 0; i < m; ++i) {
            int cur_skill = 0;
            foreach (string s in people[i]) {
                cur_skill |= 1 << skill_index[s];
            }
            for (int prev = 0; prev < dp.Length; ++prev) {
                if (dp[prev] == null) {
                    continue;
                }
                int comb = prev | cur_skill;
                if (dp[comb] == null || dp[prev].Count + 1 < dp[comb].Count) {
                    dp[comb] = new List<int>(dp[prev]);
                    dp[comb].Add(i);
                }
            }
        }
        return dp[(1 << n) - 1].ToArray();
    }
}
```

```Python [sol1-Python3]
class Solution:
    def smallestSufficientTeam(self, req_skills: List[str], people: List[List[str]]) -> List[int]:
        n, m = len(req_skills), len(people)
        skill_index = {v: i for i, v in enumerate(req_skills)}
        dp = [None] * (1 << n)
        dp[0] = []
        for i, p in enumerate(people):
            cur_skill = 0
            for s in p:
                cur_skill |= 1 << skill_index[s]
            for prev in range(1 << n):
                if dp[prev] == None:
                    continue
                comb = prev | cur_skill
                if dp[comb] == None or len(dp[comb]) > len(dp[prev]) + 1:
                    dp[comb] = dp[prev] + [i]
        return dp[(1 << n) - 1]
```

```C [sol1-C]
typedef struct {
    char *key;
    int val;
    UT_hash_handle hh;
} HashItem;

HashItem *hashFindItem(HashItem **obj, char *key) {
    HashItem *pEntry = NULL;
    HASH_FIND_STR(*obj, key, pEntry);
    return pEntry;
}

bool hashAddItem(HashItem **obj, char *key, int val) {
    if (hashFindItem(obj, key)) {
        return false;
    }
    HashItem *pEntry = (HashItem *)malloc(sizeof(HashItem));
    pEntry->key = key;
    pEntry->val = val;
    HASH_ADD_STR(*obj, key, pEntry);
    return true;
}

bool hashSetItem(HashItem **obj, char *key, int val) {
    HashItem *pEntry = hashFindItem(obj, key);
    if (!pEntry) {
        hashAddItem(obj, key, val);
    } else {
        pEntry->val = val;
    }
    return true;
}

int hashGetItem(HashItem **obj, char *key, int defaultVal) {
    HashItem *pEntry = hashFindItem(obj, key);
    if (!pEntry) {
        return defaultVal;
    }
    return pEntry->val;
}

void hashFree(HashItem **obj) {
    HashItem *curr = NULL, *tmp = NULL;
    HASH_ITER(hh, *obj, curr, tmp) {
        HASH_DEL(*obj, curr);
        free(curr);
    }
}

int* smallestSufficientTeam(char ** req_skills, int req_skillsSize, char *** people, int peopleSize, int* peopleColSize, int* returnSize) {
    int n = req_skillsSize, m = peopleSize;
    HashItem *skill_index = NULL;
    for (int i = 0; i < n; ++i) {
        hashAddItem(&skill_index, req_skills[i], i);
    }

    int *dp[1 << n], dpColSize[1 << n];
    memset(dpColSize, 0, sizeof(dpColSize));
    for (int i = 0; i < (1 << n); i++) {
        dp[i] = NULL;
    }
    dp[0] = (int *)calloc(m, sizeof(int));
    for (int i = 0; i < m; ++i) {
        int cur_skill = 0;
        for (int j = 0; j < peopleColSize[i]; j++) {
            cur_skill |= 1 << hashGetItem(&skill_index, people[i][j], 0);
        }
        for (int prev = 0; prev < (1 << n); ++prev) {
            if (dp[prev] == NULL) {
                continue;
            }
            int comb = prev | cur_skill;
            if (dp[comb] == NULL || dpColSize[prev] + 1 < dpColSize[comb]) {
                dp[comb] = (int *)calloc(m, sizeof(int));
                memcpy(dp[comb], dp[prev], sizeof(int) * dpColSize[prev]);
                dpColSize[comb] = dpColSize[prev];
                dp[comb][dpColSize[comb]++] = i;
            }
        }
    }
    for (int i = 0; i < (1 << n) - 1; i++) {
        if (dp[i]) {
            free(dp[i]);
        }
    }
    *returnSize = dpColSize[(1 << n) - 1];
    return dp[(1 << n) - 1];
}
```

```Go [sol1-Go]
func smallestSufficientTeam(req_skills []string, people [][]string) []int {
    n, m := len(req_skills), len(people)
    skill_index := make(map[string]int)
    for i, skill := range req_skills {
        skill_index[skill] = i
    }
    dp := make([][]int, 1 << n)
    dp[0] = []int {}
    for i := 0; i < m; i++ {
        cur_skill := 0
        for _, s := range people[i] {
            cur_skill |= 1 << skill_index[s]
        }
        for prev := 0; prev < len(dp); prev++ {
            if dp[prev] == nil {
                continue
            }
            comb := prev | cur_skill
            if dp[comb] == nil || len(dp[prev]) + 1 < len(dp[comb]) {
                dp[comb] = make([]int, len(dp[prev]))
                copy(dp[comb], dp[prev])
                dp[comb] = append(dp[comb], i)
            }
        }
    }
    return dp[(1 << n) - 1]
}
```

```JavaScript [sol1-JavaScript]
var smallestSufficientTeam = function(req_skills, people) {
    const n = req_skills.length;
    const m = people.length;
    let skillIndex = new Map();
    for (let i = 0; i < n; i++) {
        skillIndex.set(req_skills[i], i);
    }
    let dp = new Array(1 << n);
    dp[0] = [];
    for (let i = 0; i < m; i++) {
        let cur_skill = 0;
        for (let s of people[i]) {
            cur_skill |= 1 << skillIndex.get(s);
        }
        for (let prev = 0; prev < dp.length; prev++) {
            if (dp[prev] === undefined) {
                continue;
            }
            let comb = prev | cur_skill;
            if (dp[comb] === undefined || dp[prev].length + 1 < dp[comb].length) {
                dp[comb] = [...dp[prev], i];
            }
        }
    }
    return dp[(1 << n) - 1];
};
```

**复杂度分析**

* 时间复杂度：$O(m^{2} \times 2^{n})$，其中 $n$ 是 $\textit{req\_skills}$ 的长度，$m$ 是 $\textit{peoples}$ 的长度。
* 空间复杂度：$O(m \times 2^{n})$，其中 $n$ 是 $\textit{req\_skills}$ 的长度，$m$ 是 $\textit{peoples}$ 的长度。


#### 方法二：动态规划 + 优化

**思路与算法**
在方法一中，我们用 $\textit{dp}[i]$ 来表示状态，状态含义是满足技能集合为 $i$ 的最小人数的数组，每一个状态都用数组记录了具体的人员编号。这个过程浪费很多空间去储存结果，也消耗了很多时间去生成数组。
实际上我们只去要记录下每个状态的产生来源，就可以按序还原每个状态的具体人员编号的数组。

我们用：
- $\textit{dp}[i]$ 来表示，满足技能集合为 $i$ 的最小人数。类似方法一中，我们初始化 $\textit{dp}[0] = 0$，其它 $\textit{dp}[i]$ 初始为最大值 $m$。
- $\textit{prev\_skill}[i]$ 来表示先前的技能集合，技能集合 $i$ 是从 $\textit{prev\_skill}[i]$ 转移来的。
- $\textit{prev\_people}[i]$ 来表示一个最新加入的员工，技能集合 $i$ 是通过加入员工 $\textit{prev\_people}[i]$ 而转移来的。

通过这样方式，我们就记录了每一个状态的转移来源。


最后，所有技能的集合用 $(1 << n) - 1$ 来表示，其中 $n$ 是 $\textit{req\_skills}$ 的长度。当我们要复原一个技能集合 $i$ 的时候，我们可以找到最后一个员工 $\textit{prev\_people}[i]$, 把它加入结果中，然后赋值 $i$ 为 $\textit{prev\_skill}[i]$。不断重复这个过程，直到 $i = 0$，表示我们已找到需要技能集合的最少员工。


**代码**
```Java [sol2-Java]
class Solution {
    public int[] smallestSufficientTeam(String[] req_skills, List<List<String>> people) {
        int n = req_skills.length, m = people.size();
        HashMap<String, Integer> skill_index = new HashMap<>();
        for (int i = 0; i < n; ++i) {
            skill_index.put(req_skills[i], i);
        }
        int[] dp = new int[1 << n];
        Arrays.fill(dp, m);
        dp[0] = 0;
        int[] prev_skill = new int[1 << n];
        int[] prev_people = new int[1 << n];
        for (int i = 0; i < m; i++) {
            List<String> p = people.get(i);
            int cur_skill = 0;
            for (String s : p) {
                cur_skill |= 1 << skill_index.get(s);
            }
            for (int prev = 0; prev < (1 << n); prev++) {
                int comb = prev | cur_skill;
                if (dp[comb] > dp[prev] + 1) {
                    dp[comb] = dp[prev] + 1;
                    prev_skill[comb] = prev;
                    prev_people[comb] = i;
                }
            }
        }
        List<Integer> res = new ArrayList<>();
        int i = (1 << n) - 1;
        while (i > 0) {
            res.add(prev_people[i]);
            i = prev_skill[i];
        }
        return res.stream().mapToInt(j -> j).toArray();
    }
}
```

```C++ [sol2-C++]
class Solution {
public:
    vector<int> smallestSufficientTeam(vector<string>& req_skills, vector<vector<string>>& people) {
        int n = req_skills.size(), m = people.size();
        unordered_map<string, int> skill_index;
        for (int i = 0; i < n; ++i) {
            skill_index[req_skills[i]] = i;
        }
        vector<int> dp(1 << n, m);
        dp[0] = 0;
        vector<int> prev_skill(1 << n, 0);
        vector<int> prev_people(1 << n, 0);
        for (int i = 0; i < m; ++i) {
            int cur_skill = 0;
            for (string& skill : people[i]) {
                cur_skill |= 1 << skill_index[skill];
            }
            for (int prev = 0; prev < (1 << n); prev++) {
                int comb = prev | cur_skill;
                if (dp[comb] > dp[prev] + 1) {
                    dp[comb] = dp[prev] + 1;
                    prev_skill[comb] = prev;
                    prev_people[comb] = i;
                }
            }
        }
        vector<int> res;
        int i = (1 << n) - 1;
        while (i > 0) {
            res.push_back(prev_people[i]);
            i = prev_skill[i];
        }
        return res;
    }
};

```

```C# [sol2-C#]
public class Solution {
    public int[] SmallestSufficientTeam(string[] req_skills, IList<IList<string>> people) {
        int n = req_skills.Length, m = people.Count;
        IDictionary<string, int> skill_index = new Dictionary<string, int>();
        for (int i = 0; i < n; ++i) {
            skill_index.Add(req_skills[i], i);
        }
        int[] dp = new int[1 << n];
        for (int i = 0; i < dp.Length; i++) {
            dp[i] = m;
        }
        dp[0] = 0;
        int[] prev_skill = new int[1 << n];
        int[] prev_people = new int[1 << n];
        for (int i = 0; i < m; ++i) {
            int cur_skill = 0;
            foreach (string s in people[i]) {
                cur_skill |= 1 << skill_index[s];
            }
            for (int prev = 0; prev < dp.Length; prev++) {
                int comb = prev | cur_skill;
                if (dp[comb] > dp[prev] + 1) {
                    dp[comb] = dp[prev] + 1;
                    prev_skill[comb] = prev;
                    prev_people[comb] = i;
                }
            }
        }
        List<int> res = new List<int>();
        int skills = (1 << n) - 1;
        while (skills > 0) {
            res.Add(prev_people[skills]);
            skills = prev_skill[skills];
        }
        return res.ToArray();
    }
}
```

```Python [sol2-Python3]
class Solution:
    def smallestSufficientTeam(self, req_skills: List[str], people: List[List[str]]) -> List[int]:
        n, m = len(req_skills), len(people)
        skill_index = {v: i for i, v in enumerate(req_skills)}
        dp = [m] * (1 << n)
        dp[0] = 0
        prev_skill = [0] * (1 << n)
        prev_people = [0] * (1 << n)
        for i, p in enumerate(people):
            cur_skill = 0
            for s in p:
                cur_skill |= 1 << skill_index[s]
            for prev in range(1 << n):
                comb = prev | cur_skill
                if dp[comb] > dp[prev] + 1:
                    dp[comb] = dp[prev] + 1
                    prev_skill[comb] = prev
                    prev_people[comb] = i
        res = []
        i = (1 << n) - 1
        while i > 0:
            res.append(prev_people[i])
            i = prev_skill[i]
        return res
```

```Go [sol2-Go]
func smallestSufficientTeam(req_skills []string, people [][]string) []int {
    n, m := len(req_skills), len(people)
    skill_index := make(map[string]int)
    for i, skill := range req_skills {
        skill_index[skill] = i
    }
    dp := make([]int, 1 << n)
    for i := range dp {
        dp[i] = m
    }
    dp[0] = 0
    prev_skill := make([]int, 1 << n)
    prev_people := make([]int, 1 << n)
    for i := 0; i < m; i++ {
        cur_skill := 0
        for _, s := range people[i] {
            cur_skill |= 1 << skill_index[s]
        }
        for prev := 0; prev < (1 << n); prev++ {
            comb := prev | cur_skill
            if dp[comb] > dp[prev]+1 {
                dp[comb] = dp[prev] + 1
                prev_skill[comb] = prev
                prev_people[comb] = i
            }
        }
    }
    res := []int{}
    i := (1 << n) - 1
    for i > 0 {
        res = append(res, prev_people[i])
        i = prev_skill[i]
    }
    return res
}
```

```JavaScript [sol2-JavaScript]
var smallestSufficientTeam = function(req_skills, people) {
    const n = req_skills.length;
    const m = people.length;
    let skillIndex = new Map();
    for (let i = 0; i < n; i++) {
        skillIndex.set(req_skills[i], i);
    }
    let dp = new Array(1 << n).fill(m);
    dp[0] = 0;
    let prev_skill = new Array(1 << n);
    let prev_people = new Array(1 << n);
    for (let i = 0; i < m; i++) {
        let cur_skill = 0;
        for (let s of people[i]) {
            cur_skill |= 1 << skillIndex.get(s);
        }
        for (let prev = 0; prev < (1 << n); prev++) {
            let comb = prev | cur_skill;
            if (dp[comb] > dp[prev] + 1) {
                dp[comb] = dp[prev] + 1;
                prev_skill[comb] = prev;
                prev_people[comb] = i;
            }
        }
    }
    let res = [];
    let skills = (1 << n) - 1;
    while (skills > 0) {
        res.push(prev_people[skills]);
        skills = prev_skill[skills];
    }
    return res;
};
```

```C [sol2-C]
typedef struct {
    char *key;
    int val;
    UT_hash_handle hh;
} HashItem; 

HashItem *hashFindItem(HashItem **obj, char *key) {
    HashItem *pEntry = NULL;
    HASH_FIND_STR(*obj, key, pEntry);
    return pEntry;
}

bool hashAddItem(HashItem **obj, char *key, int val) {
    if (hashFindItem(obj, key)) {
        return false;
    }
    HashItem *pEntry = (HashItem *)malloc(sizeof(HashItem));
    pEntry->key = key;
    pEntry->val = val;
    HASH_ADD_STR(*obj, key, pEntry);
    return true;
}

bool hashSetItem(HashItem **obj, char *key, int val) {
    HashItem *pEntry = hashFindItem(obj, key);
    if (!pEntry) {
        hashAddItem(obj, key, val);
    } else {
        pEntry->val = val;
    }
    return true;
}

int hashGetItem(HashItem **obj, char *key, int defaultVal) {
    HashItem *pEntry = hashFindItem(obj, key);
    if (!pEntry) {
        return defaultVal;
    }
    return pEntry->val;
}

void hashFree(HashItem **obj) {
    HashItem *curr = NULL, *tmp = NULL;
    HASH_ITER(hh, *obj, curr, tmp) {
        HASH_DEL(*obj, curr);  
        free(curr);             
    }
}

int* smallestSufficientTeam(char ** req_skills, int req_skillsSize, char *** people, int peopleSize, int* peopleColSize, int* returnSize) {
    int n = req_skillsSize, m = peopleSize;
    HashItem *skill_index = NULL;
    for (int i = 0; i < n; ++i) {
        hashAddItem(&skill_index, req_skills[i], i);
    }

    int dp[1 << n];
    int prev_skill[1 << n], prev_people[1 << n];
    memset(prev_skill, 0, sizeof(prev_skill));
    memset(prev_people, 0, sizeof(prev_people));
    dp[0] = 0;
    for (int i = 1; i < (1 << n); i++) {
        dp[i] = m;
    }
    for (int i = 0; i < m; ++i) {
        int cur_skill = 0;
        for (int j = 0; j < peopleColSize[i]; j++) {
            cur_skill |= 1 << hashGetItem(&skill_index, people[i][j], 0);
        }
        for (int prev = 0; prev < (1 << n); prev++) {
            int comb = prev | cur_skill;
            if (dp[comb] > dp[prev] + 1) {
                dp[comb] = dp[prev] + 1;
                prev_skill[comb] = prev;
                prev_people[comb] = i;
            }
        }
    }

    hashFree(&skill_index);
    int *res = (int *)calloc(m, sizeof(int));
    int i = (1 << n) - 1;
    int pos = 0;
    while (i > 0) {
        res[pos++] = prev_people[i];
        i = prev_skill[i];
    }
    *returnSize = pos;
    return res;
}
```

**复杂度分析**

* 时间复杂度：$O(m \times 2^{n})$，其中 $n$ 是 $\textit{req\_skills}$ 的长度，$m$ 是 $\textit{peoples}$ 的长度。
* 空间复杂度：$O(2^{n})$，其中 $n$ 是 $\textit{req\_skills}$ 的长度。
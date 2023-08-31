## [721.账户合并 中文官方题解](https://leetcode.cn/problems/accounts-merge/solutions/100000/zhang-hu-he-bing-by-leetcode-solution-3dyq)
#### 方法一：哈希表 + 并查集

两个账户需要合并，当且仅当两个账户至少有一个共同的邮箱地址，因此这道题的实质是判断所有的邮箱地址中有哪些邮箱地址必定属于同一人，可以使用并查集实现。

为了使用并查集实现账户合并，需要知道一共有多少个不同的邮箱地址，以及每个邮箱对应的名称，因此需要使用两个哈希表分别记录每个邮箱对应的编号和每个邮箱对应的名称，遍历所有的账户并在两个哈希表中记录相应的信息。虽然同一个邮箱地址可能在多个账户中出现，但是同一个邮箱地址在两个哈希表中都只能存储一次。

然后使用并查集进行合并操作。由于同一个账户中的邮箱地址一定属于同一个人，因此遍历每个账户，对账户中的邮箱地址进行合并操作。并查集存储的是每个邮箱地址对应的编号，合并操作也是针对编号进行合并。

完成并查集的合并操作之后，即可知道合并后有多少个不同的账户。遍历所有的邮箱地址，对于每个邮箱地址，通过并查集得到该邮箱地址属于哪个合并后的账户，即可整理出每个合并后的账户包含哪些邮箱地址。

对于每个合并后的账户，需要整理出题目要求的返回账户的格式，具体做法是：将邮箱地址排序，账户的名称可以通过在哈希表中查找任意一个邮箱对应的名称得到，将名称和排序后的邮箱地址整理成一个账户列表。对所有合并后的账户整理出账户列表，即可得到最终答案。

```Java [sol1-Java]
class Solution {
    public List<List<String>> accountsMerge(List<List<String>> accounts) {
        Map<String, Integer> emailToIndex = new HashMap<String, Integer>();
        Map<String, String> emailToName = new HashMap<String, String>();
        int emailsCount = 0;
        for (List<String> account : accounts) {
            String name = account.get(0);
            int size = account.size();
            for (int i = 1; i < size; i++) {
                String email = account.get(i);
                if (!emailToIndex.containsKey(email)) {
                    emailToIndex.put(email, emailsCount++);
                    emailToName.put(email, name);
                }
            }
        }
        UnionFind uf = new UnionFind(emailsCount);
        for (List<String> account : accounts) {
            String firstEmail = account.get(1);
            int firstIndex = emailToIndex.get(firstEmail);
            int size = account.size();
            for (int i = 2; i < size; i++) {
                String nextEmail = account.get(i);
                int nextIndex = emailToIndex.get(nextEmail);
                uf.union(firstIndex, nextIndex);
            }
        }
        Map<Integer, List<String>> indexToEmails = new HashMap<Integer, List<String>>();
        for (String email : emailToIndex.keySet()) {
            int index = uf.find(emailToIndex.get(email));
            List<String> account = indexToEmails.getOrDefault(index, new ArrayList<String>());
            account.add(email);
            indexToEmails.put(index, account);
        }
        List<List<String>> merged = new ArrayList<List<String>>();
        for (List<String> emails : indexToEmails.values()) {
            Collections.sort(emails);
            String name = emailToName.get(emails.get(0));
            List<String> account = new ArrayList<String>();
            account.add(name);
            account.addAll(emails);
            merged.add(account);
        }
        return merged;
    }
}

class UnionFind {
    int[] parent;

    public UnionFind(int n) {
        parent = new int[n];
        for (int i = 0; i < n; i++) {
            parent[i] = i;
        }
    }

    public void union(int index1, int index2) {
        parent[find(index2)] = find(index1);
    }

    public int find(int index) {
        if (parent[index] != index) {
            parent[index] = find(parent[index]);
        }
        return parent[index];
    }
}
```

```C++ [sol1-C++]
class UnionFind {
public:
    vector<int> parent;

    UnionFind(int n) {
        parent.resize(n);
        for (int i = 0; i < n; i++) {
            parent[i] = i;
        }
    }

    void unionSet(int index1, int index2) {
        parent[find(index2)] = find(index1);
    }

    int find(int index) {
        if (parent[index] != index) {
            parent[index] = find(parent[index]);
        }
        return parent[index];
    }
};

class Solution {
public:
    vector<vector<string>> accountsMerge(vector<vector<string>>& accounts) {
        map<string, int> emailToIndex;
        map<string, string> emailToName;
        int emailsCount = 0;
        for (auto& account : accounts) {
            string& name = account[0];
            int size = account.size();
            for (int i = 1; i < size; i++) {
                string& email = account[i];
                if (!emailToIndex.count(email)) {
                    emailToIndex[email] = emailsCount++;
                    emailToName[email] = name;
                }
            }
        }
        UnionFind uf(emailsCount);
        for (auto& account : accounts) {
            string& firstEmail = account[1];
            int firstIndex = emailToIndex[firstEmail];
            int size = account.size();
            for (int i = 2; i < size; i++) {
                string& nextEmail = account[i];
                int nextIndex = emailToIndex[nextEmail];
                uf.unionSet(firstIndex, nextIndex);
            }
        }
        map<int, vector<string>> indexToEmails;
        for (auto& [email, _] : emailToIndex) {
            int index = uf.find(emailToIndex[email]);
            vector<string>& account = indexToEmails[index];
            account.emplace_back(email);
            indexToEmails[index] = account;
        }
        vector<vector<string>> merged;
        for (auto& [_, emails] : indexToEmails) {
            sort(emails.begin(), emails.end());
            string& name = emailToName[emails[0]];
            vector<string> account;
            account.emplace_back(name);
            for (auto& email : emails) {
                account.emplace_back(email);
            }
            merged.emplace_back(account);
        }
        return merged;
    }
};
```

```JavaScript [sol1-JavaScript]
var accountsMerge = function(accounts) {
    const emailToIndex = new Map();
    const emailToName = new Map();
    let emailsCount = 0;
    for (const account of accounts) {
        const name = account[0];
        const size = account.length;
        for (let i = 1; i < size; i++) {
            const email = account[i];
            if (!emailToIndex.has(email)) {
                emailToIndex.set(email, emailsCount++);
                emailToName.set(email, name);
            }
        }
    }

    const uf = new UnionFind(emailsCount);
    for (const account of accounts) {
        const firstEmail = account[1];
        const firstIndex = emailToIndex.get(firstEmail);
        const size = account.length;
        for (let i = 2; i < size; i++) {
            const nextEmail = account[i];
            const nextIndex = emailToIndex.get(nextEmail);
            uf.union(firstIndex, nextIndex);
        }
    }

    const indexToEmails = new Map();
    for (const email of emailToIndex.keys()) {
        const index = uf.find(emailToIndex.get(email));
        const account = indexToEmails.get(index) ? indexToEmails.get(index) : [];
        account.push(email);
        indexToEmails.set(index, account);
    }
    const merged = [];
    for (const emails of indexToEmails.values()) {
        emails.sort();
        const name = emailToName.get(emails[0]);
        const account = [];
        account.push(name);
        account.push(...emails);
        merged.push(account);
    }
    return merged;
};

class UnionFind {
    constructor (n) {
        this.parent = new Array(n).fill(0).map((element, index) => index);
    }

    union (index1, index2) {
        this.parent[this.find(index2)] = this.find(index1);
    }

    find (index) {
        if (this.parent[index] !== index) {
            this.parent[index] = this.find(this.parent[index]);
        }
        return this.parent[index];
    }
}
```

```go [sol1-Golang]
func accountsMerge(accounts [][]string) (ans [][]string) {
    emailToIndex := map[string]int{}
    emailToName := map[string]string{}
    for _, account := range accounts {
        name := account[0]
        for _, email := range account[1:] {
            if _, has := emailToIndex[email]; !has {
                emailToIndex[email] = len(emailToIndex)
                emailToName[email] = name
            }
        }
    }

    parent := make([]int, len(emailToIndex))
    for i := range parent {
        parent[i] = i
    }
    var find func(int) int
    find = func(x int) int {
        if parent[x] != x {
            parent[x] = find(parent[x])
        }
        return parent[x]
    }
    union := func(from, to int) {
        parent[find(from)] = find(to)
    }

    for _, account := range accounts {
        firstIndex := emailToIndex[account[1]]
        for _, email := range account[2:] {
            union(emailToIndex[email], firstIndex)
        }
    }

    indexToEmails := map[int][]string{}
    for email, index := range emailToIndex {
        index = find(index)
        indexToEmails[index] = append(indexToEmails[index], email)
    }

    for _, emails := range indexToEmails {
        sort.Strings(emails)
        account := append([]string{emailToName[emails[0]]}, emails...)
        ans = append(ans, account)
    }
    return
}
```

```Python [sol1-Python3]
class UnionFind:
    def __init__(self, n):
        self.parent = list(range(n))

    def union(self, index1: int, index2: int):
        self.parent[self.find(index2)] = self.find(index1)

    def find(self, index: int) -> int:
        if self.parent[index] != index:
            self.parent[index] = self.find(self.parent[index])
        return self.parent[index]

class Solution:
    def accountsMerge(self, accounts: List[List[str]]) -> List[List[str]]:
        emailToIndex = dict()
        emailToName = dict()

        for account in accounts:
            name = account[0]
            for email in account[1:]:
                if email not in emailToIndex:
                    emailToIndex[email] = len(emailToIndex)
                    emailToName[email] = name
        
        uf = UnionFind(len(emailToIndex))
        for account in accounts:
            firstIndex = emailToIndex[account[1]]
            for email in account[2:]:
                uf.union(firstIndex, emailToIndex[email])
        
        indexToEmails = collections.defaultdict(list)
        for email, index in emailToIndex.items():
            index = uf.find(index)
            indexToEmails[index].append(email)
        
        ans = list()
        for emails in indexToEmails.values():
            ans.append([emailToName[emails[0]]] + sorted(emails))
        return ans
```

**复杂度分析**

- 时间复杂度：$O(n \log n)$，其中 $n$ 是不同邮箱地址的数量。
  需要遍历所有邮箱地址，在并查集内进行查找和合并操作，对于两个不同的邮箱地址，如果它们的祖先不同则需要进行合并，需要进行 $2$ 次查找和最多 $1$ 次合并。一共需要进行 $2n$ 次查找和最多 $n$ 次合并，因此时间复杂度是 $O(2n \log n)=O(n \log n)$。这里的并查集使用了路径压缩，但是没有使用按秩合并，最坏情况下的时间复杂度是 $O(n \log n)$，平均情况下的时间复杂度依然是 $O(n \alpha (n))$，其中 $\alpha$ 为阿克曼函数的反函数，$\alpha (n)$ 可以认为是一个很小的常数。
  整理出题目要求的返回账户的格式时需要对邮箱地址排序，时间复杂度是 $O(n \log n)$。  
  其余操作包括遍历所有邮箱地址，在哈希表中记录相应的信息，时间复杂度是 $O(n)$，在渐进意义下 $O(n)$ 小于 $O(n \log n)$。
  因此总时间复杂度是 $O(n \log n)$。

- 空间复杂度：$O(n)$，其中 $n$ 是不同邮箱地址的数量。空间复杂度主要取决于哈希表和并查集，每个哈希表存储的邮箱地址的数量为 $n$，并查集的大小为 $n$。
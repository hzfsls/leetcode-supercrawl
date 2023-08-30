### 方法一：字典树

由于我们需要将 `searchWord` 的前缀与 `products` 中的字符串进行匹配，因此我们可以使用字典树（Trie）来存储 `products` 中的所有字符串。这样以来，当我们依次输入 `searchWord` 中的每个字母时，我们可以从字典树的根节点开始向下查找，判断是否存在以当前的输入为前缀的字符串，并找出字典序最小的三个（若存在）字符串。

对于字典树中的每个节点，我们需要额外地存储一些数据来帮助我们快速得到答案。设字典树中的某个节点为 `node`，从字典树的根到该节点对应的字符串为 `prefix`，那么我们可以在 `node` 中使用数组或优先队列，存放字典序最小的三个以 `prefix` 为前缀的字符串。具体的做法是：当我们在字典树中插入字符串 `product` 并遍历到节点 `node` 时，我们将 `product` 存储在 `node` 中，若此时 `node` 中的字符串超过三个，就丢弃字典序最大的那个字符串。这样在所有的字符串都被插入到字典树中后，字典树中的节点 `node` 就存放了当输入为 `prefix` 时应该返回的那些字符串。

```C++ [sol1]
struct Trie {
    unordered_map<char, Trie*> child;
    priority_queue<string> words;
};

class Solution {
private:
    void addWord(Trie* root, const string& word) {
        Trie* cur = root;
        for (const char& ch: word) {
            if (!cur->child.count(ch)) {
                cur->child[ch] = new Trie();
            }
            cur = cur->child[ch];
            cur->words.push(word);
            if (cur->words.size() > 3) {
                cur->words.pop();
            }
        }
    }
    
public:
    vector<vector<string>> suggestedProducts(vector<string>& products, string searchWord) {
        Trie* root = new Trie();
        for (const string& word: products) {
            addWord(root, word);
        }
        
        vector<vector<string>> ans;
        Trie* cur = root;
        bool flag = false;
        for (const char& ch: searchWord) {
            if (flag || !cur->child.count(ch)) {
                ans.emplace_back();
                flag = true;
            }
            else {
                cur = cur->child[ch];
                vector<string> selects;
                while (!cur->words.empty()) {
                    selects.push_back(cur->words.top());
                    cur->words.pop();
                }
                reverse(selects.begin(), selects.end());
                ans.push_back(move(selects));
            }
        }
        
        return ans;
    }
};
```

```Python [sol1]
class Trie:
    def __init__(self):
        self.child = dict()
        self.words = list()

class Solution:
    def suggestedProducts(self, products: List[str], searchWord: str) -> List[List[str]]:
        def addWord(root, word):
            cur = root
            for ch in word:
                if ch not in cur.child:
                    cur.child[ch] = Trie()
                cur = cur.child[ch]
                cur.words.append(word)
                cur.words.sort()
                if len(cur.words) > 3:
                    cur.words.pop()

        root = Trie()
        for word in products:
            addWord(root, word)
        
        ans = list()
        cur = root
        flag = False
        for ch in searchWord:
            if flag or ch not in cur.child:
                ans.append(list())
                flag = True
            else:
                cur = cur.child[ch]
                ans.append(cur.words)

        return ans
```

**复杂度分析**

- 时间复杂度：$O(\sum L + S)$，其中 $\sum L$ 是所有字符串的长度之和，$S$ 是字符串 `searchWord` 的长度。在计算时间复杂度时，我们将字符串的平均长度视为常数，即在字典树中存储、比较和丢弃字符串的时间复杂度均为 $O(1)$。

- 空间复杂度：$O(\sum L)$。

### 方法二：二分查找

方法一中的字典树需要使用额外的空间。可以发现，字典树实际上是帮助我们完成了排序的工作。如果我们直接将数组 `products` 中的所有字符串按照字典序进行排序，那么对于输入单词 `searchWord` 的某个前缀 `prefix`，我们只需要在排完序的数组中找到最小的三个字典序大于等于 `prefix` 的字符串，并依次判断它们是否以 `prefix` 为前缀即可。由于在排完序的数组中，以 `prefix` 为前缀的字符串的位置一定是连续的，因此我们可以使用二分查找，找出最小的字典序大于等于 `prefix` 的字符串 `products[i]`，并依次判断 `products[i]`，`products[i + 1]` 和 `products[i + 2]` 是否以 `prefix` 为前缀即可。

此外，在我们输入单词 `seachWord` 中每个字母的过程中，`prefix` 的字典序是不断增大的。因此在每次二分查找时，我们可以将左边界设为上一次找到的位置 `i`，而不用从以 `0` 为左边界，这样可以减少每次二分查找中的查找次数（但不会减少时间复杂度的数量级）。

```C++ [sol2]
class Solution {
public:
    vector<vector<string>> suggestedProducts(vector<string>& products, string searchWord) {
        sort(products.begin(), products.end());
        string query;
        auto iter_last = products.begin();
        vector<vector<string>> ans;
        for (char ch: searchWord) {
            query += ch;
            auto iter_find = lower_bound(iter_last, products.end(), query);
            vector<string> selects;
            for (int i = 0; i < 3; ++i) {
                if (iter_find + i < products.end() && (*(iter_find + i)).find(query) == 0) {
                    selects.push_back(*(iter_find + i));
                }
            }
            ans.push_back(move(selects));
            iter_last = iter_find;
        }
        return ans;
    }
};
```

```Python [sol2]
class Solution:
    def suggestedProducts(self, products: List[str], searchWord: str) -> List[List[str]]:
        products.sort()
        query = ""
        iter_last = 0
        ans = list()
        for ch in searchWord:
            query += ch
            iter_find = bisect.bisect_left(products, query, iter_last)
            ans.append([s for s in products[iter_find : iter_find + 3] if s.startswith(query)])
            iter_last = iter_find
        return ans
```

**复杂度分析**

- 时间复杂度：$O\big((\sum L + S) * \log N\big)$，其中 $\sum L$ 是所有字符串的长度之和，$S$ 是字符串 `searchWord` 的长度，$N$ 是数组 `products` 的长度。对字符串进行排序的时间复杂度为 $O(\sum L * \log N)$，二分查找进行了 $L$ 次，每次查找的时间复杂度为 $\log N$。虽然方法二的时间复杂度高于方法一，但方法二的常数较小，因此实际运行速度要快于方法一。

- 空间复杂度：$O(\log N)$，为排序需要的空间复杂度。
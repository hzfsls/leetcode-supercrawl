## [387.字符串中的第一个唯一字符 中文官方题解](https://leetcode.cn/problems/first-unique-character-in-a-string/solutions/100000/zi-fu-chuan-zhong-de-di-yi-ge-wei-yi-zi-x9rok)

#### 方法一：使用哈希表存储频数

**思路与算法**

我们可以对字符串进行两次遍历。

在第一次遍历时，我们使用哈希映射统计出字符串中每个字符出现的次数。在第二次遍历时，我们只要遍历到了一个只出现一次的字符，那么就返回它的索引，否则在遍历结束后返回 $-1$。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    int firstUniqChar(string s) {
        unordered_map<int, int> frequency;
        for (char ch: s) {
            ++frequency[ch];
        }
        for (int i = 0; i < s.size(); ++i) {
            if (frequency[s[i]] == 1) {
                return i;
            }
        }
        return -1;
    }
};
```

```Java [sol1-Java]
class Solution {
    public int firstUniqChar(String s) {
        Map<Character, Integer> frequency = new HashMap<Character, Integer>();
        for (int i = 0; i < s.length(); ++i) {
            char ch = s.charAt(i);
            frequency.put(ch, frequency.getOrDefault(ch, 0) + 1);
        }
        for (int i = 0; i < s.length(); ++i) {
            if (frequency.get(s.charAt(i)) == 1) {
                return i;
            }
        }
        return -1;
    }
}
```

```Python [sol1-Python3]
class Solution:
    def firstUniqChar(self, s: str) -> int:
        frequency = collections.Counter(s)
        for i, ch in enumerate(s):
            if frequency[ch] == 1:
                return i
        return -1
```

```JavaScript [sol1-JavaScript]
var firstUniqChar = function(s) {
    const frequency = _.countBy(s);
    for (const [i, ch] of Array.from(s).entries()) {
        if (frequency[ch] === 1) {
            return i;
        }
    }
    return -1;
};
```

```Go [sol1-Golang]
func firstUniqChar(s string) int {
    cnt := [26]int{}
    for _, ch := range s {
        cnt[ch-'a']++
    }
    for i, ch := range s {
        if cnt[ch-'a'] == 1 {
            return i
        }
    }
    return -1
}
```

```C [sol1-C]
struct hashTable {
    int key;
    int val;
    UT_hash_handle hh;
};

int firstUniqChar(char* s) {
    struct hashTable* frequency = NULL;
    int n = strlen(s);
    for (int i = 0; i < n; i++) {
        int ikey = s[i];
        struct hashTable* tmp;
        HASH_FIND_INT(frequency, &ikey, tmp);
        if (tmp == NULL) {
            tmp = malloc(sizeof(struct hashTable));
            tmp->key = ikey;
            tmp->val = 1;
            HASH_ADD_INT(frequency, key, tmp);
        } else {
            tmp->val++;
        }
    }
    for (int i = 0; i < n; i++) {
        int ikey = s[i];
        struct hashTable* tmp;
        HASH_FIND_INT(frequency, &ikey, tmp);
        if (tmp != NULL && tmp->val == 1) {
            return i;
        }
    }
    return -1;
}
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 是字符串 $s$ 的长度。我们需要进行两次遍历。

- 空间复杂度：$O(|\Sigma|)$，其中 $\Sigma$ 是字符集，在本题中 $s$ 只包含小写字母，因此 $|\Sigma| \leq 26$。我们需要 $O(|\Sigma|)$ 的空间存储哈希映射。

#### 方法二：使用哈希表存储索引

**思路与算法**

我们可以对方法一进行修改，使得第二次遍历的对象从字符串变为哈希映射。

具体地，对于哈希映射中的每一个键值对，键表示一个字符，值表示它的首次出现的索引（如果该字符只出现一次）或者 $-1$（如果该字符出现多次）。当我们第一次遍历字符串时，设当前遍历到的字符为 $c$，如果 $c$ 不在哈希映射中，我们就将 $c$ 与它的索引作为一个键值对加入哈希映射中，否则我们将 $c$ 在哈希映射中对应的值修改为 $-1$。

在第一次遍历结束后，我们只需要再遍历一次哈希映射中的所有值，找出其中不为 $-1$ 的最小值，即为第一个不重复字符的索引。如果哈希映射中的所有值均为 $-1$，我们就返回 $-1$。

**代码**

```C++ [sol2-C++]
class Solution {
public:
    int firstUniqChar(string s) {
        unordered_map<int, int> position;
        int n = s.size();
        for (int i = 0; i < n; ++i) {
            if (position.count(s[i])) {
                position[s[i]] = -1;
            }
            else {
                position[s[i]] = i;
            }
        }
        int first = n;
        for (auto [_, pos]: position) {
            if (pos != -1 && pos < first) {
                first = pos;
            }
        }
        if (first == n) {
            first = -1;
        }
        return first;
    }
};
```

```Java [sol2-Java]
class Solution {
    public int firstUniqChar(String s) {
        Map<Character, Integer> position = new HashMap<Character, Integer>();
        int n = s.length();
        for (int i = 0; i < n; ++i) {
            char ch = s.charAt(i);
            if (position.containsKey(ch)) {
                position.put(ch, -1);
            } else {
                position.put(ch, i);
            }
        }
        int first = n;
        for (Map.Entry<Character, Integer> entry : position.entrySet()) {
            int pos = entry.getValue();
            if (pos != -1 && pos < first) {
                first = pos;
            }
        }
        if (first == n) {
            first = -1;
        }
        return first;
    }
}
```

```Python [sol2-Python3]
class Solution:
    def firstUniqChar(self, s: str) -> int:
        position = dict()
        n = len(s)
        for i, ch in enumerate(s):
            if ch in position:
                position[ch] = -1
            else:
                position[ch] = i
        first = n
        for pos in position.values():
            if pos != -1 and pos < first:
                first = pos
        if first == n:
            first = -1
        return first
```


```JavaScript [sol2-JavaScript]
var firstUniqChar = function(s) {
    const position = new Map();
    const n = s.length;
    for (let [i, ch] of Array.from(s).entries()) {
        if (position.has(ch)) {
            position.set(ch, -1);
        } else {
            position.set(ch, i);
        }
    }
    let first = n;
    for (let pos of position.values()) {
        if (pos !== -1 && pos < first) {
            first = pos;
        }
    }
    if (first === n) {
        first = -1;
    }
    return first;
};
```

```Go [sol2-Golang]
func firstUniqChar(s string) int {
    n := len(s)
    pos := [26]int{}
    for i := range pos[:] {
        pos[i] = n
    }
    for i, ch := range s {
        ch -= 'a'
        if pos[ch] == n {
            pos[ch] = i
        } else {
            pos[ch] = n + 1
        }
    }
    ans := n
    for _, p := range pos[:] {
        if p < ans {
            ans = p
        }
    }
    if ans < n {
        return ans
    }
    return -1
}
```

```C [sol2-C]
struct hashTable {
    int key;
    int val;
    UT_hash_handle hh;
};

int firstUniqChar(char* s) {
    struct hashTable* position = NULL;
    int n = strlen(s);
    for (int i = 0; i < n; ++i) {
        int ikey = s[i];
        struct hashTable* tmp;
        HASH_FIND_INT(position, &ikey, tmp);
        if (tmp != NULL) {
            tmp->val = -1;
        } else {
            tmp = malloc(sizeof(struct hashTable));
            tmp->key = ikey;
            tmp->val = i;
            HASH_ADD_INT(position, key, tmp);
        }
    }

    int first = n;
    struct hashTable *iter, *tmp;
    HASH_ITER(hh, position, iter, tmp) {
        int pos = iter->val;
        if (pos != -1 && pos < first) {
            first = pos;
        }
    }
    if (first == n) {
        first = -1;
    }
    return first;
}
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 是字符串 $s$ 的长度。第一次遍历字符串的时间复杂度为 $O(n)$，第二次遍历哈希映射的时间复杂度为 $O(|\Sigma|)$，由于 $s$ 包含的字符种类数一定小于 $s$ 的长度，因此 $O(|\Sigma|)$ 在渐进意义下小于 $O(n)$，可以忽略。

- 空间复杂度：$O(|\Sigma|)$，其中 $\Sigma$ 是字符集，在本题中 $s$ 只包含小写字母，因此 $|\Sigma| \leq 26$。我们需要 $O(|\Sigma|)$ 的空间存储哈希映射。

#### 方法三：队列

**思路与算法**

我们也可以借助队列找到第一个不重复的字符。队列具有「先进先出」的性质，因此很适合用来找出第一个满足某个条件的元素。

具体地，我们使用与方法二相同的哈希映射，并且使用一个额外的队列，按照顺序存储每一个字符以及它们第一次出现的位置。当我们对字符串进行遍历时，设当前遍历到的字符为 $c$，如果 $c$ 不在哈希映射中，我们就将 $c$ 与它的索引作为一个二元组放入队尾，否则我们就需要检查队列中的元素是否都满足「只出现一次」的要求，即我们不断地根据哈希映射中存储的值（是否为 $-1$）选择弹出队首的元素，直到队首元素「真的」只出现了一次或者队列为空。

在遍历完成后，如果队列为空，说明没有不重复的字符，返回 $-1$，否则队首的元素即为第一个不重复的字符以及其索引的二元组。

**小贴士**

在维护队列时，我们使用了「延迟删除」这一技巧。也就是说，即使队列中有一些字符出现了超过一次，但它只要不位于队首，那么就不会对答案造成影响，我们也就可以不用去删除它。只有当它前面的所有字符被移出队列，它成为队首时，我们才需要将它移除。

**代码**

```C++ [sol3-C++]
class Solution {
public:
    int firstUniqChar(string s) {
        unordered_map<char, int> position;
        queue<pair<char, int>> q;
        int n = s.size();
        for (int i = 0; i < n; ++i) {
            if (!position.count(s[i])) {
                position[s[i]] = i;
                q.emplace(s[i], i);
            }
            else {
                position[s[i]] = -1;
                while (!q.empty() && position[q.front().first] == -1) {
                    q.pop();
                }
            }
        }
        return q.empty() ? -1 : q.front().second;
    }
};
```

```Java [sol3-Java]
class Solution {
    public int firstUniqChar(String s) {
        Map<Character, Integer> position = new HashMap<Character, Integer>();
        Queue<Pair> queue = new LinkedList<Pair>();
        int n = s.length();
        for (int i = 0; i < n; ++i) {
            char ch = s.charAt(i);
            if (!position.containsKey(ch)) {
                position.put(ch, i);
                queue.offer(new Pair(ch, i));
            } else {
                position.put(ch, -1);
                while (!queue.isEmpty() && position.get(queue.peek().ch) == -1) {
                    queue.poll();
                }
            }
        }
        return queue.isEmpty() ? -1 : queue.poll().pos;
    }

    class Pair {
        char ch;
        int pos;

        Pair(char ch, int pos) {
            this.ch = ch;
            this.pos = pos;
        }
    }
}
```

```Python [sol3-Python3]
class Solution:
    def firstUniqChar(self, s: str) -> int:
        position = dict()
        q = collections.deque()
        n = len(s)
        for i, ch in enumerate(s):
            if ch not in position:
                position[ch] = i
                q.append((s[i], i))
            else:
                position[ch] = -1
                while q and position[q[0][0]] == -1:
                    q.popleft()
        return -1 if not q else q[0][1]
```

```JavaScript [sol3-JavaScript]
var firstUniqChar = function(s) {
    const position = new Map();
    const q = [];
    const n = s.length;
    for (let [i, ch] of Array.from(s).entries()) {
        if (!position.has(ch)) {
            position.set(ch, i);
            q.push([s[i], i]);
        } else {
            position.set(ch, -1);
            while (q.length && position.get(q[0][0]) === -1) {
                q.shift();
            }
        }
    }
    return q.length ? q[0][1] : -1;
};
```

```Go [sol3-Golang]
type pair struct {
    ch  byte
    pos int
}

func firstUniqChar(s string) int {
    n := len(s)
    pos := [26]int{}
    for i := range pos[:] {
        pos[i] = n
    }
    q := []pair{}
    for i := range s {
        ch := s[i] - 'a'
        if pos[ch] == n {
            pos[ch] = i
            q = append(q, pair{ch, i})
        } else {
            pos[ch] = n + 1
            for len(q) > 0 && pos[q[0].ch] == n+1 {
                q = q[1:]
            }
        }
    }
    if len(q) > 0 {
        return q[0].pos
    }
    return -1
}
```

```C [sol3-C]
struct hashTable {
    int key;
    int val;
    UT_hash_handle hh;
};

int firstUniqChar(char* s) {
    struct hashTable* position = NULL;
    int que[26][2], left = 0, right = 0;
    int n = strlen(s);
    for (int i = 0; i < n; ++i) {
        int ikey = s[i];
        struct hashTable* tmp;
        HASH_FIND_INT(position, &ikey, tmp);
        if (tmp == NULL) {
            tmp = malloc(sizeof(struct hashTable));
            tmp->key = ikey;
            tmp->val = i;
            HASH_ADD_INT(position, key, tmp);
            que[right][0] = ikey;
            que[right++][1] = i;
        } else {
            tmp->val = -1;
            while (left < right) {
                int ikey = que[left][0];
                struct hashTable* tmp;
                HASH_FIND_INT(position, &ikey, tmp);
                if (tmp == NULL || tmp->val != -1) {
                    break;
                }
                left++;
            }
        }
    }
    return left < right ? que[left][1] : -1;
}
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 是字符串 $s$ 的长度。遍历字符串的时间复杂度为 $O(n)$，而在遍历的过程中我们还维护了一个队列，由于每一个字符最多只会被放入和弹出队列最多各一次，因此维护队列的总时间复杂度为 $O(|\Sigma|)$，由于 $s$ 包含的字符种类数一定小于 $s$ 的长度，因此 $O(|\Sigma|)$ 在渐进意义下小于 $O(n)$，可以忽略。

- 空间复杂度：$O(|\Sigma|)$，其中 $\Sigma$ 是字符集，在本题中 $s$ 只包含小写字母，因此 $|\Sigma| \leq 26$。我们需要 $O(|\Sigma|)$ 的空间存储哈希映射以及队列。
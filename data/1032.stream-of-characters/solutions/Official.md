#### 方法一：AC 自动机

**思路**

这题需要用到 AC 自动机的数据结构，概念可以参照「[AC 自动机](https://oi-wiki.org/string/ac-automaton/)」。

首先需要将字符串数组 $\textit{words}$ 中的单词构建一棵字典树。字典树的节点 $\textit{TrieNode}$ 有三个元素：
1. $\textit{children}$，长度为 $26$ 的数组，元素均为 $\textit{TrieNode}$；
2. $\textit{isEnd}$，布尔值，表示当前节点是否为一个单词的结尾；
3. $\textit{fail}$，失配指针，后文会继续提到。

构建字典树的步骤比较常规，将 $\textit{word}$ 一一插入字典树，并给结尾节点的 $\textit{isEnd}$ 赋为 $\textit{true}$。这里需要记住的是，此时字典树中的每一个非空节点，都表示字符串数组 $\textit{words}$ 的某个前缀，且节点的深度就是该前缀的长度。

接下来需要更新每个非空节点的失配指针。失配指针的定义是，可以表示当前节点的最长后缀的节点，具体解释如下：当前节点能表示字符串数组 $\textit{words}$ 的某个前缀 $\textit{pre}_1$，我们需要找到字典树中的另一个节点，且该节点表示的前缀 $\textit{pre}_2$，是 $\textit{pre}_1$ 的一个后缀，并且是能在字典树中找到的最长的后缀。那么如何更新所有节点的失配指针呢？首先，特殊地，我们将根节点和所有根节点的非空子节点的失配指针指向根节点，然后思考如何计算其他非空节点的失配指针。

当我们要计算某个节点 $u$ 的失配指针时，假设所有比 $u$ 浅的节点的失配指针已经计算完毕，设 $u$ 的父节点为 $p$，节点 $p$ 依靠字符 $c$ 指向节点 $u$（即节点 $u$ 代表的前缀 $\textit{pre}_u$ 比节点 $p$ 代表的前缀 $\textit{pre}_p$ 多一个字符 $c$）。我们需要考察 $p.\textit{fail}$ 依靠字符 $c$ 指向的节点是否非空，如果非空，我们就找到 $u$ 的失配节点，如果为空，我们需要继续考察 $p.\textit{fail}.\textit{fail}$，直到在这条失配链上找到一个节点，它依靠字符 $c$ 指向的子节点非空；或者我们在失配链上不断考察的过程中，最终考察到了根节点，此时我们将 $u$ 的失配节点指向根节点。这样一来，我们可以根据广度优先搜索的过程，计算出所有非空节点的失配节点。

如此，我们就可以用这棵字典树来匹配后缀数据流了。初始化时，设置一个指针 $\textit{temp}$ 指向根节点，每接收一个字符 $c$，$\textit{temp}$ 先试图依靠字符 $c$ 移动到子节点，如果子节点为空，则在失配链上不停移动，直到找到一个节点，它依靠字符 $c$ 指向的子节点非空，这时该子节点表示的前缀，是可以匹配到的数据流里的最长后缀。注意此时，并不能立刻返回结果，需要遍历该子节点的失配链上的所有节点，如果有节点的 $\textit{isEnd}$ 值为 $\textit{true}$，则返回 $\textit{true}$，否则返回 $\textit{false}$。

注意到此时已经可以解决这道题了，但是计算每个节点的失配节点和单次 $\textit{query}$ 的时间复杂度仍然较大，最差情况下，需要遍历整条失配链路才能得到结果，因此，我们在广度优先搜索时引入以下两个优化：
1. 当节点 $p$ 的依靠字符 $c$ 指向的子节点 $u$ 为空时，将其指向 $p.\textit{fail}$ 依靠字符 $c$ 指向的子节点 $v$，这种类似于路径压缩的思路，使得每个空子节点最终都会指向一个非空节点，从而省去了在失配链路上不停考察的过程。
2. 广度优先搜索过程中，节点 $u$ 出队列时，将 $u.\textit{isEnd}$ 更新为 $u.\textit{isEnd} \| u.\textit{fail}.\textit{isEnd}$，这样每个节点的 $\textit{isEnd}$ 参数的定义就变为：当自己或者自己的某一后缀能匹配字符串数组的某个字符串时为 $\textit{true}$。这样一来，$\textit{query}$ 时也不需要遍历失配链路了。

**代码**

```Python [sol1-Python3]
class StreamChecker:

    def __init__(self, words: List[str]):
        self.root = TrieNode()
        for word in words:
            cur = self.root
            for char in word:
                idx = ord(char) - ord('a')
                if not cur.children[idx]:
                    cur.children[idx] = TrieNode()
                cur = cur.children[idx]
            cur.isEnd = True
        
        self.root.fail = self.root
        q = deque()
        for i in range(26):
            if self.root.children[i]:
                self.root.children[i].fail = self.root
                q.append(self.root.children[i])
            else:
                self.root.children[i] = self.root
        while q:
            node = q.popleft()
            node.isEnd = node.isEnd or node.fail.isEnd
            for i in range(26):
                if node.children[i]:
                    node.children[i].fail = node.fail.children[i]
                    q.append(node.children[i])
                else:
                    node.children[i] = node.fail.children[i]

        self.temp = self.root
            
    def query(self, letter: str) -> bool:
        self.temp = self.temp.children[ord(letter) - ord('a')]
        return self.temp.isEnd

class TrieNode:
    def __init__(self):
        self.children = [None] * 26
        self.isEnd = False
        self.fail = None
```

```Java [sol1-Java]
class StreamChecker {
    TrieNode root;
    TrieNode temp;

    public StreamChecker(String[] words) {
        root = new TrieNode();
        for (String word : words) {
            TrieNode cur = root;
            for (int i = 0; i < word.length(); i++) {
                int index = word.charAt(i) - 'a';
                if (cur.getChild(index) == null) {
                    cur.setChild(index, new TrieNode());
                }
                cur = cur.getChild(index);
            }
            cur.setIsEnd(true);
        }
        root.setFail(root);
        Queue<TrieNode> q = new LinkedList<>();
        for (int i = 0; i < 26; i++) {
            if(root.getChild(i) != null) {
                root.getChild(i).setFail(root);
                q.add(root.getChild(i));
            } else {
                root.setChild(i, root);
            }
        }
        while (!q.isEmpty()) {
            TrieNode node = q.poll();
            node.setIsEnd(node.getIsEnd() || node.getFail().getIsEnd());
            for (int i = 0; i < 26; i++) {
                if(node.getChild(i) != null) {
                    node.getChild(i).setFail(node.getFail().getChild(i));
                    q.offer(node.getChild(i));
                } else {
                    node.setChild(i, node.getFail().getChild(i));
                }
            }
        }

        temp = root;
    }

    public boolean query(char letter) {
        temp = temp.getChild(letter - 'a');
        return temp.getIsEnd();
    }
}

class TrieNode {
    TrieNode[] children;
    boolean isEnd;
    TrieNode fail;

    public TrieNode() {
        children = new TrieNode[26];
    }

    public TrieNode getChild(int index) {
        return children[index];
    }

    public void setChild(int index, TrieNode node) {
        children[index] = node;
    }

    public boolean getIsEnd() {
        return isEnd;
    }

    public void setIsEnd(boolean b) {
        isEnd = b;
    }

    public TrieNode getFail() {
        return fail;
    } 

    public void setFail(TrieNode node) {
        fail = node;
    } 
}
```

```C# [sol1-C#]
public class StreamChecker {

    TrieNode root;
    TrieNode temp;

    public StreamChecker(String[] words) {
        root = new TrieNode();
        foreach (String word in words) {
            TrieNode cur = root;
            foreach (char ch in word) {
                int index = ch - 'a';
                if (cur.getChild(index) == null) {
                    cur.setChild(index, new TrieNode());
                }
                cur = cur.getChild(index);
            }
            cur.setIsEnd(true);
        }
        root.setFail(root);
        Queue<TrieNode> q = new Queue<TrieNode>();
        for (int i = 0; i < 26; i++) {
            if(root.getChild(i) != null) {
                root.getChild(i).setFail(root);
                q.Enqueue(root.getChild(i));
            } else {
                root.setChild(i, root);
            }
        }
        while (q.Count > 0) {
            TrieNode node = q.Dequeue();
            node.setIsEnd(node.getIsEnd() || node.getFail().getIsEnd());
            for (int i = 0; i<26; i++) {
                if(node.getChild(i) != null) {
                    node.getChild(i).setFail(node.getFail().getChild(i));
                    q.Enqueue(node.getChild(i));
                } else {
                    node.setChild(i, node.getFail().getChild(i));
                }
            }
        }

        temp = root;
    }

    public bool Query(char letter) {
        temp = temp.getChild(letter - 'a');
        return temp.getIsEnd();
    }
}

class TrieNode {
    TrieNode[] children;
    bool isEnd;
    TrieNode fail;

    public TrieNode() {
        children = new TrieNode[26];
    }

    public TrieNode getChild(int index) {
        return children[index];
    }

    public void setChild(int index, TrieNode node) {
        children[index] = node;
    }

    public bool getIsEnd() {
        return isEnd;
    }

    public void setIsEnd(bool b) {
        isEnd = b;
    }

    public TrieNode getFail() {
        return fail;
    } 

    public void setFail(TrieNode node) {
        fail = node;
    } 
}
```

```C++ [sol1-C++]
typedef struct TrieNode {
    vector<TrieNode *> children;
    bool isEnd;
    TrieNode *fail;
    TrieNode() {
        this->children = vector<TrieNode *>(26, nullptr);
        this->isEnd = false;
        this->fail = nullptr;
    }
};

class StreamChecker {
public:
    TrieNode *root;
    TrieNode *temp;
    StreamChecker(vector<string>& words) {
        root = new TrieNode();
        for (string &word : words) {
            TrieNode *cur = root;
            for (int i = 0; i < word.size(); i++) {
                int index = word[i] - 'a';
                if (cur->children[index] == nullptr) {
                    cur->children[index] = new TrieNode();
                }
                cur = cur->children[index];
            }
            cur->isEnd = true;
        }
        root->fail = root;
        queue<TrieNode *> q;
        for (int i = 0; i < 26; i++) {
            if(root->children[i] != nullptr) {
                root->children[i]->fail = root;
                q.emplace(root->children[i]);
            } else {
                root->children[i] = root;
            }
        }
        while (!q.empty()) {
            TrieNode *node = q.front();
            q.pop();
            node->isEnd = node->isEnd || node->fail->isEnd;
            for (int i = 0; i < 26; i++) {
                if(node->children[i] != nullptr) {
                    node->children[i]->fail = node->fail->children[i];
                    q.emplace(node->children[i]);
                } else {
                    node->children[i] = node->fail->children[i];
                }
            }
        }

        temp = root;
    }
    
    bool query(char letter) {
        temp = temp->children[letter - 'a'];
        return temp->isEnd;
    }
};
```

```C [sol1-C]
#define MAX_QUEUE_SIZE 81920

typedef struct TrieNode {
    struct TrieNode *children[26];
    struct TrieNode *fail;
    bool isEnd;
} TrieNode;

typedef struct {
    TrieNode *root;
    TrieNode *temp;
} StreamChecker;

TrieNode* trieNodeCreate() {
    TrieNode *obj = (TrieNode *)malloc(sizeof(TrieNode));
    for (int i = 0; i < 26; i++) {
        obj->children[i] = NULL;
    }
    obj->isEnd = false;
    obj->fail = NULL;
    return obj;
}

void freeTrieNode(TrieNode* root) {
    for (int i = 0; i < 26; i++) {
        if (root->children[i]) {
            freeTrieNode(root->children[i]);
        }
    }
    free(root);
}

StreamChecker* streamCheckerCreate(char ** words, int wordsSize) {
    StreamChecker *obj = (StreamChecker *)malloc(sizeof(StreamChecker));
    obj->root = trieNodeCreate();
    obj->temp = obj->root;
    for (int i = 0; i < wordsSize; i++) {
        TrieNode *cur = obj->root;
        for (int j = 0; words[i][j] != '\0'; j++) {
            int index = words[i][j] - 'a';
            if (cur->children[index] == NULL) {
                cur->children[index] = trieNodeCreate();
            }
            cur = cur->children[index];
        }
        cur->isEnd = true;
    }
    obj->root->fail = obj->root;
    TrieNode *queue[MAX_QUEUE_SIZE];
    int head = 0;
    int tail = 0;
    for (int i = 0; i < 26; i++) {
        if(obj->root->children[i] != NULL) {
            obj->root->children[i]->fail = obj->root;
            queue[tail++] = obj->root->children[i];
        } else {
            obj->root->children[i] = obj->root;
        }
    }
    while (head != tail) {
        TrieNode *node = queue[head++];
        node->isEnd = node->isEnd || node->fail->isEnd;
        for (int i = 0; i < 26; i++) {
            if(node->children[i] != NULL) {
                node->children[i]->fail = node->fail->children[i];
                queue[tail++] = node->children[i];
            } else {
                node->children[i] = node->fail->children[i];
            }
        }
    }
    return obj;
}

bool streamCheckerQuery(StreamChecker* obj, char letter) {
    obj->temp = obj->temp->children[letter - 'a'];
    return obj->temp->isEnd;
}

void streamCheckerFree(StreamChecker* obj) {
    free(obj);
}
```

```JavaScript [sol1-JavaScript]
var StreamChecker = function(words) {
    const root = new TrieNode();
    for (const word of words) {
        let cur = root;
        for (let i = 0; i < word.length; i++) {
            const index = word[i].charCodeAt() - 'a'.charCodeAt();
            if (cur.getChild(index) === 0) {
                cur.setChild(index, new TrieNode());
            }
            cur = cur.getChild(index);
        }
        cur.setIsEnd(true);
    }
    root.setFail(root);
    const q = [];
    for (let i = 0; i < 26; i++) {
        if(root.getChild(i) != 0) {
            root.getChild(i).setFail(root);
            q.push(root.getChild(i));
        } else {
            root.setChild(i, root);
        }
    }
    while (q.length) {
        const node = q.shift();
        node.setIsEnd(node.getIsEnd() || node.getFail().getIsEnd());
        for (let i = 0; i < 26; i++) {
            if(node.getChild(i) != 0) {
                node.getChild(i).setFail(node.getFail().getChild(i));
                q.push(node.getChild(i));
            } else {
                node.setChild(i, node.getFail().getChild(i));
            }
        }
    }

    this.temp = root;
};

StreamChecker.prototype.query = function(letter) {
    this.temp = this.temp.getChild(letter.charCodeAt() - 'a'.charCodeAt());
    return this.temp.getIsEnd();
};

class TrieNode {
    constructor() {
        this.children = new Array(26).fill(0);
        this.isEnd = false;
        this.fail;
    }

    getChild(index) {
        return this.children[index];
    }

    setChild(index, node) {
        this.children[index] = node;
    }

    getIsEnd() {
        return this.isEnd;
    }

    setIsEnd(b) {
        this.isEnd = b;
    }

    getFail() {
        return this.fail;
    }

    setFail(node) {
        this.fail = node;
    }
}
```

**复杂度分析**

- 时间复杂度：$O(L+q)$，其中 $L$ 是字符串数组总的字符数，$q$ 是查询次数。构建字典树需要消耗 $O(L)$ 的时间，单次查询的时间复杂度为 $O(1)$。

- 空间复杂度：$O(L)$。构建字典树需要消耗 $O(L)$ 的空间。
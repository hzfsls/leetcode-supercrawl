## [382.链表随机节点 中文官方题解](https://leetcode.cn/problems/linked-list-random-node/solutions/100000/lian-biao-sui-ji-jie-dian-by-leetcode-so-x6it)
#### 方法一：记录所有链表元素

我们可以在初始化时，用一个数组记录链表中的所有元素，这样随机选择链表的一个节点，就变成在数组中随机选择一个元素。

```Python [sol1-Python3]
class Solution:
    def __init__(self, head: Optional[ListNode]):
        self.arr = []
        while head:
            self.arr.append(head.val)
            head = head.next

    def getRandom(self) -> int:
        return choice(self.arr)
```

```C++ [sol1-C++]
class Solution {
    vector<int> arr;

public:
    Solution(ListNode *head) {
        while (head) {
            arr.emplace_back(head->val);
            head = head->next;
        }
    }

    int getRandom() {
        return arr[rand() % arr.size()];
    }
};
```

```Java [sol1-Java]
class Solution {
    List<Integer> list;
    Random random;

    public Solution(ListNode head) {
        list = new ArrayList<Integer>();
        while (head != null) {
            list.add(head.val);
            head = head.next;
        }
        random = new Random();
    }

    public int getRandom() {
        return list.get(random.nextInt(list.size()));
    }
}
```

```C# [sol1-C#]
public class Solution {
    IList<int> list;
    Random random;

    public Solution(ListNode head) {
        list = new List<int>();
        while (head != null) {
            list.Add(head.val);
            head = head.next;
        }
        random = new Random();
    }

    public int GetRandom() {
        return list[random.Next(list.Count)];
    }
}
```

```go [sol1-Golang]
type Solution []int

func Constructor(head *ListNode) (s Solution) {
    for node := head; node != nil; node = node.Next {
        s = append(s, node.Val)
    }
    return s
}

func (s Solution) GetRandom() int {
    return s[rand.Intn(len(s))]
}
```

```C [sol1-C]
typedef struct {
    int * arr;
    int length;
} Solution;

Solution* solutionCreate(struct ListNode* head) {
    Solution * obj = (Solution *)malloc(sizeof(Solution));
    assert(obj != NULL);
    obj->length = 0;
    struct ListNode * node = head;

    while (node) {
        node = node->next;
        obj->length++;
    }
    obj->arr = (int *)malloc(sizeof(int) * obj->length);
    assert(obj->arr != NULL);
    node = head;
    for (int i = 0; i < obj->length; i++) {
        obj->arr[i] = node->val;
        node = node->next;
    }
    return obj;
}

int solutionGetRandom(Solution* obj) {
    return obj->arr[rand() % obj->length];
}

void solutionFree(Solution* obj) {
    free(obj->arr);
    free(obj);
}
```

```JavaScript [sol1-JavaScript]
var Solution = function(head) {
    this.list = [];
    while (head != null) {
        this.list.push(head.val);
        head = head.next;
    }
};

Solution.prototype.getRandom = function() {
    return this.list[Math.floor(Math.random() * this.list.length)];
};
```

**复杂度分析**

- 时间复杂度：初始化为 $O(n)$，随机选择为 $O(1)$，其中 $n$ 是链表的元素个数。

- 空间复杂度：$O(n)$。我们需要 $O(n)$ 的空间存储链表中的所有元素。

#### 方法二：水塘抽样

方法一需要花费 $O(n)$ 的空间存储链表中的所有元素，那么能否做到 $O(1)$ 的空间复杂度呢？

我们可以设计如下算法：

从链表头开始，遍历整个链表，对遍历到的第 $i$ 个节点，随机选择区间 $[0,i)$ 内的一个整数，如果其等于 $0$，则将答案置为该节点值，否则答案不变。

该算法会保证每个节点的值成为最后被返回的值的概率均为 $\dfrac{1}{n}$，证明如下：

$$
\begin{aligned} 
&P(第\ i\ 个节点的值成为最后被返回的值)\\
=&P(第\ i\ 次随机选择的值= 0) \times P(第\ i+1\ 次随机选择的值\ne 0) \times \cdots \times P(第\ n\ 次随机选择的值\ne 0)\\
=&\dfrac{1}{i} \times (1-\dfrac{1}{i+1}) \times \cdots \times (1-\dfrac{1}{n})\\
=&\dfrac{1}{i} \times \dfrac{i}{i+1} \times \cdots \times \dfrac{n-1}{n}\\
=&\dfrac{1}{n}
\end{aligned}
$$

```Python [sol2-Python3]
class Solution:
    def __init__(self, head: Optional[ListNode]):
        self.head = head

    def getRandom(self) -> int:
        node, i, ans = self.head, 1, 0
        while node:
            if randrange(i) == 0:  # 1/i 的概率选中（替换为答案）
                ans = node.val
            i += 1
            node = node.next
        return ans
```

```C++ [sol2-C++]
class Solution {
    ListNode *head;

public:
    Solution(ListNode *head) {
        this->head = head;
    }

    int getRandom() {
        int i = 1, ans = 0;
        for (auto node = head; node; node = node->next) {
            if (rand() % i == 0) { // 1/i 的概率选中（替换为答案）
                ans = node->val;
            }
            ++i;
        }
        return ans;
    }
};
```

```Java [sol2-Java]
class Solution {
    ListNode head;
    Random random;

    public Solution(ListNode head) {
        this.head = head;
        random = new Random();
    }

    public int getRandom() {
        int i = 1, ans = 0;
        for (ListNode node = head; node != null; node = node.next) {
            if (random.nextInt(i) == 0) { // 1/i 的概率选中（替换为答案）
                ans = node.val;
            }
            ++i;
        }
        return ans;
    }
}
```

```C# [sol2-C#]
public class Solution {
    ListNode head;
    Random random;

    public Solution(ListNode head) {
        this.head = head;
        random = new Random();
    }

    public int GetRandom() {
        int i = 1, ans = 0;
        for (ListNode node = head; node != null; node = node.next) {
            if (random.Next(i) == 0) { // 1/i 的概率选中（替换为答案）
                ans = node.val;
            }
            ++i;
        }
        return ans;
    }
}
```

```go [sol2-Golang]
type Solution struct {
    head *ListNode
}

func Constructor(head *ListNode) Solution {
    return Solution{head}
}

func (s *Solution) GetRandom() (ans int) {
    for node, i := s.head, 1; node != nil; node = node.Next {
        if rand.Intn(i) == 0 { // 1/i 的概率选中（替换为答案）
            ans = node.Val
        }
        i++
    }
    return
}
```

```C [sol2-C]
typedef struct {
    struct ListNode * head;
} Solution;


Solution* solutionCreate(struct ListNode* head) {
    Solution * obj = (Solution *)malloc(sizeof(Solution));
    assert(obj != NULL);
    obj->head = head;
    return obj;
}

int solutionGetRandom(Solution* obj) {
    int i = 1, ans = 0;
    for (struct ListNode * node = obj->head; node; node = node->next) {
        if (rand() % i == 0) { // 1/i 的概率选中（替换为答案）
            ans = node->val;
        }
        ++i;
    }
    return ans;
}

void solutionFree(Solution* obj) {
    free(obj);
}
```

```JavaScript [sol2-JavaScript]
var Solution = function(head) {
    this.head = head;
};

Solution.prototype.getRandom = function() {
    let i = 1, ans = 0;
    for (let node = this.head; node != null; node = node.next) {
        if (Math.floor(Math.random() * i) === 0) { // 1/i 的概率选中（替换为答案）
            ans = node.val;
        }
        ++i;
    }
    return ans;
};
```

**复杂度分析**

- 时间复杂度：初始化为 $O(1)$，随机选择为 $O(n)$，其中 $n$ 是链表的元素个数。

- 空间复杂度：$O(1)$。我们只需要常数的空间保存若干变量。
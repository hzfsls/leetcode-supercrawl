## [1019.链表中的下一个更大节点 中文官方题解](https://leetcode.cn/problems/next-greater-node-in-linked-list/solutions/100000/lian-biao-zhong-de-xia-yi-ge-geng-da-jie-u9yo)

#### 方法一：单调栈

**思路与算法**

找出「下一个更大的元素」是经典的可以用单调栈解决的问题。

我们对链表进行一次遍历，同时维护一个内部值单调递减（不是严格单调递减，可以相等）的栈。栈中的元素对应着**还没有找到下一个更大的元素**的那些元素，它们在栈中的顺序与它们在链表中出现的顺序一致。这也解释了为什么栈中的值是单调递减的：如果有两个元素不满足单调递减的限制，那么后一个元素大于前一个元素，与「还没有找到下一个更大的元素」相矛盾。

当我们遍历到链表中的值为 $\textit{val}$ 的节点时，只要它大于栈顶元素的值，我们就可以不断取出栈顶的节点，即栈顶节点的下一个更大的元素就是 $\textit{val}$。在这之后，我们再将 $\textit{val}$ 放入栈顶，为其在后续的遍历中找到它的下一个更大的元素，同时也保证了栈的单调性。

**细节**

当我们取出栈顶的元素时，我们是不知道它在链表中的位置的。因此在单调栈中，我们需要额外存储一个表示位置的变量。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    vector<int> nextLargerNodes(ListNode* head) {
        vector<int> ans;
        stack<pair<int, int>> s;

        ListNode* cur = head;
        int idx = -1;
        while (cur) {
            ++idx;
            ans.push_back(0);
            while (!s.empty() && s.top().first < cur->val) {
                ans[s.top().second] = cur->val;
                s.pop();
            }
            s.emplace(cur->val, idx);
            cur = cur->next;
        }

        return ans;
    }
};
```

```Java [sol1-Java]
class Solution {
    public int[] nextLargerNodes(ListNode head) {
        List<Integer> ans = new ArrayList<Integer>();
        Deque<int[]> stack = new ArrayDeque<int[]>();

        ListNode cur = head;
        int idx = -1;
        while (cur != null) {
            ++idx;
            ans.add(0);
            while (!stack.isEmpty() && stack.peek()[0] < cur.val) {
                ans.set(stack.pop()[1], cur.val);
            }
            stack.push(new int[]{cur.val, idx});
            cur = cur.next;
        }

        int size = ans.size();
        int[] arr = new int[size];
        for (int i = 0; i < size; ++i) {
            arr[i] = ans.get(i);
        }
        return arr;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int[] NextLargerNodes(ListNode head) {
        IList<int> ans = new List<int>();
        Stack<int[]> stack = new Stack<int[]>();

        ListNode cur = head;
        int idx = -1;
        while (cur != null) {
            ++idx;
            ans.Add(0);
            while (stack.Count > 0 && stack.Peek()[0] < cur.val) {
                ans[stack.Pop()[1]] = cur.val;
            }
            stack.Push(new int[]{cur.val, idx});
            cur = cur.next;
        }

        return ans.ToArray();
    }
}
```

```Python [sol1-Python3]
class Solution:
    def nextLargerNodes(self, head: Optional[ListNode]) -> List[int]:
        ans = list()
        s = list()

        cur = head
        idx = -1
        while cur:
            idx += 1
            ans.append(0)
            while s and s[-1][0] < cur.val:
                ans[s[-1][1]] = cur.val
                s.pop()
            s.append((cur.val, idx))
            cur = cur.next
        
        return ans
```

```C [sol1-C]
typedef struct Pair {
    int first;
    int second;
} Pair;

int* nextLargerNodes(struct ListNode* head, int* returnSize) {
    int len = 0;
    struct ListNode* cur = head;
    while (cur) {
        cur = cur->next;
        len++;
    }
    int* ans = (int *)calloc(len, sizeof(int));
    Pair stack[len];
    int top = 0, pos = 0;

    cur = head;
    int idx = -1;
    while (cur) {
        ++idx;
        ans[pos++] = 0;
        while (top > 0 && stack[top - 1].first < cur->val) {
            ans[stack[top - 1].second] = cur->val;
            top--;
        }
        stack[top].first = cur->val;
        stack[top].second = idx;
        top++;
        cur = cur->next;
    }
    *returnSize = len;
    return ans;
}
```

```go [sol1-Golang]
func nextLargerNodes(head *ListNode) []int {
    var ans []int
    var stack [][]int
    cur := head
    idx := -1
    for cur != nil {
        idx++
        ans = append(ans, 0)
        for len(stack) > 0 && stack[len(stack)-1][0] < cur.Val {
            top := stack[len(stack)-1]
            stack = stack[:len(stack)-1]
            ans[top[1]] = cur.Val
        }
        stack = append(stack, []int{cur.Val, idx})
        cur = cur.Next
    }
    return ans
}
```

```JavaScript [sol1-JavaScript]
var nextLargerNodes = function(head) {
    const ans = [];
    const stack = [];

    let cur = head;
    let idx = -1;
    while (cur) {
        ++idx;
        ans.push(0);
        while (stack.length && stack[stack.length - 1][0] < cur.val) {
            ans[stack.pop()[1]] = cur.val;
        }
        stack.push([cur.val, idx]);
        cur = cur.next;
    }

    const size = ans.length;
    const arr = new Array(size);
    for (let i = 0; i < size; ++i) {
        arr[i] = ans[i];
    }
    return arr;
};
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 是链表的长度。对链表进行遍历需要 $O(n)$ 的时间，链表中的每个元素恰好入栈一次，最多出栈一次，这一部分的时间也为 $O(n)$。

- 空间复杂度：$O(n)$，其中 $n$ 是链表的长度。即为单调栈需要的空间。
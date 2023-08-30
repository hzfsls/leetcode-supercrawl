#### 方法一：层次遍历

**思路与算法**

题目本身希望我们将二叉树的每一层节点都连接起来形成一个链表。因此直观的做法我们可以对二叉树进行层次遍历，在层次遍历的过程中将我们将二叉树每一层的节点拿出来遍历并连接。

层次遍历基于广度优先搜索，它与广度优先搜索的不同之处在于，广度优先搜索每次只会取出一个节点来拓展，而层次遍历会每次将队列中的所有元素都拿出来拓展，这样能保证每次从队列中拿出来遍历的元素都是属于同一层的，因此我们可以在遍历的过程中修改每个节点的 $\text{next}$ 指针，同时拓展下一层的新队列。

<![ppt1](https://assets.leetcode-cn.com/solution-static/116/p1.png),![ppt2](https://assets.leetcode-cn.com/solution-static/116/p2.png),![ppt3](https://assets.leetcode-cn.com/solution-static/116/p3.png),![ppt4](https://assets.leetcode-cn.com/solution-static/116/p4.png),![ppt5](https://assets.leetcode-cn.com/solution-static/116/p5.png),![ppt6](https://assets.leetcode-cn.com/solution-static/116/p6.png),![ppt7](https://assets.leetcode-cn.com/solution-static/116/p7.png),![ppt8](https://assets.leetcode-cn.com/solution-static/116/p8.png),![ppt9](https://assets.leetcode-cn.com/solution-static/116/p9.png),![ppt10](https://assets.leetcode-cn.com/solution-static/116/p10.png),![ppt11](https://assets.leetcode-cn.com/solution-static/116/p11.png),![ppt12](https://assets.leetcode-cn.com/solution-static/116/p12.png),![ppt13](https://assets.leetcode-cn.com/solution-static/116/p13.png),![ppt14](https://assets.leetcode-cn.com/solution-static/116/p14.png),![ppt15](https://assets.leetcode-cn.com/solution-static/116/p15.png)>

**代码**

```java [sol1-Java]
class Solution {
    public Node connect(Node root) {
        if (root == null) {
            return root;
        }
        
        // 初始化队列同时将第一层节点加入队列中，即根节点
        Queue<Node> queue = new LinkedList<Node>(); 
        queue.add(root);
        
        // 外层的 while 循环迭代的是层数
        while (!queue.isEmpty()) {
            
            // 记录当前队列大小
            int size = queue.size();
            
            // 遍历这一层的所有节点
            for (int i = 0; i < size; i++) {
                
                // 从队首取出元素
                Node node = queue.poll();
                
                // 连接
                if (i < size - 1) {
                    node.next = queue.peek();
                }
                
                // 拓展下一层节点
                if (node.left != null) {
                    queue.add(node.left);
                }
                if (node.right != null) {
                    queue.add(node.right);
                }
            }
        }
        
        // 返回根节点
        return root;
    }
}
```

```python [sol1-Python3]
import collections 

class Solution:
    def connect(self, root: 'Node') -> 'Node':
        
        if not root:
            return root
        
        # 初始化队列同时将第一层节点加入队列中，即根节点
        Q = collections.deque([root])
        
        # 外层的 while 循环迭代的是层数
        while Q:
            
            # 记录当前队列大小
            size = len(Q)
            
            # 遍历这一层的所有节点
            for i in range(size):
                
                # 从队首取出元素
                node = Q.popleft()
                
                # 连接
                if i < size - 1:
                    node.next = Q[0]
                
                # 拓展下一层节点
                if node.left:
                    Q.append(node.left)
                if node.right:
                    Q.append(node.right)
        
        # 返回根节点
        return root
```

```C++ [sol1-C++]
class Solution {
public:
    Node* connect(Node* root) {
        if (root == nullptr) {
            return root;
        }
        
        // 初始化队列同时将第一层节点加入队列中，即根节点
        queue<Node*> Q;
        Q.push(root);
        
        // 外层的 while 循环迭代的是层数
        while (!Q.empty()) {
            
            // 记录当前队列大小
            int size = Q.size();
            
            // 遍历这一层的所有节点
            for(int i = 0; i < size; i++) {
                
                // 从队首取出元素
                Node* node = Q.front();
                Q.pop();
                
                // 连接
                if (i < size - 1) {
                    node->next = Q.front();
                }
                
                // 拓展下一层节点
                if (node->left != nullptr) {
                    Q.push(node->left);
                }
                if (node->right != nullptr) {
                    Q.push(node->right);
                }
            }
        }
        
        // 返回根节点
        return root;
    }
};
```

```JavaScript [sol1-JavaScript]
var connect = function(root) {
    if (root === null) {
        return root;
    }
    
    // 初始化队列同时将第一层节点加入队列中，即根节点
    const Q = [root]; 
    
    // 外层的 while 循环迭代的是层数
    while (Q.length > 0) {
        
        // 记录当前队列大小
        const size = Q.length;
        
        // 遍历这一层的所有节点
        for(let i = 0; i < size; i++) {
            
            // 从队首取出元素
            const node = Q.shift();
            
            // 连接
            if (i < size - 1) {
                node.next = Q[0];
            }
            
            // 拓展下一层节点
            if (node.left !== null) {
                Q.push(node.left);
            }
            if (node.right !== null) {
                Q.push(node.right);
            }
        }
    }
    
    // 返回根节点
    return root;
};
```

```Golang [sol1-Golang]
func connect(root *Node) *Node {
    if root == nil {
        return root
    }

    // 初始化队列同时将第一层节点加入队列中，即根节点
    queue := []*Node{root}

    // 循环迭代的是层数
    for len(queue) > 0 {
        tmp := queue
        queue = nil

        // 遍历这一层的所有节点
        for i, node := range tmp {
            // 连接
            if i+1 < len(tmp) {
                node.Next = tmp[i+1]
            }

            // 拓展下一层节点
            if node.Left != nil {
                queue = append(queue, node.Left)
            }
            if node.Right != nil {
                queue = append(queue, node.Right)
            }
        }
    }

    // 返回根节点
    return root
}
```

```C [sol1-C]
struct Node* connect(struct Node* root) {
    if (root == NULL) {
        return root;
    }

    // 初始化队列同时将第一层节点加入队列中，即根节点
    struct Node* Q[5000];
    int left = 0, right = 0;
    Q[right++] = root;

    // 外层的 while 循环迭代的是层数
    while (left < right) {
        // 记录当前队列大小
        int size = right - left;

        // 遍历这一层的所有节点
        for (int i = 0; i < size; i++) {
            // 从队首取出元素
            struct Node* node = Q[left++];

            // 连接
            if (i < size - 1) {
                node->next = Q[left];
            }

            // 拓展下一层节点
            if (node->left != NULL) {
                Q[right++] = node->left;
            }
            if (node->right != NULL) {
                Q[right++] = node->right;
            }
        }
    }

    // 返回根节点
    return root;
}
```

**复杂度分析**

* 时间复杂度：$O(N)$。每个节点会被访问一次且只会被访问一次，即从队列中弹出，并建立 $\text{next}$ 指针。

* 空间复杂度：$O(N)$。这是一棵完美二叉树，它的最后一个层级包含 $N/2$ 个节点。广度优先遍历的复杂度取决于一个层级上的最大元素数量。这种情况下空间复杂度为 $O(N)$。


#### 方法二：使用已建立的 $\text{next}$ 指针

**思路**

一棵树中，存在两种类型的 $\text{next}$ 指针。

1. 第一种情况是连接同一个父节点的两个子节点。它们可以通过同一个节点直接访问到，因此执行下面操作即可完成连接。

    ```
    node.left.next = node.right
    ```

    ![fig1](https://assets.leetcode-cn.com/solution-static/116/1.png){:width=480}

2. 第二种情况在不同父亲的子节点之间建立连接，这种情况不能直接连接。

    ![fig2](https://assets.leetcode-cn.com/solution-static/116/2.png){:width=480}

    如果每个节点有指向父节点的指针，可以通过该指针找到 $\text{next}$ 节点。如果不存在该指针，则按照下面思路建立连接：

> 第 $N$ 层节点之间建立 $\text{next}$ 指针后，再建立第 $N+1$ 层节点的 $\text{next}$ 指针。可以通过 $\text{next}$ 指针访问同一层的所有节点，因此可以使用第 $N$ 层的 $\text{next}$ 指针，为第 $N+1$ 层节点建立 $\text{next}$ 指针。

**算法**

1. 从根节点开始，由于第 $0$ 层只有一个节点，所以不需要连接，直接为第 $1$ 层节点建立 $\text{next}$ 指针即可。该算法中需要注意的一点是，当我们为第 $N$ 层节点建立 $\text{next}$ 指针时，处于第 $N-1$ 层。当第 $N$ 层节点的 $\text{next}$ 指针全部建立完成后，移至第 $N$ 层，建立第 $N+1$ 层节点的 $\text{next}$ 指针。

2. 遍历某一层的节点时，这层节点的 $\text{next}$ 指针已经建立。因此我们只需要知道这一层的最左节点，就可以按照链表方式遍历，不需要使用队列。

3. 上面思路的伪代码如下：

    ```
    leftmost = root
    while (leftmost.left != null) {
        head = leftmost
        while (head.next != null) {
            1) Establish Connection 1
            2) Establish Connection 2 using next pointers
            head = head.next
        }
        leftmost = leftmost.left
    }
   ```

    ![fig3](https://assets.leetcode-cn.com/solution-static/116/3.png){:width=480}


4. 两种类型的 $\text{next}$ 指针。
   
    1. 第一种情况两个子节点属于同一个父节点，因此直接通过父节点建立两个子节点的 $\text{next}$ 指针即可。

        ```
        node.left.next = node.right
        ```

    ![fig4](https://assets.leetcode-cn.com/solution-static/116/4.png){:width=480}


    2. 第二种情况是连接不同父节点之间子节点的情况。更具体地说，连接的是第一个父节点的右孩子和第二父节点的左孩子。由于已经在父节点这一层建立了 $\text{next}$ 指针，因此可以直接通过第一个父节点的 $\text{next}$ 指针找到第二个父节点，然后在它们的孩子之间建立连接。

        ```
        node.right.next = node.next.left
        ```
        

    ![fig5](https://assets.leetcode-cn.com/solution-static/116/5.png){:width=480}

5. 完成当前层的连接后，进入下一层重复操作，直到所有的节点全部连接。进入下一层后需要更新最左节点，然后从新的最左节点开始遍历该层所有节点。因为是完美二叉树，因此最左节点一定是当前层最左节点的左孩子。如果当前最左节点的左孩子不存在，说明已经到达该树的最后一层，完成了所有节点的连接。

    ![fig6](https://assets.leetcode-cn.com/solution-static/116/6.png){:width=480}

**代码**

```java [sol2-Java]
class Solution {
    public Node connect(Node root) {
        if (root == null) {
            return root;
        }
        
        // 从根节点开始
        Node leftmost = root;
        
        while (leftmost.left != null) {
            
            // 遍历这一层节点组织成的链表，为下一层的节点更新 next 指针
            Node head = leftmost;
            
            while (head != null) {
                
                // CONNECTION 1
                head.left.next = head.right;
                
                // CONNECTION 2
                if (head.next != null) {
                    head.right.next = head.next.left;
                }
                
                // 指针向后移动
                head = head.next;
            }
            
            // 去下一层的最左的节点
            leftmost = leftmost.left;
        }
        
        return root;
    }
}
```

```python [sol2-Python3]
class Solution:
    def connect(self, root: 'Node') -> 'Node':
        
        if not root:
            return root
        
        # 从根节点开始
        leftmost = root
        
        while leftmost.left:
            
            # 遍历这一层节点组织成的链表，为下一层的节点更新 next 指针
            head = leftmost
            while head:
                
                # CONNECTION 1
                head.left.next = head.right
                
                # CONNECTION 2
                if head.next:
                    head.right.next = head.next.left
                
                # 指针向后移动
                head = head.next
            
            # 去下一层的最左的节点
            leftmost = leftmost.left
        
        return root 
```

```C++ [sol2-C++]
class Solution {
public:
    Node* connect(Node* root) {
        if (root == nullptr) {
            return root;
        }
        
        // 从根节点开始
        Node* leftmost = root;
        
        while (leftmost->left != nullptr) {
            
            // 遍历这一层节点组织成的链表，为下一层的节点更新 next 指针
            Node* head = leftmost;
            
            while (head != nullptr) {
                
                // CONNECTION 1
                head->left->next = head->right;
                
                // CONNECTION 2
                if (head->next != nullptr) {
                    head->right->next = head->next->left;
                }
                
                // 指针向后移动
                head = head->next;
            }
            
            // 去下一层的最左的节点
            leftmost = leftmost->left;
        }
        
        return root;
    }
};
```

```JavaScript [sol2-JavaScript]
var connect = function(root) {
    if (root === null) {
        return root;
    }
    
    // 从根节点开始
    let leftmost = root;
    
    while (leftmost.left !== null) {
        
        // 遍历这一层节点组织成的链表，为下一层的节点更新 next 指针
        let head = leftmost;
        
        while (head !== null) {
            
            // CONNECTION 1
            head.left.next = head.right;
            
            // CONNECTION 2
            if (head.next != null) {
                head.right.next = head.next.left;
            }
            
            // 指针向后移动
            head = head.next;
        }
        
        // 去下一层的最左的节点
        leftmost = leftmost.left;
    }
    
    return root;
};
```

```Golang [sol2-Golang]
func connect(root *Node) *Node {
    if root == nil {
        return root
    }

    // 每次循环从该层的最左侧节点开始
    for leftmost := root; leftmost.Left != nil; leftmost = leftmost.Left {
        // 通过 Next 遍历这一层节点，为下一层的节点更新 Next 指针
        for node := leftmost; node != nil; node = node.Next {
            // 左节点指向右节点
            node.Left.Next = node.Right

            // 右节点指向下一个左节点
            if node.Next != nil {
                node.Right.Next = node.Next.Left
            }
        }
    }

    // 返回根节点
    return root
}
```

```C [sol2-C]
struct Node* connect(struct Node* root) {
    if (root == NULL) {
        return root;
    }

    // 从根节点开始
    struct Node* leftmost = root;

    while (leftmost->left != NULL) {
        // 遍历这一层节点组织成的链表，为下一层的节点更新 next 指针
        struct Node* head = leftmost;

        while (head != NULL) {
            // CONNECTION 1
            head->left->next = head->right;

            // CONNECTION 2
            if (head->next != NULL) {
                head->right->next = head->next->left;
            }

            // 指针向后移动
            head = head->next;
        }

        // 去下一层的最左的节点
        leftmost = leftmost->left;
    }

    return root;
}
```

**复杂度分析**

* 时间复杂度：$O(N)$，每个节点只访问一次。 

* 空间复杂度：$O(1)$，不需要存储额外的节点。
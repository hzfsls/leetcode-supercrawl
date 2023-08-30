#### 方法一：深度优先搜索

使用深度优先搜索计算二叉树的层平均值，需要维护两个数组，$\textit{counts}$ 用于存储二叉树的每一层的节点数，$\textit{sums}$ 用于存储二叉树的每一层的节点值之和。搜索过程中需要记录当前节点所在层，如果访问到的节点在第 $i$ 层，则将 $\textit{counts}[i]$ 的值加 $1$，并将该节点的值加到 $\textit{sums}[i]$。

遍历结束之后，第 $i$ 层的平均值即为 $\textit{sums}[i] / \textit{counts}[i]$。

<![ppt1](https://assets.leetcode-cn.com/solution-static/637/1.png),![ppt2](https://assets.leetcode-cn.com/solution-static/637/2.png),![ppt3](https://assets.leetcode-cn.com/solution-static/637/3.png),![ppt4](https://assets.leetcode-cn.com/solution-static/637/4.png),![ppt5](https://assets.leetcode-cn.com/solution-static/637/5.png),![ppt6](https://assets.leetcode-cn.com/solution-static/637/6.png),![ppt7](https://assets.leetcode-cn.com/solution-static/637/7.png),![ppt8](https://assets.leetcode-cn.com/solution-static/637/8.png)>

```Java [sol1-Java]
class Solution {
    public List<Double> averageOfLevels(TreeNode root) {
        List<Integer> counts = new ArrayList<Integer>();
        List<Double> sums = new ArrayList<Double>();
        dfs(root, 0, counts, sums);
        List<Double> averages = new ArrayList<Double>();
        int size = sums.size();
        for (int i = 0; i < size; i++) {
            averages.add(sums.get(i) / counts.get(i));
        }
        return averages;
    }

    public void dfs(TreeNode root, int level, List<Integer> counts, List<Double> sums) {
        if (root == null) {
            return;
        }
        if (level < sums.size()) {
            sums.set(level, sums.get(level) + root.val);
            counts.set(level, counts.get(level) + 1);
        } else {
            sums.add(1.0 * root.val);
            counts.add(1);
        }
        dfs(root.left, level + 1, counts, sums);
        dfs(root.right, level + 1, counts, sums);
    }
}
```

```Golang [sol1-Golang]
type data struct{ sum, count int }

func averageOfLevels(root *TreeNode) []float64 {
    levelData := []data{}
    var dfs func(node *TreeNode, level int)
    dfs = func(node *TreeNode, level int) {
        if node == nil {
            return
        }
        if level < len(levelData) {
            levelData[level].sum += node.Val
            levelData[level].count++
        } else {
            levelData = append(levelData, data{node.Val, 1})
        }
        dfs(node.Left, level+1)
        dfs(node.Right, level+1)
    }
    dfs(root, 0)

    averages := make([]float64, len(levelData))
    for i, d := range levelData {
        averages[i] = float64(d.sum) / float64(d.count)
    }
    return averages
}
```

```C++ [sol1-C++]
class Solution {
public:
    vector<double> averageOfLevels(TreeNode* root) {
        auto counts = vector<int>();
        auto sums = vector<double>();
        dfs(root, 0, counts, sums);
        auto averages = vector<double>();
        int size = sums.size();
        for (int i = 0; i < size; i++) {
            averages.push_back(sums[i] / counts[i]);
        }
        return averages;
    }

    void dfs(TreeNode* root, int level, vector<int> &counts, vector<double> &sums) {
        if (root == nullptr) {
            return;
        }
        if (level < sums.size()) {
            sums[level] += root->val;
            counts[level] += 1;
        } else {
            sums.push_back(1.0 * root->val);
            counts.push_back(1);
        }
        dfs(root->left, level + 1, counts, sums);
        dfs(root->right, level + 1, counts, sums);
    }
};
```

```Python [sol1-Python3]
class Solution:
    def averageOfLevels(self, root: TreeNode) -> List[float]:
        def dfs(root: TreeNode, level: int):
            if not root:
                return
            if level < len(totals):
                totals[level] += root.val
                counts[level] += 1
            else:
                totals.append(root.val)
                counts.append(1)
            dfs(root.left, level + 1)
            dfs(root.right, level + 1)

        counts = list()
        totals = list()
        dfs(root, 0)
        return [total / count for total, count in zip(totals, counts)]
```

```C [sol1-C]
int countsSize;
int sumsSize;

void dfs(struct TreeNode* root, int level, int* counts, double* sums) {
    if (root == NULL) {
        return;
    }
    if (level < sumsSize) {
        sums[level] += root->val;
        counts[level] += 1;
    } else {
        sums[sumsSize++] = (double)root->val;
        counts[countsSize++] = 1;
    }
    dfs(root->left, level + 1, counts, sums);
    dfs(root->right, level + 1, counts, sums);
}

double* averageOfLevels(struct TreeNode* root, int* returnSize) {
    countsSize = sumsSize = 0;
    int* counts = malloc(sizeof(int) * 1001);
    double* sums = malloc(sizeof(double) * 1001);
    dfs(root, 0, counts, sums);
    double* averages = malloc(sizeof(double) * 1001);
    *returnSize = sumsSize;
    for (int i = 0; i < sumsSize; i++) {
        averages[i] = sums[i] / counts[i];
    }
    return averages;
}
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 是二叉树中的节点个数。
  深度优先搜索需要对每个节点访问一次，对于每个节点，维护两个数组的时间复杂度都是 $O(1)$，因此深度优先搜索的时间复杂度是 $O(n)$。
  遍历结束之后计算每层的平均值的时间复杂度是 $O(h)$，其中 $h$ 是二叉树的高度，任何情况下都满足 $h \le n$。
  因此总时间复杂度是 $O(n)$。

- 空间复杂度：$O(n)$，其中 $n$ 是二叉树中的节点个数。空间复杂度取决于两个数组的大小和递归调用的层数，两个数组的大小都等于二叉树的高度，递归调用的层数不会超过二叉树的高度，最坏情况下，二叉树的高度等于节点个数。

#### 方法二：广度优先搜索

也可以使用广度优先搜索计算二叉树的层平均值。从根节点开始搜索，每一轮遍历同一层的全部节点，计算该层的节点数以及该层的节点值之和，然后计算该层的平均值。

如何确保每一轮遍历的是同一层的全部节点呢？我们可以借鉴层次遍历的做法，广度优先搜索使用队列存储待访问节点，只要确保在每一轮遍历时，队列中的节点是同一层的全部节点即可。具体做法如下：

- 初始时，将根节点加入队列；

- 每一轮遍历时，将队列中的节点全部取出，计算这些节点的数量以及它们的节点值之和，并计算这些节点的平均值，然后将这些节点的全部非空子节点加入队列，重复上述操作直到队列为空，遍历结束。

由于初始时队列中只有根节点，满足队列中的节点是同一层的全部节点，每一轮遍历时都会将队列中的当前层节点全部取出，并将下一层的全部节点加入队列，因此可以确保每一轮遍历的是同一层的全部节点。

具体实现方面，可以在每一轮遍历之前获得队列中的节点数量 $\textit{size}$，遍历时只遍历 $\textit{size}$ 个节点，即可满足每一轮遍历的是同一层的全部节点。

<![fig1](https://assets.leetcode-cn.com/solution-static/637/2_1.png),![fig2](https://assets.leetcode-cn.com/solution-static/637/2_2.png),![fig3](https://assets.leetcode-cn.com/solution-static/637/2_3.png),![fig4](https://assets.leetcode-cn.com/solution-static/637/2_4.png),![fig5](https://assets.leetcode-cn.com/solution-static/637/2_5.png),![fig6](https://assets.leetcode-cn.com/solution-static/637/2_6.png),![fig7](https://assets.leetcode-cn.com/solution-static/637/2_7.png),![fig8](https://assets.leetcode-cn.com/solution-static/637/2_8.png),![fig9](https://assets.leetcode-cn.com/solution-static/637/2_9.png),![fig10](https://assets.leetcode-cn.com/solution-static/637/2_10.png),![fig11](https://assets.leetcode-cn.com/solution-static/637/2_11.png),![fig12](https://assets.leetcode-cn.com/solution-static/637/2_12.png),![fig13](https://assets.leetcode-cn.com/solution-static/637/2_13.png),![fig14](https://assets.leetcode-cn.com/solution-static/637/2_14.png)>

```Java [sol2-Java]
class Solution {
    public List<Double> averageOfLevels(TreeNode root) {
        List<Double> averages = new ArrayList<Double>();
        Queue<TreeNode> queue = new LinkedList<TreeNode>();
        queue.offer(root);
        while (!queue.isEmpty()) {
            double sum = 0;
            int size = queue.size();
            for (int i = 0; i < size; i++) {
                TreeNode node = queue.poll();
                sum += node.val;
                TreeNode left = node.left, right = node.right;
                if (left != null) {
                    queue.offer(left);
                }
                if (right != null) {
                    queue.offer(right);
                }
            }
            averages.add(sum / size);
        }
        return averages;
    }
}
```

```Golang [sol2-Golang]
func averageOfLevels(root *TreeNode) (averages []float64) {
    nextLevel := []*TreeNode{root}
    for len(nextLevel) > 0 {
        sum := 0
        curLevel := nextLevel
        nextLevel = nil
        for _, node := range curLevel {
            sum += node.Val
            if node.Left != nil {
                nextLevel = append(nextLevel, node.Left)
            }
            if node.Right != nil {
                nextLevel = append(nextLevel, node.Right)
            }
        }
        averages = append(averages, float64(sum)/float64(len(curLevel)))
    }
    return
}
```

```C++ [sol2-C++]
class Solution {
public:
    vector<double> averageOfLevels(TreeNode* root) {
        auto averages = vector<double>();
        auto q = queue<TreeNode*>();
        q.push(root);
        while (!q.empty()) {
            double sum = 0;
            int size = q.size();
            for (int i = 0; i < size; i++) {
                auto node = q.front();
                q.pop();
                sum += node->val;
                auto left = node->left, right = node->right;
                if (left != nullptr) {
                    q.push(left);
                }
                if (right != nullptr) {
                    q.push(right);
                }
            }
            averages.push_back(sum / size);
        }
        return averages;
    }
};
```

```Python [sol2-Python3]
class Solution:
    def averageOfLevels(self, root: TreeNode) -> List[float]:
        averages = list()
        queue = collections.deque([root])
        while queue:
            total = 0
            size = len(queue)
            for _ in range(size):
                node = queue.popleft()
                total += node.val
                left, right = node.left, node.right
                if left:
                    queue.append(left)
                if right:
                    queue.append(right)
            averages.append(total / size)
        return averages
```

```C [sol2-C]
double* averageOfLevels(struct TreeNode* root, int* returnSize) {
    double* averages = malloc(sizeof(double) * 1001);
    struct TreeNode** q = malloc(sizeof(struct TreeNode*) * 10001);
    *returnSize = 0;

    int qleft = 0, qright = 0;
    q[qright++] = root;
    while (qleft < qright) {
        double sum = 0;
        int size = qright - qleft;
        for (int i = 0; i < size; i++) {
            struct TreeNode* node = q[qleft++];
            sum += node->val;
            struct TreeNode *left = node->left, *right = node->right;
            if (left != NULL) {
                q[qright++] = left;
            }
            if (right != NULL) {
                q[qright++] = right;
            }
        }
        averages[(*returnSize)++] = sum / size;
    }
    return averages;
}
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 是二叉树中的节点个数。
  广度优先搜索需要对每个节点访问一次，时间复杂度是 $O(n)$。
  需要对二叉树的每一层计算平均值，时间复杂度是 $O(h)$，其中 $h$ 是二叉树的高度，任何情况下都满足 $h \le n$。
  因此总时间复杂度是 $O(n)$。

- 空间复杂度：$O(n)$，其中 $n$ 是二叉树中的节点个数。空间复杂度取决于队列开销，队列中的节点个数不会超过 $n$。
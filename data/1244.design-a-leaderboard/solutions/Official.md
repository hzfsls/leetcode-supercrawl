## [1244.力扣排行榜 中文官方题解](https://leetcode.cn/problems/design-a-leaderboard/solutions/100000/li-kou-pai-xing-bang-by-leetcode-solutio-kwv2)
[TOC]
---

#### 前言

 对于这个特定的问题，有很多实现方案。问题的陈述非常直接：

 1. 我们需要维护一个 `playerId` 到 `score` 的列表映射。
 2. 在需要的时候，获取最高的 `K` 个分数，加它们起来，然后返回。
 3. 最后，重置特定玩家的得分。

 我们将从最基本的，暴力查找的实现开始，然后逐步过渡到稍微复杂一些的实现。为了理解这些复杂的实现方法，我们需要看一看这个问题的基本需求。
 > 我们有一个动态更新的值列表，并需要能够从该列表中提取前 k 个元素。

 每当我们有这样的问题陈述，要求我们从一个动态更新的列表中获取 `top-K` 的值，依赖于一个 **优先队列** 似乎是个不错的选择。`堆`是处理这种需求的最好的数据结构之一。所以，我们将看看使用堆数据结构的解决方案。
 此外，我们也将看一看 `二叉搜索树` 的解决方案。虽然堆是一种很好的数据结构，可以找到 `top-K` 的元素，而不需要实际排序列表，但它对 `查找和更新` 的操作效率不高。堆数据结构的经验之谈是，使用 `懒更新`，而不是遍历和更新条目。在这里，使用懒更新并不能得到确定的性能，因为我们不知道 `更新` 操作的数量，因此，如果我们有数百万个得分更新和没有 `top-K` 的函数调用（或者比例较小），堆的大小可能会持续增长。

---

 #### 方法 1：暴力法

 暴力法解决这个问题很简单，我们将维护一个字典，其中 `playerId` 为键， `score` 为值。然后，对于每个 `top` 操作，我们将从字典中获取所有的值，对它们进行排序，然后获取前 `K` 个元素。  

 **算法步骤**

 1. 初始化一个字典 `scores` ，其中 `playerId` 作为键， `score` 作为值
 2. *addScore* ~  
    - 直接用新的分数更新该玩家的字典。 
    - 如果玩家不存在，初始化得分为 `score`。
 3. *top* ~  
    - 从字典中获取所有值的列表。  
    - 将列表以 `reverse` 的顺序排序。
    - 将排序后的列表的前 `K` 个值相加。
 4. *reset* ~
    - 删除含有 `playerId` 的条目。
    - 我们也可以将值（得分）设为 `0`。这样做的唯一缺点是我们将在 `top` 函数中对 `reset` 的玩家进行排序。不过对于小的测试用例，这不太重要。

 **实现**

 ```Java [slu1]
 class Leaderboard {

    private HashMap<Integer, Integer> scores;
    
    public Leaderboard() {
      
        // 因为这是个单线程程序，我们不需要并发访问，
        // HashMap 比起 Hashtable 是一个更好的数据结构的选择。在这里阅读更多：
        // https://stackoverflow.com/questions/40471/what-are-the-differences-between-a-hashmap-and-a-hashtable-in-java 
        this.scores = new HashMap<Integer, Integer>();
    }
    
    public void addScore(int playerId, int score) {
        
        if (!this.scores.containsKey(playerId)) {
            this.scores.put(playerId, 0);
        }
        
        this.scores.put(playerId, this.scores.get(playerId) + score);
    }
    
    public int top(int K) {
        
        List<Integer> values = new ArrayList<Integer>(this.scores.values());
        Collections.sort(values, Collections.reverseOrder());
        
        int total = 0;
        for (int i = 0; i < K; i++) {
            total += values.get(i);            
        }
        
        return total;
    }
    
    public void reset(int playerId) {
        this.scores.put(playerId, 0);
    }
}
 ```

 ```Python3 [slu1]
 class Leaderboard:

    def __init__(self):
        self.scores = defaultdict()

    def addScore(self, playerId: int, score: int) -> None:
        if playerId not in self.scores:
            self.scores[playerId] = 0
        self.scores[playerId] += score

    def top(self, K: int) -> int:
        values = [v for _, v in sorted(self.scores.items(), key=lambda item: item[1])]
        values.sort(reverse=True)
        total, i = 0, 0
        while i < K:
            total += values[i]
            i += 1
        
        return total

    def reset(self, playerId: int) -> None:
        self.scores[playerId] = 0
 ```

 **复杂性分析**

 * 时间复杂度：
    - `addScore` 的时间复杂度为 $O(1)$。
    - `reset` 的时间复杂度为 $O(1)$。
    - `top` 的时间复杂度为 $O(N \text{log}N)$，其中 $N$ 是所有玩家的总数，因为我们需要对所有玩家的得分进行排序，然后再从排序后的列表中取前 `K` 个。
 * 空间复杂度：
    - 空间复杂度为 $O(N)$，`scores` 字典占用了空间，`top` 函数中使用字典值形成的新列表也占用了空间。

---

 #### 方法 2：使用堆找到 top-K

 这是对上一种方法的稍微修改，而不是对 `values` 列表进行排序，我们将使用 `最小堆` 来找到 `top-K` 的值。这是上一种实现的稍微改变的版本。
 **算法**
 1. 初始化一个字典 `scores` ，其中 `playerId` 作为键， `score` 作为值 
 2. *addScore* ~  
    - 直接用新的分数更新该玩家的字典。
    - 如果玩家不存在，初始化得分为 `score`。 
 3. *top* ~  
    - 初始化一个新的最小堆， `scoreHeap`。
    - 遍历字典中的前 `K` 个值，并将它们添加到堆中。
    - 然后，对于剩下的 $N-K$ 个值，我们只需执行以下操作。我们将新值添加到堆中，并从堆中弹出最小值。这样做，我们可以保持堆的大小为 `K`，并移出两个值中较小的那个。
    - 我们对所有的 $N-K$ 个值都这么做，然后简单地把堆中剩下的所有值加起来，因为它们就是剩下的最大 `K` 个值。
 4. *reset* ~
    - 删除含有 `playerId` 的条目。  
    - 我们也可以将值（得分）设为 `0`。这样做的唯一缺点是我们将在 `top` 函数中对 `reset` 的玩家进行排序。不过对于小的测试用例，这不太重要。

 **实现**

 ```Java [slu2]
 class Leaderboard {

    private HashMap<Integer, Integer> scores;
    
    public Leaderboard() {
        this.scores = new HashMap<Integer, Integer>();
    }
    
    public void addScore(int playerId, int score) {
        
        if (!this.scores.containsKey(playerId)) {
            this.scores.put(playerId, 0);
        }
        
        this.scores.put(playerId, this.scores.get(playerId) + score);
    }
    
    public int top(int K) {
        
        // Java 中包含 hash map 条目的最小堆。
        // 请注意，我们必须提供自己的比较器，以确保获得这些对象的排序权限。
        PriorityQueue<Map.Entry<Integer, Integer>> heap = new PriorityQueue<>((a, b) -> a.getValue() - b.getValue());
        
        for (Map.Entry<Integer, Integer> entry : this.scores.entrySet()) {
            heap.offer(entry);
            if (heap.size() > K) {
                heap.poll();
            }
        }
        
        int total = 0;
        Iterator value = heap.iterator();
        while (value.hasNext()) { 
            total += ((Map.Entry<Integer, Integer>)value.next()).getValue();   
        }
        
        return total;
    }
    
    public void reset(int playerId) {
        this.scores.put(playerId, 0);
    }
}
 ```

 ```Python3 [slu2]
 class Leaderboard:

    def __init__(self):
        self.scores = {}

    def addScore(self, playerId: int, score: int) -> None:
        if playerId not in self.scores:
            self.scores[playerId] = 0
        self.scores[playerId] += score

    def top(self, K: int) -> int:
    
        # 这是 Python 中默认的小顶堆。
        heap = []
        for x in self.scores.values():
            heapq.heappush(heap, x)
            if len(heap) > K:
                heapq.heappop(heap)
        res = 0
        while heap:
            res += heapq.heappop(heap)
        return res

    def reset(self, playerId: int) -> None:
        self.scores[playerId] = 0
 ```

 **复杂性分析**

 * 时间复杂度：  
    - `addScore` 的时间复杂度为 $O(1)$。
    - `reset` 的时间复杂度为 $O(1)$。
    - 时间复杂度为 $O(K) + O(N \text{log}K)$ = $O(N \text{log}K)$。它需要 $O(K)$ 的时间来构造初始的堆，然后对剩下的 $N-K$ 个元素，我们在堆上执行 `extractMin` 和 `add` 操作，每个操作需要 $(\text{log}K)$ 的时间。
 * 空间复杂度：
    - 空间复杂度为 $O(N + K)$，其中 $O(N)$ 由 `scores` 字典使用， $O(K)$ 由堆使用。

---

 #### 方法 3：使用 TreeMap / SortedMap  

 在这里我们会尝试在 `addScore` 函数的时间复杂度增加的情况下提高 `top` 函数的整体的时间复杂度。如前所述，堆并没有任何增加搜索性能的属性。归根结底，堆只是具有一些特性的元素列表。然而，这些特性并不能提高数据结构的整体可搜索性。我们确实可以做一些优化，如在字典中保留对堆中每一个节点的引用，然后使用这些引用进行更新。然而，我们将看一看利用平衡二叉搜索树的 TreeMap 数据结构（java）。  
 我们使用平衡 BST 获得的最大优势是，搜索/添加/移除操作的时间复杂度都被限制在以树中元素数量为底的对数复杂度内。这是由于树的结构以及树的子树与根之间的关系。
 **算法**

1. 初始化一个字典 `scores` ，其中 `playerId` 作为键， `score` 作为值。 
2. 初始化一个 TreeMap （Java）或者 SortedMap (Python) 叫做 `sortedScoreMap`。这个映射的结构是，键是得分，值是拥有该得分的玩家数量。想象被表示为一个平衡的二叉树，其中键被用来对树进行排列。我们需要 `top` 函数来使用 *scores* ，因此我们将它们作为键。
3. *addScore* ~  
   - 注意玩家的旧得分。我们称之为 `oldScore`。
   - 更新 `sortedScoreMap` TreeMap 中的 `oldScore` 的值。如果值已经变成 `0`，则删除该得分条目。
   - 直接用新的分数更新该玩家的字典。
   - 通过将值增加1来将更新的值添加到 `sortedScoreMap` 中，即再有一个玩家拥有这个得分。
   - 如果玩家不存在，初始化得分为 `score`。 
4. *top* ~  
   - 遍历 `sortedScoreMap` 中的所有键。注意，由于数据结构是一个 BST，对键的中序遍历会按照排序顺序返回它们。我们不需要再对它们排序。因此，我们只是简单地遍历这些键，然后挑选出前 `K` 个。此外，我们已经将树排列成每个得分映射到具有该得分的玩家数量。所以树中没有重复的元素。
   - 挑选出前 `K` 个条目，即前 `K` 个值。
     - 我们对每个键，将 `(key * value)` 加到总和中。  
     - 同时，也将计数到 `K` 的计数器减去 `value`。
5. *reset* ~  
   - 注意玩家的旧得分。我们称之为 `oldScore`。
   - 更新 `sortedScoreMap` TreeMap 中的 `oldScore` 的值。如果值已经变成 `0`则删除该得分条目。
   - 删除含有 `playerId` 的条目。

**实现**
 注意，我们在 Python 中使用的是 `SortedDict`。这是一个外部的，获取 Apache 许可的包，是 Leetcode 平台支持的。你可以在 [这里](http://www.grantjenks.com/docs/sortedcontainers/implementation.html) 读到更多关于它的信息。我们在 Python 中没有办法构造一个反向的 SortedDict，因此我们在添加它们到字典（类似 TreeMap 的数据结构）之前，将分数变为负数，这样正常的中序遍历就会给我们以降序排列的分数。

 ```Java [slu3]
 class Leaderboard {

    Map<Integer, Integer> scores;
    TreeMap<Integer, Integer> sortedScores;
    
    public Leaderboard() {
        this.scores = new HashMap<Integer, Integer>();
        this.sortedScores = new TreeMap<>(Collections.reverseOrder());
    }
    
    public void addScore(int playerId, int score) {
        
        // 分数字典只包含从 playerID 到它们的分数的映射。
        // SortedScores 包含一个 BST，
        // 其中 key 作为比分，value 作为拥有该比分的球员的数量。
        if (!this.scores.containsKey(playerId)) {
            this.scores.put(playerId, score);
            this.sortedScores.put(score, this.sortedScores.getOrDefault(score, 0) + 1);
        } else {
            
            // 由于当前球员的分数正在更改，
            // 我们需要更新 sortedScores 映射以减少旧分数的计数。
            int preScore = this.scores.get(playerId);
            int playerCount = this.sortedScores.get(preScore);
            
            
            // 如果没有玩家拥有此分数，则将其从树中移除。
            if (playerCount == 1) {
                this.sortedScores.remove(preScore);
            } else {
                this.sortedScores.put(preScore, playerCount - 1);
            }
            
            // 更新分数
            int newScore = preScore + score;
            this.scores.put(playerId, newScore);
            this.sortedScores.put(newScore, this.sortedScores.getOrDefault(newScore, 0) + 1);
        }
    }
    
    public int top(int K) {
        
        int count = 0;
        int sum = 0;
        
        // 按顺序遍历 TreeMap 中的分数
        for (Map.Entry<Integer, Integer> entry: this.sortedScores.entrySet()) {
            
            // 拥有此分数的玩家的数量。
            int times = entry.getValue();
            int key = entry.getKey();
            
            for (int i = 0; i < times; i++) {
                sum += key;
                count++;
                
                // 找到 top-K分数，break。
                if (count == K) {
                    break;
                }
            }
            
            // 找到 top-K分数，break。
            if (count == K) {
                break;
            }
        }
        
        return sum;
    }
    
    public void reset(int playerId) {
        int preScore = this.scores.get(playerId);
        this.sortedScores.put(preScore, this.sortedScores.get(preScore) - 1);
        if (this.sortedScores.get(preScore) == 0) {
            this.sortedScores.remove(preScore);
        }
        
        this.scores.remove(playerId);
    }
}
 ```

 ```Python3 [slu3]
 from sortedcontainers import SortedDict

class Leaderboard:

    def __init__(self):
        self.scores = {}
        self.sortedScores = SortedDict()

    def addScore(self, playerId: int, score: int) -> None:

        # 分数字典只包含从 playerID 到它们的分数的映射。
        # sortedScores 包含一个 BST，
        # 其中 key 作为比分，value 作为拥有该比分的球员的数量。
        if playerId not in self.scores:
            self.scores[playerId] = score
            self.sortedScores[-score] = self.sortedScores.get(-score, 0) + 1
        else:
            preScore = self.scores[playerId]
            val = self.sortedScores.get(-preScore)
            if val == 1:
                del self.sortedScores[-preScore]
            else:
                self.sortedScores[-preScore] = val - 1    
            
            newScore = preScore + score;
            self.scores[playerId] = newScore
            self.sortedScores[-newScore] = self.sortedScores.get(-newScore, 0) + 1
        
    def top(self, K: int) -> int:
        count, total = 0, 0;

        for key, value in self.sortedScores.items():
            times = self.sortedScores.get(key)
            for _ in range(times): 
                total += -key;
                count += 1;
                
                # 找到 top-K分数，break。
                if count == K:
                    break;
                
            # 找到 top-K分数，break。
            if count == K:
                break;
        
        return total;

    def reset(self, playerId: int) -> None:
        preScore = self.scores[playerId]
        if self.sortedScores[-preScore] == 1:
            del self.sortedScores[-preScore]
        else:
            self.sortedScores[-preScore] -= 1
        del self.scores[playerId];
 ```

 **复杂性分析**

 * 时间复杂度：
    - `addScore` 的时间复杂度为 $O(\text{log}N)$。这是由于每次向 BST 中添加元素都需要对数复杂度的时间进行搜索。一旦知道父节点的位置，添加本身就需要常数时间。
    - `reset` 的时间复杂度为 $O(\text{log}N)$，因为我们需要在 BST 中搜索得分，然后更新/删除它。注意，这个复杂度是在每个玩家总是保持唯一得分的情况下的。
    - `top` 函数需要 $O(K)$ 的时间，因为我们只是简单地遍历 TreeMap 的键，然后完成 `K` 个得分的考虑。注意，如果数据结构没有提供自然的迭代器，那么我们就可以简单地得到所有的键值对列表，由于这个数据结构的性质，它们将自然地被排序。在这种情况下，复杂度将是 $O(N)$，因为我们将形成一个新的列表。
 * 空间复杂度：
    - `scores` 字典使用了 $O(N)$ 的空间。此外，如果你在 `top` 函数中获取所有的键值对并放在一个新的列表中，那么还会使用额外的 $O(N)$ 的空间。
## [277.搜寻名人 中文官方题解](https://leetcode.cn/problems/find-the-celebrity/solutions/100000/sou-xun-ming-ren-by-leetcode-solution-jvsz)
[TOC] 

 ## 解决方案

---

 #### 方法 1：暴力解法 

 **简述** 

 根据题目描述，对于给定的人  `i` ，我们可以检查是否 `i` 是名人，通过使用 `knows(...)` API查看是否每个人都知道  `i` ，以及 `i` 是否不认识任何人。 

 因此，解决这个问题的最简单方法是轮流检查每个人是否是名人。 

 **算法** 

 最好定义一个单独的 `isCelebrity(...)` 函数，该函数接受特定人的id号，如果他们是名人则返回  `true` ，如果不是则返回  `false` 。这就避免了复杂的循环跳出条件，从而使代码更清晰。 

 我们需要小心的一个边缘情况是不要询问人 `i` 他们是否认识自己。这可以通过在 `isCelebrity(...)` 的主循环开始时检查 `i == j`，然后当它为 `true` 时直接 `continue` 来处理。 

 ```Java [slu1]
 public class Solution extends Relation {
    
    private int numberOfPeople;
    
    public int findCelebrity(int n) {
        numberOfPeople = n;
        for (int i = 0; i < n; i++) {
            if (isCelebrity(i)) {
                return i;
            }
        }
        return -1;
    }
    
    private boolean isCelebrity(int i) {
        for (int j = 0; j < numberOfPeople; j++) {
            if (i == j) continue; // 他们认识自己就不用询问。
            if (knows(i, j) || !knows(j, i)) {
                return false;
            }
        }
        return true;
    }
}
 ```

 ```Python [slu1]
 class Solution:
    def findCelebrity(self, n: int) -> int:
        self.n = n
        for i in range(n):
            if self.is_celebrity(i):
                return i
        return -1
    
    def is_celebrity(self, i):
        for j in range(self.n):
            if i == j: continue # 他们认识自己就不用询问。
            if knows(i, j) or not knows(j, i):
                return False
        return True
 ```

 ```JavaScript [slu1]
 function solution(knows) {
    function isCelebrity(i, n) {
        for (let j = 0; j < n; j++) {
            if (i === j) continue;
            if (knows(i, j) || !knows(j, i)) {
                return false;
            }
        }
        return true;
    }

    return function findCelebrity(n) {
        for (let i = 0; i < n; i++) {
            if (isCelebrity(i, n)) {
                return i;
            }
        }
        return -1;
    }
}
 ```

 **复杂度分析** 

 我们不关心且不知道 `knows(...)` API 使用的时间和空间，所以我们假设它是 $O(1)$ 来分析我们的算法。 

 - 时间复杂度：$O(n^2)$。

    对于每个人，我们需要检查他们是否是名人。 

    检查某人是否是名人需要对其他的 $n - 1$ 人进行 $2$ 次 API 调用，总共需要 $2 \cdot (n - 1) = 2 \cdot n - 2$ 次调用。在大 o 记法中，我们放弃常数，留下 $O(n)$。 

    所以每个人的 $n$ 名人检查将花费 $O(n)$，总共为 $O(n^2)$。 


 - 空间复杂度：$O(1)$。 

    我们的代码只使用常数的额外空间。API 调用的结果没有保存。 

 <br /> 

---

 #### 方法 2：逻辑推理 

 **简述** 

 我们可以做得比上面的方法好得多。让我们从另一种表示问题的方式开始，这是在面试中处理它的好方法。我们在这个问题中实际上拥有的是一个**图**，其中*有向边*从人 `A` 指向人 `B` 意味着我们已经确认了 `A` 认识  `B` 。 
 比如说，这里是一个可能的图。假设我们已经调用了所有可能的 `knows(...)` API 来找到这些边。这里有名人吗？如果有，是谁？ 

 ![image.png](https://pic.leetcode.cn/1691742577-HsOymB-image.png){:width=700}

 这个图呢？ 

 ![image.png](https://pic.leetcode.cn/1691742799-dkVijF-image.png){:width=700}

 还有这个？ 

 ![image.png](https://pic.leetcode.cn/1691742801-KAHbPn-image.png){:width=700}

 在图的表示上，名人是一个有*恰好* `n - 1` 个入方向的边（每个人都认识他们）和 `0` 个出方向的边（他们不认识任何人）的人。 

 在我们上面看过的第一个示例中，人 `4` 是名人，因为他们有 `5` 个入方向的边，也就是 `n - 1`。他们没有出方向的边。注意， `3` *不是名人*，因为他们有 `5` 个*出方向*的边，而不是 `5` 个入方向。 

 在第二个示例中，没有名人。人 `4` 不是名人，因为人 `2` 不认识他们。只有 `n - 2` 个有向边指向 `4` 。 

 在第三个示例中，也没有名人。人 `0` 不是名人，因为他们认识人 `5` ，由 `0` 到 `5` 的有向边表示了这一点。 

 在开始时，我们只知道图的*节点*。所有的*边*都是隐藏的。我们可以通过调用 `knows(...)` API 来""揭示""*边*。在第一个方法中，我们以这种方式揭示了*所有*的边。所以，我们现在需要问的问题是...揭示*所有*的边实际上是否有必要？在面试中回答这个问题的一个好方法是在白板上操作一个示例，你决定你想问哪些边，然后在进行中画出它们。 

 当你做你自己的示例时，你当然需要知道你的示例背后的完整图，或者至少是它的重要方面，但你也需要关注你通过使用 `knows(...)` API “揭示”的信息。 

 这是一个示例的动画。为了区分 `not (A knows B)` 和我们还没有询问 `A knows B` ，我们使用绿色的实箭头表示 `A knows B` ，红色的虚箭头表示 `not (A knows B)` ，如果我们还没有询问，则没有箭头。 

 <![image.png](https://pic.leetcode.cn/1691744055-WWCbkQ-image.png){:width=400},![image.png](https://pic.leetcode.cn/1691744058-oMpCEV-image.png){:width=400},![image.png](https://pic.leetcode.cn/1691744060-HYuJSQ-image.png){:width=400},![image.png](https://pic.leetcode.cn/1691744062-qypyZa-image.png){:width=400},![image.png](https://pic.leetcode.cn/1691744064-XpGjIu-image.png){:width=400},![image.png](https://pic.leetcode.cn/1691744066-JygoJF-image.png){:width=400},![image.png](https://pic.leetcode.cn/1691744068-KMBfUo-image.png){:width=400},![image.png](https://pic.leetcode.cn/1691744071-dIUHbR-image.png){:width=400}>

 在动画示例中，我们问了 `4` 是否认识 `6` 。为什么这个问题对于识别名人来说是不必要的？ 

 ![image.png](https://pic.leetcode.cn/1691744068-KMBfUo-image.png){:width=400}

 嗯，因为我们已经知道 `4` 和 `6` 都至少认识一个其他的人，这意味着他们都不能是名人！因此，我们已经将他们排除在外，没有必要进一步调查他们。 

 那么，我们能从 `A knows B` 检查的结果中得出什么结论呢？如果结果是 `true` ， `A` 能否成为名人？ `B` 呢？ 

 ![image.png](https://pic.leetcode.cn/1691744113-HUEqMy-image.png){:width=400}

 那么如果`A knows B`返回 `false` 呢？谁不能成为名人？ 

 ![image.png](https://pic.leetcode.cn/1691743954-eLjtFa-image.png){:width=400}

 在第一个示例中，我们知道 `A` 不能成为名人，因为 `A` 认识某个人，即 `B` 。在第二个示例中，我们知道 `B` 不能成为名人，因为 `A` 不认识他/她。 

 > 因此，每次调用`knows(...)`，我们都可以确定地知道恰好**1**个人不是名人！ 

 因此，以下算法可以在 $O(n)$ 的时间内排除 `n - 1` 个人。我们从假设 `0` 可能是 `celebrityCandidate` 开始，然后检查 `0 knows 1`（在循环中）。如果为 `true` ，那么我们知道 `0` 不是名人（他们认识某人），但 `1` 可能是。我们更新 `celebrityCandidate` 变量为 `1` 来反映这一点。否则，我们知道 `1` 不是名人（某人不认识他们），但我们还没有排除 `0` ，所以保持他们作为 `celebrityCandidate` 。然后问我们保留的人他们是否认识 `2` ，等等。 

```
  celebrity_candidate = 0 
  for i in range(1, n):  
    if knows(celebrity_candidate, i):  
        celebrity_candidate = i 
```

 最后，我们还未排除的只有 `celebrityCandidate` 变量中的人。 

 这是算法的动画。 

 <![image.png](https://pic.leetcode.cn/1691749173-xMGOJh-image.png){:width=400},![image.png](https://pic.leetcode.cn/1691749176-JwndLg-image.png){:width=400},![image.png](https://pic.leetcode.cn/1691749178-DjjIzs-image.png){:width=400},![image.png](https://pic.leetcode.cn/1691749180-cumPGx-image.png){:width=400},![image.png](https://pic.leetcode.cn/1691749182-cerHTD-image.png){:width=400},![image.png](https://pic.leetcode.cn/1691749184-JOMYug-image.png){:width=400},![image.png](https://pic.leetcode.cn/1691749186-jzOpli-image.png){:width=400},![image.png](https://pic.leetcode.cn/1691749189-mzJljN-image.png){:width=400},![image.png](https://pic.leetcode.cn/1691749191-ATqGWq-image.png){:width=400},![image.png](https://pic.leetcode.cn/1691749194-PrUpkc-image.png){:width=400},![image.png](https://pic.leetcode.cn/1691749196-UBjiJw-image.png){:width=400},![image.png](https://pic.leetcode.cn/1691749199-aAdvEZ-image.png){:width=400},![image.png](https://pic.leetcode.cn/1691749201-efqIgu-image.png){:width=400},![image.png](https://pic.leetcode.cn/1691749203-ZTFgrr-image.png){:width=400},![image.png](https://pic.leetcode.cn/1691749206-najRVa-image.png){:width=400}>


 在动画中的示例结束后，我们的图看起来像这样。我们还没有排除的人是 `4` 。 

 ![image.png](https://pic.leetcode.cn/1691749346-TQCpds-image.png){:width=400}

 但是我们是否确实知道这个人一定是名人？（记住，也有可能没有名人，在这种情况下我们返回 `-1`）。 

 不是！我们仍然可能不知道 `0` 是否认识 `4` ，或者可能 `4` 认识 `3` 。从我们到目前为止所揭示的信息中，我们不能排除这些可能性。 

 那么，我们能做什么呢？我们可以使用`isCelebrity(...)`函数对 `4` 进行检查，看看他们是否是名人。如果是，我们的函数将返回 `4` 。如果不是，那么它应该返回 `-1`。 

 **算法步骤** 

 我们的算法首先使用上述算法将人数减少到一个 `celebrityCandidate` ，然后使用 `isCelebrity(...)` 检查该候选人是否真的是名人。 

 ```Java [slu2]
 public class Solution extends Relation {
    
    private int numberOfPeople;
    
    public int findCelebrity(int n) {
        numberOfPeople = n;
        int celebrityCandidate = 0;
        for (int i = 0; i < n; i++) {
            if (knows(celebrityCandidate, i)) {
                celebrityCandidate = i;
            }
        }
        if (isCelebrity(celebrityCandidate)) {
            return celebrityCandidate;
        }
        return -1;
    }
    
    private boolean isCelebrity(int i) {
        for (int j = 0; j < numberOfPeople; j++) {
            if (i == j) continue; // 他们认识自己就不用询问。
            if (knows(i, j) || !knows(j, i)) {
                return false;
            }
        }
        return true;
    }
}
 ```

 ```Python [slu2]
 class Solution:
    def findCelebrity(self, n: int) -> int:
        self.n = n
        celebrity_candidate = 0
        for i in range(1, n):
            if knows(celebrity_candidate, i):
                celebrity_candidate = i
        if self.is_celebrity(celebrity_candidate):
            return celebrity_candidate
        return -1

    def is_celebrity(self, i):
        for j in range(self.n):
            if i == j: continue
            if knows(i, j) or not knows(j, i):
                return False
        return True
 ```

 ```JavaScript [slu2]
 function solution(knows) {
    function isCelebrity(i, n) {
        for (let j = 0; j < n; j++) {
            if (i === j) continue;
            if (knows(i, j) || !knows(j, i)) {
                return false;
            }
        }
        return true;
    }

    return function findCelebrity(n) {
        let celebrityCandidate = 0;
        for (let i = 0; i < n; i++) {
            if (knows(celebrityCandidate, i)) {
                celebrityCandidate = i;
            }
        }
        if (isCelebrity(celebrityCandidate, n)) {
            return celebrityCandidate;
        }
        return -1;
    }
}
 ```

 **复杂度分析** 

 - 时间复杂度：$O(n)$。
    我们的代码分为两部分。 

    第一部分找到了名人候选人。这需要调用 $n - 1$ 次 `knows(...)` API，所以是 $O(n)$。 

    第二部分与之前相同——检查给定的人是否是名人。我们确定这是 $O(n)$。 

    因此，我们的总时间复杂度是 $O(n + n) = O(n)$。 

 - 空间复杂度：$O(1)$。 

    同上。我们只使用常数的额外空间。 

 <br /> 

---

 #### 方法 3：使用缓存的逻辑推理 

 **简述** 

 *你可能不需要在面试中实现这种方法，但是，如果这些想法是后续问题的讨论我不会感到惊讶。因此，我们将快速查看它！* 

 再看一下我们上面的示例。这是我们用于确定 `4` 是名人候选人的 `knows(...)` API 的调用。 

 ![image.png](https://pic.leetcode.cn/1691749346-TQCpds-image.png){:width=400}

 现在，这些是我们的方法二在第二阶段会做的调用，以检查我们的名人候选人 `4` 是否真的是名人。 

 ![image.png](https://pic.leetcode.cn/1691749513-QfSGSD-image.png){:width=400}

 如上图所示，我们做了一些相同的调用两次！名人候选人的编号越低，这些重复的调用就越多，因为名人候选人在 `celebrityCandidate` 变量中待的时间更长，因此参与了更多的初始""问询""。这实际上是浪费吗？ 

 我们知道我们在平均/最坏情况下可能达到的最佳可能的时间复杂度是 $O(n)$。证明这一点的最简单方法就是指出确认某人*是*名人需要 $O(n)$ 的检查。这是毫无疑问的，如果你只是错过了其中一个检查，它本来可能已经显示他们*不是*。 

 那么，因为我们永远不能做得优于 $O(n)$，所以这竟然真的不重要吗？ 

 是也不是！可能对 `knows(...)` API 的调用可能是*非常消耗资源*（即慢）。例如，对于题目中提出的情况，你需要向人们提问，然后听他们的回答。这太耗时了！如果 `knows(...)` API 是从世界另一端的一个非常慢的网络服务中获取答案呢？如果有人必须坐在电脑前，耐心地等待这个算法完成运行呢？他们肯定会更喜欢它花费 5 秒钟而不是 10 秒钟，尽管这个差异是常数。 

 然而，这样做的代价是空间。我们现在需要存储 `n - 1` 次对于 `knows(...)` API 的调用的结果。 

 这类似于网络浏览器缓存数据的方式。通常，重新检索页面的成本被认为比缓存页面的成本更高。 

 **算法** 

 对于 Java 和 JavaScript，我们将在 `HashMap` 中存储我们的缓存。对于 Python，我们将在 `functools` 库中使用 `lru_cache` 。除此之外，代码像这样

 ```Java [slu3]
 public class Solution extends Relation {
    
    private int numberOfPeople;
    private Map<Pair<Integer, Integer>, Boolean> cache = new HashMap<>(); 
    
    @Override
    public boolean knows(int a, int b) {
        if (!cache.containsKey(new Pair(a, b))) {
            cache.put(new Pair(a, b), super.knows(a, b));
        }
        return cache.get(new Pair(a, b));
    }
    
    public int findCelebrity(int n) {
        numberOfPeople = n;
        int celebrityCandidate = 0;
        for (int i = 0; i < n; i++) {
            if (knows(celebrityCandidate, i)) {
                celebrityCandidate = i;
            }
        }
        if (isCelebrity(celebrityCandidate)) {
            return celebrityCandidate;
        }
        return -1;
    }
    
    private boolean isCelebrity(int i) {
        for (int j = 0; j < numberOfPeople; j++) {
            if (i == j) continue; // 他们认识自己就不用询问。
            if (knows(i, j) || !knows(j, i)) {
                return false;
            }
        }
        return true;
    }
}
 ```

```Python [slu3]
from functools import lru_cache

class Solution:
    
    @lru_cache(maxsize=None)
    def cachedKnows(self, a, b):
        return knows(a, b)
    
    def findCelebrity(self, n: int) -> int:
        self.n = n
        celebrity_candidate = 0
        for i in range(1, n):
            if self.cachedKnows(celebrity_candidate, i):
                celebrity_candidate = i
        if self.is_celebrity(celebrity_candidate):
            return celebrity_candidate
        return -1

    def is_celebrity(self, i):
        for j in range(self.n):
            if i == j: continue
            if self.cachedKnows(i, j) or not self.cachedKnows(j, i):
                return False
        return True
```

```JavaScript [slu3]
function cached(f) {
    const cache = new Map();
    return function(...args) {
        const cacheKey = args.join(',');
        if (!cache.has(cacheKey)) {
            const value = f(...args);
            cache.set(cacheKey, value);
        }

        return cache.get(cacheKey);
    }
}

function solution(knows) {
    knows = cached(knows);

    function isCelebrity(i, n) {
        for (let j = 0; j < n; j++) {
            if (i === j) continue;
            if (knows(i, j) || !knows(j, i)) {
                return false;
            }
        }
        return true;
    }

    return function findCelebrity(n) {
        let celebrityCandidate = 0;
        for (let i = 0; i < n; i++) {
            if (knows(celebrityCandidate, i)) {
                celebrityCandidate = i;
            }
        }
        if (isCelebrity(celebrityCandidate, n)) {
            return celebrityCandidate;
        }
        return -1;
    }
}
```

 **复杂度分析** 

 - 时间复杂度：$O(n)$。 

    时间复杂度仍然是 $O(n)$。 唯一的区别是有时我们从我们代码中的缓存中获取数据，而不是从 API 中获取。 

 - 空间复杂度：$O(n)$。 

    我们存储了我们在寻找候选人时做的 $n - 1$ 次 `know(...)` API 的结果。 

    我们可以通过每次 `celebrityCandidate` 变量发生变化时都丢弃缓存中的内容稍微优化空间复杂度，这在最好的情况下（也就是减少 API 调用的最坏情况）是 $O(1)$，但是在最坏的情况下仍然是 $O(n)$，并且由于算法仍然需要最坏情况所需要的内存/磁盘空间，所以可能不值得增加额外的代码复杂度。 

  </br>
[TOC]

## 解决方案

---

 #### 概述

 谁不怀念著名的“贪吃蛇”游戏呢？它曾经是（现在仍是）我们许多人在手机和其他平台上首选的视频游戏，这个问题谈到的版本是最基本的一个。而这是一个设计问题，使得事情变得更加有趣！
 让我们再回顾一下问题描述。

* 给出了蛇在其上移动的网格的 `width` 和 `height`。
* 此外，我们还被给出了食物会按顺序出现的网格位置列表。就像传统的蛇一样，下一个食物只会在消耗当前的一个之后出现。
* 消费一块食物会使蛇的长度增加一个单位。在我们的问题描述中，蛇的长度每消费一个食物就会增加一个 `cell`，每个格子的长度和宽度为一个单位。
* 蛇可以向 `U`、`D`、`L` 和 `R` 四个方向移动。每次需要移动蛇时，都会调用 `move()` 函数，而这就是我们在这个问题中需要关注的唯一函数。
* 游戏结束的情况有：
  * 蛇变得过长，有可能无法装进网格，或者
  * 蛇碰到边界，这种情况也可能发生在前一种情况中，或者
  * 蛇咬到自己，即当蛇的头在下一步移动中与蛇的身体相撞。

问题描述并没有任何后续语句，但我们将讨论这个问题的一个后续问题，即墙变得 `无穷` 大，也就是说，蛇可以穿过墙，唯一结束游戏的条件就是 `蛇` 在网格上撞到自己。

 ![img1.png](https://pic.leetcode.cn/1692178755-gTXfCV-img1.png){:width=400}

---

 #### 方法：队列和哈希集

 **概述**

 让我们从思考如何存储蛇开始？

 >在面对网格来说，一条蛇只是一个 **_有序_** 的格子集合。

 我们在理论上可以使用数组来存储表示蛇的格子。然而，我们需要实例化一个大小为 `width * height` 的网格，因为在最坏的情况下，蛇可以由所有的网格格子组成。一个螺旋状的蛇。让我们看看这样一条蛇如何占据网格。

 ![img2.png](https://pic.leetcode.cn/1692178755-HaWTzP-img2.png){:width=400}

 这种结构不太可能出现，因为食物在网格上的出现具有随机性。然而，我们需要一个与网格大小相同的数组来装下这样大的蛇。对于数组的破局之处是，当我们要将蛇从一处转移到另一处时。让我们看看当蛇向一个方向移动时，发生了什么。无论如何，结果大体上将是相同的，只是根据方向有一些小的变化。

 ![img3.png](https://pic.leetcode.cn/1692178755-uDdxuV-img3.png){:width=400}

 在上图中，我们有一条占据4个网格格子的蛇，或者说，长度为4。蛇可以由以下集合的格子表示：`[(1,1), (1,2), (1,3), (2,3)]`。假设我们让蛇向右移动，也就是 `R`。那么，蛇在网格上看起来就像这样。

 ![img4.png](https://pic.leetcode.cn/1692178755-bglTNQ-img4.png){:width=400}

 在这里，移动一步到右边之后，蛇用格子 `[(1,2), (1,3), (2,3), (2,4)]` 来表示。

 >为了用数组实现这个，我们需要移动所有的格子，这并不是非常理想。我们可以构建一些关于蛇在数组中移动的复杂逻辑，但是这并不值得拥有数组的固定空间复杂度。

 让我们看看什么样的数据结构最适合我们的需求。我们需要满足的两个基本需求是：

 1. 动态地向蛇的身体添加新的格子，并且 
 2. 在常量时间内移动网格上的蛇。

 让我们看一下从上面的例子中，去理解蛇在移动之间的表示是什么，这将帮助我们找到解决这个问题的数据结构。
 **没有食物的移动**

 我们已经有了这样的一个例子，所以我们将简单地观察网格上的蛇表示以理解这究竟是怎么回事。
 在移动之前，蛇以指定的顺序占据了网格的以下位置：
 ```(1,1), (1,2), (1,3), (2,3)```
 移动之后，蛇占据了网格的以下位置：
 ```(1,2), (1,3), (2,3), (2,4)```
 如果你从一个 **_滑动窗口_** 的视角看待这一点，我们简单地将窗口向前移动了一步，也就是说，我们移除了 **_尾部_**，并添加了一个新的 **_头部_** 到窗口。在这种情况下，尾部是 `(1,2)`，而新的头部是 `(2,4)`。
 **有食物消费的移动**

 现在让我们看看一种蛇在移动中消费了食物，并且增长长度的情况。假设移动和之前的一样，并且位置 `(2,4)` 包含了一块食物。在上一个例子中，蛇的头在网格上的位置是 `(2,3)`。所以，向右移动会使得其消耗这块食物，因此总长度增加了1。所以现在，蛇不再占据网格的 4 个格子，而是 5 个。让我们具体看一下在移动之前和之后的蛇表示。
 在移动之前，蛇以指定的顺序占据了网格的以下位置：
 ```(1,1), (1,2), (1,3), (2,3)```
 移动之后，蛇占据了网格的以下位置：
 ```(1,1), (1,2), (1,3), (2,3), (2,4)```
 在这种情况下，我们只是为蛇添加了一个新的 **_头_**，而头是格子 `(2,4)`。在这种情况下，尾巴保持不变。除了游戏结束的情况外，这些就是可能发生的移动情况。基于它们，让我们看看我们的数据结构需要具体支持哪些操作。
 我们的抽象数据结构需要支持以下操作。

 1. 动态地增长长度。注意到，我们从不 **_收缩_** 长度。蛇可以保持原来的长度，或者因为在网格上消费了食物而增长长度。但它们不能收缩长度。
 2. 保持格子的特定顺序，用以表示蛇。
 3. 提取尾部的格子，可能为顺序的格子添加一个新的头部，以表示更新后的蛇。这是所有操作中最重要的一个，且这种操作指向了一个非常具体的数据结构。

 >基于第三种操作，我们可以看到 **_队列_** 将会是一个好的数据结构，因为我们需要快速访问一个有序列表的第一个和最后一个元素，而队列提供了我们确切地需要这一点。

 队列是一个具有某些特定属性的抽象数据结构，它满足我们的需求。它可以用数组或链表来表示。对于我们的目的，因为我们需要一个动态大小的数据结构，我们将会选择使用链表基于的队列实现，而不选择数组，因为我们不希望为数组预先分配任何内存，只希望在运行时分配。链表在这里将会是一个很好的选择，因为我们不需要对蛇的格子有随机访问。

 **代码实现**

 1. 初始化一个队列，包含一个单一的格子 `(0,0)`，这是游戏开始时的初始位置。注意我们将会在类的构造器中进行这个操作，而不是在 `move` 函数中。
 2. 在 `move` 函数中我们需要做的第一件事是，基于移动的方向计算新的 **_头_**。如我们在直观理解的部分中所见，无论移动的类型如何，我们总是会获得一个新的头。我们需要新的头的位置以决定蛇是否已经撞到了边界，并因此结束游戏。
 3. 在我们在讨论如何修改队列之前，先讨论一下游戏的结束条件。
    1. 第一种条件是如果蛇在移动后越过了任何一边的边界，则我们结束一切。所以对于这个，我们需要简单地检查新的头 (`new_head`) 是否满足`new_head[0] < 0` 或 `new_head[0] > height` 或 `new_head[1] < 0` 或 `new_head[1] > width`。
    2. 第二种条件是如果蛇在移动后咬到自己。这里的重要一点是当前的蛇`尾巴`并 **_不_** 是蛇身体的一部分。如果这不是移动食物，那么尾巴将会在更新 (被移除) ，正如我们所看到的。如果这是一个食物移动，那么蛇将不能咬到自己，因为食物不能出现在任何被蛇占据的格子上 (根据问题描述)。

    为了检查蛇是否咬到自己，我们需要检查新的头是否已经存在于我们的队列中。这可能是一个 $\mathcal{O}(N)$ 的操作，并且这将会耗费大量的资源。所以，以损耗内存为代价，我们也可以使用额外的字典数据结构来保存蛇的位置。这个字典将会仅仅用于这种特定的检查。我们不能只用一个字典，因为字典没有元素的有序列表，我们需要这个顺序来实现我们的方法。 
 4. 如果都没有满足结束条件，则我们将会继续使用我们的新的头来更新队列，并可能移除旧的尾巴。如果新的头着陆在一个包含食物的位置，则我们简单地将新的头添加到代表蛇的队列中。在这种情况下，我们不会弹出尾巴，因为蛇的长度增加了1。 
 5. 在每个移动之后，如果这是一个有效的移动，我们返回蛇的长度。否则，我们返回 `-1` 来表示游戏已经结束。

 ```Java [slu1]
 class SnakeGame {

HashMap<Pair<Integer, Integer>, Boolean> snakeMap;
Deque<Pair<Integer, Integer>> snake;
int[][] food;
int foodIndex;
int width;
int height;

/**
 * 在这里初始化你的数据结构。
 *
 * @param width - 屏幕宽度
 * @param height - 屏幕高度
 * @param food - 食物位置列表 E.g food = [[1,1], [1,0]] 意味着第一个食物在
 *     [1,1]，第二个在 [1,0]。
 */
public SnakeGame(int width, int height, int[][] food) {
    this.width = width;
    this.height = height;
    this.food = food;
    this.snakeMap = new HashMap<Pair<Integer, Integer>, Boolean>();
    this.snakeMap.put(new Pair<Integer, Integer>(0,0), true); // 开始时为 [0][0]
    this.snake = new LinkedList<Pair<Integer, Integer>>();
    this.snake.offerLast(new Pair<Integer, Integer>(0,0));
}

/**
 * 移动蛇。
 *
 * @param direction - 'U' = Up, 'L' = Left, 'R' = Right, 'D' = Down
 * @return 在移动后游戏的分数。如果游戏结束返回 -1。当蛇
 *     穿过了屏幕的边界或者咬到自己身体时游戏结束。
 */
public int move(String direction) {

    Pair<Integer, Integer> snakeCell = this.snake.peekFirst();
    int newHeadRow = snakeCell.getKey();
    int newHeadColumn = snakeCell.getValue();

    switch (direction) {
    case ""U"":
        newHeadRow--;
        break;
    case ""D"":
        newHeadRow++;
        break;
    case ""L"":
        newHeadColumn--;
        break;
    case ""R"":
        newHeadColumn++;
        break;
    }

    Pair<Integer, Integer> newHead = new Pair<Integer, Integer>(newHeadRow, newHeadColumn);
    Pair<Integer, Integer> currentTail = this.snake.peekLast();

    // 边界条件
    boolean crossesBoundary1 = newHeadRow < 0 || newHeadRow >= this.height;
    boolean crossesBoundary2 = newHeadColumn < 0 || newHeadColumn >= this.width;

    // 检查蛇是否咬到自己。
    boolean bitesItself = this.snakeMap.containsKey(newHead) && !(newHead.getKey() == currentTail.getKey() && newHead.getValue() == currentTail.getValue());
    
    // 如果满足任何结束条件，则以 -1 返回值退出。
    if (crossesBoundary1 || crossesBoundary2 || bitesItself) {
        return -1;
    }

    // 如果有可用的食物，并且它在移动后蛇占据的单元格上，就吃掉它。
    if ((this.foodIndex < this.food.length)
        && (this.food[this.foodIndex][0] == newHeadRow)
        && (this.food[this.foodIndex][1] == newHeadColumn)) {
        this.foodIndex++;
    } else {
        this.snake.pollLast();
        this.snakeMap.remove(currentTail);
    }

    // 总会有新的头节点加入
    this.snake.addFirst(newHead);

    // 也将头部添加到集合中
    this.snakeMap.put(newHead, true);

    return this.snake.size() - 1;
}
    
}

/**
 * 你的 SnakeGame 对象将以以下方式初始化并被调用： SnakeGame obj = new
 * SnakeGame(width, height, food); int param_1 = obj.move(direction);
 */
 ```

 ```Python3 [slu1]
 class SnakeGame:

    def __init__(self, width: int, height: int, food: List[List[int]]):
        """"""
        在这里初始化你的数据结构。
        @param width - 屏幕宽度
        @param height - 屏幕高度 
        @param food - 食物位置列表
        E.g food = [[1,1], [1,0]] 意味着第一个食物在 [1,1]，第二个在 [1,0]。
        """"""
        self.snake = collections.deque([(0,0)])    # 蛇头在前面
        self.snake_set = {(0,0) : 1}
        self.width = width
        self.height = height
        self.food = food
        self.food_index = 0
        self.movement = {'U': [-1, 0], 'L': [0, -1], 'R': [0, 1], 'D': [1, 0]}
        

    def move(self, direction: str) -> int:
        """"""
        移动蛇。
        @param direction - 'U' = Up, 'L' = Left, 'R' = Right, 'D' = Down 
        @return 在移动后游戏的分数。如果游戏结束返回 -1。
        当蛇穿过了屏幕的边界或者咬到自己身体时游戏结束。
        """"""
        
        newHead = (self.snake[0][0] + self.movement[direction][0],
                   self.snake[0][1] + self.movement[direction][1])
        
        # 边界条件
        crosses_boundary1 = newHead[0] < 0 or newHead[0] >= self.height
        crosses_boundary2 = newHead[1] < 0 or newHead[1] >= self.width
        
        # 检查蛇是否咬到自己。
        bites_itself = newHead in self.snake_set and newHead != self.snake[-1]
     
        # 如果满足任何结束条件，则以 -1 返回值退出。
        if crosses_boundary1 or crosses_boundary2 or bites_itself:
            return -1

        # 注意，此时食物清单可能是空的。
        next_food_item = self.food[self.food_index] if self.food_index < len(self.food) else None
        
        # 如果有可用的食物，并且它在移动后蛇占据的单元格上，就吃掉它。
        if self.food_index < len(self.food) and \
            next_food_item[0] == newHead[0] and \
                next_food_item[1] == newHead[1]:  # eat food
            self.food_index += 1
        else:    # 没有吃食物就删掉尾节点                 
            tail = self.snake.pop()  
            del self.snake_set[tail]
            
        # 总会有新的头节点加入
        self.snake.appendleft(newHead)
        
        # 也将头部添加到集合中
        self.snake_set[newHead] = 1

        return len(self.snake) - 1
        


# 你的 SnakeGame 对象将以以下方式初始化并被调用：
# obj = SnakeGame(width, height, food)
# param_1 = obj.move(direction)
 ```

 **复杂度分析**
 设 $W$ 表示网格的宽度，$H$ 表示网格的高度。此外，设 $N$ 表示食物列表中的食物个数。

 - 时间复杂度：  
    - `move` 函数的时间复杂度是 $\mathcal{O}(1)$。  
    - 计算 `bites_itself` 所需时间是常量，因为我们使用字典来搜索元素。  
    - 从队列中添加和移除元素的时间也是常量。 
 - 空间复杂度：  
    - 空间复杂度是 $\mathcal{O}(W \times H + N)$  
    - $\mathcal{O}(N)$ 由 `food` 数据结构使用。  
    - $\mathcal{O}(W \times H)$ 由 `snake` 和 `snake_set` 数据结构使用。在最坏情况下，蛇玩可能占据所有的网格，如文章开头所解释。

---
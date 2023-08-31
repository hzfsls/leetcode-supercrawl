## [359.日志速率限制器 中文官方题解](https://leetcode.cn/problems/logger-rate-limiter/solutions/100000/ri-zhi-su-lu-xian-zhi-qi-by-leetcode-sol-gl8v)

[TOC]

## 解决方案

---

#### 方法 1：队列 + 集合

 **概述**

 在我们解决这个问题之前，必须明确问题的条件，因为问题描述中并没有明确说明。这里有一个重要的说明：
 >有可能多条消息会在大致相同的时间到达。

 我们可以理解为输入的消息是按时间顺序排列的，即消息的时间戳是递增的，尽管并非_严格_。这个约束是至关重要的，因为它将简化任务，正如你将在以下解决方案中看到的。
 根据问题描述，让我们直观地构建一个解决方案。

 >我们把来的消息用一个 **队列** 维护。另外，为了加速查重，我们用一个 **集合** 数据结构来索引消息。

 ![image.png](https://pic.leetcode.cn/1692171085-yXmyvT-image.png){:width=600}

 如上图示例所示，数字表示每条消息的时间戳，时间戳为 `18` 的消息到达时，将使时间戳为 `5` 和 `7` 的消息无效，因为这两条消息超出了 10 秒的时间窗口。
 **算法**

- 首先，我们使用一个队列作为一种滑动窗口，保持所有在一定时间范围（10 秒）内的可打印消息。
- 每一条新消息来临时，它都带有一个 `timestamp`。这个时间戳暗示了滑动窗口的演变。因此，我们应该首先验证队列中那些 _过期的_ 消息。
- 由于 `queue` 和 `set` 数据结构应该彼此同步，我们也将那些过期的消息从我们的消息集合中移除。
- 在更新了我们的消息队列和集合之后，我们简单地检查新消息是否有重复。如果没有，我们就添加消息到队列和集合中。

```python [solution1-Python]
from collections import deque

class Logger(object):

    def __init__(self):
        """
        Initialize your data structure here.
        """
        self._msg_set = set()
        self._msg_queue = deque()
    
    def shouldPrintMessage(self, timestamp, message):
        """
        Returns true if the message should be printed in the given timestamp, otherwise returns false.
        """
        while self._msg_queue:
            msg, ts = self._msg_queue[0]
            if timestamp - ts >= 10:
                self._msg_queue.popleft()
                self._msg_set.remove(msg)
            else:
                break
        
        if message not in self._msg_set:
            self._msg_set.add(message)
            self._msg_queue.append((message, timestamp))
            return True
        else:
            return False
```

```java [solution1-Java]
class Pair<U, V> {
  public U first;
  public V second;

  public Pair(U first, V second) {
    this.first = first;
    this.second = second;
  }
}

class Logger {
  private LinkedList<Pair<String, Integer>> msgQueue;
  private HashSet<String> msgSet;

  /** Initialize your data structure here. */
  public Logger() {
    msgQueue = new LinkedList<Pair<String, Integer>>();
    msgSet = new HashSet<String>();
  }

  /**
   * Returns true if the message should be printed in the given timestamp, otherwise returns false.
   */
  public boolean shouldPrintMessage(int timestamp, String message) {

    // clean up.
    while (msgQueue.size() > 0) {
      Pair<String, Integer> head = msgQueue.getFirst();
      if (timestamp - head.second >= 10) {
        msgQueue.removeFirst();
        msgSet.remove(head.first);
      } else
        break;
    }

    if (!msgSet.contains(message)) {
      Pair<String, Integer> newEntry = new Pair<String, Integer>(message, timestamp);
      msgQueue.addLast(newEntry);
      msgSet.add(message);
      return true;
    } else
      return false;

  }
}
```

 如你所见，使用集合数据结构并不是 _绝对必要的_。一人可以简单地遍历消息队列来检查是否有重复。
 另一个重要提示是，如果消息不是按时间顺序排列的，那么我们需要遍历整个队列来删除过期的消息，而不是有 _提前停止_。或者，可以使用一些排序队列如 **优先队列** 来保留消息。

 **复杂性分析**

 - 时间复杂度：$\mathcal{O}(N)$，其中$N$是队列的大小。最坏的情况是，队列中的所有消息都过时了。因此，我们需要清理它们。
 - 空间复杂度：$\mathcal{O}(N)$，其中$N$是队列的大小。我们在队列和集合中都保持新进来的消息。所需空间的上限将为$2N$，如果我们没有任何重复的话。


---

 #### 方法 2：哈希表 / 字典

 **概述**

 一种可以将队列和集合数据结构合并为一个 **哈希表** 或 **字典** 的方法，这个方法给我们带来了既能保留所有唯一消息的队列的能力，又能像集合一样快速判断消息的重复性。

 >我们的想法是：我们用一个包含消息为键，其时间戳为值的哈希表/字典。这个哈希表保留所有唯一的消息，以及该消息打印的最新时间戳。

 ![image.png](https://pic.leetcode.cn/1692171342-XiDhfj-image.png){:width=600}

 如上图例所示，哈希表中有一个条目，其中消息为 `m2`，时间戳为 `2`。然后又来了一条消息 `m2`，时间戳为 `15`。由于消息在 13 秒前打印的（即超出了缓冲窗口），因此有资格再次打印该消息。结果，消息 `m2` 的时间戳将更新为 `15`。

 **算法步骤**

 - 我们用一个哈希表/字典开始，保持消息和时间戳。
 - 每一条新消息到来时，如果满足以下任意一种情况，该消息就有资格被打印：
   - 情况 1）我们从未见过这条消息。
   - 情况 2）我们以前见过这条消息，并且超过 10 秒没有打印过。

 - 在以上两种情况中，我们将更新哈希表中与消息相关联的条目，用最新的时间戳。

```python [solution2-Python]
class Logger(object):

    def __init__(self):
        """
        Initialize your data structure here.
        """
        self._msg_dict = {}
    
    def shouldPrintMessage(self, timestamp, message):
        """
        Returns true if the message should be printed in the given timestamp, otherwise returns false.
        """
        if message not in self._msg_dict:
            # case 1). add the message to print
            self._msg_dict[message] = timestamp
            return True

        if timestamp - self._msg_dict[message] >= 10:
            # case 2). update the timestamp of the message
            self._msg_dict[message] = timestamp
            return True
        else:
            return False
```

```java [solution2-Java]
class Logger {
  private HashMap<String, Integer> msgDict;

  /** Initialize your data structure here. */
  public Logger() {
    msgDict = new HashMap<String, Integer>();
  }

  /**
   * Returns true if the message should be printed in the given timestamp, otherwise returns false.
   */
  public boolean shouldPrintMessage(int timestamp, String message) {

    if (!this.msgDict.containsKey(message)) {
      this.msgDict.put(message, timestamp);
      return true;
    }

    Integer oldTimestamp = this.msgDict.get(message);
    if (timestamp - oldTimestamp >= 10) {
      this.msgDict.put(message, timestamp);
      return true;
    } else
      return false;
  }
}
```

 * 注意：为了清晰，我们将这两种情况分为两个块。可以将两个块合并在一起，得到更加精细的解决方案。

 这个使用哈希表的方法与前一个使用队列的方法主要的区别是，前者我们进行主动清理，即在每次调用函数时，我们首先删除那些过期的消息。
 而在这种方法里，我们保留所有的消息，即使它们已经过期。这种特性可能会成为问题，因为随着时间的推移，内存的使用会不断增长。有时候，前一种方法的 _垃圾收集_ 特性可能更有希望。

 **复杂性分析**

 - 时间复杂度：$\mathcal{O}(1)$。查找和更新哈希表需要一个常数时间。
 - 空间复杂度：$\mathcal{O}(M)$，其中 $M$ 是所有进入的消息的大小。随着时间的推移，哈希表将为已出现的每个唯一消息提供一个入口。
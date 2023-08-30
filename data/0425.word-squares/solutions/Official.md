[TOC]

## 解决方案

---

 在深入解决方案之前，首先回顾一下问题的要求可能会有帮助。
 给定一个非重复词汇的列表，我们被要求构造所有可能的词方阵的组合。这里是 _**词方阵**_ 的定义。
 >一组单词形成一个有效的_词方块_，当且仅当从第 k 行横向组成的字符串($H_k$)等于从第 k 列纵向组成的字符串($V_k$)，_即_ $H_k == V_k \qquad \forall{k} \quad 0 ≤ k < \max(\text{numRows}, \text{numColumns})$

 ![image.png](https://pic.leetcode.cn/1692171933-MkPjlC-image.png){:width=400}

 从定义中我们可以看到，对于行和列大小相等的词方块，结果字母矩阵应在对角线上是 **对称的**。

 换句话说，如果我们知道词方块的右上部分，我们就可以推断出其左下部分，反之亦然。词方块的这种对称性也可以被解释为问题的 **约束**（如在 _约束编程_ 中），这可以帮助我们缩小有效组合的范围。

---

#### 算法：回溯法  

 给定一个单词列表，我们被要求找到一个单词的组合，在此基础上我们可以构建一个 _词方阵_。解决上述问题的算法的主要思想可以非常简单。
 >这个简单的课题是我们从上到下 **_逐行_** 构造词方块。在每一行，我们简单地进行 _试错_，_即_ 我们试一个词，如果它不满足约束，那么我们就试另一个。
 > 你可能已经注意到了，上述算法思想实际上被称为回溯法，它经常与 _递归_ 和 _DFS_(深度优先搜索)一起使用。
 > 让我们用一个例子来说明这个想法。给定一个单词列表 `[ball, able, area, lead, lady]`，我们应该堆叠 4 个单词以构建一个词方块。

 ![image.png](https://pic.leetcode.cn/1692172383-jxPpyE-image.png){:width=400}

- 让我们从 `ball` 这个词开始作为词方块的第一个词，_即_我们将在第一行放入的词。
- 然后我们移到第二行。给定词方阵的 _对称性_ 属性，我们现在知道我们应该在第二行的第一 _列_ 填充字母。换句话说，我们知道第二行的单词应该以 _前缀_ `a` 开头。
- 在单词列表中，有两个单词以 `a` 开头(_即_ `able`，`area`)。他们都可以作为填充方块第二行的候选词。因此，我们应该在下一步尝试他们。
- 在接下来的步骤(1)，让我们用 `able` 这个单词填充第二行。然后我们可以移到第三行。再次，由于对称性，我们知道第三行的单词应该以 `ll` 开始。不幸的是，我们没有找到以 `ll` 开头的单词。因此，我们不能再向前走。我们然后放弃这个路径，并 **_回溯_** 到以前的状态(已填充第一行)。
- 作为一个替代的下一步(1)，我们可以尝试在第二行使用 `area` 这个词。一旦我们填满第二行，我们就会知道下一行，即填入的单词应该以 `le` 为前缀。这一次，我们找到了候选词(_即_ `lead`)。
- 结果，在下一步(2)，我们用 `lead`这个词填充第三行。等等。
- _最后，如果一个人用每个单词作为开始的单词重复上述步骤，一个人就会耗尽所有构造有效词方块的可能性_。

 ```Python3
 class Solution:

    def wordSquares(self, words: List[str]) -> List[List[str]]:

        self.words = words
        self.N = len(words[0])

        results = []
        word_squares = []
        for word in words:
            # 尝试把每一个词都作为起始词
            word_squares = [word]
            self.backtracking(1, word_squares, results)
        return results

    def backtracking(self, step, word_squares, results):

        if step == self.N:
            results.append(word_squares[:])
            return

        prefix = ''.join([word[step] for word in word_squares])
        # 找出所有以给定前缀开头的单词
        for candidate in self.getWordsWithPrefix(prefix):
            # 逐行迭代
            word_squares.append(candidate)
            self.backtracking(step+1, word_squares, results)
            word_squares.pop()

    def getWordsWithPrefix(self, prefix):
        for word in self.words:
            if word.startswith(prefix):
                yield word
 ```

 在代码的第一眼看来，这个问题似乎并不像它的标签那样令人生畏。实际上如果一个人能在面试中提出代码的框架，就可以说一个人已经 _拿下了_ 面试。

 以上实现是正确的，将通过在线评测的大部分测试用例。然而，对于某些具有大量输入的测试用例，它会导致 `Time Limit Exceeded` 异常。但是，没有必要感到沮丧，因为我们已经找出了算法的 _困难_ 部分。我们只需要整理出最后一点 _优化_，这实际上可以作为面试中的后续问题。

---

 #### 方法 1：带哈希表的回溯

 **概述**

 如上面的回溯算法中所注意到的，瓶颈在于 `getWordsWithPrefix()` 函数，该函数用于找到所有具有给定前缀的单词。在每次调用该函数时，我们都在遍历整个输入单词列表，这是线性时间复杂度 $\mathcal{O}(N)$。
 >优化 `getWordsWithPrefix()` 函数的一个想法是事先处理单词，并构建一个数据结构，以便稍后加速查找过程。
 > 可能有人会想起，提供快速查找操作的其中一个数据结构被称为 _**散列表**_ 或字典。我们可以简单地构建一个散列表，所有可能的前缀作为表中的 _键_，与前缀相关联的单词作为表中的 _值_。稍后，给定前缀，我们应该能够在常数时间 $\mathcal{O}(1)$ 内列出所有具有给定前缀的单词。

 **算法步骤**

 - 我们在上面列出的回溯算法基础上进行构建，并调整两个部分。
 - 在第一部分，我们添加一个新的函数 `buildPrefixHashTable(words)` 来构建一个由输入单词构成的散列表。
 - 在第二部分，在 `getWordsWithPrefix()` 函数中，我们直接查询散列表以检索所有具有给定前缀的单词。

 ```Java [slu1]
 class Solution {
  int N = 0;
  String[] words = null;
  HashMap<String, List<String>> prefixHashTable = null;

  public List<List<String>> wordSquares(String[] words) {
    this.words = words;
    this.N = words[0].length();

    List<List<String>> results = new ArrayList<List<String>>();
    this.buildPrefixHashTable(words);

    for (String word : words) {
      LinkedList<String> wordSquares = new LinkedList<String>();
      wordSquares.addLast(word);
      this.backtracking(1, wordSquares, results);
    }
    return results;
  }

  protected void backtracking(int step, LinkedList<String> wordSquares,
                              List<List<String>> results) {
    if (step == N) {
      results.add((List<String>) wordSquares.clone());
      return;
    }

    StringBuilder prefix = new StringBuilder();
    for (String word : wordSquares) {
      prefix.append(word.charAt(step));
    }

    for (String candidate : this.getWordsWithPrefix(prefix.toString())) {
      wordSquares.addLast(candidate);
      this.backtracking(step + 1, wordSquares, results);
      wordSquares.removeLast();
    }
  }

  protected void buildPrefixHashTable(String[] words) {
    this.prefixHashTable = new HashMap<String, List<String>>();

    for (String word : words) {
      for (int i = 1; i < this.N; ++i) {
        String prefix = word.substring(0, i);
        List<String> wordList = this.prefixHashTable.get(prefix);
        if (wordList == null) {
          wordList = new ArrayList<String>();
          wordList.add(word);
          this.prefixHashTable.put(prefix, wordList);
        } else {
          wordList.add(word);
        }
      }
    }
  }

  protected List<String> getWordsWithPrefix(String prefix) {
    List<String> wordList = this.prefixHashTable.get(prefix);
    return (wordList != null ? wordList : new ArrayList<String>());
  }
}
 ```

 ```Python3 [slu1]
 class Solution:

    def wordSquares(self, words: List[str]) -> List[List[str]]:

        self.words = words
        self.N = len(words[0])
        self.buildPrefixHashTable(self.words)

        results = []
        word_squares = []
        for word in words:
            word_squares = [word]
            self.backtracking(1, word_squares, results)
        return results

    def backtracking(self, step, word_squares, results):
        if step == self.N:
            results.append(word_squares[:])
            return

        prefix = ''.join([word[step] for word in word_squares])
        for candidate in self.getWordsWithPrefix(prefix):
            word_squares.append(candidate)
            self.backtracking(step+1, word_squares, results)
            word_squares.pop()

    def buildPrefixHashTable(self, words):
        self.prefixHashTable = {}
        for word in words:
            for prefix in (word[:i] for i in range(1, len(word))):
                self.prefixHashTable.setdefault(prefix, set()).add(word)

    def getWordsWithPrefix(self, prefix):
        if prefix in self.prefixHashTable:
            return self.prefixHashTable[prefix]
        else:
            return set([])
 ```

 **复杂度分析**

- 时间复杂度：$\mathcal{O}(N\cdot 26^{L})$，其中 $N$ 是输入单词的数量，$L$ 是单个单词的长度。
  - 计算回溯算法中操作的确切数量是很棘手的。我们知道，回溯的痕迹将形成一个 n 叉树。因此，操作的上限应该是完全 n 叉树中的节点总数。
  - 在我们的案例中，在痕迹的任何节点，最多可以有 26 个分支（_即_ 26 个字母表字母）。因此，一个 26 叉树的最大节点数大约为 $26^L$。  
  - 在回溯函数的循环中，我们枚举每个单词作为词方阵的开始单词的可能性。因此，总体而言，算法的整体时间复杂度应为 $\mathcal{O}(N\cdot 26^{L})$。
  - 尽管时间复杂度看起来很大，在实际中，回溯的实际痕迹比其上限小得多，这要归功于 _约束_ 检查方针（词方阵的对称性），它对回溯进行了极大的剪枝。
- 空间复杂度：$\mathcal{O}(N\cdot L + N\cdot\frac{L}{2}) = \mathcal{O}(N\cdot L)$ 其中 $N$ 是单词数量，$L$ 是单个词的长度。
- 空间复杂度的第一部分（即 $N\cdot L$）是散列表中的值，我们在散列表中存储了 $L$ 次所有单词。
- 空间复杂度的第二部分（_即_ $N\cdot\frac{L}{2}$）是散列表的关键所占据的空间，其中包含所有单词的所有前缀。
- 总的来说，我们可以说，整个算法的空间是单词总数乘以单个单词的长度。

---

#### 方法 2：带有 Trie 的回溯

 **概述**
 说起前缀，还有另一种称为 **_Trie_** 的数据结构（也称为 **_前缀树_**），可能在这个问题中可以发挥作用。
 在上述方法中，我们已经将以给定前缀检索单词列表的时间复杂度从线性 $\mathcal{O}(N)$ 降低到常数时间 $\mathcal{O}(1)$。换句话说，我们必须花一些额外的空间来储存所有单词的前缀。

 >Trie 数据结构提供了一个 _紧凑_ 而仍然 _快速_ 检索给定前缀的单词的方法。
 > 在下图中，我们展示了一个如何从单词列表中建立 Trie 的例子。

 ![image.png](https://pic.leetcode.cn/1692172769-OQyoyo-image.png){:width=400}

 可以看到，Trie 基本上是一个 n 叉树，其中每个节点代表一个前缀中的一个字符。Trie 数据结构在储存前缀时是 **紧凑** 的，因为它消除了冗余的前缀，_比如_ `le` 和 `la` 的前缀将共享一个节点。然而，从 Trie 中检索单词仍然很快。检索一个词需要 $\mathcal{O}(L)$，其中 $L$ 是词的长度，这比蛮力枚举快多了。

 **算法步骤**

- 我们在上面列出的回溯算法基础上进行构建，并调整两个部分。  
- 在第一部分，我们添加一个新的函数 `buildTrie(words)` 来构建一个由输入单词构成的 Trie。
- 然后在第二部分，在 `getWordsWithPrefix(prefix)` 函数中，我们直接查询 Trie 以检索所有具有给定前缀的单词。
 以下是一些样本实现。注意，我们稍微调整了 Trie 数据结构，以进一步优化时间和空间复杂度。

- 不是在 Trie 的叶子节点上标记单词，而是在每个节点上标记单词，这样我们就不需要在达到前缀的最后一个节点时进行进一步的遍历。这个技巧可以帮助我们节省时间。
- 不是在 Trie 中存储实际的单词，我们只保留单词的索引，这可以大大节省空间。

 ```Java [slu2]
 class TrieNode {
  HashMap<Character, TrieNode> children = new HashMap<Character, TrieNode>();
  List<Integer> wordList = new ArrayList<Integer>();

  public TrieNode() {}
}


class Solution {
  int N = 0;
  String[] words = null;
  TrieNode trie = null;

  public List<List<String>> wordSquares(String[] words) {
    this.words = words;
    this.N = words[0].length();

    List<List<String>> results = new ArrayList<List<String>>();
    this.buildTrie(words);

    for (String word : words) {
      LinkedList<String> wordSquares = new LinkedList<String>();
      wordSquares.addLast(word);
      this.backtracking(1, wordSquares, results);
    }
    return results;
  }

  protected void backtracking(int step, LinkedList<String> wordSquares,
                              List<List<String>> results) {
    if (step == N) {
      results.add((List<String>) wordSquares.clone());
      return;
    }

    StringBuilder prefix = new StringBuilder();
    for (String word : wordSquares) {
      prefix.append(word.charAt(step));
    }

    for (Integer wordIndex : this.getWordsWithPrefix(prefix.toString())) {
      wordSquares.addLast(this.words[wordIndex]);
      this.backtracking(step + 1, wordSquares, results);
      wordSquares.removeLast();
    }
  }

  protected void buildTrie(String[] words) {
    this.trie = new TrieNode();

    for (int wordIndex = 0; wordIndex < words.length; ++wordIndex) {
      String word = words[wordIndex];

      TrieNode node = this.trie;
      for (Character letter : word.toCharArray()) {
        if (node.children.containsKey(letter)) {
          node = node.children.get(letter);
        } else {
          TrieNode newNode = new TrieNode();
          node.children.put(letter, newNode);
          node = newNode;
        }
        node.wordList.add(wordIndex);
      }
    }
  }

  protected List<Integer> getWordsWithPrefix(String prefix) {
    TrieNode node = this.trie;
    for (Character letter : prefix.toCharArray()) {
      if (node.children.containsKey(letter)) {
        node = node.children.get(letter);
      } else {
        // 返回空列表。
        return new ArrayList<Integer>();
      }
    }
    return node.wordList;
  }
}
 ```

 ```Python3 [slu2]
 class Solution:

    def wordSquares(self, words: List[str]) -> List[List[str]]:

        self.words = words
        self.N = len(words[0])
        self.buildTrie(self.words)

        results = []
        word_squares = []
        for word in words:
            word_squares = [word]
            self.backtracking(1, word_squares, results)
        return results

    def buildTrie(self, words):
        self.trie = {}

        for wordIndex, word in enumerate(words):
            node = self.trie
            for char in word:
                if char in node:
                    node = node[char]
                else:
                    newNode = {}
                    newNode['#'] = []
                    node[char] = newNode
                    node = newNode
                node['#'].append(wordIndex)

    def backtracking(self, step, word_squares, results):
        if step == self.N:
            results.append(word_squares[:])
            return

        prefix = ''.join([word[step] for word in word_squares])
        for candidate in self.getWordsWithPrefix(prefix):
            word_squares.append(candidate)
            self.backtracking(step+1, word_squares, results)
            word_squares.pop()

    def getWordsWithPrefix(self, prefix):
        node = self.trie
        for char in prefix:
            if char not in node:
                return []
            node = node[char]
        return [self.words[wordIndex] for wordIndex in node['#']]
 ```

 **复杂度分析**

- 时间复杂度：$\mathcal{O}(N\cdot 26^{L}\cdot L)$，其中 $N$ 是输入单词的数量，$L$ 是单个单词的长度。
  - 基本上，时间复杂度与方法#1相同($\mathcal{O}(N\cdot 26^{L})$)，只是 `getWordsWithPrefix(prefix)` 函数的常量时间访问现在需要 $\mathcal{O}(L)$。
- 空间复杂度：$\mathcal{O}(N\cdot L + N\cdot\frac{L}{2}) = \mathcal{O}(N\cdot L)$ 其中 $N$ 是单词的数量，$L$ 是单个词的长度。
  - 空间复杂度的第一部分(_即_ $N\cdot L$)是我们在 Trie 中存储的单词索引，我们为每个单词存储了 $L$ 次索引。
  - 空间复杂度的第二部分(_即_ $N\cdot\frac{L}{2}$)是所有单词的前缀所需要的空间。在最糟糕的情况下，我们的前缀没有重叠。
  - 总的来说，这种方法的空间复杂度和前一种方法的空间复杂度是一样的。然而，在运行时间方面，由于我们所做的所有优化，它会使用更少的内存。
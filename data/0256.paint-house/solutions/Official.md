## [256.粉刷房子 中文官方题解](https://leetcode.cn/problems/paint-house/solutions/100000/fen-shua-fang-zi-by-leetcode-solution-a2qn)
## 解决方案

对那些已经熟悉记忆化和动态规划的人来说，这道题可能很简单。对于那些 Leetcoding 新手来说，它可能看上去是中等，甚至困难难度。_**对于那些正在开始学习记忆化和动态规划的人来说，非常适合从这道题开始**_！

本文的目标读者是那些开始学习动态规划和记忆的人。所以本文会默认你已经学习了前置知识，如 n 叉树(或二叉树)，包括递归。如果你没有，我强烈建议你在学习了 [n 叉树板块](https://leetcode.cn/leetbook/detail/n-ary-tree/) 和 [二叉树板块](https://leetcode.cn/leetbook/detail/data-structure-binary-tree/) 之后再尝试此题。记忆化和动态规划背后的思路最好是使用树来理解，这也是我在本文中所做的。了解如何识别并处理记忆化和动态规划问题是面试成功的关键。

___

#### 方法 1：暴力

**概述**

暴力方法通常是一个很好的起点。从那里，我们可以发现不必要的工作并进一步优化。在这种情况下，暴力算法将生成房屋颜色的每个有效排列(或所有排列，然后移除所有无效排列，例如，具有两个并排的红房子的排列)并对它们进行评分。然后，最低的分数是我们需要返回的值。

在本文中，我们将用下面的输入，它包含 4 个房子。

```text
[[17, 2, 17], [8, 4, 10], [6, 3, 19], [4, 8, 12]]
```

![input_grid.png](https://pic.leetcode.cn/1692342032-EgThKc-input_grid.png){:width=400}

这些都是你可以用 4 个房子得到的有效序列。总共有 24 个。总成本最低的项目会高亮显示。

![brute_force.png](https://pic.leetcode.cn/1692342053-OxtKgb-brute_force.png){:width=400}

最好的选择是将第一所房子漆成绿色，第二所房子涂成红色，第三所房子涂成绿色，第四所房子涂成红色。这将总共花费 17。

**算法步骤**

不用过多的去考虑如何实现暴力解决方案，因为这在实践中是完全不可行，或者说是毫无用处的。此外，后一种方法会朝着不同的方向移动，而置换代码实际上需要一些努力才能理解(这会分散你的注意力)。因此，我没有写它的代码。你也不会在面试中为它编写代码，相反，你只需描述一种可能的方法并进行优化，然后为更优化的算法编写代码。

有很多不同的方法来解决这个问题。它们都是基于排列生成的，但有些只生成遵循颜色规则的排列，而另一些则生成所有排列，然后删除无效的排列。有些是递归的，有些是迭代的。一些人使用 O(N) 空间，一次只生成一个排列，然后在生成下一个排列之前处理它，而另一些人使用更多的空间(下面讨论)，首先生成所有序列，然后处理它们。

最简单的方法可能是生成所有可能的长度为 n 的字符串，包括 “0”、“1” 和 “2”，删除连续两次相同数字的字符串，然后对剩下的字符串进行评分，以记录到目前为止所见的最小成本。

**复杂度分析**

-   时间复杂度：$O(2^n)$ 或 $O(3^n)$。
    
    无需编写代码，我们就可以很好地了解开销。我们知道，至少，我们必须处理每一个有效的排列。每增加一栋房子，有效排列的数量就会翻一番。有了 4 栋房子，就有了 24 栋排列。如果我们添加另一个房子，那么我们对 4 个房子的所有排列可以扩展为 5 个房子的 2 种不同的颜色，给出 `48` 个排列。因为它每次都加倍，所以是 $O(n^2)$。
    
    如果我们生成 `0`、`1` 和 `2` 的所有排列，然后删除无效的排列，情况会更糟。这样的排列总共有 $O(n^3)$ 个。
    
-   空间复杂度：$O(n)$ 到 $O(n \cdot 3^n)$ 之间。
    
    这将完全取决于实现。如果你同时生成所有的排列并将它们放在一个庞大的列表中，那么你将使用 $O(n \cdot 2^n)$ 或 $O(n \cdot 3^n)$ 空间。如果你生成一个列表、处理它、生成下一个列表、处理它，等等，而没有保存长列表，那么它将需要 $O(N)$ 空间。
    
___

#### 方法 2：使用递归树暴力

**概述**

像第一种方法一样，这种方法仍然不够好。然而，它弥合了方法 1 和方法 3 之间的差距，方法 3 进一步建立在它的基础上。所以要确保你很好地理解了它。

当我们有排列时，我们可以把它们想象成一棵包含所有选项的大树。画出这棵树(或其中的一部分)可以提供有用的见解，并揭示其他可能的算法。我们将继续使用上面的示例：

![input_grid.png](https://pic.leetcode.cn/1692342032-EgThKc-input_grid.png){:width=400}

这就是我们如何用树来表示它。从根到叶的每一条路径代表着不同的可能的房屋颜色排列。树上有 24 个叶节点，就像在暴力方法中识别的 24 个排列一样。

![permutation_tree.png](https://pic.leetcode.cn/1692342120-RWdABP-permutation_tree.png){:width=400}

树表示法给出了问题和所有可能的排列的有用模型。它显示，例如，如果我们将第一个房子漆成红色，那么第二个房子有两个选择：绿色或蓝色。如果我们为第二所房子选择绿色，我们可以为第三所房子选择红色或蓝色。以此类推。

不用担心我们将如何实际实现它，我们现在将探索一种简单的算法，该算法可以用来使用这棵树来解决问题。

如果前三个房子是红色、绿色和红色，那么我们可以把第四个房子漆成绿色或蓝色。我们会选择哪一个呢？

![image.png](https://pic.leetcode.cn/1692342206-jYJoVs-image.png){:width=400}

为了把成本降到最低，我们会选择绿色的。因为绿色是 `8`，蓝色是 `12`。_假设我们已经决定了前3个房子是红色、绿色和红色的_，这个决定绝对是最优的。我们知道我们不可能做得更好。

我们实际上是在决定两种组合中哪种更便宜：`red, green, red, green` 或 `red, green, red, blue`。因为前者更便宜，我们完全排除了后者。我们可以用这一新信息简化我们的树，方法是将第四所房子的成本与该分支上第三所房子的成本相加。

![image.png](https://pic.leetcode.cn/1692342275-vKPqod-image.png){:width=400}

我们可以按照相同的过程重复移除叶节点，如此动画所示。

<![Slide1.PNG](https://pic.leetcode.cn/1692342375-jijSZD-Slide1.PNG){:width=400},![Slide2.PNG](https://pic.leetcode.cn/1692342375-TKNJLj-Slide2.PNG){:width=400},![Slide3.PNG](https://pic.leetcode.cn/1692342375-jpebuS-Slide3.PNG){:width=400},![Slide4.PNG](https://pic.leetcode.cn/1692342375-NsRSqw-Slide4.PNG){:width=400},![Slide5.PNG](https://pic.leetcode.cn/1692342375-gQsOSN-Slide5.PNG){:width=400},![Slide6.PNG](https://pic.leetcode.cn/1692342375-tMgIuD-Slide6.PNG){:width=400},![Slide7.PNG](https://pic.leetcode.cn/1692342375-PlYqyb-Slide7.PNG){:width=400},![Slide8.PNG](https://pic.leetcode.cn/1692342375-wSvTFV-Slide8.PNG){:width=400},![Slide9.PNG](https://pic.leetcode.cn/1692342375-VhzlOu-Slide9.PNG){:width=400},![Slide10.PNG](https://pic.leetcode.cn/1692342375-JTPXzO-Slide10.PNG){:width=400},![Slide11.PNG](https://pic.leetcode.cn/1692342375-CeuGGa-Slide11.PNG){:width=400},![Slide12.PNG](https://pic.leetcode.cn/1692342375-Fwsmkn-Slide12.PNG){:width=400},![Slide13.PNG](https://pic.leetcode.cn/1692342375-JkdXni-Slide13.PNG){:width=400},![Slide14.PNG](https://pic.leetcode.cn/1692342375-dLnBjg-Slide14.PNG){:width=400},![Slide15.PNG](https://pic.leetcode.cn/1692342375-jngBue-Slide15.PNG){:width=400},![Slide16.PNG](https://pic.leetcode.cn/1692342375-qrmssb-Slide16.PNG){:width=400},![Slide17.PNG](https://pic.leetcode.cn/1692342375-VYohWL-Slide17.PNG){:width=400},![Slide18.PNG](https://pic.leetcode.cn/1692342375-PJLJOm-Slide18.PNG){:width=400},![Slide19.PNG](https://pic.leetcode.cn/1692342375-qBDmVU-Slide19.PNG){:width=400},![Slide20.PNG](https://pic.leetcode.cn/1692342375-ARCLlR-Slide20.PNG){:width=400},![Slide21.PNG](https://pic.leetcode.cn/1692342375-rMnVzD-Slide21.PNG){:width=400},![Slide22.PNG](https://pic.leetcode.cn/1692342375-HedBwK-Slide22.PNG){:width=400},![Slide23.PNG](https://pic.leetcode.cn/1692342375-xcHfMk-Slide23.PNG){:width=400},![Slide24.PNG](https://pic.leetcode.cn/1692342375-TqOTLQ-Slide24.PNG){:width=400},![Slide25.PNG](https://pic.leetcode.cn/1692342375-KKszSK-Slide25.PNG){:width=400},![Slide26.PNG](https://pic.leetcode.cn/1692342375-Hjtwvl-Slide26.PNG){:width=400},![Slide27.PNG](https://pic.leetcode.cn/1692342375-YSVFLS-Slide27.PNG){:width=400}>

我们得到的结论是：
- 将第一栋房子漆成红色，总成本为 `34`。
- 将第一栋房子漆成绿色，总成本为 `17`。
- 将第一栋房子漆成蓝色，总成本为 `32`。

所以，把第一栋房子漆成绿色是有意义的。这给出的总成本是 `17`，这与我们在方法 1 中的暴力得出的答案相同。

**算法步骤**

要真正实现这个算法，我们需要改变我们的思考方式。我们在这里所做的是一种自下而上的算法，这意味着我们从处理叶节点开始，然后逐步向上。然而，当实现这样的算法时，我们几乎总是自上而下地执行。这允许我们在递归中使用 _隐含的树_，而不是实际创建树(即不是必须使用 `TreeNode`)。递归调用都形成了树形结构。如果你还不太熟悉这个想法，请不要惊慌，在下一节中有一个算法和代码的动画。理解递归的最好方法是查看示例并识别常见模式。

我们开始吧。还记得我们是如何确定在树上粉刷每座房子的成本的吗？

![image.png](https://pic.leetcode.cn/1692342569-VDSGgj-image.png){:width=400}

所谓“总成本”，我们指的是粉刷一种特定颜色的成本，以及粉刷后一种颜色的成本。

在伪代码中这个自顶向下的递归算法看起来像这样：

```C
print min(paint(0, 0), paint(0, 1), paint(0, 2))

define function paint(n, color):
  total_cost = costs[n][color]
  if n is the last house number:
    pass [go straight to the return]
  else if color is red (0):
    total_cost += min(paint(n+1, 1), paint(n+1, 2))
  else if color is green (1):
    total_cost += min(paint(n+1, 0), paint(n+1, 2))
  else if color is blue (2):
    total_cost += min(paint(n+1, 0), paint(n+1, 1))
  return the total_cost    
```

以下是该算法的动画。它还展示了递归调用如何构建与我们之前处理的树相同的结构，而不是实际构建树。如果你不太熟悉递归，这个算法可能会让你摸不着头脑，但它对于理解方法 3 是必不可少的。

<![image.png](https://pic.leetcode.cn/1692352794-BHoHYW-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692352798-hASsmS-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692352801-CBOzXF-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692352804-JGuvCz-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692352807-DzAJwt-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692352809-yQRzuS-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692352813-kkOyIX-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692352816-CZrWSr-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692352820-FlNpGD-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692352840-HzoObq-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692352845-eUUyTx-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692352849-nqYlRE-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692352853-HjgmcL-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692352856-iikoaw-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692352859-iDpjmh-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692352866-JnvEJR-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692352869-gxbPlU-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692352872-nowDRu-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692352876-wvQAIN-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692352879-GmLOEM-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692352882-yMiAOm-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692352885-nZZdrJ-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692352889-mdnYpF-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692352892-IkQUKj-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692352896-jklezU-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692352900-UKZFtd-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692352903-HOLNqN-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692352906-QgGLuZ-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692352910-SponPQ-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692352916-eXiffY-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692352919-LZYwyN-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692352922-wlQLMu-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692352925-muSwvU-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692352929-LUNEug-image.png){:width=400}>

当你阅读代码实现的时候，脑中会有一个初步的想法，你应该怎样去优化它，使其不再花费指数级的时间。提示：仔细查看递归函数的参数。我们实际上是在一遍又一遍地重复同样的事情。这是我们在方法 3 中解决的问题。

```Java [slu2]
class Solution {

    private int[][] costs;

    public int minCost(int[][] costs) {
        if (costs.length == 0) {
            return 0;
        }
        this.costs = costs;
        return Math.min(paintCost(0, 0), Math.min(paintCost(0, 1), paintCost(0, 2)));
    }

    private int paintCost(int n, int color) {
        int totalCost = costs[n][color];
        if (n == costs.length - 1) {
        } else if (color == 0) { // 红
            totalCost += Math.min(paintCost(n + 1, 1), paintCost(n + 1, 2));
        } else if (color == 1) { // 绿
            totalCost += Math.min(paintCost(n + 1, 0), paintCost(n + 1, 2));
        } else { // 蓝
            totalCost += Math.min(paintCost(n + 1, 0), paintCost(n + 1, 1));
        }        
        return totalCost;
    }
}
```

```Python
def minCost(self, costs):
    """
    :type costs: List[List[int]]
    :rtype: int
    """

    def paint_cost(n, color):
        total_cost = costs[n][color]
        if n == len(costs) - 1:
            pass
        elif color == 0: # 红
            total_cost += min(paint_cost(n + 1, 1), paint_cost(n + 1, 2))
        elif color == 1: # 绿
            total_cost += min(paint_cost(n + 1, 0), paint_cost(n + 1, 2))
        else: # 蓝
            total_cost += min(paint_cost(n + 1, 0), paint_cost(n + 1, 1))
        return total_cost

    if costs == []:
        return 0
    return min(paint_cost(0, 0), paint_cost(0, 1), paint_cost(0, 2))
```

**复杂度分析**

-   时间复杂度：$O(2^n)$。
    
    虽然这种方法是对以前方法的改进，但它仍然需要指数级的时间。想一想叶节点的数量。每个排列都有自己的叶节点。内部节点的数量也与叶节点的数量相同。还记得有 $2^n$ 个不同的排列吗？每个节点都有效地将 `2` 个节点添加到树中，因此省略常量 `2` 将得到 $O(2^n)$。
    
    这比前一种方法更好，前一种方法有一个额外的因子 `n`，得到 $O(n \cdot 2^n)$。这个 `n` 的额外因素在这里消失了，因为与以前不同的是，这些排列现在“共享”了它们相似的部分。对于这个特定的问题，“共享”相似部分的想法可以更进一步，正如我们将在其余方法中看到的那样，这些方法将时间复杂度一路降低到 $O(n)$。
    
-   空间复杂度：$O(n)$。
    
    该算法最初可能看起来是 `O(1)`，因为我们没有分配任何新的数据结构。但是，我们需要考虑 **运行时堆栈** 上的空间使用情况。动画中显示了运行时堆栈。每当我们处理最后一个房子(房号为 `n-1`)时，堆栈上都有 `n` 个堆栈帧。此空间使用量计入复杂性分析(它是内存使用量，与任何其他内存使用量一样)，因此空间复杂性为 `O(N)`。

___

#### 方法 3：记忆化

**概述**

当我们使用前面的方法时，你可能已经注意到了一个非常重要的模式。让我们仔细看看。

这是我们移除任何层之前的树。

![permutation_tree.png](https://pic.leetcode.cn/1692353087-tssGhw-permutation_tree.png){:width=400}

观察这些叶节点。所有的红房子都花费 4，绿房子是花费 8，蓝房子是花费 12。这是有道理的，因为最初的输入告诉我们，将 `4` 房子漆成红色、绿色或蓝色的成本分别是 `4`、`8` 和 `12`。

但是，看看当我们按照上一节描述的方式删除这些叶节点时会发生什么。

![1_layer_removed.png](https://pic.leetcode.cn/1692353094-xqHwch-1_layer_removed.png){:width=400}

同样，所有的红房子在 14 号都是一样的，绿房子是 7 号，蓝房子是 23 号。为什么会发生这种情况？在删除两个子代之前，我们总是将两个子代中最便宜的一个添加到父代中。把第三栋房子刷成红色要花费 6。然后我们总是可以在把第四栋房子漆成绿色或蓝色之间做出选择。只有选择绿色才有意义，因为绿色是 `8`(相比之下，把它涂成蓝色是 `12`)，因此，所有这些树枝都变成了 `6+8=14`。类似的理由也适用于将第三个房子漆成蓝色或绿色。

这是我们再次移除另一层时的树。

![2_layers_removed.png](https://pic.leetcode.cn/1692353099-lpllcC-2_layers_removed.png){:width=400}

不出所料，这种模式仍在继续。

这一模式很重要，因为它向我们表明，我们实际上一遍又一遍地进行同样的几个计算。我们应该保存并在可能的情况下重复使用结果，而不是重复进行相同的(昂贵的)计算。

例如，想象一下，如果你在学校里被布置了这样的数学作业(而且不允许使用计算器)。你会怎么做呢？

```text
1) 345 * 282 = ?
2) 43 + (345 * 282) = ?
3) (345 * 282) + 89 = ?
4) (345 * 282) * 5 + 19 = ?
```

除非你真的、真的喜欢算术，否则我想你只会做一次 `345*282` 的运算，然后把它插入所有其他的方程式中。你可能不会为它做 4 次长长的乘法！

计算粉刷这些房子的费用也是一样的。我们只需要计算一下把第二栋房子漆成红色一次的费用。

因此，要做到这一点，我们将使用 **记忆化**。在返回我们已经完成计算的值之前，我们将把它写入一个字典，输入值作为键，返回值作为结果。然后，在函数开始时，我们将首先检查答案是否已经在词典中。如果是的话，我们可以立即返回。如果不是，那么我们需要像以前一样继续计算它。

**算法步骤**

代码实现与上一个几乎相同。唯一的区别是我们在开始时创建了一个空字典，将返回值写入其中，然后首先检查它，看看我们是否已经找到了一组特定输入参数的答案。

```
print min(paint(0, 0), paint(0, 1), paint(0, 2))

memo = a new, empty dictionary

define function paint(n, color):
  if (n, color) is a key in memo:
     return memo[(n, color)]
  total_cost = costs[n][color]
  if n is the last house number:
    pass [go straight to return]
  else if color is red (0):
    total_cost += min(paint(n+1, 1), paint(n+1, 2))
  else if color is green (1):
    total_cost += min(paint(n+1, 0), paint(n+1, 2))
  else if color is blue (2):
    total_cost += min(paint(n+1, 0), paint(n+1, 1))
  memo[(n, color)] = total_cost
  return the total_cost    
```

还记得前面的方法是如何为我们绘制的树中的每个节点进行递归函数调用的吗？这种方法只需要进行所示的计算。亮的圆圈表示实际计算答案所需的位置，而暗淡的圆圈表示在词典中查找答案的位置。

![visualisation_memo.png](https://pic.leetcode.cn/1692353166-UlWdfm-visualisation_memo.png){:width=400}

```Java [slu3]
class Solution {

    private int[][] costs;
    private Map<String, Integer> memo;

    public int minCost(int[][] costs) {
        if (costs.length == 0) {
            return 0;
        }
        this.costs = costs;
        this.memo = new HashMap<>();
        return Math.min(paintCost(0, 0), Math.min(paintCost(0, 1), paintCost(0, 2)));
    }

    private int paintCost(int n, int color) {
        if (memo.containsKey(getKey(n, color))) {
            return memo.get(getKey(n, color));   
        }
        int totalCost = costs[n][color];
        if (n == costs.length - 1) {
        } else if (color == 0) { // 红
            totalCost += Math.min(paintCost(n + 1, 1), paintCost(n + 1, 2));
        } else if (color == 1) { // 绿
            totalCost += Math.min(paintCost(n + 1, 0), paintCost(n + 1, 2));
        } else { // 蓝
            totalCost += Math.min(paintCost(n + 1, 0), paintCost(n + 1, 1));
        }        
        memo.put(getKey(n, color), totalCost);

        return totalCost;
    }

    private String getKey(int n, int color) {
        return String.valueOf(n) + " " + String.valueOf(color);
    }
}
```

```Python [slu3]
def minCost(self, costs):
    """
    :type costs: List[List[int]]
    :rtype: int
    """

    def paint_cost(n, color):
        if (n, color) in self.memo:
            return self.memo[(n, color)]
        total_cost = costs[n][color]
        if n == len(costs) - 1:
            pass
        elif color == 0:
            total_cost += min(paint_cost(n + 1, 1), paint_cost(n + 1, 2))
        elif color == 1:
            total_cost += min(paint_cost(n + 1, 0), paint_cost(n + 1, 2))
        else:
            total_cost += min(paint_cost(n + 1, 0), paint_cost(n + 1, 1))
        self.memo[(n, color)] = total_cost
        return total_cost

    if costs == []:
        return 0

    self.memo = {}
    return min(paint_cost(0, 0), paint_cost(0, 1), paint_cost(0, 2))
```

在 Python 中，我们可以使用 `functools` 包中的 `lru_cache` 修饰符。如果你对此不熟悉，你可以看看这个 [Python 文档](https://docs.python.org/3/library/functools.html#functools.lru_cache)。它非常有用！

下面是使用它的代码。

```Python
from functools import lru_cache

class Solution:
    def minCost(self, costs):
        """
        :type costs: List[List[int]]
        :rtype: int
        """

        @lru_cache(maxsize=None)
        def paint_cost(n, color):
            total_cost = costs[n][color]
            if n == len(costs) - 1:
                pass
            elif color == 0:
                total_cost += min(paint_cost(n + 1, 1), paint_cost(n + 1, 2))
            elif color == 1:
                total_cost += min(paint_cost(n + 1, 0), paint_cost(n + 1, 2))
            else:
                total_cost += min(paint_cost(n + 1, 0), paint_cost(n + 1, 1))
            return total_cost

        if costs == []:
            return 0
        return min(paint_cost(0, 0), paint_cost(0, 1), paint_cost(0, 2))
```

**复杂度分析**

-   时间复杂度：$O(n)$。
    
    分析记忆算法一开始可能很棘手，需要了解递归如何以不同于循环的方式影响成本。需要注意的关键一点是，对于每个可能的参数集，函数完整运行一次。有 `3*n` 组不同的参数，因为有 `n` 套房子和 `3` 种颜色。因为函数体是 $O(1)$(它只是一个条件)，所以我们总共得到了 `3*n`。在记忆化字典中搜索的次数也不能超过 `3*2*n`。树清楚地显示了这一点--表示查找的节点必须是执行完整计算的调用的子节点。因为所有常量都被删除了，所以只剩下 $O(N)$。
    
-   空间复杂度：$O(n)$
    
    与前面的方法一样，主要的空间使用在堆栈上。当我们向下查看函数调用的第一个分支时(请参见树可视化)，我们将在字典中找不到任何结果。因此，每家每户都会做一个堆栈框架。因为有 `n` 个房子，所以最坏情况下的空间使用量为 $O(N)$。请注意，这在诸如 Python 之类的语言中可能是一个问题，因为在这些语言中，堆栈帧很大。
    
___

#### 方法 4：动态规划

**概述**

在方法 2 中，我们从自下而上算法开始，尽管实际上并没有实现。我们没有实现它的原因是因为我们必须生成一个实际的树，这将是大量的工作，并且对于我们试图实现的目标来说是不必要的。然而，还有另一种编写迭代自底向上算法来解决此问题的方法。它使用的模式与我们在方法 3 中确定的模式相同。

作为起点，如果我们将树转换成没有重复的有向图，它会是什么样子？换句话说，如果我们这样做，第二个房子是蓝色的，第一个房子是绿色的，第一个房子是红色的？嗯，它看起来就像这样。

![dp_collapsed_tree.png](https://pic.leetcode.cn/1692353238-jDTQml-dp_collapsed_tree.png){:width=400}

直接生成这个图(即不首先生成大树)，然后使用与方法2相同的算法，可以获得与方法 3 相当的时间复杂度。但有一种甚至不需要生成图形的简单得多的方法：动态规划！动态规划是迭代的，与记忆法不同，记忆法是递归的。

我们将定义一个子问题来计算特定房屋位置和颜色的总成本。

对于 4 栋房子的例子，回忆法总共需要解决 12 个不同的子问题。我们知道这一点，因为颜色有 3 个可能的值(0，1，2)，门牌号有 4 个可能的值(0，1，2，3)。总而言之，这给了我们 12 种不同的可能性。动态规划方法将需要解决这些相同的子问题，以迭代的方式。

![dp_func_call_grid.png](https://pic.leetcode.cn/1692353197-LfbXjN-dp_func_call_grid.png){:width=400}

现在，还记得输入数组的大小吗？都是一样的！另外，请注意它如何映射到树上。再说一次，这是一样的。

![dp_in_grid.png](https://pic.leetcode.cn/1692353204-OGzmVs-dp_in_grid.png){:width=400}

因此，我们可以从门牌号最高的子问题开始计算每个子问题的成本，并将结果直接写入输入数组。实际上，我们将用粉刷该颜色的房子的成本和粉刷之后所有房子的最小成本来替换数组中的每个单栋房子的成本。这和我们在树上做的几乎是一样的。唯一的区别是，我们每个计算只做一次，并且我们将结果直接写入输入表。它是自下而上的，因为我们首先解决“较低”的问题，一旦我们解决了它们所依赖的所有较低的问题，就再解决“较高”的问题。

首先要意识到的是，我们不需要对最后一行做任何操作。就像在树上一样，这些成本就是总成本，因为在它们之后没有更多的房子了。

![dp_last_already_done.png](https://pic.leetcode.cn/1692353277-wdNeqw-dp_last_already_done.png){:width=400}

现在，倒数第二排怎么样？好吧，我们知道如果我们把房子漆成红色，它本身就会花费，而下一排蓝色和绿色的最便宜的是 8。所以总成本是 14，我们可以把它放入单元格。

![dp_calc_example.png](https://pic.leetcode.cn/1692353296-yEVUpk-dp_calc_example.png){:width=400}

就像我们处理树一样，我们可以在网格中向上移动，重复应用相同的算法来确定每个单元格的总值。一旦我们更新了所有的单元格，我们只需要从第一行取最小值并返回它。这是一个展示这一过程的动画。

**算法步骤**

算法简单明了。我们向后迭代网格中的所有行(从倒数第二行开始)，并按照动画中所示的方式计算每个单元格的总成本。

<![Slide1.PNG](https://pic.leetcode.cn/1692353441-RHZARJ-Slide1.PNG){:width=400},![Slide2.PNG](https://pic.leetcode.cn/1692353445-GlZGfr-Slide2.PNG){:width=400},![Slide3.PNG](https://pic.leetcode.cn/1692353452-VBpjCB-Slide3.PNG){:width=400},![Slide4.PNG](https://pic.leetcode.cn/1692353456-cFifEs-Slide4.PNG){:width=400},![Slide5.PNG](https://pic.leetcode.cn/1692353461-ijGuTW-Slide5.PNG){:width=400},![Slide6.PNG](https://pic.leetcode.cn/1692353471-yTARmM-Slide6.PNG){:width=400},![Slide7.PNG](https://pic.leetcode.cn/1692353476-KOKTcu-Slide7.PNG){:width=400},![Slide8.PNG](https://pic.leetcode.cn/1692353480-siuDkr-Slide8.PNG){:width=400},![image.png](https://pic.leetcode.cn/1692353577-UuJRjX-image.png){:width=400},![Slide10.PNG](https://pic.leetcode.cn/1692353583-HnLbVQ-Slide10.PNG){:width=400},![Slide11.PNG](https://pic.leetcode.cn/1692353594-zaMgLE-Slide11.PNG){:width=400},![Slide12.PNG](https://pic.leetcode.cn/1692353598-qOPPGN-Slide12.PNG){:width=400},![Slide13.PNG](https://pic.leetcode.cn/1692353602-uMuvxD-Slide13.PNG){:width=400},![Slide14.PNG](https://pic.leetcode.cn/1692353605-qsysJI-Slide14.PNG){:width=400},![Slide15.PNG](https://pic.leetcode.cn/1692353609-GYDfMw-Slide15.PNG){:width=400},![Slide16.PNG](https://pic.leetcode.cn/1692353612-PjGuJS-Slide16.PNG){:width=400},![Slide17.PNG](https://pic.leetcode.cn/1692353616-JmEUKN-Slide17.PNG){:width=400},![image.png](https://pic.leetcode.cn/1692353682-BoUtCS-image.png){:width=400}>

```Java [sol4-Java]
class Solution {
    public int minCost(int[][] costs) {

        for (int n = costs.length - 2; n >= 0; n--) {
            // 把第 n 栋房子漆成红色的总成本。
            costs[n][0] += Math.min(costs[n + 1][1], costs[n + 1][2]);
            // 把第 n 栋房子漆成绿色的总成本。
            costs[n][1] += Math.min(costs[n + 1][0], costs[n + 1][2]);
            // 把第 n 栋房子漆成蓝色的总成本。
            costs[n][2] += Math.min(costs[n + 1][0], costs[n + 1][1]);
        }

        if (costs.length == 0) return 0;   

        return Math.min(Math.min(costs[0][0], costs[0][1]), costs[0][2]);
    }
}
```

```Python [sol1-Python]
def minCost(self, costs: List[List[int]]) -> int:    
    for n in reversed(range(len(costs) - 1)):
        # 把第 n 栋房子漆成红色的总成本。
        costs[n][0] += min(costs[n + 1][1], costs[n + 1][2])
        # 把第 n 栋房子漆成绿色的总成本。
        costs[n][1] += min(costs[n + 1][0], costs[n + 1][2])
        # 把第 n 栋房子漆成蓝色的总成本。
        costs[n][2] += min(costs[n + 1][0], costs[n + 1][1])

    if len(costs) == 0: return 0
    return min(costs[0]) # 返回第一行中的最小值。
```

你还可以避免对颜色进行硬编码，而是在颜色上迭代。这一方法将在后续问题的解决方案文章中介绍，在该问题中，颜色不是只有 3 种，而是 `m` 种。

**复杂度分析**

-   时间复杂度：$O(n)$
    
    找到两个值中的最小值并将其与另一个值相加是一种 $O(1)$ 操作。我们正在对网格中的 $3 \cdot (n−1)$个单元执行这些 $O(1)$ 操作。将其展开，我们得到 $3 \cdot n-3$。这些常量在大 O 表示法中并不重要，所以我们去掉它们，只剩下 $O(N)$。
    
    _警告一句：_ 如果有 $m$ 种颜色，这是不正确的。对于这个特殊的问题，我们被告知只有 3 种颜色。然而，一个合乎逻辑的后续问题将是使代码对任何数量的颜色起作用。在这种情况下，时间复杂度实际上是 $O(n\cdot m)$，因为 $m$ 不是常量，而 3 是常量。如果这让你感到困惑，我建议你好好读一读大 O 表示法。
    
-   空间复杂度：$O(1)$
    
    我们没有分配任何新的数据结构，并且只使用了几个局部变量。所有工作都直接在输入数组中完成。因此，该算法是适当的，需要不断的额外空间。
    

  

___

#### 方法 5：空间优化的动态规划

**概述**

覆盖输入数组并不总是可取的。例如，如果其他函数也需要使用相同的数组，该怎么办？
我们可以分配我们自己的数组，然后以与方法 4 相同的方式继续。这将使我们的空间复杂性达到 $O(N)$(出于同样的原因，时间复杂性是 $O(N)$，常量以大 O 表示法丢弃)。
然而，使用 $O(N)$ 空间并不是必须的-我们可以进一步优化空间复杂性。还记得动态规划是如何将行空白以显示我们将不再查看它们的吗？我们只需要查看前一行，以及我们当前正在处理的行。其余的可能都被扔掉了。因此，为了避免覆盖输入，我们将前一行和当前行作为长度为 3 的数组进行跟踪。
这种空间优化技术适用于许多动态规划问题。一般来说，我建议首先尝试提出一个具有最佳时间复杂性的算法，然后再看看是否可以降低空间复杂性。

**算法步骤**

这取决于你是使用长度为 3 的数组还是使用变量。不过，在编写干净的代码方面，数组更好。如果你被要求让算法对 $m$ 种颜色起作用，它们也会更容易适应。我在这里选择使用数组，因为跟踪 6 个独立的变量太杂乱了。

`previous_row` 作为输入数组的最后一行开始。`current_row` 是 `n` 当前所在的行(从倒数第二行开始)。在每一步中，我们都会通过添加 `previous_row` 中的值来更新 `current_row` 中的值。然后，我们将 `previous_row` 设置为 `current_row`，然后继续到 `n` 的下一个值，在该值中我们重复该过程。最后，第一行将位于 `previous_row` 变量中，因此我们将像以前一样找到最小值。

请注意，我们必须小心，不要无意中覆盖 `costs` 数组。我们从数组中取出的要写入的任何行都需要是副本。这可以使用 Java 中的 `clone`(适用于整数等基本类型的数组)和 Python 语言中的`copy.deepcopy` 来实现。



```Java [slu5]
class Solution {
    public int minCost(int[][] costs) {

        if (costs.length == 0) return 0;

        int[] previousRow = costs[costs.length -1];

        for (int n = costs.length - 2; n >= 0; n--) {

            int[] currentRow = costs[n].clone();
            // 把第 n 栋房子漆成红色的总成本。
            currentRow[0] += Math.min(previousRow[1], previousRow[2]);
            // 把第 n 栋房子漆成绿色的总成本。
            currentRow[1] += Math.min(previousRow[0], previousRow[2]);
            // 把第 n 栋房子漆成蓝色的总成本。
            currentRow[2] += Math.min(previousRow[0], previousRow[1]);
            previousRow = currentRow;
        }  

        return Math.min(Math.min(previousRow[0], previousRow[1]), previousRow[2]);
    }
}
```

```Python [slu5]
import copy

class Solution:
    def minCost(self, costs: List[List[int]]) -> int:

        if len(costs) == 0: return 0

        previous_row = costs[-1]
        for n in reversed(range(len(costs) - 1)):

            current_row = copy.deepcopy(costs[n])
            # 把第 n 栋房子漆成红色的总成本
            current_row[0] += min(previous_row[1], previous_row[2])
            # 把第 n 栋房子漆成绿色的总成本。
            current_row[1] += min(previous_row[0], previous_row[2])
            # 把第 n 栋房子漆成蓝色的总成本。
            current_row[2] += min(previous_row[0], previous_row[1])
            previous_row = current_row

        return min(previous_row)
```

```C++ [slu5]
class Solution {
public:
    int minCost(vector<vector<int>>& costs) {
        if(costs.size()==0){
            return 0;
        }
        auto previousRow = costs.back();
        for(int n = costs.size()-2;n>=0;n--){
            auto currentRow = costs[n];
            // 把第 n 栋房子漆成红色的总成本。
            currentRow[0] += min(previousRow[1], previousRow[2]);
            // 把第 n 栋房子漆成绿色的总成本。
            currentRow[1] += min(previousRow[0], previousRow[2]);
            // 把第 n 栋房子漆成蓝色的总成本。
            currentRow[2] += min(previousRow[0], previousRow[1]);
            previousRow = currentRow;
        }
        return *min_element(previousRow.begin(),previousRow.end());
    }
};
```

```Golang [slu5]
func minCost(costs [][]int) int {
    if len(costs)== 0{
        return 0
    }
    previousRow:=costs[len(costs)-1]
    for n:=len(costs)-2;n>=0;n--{
        currentRow:=costs[n]
        // 把第 n 栋房子漆成红色的总成本。
        currentRow[0] += min(previousRow[1], previousRow[2]);
        // 把第 n 栋房子漆成绿色的总成本。
        currentRow[1] += min(previousRow[0], previousRow[2]);
        // 把第 n 栋房子漆成蓝色的总成本。
        currentRow[2] += min(previousRow[0], previousRow[1]);
        previousRow = currentRow;
    }
    return min(previousRow[0],min(previousRow[1],previousRow[2]))
}

func min(a, b int) int {
    if a > b {
        return b
    }
    return a
}
```

```C [slu5]
int minCost(int** costs, int costsSize, int* costsColSize){
    if(costsSize==0){
        return 0;
    }
    int* previousRow = costs[costsSize-1];
    for(int n=costsSize-2;n>=0;n--){
        int* currentRow = costs[n];
        // 把第 n 栋房子漆成红色的总成本。
        currentRow[0] += fmin(previousRow[1], previousRow[2]);
        // 把第 n 栋房子漆成绿色的总成本。
        currentRow[1] += fmin(previousRow[0], previousRow[2]);
        // 把第 n 栋房子漆成蓝色的总成本。
        currentRow[2] += fmin(previousRow[0], previousRow[1]);
        previousRow = currentRow;
    }
    return fmin(previousRow[0],fmin(previousRow[1],previousRow[2]));
}
```

```C# [slu5]
public class Solution {
    public int MinCost(int[][] costs) {
        if(costs.Length==0){
            return 0;
        }
        int[] previousRow = costs[costs.Length-1];
        for(int n = costs.Length-2;n>=0;n--){
            int[] currentRow = costs[n];
            // 把第 n 栋房子漆成红色的总成本。
            currentRow[0] += Math.Min(previousRow[1], previousRow[2]);
            // 把第 n 栋房子漆成绿色的总成本。
            currentRow[1] += Math.Min(previousRow[0], previousRow[2]);
            // 把第 n 栋房子漆成蓝色的总成本。
            currentRow[2] += Math.Min(previousRow[0], previousRow[1]);
            previousRow = currentRow;
        }
        return Math.Min(Math.Min(previousRow[0],previousRow[1]),previousRow[2]);
    }
}
```

```JavaScript [slu5]
/**
 * @param {number[][]} costs
 * @return {number}
 */
var minCost = function(costs) {
    if(costs.length==0){
        return 0;
    }
    let previousRow = costs[costs.length-1];
    for(let n = costs.length-2;n>=0;n--){
        let currentRow = costs[n];
        // 把第 n 栋房子漆成红色的总成本。
        currentRow[0] += Math.min(previousRow[1], previousRow[2]);
        // 把第 n 栋房子漆成绿色的总成本。
        currentRow[1] += Math.min(previousRow[0], previousRow[2]);
        // 把第 n 栋房子漆成蓝色的总成本。
        currentRow[2] += Math.min(previousRow[0], previousRow[1]);
        previousRow = currentRow;
    }
    return Math.min(Math.min(previousRow[0],previousRow[1]),previousRow[2])
};
```



**复杂度分析**

-   时间复杂度：$O(n)$
    
    与以前的方法相同。
    
-  空间复杂度：$O(1)$
   
    我们一次可以“记住”多达 6 次计算(使用 2 个长度为 3 的数组)。因为这实际上是一个常量，所以空间复杂度仍然是 $O(1)$。
    
    然而，与时间复杂性一样，该分析依赖于颜色的恒定数量(即 3)。如果将问题更改为 $m$ 种颜色，则空间复杂性将变为 $O(M)$，因为我们需要跟踪几个长度为 m 的数组。
    
___

#### 为什么这是一个动态规划问题

许多动态规划问题都有非常简单的解决方案。随着你获得更多的经验，你会对动态规划何时可以解决一个问题有更好的思路，你也会更好地快速识别重叠的子问题(例如，无论第二个房子是蓝色还是红色，将第三个房子漆成绿色的总成本都是相同的)。考虑树结构也有助于识别这些子问题，尽管你并不总是需要像我们在这里所做的那样完全解决它。

请记住，**子问题** 是对递归函数的任何调用。子问题要么作为基本情况解决(在本例中，只需从表中简单查找，无需进一步计算)，要么通过查看一系列下层子问题的解决方案来解决。在动态规划术语中，我们说这个问题有一个 **最优子结构**。这意味着每个 **子问题** 的最优成本是由它下面的 **子问题** 的 **最优成本** 构造的。这也是贪婪算法要发挥作用所必须具备的特性。

例如，如果我们不能选择最小值，并且知道它是最优的(可能是因为它会影响树上更高的选择)，那么就不会有 **最优子结构**。

此外，这个问题还有 **重叠子问题**。这只是意味着较低的子问题通常是共享的(还记得树上有许多看起来相同的分支吗？)

具有 **最优子结构** 的问题可以用贪婪算法来解决。如果它们还有 **重叠子问题**，那么它们可以用动态规划算法来解决。
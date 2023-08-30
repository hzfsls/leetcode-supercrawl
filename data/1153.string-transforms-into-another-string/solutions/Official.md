[TOC]

## 解决方案

---

#### 方法 1：贪心 + 哈希

 **思路**
 我们希望通过一些转换，将字符串 `str1` 转换为 `str2`。我们可以在一次转换中将 `str1` 中的所有字符转为其他小写英文字符。 `str1` 和 `str2`都只包含小写英文字母。
 让我们通过一些例子来更好地理解问题表述和解决方案。
 我们会覆盖所有可能出现的场景并讨论，哪些场景存在有效的转换。然后，我们可以根据这些例子中发现的事实创建规则，帮助我们确定 `str1`是否可以转换为 `str2`。

- *例1：一一映射*
  在第一个例子中，让我们拿两个简单的字符串，他们都只有不同的字符，且每个字符从 `str1` 映射到 `str2`中的另一个字符。

  ![1153A.png](https://pic.leetcode.cn/1692070735-EXOKwN-1153A.png){:width=500}

  在上面的例子中，我们通过四次转换（ `a` 到 `p`，`b` 到 `q`，`c` 到 `r`和 `d` 到 `s`）将 `str1` （"abcd"）转换为 `str2`（"pqrs"）。因此，答案是正确的。  
- *例2：一对多映射*
  如果在 `str1`中的字符是相同的，并且 `str1` 中的相同字符映射到 `str2`中的另一个字符，将会怎么样呢？

  ![1153B.png](https://pic.leetcode.cn/1692070748-Dmofrf-1153B.png){:width=500}

  在上面的例子中，我们有两种可能的方式将字符 `c`转换为`r` 或 `s`。如果遵循第一个转换选项，即 `c` 到 `r`，意味着所有的 `c`都会变为 `r`；因此，我们不能再将 `c`转换为 `s`。
  同样，如果我们使用第二种转换方案（ `c` 到 `s`），我们就不能再将 `c`转换为 `r`。因此，这两种情况不能同时发生。因此，答案为假。
  从这个例子中，我们可以理解，如果字符串 `str1`中的某个字符映射到 `str2`中的两个或更多字符，那么转换就无法实现。
- *例3：链表映射*
  下面的例子稍有不同，因为我们需要处理重叠映射。

  ![image.png](https://pic.leetcode.cn/1692070838-bmXAaa-image.png){:width=500}

  在上面的例子中，我们有5种可能的转换映射。映射形成一个链表，每个连接都表示一种转换。然而，如上所示，如果我们按照链表从左到右的顺序进行转换，我们无法将 `str1` 转换为 `str2`。原因是每次我们进行转换，结果字符会按照后续转换映射转换为另一个字符。因此，我们必须将 `str1` 中的每个字符转换为权值高于未来使用的字符。
  从这个例子中，我们可以得出结论，如果转换映射形成一个链表，我们可以通过逆向转换，将字符串 `str1` 转为 `str2`。
- *例4：循环链表*
  上一个例子中的链表也有可能是循环的。下面的例子演示了这种情况。

  ![image.png](https://pic.leetcode.cn/1692070947-erpyxh-image.png){:width=500}

  在上面的例子中，三种转换映射（ `a` 到 `c`，`c` 到 `b` 和 `b` 到 `a`）形成了一个循环链表，这阻止了我们将 `str1` 转换为 `str2`，无论我们选择从右到左还是从左到右进行转换。原因是没有这样的字符，它不在任何转换映射的左手边，这违反了我们从例3中得到的结论。所以，例如，当我们将 `b` 转换为 `a` 时，我们将 `str1` 中所有的 `b` 转换为 `a`，但是当我们将 `a` 转换为 `c` 时，我们将 `str1` 中所有的 `a` 包括先前用第一个方案转换得到的 `b` 转换为 `c`。所以我们最后将 `b` 映射为 `c` 而不是 `b` 到 `a`。

  ![image.png](https://pic.leetcode.cn/1692071006-FqOsIm-image.png){:width=500}

  为了解决这个问题，我们引入了一个新字符 `z`，而不是直接将 `b` 转换为 `a` ，我们首先将 `b` 转换为 `z`，然后将 `z` 转换为 `a`。这样有利于防止 `b` 转换为 `c`，因为我们将 `b` 转换为 `z`，然后从右到左跟随转换。最后，我们将 `z` 转换为 `a`。
  从上面的例子中，我们得知，如果转换映射形成一个循环链表时，我们必须有一个临时字符来打破这个环。该临时字符不能出现在字符串 `str1`中，否则 `str2` 中的其他字母也会改变。
- *例5：多个循环链表*

  ![1153F.png](https://pic.leetcode.cn/1692071021-EOStdS-1153F.png){:width=500}

  在上面的例子中，有两个链表循环；一个包括转换映射（ `a` 到 `c`，`c` 到 `b` 和 `b` 到 `a`）,另一个包括（ `d` 到 `e`，`e` 到 `f` 和 `f` 到 `d`）。我们注意到，我们可以使用一个 **单独** 的临时字符，`z`，来为两个循环打破环。

  这个例子说明我们只需要 **一个** 临时字符来为所有的环打破环，无论环的数量。因为每个环不包含其他环中的任何相同字母，我们可以一次转换一个环，因此我们可以为所有环使用相同的虚拟字符。
  
- *例6：带 $26$个字母的循环链表*

  ![1153G.png](https://pic.leetcode.cn/1692071035-wHDNAW-1153G.png){:width=500}

  在上图中，转换映射又一次形成了一个循环链表。在之前的例子中，我们发现我们可以通过引入一个临时字符来打破环。但这有一个问题。字符串 `str1` 包含所有 $26$ 个小写英文字母。所以没有临时字符供我们选择。因此，将 `str1` 转换为 `str2` 是不可能的。
  从上面的例子中，我们可能会觉得如果 `str1` 包含了所有的小写英文字母，那么就不可能将 `str1` 转换为 `str2`。但这并不准确。让我们通过一个最后的例子，对此类情况有另一种观点。
- *例7：带有 $26$ 个字母和一个环的链表*

  ![image.png](https://pic.leetcode.cn/1692071158-NUTJVk-image.png){:width=500}
  
  在上面的例子中，`str1` 有 $26$ 个小写英文字母。但是，我们可以将它转换为 `str2`。原因是 `str2` 有 $25$ 个唯一的字母，暗示 string `str1` 中的两个字符映射到相同的字符（`str1` 中的 `y` 和 `z` 映射到 `str2` 中的 `z`）。所以，我们可以采用贪心的方式，将 `y` 转换为 `z` 或者 `z` 转换为 `y`。这样做的想法是要让这两个字符（`y` 和 `z`）保持一致，因为最后，它们都会被转换为 `z`。
  从这个例子中，很明显，即使 `str1` 有 $26$ 个独特的字符，只要 `str2` 有少于 $26$ 个字符，也可以将 `str1` 转换为 `str2`。因为在这种情况下，`str1`中将有多个字符对应 `str2` 中的同一个字符。因此我们可以将所有这些字符转为一个字符，然后 `str1` 中的独特字符数就会少于 $26$ 个。
  因此，如果 `str1` 有 $26$ 个独特的字符并且 `str2` 没有，那么总有办法将 `str1` 转换为 `str2`。
  

 **结论**
 我们可以从上述例子中得出以下结论：要将 `str1` 转换为 `str2`，必须满足以下条件：

 1. `str1` 中的无字符映射到 `str2` 中的多个字符。 
 2. 如果 `str1`中的不同字符数是 $26$，那么 `str2` 中的不同字符数应小于 $26$ 或者 `str1` 等于 `str2`。

 >  **注意：** 如果满足第一条条件，我们不需要检查 `str1` 中的独特字符数（如第二条规定）。假设 `str1` 中的独特字符数为 `|str1|`，而 `str2` 中的为 `|str2|` 那么可以证明，如果 `str1` 没有映射到 `str2` 的两个或更多字符，那么满足 `|str1| >= |str2|` 这个条件。因为如果 `|str1| < |str2|`(`length(str1) = length(str2)`)那么至少有一个字符从 `str1` 映射到 `str2`的两个或更多字符。

 因此，我们可以将要满足的条件修改为下面的形式：

 1. `str1` 中的无字符映射到 `str2` 中的多个字符。 
 2. `str2` 中的独特字符数应严格小于 $26$，除非 `str1` 等于 `str2`。

 **算法**

 1. 计算字符串 `str1`
 2. 对于每个字符:

   - 如果当前字母在映射中不存在，那么在 `conversionMappings` 中存储这个映射，并同时把 `str2`中的对应位置的字母在 HashSet `uniqueCharactersInStr2` 中存储。
   - 如果当前字母在映射中存在，并且其映射到的字符与 `str2`中当前的对应字符不同，那么我们就返回 false。 3.在遍历完所有字符后，如果 HashSet `uniqueCharactersInStr2` 包含 $26$ 个字母，那么返回 false，否则返回 true。

 **实现**

 ```C++ [slu1]
 class Solution {
public:
    bool canConvert(string str1, string str2) {
        if (str1 == str2) {
            return true;
        }
        
        unordered_map<char, char> conversionMappings;
        unordered_set<char> uniqueCharactersInStr2;
        
        // 确保 str1 中的任何字符都没有映射到 str2 中的多个字符。
        for (int i = 0; i < str1.size(); i++) {
            if (conversionMappings.find(str1[i]) == conversionMappings.end()) {
                conversionMappings[str1[i]] = str2[i];
                uniqueCharactersInStr2.insert(str2[i]);
            } else if (conversionMappings[str1[i]] != str2[i]) {
                // 此字母映射到两个不同的字符，因此 str1 无法转换为 str2。
                return false;
            }
        }
        
        // str1 中没有字符映射到 str2 中的两个或多个不同字符
        // 并有至少一个可用于中断任何循环的临时字符。
        if (uniqueCharactersInStr2.size() < 26) {
            return true;
        }
        
        // 转换映射形成一个或多个循环，并且没有可用于中断循环的临时字符，因此 str1 无法转换为 str2。 
        return false;
    }
};
 ```

 ```Java [slu1]
 class Solution {
    public boolean canConvert(String str1, String str2) {
        if (str1.equals(str2)) {
            return true;
        }
        
        Map<Character, Character> conversionMappings = new HashMap<>();
        Set<Character> uniqueCharactersInStr2 = new HashSet<>();
        
        // 确保 str1 中的任何字符都没有映射到 str2 中的多个字符。
        for (int i = 0; i < str1.length(); i++) {
           if (!conversionMappings.containsKey(str1.charAt(i))) {
                conversionMappings.put(str1.charAt(i), str2.charAt(i));
                uniqueCharactersInStr2.add(str2.charAt(i));
            } else if (conversionMappings.get(str1.charAt(i)) != str2.charAt(i)) {
                // 此字母映射到两个不同的字符，因此 str1 无法转换为 str2。
                return false;
            }
        }
        
        // str1 中没有字符映射到 str2 中的两个或多个不同字符
        // 并有至少一个可用于中断任何循环的临时字符。
        if (uniqueCharactersInStr2.size() < 26) {
            return true;
        }

        // 转换映射形成一个或多个循环，并且没有可用于中断循环的临时字符，因此 str1 无法转换为 str2。
        return false;
    }
}
 ```

 ```Python3 [slu1]
 class Solution:
    def canConvert(self, str1: str, str2: str) -> bool:
        if str1 == str2:
            return True
        
        conversion_mappings = dict()
        unique_characters_in_str2 = set()
        
        # 确保 str1 中的任何字符都没有映射到 str2 中的多个字符。
        for letter1, letter2 in zip(str1, str2):
            if letter1 not in conversion_mappings:
                conversion_mappings[letter1] = letter2
                unique_characters_in_str2.add(letter2)
            elif conversion_mappings[letter1] != letter2:
                # letter1 映射到 2 个不同的字符，因此 str1 无法转换为 str2。
                return False
        
        
        if len(unique_characters_in_str2) < 26:
            # str1 中没有字符映射到 str2 中的两个或多个不同字符
            # 并有至少一个可用于中断任何循环的临时字符。
            return True
        
        # 转换映射形成一个或多个循环，并且没有可用于中断循环的临时字符，因此 str1 无法转换为 str2。
        return False
 ```

 **复杂度分析**
 在这里 $N$ 是字符串 `str1` 或 `str2` 的长度，$K$ 是 `str1` 和 `str2` 中最大不同字符的数量。

- 时间复杂度：$O(N)$
  我们遍历字符串 `str1`。然后，我们在一个字典中寻找或插入一个键，这对于每个字符是 $O(1)$ 的时间。 同样，将一个字符添加到 HashSet 中也需要 $O(1)$ 时间。因此，总的时间复杂度是 $O(N)$。
- 空间复杂度：$O(K)$
  字典中存储的映射的最大可能数量为 $K$ 。同时，HashSet 最多包含 $K$ 个字符。因为 $K$ 的最大值在这个问题中是 $26$，我们可以认为空间复杂度是常数。

---
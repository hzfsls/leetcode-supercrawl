[TOC]

 ## 解决方案

---

 #### 方法 1：穷举

 如果一个具有偶数长度的字符串是回文，字符串中的每个字符必须始终出现偶数次。如果字符串的长度是奇数则是回文，除一种字符以外的每个字符必须始终出现偶数次。因此，在回文的情况下，出现奇数次的字符的数量不能超过 1（奇数长度的情况下为 1，偶数长度的情况下为 0）。
 基于上述说法，我们可以找到该问题的解决方案。给定的字符串可能包含几乎所有从 0 到 127 的 ASCII 字符。因此，我们遍历所有从 0 到 127 的字符。对于每个选择的字符，我们再次遍历给定的字符串 $s$ 并找到当前字符在 $s$ 中的出现次数，$ch$。我们还在变量 $\text{count}$ 中跟踪给定字符串 $s$ 中出现奇数次的字符数量。
 如果对于当前考虑的任何字符，其相应的计数，$ch$，恰好是奇数，我们将 $\text{count}$ 的值增加，以反映相同的情况。在任何字符的 $ch$ 值为偶数的情况下，$\text{count}$ 保持不变。
 如果对于任何字符，$count$ 变得大于1，这表明给定的字符串 $s$ 不能导致基于上述推理的回文排列的形成。但是，如果当考虑到所有可能的字符时，$\text{count}$ 的值小于2，这表明可以从给定的字符串 $s$ 形成回文排列。

 ```Java [solution]
public class Solution {
    public boolean canPermutePalindrome(String s) {
        int count = 0;
        for (char i = 0; i < 128 && count <= 1; i++) {
            int ct = 0;
            for (int j = 0; j < s.length(); j++) {
                if (s.charAt(j) == i)
                    ct++;
            }
            count += ct % 2;
        }
        return count <= 1;
    }
}

 ```


 **复杂度分析**

 * 时间复杂度：$O(n)$。我们迭代字符串 $s$ 常数次（128），长度为 $n$,即 $O(128 \cdot n) = O(n)$。
 * 空间复杂度：$O(1)$。使用恒定的额外空间。

---

 #### 方法 2：使用 HashMap

 **算法**
 从上述讨论中，我们知道解决给定问题，我们需要计算给定字符串 $s$ 中出现奇数次的字符数量。为此，我们也可以使用一个哈希表，$\text{map}$。这个 $\text{map}$ 采用 $(\text{character}, \text{number of occurrences of character})$ 的形式。
 我们遍历给定的字符串 $s$。对于在 $s$ 中找到的每个新字符，我们在此字符的 $\text{map}$ 中创建一个新条目，其出现次数为1。无论何时找到相同的字符，我们适当地更新出现次数。
 最后，我们遍历创建的 $\text{map}$ 并找到出现奇数次的字符数。如果这个 $\text{count}$ 在任何步骤上都超过 1，我们就得出结论，字符串 $s$ 的回文排列不可能。但是，如果我们可以在 $\text{count}$ 小于2的情况下到达字符串的结尾，我们就断定 $s$ 的回文排列是可行的。
 以下动画说明了这个过程。

 <![image.png](https://pic.leetcode.cn/1692167175-gYZMAn-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692167177-LjVbbU-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692167180-pvVtiQ-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692167182-uhUpfH-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692167185-RZnjUV-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692167188-sfmqna-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692167191-fjmPvd-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692167193-VEeKxB-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692167196-OdcuHa-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692167199-VmmsYU-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692167202-biJHXO-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692167205-uDKRuD-image.png){:width=400}>

 ```Java [solution]
public class Solution {
 public boolean canPermutePalindrome(String s) {
     HashMap < Character, Integer > map = new HashMap < > ();
     for (int i = 0; i < s.length(); i++) {
         map.put(s.charAt(i), map.getOrDefault(s.charAt(i), 0) + 1);
     }
     int count = 0;
     for (char key: map.keySet()) {
         count += map.get(key) % 2;
     }
     return count <= 1;
 }
}

 ```


 **复杂度分析**

 * 时间复杂度：$O(n)$。我们一次遍历具有 $n$ 个字符的字符串 $s$。 我们还遍历 $\text{map}$，如果 $s$ 中的所有字符都是不同的，那么这个 $\text{map}$ 可以增长到 $n$ 的大小。
 * 空间复杂度：$O(1)$。$\text{map}$ 可以增长到所有不同元素的最大数量。但是，由于不同字符的数量是有界的，因此空间复杂度也是如此。


---

 #### 方法 3：使用数组  

 **算法**
 我们可以使用数组作为 hashmap，而不是使用内建的 Hashmap。为此，我们使用一个长度为128的数组 $\text{map}$。该 $\text{map}$ 的每个索引对应 128 个可能的 ASCII 字符之一。
 我们遍历字符串 $s$ 且适当地在这个 $\text{map}$ 中放入每个字符的出现次数，就像在最后一个例子中那样。然后，我们找出出现奇数次数的字符数量，以确定字符串 $s$ 是否可能是回文排列，就像在之前的方法中一样。

 ```Java [solution]
public class Solution {
    public boolean canPermutePalindrome(String s) {
        int[] map = new int[128];
        for (int i = 0; i < s.length(); i++) {
            map[s.charAt(i)]++;
        }
        int count = 0;
        for (int key = 0; key < map.length && count <= 1; key++) {
            count += map[key] % 2;
        }
        return count <= 1;
    }
}
 ```


 **复杂度分析**

 * 时间复杂度： $O(n)$。我们只遍历一次 $n$长度的字符串 $s$。然后，我们遍历长度为 128（即常数）的 $\text{map}$。
 * 空间复杂度： $O(1)$。用于 $\text{map}$ 的额外空间是大小为 128 的常数。

---

 #### 方法 4：数组 + 单次循环 

 **算法**
 我们在遍历 $s$ 时，而非在首次查找每个元素的出现次数之后再确定 $s$ 中出现次数为奇数的字符的 $\text{count}$ 值，我们可以即时确定 $\text{count}$ 值。
 为此，我们遍历 $s$ 并在 $\text{map}$ 中更新刚刚遇到的字符的出现次数。但是，每当我们更新 $\text{map}$ 中的任何条目时，我们也检查其值是否变为偶数或奇数。我们从值为 0 的 $\text{count}$ 开始。如果刚刚在 $map$ 中更新的条目的值变为奇数，我们就会增加 $\text{count}$ 的值，表明找到了一个出现奇数次的字符。但是，如果此条目恰好为偶数，我们就会减少 $\text{count}$ 的值，表示出现奇数次的字符数量已减少一个。
 但是，在这种情况下，我们需要遍历到字符串的结尾以确定最终结果，而在最后的方法 中，我们可以在 $\text{count}$ 超过 1 的时候停止遍历 $\text{map}$。这是因为，即使在当前时刻出现奇数次数的元素数量可能非常大，但是当我们在字符串 $s$ 中进一步遍历时，它们的出现次数可能会变为偶数。
 最后，我们再次检查 $\text{count}$ 的值是否小于 2，以推断字符串 $s$ 的回文排列是否可能。

 ```Java [solution]
public class Solution {
    public boolean canPermutePalindrome(String s) {
        int[] map = new int[128];
        int count = 0;
        for (int i = 0; i < s.length(); i++) {
            map[s.charAt(i)]++;
            if (map[s.charAt(i)] % 2 == 0)
                count--;
            else
                count++;
        }
        return count <= 1;
    }
}
 ```


 **复杂度分析**

 * 时间复杂度：$O(n)$。我们只遍历一次长度为 $n$ 的字符串 $s$。
 * 空间复杂度：$O(1)$。使用一个 $map$，其大小是常数(128)。

---

 #### 方法 5：集合

 **算法**
 上一种方法的另一种修改方法是使用 $\text{set}$ 来跟踪在 $s$ 中出现奇数次数的元素数量。为此，我们遍历字符串 $s$ 中的字符。每当一个字符的出现次数变为奇数时，我们就在 $\text{set}$ 中放入其条目。之后，如果我们再次找到相同的元素，导致其出现次数为偶数，我们就从 $\text{set}$ 中删除其条目。因此，如果该元素再次出现（表示出现次数为奇数），则其条目将不存在于 $\text{set}$ 中。
 基于这个想法，当我们在字符串 $s$ 中找到一个不在 $\text{set}$ 中的字符（这表示当前这个字符的出现次数是奇数）时，我们在 $\text{set}$ 中放入相应的条目。如果我们找到一个已经存在于 $\text{set}$ 中的字符（这表示当前这个字符的出现次数是偶数），我们就从 $\text{set}$ 中删除对应的条目。
 最后，$\text{set}$ 的大小表明在 $s$ 中出现奇数次的元素数量。如果它小于2，那么字符串 $s$ 的回文排列是可能的，否则不可能。

 ```Java [solution]
public class Solution {
    public boolean canPermutePalindrome(String s) {
        Set < Character > set = new HashSet < > ();
        for (int i = 0; i < s.length(); i++) {
            if (!set.add(s.charAt(i)))
                set.remove(s.charAt(i));
        }
        return set.size() <= 1;
    }
}

 ```


 **复杂度分析**

 * 时间复杂度：$O(n)$。我们只遍历一次长度为 $n$ 的字符串 $s$。
 * 空间复杂度：$O(1)$。$\text{set}$ 可以增长到所有不同元素的最大数量。但是，由于不同字符的数量是有界的，因此空间复杂度也是如此。
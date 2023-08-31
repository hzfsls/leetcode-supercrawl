## [484.寻找排列 中文官方题解](https://leetcode.cn/problems/find-permutation/solutions/100000/xun-zhao-pai-lie-by-leetcode-solution-ejis)

[TOC] 

 ## 解决方案 

---

 #### 方法 1：使用栈

 首先，我们回顾一下给定问题陈述的重要点。对于给定的 $n$，我们需要使用范围在 $(1,n)$ 中的所有整数来生成满足字符串 $s$ 中的模式的这些 $n$ 数字的字典序最小的排列。

 首先，我们注意到，生成的字典序最小的排列（无关于给定的模式 $s$）使用的是 $n$ 个整数，从 $(1,n)$，就是 $[1, 2, 3,.., n]$（比如说 $min$）。因此，在生成所需的排列时，我们可以肯定地说，生成的排列应该尽可能接近 $min$。

 现在，我们还可以注意到，只有在满足模式 $s$ 的条件下，越靠近最有效位的数字越小，生成的数字才会尽可能小。现在，为了理解这些观察如何帮助解决给定问题，我们来看一个简单的例子。

 比如，给定的模式 $s$ 是 `"DDIIIID"`。这对应的 $n=8$。因此，可能的 $min$ 排列将是 `[1, 2, 3, 4, 5, 6, 7, 8]`。现在，为了满足前两个 `"DD"` 模式，我们可以观察到生成最小排序的最佳做法是只重新排列 `1, 2, 3`，因为这些是可以放在生成到目前为止的满足给定排序的最小排序的三个最重要位置的最小数字，这导致现在形成的是 `[3, 2, 1, 4, 5, 6, 7, 8]`。我们可以注意到，将任何大于3的数字放在这些位置上都会导致生成字典序较大的排列，如上所述。

 我们也可以注意到，无论我们如何重新排列前三个 `1, 2, 3`，最后一个数字与下一个数字之间的关系始终满足满足 $s$ 中第一个 `I` 的条件。此外，注意到，直到现在生成的模式已经满足 $s$ 中的子模式 `"IIII"`。这将始终得到满足，因为最初被考虑的 $min$ 数字总是满足递增的条件。

 现在，当我们找到模式 $s$ 中的最后一个 `"D"` 时，我们又需要在最后两个位置进行重新排列，而且我们只需要在这些位置进行重新排列使用的数字 `7, 8`。这是因为，再次，我们想要尽可能地将较大的数字保持在尽可能小的有效位置以生成字典序最小的排序。因此，为了满足最后一个 `"D"`，最后两个数字的最佳排列是 `8, 7` 这将生成 `[3, 2, 1, 4, 5, 6, 8, 7]` 作为所需的输出。

 基于以上的例子，我们可以总结，为了生成所需的排列，我们可以从给定的 $n$ 可以形成的 $min$ 数字开始。然后，为了满足给定的模式 $s$，我们只需要反转 $min$ 数组中的那些子区域，这些子区域在其相应位置的模式中有一个 `D`。

 为了执行这些操作，我们不必一开始就创建 $min$ 数组，因为它只包含按升序的从 $1$ 到 $n$ 的数字。

 为了执行上述操作，我们可以使用 $stack$。我们可以从 $1$ 到 $n$ 考虑数字 $i$。对于每个当前的数字，当我们在模式 $s$ 中找到一个 `D` 时，我们只是将该数字推到 $stack$ 上。这样做是因为，稍后，当我们找到下一个 `I` 时，我们可以从栈中弹出这些数字，从而形成在 $s$ 中与 `D`'s 相对应的那些数字的反向（降序）子模式（如上所述）。

 当我们在模式中遇到一个 `I` 时，如上所述，我们也将当前的数字推到 $stack$ 上，然后弹出 $stack$ 上的所有数字，并将这些数字添加到直到现在形成的结果模式中。

 现在，我们可能会在模式 $s$ 的末尾看到一串 `D`'s。在这种情况下，我们将无法找到结束的 `I` 来弹出 $stack$ 上的数字。因此，最后，我们将值 $n$ 推到堆栈上，然后弹出堆栈上的所有值，并将它们附加到此时此刻形成的结果模式中。现在，如果 $s$ 中的倒数第二个字符是 `I`，那么 $n$ 将正确地添加到结果排列的末尾。如果倒数第二个字符是 `D`，那么附加到结果排列末尾的反转模式将包括最后一个数字 $n$ 来进行反转。在这两种情况下，结果排列都是正确的。

 下面的动画更好地说明了这个过程。

 <![image.png](https://pic.leetcode.cn/1691993330-WzfWmU-image.png){:width=400},![image.png](https://pic.leetcode.cn/1691993333-eAiXRh-image.png){:width=400},![image.png](https://pic.leetcode.cn/1691993335-Plzync-image.png){:width=400},![image.png](https://pic.leetcode.cn/1691993338-gDjRUx-image.png){:width=400},![image.png](https://pic.leetcode.cn/1691993340-WQianR-image.png){:width=400},![image.png](https://pic.leetcode.cn/1691993343-jtsQrK-image.png){:width=400},![image.png](https://pic.leetcode.cn/1691993346-RuRbWj-image.png){:width=400},![image.png](https://pic.leetcode.cn/1691993348-aymevb-image.png){:width=400},![image.png](https://pic.leetcode.cn/1691993353-RhegtB-image.png){:width=400},![image.png](https://pic.leetcode.cn/1691993356-rCDYCI-image.png){:width=400},![image.png](https://pic.leetcode.cn/1691993359-tKcjGz-image.png){:width=400},![image.png](https://pic.leetcode.cn/1691993361-KANDae-image.png){:width=400},![image.png](https://pic.leetcode.cn/1691993365-sYECYh-image.png){:width=400},![image.png](https://pic.leetcode.cn/1691993368-qcmGgc-image.png){:width=400},![image.png](https://pic.leetcode.cn/1691993371-pVwNZR-image.png){:width=400},![image.png](https://pic.leetcode.cn/1691993374-dyBeed-image.png){:width=400},![image.png](https://pic.leetcode.cn/1691993378-NcdiJh-image.png){:width=400},![image.png](https://pic.leetcode.cn/1691993381-JJNCXF-image.png){:width=400},![image.png](https://pic.leetcode.cn/1691993384-HaaOrU-image.png){:width=400},![image.png](https://pic.leetcode.cn/1691993387-OWgHwz-image.png){:width=400}>

 ```Java [slu1]
public class Solution {
    public int[] findPermutation(String s) {
        int[] res = new int[s.length() + 1];
        Stack < Integer > stack = new Stack < > ();
        int j = 0;
        for (int i = 1; i <= s.length(); i++) {
            if (s.charAt(i - 1) == 'I') {
                stack.push(i);
                while (!stack.isEmpty())
                    res[j++] = stack.pop();
            } else
                stack.push(i);
        }
        stack.push(s.length() + 1);
        while (!stack.isEmpty())
            res[j++] = stack.pop();
        return res;
    }
}
 ```

 **复杂度分析** 

 * 时间复杂度：$O(n)$。 $n$ 个数字将从 $stack$ 中被压入和弹出。这里的 $n$ 是指结果排列中的元素数。
 * 空间复杂度：$O(n)$。 在最坏情况下，$stack$ 可以增长到 $n$ 的深度。

---

 #### 方法 2：反转子数组

 **算法步骤** 

 为了反转 $min$ 数组的子区域，如上一个方法中所讨论的，我们也可以首先使用 $min$ 数组初始化结果排列 $res$，也就是以升序填充元素 $(1,n)$。然后，当遍历模式 $s$ 时，我们可以跟踪 $res$ 中对应于模式 $s$ 中的 `D` 的开始和结束索引，并反转 $res$ 中对应于这些索引的的子数组的部分。这背后的推理与上一个方法中讨论的相同。

 以下动画展示了这个过程。

 <![image.png](https://pic.leetcode.cn/1691994434-VzIoHC-image.png){:width=400},![image.png](https://pic.leetcode.cn/1691994438-emBnhh-image.png){:width=400},![image.png](https://pic.leetcode.cn/1691994441-wYRrwA-image.png){:width=400},![image.png](https://pic.leetcode.cn/1691994444-tHWVRg-image.png){:width=400},![image.png](https://pic.leetcode.cn/1691994446-EzeOtI-image.png){:width=400},![image.png](https://pic.leetcode.cn/1691994589-vlEDap-image.png){:width=400},![image.png](https://pic.leetcode.cn/1691994449-jmnAQm-image.png){:width=400},![image.png](https://pic.leetcode.cn/1691994451-FbTsUi-image.png){:width=400},![image.png](https://pic.leetcode.cn/1691994454-gCBkSv-image.png){:width=400},![image.png](https://pic.leetcode.cn/1691994458-qwVprU-image.png){:width=400},![image.png](https://pic.leetcode.cn/1691994461-HAfjZv-image.png){:width=400},![image.png](https://pic.leetcode.cn/1691994464-DFawHZ-image.png){:width=400},![image.png](https://pic.leetcode.cn/1691994467-UgwfVZ-image.png){:width=400},![image.png](https://pic.leetcode.cn/1691994470-XmKsih-image.png){:width=400}>

 ```Java [slu2]
 public class Solution {
    public int[] findPermutation(String s) {
        int[] res = new int[s.length() + 1];
        for (int i = 0; i < res.length; i++)
            res[i] = i + 1;
        int i = 1;
        while (i <= s.length()) {
            int j = i;
            while (i <= s.length() && s.charAt(i - 1) == 'D')
                i++;
            reverse(res, j - 1, i);
            i++;
        }
        return res;
    }
    public void reverse(int[] a, int start, int end) {
        for (int i = 0; i < (end - start) / 2; i++) {
            int temp = a[i + start];
            a[i + start] = a[end - i - 1];
            a[end - i - 1] = temp;
        }
    }
}
 ```

 **复杂度分析** 

 * 时间复杂度：$O(n)$。在最坏情况下，例如 ""DDDDDD""，大小为 $n$ 的结果数组至多被遍历三次。
 * 空间复杂度：$O(1)$。使用的额外空间是常数

---

#### 方法 3：双指针

**算法步骤** 

 在初始化 $res$ 数组一次就使用升序数组的情况下，我们可以节省一次 $res$ 的迭代，如果我们动态填充它。为了做到这一点，我们可以继续用升序数字填充 $res$，当在模式 $s$ 中找到 `I`。 每当我们在模式 $s$ 中找到一个 `D`，我们可以将当前位置（从 1 开始计数）存储在以 $res$ 数组的指针 $j$ 中。现在，每当我们找到第一个 `I`，即在 $res$ 中的 $i^{th}$ 位置（从 1 开始计数）紧随其后的一连串的 `D`，我们知道，$res$ 中从 $j^{th}$ 位置到 $i^{th}$ 位置的元素需要用从 $j$ 到 $i$ 的数字以反向顺序填充。因此，我们可以从 $j^{th}$ 位置开始填充 $res$ 数组，该位置填充的数字是 $i$，然后继续以降序填充，直到达到 $i^{th}$ 位置。通过这种方式，我们可以生成 $res$ 而无需初始化。

 ```Java [slu3]
 public class Solution {
    public int[] findPermutation(String s) {
        int[] res = new int[s.length() + 1];
        res[0]=1;
        int i = 1;
        while (i <= s.length()) {
            res[i]=i+1;
            int j = i;
            if(s.charAt(i-1)=='D')
            {
                while (i <= s.length() && s.charAt(i - 1) == 'D')
                    i++;
                for (int k = j - 1, c = i; k <= i - 1; k++, c--) {
                    res[k] = c;
                }
            }
            else
                i++;
        }
        return res;
    }
}
 ```

**复杂度分析**

 * 时间复杂度：$O(n)$。在最坏情况下，例如 "DDDDDD"，大小为 $n$ 的结果数组至多被遍历两次。
 * 空间复杂度：$O(1)$。使用的额外空间是常数。
## [604.迭代压缩字符串 中文官方题解](https://leetcode.cn/problems/design-compressed-string-iterator/solutions/100000/die-dai-ya-suo-zi-fu-chuan-by-leetcode-s-wpus)
[TOC]

 ## 解决方案

 #### 方法 1：解压字符串

 **算法** 

 在这种方法中，我们对解压后的字符串进行预计算。我们已经产生了解压后的字符串，并将每个压缩字母的解压字母追加到 $res$ 字符串构建器中。为了找到存储在 $res$ 中的解压字符串，我们遍历给定的 $compressedString$。每当我们找到一个字母，我们都根据十进制数学寻找跟在它后面的数字。因此，我们获取到了形成当前解压字符串部分所需的两个元素（字母和计数）。

 现在，我们将看一下如何执行 `next()` 和 `hasNext()` 操作：

 1. `next()`：我们首先检查压缩字符串是否有更多的解压字母待处理。如果没有，`hasNext()` 返回 False， `next()` 返回 ' '。 否则，我们返回$ptr$指向的字母，该字母表示下一个要返回的字母。在返回该字母前，我们还将 $ptr$ 更新为指向 $res$ 中的下一个字母。
 2. `hasNext()`：如果指针 $ptr$ 超越了 $res$ 数组的末尾，它表示在当前索引由 $ptr$ 指向之后的位置上没有更多解压的字母。因此，在这种情况下，我们返回 False。否则，我们返回 True。

 ```Java [slu1]
public class StringIterator {
    StringBuilder res=new StringBuilder();
    int ptr=0;
    public StringIterator(String s) {
        int i = 0;
        while (i < s.length()) {
                char ch = s.charAt(i++);
                int num = 0;
                while (i < s.length() && Character.isDigit(s.charAt(i))) {
                    num = num * 10 + s.charAt(i) - '0';
                    i++;
                }
                for (int j = 0; j < num; j++)
                    res.append(ch);
        }
    }
    public char next() {
        if (!hasNext())
            return ' ';
        return res.charAt(ptr++);
    }
    public boolean hasNext() {
        return ptr!=res.length();
    }
}
 ```

 **性能分析** 

 * 我们预先计算了解压字符串的元素。因此，在这种情况下，所需的空间是 $O(m)$，其中 $m$ 表示解压字符串的长度。
 * 预先计算所需的时间是 $O(m)$，因为我们需要生成长度为 $m$ 的 解压字符串。
 * 一旦预计算完成，`next()` 和 `hasNext()`的执行时间都是 $O(1)$。
 * 此方法可以轻松扩展以包括 `previous()`，`last()` 和 `find()` 操作。所有这些操作都只需要使用索引，因此花费 $O(1)$ 时间。像 `hasPrevious()` 这样的操作也可以轻松的加入进来。
 * 由于一旦预计算完成，`next()` 就需要 $O(1)$ 时间，因此如果需要执行大量的 `next()` 操作，此方法非常有用。然而，如果大部分时间都在执行 `hasNext()` 操作，那么这种方法就没有太多优势，因为不管怎样都需要进行预先计算。
 * 如果解压字符串的长度非常大，那么此方法可能会出现问题。在这种情况下，完全解压的字符串的大小可能会变得如此之大，以至于无法适应内存限制，从而导致内存溢出。

---

 #### 方法 2：预计算

 **算法** 

 在此方法中，首先，我们根据数字（0-9）分割给定的 $compressedString$，并将获取的值（字母）存储在 $chars$ 数组中。我们也根据字母（a-z，A-Z）分割 $compressedString$，并将数字（以字符串形式）存储在 $nums$ 阵列中（将获得的字符串转换为整数）。我们通过匹配正则表达式进行分割。
 预计算步骤是针对正则表达式的。现在，我们将看一下如何实现 `next()` 和 `hasNext()` 操作。

 1. `next()`：每次执行 `next()` 操作时，首先我们检查是否还有更多的字母需要解压。我们通过使用 `hasNext()` 函数来检查。如果没有其他字母，我们只返回' '. 我们用一个指针 $ptr$ 来维护需要返回的下一个字母。如果解压后的字符串中还有其他字母，我们返回 $ptr$ 指向的当前字母。但是，返回此字母之前，我们还减去 $nums[ptr]$ 条目，以表明解压字符串中当前字母的未解决情况减少了一个数。在递减此条目后，如果变为零，它表示解压字符串中不存在当前字母的任何实例。因此，我们更新指针 $ptr$ 以指向下一个字母。
 2. `hasNext()`：对于执行 `hasNext()` 操作，我们只需要检查 $ptr$ 是否已经超出了 $chars$ 数组的末尾。如果是这样，它表示在 $compressedString$ 中不存在更多的压缩字母。因此，在这种情况下，我们返回 False。否则，存在更多的压缩字母。因此，我们在这种情况下返回 True。

 ```Java [slu2]
import java.util.regex.Pattern;
public class StringIterator {
    int ptr = 0;
    String[] chars;int[] nums;
    public StringIterator(String compressedString) {
        nums = Arrays.stream(compressedString.substring(1).split("[a-zA-Z]+")).mapToInt(Integer::parseInt).toArray();;
        chars = compressedString.split("[0-9]+");
    }
    public char next() {
        if (!hasNext())
            return ' ';
        nums[ptr]--;
        char res=chars[ptr].charAt(0);
        if(nums[ptr]==0)
            ptr++;
        return res;
    }
    public boolean hasNext() {
        return ptr != chars.length;
    }
}
 ```

 **性能分析** 

 * 存储预先计算结果所需的空间是 $O(n)$，其中 $n$ 是压缩字符串的长度。$nums$ 和 $chars$ 数组包含总共 $n$ 个元素。
 * 预先计算步骤需要 $O(n)$ 的时间。因此，如果大部分时间都在执行 `hasNext()` 操作，那么这种预先计算结果的方式是不合适的。
 * 预先计算结果完成，`hasNext()` 和 `next()` 需要 $O(1)$ 的时间。
 * 此方法可以扩展以包括 `previous()` 和 `hasPrevious()` 操作，但这需要对当前实现进行一些简单的修改。

---

 #### 方法 3：按需计算

 **算法** 

 在这种方法中，我们不使用正则表达式查找给定 $compressedString$ 的单个组件。我们不进行任何形式的预性计算。每当需要执行一个操作时，从头开始生成所需的结果。因此，操作只在需要时执行。

 我们来看看如何实现所需的操作：

 1. `next()`：我们使用全局指针 $ptr$ 来跟踪 $compressedString$ 中需要处理的下一个压缩字母。我们还使用全局变量 $num$ 来跟踪当前字母的剩余实例数量。每当需要执行 `next()` 操作时，首先我们检查 $compressedString$ 里是否还有更多的未解压字母。如果没有了，我们返回' '。否则，我们检查当前字母是否还有更多的实例待处理。如果有，我们直接递减 $nums$ 表明实例数，并返回当前字母。但是，如果当前字母没有更多的实例待处理，我们更新 $ptr$ 以指向 $compressedString$ 中的下一个字母。我们也通过从 $compressedString$ 中获取下一个字母的计数来更新 $num$。这个数字由十进制算法获取。
 2. `hasNext()`：如果指针 $ptr$ 已经到达了 $compressedString$ 的最后一个索引，并且 $num$ 变为 0，那么说明在压缩字符串中没有更多的未压缩字母。因此，在这种情况下，我们返回 False 值。否则，返回 True 值，表明 $compressedString$ 存在更多的压缩字母。

 ```Java [slu3]
public class StringIterator {
    String res;
    int ptr = 0, num = 0;
    char ch = ' ';
    public StringIterator(String s) {
        res = s;
    }
    public char next() {
        if (!hasNext())
            return ' ';
        if (num == 0) {
            ch = res.charAt(ptr++);
            while (ptr < res.length() && Character.isDigit(res.charAt(ptr))) {
                num = num * 10 + res.charAt(ptr++) - '0';
            }
        }
        num--;
        return ch;
    }
    public boolean hasNext() {
        return ptr != res.length() || num != 0;
    }
}

 ```

 **性能分析** 

 * 由于没有进行预计算，因此这种情况只需要常量空间。
 * `next()` 操作所需的时间是 $O(1)$。
 * `hasNext()` 操作所需的时间是 $O(1)$。
 * 由于没有进行预计算，并且 `hasNext()` 只需要 $O(1)$ 时间，因此如果大部分情况下执行 `hasNext()` 操作，这个解决方案就很有优势。
 * 这种方法可以扩展为包括 `previous()` 和 `hasPrevious()` 操作，但需要使用一些额外的变量。
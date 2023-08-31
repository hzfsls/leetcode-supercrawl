## [548.将数组分割成和相等的子数组 中文官方题解](https://leetcode.cn/problems/split-array-with-equal-sum/solutions/100000/jiang-shu-zu-fen-ge-cheng-he-xiang-deng-zu5fi)
[TOC]

## 解决方案

---

 #### 方法 1：暴力解决 [超出时间限制]
 **算法**
 在我们开始解决这个问题的任何方法之前，首先我们需要看一下在给定的一组约束条件下对 $i$，$j$ 和 $k$ 的限制。以下图表显示了 $i$, $j$ 和 $k$ 可以假定的最大值和最小值。

 ![638_Split_Array.PNG](https://pic.leetcode.cn/1692243410-ibkFOr-638_Split_Array.PNG){:width=400}

 因此，现在可以根据数组长度 $n$ 重写这些限制：
 $1≤ i ≤ n −6$
 $i + 2≤ j ≤ n −4$
 $j + 2≤ k ≤ n −2$
 在讨论了我们将在给定数组 $nums$ 上应用的切割 $i$，$j$，$k$ 的限制之后，让我们看一下我们的第一个解决方案。
 我们只需遍历数组的所有元素。我们考虑所有可能的子数组，注意满足给定的等于总和四元组条件的切割的约束，并检查是否存在这样的切割。

 ```Java [slu1]
public class Solution {

    public int sum(int[] nums, int l, int r) {
        int summ = 0;
        for (int i = l; i < r; i++)
            summ += nums[i];
        return summ;
    }

    public boolean splitArray(int[] nums) {
        if (nums.length < 7)
            return false;
        for (int i = 1; i < nums.length - 5; i++) {
            int sum1 = sum(nums, 0, i);
            for (int j = i + 2; j < nums.length - 3; j++) {
                int sum2 = sum(nums, i + 1, j);
                for (int k = j + 2; k < nums.length - 1; k++) {
                    int sum3 = sum(nums, j + 1, k);
                    int sum4 = sum(nums, k + 1, nums.length);
                    if (sum1 == sum2 && sum3 == sum4 && sum2 == sum4)
                        return true;
                }
            }
        }
        return false;
    }
}
 ```

 **复杂度分析**

 * 时间复杂度： $O(n^4)$。四个 for 循环，每个最坏运行长度 $n$。
 * 空间复杂度： $O(1)$。需要常数空间。

---

 #### 方法 2：累积求和 [超出时间限制]
 **算法**
 在暴力解决方法中，我们为每个考虑的三元组遍历了子数组。而不是这样做，如果我们使用累计求和数组 $sum$，那么我们可以节省一些计算工作，在该数组中，$sum[i]$ 存储数组 $nums$ 至 $i^{th}$ 元素的累计和。因此，现在为了找到 $sum\big(subarray(i:j)\big)$，我们可以简单地使用 $sum[j]-sum[i]$。其他过程保持不变。

 ```Java [slu2]
public class Solution {
    public boolean splitArray(int[] nums) {
        if (nums.length < 7)
            return false;
        int[] sum = new int[nums.length];
        sum[0] = nums[0];
        for (int i = 1; i < nums.length; i++) {
            sum[i] = sum[i - 1] + nums[i];
        }
        for (int i = 1; i < nums.length - 5; i++) {
            int sum1 = sum[i - 1];
            for (int j = i + 2; j < nums.length - 3; j++) {
                int sum2 = sum[j - 1] - sum[i];
                for (int k = j + 2; k < nums.length - 1; k++) {
                    int sum3 = sum[k - 1] - sum[j];
                    int sum4 = sum[nums.length - 1] - sum[k];
                    if (sum1 == sum2 && sum3 == sum4 && sum2 == sum4)
                        return true;
                }
            }
        }
        return false;
    }
}
 ```

 **复杂度分析**

 * 时间复杂度：$O(n^3)$。有三个 for 循环。
 * 空间复杂度：$O(n)$。在 $sum$ 数组中存储累积求和，数组大小为 $n$。

---

 #### 方法 3：稍微改进的方法 [超出时间限制]

 **算法**
 如果我们在到目前为止形成的第一部分和第二部分有相等的和时停止检查进一步的四元组，那么我们可以在一定程度上改进之前的实现。当前的实现使用了这个想法。

 ```Java [slu3]
 public class Solution {
    public boolean splitArray(int[] nums) {
        if (nums.length < 7)
            return false;

        int[] sum = new int[nums.length];
        sum[0] = nums[0];
        for (int i = 1; i < nums.length; i++) {
            sum[i] = sum[i - 1] + nums[i];
        }
        for (int i = 1; i < nums.length - 5; i++) {
            int sum1 = sum[i - 1];
            for (int j = i + 2; j < nums.length - 3; j++) {
                int sum2 = sum[j - 1] - sum[i];
                if (sum1 != sum2)
                    continue;
                for (int k = j + 2; k < nums.length - 1; k++) {
                    int sum3 = sum[k - 1] - sum[j];
                    int sum4 = sum[nums.length - 1] - sum[k];
                    if (sum3 == sum4 && sum2 == sum4)
                        return true;
                }
            }
        }
        return false;
    }
}
 ```

 **复杂度分析**

 * 时间复杂度: $O(n^3)$。有三个循环。
 * 空间复杂度：$O(n)$。在 $sum$ 数组中存储累积求和，数组大小为 $n$。

---

 #### 方法 4：使用哈希图 [超出时间限制]
 **算法**
 在这个方法中，我们创建了一种叫做 $map$ 的数据结构，它只是一个 HashMap，数据按以下格式排列：
 $\big\{csum(i):[i_1,i_2,i_3,....]\big\}$，这里 $csum(i)$ 表示在给定的数组 $nums$ 中直到 $i^{th}$ 索引的累积和，它的相应值代表累积求和=csum(i) 的索引。
 一旦我们创建了这个 $map$，解决方案就简化了很多。我们只考虑第一和第二段所产生的切割(i,j)。然后，直到 $(j-1)^{th}$ 索引的累积和将由以下公式给出：$csum(j-1)=sum(part1) + nums[i] + sum(part2)$。现在，如果我们希望前两部分有相同的和，那么可以将相同的累积和重写为：
 $csum'(j-1) = csum(i-1) + nums[i] + csum(i-1) = 2csum(i-1) + nums[i]$。
 因此，我们遍历给定的数组，改变形成第一个切割的指数值 $i$，并查看最初形成的 $map$ 中是否包含一个等于 $csum'(j-1)$ 的累积和。 如果 $map$ 包含这样一个累积求和，我们就考虑所有可能的指数 $j$，看看第一的累积求和与第三和第四部分的等式是否满足。
 按照上面的讨论，由 $k^{th}$ 索引的第三次切割的累积和由以下公式给出：
 $csum(k-1) = sum(part1) + nums[i] + sum(part2) + nums[j] + sum(part3)$。
 为了满足相等性的条件：
 $csum'(k-1) = 3*csum(i-1) + nums[i] + nums[j]$。
 同样地，直到最后一个索引的累积和变为：
 $csum(end) = sum(part1) + nums[i] + sum(part2) + nums[j] + sum(part3) + nums[k] + sum(part4)$。
 同样地，相等的条件就变成了：
 $csum'(end) = 4*csum(i-1) + nums[i] + nums[j] + nums[k]$。
 对于每一次选择的切割，我们都会查看在 $map$ 中是否存在需要的累积求和。 因此，我们不需要再去计算求和或者为所有可能的三元组 $(i, j, k)$ 遍历数组。相反，我们现在只需要知道在$map$中查找什么样的累积和，这大大减少了计算量。

 ```Java [slu4]
 public class Solution {
    public boolean splitArray(int[] nums) {
        HashMap < Integer, ArrayList < Integer >> map = new HashMap < > ();
        int summ = 0, tot = 0;
        for (int i = 0; i < nums.length; i++) {
            summ += nums[i];
            if (map.containsKey(summ))
                map.get(summ).add(i);
            else {
                map.put(summ, new ArrayList < Integer > ());
                map.get(summ).add(i);
            }
            tot += nums[i];
        }
        summ = nums[0];
        for (int i = 1; i < nums.length - 5; i++) {
            if (map.containsKey(2 * summ + nums[i])) {
                for (int j: map.get(2 * summ + nums[i])) {
                    j++;
                    if (j > i + 1 && j < nums.length - 3 && map.containsKey(3 * summ + nums[i] + nums[j])) {
                        for (int k: map.get(3 * summ + nums[j] + nums[i])) {
                            k++;
                            if (k < nums.length - 1 && k > j + 1 && 4 * summ + nums[i] + nums[j] + nums[k] == tot)
                                return true;
                        }
                    }
                }
            }
            summ += nums[i];
        }
        return false;
    }
}
 ```

 **复杂度分析**
 * 时间复杂度：$O(n^3)$。有三个内嵌的循环，每个循环在最坏的情况下都要运行 $n$ 次。观察最糟糕的情况 [0,0,0....,1,1,1,1,1,1,1]。
 * 空间复杂度：$O(n)$。HashMap 大小可以达到 $n$。

---

 #### 方法 5：使用累计求和和哈希集 [接受]
 **算法**
 在这个方法中，首先我们建立一个累计求和数组 $sum$，其中 $sum[i]$ 存储数组 $nums$ 至 $i^{th}$ 索引的累计求和。然后，我们开始遍历 $j$ 形成的中间砍的可能位置。 对于每一个 $j$，首先，我们找到所有导致第一和第二部分和相等的左切线的位置 $i$（i.e. $sum[i-1] = sum[j-1] - sum[i]$）并将此类和存储在 $set$ 中（对于每个所选的 $j$ 形成一个新的哈希集）。因此，$set$ 中有和的存在意味着对于当前位置的中间切（$j$），这样的和可能使第一和第二部分相等。
 然后，我们去找右切线并找到导致第三和第四部分和相等（$sum[n-1]-sum[k]=sum[k-1]-sum[j]$）的右切线位置，对于之前选中的中间切线。我们同时看看相同的和是否存在于 $set$ 中。如果有，那么就存在这样一个三元组 $（i，j，k）$，它满足要求的标准，否则不。
 查看下面的动画以对此过程有一个视觉的表示：

 <![image.png](https://pic.leetcode.cn/1692244220-yhLCSf-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692244232-rzTZIf-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692244236-jUEolC-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692244239-MvJmtT-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692244241-INHdPD-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692244244-LdNmhN-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692244247-hRAnxW-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692244250-NqCHFW-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692244253-QbRCNA-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692244257-SSXOxU-image.png){:width=400}>

 ```Java [slu5]
 public class Solution {
    public boolean splitArray(int[] nums) {
        if (nums.length < 7)
            return false;
        int[] sum = new int[nums.length];
        sum[0] = nums[0];
        for (int i = 1; i < nums.length; i++) {
            sum[i] = sum[i - 1] + nums[i];
        }
        for (int j = 3; j < nums.length - 3; j++) {
            HashSet < Integer > set = new HashSet < > ();
            for (int i = 1; i < j - 1; i++) {
                if (sum[i - 1] == sum[j - 1] - sum[i])
                    set.add(sum[i - 1]);
            }
            for (int k = j + 2; k < nums.length - 1; k++) {
                if (sum[nums.length - 1] - sum[k] == sum[k - 1] - sum[j] && set.contains(sum[k - 1] - sum[j]))
                    return true;
            }
        }
        return false;
    }
}
 ```

 **复杂度分析**

 * 时间复杂度：$O(n^2)$。有一个外循环和两个内循环。
 * 空间复杂度：$O(n)$。哈希集的大小可以达到 $n$。
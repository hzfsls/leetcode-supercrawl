[TOC]

 ## 解决方案

---

 #### 方法 1：枚举 [超出时间限制]

 最简单的解决方案是考虑所有可能的 32 位数字，从 1 开始，满足给定的条件。为了检查这一点，我们获取每个这样的数字的每一位数，检查他们的乘积是否等于给定的数字 $a$。类似的情况一开始就找到，我们就返回相同的结果。如果没有找到这样的 32 位数字，我们返回 0。

 ```Java [slu1]
public class Solution {
    public int smallestFactorization(int a) {
        for (int i = 1; i < 999999999; i++) {
            long mul = 1, t = i;
            while (t != 0) {
                mul *= t % 10;
                t /= 10;
            }
            if (mul == a && mul <= Integer.MAX_VALUE)
                return i;
        }
        return 0;
    }
}

 ```


 **复杂性分析**

 * 时间复杂度：$O(9999999999)$。对于质数，循环可以遍历到这个大的数字。
 * 空间复杂度：$O(1)$。使用的空间是常数。

---

 #### 方法 2：深度优先搜索 [超出时间限制]

**算法**

我们可以对方法 1 中的枚举进行优化，每次枚举数的某一位，通过深度优先搜索的方式找出答案。

我们首先可以挖掘出答案 b 的一些性质。

如果 a 大于 1，那么 b 中不会包含数字 1；
b 中的数字从低位向高位看是单调不增的。例如 2833 一定不可能是答案，因为将这四个数字排成从低位到高位单调不增的 2338 比 2833 更小。
因此，我们可以从最低位数字（个位数字）开始枚举答案，并且每一位数字的取值下界为它右侧的数字 2，上界为它右侧的数字（如果右侧没有数字，则上界为 9），优先枚举大的数字。如果当前枚举了 k 位数字，并且这 k 个数字的乘积大于 a，我们就需要进行回溯；如果等于 a，那么我们就找到了答案，并且直接跳出搜索，因为如果优先枚举大的数字，第一个找到的答案一定是最小的；如果小于 a，那我们枚举第 k + 1 位并继续进行深度优先搜索。

 <![image.png](https://pic.leetcode.cn/1691740000-XqKezO-image.png){:width=400},![image.png](https://pic.leetcode.cn/1691740005-mnvAzm-image.png){:width=400},![image.png](https://pic.leetcode.cn/1691740007-TUDLrw-image.png){:width=400},![image.png](https://pic.leetcode.cn/1691740009-YlQUnW-image.png){:width=400},![image.png](https://pic.leetcode.cn/1691740011-rLUQGe-image.png){:width=400},![image.png](https://pic.leetcode.cn/1691740015-kXmqCV-image.png){:width=400},![image.png](https://pic.leetcode.cn/1691740017-ptLuke-image.png){:width=400},![image.png](https://pic.leetcode.cn/1691740019-IyIkxI-image.png){:width=400},![image.png](https://pic.leetcode.cn/1691740021-keVuYW-image.png){:width=400},![image.png](https://pic.leetcode.cn/1691740024-KdCdkM-image.png){:width=400},![image.png](https://pic.leetcode.cn/1691740026-jJLwwG-image.png){:width=400}>


 ```Java [slu2]
public class Solution {
    long ans;
    public int smallestFactorization(int a) {
        if(a < 2)
            return a;
        int[] dig=new int[]{9, 8, 7, 6, 5, 4, 3, 2};
        if (search(dig, 0, a, 1, """") && ans <= Integer.MAX_VALUE)
            return (int)ans;
        return 0;
    }
    public boolean search(int[] dig, int i, int a, long mul, String res) {
        if (mul > a || i == dig.length )
            return false;
        if (mul == a) {
            ans = Long.parseLong(res);
            return true;
        }
        return search(dig, i, a, mul * dig[i], dig[i] + res) || search(dig, i + 1, a, mul, res);
    }
}

 ```

 **复杂性分析**

 * 时间复杂度：$O(l)$。这里的 $l$ 是指所有的组合。
 * 空间复杂度：$O(log(a))$。在最糟糕的情况下，递归树的深度可以达到 $O(log(a))$。

---

 #### 方法 3：使用因子分解

 **算法**
 我们知道最后生成的数字，$res$，应该是这样的，它的位数的乘积等于给定的数字 $a$。换句话说，$res$ 的数字会是给定的数字 $a$ 的因数（不一定是素数）。因此，我们的问题就简化为找到 $a$ 的因数（并找到这些因数可能的最小排列）。因此，我们首先尝试用最大可能的因数 $9$，在 $res$ 中尽可能多的获得这个因数的数量，并将得到的因数放在它的最不重要位置。然后，我们开始减小当前考虑的可能因数的数目，如果它是一个因数，我们将它放在 $res$ 中相对更重要的位置。我们继续获取这样的因数，直到我们考虑了所有从9到2的数字。在最后，$res$ 就是我们所需要的结果。

 ```Java [slu3]
public class Solution {
    public int smallestFactorization(int a) {
        if (a < 2)
            return a;
        long res = 0, mul = 1;
        for (int i = 9; i >= 2; i--) {
            while (a % i == 0) {
                a /= i;
                res = mul * i + res;
                mul *= 10;
            }
        }
        return a < 2 && res <= Integer.MAX_VALUE ? (int)res : 0;
    }
}
 ```

 **复杂性分析**

 * 时间复杂度：$O(8loga)$。外部循环只会迭代8次，而内部循环在特定的 $i$ 下需要 $O(logi)$。
 * 空间复杂度：$O(1)$。使用的是常数空间。
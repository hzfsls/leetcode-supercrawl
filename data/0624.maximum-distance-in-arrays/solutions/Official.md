[TOC]
 ## 解决方案

---
 #### 方法 1 暴力解法（超时）
 简单的解决办法是从每个数组 $arrays$ 中的每一个元素开始，计算它与除了自身之外的其他所有数组的每一个元素的距离，并找出其中的最大距离。
 ```Java [solution]
class Solution {
    public int maxDistance(List<List<Integer>> arrays) {
        int res = 0;
        int n = arrays.size();
        for (int i = 0; i < n - 1; i++) {
            for (int j = 0; j < arrays.get(i).size(); j++) {
                for (int k = i + 1; k < n; k++) {
                    for (int l = 0; l < arrays.get(k).size(); l++) {
                        res = Math.max(res, Math.abs(arrays.get(i).get(j) - arrays.get(k).get(l)));
                    }
                }
            }
        }
        return res;
    }
}
 ```


 **复杂度分析**
 * 时间复杂度: $O((n*x)^2)$。我们对于每一个数组的元素，都会遍历完 $arrays$ 中的所有数组。这里，$n$ 指的是 $arrays$ 中的数组的数量，$x$ 指的是 $arrays$ 中的每个数组的平均元素个数。
 * 空间复杂度: $O(1)$。只使用了常数级的额外空间。

---
 #### 方法 2 更好的暴力解法（超时）
 **算法**
 在上一个方法 中，我们没有利用到每个数组在 $arrays$ 中都被排序过的事实。因此，我们不需要考虑所有数组(除了数组内部的元素)之间所有元素的距离，我们只需要考虑数组中的第一个(最小元素)和其它数组中最后一个(最大元素)之间的距离，然后从这些距离中找出最大距离。
 ```Java [solution]
class Solution {
    public int maxDistance(List<List<Integer>> arrays) {
        List<Integer> array1, array2;
        int res = 0;
        int n = arrays.size();
        for (int i = 0; i < n - 1; i++) {
            for (int j = i + 1; j < n; j++) {
                array1 = arrays.get(i);
                array2 = arrays.get(j);
                res = Math.max(res, Math.abs(array1.get(0) - array2.get(array2.size() - 1)));
                res = Math.max(res, Math.abs(array2.get(0) - array1.get(array1.size() - 1)));
            }
        }
        return res;
    }
}
 ```


 **复杂度分析**
 * 时间复杂度: $O(n^2)$. 我们只考虑每个数组的最大和最小值。这里，$n$ 指的是 $arrays$ 中的数组的数量。
 * 空间复杂度: $O(1)$. 只使用了常数级的额外空间。

---
 #### 方法 3 单次扫描
 **算法**
 如已经讨论过的，为了找出任何两个数组之间的最大距离，我们不需要比较数组中的每一个元素，因为数组已经被排序过了。因此，我们只需要考虑数组中的极值来计算距离。
 此外，被考虑用于计算距离的两个点不应该都属于同一个数组。因此，对于当前选择的数组 $a$ 和 $b$，我们只需要找出 $a[n-1]-b[0]$ 和  $b[m-1]-a[0]$ 中的较大者来找出较大的距离。这里，$n$ 和 $m$ 分别指的是数组 $a$ 和 $b$ 的长度。
 但是，我们不需要比较所有可能的数组对来找出最大距离。相反，我们可以不断地遍历 $arrays$ 中的数组，并跟踪到目前为止发现的最大距离。
 为此，我们需要跟踪到目前为止找到的最小值（$min\_val$）和最大值（$max\_val$）。因此，现在这些极值可以被视为代表到目前为止考虑过的所有数组的累积数组的极点。
 对于每一个新考虑的数组，我们找到 $a[n-1]-min\_val$ 和 $max\_val - a[0]$ 与到目前为止找到的最大距离进行对比。这里的$n$指的是当前数组 a 的元素数量。此外，我们需要注意，到目前为止找到的最大距离并不总是由距离的端点 $max\_val$和$min\_val$ 贡献。
 但是，这些类型的点可能在未来有助于最大化距离。因此，我们需要跟踪这些最大值和最小值以及到目前为止找到的最大距离进行未来的计算。但是，一般来说，最终找到的最大距离总是由这些极值，$max\_val$和$min\_val$， 或在某些情况下，由它们两者决定的。
 下面的动画示例了这个过程。

 <![image.png](https://pic.leetcode.cn/1692167765-hilENt-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692167769-cujEAb-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692167772-itJXCF-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692167775-USVVRG-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692167778-WVCzZz-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692167781-KYsevs-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692167784-zYLNqn-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692167787-YSNJta-image.png){:width=400}>

 从上述插图中，我们可以清楚地看到，尽管 $max\_val$ 或 $min\_val$ 可能不能为局部最大距离值做出贡献，但是他们稍后可以做出最大距离的贡献。
 ```Java [solution]
class Solution {
    public int maxDistance(List<List<Integer>> arrays) {
        int res = 0;
        int n = arrays.get(0).size();
        int min_val = arrays.get(0).get(0);
        int max_val = arrays.get(0).get(arrays.get(0).size() - 1);
        for (int i = 1; i < arrays.size(); i++) {
            n = arrays.get(i).size();
            res = Math.max(res, Math.max(Math.abs(arrays.get(i).get(n - 1) - min_val), 
                                         Math.abs(max_val - arrays.get(i).get(0))));
            min_val = Math.min(min_val, arrays.get(i).get(0));
            max_val = Math.max(max_val, arrays.get(i).get(n - 1));
        }
        return res;
    }
}
 ```


 **复杂度分析**
 * 时间复杂度: $O(n)$. 我们只遍历了一次长度为 $n$ 的 $arrays$。
 * 空间复杂度: $O(1)$. 只使用了常数级的额外空间。
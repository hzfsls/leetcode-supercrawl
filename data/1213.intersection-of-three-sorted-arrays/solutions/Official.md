## [1213.三个有序数组的交集 中文官方题解](https://leetcode.cn/problems/intersection-of-three-sorted-arrays/solutions/100000/san-ge-you-xu-shu-zu-de-jiao-ji-by-leetc-0cez)
[TOC]
 ## 解决方案

 #### 方案一：使用哈希表进行暴力破解
 最直观的方法是计算 `arr1`、`arr2` 和 `arr3` 中每一个项目的频率，这样我们就能够找到只出现三次的数字。 这是可行的，因为这三个数组都是严格递增的，因此我们可以排除任何元素在任何一个数组中出现多次的可能性。
 **算法**
 - 我们会初始化一个哈希表 `counter` 来记录在三个数组中出现的数字及其出现的次数； 
 -  然后我们扫描 `arr1`、`arr2` 和 `arr3` 来计算频率； 
 -  最后，我们会遍历 `counter` 来找出出现三次的数字。

 ```Java [solution]
class Solution {
    public List<Integer> arraysIntersection(int[] arr1, int[] arr2, int[] arr3) {
        List<Integer> ans = new ArrayList<>();

        // 注意 HashMap 不能在这里使用，因为它不能保证键的顺序
        Map<Integer, Integer> counter = new TreeMap<>();

        // 迭代 arr1、arr2 和 arr3 来计算频率
        for (Integer e: arr1) {
            counter.put(e, counter.getOrDefault(e, 0) + 1);
        }
        for (Integer e: arr2) {
            counter.put(e, counter.getOrDefault(e, 0) + 1);
        }
        for (Integer e: arr3) {
            counter.put(e, counter.getOrDefault(e, 0) + 1);
        }

        for (Integer item: counter.keySet()) {
            if (counter.get(item) == 3) {
                ans.add(item);
            }
        }
        return ans;

    }
}
 ```
```Python3 [solution]
class Solution:
    def arraysIntersection(self, arr1: List[int], arr2: List[int], arr3: List[int]) -> List[int]:
        ans = []

        # 你可以用字典来计算频率
        # 或者您可以使用集合。
        # 更多信息可以在这里找到:
        # https://docs.python.org/3/library/collections.html
        counter = collections.Counter(arr1 + arr2 + arr3) # concatenate them together

        for item in counter:
            if counter[item] == 3:
                ans.append(item)
        return ans
```


 **复杂性分析**
 * 时间复杂度：$\mathcal{O}(n)$，其中 $n$ 是所有输入数组的总长度。 
 * 空间复杂度：$\mathcal{O}(n)$，其中 $n$ 是所有输入数组的总长度。 这是因为我们采用了一个哈希表来存储所有数字及其出现的次数。 <br />
 #### 方案二：三个指针
 你可能会注意到，方案一并没有利用到所有数组都是排序的这一事实。 实际上，我们可以使用三个指针`p1`、`p2`和`p3`来分别遍历 `arr1`、`arr2` 和 `arr3`，而不是使用哈希表来存储频率：
 - 每次，我们想要将指向最小数的指针，即 `min(arr1[p1], arr2[p2], arr3[p3])` 前移； 
 -  如果`p1`、`p2`和`p3`指向的数值都相同，那么我们应该存储它并将所有三个指针前移。
 此外，我们不必移动指向最小数的指针 
- 我们只需要移动指向较小数的指针。在这种情况下，我们避免了比较三个数并找到最小的一个才决定哪一个要移动。 你可能会在算法中找到这背后的原理。

 <![image.png](https://pic.leetcode.cn/1692095530-AWiSeM-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692095535-gzXJaC-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692095538-EjKavt-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692095540-TFeyOm-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692095542-COMmlm-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692095545-MpQRBU-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692095547-CBEBWD-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692095549-hjLRCJ-image.png){:width=400}>

 **算法**
 - 初始化三个指针`p1`、`p2`和`p3`，将它们放在`arr1`、`arr2`、`arr3`的开始，将它们初始化为0； 
 -  当它们在边界内时：  
    -  如果`arr1[p1] == arr2[p2] && arr2[p2] == arr3[p3]`，我们应当存储它，因为它在`arr1`, `arr2`, `arr3`中出现了三次；  
    -  否则如果 `arr1[p1] < arr2[p2]`，则移动较小的那一个，即`p1`；  
    -  否则如果 `arr2[p2] < arr3[p3]`，则移动较小的那一个，即`p2`；  
 -  如果以上两个条件都不满足，说明 `arr1[p1] >= arr2[p2] && arr2[p2] >= arr3[p3]`，因此应移动`p3`。

 ```Java [solution]
class Solution {
    public List<Integer> arraysIntersection(int[] arr1, int[] arr2, int[] arr3) {
        List<Integer> ans = new ArrayList <>();
        // 准备三个指针来迭代三个数组
        // p1、p2和p3分别指向arr1、arr2和arr3的起始点
        int p1 = 0, p2 = 0, p3 = 0;

        while (p1 < arr1.length && p2 < arr2.length && p3 < arr3.length) {

            if (arr1[p1] == arr2[p2] && arr2[p2] == arr3[p3]) {
                ans.add(arr1[p1]);
                p1++;
                p2++;
                p3++;
            } else {
                if (arr1[p1] < arr2[p2]) {
                    p1++;
                } else if (arr2[p2] < arr3[p3]) {
                    p2++;
                } else {
                    p3++;
                }

            }
        }
        return ans;
    }
}
 ```
```Python3 [solution]
class Solution:
    def arraysIntersection(self, arr1: List[int], arr2: List[int], arr3: List[int]) -> List[int]:
        ans = []
        # 准备三个指针来迭代三个数组
        # p1、p2和p3分别指向arr1、arr2和arr3的起始点
        p1 = p2 = p3 = 0
        while p1 < len(arr1) and p2 < len(arr2) and p3 < len(arr3):
            if arr1[p1] == arr2[p2] == arr3[p3]:
                ans.append(arr1[p1])
                p1 += 1
                p2 += 1
                p3 += 1
            else:
                if arr1[p1] < arr2[p2]:
                    p1 += 1
                elif arr2[p2] < arr3[p3]:
                    p2 += 1
                else:
                    p3 += 1
        return ans
```


 **复杂性分析**
 * 时间复杂度：$\mathcal{O}(n)$，其中 $n$ 是所有输入数组的总长度。 
 * 空间复杂度：$\mathcal{O}(1)$，因为我们只初始化了三个整数变量，使用了常量空间。
 <br /> 

---
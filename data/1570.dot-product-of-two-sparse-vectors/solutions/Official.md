## [1570.两个稀疏向量的点积 中文官方题解](https://leetcode.cn/problems/dot-product-of-two-sparse-vectors/solutions/100000/liang-ge-xi-shu-xiang-liang-de-dian-ji-b-2ljd)

[TOC]

 ## 解决方案

 稀疏向量是一个大部分元素为零的向量，而密集向量是一个大部分元素非零的向量。以一维数组的形式存储稀疏向量是低效率的（方法1）。相反，我们可以在字典中存储非零值及其对应的索引，索引作为键（方法2）。或者，我们可以将稀疏向量的元素表示为每个非零值的一对数组。每对具有整数索引和数值（方法3）。
 相关问题是 [LeetCode 311. 稀疏矩阵的乘法](https://leetcode.cn/problems/sparse-matrix-multiplication/)。

---

 #### 方法 1: 低效率数组方法

 **简述**
 我们忽略数组的稀疏性，存储原始数组。
 **算法实现**

 ```Java [solution]
class SparseVector {

    private int[] array;

    SparseVector(int[] nums) {
        array = nums;
    }

    public int dotProduct(SparseVector vec) {
        int result = 0;

        for (int i = 0; i < array.length; i++) {
            result += array[i] * vec.array[i];
        }
        return result;
    }   
}
 ```

```Python3 [solution]
class SparseVector:
    def __init__(self, nums):
        self.array = nums

    def dotProduct(self, vec):
        result = 0
        for num1, num2 in zip(self.array, vec.array):
            result += num1 * num2
        return result
```


 **复杂度分析**
 设 $n$ 是输入数组的长度。

 * 时间复杂度：构建稀疏向量和计算点积都是 $O(n)$。
 * 空间复杂度：构建稀疏向量为 $O(1)$，因为我们只是保存对输入数组的引用，计算点积为 $O(1)$。

---

 #### 方法 2: 哈希集

 **简述**
 在字典中存储非零值及其对应的索引，索引作为键。任何不存在的索引对应输入数组中的值0。
 **算法实现**

 ```Java [solution]
class SparseVector {
    // 将 vector 中所有非零值的索引映射为 value
    Map<Integer, Integer> mapping;      

    SparseVector(int[] nums) {
        mapping = new HashMap<>();
        for (int i = 0; i < nums.length; ++i) {
            if (nums[i] != 0) {
                mapping.put(i, nums[i]);        
            }
        }
    }

    public int dotProduct(SparseVector vec) {        
        int result = 0;

        // 迭代这个稀疏向量中的每个非零元素
        // 如果对应的索引在另一个向量中具有非零值，则更新点积
        for (Integer i : this.mapping.keySet()) {
            if (vec.mapping.containsKey(i)) {
                result += this.mapping.get(i) * vec.mapping.get(i);
            }
        }
        return result;
    }
}
 ```

```Python3 [solution]
class SparseVector:
    def __init__(self, nums: List[int]):
        self.nonzeros = {}
        for i, n in enumerate(nums):
            if n != 0:
                self.nonzeros[i] = n              

    def dotProduct(self, vec: 'SparseVector') -> int:
        result = 0
        # 迭代这个稀疏向量中的每个非零元素
        # 如果对应的索引在另一个向量中具有非零值，则更新点积
        for i, n in self.nonzeros.items():
            if i in vec.nonzeros:
                result += n * vec.nonzeros[i]
        return result
```


 **复杂度分析**
 设 $n$ 是输入数组的长度，$L$ 是非零元素的数量。

 * 时间复杂度：创建哈希映射为 $O(n)$，计算点积为 $O(L)$。
 * 空间复杂度：创建哈希映射为 $O(L)$，因为我们只存储非零元素。计算点积为 $O(1)$。

---

 #### 方法 3: 索引-值配对

 **简述**
 我们也可以将稀疏向量的元素表示为<索引，值>对的列表。我们用两个指针遍历两个向量来计算点积。
 **算法实现**

 ```Java [solution]
class SparseVector {

    List<int[]> pairs;

    SparseVector(int[] nums) {
        pairs = new ArrayList<>();
        for (int i = 0; i < nums.length; i++) {
            if (nums[i] != 0) {
                pairs.add(new int[]{i, nums[i]});
            }
        }
    }

    // 返回两个稀疏向量的点积
    public int dotProduct(SparseVector vec) {
        int result = 0, p = 0, q = 0;
        while (p < pairs.size() && q < vec.pairs.size()) {
            if (pairs.get(p)[0] == vec.pairs.get(q)[0]) {
                result += pairs.get(p)[1] * vec.pairs.get(q)[1];
                p++;
                q++;
            }
            else if (pairs.get(p)[0] > vec.pairs.get(q)[0]) {
                q++;
            }
            else {
                p++;
            }
        }
        return result;
    }
}
 ```

```Python3 [solution]
class SparseVector:
    def __init__(self, nums: List[int]):
        self.pairs = []
        for index, value in enumerate(nums):
            if value != 0:
                self.pairs.append([index, value])

    def dotProduct(self, vec: 'SparseVector') -> int:
        result = 0
        p, q = 0, 0

        while p < len(self.pairs) and q < len(vec.pairs):
            if self.pairs[p][0] == vec.pairs[q][0]:
                result += self.pairs[p][1] * vec.pairs[q][1]
                p += 1
                q += 1
            elif self.pairs[p][0] < vec.pairs[q][0]:
                p += 1
            else:
                q += 1

        return result

```


 **复杂度分析**
 设 $n$ 是输入数组的长度，$L$和$L_{2}$ 是两个向量的非零元素数。

 * 时间复杂度：为非零值创建<index, value>对的复杂度为 $O(n)$；计算点积的复杂度为 $O(L+L_{2})$。
 * 空间复杂度：为非零值创建<index, value>对的空间复杂度为 $O(L)$。计算点积的空间复杂度为 $O(1)$。
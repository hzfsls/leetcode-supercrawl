## [1389.按既定顺序创建目标数组 中文官方题解](https://leetcode.cn/problems/create-target-array-in-the-given-order/solutions/100000/an-ji-ding-shun-xu-chuang-jian-mu-biao-shu-zu-by-l)

#### 方法一：模拟

**思路**

使用顺序表作为答案的存储结构，按照题意模拟即可。具体的方法是：要在当前的下标从 $0$ 开始长度为 $n$ 的顺序表的 $i$ 位置插入元素，就要先把原来表中区间 $[i, n]$ 中的元素从全部向后移动一位，然后在 $i$ 位置插入带插入的元素。当然很多语言中都有现成的方法可以调用，比如 C++ `vector` 类中的 `insert`、Python 列表中的 `insert` 等。

**代码**

```C [sol1-C]
int* createTargetArray(int* nums, int numsSize, int* index, int indexSize, int* returnSize){
    int* ret = (int*)malloc(sizeof(int) * indexSize);
    int tail = -1;
    for (int i = 0; i < indexSize; ++i) {
        ++tail;
        for (int j = tail; j > index[i]; --j) {
            ret[j] = ret[j - 1];
        }
        ret[index[i]] = nums[i];
    }
    *returnSize = indexSize;
    return ret;
}
```

```C++ [sol1-C++]
class Solution {
public:
    vector<int> createTargetArray(vector<int>& nums, vector<int>& index) {
        vector <int> r;
        for (unsigned i = 0; i < nums.size(); ++i) {
            r.insert(r.begin() + index[i], nums[i]);
        }
        return r;
    }
};
```

```Java [sol1-Java]
class Solution {
    public int[] createTargetArray(int[] nums, int[] index) {
        List<Integer> list = new ArrayList<Integer>();
        for (int i = 0; i < nums.length; ++i) {
            list.add(index[i], nums[i]);
        }
        int[] ret = new int[nums.length];
        for (int i = 0; i < nums.length; ++i) {
            ret[i] = list.get(i);
        }
        return ret;
    }
}
```

```Python [sol1-Python]
class Solution:
    def createTargetArray(self, nums: List[int], index: List[int]) -> List[int]:
        ret = []
        for i in range(len(nums)):
            ret.insert(index[i], nums[i])
        return ret
```

**复杂度分析**

记数组的长度为 $n$。

- 时间复杂度：考虑一次操作最坏情况下的时间代价和当前数组中元素的个数呈正比， 第 $i$ 次操作时元素个数为 $i - 1$，所以这里渐进时间复杂度为 $O(\sum_{i = 1}^{n} (i - 1)) = O(n^2)$。

- 空间复杂度：这里没有使用到辅助空间，故渐进空间复杂度为 $O(1)$。
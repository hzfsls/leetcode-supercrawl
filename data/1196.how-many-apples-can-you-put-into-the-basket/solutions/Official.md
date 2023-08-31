## [1196.最多可以买到的苹果数量 中文官方题解](https://leetcode.cn/problems/how-many-apples-can-you-put-into-the-basket/solutions/100000/zui-duo-ke-yi-mai-dao-de-ping-guo-shu-liang-by-lee)
#### 方法一：排序

**思路**

本题要求**最多可以买到的苹果数量**，固定容量的购物袋，苹果的重量越小，能放入的数量越多。比如 `100` 容量的购物袋，可以放 10 个重量为 `10` 的苹果，只能放 5 个重量为 `20` 的苹果。要保证放的苹果最多，需要尽可能的保证每个苹果的重量最小。

因此，我们可以逐个放入苹果，每次放入的苹果都选择剩余的苹果中最小的那个，直到总的容量超过购物袋的容量。

**算法**

对数组 `arr` 排序，快速找到苹果中重量最小的那个。从小到大遍历 `arr` 数组，将当前下标的苹果加入到购物袋，将重量加到当前总重量 `sum` 中， 如果 `sum > 5000` 说明已经放不下了，返回之前所有苹果的个数。如果整个数组的和小于 `5000`，说明可以放下所有的苹果。

**代码**

```Java [ ]
class Solution {
    public int maxNumberOfApples(int[] arr) {
        Arrays.sort(arr);
        int sum = 0;
        int count = 0;
        for(int i = 0;i < arr.length; i++) {
            sum += arr[i];
            if(sum > 5000) {
                break;
            }
            count++;
        }
        return count;
    }
}
```

```Golang [ ]
func maxNumberOfApples(arr []int) int {
    sort.Ints(arr)
    sum := 0
    for i := 0; i < len(arr); i++ {
        sum += arr[i]
        if sum > 5000 {
            return i
        }
    }
    return len(arr)
}
```

```Python3 [ ]
class Solution:
    def maxNumberOfApples(self, arr: List[int]) -> int:
        sum = 0
        count = 0
        for i in sorted(arr):
            sum += i
            if sum > 5000:
                break
            count = count + 1
        return count
```

```C++ [ ]
class Solution {
public:
    int maxNumberOfApples(vector<int>& arr) {
        sort(arr.begin(), arr.end());
        int sum = 0;
        int count = 0;
        for(int v : arr) {
            sum += v;
            if(sum > 5000){
                break;
            }
            count++;
        }
        return count;
    }
};
```

**复杂度分析**

- 时间复杂度：$O(N\log N)$，其中 $n$ 为数组 `arr` 的长度。排序算法为快排，时间复杂度为 $O(N\log N)$，遍历 `arr` 数组的时间复杂度为 $O(N)$。

- 空间复杂度：$O(\log N)$，排序算法为快排，空间复杂度为 $O(\log N)$。
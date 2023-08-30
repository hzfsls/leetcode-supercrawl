#### 方法一：哈希统计

**思路**

我们用哈希统计数组中每个元素出现的次数，设数组的长度为 $n$，返回所有统计次数超过 $\lfloor\frac{n}{3}\rfloor$ 的元素。

```C++ [sol1-C++]
class Solution {
public:
    vector<int> majorityElement(vector<int>& nums) {
        int n = nums.size();
        vector<int> ans;
        unordered_map<int, int> cnt;

        for (auto & v : nums) {
            cnt[v]++;
        }
        for (auto & v : cnt) {
            if (v.second > n / 3) {
                ans.push_back(v.first);
            }
        }

        return ans;
    }
};
```

```Java [sol1-Java]
class Solution {
    public List<Integer> majorityElement(int[] nums) {
        HashMap<Integer, Integer> cnt = new HashMap<Integer, Integer>();

        for (int i = 0; i < nums.length; i++) {
            if (cnt.containsKey(nums[i])) {
                cnt.put(nums[i], cnt.get(nums[i]) + 1);
            } else {
                cnt.put(nums[i], 1);
            }
        }
        List<Integer> ans = new ArrayList<>();
        for (int x : cnt.keySet()) {
            if (cnt.get(x) > nums.length / 3) {
                ans.add(x);
            }
        }
   
        return ans;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public IList<int> MajorityElement(int[] nums) {
        Dictionary<int, int> cnt = new Dictionary<int, int>();

        for (int i = 0; i < nums.Length; i++) {
            if (cnt.ContainsKey(nums[i])) {
                cnt[nums[i]]++;
            } else {
                cnt.Add(nums[i], 1);
            }
        }
        IList<int> ans = new List<int>();
        foreach (KeyValuePair<int, int> pair in cnt) {
            if (pair.Value > nums.Length / 3) {
                ans.Add(pair.Key);
            }
        }
   
        return ans;
    }
}
```

```Python [sol1-Python3]
class Solution:
    def majorityElement(self, nums: List[int]) -> List[int]:
        cnt = {}
        ans = []

        for v in nums:
            if v in cnt:
                cnt[v] += 1
            else:
                cnt[v] = 1
        for item in cnt.keys():
            if cnt[item] > len(nums)//3:
                ans.append(item)

        return ans
```

```go [sol1-Golang]
func majorityElement(nums []int) (ans []int) {
    cnt := map[int]int{}
    for _, v := range nums {
        cnt[v]++
    }
    for v, c := range cnt {
        if c > len(nums)/3 {
            ans = append(ans, v)
        }
    }
    return
}
```

```JavaScript [sol1-JavaScript]
var majorityElement = function(nums) {
    const cnt = new Map();

    for (let i = 0; i < nums.length; i++) {
        if (cnt.has(nums[i])) {
            cnt.set(nums[i], cnt.get(nums[i]) + 1);
        } else {
            cnt.set(nums[i], 1);
        }
    }
    const ans = [];
    for (const x of cnt.keys()) {
        if (cnt.get(x) > Math.floor(nums.length / 3)) {
            ans.push(x);
        }
    }

    return ans;
};
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 为数组的长度。

- 空间复杂度：$O(n)$，其中 $n$ 为数组的长度，使用哈希表需要开辟额外的空间。

#### 方法二：摩尔投票法

**背景知识**

摩尔投票法：摩尔投票法的核心思想为对拼消耗。首先我们考虑最基本的摩尔投票问题，比如找出一组数字序列中出现次数大于总数 $\frac{1}{2}$ 的数字（并且假设这个数字一定存在）。我们可以直接利用反证法证明这样的数字只可能有一个。摩尔投票算法的核心思想是基于这个事实：

- 每次从序列里选择两个不相同的数字删除掉（或称为「抵消」），最后剩下一个数字或几个相同的数字，就是出现次数大于总数一半的那个元素。假设我们当前数组中存在次数大于总数一半的元素为 $x$，数组的总长度为 $n$，则我们可以把数组分为两部分，一部分为相同的 $k$ 个元素 $x$，另一部分为 $\frac{n-k}{2}$对个不同的元素配对，此时我们假设还存在另外一个次数大于总数一半的元素 $y$，则此时 $y$ 因该满足 $y > \frac{n}{2}$，但是按照我们之前的推理 $y$ 应当满足 $y \le \frac{n-k}{2}$，二者自相矛盾。

- 具体有兴趣的同学可以参考论文的证明过程，论文地址：[MJRTYA Fast Majority Vote Algorithm](https://www.cs.ou.edu/~rlpage/dmtools/mjrty.pdf)

**解题思路**

题目要求找出其中所有出现超过 $\lfloor\frac{n}{3}\rfloor$ 次的元素。我们可以利用反证法推断出满足这样条件的元素最多只有两个，我们可以利用摩尔投票法的核心思想，每次选择三个互不相同的元素进行删除（或称为「抵消」）。我们可以假设数组中一定只存在一个次数大于 $\lfloor\frac{n}{3}\rfloor$ 的元素 $x$，其中 $n$ 为数组的长度，则此时我们可以把数组分成两部分：一部分相同的 $k$ 个元素 $x$，另一部分为 $\frac{n-k}{3}$组三个不同的元素，我们知道三个不同的元素会被抵消，因此最终只会剩下一个元素为 $x$。如果只存在 $2$ 个次数大于 $\lfloor\frac{n}{3}\rfloor$ 的元素时，我们假设这两个不同的元素分别为 $x$ 和 $y$，则此时我们一定可以把数组分成三部分：第一部分相同的 $m$ 个元素 $x$，第二部分相同的 $k$ 个元素 $y$，第三部分为 $\frac{n-m-k}{3}$组三个互不同的元素，我们知道三个互不同的元素会被抵消，因此最终只会剩下两个元素为 $x$ 和 $y$。

- 我们每次检测当前元素是否为第一个选中的元素或者第二个选中的元素。

- 每次我们发现当前元素与已经选中的两个元素都不相同，则进行抵消一次。

- 如果存在最终选票大于 $0$ 的元素，我们还需要再次统计已选中元素的次数,检查元素的次数是否大于 $\lfloor\frac{n}{3}\rfloor$ 。

```C++ [sol2-C++]
class Solution {
public:
    vector<int> majorityElement(vector<int>& nums) {
        vector<int> ans;
        int element1 = 0;
        int element2 = 0;
        int vote1 = 0;
        int vote2 = 0;

        for (auto & num : nums) {
            if (vote1 > 0 && num == element1) { //如果该元素为第一个元素，则计数加1
                vote1++;
            } else if (vote2 > 0 && num == element2) { //如果该元素为第二个元素，则计数加1
                vote2++;
            } else if (vote1 == 0) { // 选择第一个元素
                element1 = num;
                vote1++;
            } else if (vote2 == 0) { // 选择第二个元素
                element2 = num;
                vote2++;
            } else { //如果三个元素均不相同，则相互抵消1次
                vote1--;
                vote2--;
            }
        }

        int cnt1 = 0;
        int cnt2 = 0;
        for (auto & num : nums) {
            if (vote1 > 0 && num == element1) {
                cnt1++;
            }
            if (vote2 > 0 && num == element2) {
                cnt2++;
            }
        }
        // 检测元素出现的次数是否满足要求
        if (vote1 > 0 && cnt1 > nums.size() / 3) {
            ans.push_back(element1);
        }
        if (vote2 > 0 && cnt2 > nums.size() / 3) {
            ans.push_back(element2);
        }

        return ans;
    }
};
```

```Java [sol2-Java]
class Solution {
    public List<Integer> majorityElement(int[] nums) {
        int element1 = 0;
        int element2 = 0;
        int vote1 = 0;
        int vote2 = 0;

        for (int num : nums) {
            if (vote1 > 0 && num == element1) { //如果该元素为第一个元素，则计数加1
                vote1++;
            } else if (vote2 > 0 && num == element2) { //如果该元素为第二个元素，则计数加1
                vote2++;
            } else if (vote1 == 0) { // 选择第一个元素
                element1 = num;
                vote1++;
            } else if (vote2 == 0) { // 选择第二个元素
                element2 = num;
                vote2++;
            } else { //如果三个元素均不相同，则相互抵消1次
                vote1--;
                vote2--;
            }
        }

        int cnt1 = 0;
        int cnt2 = 0;
        for (int num : nums) {
            if (vote1 > 0 && num == element1) {
                cnt1++;
            }
            if (vote2 > 0 && num == element2) {
                cnt2++;
            }
        }
        // 检测元素出现的次数是否满足要求
        List<Integer> ans = new ArrayList<>();
        if (vote1 > 0 && cnt1 > nums.length / 3) {
            ans.add(element1);
        }
        if (vote2 > 0 && cnt2 > nums.length / 3) {
            ans.add(element2);
        }

        return ans;
    }
}
```

```C# [sol2-C#]
public class Solution {
    public IList<int> MajorityElement(int[] nums) {
        int element1 = 0;
        int element2 = 0;
        int vote1 = 0;
        int vote2 = 0;

        foreach (int num in nums) {
            if (vote1 > 0 && num == element1) { //如果该元素为第一个元素，则计数加1
                vote1++;
            } else if (vote2 > 0 && num == element2) { //如果该元素为第二个元素，则计数加1
                vote2++;
            } else if (vote1 == 0) { // 选择第一个元素
                element1 = num;
                vote1++;
            } else if (vote2 == 0) { // 选择第二个元素
                element2 = num;
                vote2++;
            } else { //如果三个元素均不相同，则相互抵消1次
                vote1--;
                vote2--;
            }
        }

        int cnt1 = 0;
        int cnt2 = 0;
        foreach (int num in nums) {
            if (vote1 > 0 && num == element1) {
                cnt1++;
            }
            if (vote2 > 0 && num == element2) {
                cnt2++;
            }
        }
        // 检测元素出现的次数是否满足要求
        IList<int> ans = new List<int>();
        if (vote1 > 0 && cnt1 > nums.Length / 3) {
            ans.Add(element1);
        }
        if (vote2 > 0 && cnt2 > nums.Length / 3) {
            ans.Add(element2);
        }

        return ans;
    }
}
```

```Python [sol2-Python3]
class Solution:
    def majorityElement(self, nums: List[int]) -> List[int]:
        ans = []
        element1, element2 = 0, 0
        vote1, vote2 = 0, 0

        for num in nums:
            # 如果该元素为第一个元素，则计数加1
            if vote1 > 0 and num == element1:
                vote1 += 1
            # 如果该元素为第二个元素，则计数加1
            elif vote2 > 0 and num == element2:
                vote2 += 1
            # 选择第一个元素
            elif vote1 == 0:
                element1 = num
                vote1 += 1
            # 选择第二个元素
            elif vote2 == 0:
                element2 = num
                vote2 += 1
            # 如果三个元素均不相同，则相互抵消1次
            else:
                vote1 -= 1
                vote2 -= 1

        cnt1, cnt2 = 0, 0
        for num in nums:
            if vote1 > 0 and num == element1:
                cnt1 += 1
            if vote2 > 0 and num == element2:
                cnt2 += 1        
        # 检测元素出现的次数是否满足要求
        if vote1 > 0 and cnt1 > len(nums) / 3:
            ans.append(element1)
        if vote2 > 0 and cnt2 > len(nums) / 3:
            ans.append(element2)

        return ans
```

```go [sol2-Golang]
func majorityElement(nums []int) (ans []int) {
    element1, element2 := 0, 0
    vote1, vote2 := 0, 0

    for _, num := range nums {
        if vote1 > 0 && num == element1 { // 如果该元素为第一个元素，则计数加1
            vote1++
        } else if vote2 > 0 && num == element2 { // 如果该元素为第二个元素，则计数加1
            vote2++
        } else if vote1 == 0 { // 选择第一个元素
            element1 = num
            vote1++
        } else if vote2 == 0 { // 选择第二个元素
            element2 = num
            vote2++
        } else { // 如果三个元素均不相同，则相互抵消1次
            vote1--
            vote2--
        }
    }

    cnt1, cnt2 := 0, 0
    for _, num := range nums {
        if vote1 > 0 && num == element1 {
            cnt1++
        }
        if vote2 > 0 && num == element2 {
            cnt2++
        }
    }

    // 检测元素出现的次数是否满足要求
    if vote1 > 0 && cnt1 > len(nums)/3 {
        ans = append(ans, element1)
    }
    if vote2 > 0 && cnt2 > len(nums)/3 {
        ans = append(ans, element2)
    }
    return
}
```

```JavaScript [sol2-JavaScript]
var majorityElement = function(nums) {
    let element1 = 0;
    let element2 = 0;
    let vote1 = 0;
    let vote2 = 0;

    for (const num of nums) {
        if (vote1 > 0 && num === element1) { //如果该元素为第一个元素，则计数加1
            vote1++;
        } else if (vote2 > 0 && num === element2) { //如果该元素为第二个元素，则计数加1
            vote2++;
        } else if (vote1 === 0) { // 选择第一个元素
            element1 = num;
            vote1++;
        } else if (vote2 === 0) { // 选择第二个元素
            element2 = num;
            vote2++;
        } else { //如果三个元素均不相同，则相互抵消1次
            vote1--;
            vote2--;
        }
    }

    let cnt1 = 0;
    let cnt2 = 0;
    for (const num of nums) {
        if (vote1 > 0 && num === element1) {
            cnt1++;
        }
        if (vote2 > 0 && num === element2) {
            cnt2++;
        }
    }
    // 检测元素出现的次数是否满足要求
    const ans = [];
    if (vote1 > 0 && cnt1 > Math.floor(nums.length / 3)) {
        ans.push(element1);
    }
    if (vote2 > 0 && cnt2 > Math.floor(nums.length / 3)) {
        ans.push(element2);
    }

    return ans;
};
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 为数组的长度。

- 空间复杂度：$O(1)$，只需要常数个元素用来存储关键元素和统计次数即可。
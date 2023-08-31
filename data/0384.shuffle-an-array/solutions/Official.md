## [384.打乱数组 中文官方题解](https://leetcode.cn/problems/shuffle-an-array/solutions/100000/da-luan-shu-zu-by-leetcode-solution-og5u)
#### 方法一：暴力

**思路**

首先，我们考虑如何随机打乱一个数组。

不妨设数组 $\textit{nums}$，其长度为 $n$。我们可以使用如下方法打乱：

* 将数组中所有的数都放到数据结构 $\textit{waiting}$ 中，并初始化打乱后的数组 $\textit{shuffle}$；
* 循环 $n$ 次，在第 $i$ 次循环中（$0 \le i < n$）：
  * 在 $\textit{waiting}$ 中随机抽取一个数 $\textit{num}$，将其作为打乱后的数组 $\textit{shuffle}$ 的第 $i$ 个元素；
  * 从 $\textit{waiting}$ 中移除 $\textit{num}$。

对于原数组 $\textit{nums}$ 中的数 $\textit{num}$ 来说，被移动到打乱后的数组的第 $i$ 个位置的概率为：

$$
P(i) = 
\begin{cases}
 (\frac{n-1}{n} \times \frac{n-2}{n-1} \cdots \times \frac{n-i}{n-i+1}) \times \frac{1}{n-i} = \frac{1}{n}, \hspace{1em} i > 0 \\
 \frac{1}{n}, \hspace{1em} i = 0
\end{cases}
$$

因此，对于原数组 $\textit{nums}$ 中的任意一个数，被移动到打乱后的数组的任意一个位置的概率都是相同的。

**算法**

在算法的实现中，我们考虑以下两个问题：

- 如何实现重设数组到它的初始状态？

  我们使用 $\textit{nums}$ 来存储当前数组，并用 $\textit{original}$ 来存储数组的初始状态。在需要重设数组到它的初始状态时，只需要将 $\textit{original}$ 复制到 $\textit{nums}$ 并返回即可。

- 如何实现 $\textit{waiting}$？

  我们要求 $\textit{waiting}$ 既支持根据随机计算的下标获取元素，又支持根据该下标移除元素。在方法一中，我们使用数组来实现 $\textit{waiting}$。

**代码**

```Python [sol1-Python3]
class Solution:
    def __init__(self, nums: List[int]):
        self.nums = nums
        self.original = nums.copy()

    def reset(self) -> List[int]:
        self.nums = self.original.copy()
        return self.nums

    def shuffle(self) -> List[int]:
        shuffled = [0] * len(self.nums)
        for i in range(len(self.nums)):
            j = random.randrange(len(self.nums))
            shuffled[i] = self.nums.pop(j)
        self.nums = shuffled
        return self.nums
```

```Java [sol1-Java]
class Solution {
    int[] nums;
    int[] original;

    public Solution(int[] nums) {
        this.nums = nums;
        this.original = new int[nums.length];
        System.arraycopy(nums, 0, original, 0, nums.length);
    }
    
    public int[] reset() {
        System.arraycopy(original, 0, nums, 0, nums.length);
        return nums;
    }
    
    public int[] shuffle() {
        int[] shuffled = new int[nums.length];
        List<Integer> list = new ArrayList<Integer>();
        for (int i = 0; i < nums.length; ++i) {
            list.add(nums[i]);
        }
        Random random = new Random();
        for (int i = 0; i < nums.length; ++i) {
            int j = random.nextInt(list.size());
            shuffled[i] = list.remove(j);
        }
        System.arraycopy(shuffled, 0, nums, 0, nums.length);
        return nums;
    }
}
```

```C# [sol1-C#]
public class Solution {
    int[] nums;
    int[] original;

    public Solution(int[] nums) {
        this.nums = nums;
        this.original = new int[nums.Length];
        Array.Copy(nums, original, nums.Length);
    }
    
    public int[] Reset() {
        Array.Copy(original, nums, nums.Length);
        return nums;
    }
    
    public int[] Shuffle() {
        int[] shuffled = new int[nums.Length];
        IList<int> list = new List<int>();
        for (int i = 0; i < nums.Length; ++i) {
            list.Add(nums[i]);
        }
        Random random = new Random();
        for (int i = 0; i < nums.Length; ++i) {
            int j = random.Next(list.Count);
            shuffled[i] = list[j];
            list.Remove(list[j]);
        }
        Array.Copy(shuffled, nums, nums.Length);
        return nums;
    }
}
```

```C++ [sol1-C++]
class Solution {
public:
    Solution(vector<int>& nums) {
        this->nums = nums;
        this->original.resize(nums.size());
        copy(nums.begin(), nums.end(), original.begin());
    }
    
    vector<int> reset() {
        copy(original.begin(), original.end(), nums.begin());
        return nums;
    }
    
    vector<int> shuffle() {
        vector<int> shuffled = vector<int>(nums.size());
        list<int> lst(nums.begin(), nums.end());
      
        for (int i = 0; i < nums.size(); ++i) {
            int j = rand()%(lst.size());
            auto it = lst.begin();
            advance(it, j);
            shuffled[i] = *it;
            lst.erase(it);
        }
        copy(shuffled.begin(), shuffled.end(), nums.begin());
        return nums;
    }
private:
    vector<int> nums;
    vector<int> original;
};
```

```go [sol1-Golang]
type Solution struct {
    nums, original []int
}

func Constructor(nums []int) Solution {
    return Solution{nums, append([]int(nil), nums...)}
}

func (s *Solution) Reset() []int {
    copy(s.nums, s.original)
    return s.nums
}

func (s *Solution) Shuffle() []int {
    shuffled := make([]int, len(s.nums))
    for i := range shuffled {
        j := rand.Intn(len(s.nums))
        shuffled[i] = s.nums[j]
        s.nums = append(s.nums[:j], s.nums[j+1:]...)
    }
    s.nums = shuffled
    return s.nums
}
```

```JavaScript [sol1-JavaScript]
var Solution = function(nums) {
    this.nums = nums;
    this.original = nums.slice();

};

Solution.prototype.reset = function() {
    this.nums = this.original.slice();
    return this.nums;
};

Solution.prototype.shuffle = function() {
    const shuffled = new Array(this.nums.length).fill(0);
    const list = [];
    this.nums.forEach((num) => list.push(num));
    for (let i = 0; i < this.nums.length; ++i) {
        const j = Math.random() * list.length;
        shuffled[i] = list.splice(j, 1);
    }
    this.nums = shuffled.slice();
    return this.nums;
};
```

**复杂度分析**

- 时间复杂度：
  - 初始化：$O(n)$，其中 $n$ 为数组中的元素数量。我们需要 $O(n)$ 来初始化 $\textit{original}$。
  - $\texttt{reset}$：$O(n)$。我们需要 $O(n)$ 将 $\textit{original}$ 复制到 $\textit{nums}$。
  - $\texttt{shuffle}$：$O(n^2)$。我们需要遍历 $n$ 个元素，每个元素需要 $O(n-k)$ 的时间从 $\textit{nums}$ 中移除第 $k$ 个元素。
- 空间复杂度：$O(n)$。记录初始状态和临时的乱序数组均需要存储 $n$ 个元素。

#### 方法二：Fisher-Yates 洗牌算法

**思路和算法**

考虑通过调整 $\textit{waiting}$ 的实现方式以优化方法一。

我们可以在移除 $\textit{waiting}$ 的第 $k$ 个元素时，将第 $k$ 个元素与数组的最后 $1$ 个元素交换，然后移除交换后数组的最后 $1$ 个元素，这样我们只需要 $O(1)$ 的时间复杂度即可完成移除第 $k$ 个元素的操作。此时，被移除的交换后数组的最后 $1$ 个元素即为我们根据随机下标获取的元素。

在此基础上，我们也可以不移除最后 $1$ 个元素，而直接将其作为乱序后的结果，并更新待乱序数组的长度，从而实现数组的原地乱序。因为我们不再需要从数组中移除元素，所以也可以将第 $k$ 个元素与第 $1$ 个元素交换。

具体地，实现算法如下：

- 设待原地乱序的数组 $\textit{nums}$。
- 循环 $n$ 次，在第 $i$ 次循环中（$0 \le i < n$）：
  - 在 $[i,n)$ 中随机抽取一个下标 $j$；
  - 将第 $i$ 个元素与第 $j$ 个元素交换。

其中数组中的 $\textit{nums}[i \ .. \ n-1]$ 的部分为待乱序的数组，其长度为 $n-i$；$\textit{nums}[0 \ .. \ i-1]$ 的部分为乱序后的数组，其长度为 $i$。

**代码**

```Python [sol2-Python3]
class Solution:
    def __init__(self, nums: List[int]):
        self.nums = nums
        self.original = nums.copy()

    def reset(self) -> List[int]:
        self.nums = self.original.copy()
        return self.nums

    def shuffle(self) -> List[int]:
        for i in range(len(self.nums)):
            j = random.randrange(i, len(self.nums))
            self.nums[i], self.nums[j] = self.nums[j], self.nums[i]
        return self.nums
```

```Java [sol2-Java]
class Solution {
    int[] nums;
    int[] original;

    public Solution(int[] nums) {
        this.nums = nums;
        this.original = new int[nums.length];
        System.arraycopy(nums, 0, original, 0, nums.length);
    }
    
    public int[] reset() {
        System.arraycopy(original, 0, nums, 0, nums.length);
        return nums;
    }
    
    public int[] shuffle() {
        Random random = new Random();
        for (int i = 0; i < nums.length; ++i) {
            int j = i + random.nextInt(nums.length - i);
            int temp = nums[i];
            nums[i] = nums[j];
            nums[j] = temp;
        }
        return nums;
    }
}
```

```C# [sol2-C#]
public class Solution {
    int[] nums;
    int[] original;

    public Solution(int[] nums) {
        this.nums = nums;
        this.original = new int[nums.Length];
        Array.Copy(nums, original, nums.Length);
    }
    
    public int[] Reset() {
        Array.Copy(original, nums, nums.Length);
        return nums;
    }
    
    public int[] Shuffle() {
        Random random = new Random();
        for (int i = 0; i < nums.Length; ++i) {
            int j = random.Next(i, nums.Length);
            int temp = nums[i];
            nums[i] = nums[j];
            nums[j] = temp;
        }
        return nums;
    }
}
```

```C++ [sol2-C++]
class Solution {
public:
    Solution(vector<int>& nums) {
        this->nums = nums;
        this->original.resize(nums.size());
        copy(nums.begin(), nums.end(), original.begin());
    }
    
    vector<int> reset() {
        copy(original.begin(), original.end(), nums.begin());
        return nums;
    }
    
    vector<int> shuffle() {
        for (int i = 0; i < nums.size(); ++i) {
            int j = i + rand() % (nums.size() - i);
            swap(nums[i], nums[j]);
        }
        return nums;
    }
private:
    vector<int> nums;
    vector<int> original;
};
```

```go [sol2-Golang]
type Solution struct {
    nums, original []int
}

func Constructor(nums []int) Solution {
    return Solution{nums, append([]int(nil), nums...)}
}

func (s *Solution) Reset() []int {
    copy(s.nums, s.original)
    return s.nums
}

func (s *Solution) Shuffle() []int {
    n := len(s.nums)
    for i := range s.nums {
        j := i + rand.Intn(n-i)
        s.nums[i], s.nums[j] = s.nums[j], s.nums[i]
    }
    return s.nums
}
```

```JavaScript [sol2-JavaScript]
var Solution = function(nums) {
    this.nums = nums;
    this.original = this.nums.slice();
};

Solution.prototype.reset = function() {
    this.nums = this.original.slice();
    return this.nums;
};

Solution.prototype.shuffle = function() {
    for (let i = 0; i < this.nums.length; ++i) {
        const j = Math.floor(Math.random() * (this.nums.length - i)) + i;
        const temp = this.nums[i];
        this.nums[i] = this.nums[j];
        this.nums[j] = temp;
    }
    return this.nums;
};
```

**复杂度分析**

- 时间复杂度：
  - 初始化：$O(n)$，其中 $n$ 为数组中的元素数量。我们需要 $O(n)$ 来初始化 $\textit{original}$。
  - $\texttt{reset}$：$O(n)$。我们需要 $O(n)$ 将 $\textit{original}$ 复制到 $\textit{nums}$。
  - $\texttt{shuffle}$：$O(n)$。我们只需要遍历 $n$ 个元素即可打乱数组。

- 空间复杂度：$O(n)$。记录初始状态需要存储 $n$ 个元素。
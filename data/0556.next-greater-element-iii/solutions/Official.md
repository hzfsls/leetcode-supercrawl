## [556.下一个更大元素 III 中文官方题解](https://leetcode.cn/problems/next-greater-element-iii/solutions/100000/xia-yi-ge-geng-da-yuan-su-iii-by-leetcod-mqf1)

#### 方法一：下一个排列

把 $n$ 转换成字符串（字符数组），那么本题实际上是在求字符数组的 [31. 下一个排列](https://leetcode.cn/problems/next-permutation/)，当不存在下一个排列时返回 $-1$。

参考 [31. 下一个排列的官方题解](https://leetcode.cn/problems/next-permutation/solution/xia-yi-ge-pai-lie-by-leetcode-solution/)，可以得到如下做法：

```Python [sol1-Python3]
class Solution:
    def nextGreaterElement(self, n: int) -> int:
        nums = list(str(n))
        i = len(nums) - 2
        while i >= 0 and nums[i] >= nums[i + 1]:
            i -= 1
        if i < 0:
            return -1

        j = len(nums) - 1
        while j >= 0 and nums[i] >= nums[j]:
            j -= 1
        nums[i], nums[j] = nums[j], nums[i]
        nums[i + 1:] = nums[i + 1:][::-1]
        ans = int(''.join(nums))
        return ans if ans < 2 ** 31 else -1
```

```C++ [sol1-C++]
class Solution {
public:
    int nextGreaterElement(int n) {
        auto nums = to_string(n);
        int i = (int) nums.length() - 2;
        while (i >= 0 && nums[i] >= nums[i + 1]) {
            i--;
        }
        if (i < 0) {
            return -1;
        }

        int j = nums.size() - 1;
        while (j >= 0 && nums[i] >= nums[j]) {
            j--;
        }
        swap(nums[i], nums[j]);
        reverse(nums.begin() + i + 1, nums.end());
        long ans = stol(nums);
        return ans > INT_MAX ? -1 : ans;
    }
};
```

```Java [sol1-Java]
class Solution {
    public int nextGreaterElement(int n) {
        char[] nums = Integer.toString(n).toCharArray();
        int i = nums.length - 2;
        while (i >= 0 && nums[i] >= nums[i + 1]) {
            i--;
        }
        if (i < 0) {
            return -1;
        }

        int j = nums.length - 1;
        while (j >= 0 && nums[i] >= nums[j]) {
            j--;
        }
        swap(nums, i, j);
        reverse(nums, i + 1);
        long ans = Long.parseLong(new String(nums));
        return ans > Integer.MAX_VALUE ? -1 : (int) ans;
    }

    public void reverse(char[] nums, int begin) {
        int i = begin, j = nums.length - 1;
        while (i < j) {
            swap(nums, i, j);
            i++;
            j--;
        }
    }

    public void swap(char[] nums, int i, int j) {
        char temp = nums[i];
        nums[i] = nums[j];
        nums[j] = temp;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int NextGreaterElement(int n) {
        char[] nums = n.ToString().ToCharArray();
        int i = nums.Length - 2;
        while (i >= 0 && nums[i] >= nums[i + 1]) {
            i--;
        }
        if (i < 0) {
            return -1;
        }

        int j = nums.Length - 1;
        while (j >= 0 && nums[i] >= nums[j]) {
            j--;
        }
        Swap(nums, i, j);
        Reverse(nums, i + 1);
        long ans = long.Parse(new string(nums));
        return ans > int.MaxValue ? -1 : (int) ans;
    }

    public void Reverse(char[] nums, int begin) {
        int i = begin, j = nums.Length - 1;
        while (i < j) {
            Swap(nums, i, j);
            i++;
            j--;
        }
    }

    public void Swap(char[] nums, int i, int j) {
        char temp = nums[i];
        nums[i] = nums[j];
        nums[j] = temp;
    }
}
```

```go [sol1-Golang]
func nextGreaterElement(n int) int {
    nums := []byte(strconv.Itoa(n))
    i := len(nums) - 2
    for i >= 0 && nums[i] >= nums[i+1] {
        i--
    }
    if i < 0 {
        return -1
    }

    j := len(nums) - 1
    for j >= 0 && nums[i] >= nums[j] {
        j--
    }
    nums[i], nums[j] = nums[j], nums[i]
    reverse(nums[i+1:])
    ans, _ := strconv.Atoi(string(nums))
    if ans > math.MaxInt32 {
        return -1
    }
    return ans
}

func reverse(a []byte) {
    for i, n := 0, len(a); i < n/2; i++ {
        a[i], a[n-1-i] = a[n-1-i], a[i]
    }
}
```

```C [sol1-C]
int nextGreaterElement(int n){
    char nums[32];
    sprintf(nums, "%d", n);
    int i = (int) strlen(nums) - 2;
    while (i >= 0 && nums[i] >= nums[i + 1]) {
        i--;
    }
    if (i < 0) {
        return -1;
    }

    int j = strlen(nums) - 1;
    while (j >= 0 && nums[i] >= nums[j]) {
        j--;
    }
    int num = nums[i];
    nums[i] = nums[j];
    nums[j] = num;
    int left = i + 1;
    int right = strlen(nums) - 1;
    while (left < right) {
        int num = nums[left];
        nums[left] = nums[right];
        nums[right] = num;
        left++;
        right--;
    }
    long ans = atol(nums);
    return ans > INT_MAX ? -1 : ans;
}
```

```JavaScript [sol1-JavaScript]
const MAX = 2147483647;
var nextGreaterElement = function(n) {
    const nums = [...('' + n)];
    let i = nums.length - 2;
    while (i >= 0 && nums[i] >= nums[i + 1]) {
        i--;
    }
    if (i < 0) {
        return -1;
    }

    let j = nums.length - 1;
    while (j >= 0 && nums[i] >= nums[j]) {
        j--;
    }
    [nums[i], nums[j]] = [nums[j], nums[i]];
    reverse(nums, i + 1);
    const ans = 0 + nums.join('');
    return ans > MAX ? -1 : ans;
};

const reverse = (nums, begin) => {
    let i = begin, j = nums.length - 1;
    while (i < j) {
        [nums[i], nums[j]] = [nums[j], nums[i]];
        i++;
        j--;
    }
}
```

**复杂度分析**

- 时间复杂度：$O(\log n)$。

- 空间复杂度：$O(\log n)$。

#### 方法二：数学

不转换成字符数组，如何用 $O(1)$ 空间复杂度解决此题？

如果还要求不使用 $64$ 位整数呢？

类似方法一，我们从 $n$ 开始，不断比较其最低位数字和次低位数字的大小，如果次低位数字不低于最低位数字，则移除最低位数字，继续循环。循环结束后的 $n$ 就对应着方法一的下标 $i$，即 $\textit{nums}$ 的前 $i+1$ 个字符。

对于方法一中下标 $j$ 的计算也是同理。

最后，我们参考 [7. 整数反转的官方题解](https://leetcode.cn/problems/reverse-integer/solution/zheng-shu-fan-zhuan-by-leetcode-solution-bccn/) 的做法，将 $i+1$ 之后的部分反转，即得到下一个整数。如果中途计算会溢出，则返回 $-1$。

```Python [sol2-Python3]
class Solution:
    def nextGreaterElement(self, n: int) -> int:
        x, cnt = n, 1
        while x >= 10 and x // 10 % 10 >= x % 10:
            cnt += 1
            x //= 10
        x //= 10
        if x == 0:
            return -1

        targetDigit = x % 10
        x2, cnt2 = n, 0
        while x2 % 10 <= targetDigit:
            cnt2 += 1
            x2 //= 10
        x += x2 % 10 - targetDigit  # 把 x2 % 10 换到 targetDigit 上

        MAX_INT = 2 ** 31 - 1
        for i in range(cnt):  # 反转 n 末尾的 cnt 个数字拼到 x 后
            d = n % 10 if i != cnt2 else targetDigit
            # 为了演示算法，请读者把 x 视作一个 32 位有符号整数
            if x > MAX_INT // 10 or x == MAX_INT // 10 and d > 7:
                return -1
            x = x * 10 + d
            n //= 10
        return x
```

```C++ [sol2-C++]
class Solution {
public:
    int nextGreaterElement(int n) {
        int x = n, cnt = 1;
        for (; x >= 10 && x / 10 % 10 >= x % 10; x /= 10) {
            ++cnt;
        }
        x /= 10;
        if (x == 0) {
            return -1;
        }

        int targetDigit = x % 10;
        int x2 = n, cnt2 = 0;
        for (; x2 % 10 <= targetDigit; x2 /= 10) {
            ++cnt2;
        }
        x += x2 % 10 - targetDigit; // 把 x2 % 10 换到 targetDigit 上

        for (int i = 0; i < cnt; ++i, n /= 10) { // 反转 n 末尾的 cnt 个数字拼到 x 后
            int d = i != cnt2 ? n % 10 : targetDigit;
            if (x > INT_MAX / 10 || x == INT_MAX / 10 && d > 7) {
                return -1;
            }
            x = x * 10 + d;
        }
        return x;
    }
};
```

```Java [sol2-Java]
class Solution {
    public int nextGreaterElement(int n) {
        int x = n, cnt = 1;
        for (; x >= 10 && x / 10 % 10 >= x % 10; x /= 10) {
            ++cnt;
        }
        x /= 10;
        if (x == 0) {
            return -1;
        }

        int targetDigit = x % 10;
        int x2 = n, cnt2 = 0;
        for (; x2 % 10 <= targetDigit; x2 /= 10) {
            ++cnt2;
        }
        x += x2 % 10 - targetDigit; // 把 x2 % 10 换到 targetDigit 上

        for (int i = 0; i < cnt; ++i, n /= 10) { // 反转 n 末尾的 cnt 个数字拼到 x 后
            int d = i != cnt2 ? n % 10 : targetDigit;
            if (x > Integer.MAX_VALUE / 10 || x == Integer.MAX_VALUE / 10 && d > 7) {
                return -1;
            }
            x = x * 10 + d;
        }
        return x;
    }
}
```

```C# [sol2-C#]
public class Solution {
    public int NextGreaterElement(int n) {
        int x = n, cnt = 1;
        for (; x >= 10 && x / 10 % 10 >= x % 10; x /= 10) {
            ++cnt;
        }
        x /= 10;
        if (x == 0) {
            return -1;
        }

        int targetDigit = x % 10;
        int x2 = n, cnt2 = 0;
        for (; x2 % 10 <= targetDigit; x2 /= 10) {
            ++cnt2;
        }
        x += x2 % 10 - targetDigit; // 把 x2 % 10 换到 targetDigit 上

        for (int i = 0; i < cnt; ++i, n /= 10) { // 反转 n 末尾的 cnt 个数字拼到 x 后
            int d = i != cnt2 ? n % 10 : targetDigit;
            if (x > int.MaxValue / 10 || x == int.MaxValue / 10 && d > 7) {
                return -1;
            }
            x = x * 10 + d;
        }
        return x;
    }
}
```

```go [sol2-Golang]
func nextGreaterElement(n int) int {
    x, cnt := n, 1
    for ; x >= 10 && x/10%10 >= x%10; x /= 10 {
        cnt++
    }
    x /= 10
    if x == 0 {
        return -1
    }

    targetDigit := x % 10
    x2, cnt2 := n, 0
    for ; x2%10 <= targetDigit; x2 /= 10 {
        cnt2++
    }
    x += x2%10 - targetDigit // 把 x2%10 换到 targetDigit 上

    for i := 0; i < cnt; i++ { // 反转 n 末尾的 cnt 个数字拼到 x 后
        d := targetDigit
        if i != cnt2 {
            d = n % 10
        }
        if x > math.MaxInt32/10 || x == math.MaxInt32/10 && d > 7 {
            return -1
        }
        x = x*10 + d
        n /= 10
    }
    return x
}
```

```C [sol2-C]
int nextGreaterElement(int n){
    int x = n, cnt = 1;
    for (; x >= 10 && x / 10 % 10 >= x % 10; x /= 10) {
        ++cnt;
    }
    x /= 10;
    if (x == 0) {
        return -1;
    }

    int targetDigit = x % 10;
    int x2 = n, cnt2 = 0;
    for (; x2 % 10 <= targetDigit; x2 /= 10) {
        ++cnt2;
    }
    x += x2 % 10 - targetDigit; // 把 x2 % 10 换到 targetDigit 上

    for (int i = 0; i < cnt; ++i, n /= 10) { // 反转 n 末尾的 cnt 个数字拼到 x 后
        int d = i != cnt2 ? n % 10 : targetDigit;
        if (x > INT_MAX / 10 || x == INT_MAX / 10 && d > 7) {
            return -1;
        }
        x = x * 10 + d;
    }
    return x;
}
```

**复杂度分析**

- 时间复杂度：$O(\log n)$。

- 空间复杂度：$O(1)$。我们只需要常数的空间保存若干变量。
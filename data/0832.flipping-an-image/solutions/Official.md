#### 方法一：模拟优化 + 双指针

最直观的做法是首先对矩阵 $\textit{image}$ 的每一行进行水平翻转操作，然后对矩阵中的每个元素进行反转操作。该做法需要遍历矩阵两次。

是否可以只遍历矩阵一次就完成上述操作？答案是肯定的。

假设矩阵的行数和列数都是 $n$，考虑列下标 $\textit{left}$ 和 $\textit{right}$，其中 $\textit{left}<\textit{right}$ 且 $\textit{left}+\textit{right}=n-1$，当 $0 \le i<n$ 时，对第 $i$ 行进行水平翻转之后，$\textit{image}[i][\textit{left}]$ 和 $\textit{image}[i][\textit{right}]$ 的元素值会互换，进行反转之后，$\textit{image}[i][\textit{left}]$ 和 $\textit{image}[i][\textit{right}]$ 的元素值都会改变。

具体而言，考虑以下四种情况。

- 情况一：$\textit{image}[i][\textit{left}]=0,\textit{image}[i][\textit{right}]=0$。对第 $i$ 行进行水平翻转之后，$\textit{image}[i][\textit{left}]=0,\textit{image}[i][\textit{right}]=0$。进行反转之后，$\textit{image}[i][\textit{left}]=1,\textit{image}[i][\textit{right}]=1$。

- 情况二：$\textit{image}[i][\textit{left}]=1,\textit{image}[i][\textit{right}]=1$。对第 $i$ 行进行水平翻转之后，$\textit{image}[i][\textit{left}]=1,\textit{image}[i][\textit{right}]=1$。进行反转之后，$\textit{image}[i][\textit{left}]=0,\textit{image}[i][\textit{right}]=0$。

- 情况三：$\textit{image}[i][\textit{left}]=0,\textit{image}[i][\textit{right}]=1$。对第 $i$ 行进行水平翻转之后，$\textit{image}[i][\textit{left}]=1,\textit{image}[i][\textit{right}]=0$。进行反转之后，$\textit{image}[i][\textit{left}]=0,\textit{image}[i][\textit{right}]=1$。

- 情况四：$\textit{image}[i][\textit{left}]=1,\textit{image}[i][\textit{right}]=0$。对第 $i$ 行进行水平翻转之后，$\textit{image}[i][\textit{left}]=0,\textit{image}[i][\textit{right}]=1$。进行反转之后，$\textit{image}[i][\textit{left}]=1,\textit{image}[i][\textit{right}]=0$。

情况一和情况二是 $\textit{image}[i][\textit{left}]=\textit{image}[i][\textit{right}]$ 的情况。在进行水平翻转和反转之后，$\textit{image}[i][\textit{left}]$ 和 $\textit{image}[i][\textit{right}]$ 的元素值都发生了改变，即元素值被反转。

情况三和情况四是 $\textit{image}[i][\textit{left}]\ne \textit{image}[i][\textit{right}]$ 的情况。在进行水平翻转和反转之后，$\textit{image}[i][\textit{left}]$ 和 $\textit{image}[i][\textit{right}]$ 的元素值都发生了两次改变，恢复原状。

因此，可以遍历矩阵一次即完成水平翻转和反转。

遍历矩阵的每一行。对于矩阵的第 $i$ 行，初始化 $\textit{left}=0$ 和 $\textit{right}=n-1$，进行如下操作：

- 当 $\textit{left}<\textit{right}$ 时，判断 $\textit{image}[i][\textit{left}]$ 和 $\textit{image}[i][\textit{right}]$ 是否相等，如果相等则对 $\textit{image}[i][\textit{left}]$ 和 $\textit{image}[i][\textit{right}]$ 的值进行反转，如果不相等则不进行任何操作；

- 将 $\textit{left}$ 的值加 $1$，将 $\textit{right}$ 的值减 $1$，重复上述操作，直到 $\textit{left} \ge \textit{right}$；

- 如果 $n$ 是奇数，则上述操作结束时，$\textit{left}$ 和 $\textit{right}$ 的值相等，都指向第 $i$ 行的中间元素，此时需要对中间元素的值进行反转。

```Java [sol1-Java]
class Solution {
    public int[][] flipAndInvertImage(int[][] image) {
        int n = image.length;
        for (int i = 0; i < n; i++) {
            int left = 0, right = n - 1;
            while (left < right) {
                if (image[i][left] == image[i][right]) {
                    image[i][left] ^= 1;
                    image[i][right] ^= 1;
                }
                left++;
                right--;
            }
            if (left == right) {
                image[i][left] ^= 1;
            }
        }
        return image;
    }
}
```

```JavaScript [sol1-JavaScript]
var flipAndInvertImage = function(image) {
    const n = image.length;
    for (let i = 0; i < n; i++) {
        let left = 0, right = n - 1;
        while (left < right) {
            if (image[i][left] === image[i][right]) {
                image[i][left] ^= 1;
                image[i][right] ^= 1;
            }
            left++;
            right--;
        }
        if (left === right) {
            image[i][left] ^= 1;
        }
    }
    return image;
};
```

```go [sol1-Golang]
func flipAndInvertImage(image [][]int) [][]int {
    for _, row := range image {
        left, right := 0, len(row)-1
        for left < right {
            if row[left] == row[right] {
                row[left] ^= 1
                row[right] ^= 1
            }
            left++
            right--
        }
        if left == right {
            row[left] ^= 1
        }
    }
    return image
}
```

```Python [sol1-Python3]
class Solution:
    def flipAndInvertImage(self, image: List[List[int]]) -> List[List[int]]:
        n = len(image)
        for i in range(n):
            left, right = 0, n - 1
            while left < right:
                if image[i][left] == image[i][right]:
                    image[i][left] ^= 1
                    image[i][right] ^= 1
                left += 1
                right -= 1
            if left == right:
                image[i][left] ^= 1
        return image
```

```C++ [sol1-C++]
class Solution {
public:
    vector<vector<int>> flipAndInvertImage(vector<vector<int>>& image) {
        int n = image.size();
        for (int i = 0; i < n; i++) {
            int left = 0, right = n - 1;
            while (left < right) {
                if (image[i][left] == image[i][right]) {
                    image[i][left] ^= 1;
                    image[i][right] ^= 1;
                }
                left++;
                right--;
            }
            if (left == right) {
                image[i][left] ^= 1;
            }
        }
        return image;
    }
};
```

```C [sol1-C]
int** flipAndInvertImage(int** image, int imageSize, int* imageColSize, int* returnSize, int** returnColumnSizes) {
    *returnSize = imageSize;
    *returnColumnSizes = imageColSize;
    int n = imageSize;
    for (int i = 0; i < n; i++) {
        int left = 0, right = n - 1;
        while (left < right) {
            if (image[i][left] == image[i][right]) {
                image[i][left] ^= 1;
                image[i][right] ^= 1;
            }
            left++;
            right--;
        }
        if (left == right) {
            image[i][left] ^= 1;
        }
    }
    return image;
}
```

**复杂度分析**

- 时间复杂度：$O(n^2)$，其中 $n$ 是矩阵 $\textit{image}$ 的行数和列数。需要遍历矩阵一次，进行翻转操作。

- 空间复杂度：$O(1)$。除了返回值以外，额外使用的空间为常数。
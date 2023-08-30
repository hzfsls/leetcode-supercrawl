#### 方法一：线性查找

由于给定的列表已经按照递增顺序排序，因此可以从左到右遍历列表，找到第一个比目标字母大的字母，即为比目标字母大的最小字母。

如果目标字母小于列表中的最后一个字母，则一定可以在列表中找到比目标字母大的最小字母。如果目标字母大于或等于列表中的最后一个字母，则列表中不存在比目标字母大的字母，根据循环出现的顺序，列表的首个字母是比目标字母大的最小字母。

```Python [sol1-Python3]
class Solution:
    def nextGreatestLetter(self, letters: List[str], target: str) -> str:
        return next((letter for letter in letters if letter > target), letters[0])
```

```Java [sol1-Java]
class Solution {
    public char nextGreatestLetter(char[] letters, char target) {
        int length = letters.length;
        char nextGreater = letters[0];
        for (int i = 0; i < length; i++) {
            if (letters[i] > target) {
                nextGreater = letters[i];
                break;
            }
        }
        return nextGreater;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public char NextGreatestLetter(char[] letters, char target) {
        int length = letters.Length;
        char nextGreater = letters[0];
        for (int i = 0; i < length; i++) {
            if (letters[i] > target) {
                nextGreater = letters[i];
                break;
            }
        }
        return nextGreater;
    }
}
```

```C++ [sol1-C++]
class Solution {
public:
    char nextGreatestLetter(vector<char>& letters, char target) {
        for (char letter : letters) {
            if (letter > target) {
                return letter;
            }
        }
        return letters[0];
    }
};
```

```C [sol1-C]
char nextGreatestLetter(char* letters, int lettersSize, char target){
    for (int i = 0; i < lettersSize; i++) {
        if (letters[i] > target) {
            return letters[i];
        }
    }
    return letters[0];
}
```

```JavaScript [sol1-JavaScript]
var nextGreatestLetter = function(letters, target) {
    const length = letters.length;
    let nextGreater = letters[0];
    for (let i = 0; i < length; i++) {
        if (letters[i] > target) {
            nextGreater = letters[i];
            break;
        }
    }
    return nextGreater;
};
```

```go [sol1-Golang]
func nextGreatestLetter(letters []byte, target byte) byte {
    for _, letter := range letters {
        if letter > target {
            return letter
        }
    }
    return letters[0]
}
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 是列表 $\textit{letters}$ 的长度。需要遍历列表一次寻找比目标字母大的最小字母。

- 空间复杂度：$O(1)$。

#### 方法二：二分查找

利用列表有序的特点，可以使用二分查找降低时间复杂度。

首先比较目标字母和列表中的最后一个字母，当目标字母大于或等于列表中的最后一个字母时，答案是列表的首个字母。当目标字母小于列表中的最后一个字母时，列表中一定存在比目标字母大的字母，可以使用二分查找得到比目标字母大的最小字母。

初始时，二分查找的范围是整个列表的下标范围。每次比较当前下标处的字母和目标字母，如果当前下标处的字母大于目标字母，则在当前下标以及当前下标的左侧继续查找，否则在当前下标的右侧继续查找。

```Python [sol2-Python3]
class Solution:
    def nextGreatestLetter(self, letters: List[str], target: str) -> str:
        return letters[bisect_right(letters, target)] if target < letters[-1] else letters[0]
```

```Java [sol2-Java]
class Solution {
    public char nextGreatestLetter(char[] letters, char target) {
        int length = letters.length;
        if (target >= letters[length - 1]) {
            return letters[0];
        }
        int low = 0, high = length - 1;
        while (low < high) {
            int mid = (high - low) / 2 + low;
            if (letters[mid] > target) {
                high = mid;
            } else {
                low = mid + 1;
            }
        }
        return letters[low];
    }
}
```

```C# [sol2-C#]
public class Solution {
    public char NextGreatestLetter(char[] letters, char target) {
        int length = letters.Length;
        if (target >= letters[length - 1]) {
            return letters[0];
        }
        int low = 0, high = length - 1;
        while (low < high) {
            int mid = (high - low) / 2 + low;
            if (letters[mid] > target) {
                high = mid;
            } else {
                low = mid + 1;
            }
        }
        return letters[low];
    }
}
```

```C++ [sol2-C++]
class Solution {
public:
    char nextGreatestLetter(vector<char> &letters, char target) {
        return target < letters.back() ? *upper_bound(letters.begin(), letters.end() - 1, target) : letters[0];
    }
};
```

```C [sol2-C]
char nextGreatestLetter(char* letters, int lettersSize, char target){
    if (target >= letters[lettersSize - 1]) {
        return letters[0];
    }
    int low = 0, high = lettersSize - 1;
    while (low < high) {
        int mid = (high - low) / 2 + low;
        if (letters[mid] > target) {
            high = mid;
        } else {
            low = mid + 1;
        }
    }
    return letters[low];
}
```

```JavaScript [sol2-JavaScript]
var nextGreatestLetter = function(letters, target) {
    const length = letters.length;
    if (target >= letters[length - 1]) {
        return letters[0];
    }
    let low = 0, high = length - 1;
    while (low < high) {
        const mid = Math.floor((high - low) / 2) + low;
        if (letters[mid] > target) {
            high = mid;
        } else {
            low = mid + 1;
        }
    }
    return letters[low];
};
```

```go [sol2-Golang]
func nextGreatestLetter(letters []byte, target byte) byte {
    if target >= letters[len(letters)-1] {
        return letters[0]
    }
    i := sort.Search(len(letters)-1, func(i int) bool { return letters[i] > target })
    return letters[i]
}
```

**复杂度分析**

- 时间复杂度：$O(\log n)$，其中 $n$ 是列表 $\textit{letters}$ 的长度。二分查找的时间复杂度是 $O(\log n)$。

- 空间复杂度：$O(1)$。
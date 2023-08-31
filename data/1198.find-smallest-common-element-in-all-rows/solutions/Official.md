## [1198.找出所有行中最小公共元素 中文官方题解](https://leetcode.cn/problems/find-smallest-common-element-in-all-rows/solutions/100000/zhao-chu-suo-you-xing-zhong-zui-xiao-gon-rbmb)

[TOC]

 ## 解决方案

---

 由于每行都按递增顺序排序，这告诉我们单行中不会有重复元素。因此，如果一个元素在所有行中都出现，那么它会出现`n`次（其中`n`是行数）。
 我们可以数所有的元素，然后从左到右选择最小的元素，它出现`n`次。这种方法 的时间复杂度是线性的 
需要使用额外的内存来存储计数。
 此外，我们可以使用二分查找在矩阵中直接查找元素。我们将不需要任何额外的内存，尽管这种方式会稍慢一些。
 最后，我们可以为每行跟踪位置。然后，我们将反复推进较小元素的位置，直到所有位置指向公共元素 
时间复杂度是线性的，并且将比存储计数时需要更少的内存。

---

 #### 方法 1：元素计数
 逐行遍历所有元素并计算每个元素。由于元素的取值范围是 `[1...10000]`，我们将使用这个大小的数组存储计数值。
 然后，从左到右遍历数组，并返回第一个出现 `n` 次的元素。顺便说一下，这就是计数排序的工作方式。
 > 对于不受约束的问题，我们将需要使用一个有序映射来存储计数。

 ![image.png](https://pic.leetcode.cn/1692165127-cJHSsn-image.png){:width=400}

 **算法**
1.遍历每一行`i`。
  - 遍历每一列`j`。
  - 增加元素`mat[i][j]`的`count`。

2.从`1`到`10000`遍历`k`。
  - 如果`count[k]`等于`n`，返回`k`。

3.返回`-1`。


 ```C++ [solution]
int smallestCommonElement(vector<vector<int>>& mat) {
    int count[10001] = {};
    int n = mat.size(), m = mat[0].size();
    for (int i = 0; i < n; ++i) {
        for (int j = 0; j < m; ++j) {
            ++count[mat[i][j]];
        }
    }
    for (int k = 1; k <= 10000; ++k) {
        if (count[k] == n) {
            return k;
        }
    }
    return -1;
}
 ```
```Java [solution]
public int smallestCommonElement(int[][] mat) {
    int count[] = new int[10001];
    int n = mat.length, m = mat[0].length;
    for (int i = 0; i < n; ++i) {
        for (int j = 0; j < m; ++j) {
            ++count[mat[i][j]];
        }
    }
    for (int k = 1; k <= 10000; ++k) {
        if (count[k] == n) {
            return k;
        }
    } 
    return -1;
}
```


 **解决方案改进**
 如果我们按列计元素，我们可以改进平均时间复杂度。这样，小的元素将首先被计算，我们可以在获取到重复`n`次的元素时立即退出。
 > 对于一个无约束的问题，如果我们按列算元素，我们可以使用一个无序映射（这应该比有序映射快，就像初始方案一样）。
 ```C++ [solution]
int smallestCommonElement(vector<vector<int>>& mat) {
    int count[10001] = {};
    int n = mat.size(), m = mat[0].size();
    for (int j = 0; j < m; ++j) {
        for (int i = 0; i < n; ++i) {
            if (++count[mat[i][j]] == n) {
                return mat[i][j];
            }
        }
    }
    return -1;
}
 ```
```Java [solution]
public int smallestCommonElement(int[][] mat) {
    int count[] = new int[10001];
    int n = mat.length, m = mat[0].length;
    for (int j = 0; j < m; ++j) {
        for (int i = 0; i < n; ++i) {
            if (++count[mat[i][j]] == n) {
                return mat[i][j];
            }
        }
    }
    return -1;
}
```


 **处理重复项**
 如果元素是非递减的，我们将需要修改这些解决方案以正确处理重复项。例如，对于以下测试用例，我们返回 `4` （初始解决方案）和 `7` （改进的解决方案）而不是 `5` ：
 `[[1,2,3,4,5],[5,7,7,7,7],[5,7,7,7,7],[1,2,4,4,5],[1,2,4,4,5]]`
 修改这些解决方案以处理重复项很容易。由于一行中的元素是排序的，如果当前元素等于前一个元素，我们可以跳过当前元素。
 **复杂度分析**
 - 时间复杂度：$\mathcal{O}(nm)$，其中$n$和$m$为行数和列数。
 - 空间复杂度：
    - 受限问题：$\mathcal{O}(10000)=\mathcal{O}(1)$。
    - 无约束问题：$\mathcal{O}(k)$，其中$k$是唯一元素的数量。
    
---

 #### 方法 2：二分查找
 我们可以遍历第一行的每个元素，然后使用二分查找来检查该元素是否存在于所有其他行中。

 <![image.png](https://pic.leetcode.cn/1692165642-awhzAn-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692165645-LeFFxM-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692165648-CvHdye-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692165650-CZAkso-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692165653-TzsjyJ-image.png){:width=400}>

 **算法**
 1. 遍历第一行的每个元素。
    - 初始化 `found` 为 true。
    - 对于每一行：
      - 使用二分查找检查元素是否存在。
      - 如果不存在，设置 `found` 为 false 并退出循环。
      - 如果 `found` 是 true，返回该元素。

 2. 返回 `-1`。
 ```C++ [solution]
int smallestCommonElement(vector<vector<int>>& mat) {
    int n = mat.size(), m = mat[0].size();
    for (int j = 0; j < m; ++j) {
        bool found = true;
        for (int i = 1; i < n && found; ++i) {
            found = binary_search(begin(mat[i]), end(mat[i]), mat[0][j]);
        }
        if (found) {
            return mat[0][j];
        }
    }
    return -1;
}
 ```
```Java [solution]
public int smallestCommonElement(int[][] mat) {
    int n = mat.length, m = mat[0].length;
    for (int j = 0; j < m; ++j) {
        boolean found = true;
        for (int i = 1; i < n && found; ++i) {
            found = Arrays.binarySearch(mat[i], mat[0][j]) >= 0;
        }
        if (found) {
            return mat[0][j];
        }
    }
    return -1;
}
```


 **解决方案改进**
 在上面的方案中，我们总是搜索整行。我们可以改进平均时间复杂度，如果我们从上一个搜索返回的位置开始下一次搜索。我们也可以在行中的所有元素都小于我们搜索的值时返回 `-1`。
 > 请注意，C++ 中的 `lower_bound`返回等于（如果存在）或大于搜索值的第一个元素的位置。在 Java 中，`binarySearch`返回一个正索引，如果元素存在，或者`(-insertion_point - 1)`，其中`insertion_point`也是下一个更大元素的位置。在两种情况下，如果所有的元素都小于被搜索的值，它就会指向最后一个元素。
 ```C++ [solution]
int smallestCommonElement(vector<vector<int>>& mat) {
    int n = mat.size(), m = mat[0].size();
    vector<int> pos(n);
    for (int j = 0; j < m; ++j) {
        bool found = true;
        for (int i = 1; i < n && found; ++i) {
            pos[i] = lower_bound(begin(mat[i]) + pos[i], end(mat[i]), mat[0][j]) - begin(mat[i]);
            if (pos[i] >= m) {
                return -1;
            }
            found = mat[i][pos[i]] == mat[0][j];
        }
        if (found) {
            return mat[0][j];
        }
    }
    return -1;
}
 ```
```Java [solution]
public int smallestCommonElement(int[][] mat) {
    int n = mat.length, m = mat[0].length;
    int pos[] = new int[n];
    for (int j = 0; j < m; ++j) {
        boolean found = true;
        for (int i = 1; i < n && found; ++i) {
            pos[i] = Arrays.binarySearch(mat[i], pos[i], m, mat[0][j]);
            if (pos[i] < 0) {
                found = false;
                pos[i] = -pos[i] - 1;
                if (pos[i] >= m) {
                    return -1;
                }
            }
        }
        if (found) {
            return mat[0][j];
        }
    }
    return -1;
}
```


 **处理重复项**
 由于我们在每行中搜索一个元素，如果有重复项，此方法 可以正确地工作。
 **复杂度分析**
- 时间复杂度：$\mathcal{O}(mn\log{m})$
    - 我们在第一行遍历 $m$个 元素。
    - 对于每个元素，我们在 $m$ 个元素上执行 $n$ 次二分查找。
 - 空间复杂度：
    - 原始解决方案：$\mathcal{O}(1)$.
    - 改进的解决方案：$\mathcal{O}(n)$，用于存储所有行的搜索位置。

---

 #### 方法 3：行位置
 我们可以按照 [23.合并k个排序链表](https://leetcode.cn/problems/merge-k-sorted-lists/solution/) 中关于方法 2描述的方式，按排序顺序遍历所有行中的元素。
 对于每一行，我们跟踪当前元素的位置，从零开始。然后，我们找出所有位置中最小的元素，并推进相应行的位置。当所有位置指向值相同的元素时，我们找到了我们的答案。
 然而，对于这个问题，我们不需要完美地按照排序的顺序列出元素。我们可以确定所有位置中的最大元素，并在所有其他行中跳过较小的元素。

 <![image.png](https://pic.leetcode.cn/1692166409-jxgzJY-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692166416-iVpLWj-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692166419-gEuEIZ-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692166422-euGWyn-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692166424-tgOLKY-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692166427-ujkWap-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692166430-JAqnuH-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692166434-kuDXjB-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692166436-CaRiGm-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692166438-vJcZbj-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692166442-XdSoJn-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692166444-tyaNPk-image.png){:width=400}>

 **算法**
 1. 使用零初始化行位置，当前最大值和计数器。
 2. 对于每一行：
    - 增加行位置，直到值等于或大于当前最大值。
    - 如果我们到达了行的末尾，返回 `-1`。
    - 如果值等于当前最大值，增加计数器。
    - 否则，将计数器重置为 `1` 并更新当前最大值。
    - 如果计数器等于 `n`，返回当前最大值。
 3. 重复步骤2。

 ```C++ [solution]
int smallestCommonElement(vector<vector<int>>& mat) {
    int n = mat.size(), m = mat[0].size();
    int cur_max = 0, cnt = 0;
    vector<int> pos(n);
    while (true) {
        for (int i = 0; i < n; ++i) {
            while (pos[i] < m && mat[i][pos[i]] < cur_max) {
                ++pos[i];
            }
            if (pos[i] >= m) {
                return -1;
            }
            if (cur_max != mat[i][pos[i]]) {
                cnt = 1;
                cur_max = mat[i][pos[i]];
            } else if (++cnt == n) {
                return cur_max;
            }
        }
    }
    return -1;
}
 ```
```Java [solution]
public int smallestCommonElement(int[][] mat) {
    int n = mat.length, m = mat[0].length;
    int pos[] = new int[n], cur_max = 0, cnt = 0;
    while (true) {
        for (int i = 0; i < n; ++i) {
            while (pos[i] < m && mat[i][pos[i]] < cur_max) {
                ++pos[i];
            }
            if (pos[i] >= m) {
                return -1;
            }
            if (mat[i][pos[i]] != cur_max) {
                cnt = 1;
                cur_max = mat[i][pos[i]];
            } else if (++cnt == n) {
                return cur_max;
            }
        }
    }
}
```


 **处理重复项**
 由于我们从每行取一个元素，所以如果存在重复项，这种方法也可以通过。
 **复杂度分析**
 - 时间复杂度：$\mathcal{O}(nm)$；在最坏的情况下，我们在矩阵中遍历所有的 $nm$ 个元素。
 - 空间复杂度：$\mathcal{O}(n)$，用于存储行索引。

**解决方案改进**
 我们可以使用二分查找推动位置，就像方法 2：二分查找那样。
 虽然它肯定可以改进运行时，但是在最坏的情况下，时间复杂度将是$\mathcal{O}(mn\log{m})$，这比简单增量的 $\mathcal{O}(nm)$ 要差。原因是，如果我们需要一步步推进行位置，二分查找仍然需要 $\mathcal{O}(\log{m})$ 才能找到那个就在下一个的值。
 为了优化最坏情况的情况，我们可以使用单边二分查找（也称为元二分查找），其中我们迭代地将距离从我们的位置翻倍。此类搜索执行的操作数量不会超过原始位置和结果位置之间的距离，这将时间复杂度提升回到 $\mathcal{O}(nm)$。
 ```C++ [solution]
int metaSearch(vector<int> &row, int pos, int val, int d = 1) {
    int sz = row.size();
    while (pos < sz && row[pos] < val) {
        d <<= 1;
        if (row[min(pos + d, sz - 1)] >= val) {
            d = 1;
        }
        pos += d;
    }
    return pos;
}
int smallestCommonElement(vector<vector<int>>& mat) {
    int n = mat.size(), m = mat[0].size();
    int cur_max = 0, cnt = 0;
    vector<int> pos(n);
    while (true) {
        for (int i = 0; i < n; ++i) {
            pos[i] = metaSearch(mat[i], pos[i], cur_max);
            if (pos[i] >= m) {
                return -1;
            }
            if (cur_max != mat[i][pos[i]]) {
                cnt = 1;
                cur_max = mat[i][pos[i]];
            } else if (++cnt == n) {
                return cur_max;
            }
        }
    }
    return -1;
}
 ```
```Java [solution]
private int metaSearch(int[] row, int pos, int val) {
    int sz = row.length, d = 1;
    while (pos < sz && row[pos] < val) {
        d <<= 1;
        if (row[Math.min(pos + d, sz - 1)] >= val) {
            d = 1;
        }
        pos += d;
    }
    return pos;
}    
public int smallestCommonElement(int[][] mat) {
    int n = mat.length, m = mat[0].length;
    int pos[] = new int[n], cur_max = 0, cnt = 0;
    while (true) {
        for (int i = 0; i < n; ++i) {
            pos[i] = metaSearch(mat[i], pos[i], cur_max);
            if (pos[i] >= m) {
                return -1;
            }
            if (mat[i][pos[i]] != cur_max) {
                cnt = 1;
                cur_max = mat[i][pos[i]];
            } else if (++cnt == n) {
                return cur_max;
            }
        }
    }
}
```
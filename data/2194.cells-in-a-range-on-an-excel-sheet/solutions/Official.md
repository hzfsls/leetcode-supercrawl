## [2194.Excel 表中某个范围内的单元格 中文官方题解](https://leetcode.cn/problems/cells-in-a-range-on-an-excel-sheet/solutions/100000/excel-biao-zhong-mou-ge-fan-wei-nei-de-d-uffw)

#### 方法一：模拟

**思路与算法**

根据题意，我们需要遍历满足列号**字典序**在 $[r_1, r_2]$ 闭区间内，且行号在 $[c_1, c_2]$ 内的所有单元格。

我们可以模拟题目中的遍历方式先按列升序遍历，再按行升序遍历目标单元格。与此同时，我们用数组 $\textit{res}$ 维护所有目标单元格，在遍历到每个目标单元格时，我们将列号对应字符与行号对应字符组合在一起并添加进 $\textit{res}$ 中。最终，我们返回 $\textit{res}$ 作为答案。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    vector<string> cellsInRange(string s) {
        vector<string> res;
        for (char row = s[0]; row <= s[3]; ++row) {
            for (char col = s[1]; col <= s[4]; ++col) {
                string cell(1, row);
                cell.push_back(col);
                res.push_back(cell);
            }
        }
        return res;
    }
};
```


```Python [sol1-Python3]
class Solution:
    def cellsInRange(self, s: str) -> List[str]:
        res = []
        for row in range(ord(s[0]), ord(s[3]) + 1):
            for col in range(ord(s[1]), ord(s[4]) + 1):
                res.append(chr(row) + chr(col))
        return res
```


**复杂度分析**

- 时间复杂度：$O(mn)$，其中 $m$ 为列的取值范围，即大写英文字母的个数；$n$ 为行的取值范围，即数字的个数。即为模拟遍历单元格的时间复杂度。

- 空间复杂度：$O(1)$，输出数组不计入空间复杂度。
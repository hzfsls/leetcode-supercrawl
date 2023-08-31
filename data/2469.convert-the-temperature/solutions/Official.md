## [2469.温度转换 中文官方题解](https://leetcode.cn/problems/convert-the-temperature/solutions/100000/wen-du-zhuan-huan-by-leetcode-solution-7bz8)
#### 方法一：模拟

**思路与算法**

题目要求将给定摄氏度 $\textit{celsius}$ 转换为开氏度和华氏度，我们根据题目给定的计算公式直接计算即可，其中计算公式如下:
+ 开氏度：$\text{Kelvin} = \text{Celsius} + 237.15$；
+ 华氏度：$\text{Fahrenheit} = \text{Celsius} \times 1.80 + 32.00$；

**代码**

```Python [sol1-Python3]
class Solution:
    def convertTemperature(self, celsius: float) -> List[float]:
        return [celsius + 273.15, celsius * 1.80 + 32.00]
```

```C++ [sol1-C++]
class Solution {
public:
    vector<double> convertTemperature(double celsius) {
        return {celsius + 273.15, celsius * 1.80 + 32.00};
    }
};
```

```Java [sol1-Java]
class Solution {
    public double[] convertTemperature(double celsius) {
        return new double[]{celsius + 273.15, celsius * 1.80 + 32.00};
    }
}
```

```C# [sol1-C#]
public class Solution {
    public double[] ConvertTemperature(double celsius) {
        return new double[]{celsius + 273.15, celsius * 1.80 + 32.00};
    }
}
```

```C [sol1-C]
double* convertTemperature(double celsius, int* returnSize) {
    double *res = (double *)malloc(sizeof(double) * 2);
    res[0] = celsius + 273.15;
    res[1] = celsius * 1.80 + 32.00;
    *returnSize = 2;
    return res;
}
```

```JavaScript [sol1-JavaScript]
var convertTemperature = function(celsius) {
    return [celsius + 273.15, celsius * 1.80 + 32.00];
};
```

```go [sol1-Golang]
func convertTemperature(celsius float64) []float64 {
    return []float64{celsius + 273.15, celsius * 1.80 + 32.00}
}
```

**复杂度分析**

- 时间复杂度：$O(1)$。

- 空间复杂度：$O(1)$。
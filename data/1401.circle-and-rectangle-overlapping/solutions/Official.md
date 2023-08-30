#### 方法一：分区域讨论

**思路**

在思考这个问题之前，我们先考虑一种临界情况：什么时候圆和矩形只有一个公共点呢？有两种情况：

+ 圆「贴」在矩形的四周
+ 圆「顶」在矩形的顶点

设圆心的坐标为 $(x,y)$，圆的半径为 $r$, 矩形的左下端点为 $(x_1,y_1)$，右上端点为 $(x_2,y_2)$，形式化地，这两种情况可以继续细分：
+ 圆「贴」在矩形的四周
  + $x = x_1 - r, y \in [y_1, y_2]$
  + $x = x_2 + r, y \in [y_1, y_2]$
  + $y = y_1 - r, x \in [x_1, x_2]$
  + $y = y_2 + r, x \in [x_1, x_2]$
+ 圆「顶」在矩形的顶点
  + $(x - x_1)^2 + (y - y_1)^2 = r^2, x \in [x_1 - r, x], y \in [y_1 - r, y]$
  + $(x - x_2)^2 + (y - y_1)^2 = r^2, x \in [x_2, x_2 + r], y \in [y_1 - r, y]$
  + $(x - x_1)^2 + (y - y_2)^2 = r^2, x \in [x_1 - r, x], y \in [y_2, y_2 + r]$
  + $(x - x_2)^2 + (y - y_2)^2 = r^2, x \in [x_2, x_2 + r], y \in [y_2, y_2 + r]$

由此可见，圆心临界位置的轨迹是一个「圆角矩形」——如果我们尝试把圆心向「圆角矩形」内部移动，就一定会出现公共点；如果向「圆角矩形」外部移动，就不会出现公共点。那么问题就转化成了判断圆心是否在这个圆角矩形内，如果在就表示有公共点，否则没有公共点。

![fig1](https://assets.leetcode-cn.com/solution-static/1401/1401_fig1.gif)

对于这个圆角矩形我们可以分成九个部分来讨论：

+ 圆心在中心矩形中：$x \in [x_1, x_2], y \in [y_1, y_2]$
+ 圆心在上部矩形中：$x \in [x_1, x_2], y \in [y_2, y_2 + r]$
+ 圆心在下部矩形中：$x \in [x_1, x_2], y \in [y_1 - r, y_1]$
+ 圆心在左部矩形中：$x \in [x_1 - r, x_1], y \in [y_1, y_2]$
+ 圆心在右部矩形中：$x \in [x_2, x_2 + r], y \in [y_1, y_2]$
+ 圆心在左下方圆角中：$(x - x_1)^2 + (y - y_1)^2 \leq r^2, x \in [x_1 - r, x], y \in [y_1 - r, y]$
+ 圆心在右下方圆角中：$(x - x_2)^2 + (y - y_1)^2 \leq r^2, x \in [x_2, x_2 + r], y \in [y_1 - r, y]$
+ 圆心在左上方圆角中：$(x - x_1)^2 + (y - y_2)^2 \leq r^2, x \in [x_1 - r, x], y \in [y_2, y_2 + r]$
+ 圆心在右上方圆角中：$(x - x_2)^2 + (y - y_2)^2 \leq r^2, x \in [x_2, x_2 + r], y \in [y_2, y_2 + r]$

对于上述情况我们分别进行讨论，由于在判断圆角的情况时，已经判断过五种矩形内的情况，所以不需要再分别讨论横坐标和纵坐标的取值范围，直接判断圆心到顶点的距离即可。

代码如下。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    long long distance(int ux, int uy, int vx, int vy) {
        return (long long)pow(ux - vx, 2) + (long long)pow(uy - vy, 2);
    }

    bool checkOverlap(int radius, int xCenter, int yCenter, int x1, int y1, int x2, int y2) {
        /* 圆心在矩形内部 */
        if (x1 <= xCenter && xCenter <= x2 && y1 <= yCenter && yCenter <= y2) {
            return true;
        }
        /* 圆心在矩形上部*/
        if (x1 <= xCenter && xCenter <= x2 && y2 <= yCenter && yCenter <= y2 + radius) {
            return true;
        }
        /* 圆心在矩形下部*/
        if (x1 <= xCenter && xCenter <= x2 && y1 - radius <= yCenter && yCenter <= y1) {
            return true;
        }
        /* 圆心在矩形左部*/
        if (x1 - radius <= xCenter && xCenter <= x1 && y1 <= yCenter && yCenter <= y2) {
            return true;
        }
        /* 圆心在矩形右部*/
        if (x2 <= xCenter && xCenter <= x2 + radius && y1 <= yCenter && yCenter <= y2) {
            return true;
        }
        /* 矩形左上角 */
        if (distance(xCenter, yCenter, x1, y2) <= radius * radius)  {
            return true;
        }
        /* 矩形左下角 */
        if (distance(xCenter, yCenter, x1, y1) <= radius * radius) {
            return true;
        }
        /* 矩形右上角 */
        if (distance(xCenter, yCenter, x2, y2) <= radius * radius) {
            return true;
        }
        /* 矩形右下角 */
        if (distance(xCenter, yCenter, x1, y2) <= radius * radius) {
            return true;
        }
        /* 无交点 */
        return false;
    }
};
```

```C [sol1-C]
long long distance(int ux, int uy, int vx, int vy) {
    return (long long)pow(ux - vx, 2) + (long long)pow(uy - vy, 2);
}


bool checkOverlap(int radius, int xCenter, int yCenter, int x1, int y1, int x2, int y2) {
    /* 圆心在矩形内部 */
    if (x1 <= xCenter && xCenter <= x2 && y1 <= yCenter && yCenter <= y2) {
        return true;
    }
    /* 圆心在矩形上部 */
    if (x1 <= xCenter && xCenter <= x2 && y2 <= yCenter && yCenter <= y2 + radius) {
        return true;
    }
    /* 圆心在矩形下部 */
    if (x1 <= xCenter && xCenter <= x2 && y1 - radius <= yCenter && yCenter <= y1) {
        return true;
    }
    /* 圆心在矩形左部 */
    if (x1 - radius <= xCenter && xCenter <= x1 && y1 <= yCenter && yCenter <= y2) {
        return true;
    }
    /* 圆心在矩形右部 */
    if (x2 <= xCenter && xCenter <= x2 + radius && y1 <= yCenter && yCenter <= y2) {
        return true;
    }
    /* 矩形左上角 */
    if (distance(xCenter, yCenter, x1, y2) <= radius * radius)  {
        return true;
    }
    /* 矩形左下角 */
    if (distance(xCenter, yCenter, x1, y1) <= radius * radius) {
        return true;
    }
    /* 矩形右上角 */
    if (distance(xCenter, yCenter, x2, y2) <= radius * radius) {
        return true;
    }
    /* 矩形右下角 */
    if (distance(xCenter, yCenter, x1, y2) <= radius * radius) {
        return true;
    }
    /* 无交点 */
    return false;
}
```

```Java [sol1-Java]
class Solution {
    public boolean checkOverlap(int radius, int xCenter, int yCenter, int x1, int y1, int x2, int y2) {
        /* 圆心在矩形内部 */
        if (x1 <= xCenter && xCenter <= x2 && y1 <= yCenter && yCenter <= y2) {
            return true;
        }
        /* 圆心在矩形上部 */
        if (x1 <= xCenter && xCenter <= x2 && y2 <= yCenter && yCenter <= y2 + radius) {
            return true;
        }
        /* 圆心在矩形下部 */
        if (x1 <= xCenter && xCenter <= x2 && y1 - radius <= yCenter && yCenter <= y1) {
            return true;
        }
         /* 圆心在矩形左部 */
        if (x1 - radius <= xCenter && xCenter <= x1 && y1 <= yCenter && yCenter <= y2) {
            return true;
        }
         /* 圆心在矩形右部 */
        if (x2 <= xCenter && xCenter <= x2 + radius && y1 <= yCenter && yCenter <= y2) {
            return true;
        }
        /* 矩形左上角 */
        if (distance(xCenter, yCenter, x1, y2) <= radius * radius)  {
            return true;
        }
        /* 矩形左下角 */
        if (distance(xCenter, yCenter, x1, y1) <= radius * radius) {
            return true;
        }
        /* 矩形右上角 */
        if (distance(xCenter, yCenter, x2, y2) <= radius * radius) {
            return true;
        }
        /* 矩形右下角 */
        if (distance(xCenter, yCenter, x1, y2) <= radius * radius) {
            return true;
        }
        /* 无交点 */
        return false;
    }

    public long distance(int ux, int uy, int vx, int vy) {
        return (long)Math.pow(ux - vx, 2) + (long)Math.pow(uy - vy, 2);
    }
}
```

```C# [sol1-C#]
public class Solution {
    public bool CheckOverlap(int radius, int xCenter, int yCenter, int x1, int y1, int x2, int y2) {
        /* 圆心在矩形内部 */
        if (x1 <= xCenter && xCenter <= x2 && y1 <= yCenter && yCenter <= y2) {
            return true;
        }
        /* 圆心在矩形上部 */
        if (x1 <= xCenter && xCenter <= x2 && y2 <= yCenter && yCenter <= y2 + radius) {
            return true;
        }
        /* 圆心在矩形下部 */
        if (x1 <= xCenter && xCenter <= x2 && y1 - radius <= yCenter && yCenter <= y1) {
            return true;
        }
         /* 圆心在矩形左部 */
        if (x1 - radius <= xCenter && xCenter <= x1 && y1 <= yCenter && yCenter <= y2) {
            return true;
        }
         /* 圆心在矩形右部 */
        if (x2 <= xCenter && xCenter <= x2 + radius && y1 <= yCenter && yCenter <= y2) {
            return true;
        }
        /* 矩形左上角 */
        if (Distance(xCenter, yCenter, x1, y2) <= radius * radius)  {
            return true;
        }
        /* 矩形左下角 */
        if (Distance(xCenter, yCenter, x1, y1) <= radius * radius) {
            return true;
        }
        /* 矩形右上角 */
        if (Distance(xCenter, yCenter, x2, y2) <= radius * radius) {
            return true;
        }
        /* 矩形右下角 */
        if (Distance(xCenter, yCenter, x1, y2) <= radius * radius) {
            return true;
        }
        /* 无交点 */
        return false;
    }

    public long Distance(int ux, int uy, int vx, int vy) {
        return (long)Math.Pow(ux - vx, 2) + (long)Math.Pow(uy - vy, 2);
    }
}
```

```Python [sol1-Python3]
class Solution:
    def checkOverlap(self, radius: int, xCenter: int, yCenter: int, x1: int, y1: int, x2: int, y2: int) -> bool:

        def distance(ux, uy, vx, vy):
            return (ux - vx)**2 + (uy - vy)**2

        """
        圆心在矩形内部
        """
        if x1 <= xCenter <= x2 and y1 <= yCenter <= y2:
            return True

        """
        圆心在矩形上部
        """
        if x1 <= xCenter <= x2 and y2 <= yCenter <= y2 + radius:
            return True

        """
        圆心在矩形下部
        """
        if x1 <= xCenter <= x2 and y1 - radius <= yCenter <= y1:
            return True

        """
        圆心在矩形左部
        """
        if x1 - radius <= xCenter <= x1 and y1 <= yCenter <= y2:
            return True

        """
        圆心在矩形右部
        """
        if x2 <= xCenter <= x2 + radius and y1 <= yCenter <= y2:
            return True

        """
        矩形左上角
        """
        if distance(xCenter, yCenter, x1, y2) <= radius**2:
            return True

        """
        矩形左下角
        """
        if distance(xCenter, yCenter, x1, y1) <= radius**2:
            return True

        """
        矩形右上角
        """
        if distance(xCenter, yCenter, x2, y2) <= radius**2:
            return True

        """
        矩形右下角
        """
        if distance(xCenter, yCenter, x1, y2) <= radius**2:
            return True

        """
        无交点
        """
        return False
```

```Go [sol1-Go]
func distance(ux, uy, vx, vy int) int {
  return (ux - vx) * (ux - vx) +  (uy - vy) * (uy - vy)
}

func checkOverlap(radius int, xCenter int, yCenter int, x1 int, y1 int, x2 int, y2 int) bool {
  // 圆心在矩形内部
  if x1 <= xCenter && xCenter <= x2 && y1 <= yCenter && yCenter <= y2 {
    return true
  }

  // 圆心在矩形上部
  if x1 <= xCenter && xCenter <= x2 && y2 <= yCenter && yCenter <= y2 + radius {
    return true
  }

  // 圆心在矩形下部
  if x1 <= xCenter && xCenter <= x2 && y1 - radius <= yCenter && yCenter <= y1 {
    return true
  }

  // 圆心在矩形左部
  if x1 - radius <= xCenter && xCenter <= x1 && y1 <= yCenter && yCenter <= y2 {
    return true
  }

  // 圆心在矩形右部
  if x2 <= xCenter && xCenter <= x2 + radius && y1 <= yCenter && yCenter <= y2 {
    return true
  }

  // 矩形左上角
  if distance(xCenter, yCenter, x1, y2) <= radius * radius {
    return true
  }

  // 矩形左下角
  if distance(xCenter, yCenter, x1, y1) <= radius * radius {
    return true
  }

  // 矩形右上角
  if distance(xCenter, yCenter, x2, y2) <= radius * radius {
    return true
  }

  // 矩形右下角
  if distance(xCenter, yCenter, x1, y2) <= radius * radius {
    return true
  }

  // 无交点
  return false
}
```

```JavaScript [sol1-JavaScript]
function distance(ux, uy, vx, vy) {
    return (ux - vx) ** 2 + (uy - vy) ** 2
}

var checkOverlap = function(radius, xCenter, yCenter, x1, y1, x2, y2) {
    /* 圆心在矩形内部 */
    if (x1 <= xCenter && xCenter <= x2 && y1 <= yCenter && yCenter <= y2) {
        return true;
    }
    /* 圆心在矩形上部 */
    if (x1 <= xCenter && xCenter <= x2 && y2 <= yCenter && yCenter <= y2 + radius) {
        return true;
    }
    /* 圆心在矩形下部 */
    if (x1 <= xCenter && xCenter <= x2 && y1 - radius <= yCenter && yCenter <= y1) {
        return true;
    }
    /* 圆心在矩形左部 */
    if (x1 - radius <= xCenter && xCenter <= x1 && y1 <= yCenter && yCenter <= y2) {
        return true;
    }
    /* 圆心在矩形右部 */
    if (x2 <= xCenter && xCenter <= x2 + radius && y1 <= yCenter && yCenter <= y2) {
        return true;
    }
    /* 矩形左上角 */
    if (distance(xCenter, yCenter, x1, y2) <= radius * radius) {
        return true;
    }
    /* 矩形左下角 */
    if (distance(xCenter, yCenter, x1, y1) <= radius * radius) {
        return true;
    }
    /* 矩形右上角 */
    if (distance(xCenter, yCenter, x2, y2) <= radius * radius) {
        return true;
    }
    /* 矩形右下角 */
    if (distance(xCenter, yCenter, x1, y2) <= radius * radius) {
        return true;
    }
    /* 无交点 */
    return false;
};
```


**复杂度**

- 时间复杂度：$O(1)$。

- 空间复杂度：$O(1)$。

#### 方法二：求圆心到矩形区域的最短距离

**思路**

在求圆和直线的位置关系时，我们常常会计算圆心到直线的垂直线段的距离。这条垂直线段的距离小于半径的时候，就说明两者相交。更进一步地考虑，其实是因为这条垂直线段的长度已经是圆心到直线上任意点中最小的了，如果最小的线段长度比圆半径小，说明存在点在圆内。

我们可以类比这个思想，来计算求圆心到矩形区域的最短距离。

我们可以分解成两个问题，即圆心到区域 $x_1 \leq x \leq x_2$ 的最小值 $x_{\min}$，和圆心到区域 $y_1 \leq y \leq y_2$ 的最小值 $y_{\min}$，我们可以得到这样的关系：

$$ 
x_{\min}(x) = \left \{
    \begin{aligned}
        0 &,& x \in [x_1, x_2] \\
        \min \{ |x - x_1|, |x - x_2| \} &,& {\rm otherwise}
    \end{aligned} 
\right .
$$
$$
y_{\min}(y) = \left \{
    \begin{aligned}
        0 &,& y \in [y_1, y_2] \\
        \min \{ |y - y_1|, |y - y_2| \} &,& {\rm otherwise}
    \end{aligned} 
\right .
$$

圆心到矩形区域的最小距离就是 $\sqrt{x_{\min}^2 + y_{\min}^2}$。未了方便理解，我们可以把平面区域根据 $x = x_1$、$x = x_2$、$y = y_1$、$y = y_2$ 四条直线分割成九个区域，分类讨论就可以合并到这个结果。

得到这个距离之后，我们再和半径比较，如果这个距离不大于半径的话，就说明存在公共点。

**代码**

```C++ [sol2-C++]
class Solution {
public:
    bool checkOverlap(int radius, int xCenter, int yCenter, int x1, int y1, int x2, int y2) {
        long long dist = 0;
        if (xCenter < x1 || xCenter > x2) {
            dist += min(pow(x1 - xCenter, 2), pow(x2 - xCenter, 2));
        }
        if (yCenter < y1 || yCenter > y2) {
            dist += min(pow(y1 - yCenter, 2), pow(y2 - yCenter, 2));
        }
        return dist <= radius * radius;
    }
};
```

```C [sol2-C]
static double min(double a, double b) {
    return a < b ? a : b;
}

bool checkOverlap(int radius, int xCenter, int yCenter, int x1, int y1, int x2, int y2) {
    double dist = 0;
    if (xCenter < x1 || xCenter > x2) {
        dist += min(pow(x1 - xCenter, 2), pow(x2 - xCenter, 2));
    }
    if (yCenter < y1 || yCenter > y2) {
        dist += min(pow(y1 - yCenter, 2), pow(y2 - yCenter, 2));
    }
    return dist <= radius * radius;
}
```

```Java [sol2-Java]
class Solution {
    public boolean checkOverlap(int radius, int xCenter, int yCenter, int x1, int y1, int x2, int y2) {
        double dist = 0;
        if (xCenter < x1 || xCenter > x2) {
            dist += Math.min(Math.pow(x1 - xCenter, 2), Math.pow(x2 - xCenter, 2));
        }
        if (yCenter < y1 || yCenter > y2) {
            dist += Math.min(Math.pow(y1 - yCenter, 2), Math.pow(y2 - yCenter, 2));
        }
        return dist <= radius * radius;
    }
}
```

```C# [sol2-C#]
public class Solution {
    public bool CheckOverlap(int radius, int xCenter, int yCenter, int x1, int y1, int x2, int y2) {
        double dist = 0;
        if (xCenter < x1 || xCenter > x2) {
            dist += Math.Min(Math.Pow(x1 - xCenter, 2), Math.Pow(x2 - xCenter, 2));
        }
        if (yCenter < y1 || yCenter > y2) {
            dist += Math.Min(Math.Pow(y1 - yCenter, 2), Math.Pow(y2 - yCenter, 2));
        }
        return dist <= radius * radius;
    }
}
```

```Python [sol2-Python3]
class Solution:
    def checkOverlap(self, radius: int, xCenter: int, yCenter: int, x1: int, y1: int, x2: int, y2: int) -> bool:
        dist = 0
        if xCenter < x1 or xCenter > x2:
            dist += min((x1 - xCenter) ** 2, (x2 - xCenter) ** 2)
        if yCenter < y1 or yCenter > y2:
            dist += min((y1 - yCenter) ** 2, (y2 - yCenter) ** 2)
        return dist <= radius ** 2
```

```Go [sol2-Go]
func checkOverlap(radius int, xCenter int, yCenter int, x1 int, y1 int, x2 int, y2 int) bool {
    dist := 0
    if xCenter < x1 || xCenter > x2 {
        dist += min((x1 - xCenter) * (x1 - xCenter), (x2 - xCenter) * (x2 - xCenter))
    }
    if yCenter < y1 || yCenter > y2 {
       dist += min((y1 - yCenter) * (y1 - yCenter), (y2 - yCenter) * (y2 - yCenter))
    }
    return dist <= radius * radius
}

func min(a int, b int) int {
    if a < b {
        return a
    }
    return b
}
```

```JavaScript [sol2-JavaScript]
var checkOverlap = function(radius, xCenter, yCenter, x1, y1, x2, y2) {
    dist = 0;
    if (xCenter < x1 || xCenter > x2) {
        dist += Math.min(Math.pow(x1 - xCenter, 2), Math.pow(x2 - xCenter, 2));
    }
    if (yCenter < y1 || yCenter > y2) {
        dist += Math.min(Math.pow(y1 - yCenter, 2), Math.pow(y2 - yCenter, 2));
    }
    return dist <= radius ** 2;
}
```

**复杂度**

- 时间复杂度：$O(1)$。

- 空间复杂度：$O(1)$。
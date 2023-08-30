[TOC] 

 ## 解决方案 

---

 #### 方法: 使用 `ABS()` 和 `MIN()` 函数 

 **简述** 

 首先计算每两个点之间的距离，然后显示最小的一个。 

 **算法** 

 为了得到每两点之间的距离，我们需要将这个表和它自身进行连接，并使用 `ABS()` 函数，因为距离是非负的。 这里的一个技巧是在联接中添加条件，以避免计算一个点与其自身之间的距离。 

 ```sql 
 SELECT
    p1.x, p2.x, ABS(p1.x - p2.x) AS distance
FROM
    point p1
        JOIN
    point p2 ON p1.x != p2.x
;
 ```
 > 注意：列 p1.x, p2.x 仅用于演示目的，因此实际上并不需要它们。 

 以样本数据为例，输出结果如下。

  ```
| x  | x  | distance |
|----|----|----------|
| 0  | -1 | 1        |
| 2  | -1 | 3        |
| -1 | 0  | 1        |
| 2  | 0  | 2        |
| -1 | 2  | 3        |
| 0  | 2  | 2        |
  ```

 最后，使用 `MIN()` 选取 *distance* 列中的最小值。 

 **MySQL** 

 ```Sql [slu1]
SELECT
    MIN(ABS(p1.x - p2.x)) AS shortest
FROM
    point p1
        JOIN
    point p2 ON p1.x != p2.x
;
 ```
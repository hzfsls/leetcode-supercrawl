[TOC]

## 解决方案 

---

#### 方法：使用自身 `join` 和 `abs()`

 **概述**
 这个问题只有一个表，所以我们可能需要为这个相对复杂的问题使用 **自身连接**。
 **算法**
 首先，让我们看看在自身连接这个表后我们有什么。 
 >注意：连接两个表的结果是这两个表的笛卡尔积。

 ```sql 
 select a.seat_id, a.free, b.seat_id, b.free from cinema a join cinema b;
 ```

| seat_id | free | seat_id | free |
| ------- | ---- | ------- | ---- |
| 1       | 1    | 1       | 1    |
| 2       | 0    | 1       | 1    |
| 3       | 1    | 1       | 1    |
| 4       | 1    | 1       | 1    |
| 5       | 1    | 1       | 1    |
| 1       | 1    | 2       | 0    |
| 2       | 0    | 2       | 0    |
| 3       | 1    | 2       | 0    |
| 4       | 1    | 2       | 0    |
| 5       | 1    | 2       | 0    |
| 1       | 1    | 3       | 1    |
| 2       | 0    | 3       | 1    |
| 3       | 1    | 3       | 1    |
| 4       | 1    | 3       | 1    |
| 5       | 1    | 3       | 1    |
| 1       | 1    | 4       | 1    |
| 2       | 0    | 4       | 1    |
| 3       | 1    | 4       | 1    |
| 4       | 1    | 4       | 1    |
| 5       | 1    | 4       | 1    |
| 1       | 1    | 5       | 1    |
| 2       | 0    | 5       | 1    |
| 3       | 1    | 5       | 1    |
| 4       | 1    | 5       | 1    |
| 5       | 1    | 5       | 1    |

 要找到连续的可用座位，a.seat_id 的值应该比 b.seat_id 的值大（或小），而且它们都应该是空闲的。

 ```sql 
 select a.seat_id, a.free, b.seat_id, b.free from cinema a join cinema b  on abs(a.seat_id - b.seat_id) = 1  and a.free = true and b.free = true;
 ```

| seat_id | free | seat_id | free |
| ------- | ---- | ------- | ---- |
| 4       | 1    | 3       | 1    |
| 3       | 1    | 4       | 1    |
| 5       | 1    | 4       | 1    |
| 4       | 1    | 5       | 1    |

 最后，选择关注的列 seat_id，并按 seat_id 的顺序显示结果。
 >注意：你可能会注意到带有 *seat_id* '4'  的座位在这个表中出现了两次。这是因为座位 '4' 旁边是 '3'，另一边是 '5'。所以我们需要使用 `distinct` 来过滤重复的记录。

 **MySQL**

 ```sql
 select distinct a.seat_id from cinema a join cinema b  on abs(a.seat_id - b.seat_id) = 1  and a.free = true and b.free = true order by a.seat_id ;
 ```
[TOC]

## 解决方案 

---

#### 方法：使用 "会话变量" 和 `join`

 **概述**
 为每个大陆分配一个单独的自动增量行 id，然后将它们连接在一起。
 **算法**
 为每个大陆设置行 id，我们需要使用会话变量。
 例如，我们可以使用以下语句为美洲的学生分配一个自动增量的行号。

```sql
  SELECT 
    row_id, America
FROM
    (SELECT @am:=0) t,
    (SELECT 
        @am:=@am + 1 AS row_id, name AS America
    FROM
        student
    WHERE
        continent = 'America'
    ORDER BY America) AS t2
;
```

```text
| row_id | America |
|--------|---------|
| 1      | Jack    |
| 2      | Jane    |
```

同样，我们可以为其他大陆分配其他专用的行 id，如下所示。

```text
| row_id | Asia |
|--------|------|
| 1      | Xi   |

| row_id | Europe |
|--------|--------|
| 1      | Jesper |
```

 然后，如果我们将这 3 个临时表连接在一起，并使用相同的 row_id 作为条件，我们可以得到以下表。

```text
| row_id | America | Asia | Europe |
|--------|---------|------|--------|
| 1      | Jack    | Xi   | Pascal |
| 2      | Jane    |      |        |
```

一个可能遇到的问题是，如果你使用常规内连接，美洲的学生名单可能不完整，因为与其他两个相比，这个名单中有更多的记录。所以你可能会想到使用 `outer join` 的解决方案。这个想法是正确的！但是怎样排列这 3 个表呢？技巧就是将美洲列表放在中间，这样我们就可以使用 `right (outer) join` 和 `right (outer) join` 来连接其他两个表。

 **MySQL**

 ```sql
 SELECT 
    America, Asia, Europe
FROM
    (SELECT @as:=0, @am:=0, @eu:=0) t,
    (SELECT 
        @as:=@as + 1 AS asid, name AS Asia
    FROM
        student
    WHERE
        continent = 'Asia'
    ORDER BY Asia) AS t1
        RIGHT JOIN
    (SELECT 
        @am:=@am + 1 AS amid, name AS America
    FROM
        student
    WHERE
        continent = 'America'
    ORDER BY America) AS t2 ON asid = amid
        LEFT JOIN
    (SELECT 
        @eu:=@eu + 1 AS euid, name AS Europe
    FROM
        student
    WHERE
        continent = 'Europe'
    ORDER BY Europe) AS t3 ON amid = euid
;
 ```
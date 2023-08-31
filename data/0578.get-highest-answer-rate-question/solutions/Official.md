## [578.查询回答率最高的问题 中文官方题解](https://leetcode.cn/problems/get-highest-answer-rate-question/solutions/100000/cha-xun-hui-da-lu-zui-gao-de-wen-ti-by-leetcode-so)

#### 方法 1：使用两个子查询分别求回答次数与出现次数
##### 想法
$回答率 = 回答次数 / 出现次数$。为了求得回答率，可以先分别求出每个问题的回答次数与出现次数，形成两个子表，然后将子表合并即可。

##### 算法
我们可以首先使用 `count` 求得每个问题出现与回答的次数。
```sql
(select question_id, count(*) as answer_cnt
    from survey_log
    where action = "answer"
    group by question_id) as AnswerCnt
```
以上代码可以查询每个问题的回答次数，将子表命名为 `AnswerCnt`。
```sql
(select question_id, count(*) as action_cnt
    from survey_log
    where action = "show"
    group by question_id) as ShowCnt
```
以上代码可以查询每个问题的出现次数，将子表命名为 `ShowCnt`。
然后将两个表用 `join` 操作合并起来，同时求回答率，排序并取第一名：

```sql
select AnswerCnt.question_id as survey_log from
(select question_id, count(*) as answer_cnt
    from survey_log
    where action = "answer"
    group by question_id) as AnswerCnt
join
(select question_id, count(*) as action_cnt
    from survey_log
    where action = "show"
    group by question_id) as ShowCnt
on AnswerCnt.question_id = ShowCnt.question_id
order by AnswerCnt.answer_cnt / ShowCnt.action_cnt desc
limit 1
```

#### 方法 2：使用一个子查询同时求回答次数与出现次数
##### 想法
方法 1 在查询问题回答次数时使用了 `where` 子句筛选符合条件的数据，因此不能同时对问题的出现次数进行记数。因此可以考虑不使用 `where` 子句，而是直接用条件判断函数 `if` 计算符合条件的数据条数。
##### 算法
SQL 中的 `if` 函数有三个参数，第一个参数为需要判断的条件。若条件为真，则返回值为第二个参数；若条件为假，则返回值为第三个参数。因此要查询问题的出现次数，只需要设计条件判断 `if(action='show', 1, 0)` 并按问题分组求和即可。
```sql
select
    question_id,
    sum(if(action = 'answer', 1, 0)) as AnswerCnt,
    sum(if(action = 'show', 1, 0)) as ShowCnt
from
    survey_log
group by question_id
```
以上的代码可以同时查询每个问题的出现次数以及回答次数，分别存入 `AnswerCnt` 与 `ShowCnt` 列中。随后我们可以在此表的基础上求每个问题的回答率并排序取最大者。
```sql
select question_id as survey_log
from (
  select
      question_id,
      sum(if(action = 'answer', 1, 0)) as AnswerCnt,
      sum(if(action = 'show', 1, 0)) as ShowCnt
  from
      survey_log
  group by question_id
) as tbl
order by (AnswerCnt / ShowCnt) desc
limit 1
```

#### 方法 3：不使用子查询，直接排序
方法 2 使用了一个子查询生成临时表 `tbl`，但使用 `if` 语句后，其实可以直接计算回答率，而不需要进行子查询。最终设计的查询如下：
```sql
select question_id as survey_log
from survey_log
group by question_id
order by sum(if(action = 'answer', 1, 0)) / sum(if(action = 'show', 1, 0)) desc
limit 1
```
####  方法：使用临时表进行连接
**算法：**

获胜者是 `Vote` 表中出现最多次的 `CandidateId`。因此可以先按照 `CandidateId` 分组，然后按照每个分组的计数给分组排序，使用 `limit 1` 取第一名即可。获得第一名的 `CandidateId` 之后，与 `Candidate` 表连接即可取得获胜者的名字。

```MySQL [-MySQL]
select Name
from (
  select CandidateId as id
  from Vote
  group by CandidateId
  order by count(id) desc
  limit 1
) as Winner join Candidate
on Winner.id = Candidate.id
```

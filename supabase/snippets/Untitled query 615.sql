begin;

with ranked as (
  select ctid, name,
         row_number() over (partition by name order by ctid) as rn
  from storage.migrations
)
delete from storage.migrations m
using ranked r
where m.ctid = r.ctid
  and r.rn > 1;

commit;

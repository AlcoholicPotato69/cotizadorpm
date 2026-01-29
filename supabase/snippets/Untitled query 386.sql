select name, count(*) as n
from storage.migrations
group by name
having count(*) > 1
order by n desc, name;

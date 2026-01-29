select name, count(*) as n
from storage.migrations
group by name
having count(*) > 1;

select count(*) from storage.migrations;
select name, count(*) from storage.migrations group by name having count(*)>1;

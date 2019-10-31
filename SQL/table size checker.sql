/*
Checking the size of a given table
*/
select
    count(*) as num_rows
       --,
    pg_size_pretty(pg_database_size('activity_accumulator')) AS "total_size"

from activity_accumulator aa
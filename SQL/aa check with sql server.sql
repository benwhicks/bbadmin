/* Designed to aggregate tables from aa to check with SQL server */

select cm.course_id, count(*) as n_rows,
       avg(aa.user_pk1) as mean_id, variance(aa.user_pk1) as var_id
from activity_accumulator aa
    inner join course_main cm on cm.pk1 = aa.course_pk1
where course_id like 'S-A%11%_201930%' and
      aa.timestamp < make_date(2019, 5, 1) and
      aa.timestamp >= make_date(2019, 4, 1)
group by cm.course_id

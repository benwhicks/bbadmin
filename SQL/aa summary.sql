/* Needs to be run on stats db to catch historical data. This means course_contents is not available */
select cm.course_name,
       count(*) as rows,
       avg(aa.user_pk1) as average_user_id,
       count(distinct aa.user_pk1) as total_users
from activity_accumulator aa
  left join course_main cm on aa.course_pk1 = cm.pk1
where cm.course_id like 'S-NRS%_201930%'
group by cm.course_name
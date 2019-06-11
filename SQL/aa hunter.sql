/* Run on stats schema if needing data more than 6 months old */

select u.lastname, u.firstname, u.user_id,
       aa.event_type, aa.internal_handle, aa.content_pk1,
       aa.data, aa.timestamp
from activity_accumulator aa inner join
    course_main cm on aa.course_pk1 = cm.pk1 inner join
    users u on aa.user_pk1 = u.pk1
where cm.course_id like 'S-COM112_201860%'
  and u.student_id like '11574833'
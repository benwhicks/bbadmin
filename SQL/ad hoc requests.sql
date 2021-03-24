/* Fetching list of students with full Bb ids for NRS160 202130 */

select u.user_id, u.pk1 as users_pk1, cu.pk1 as course_users_pk1,
       u.student_id, u.email,
       u.firstname, u.lastname,
       cm.course_id, cu.row_status
from users u
    inner join course_users cu on u.pk1 = cu.users_pk1
    inner join course_main cm on cu.crsmain_pk1 = cm.pk1
where cm.course_id like 'S-NRS160_202130%'
    and cu.role = 'S'
order by row_status
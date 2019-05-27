select u.firstname, u.lastname, u.student_id, u.user_id,
cu.role, cu.row_status, cm.course_name, cm.course_id
from course_users cu inner join course_main cm on cu.crsmain_pk1 = cm.pk1
inner join users u on cu.users_pk1 = u.pk1
where cm.course_id like '%NRS111_201930%'
/* Gets a rough estimate of enrolments from the course users table */
select u.student_id as id, u.user_id,
       replace(cm.course_id, 'S-', '') as offering, cu.row_status
from course_users cu
    inner join users u on cu.users_pk1 = u.pk1
    inner join course_main cm on cu.crsmain_pk1 = cm.pk1
where
    cm.course_id like 'S-%' and cu.role = 'S'
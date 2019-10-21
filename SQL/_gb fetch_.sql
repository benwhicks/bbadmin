/*
Basic mark fetch from the grade book / centre.

Run on the public schema.
*/

select u.student_id as id,
       cm.course_id as subject_code,
       cm.course_name as subject,
       gm.title as assessment,
       ggc.score, ggc.possible
from gradebook_grade_calc ggc
    inner join gradebook_main gm on ggc.gradebook_main_pk1 = gm.pk1
    inner join course_users cu on ggc.course_users_pk1 = cu.pk1
    inner join course_main cm on cu.crsmain_pk1 = cm.pk1
    inner join users u on cu.users_pk1 = u.pk1
where cm.course_id like 'S-%201945%'
/*
 Exploring DDA capabilities of extracting test center data
 */

select cm.course_name, cm.course_id,
       u.firstname, u.lastname, u.student_id,
       gm.title, att.qti_result_data_pk1,
       att.*
from attempt att
  left join gradebook_grade gg on att.gradebook_grade_pk1 = gg.pk1
  left join gradebook_main gm on gg.gradebook_main_pk1 = gm.pk1
  left join course_main cm on gm.crsmain_pk1 = cm.pk1
  inner join course_users cu on cm.pk1 = cu.crsmain_pk1 and gg.course_users_pk1 = cu.pk1
  inner join users u on cu.users_pk1 = u.pk1
where att.attempt_date >= '2020-06-18'
  and att.attempt_date < '2020-06-21'

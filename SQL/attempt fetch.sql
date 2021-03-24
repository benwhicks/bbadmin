select cm.course_name, cm.course_id,
       gm.title, att.attempt_date,
       u.student_id, u.firstname, u.lastname
from attempt att
  inner join gradebook_grade gg on att.gradebook_grade_pk1 = gg.pk1
  inner join gradebook_main gm on gg.gradebook_main_pk1 = gm.pk1
  inner join course_main cm on gm.crsmain_pk1 = cm.pk1
  inner join course_users cu on cm.pk1 = cu.crsmain_pk1 and gg.course_users_pk1 = cu.pk1
  inner join users u on cu.users_pk1 = u.pk1
where
/*      ((att.attempt_date >= '2020-08-17' and att.attempt_date <= '2020-08-21')
           or
       (att.attempt_date >= '2020-10-19' and att.attempt_date <= '2020-10-30'))
  and*/ cm.course_id like '%201990%'
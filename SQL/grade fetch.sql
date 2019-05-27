select cm.course_name, cm.course_id, u.firstname, u.lastname, u.student_id, u.user_id,
       gt.name, gm.position, gm.title,
       a.score, a.grade, a.attempt_date
from gradebook_type gt
    inner join gradebook_main gm on gt.pk1 = gm.gradebook_type_pk1
    inner join gradebook_grade gg on gm.pk1 = gg.gradebook_main_pk1
    inner join course_main cm on gm.crsmain_pk1 = cm.pk1
    inner join attempt a on a.gradebook_grade_pk1 = gg.pk1
    inner join course_users cu on cm.pk1 = cu.crsmain_pk1
    inner join users u on cu.users_pk1 = u.pk1
where cm.course_id like 'S-PSY203_201860%'
  and cu.row_status = 0
  and cu.role = 'S'
order by user_id, attempt_date
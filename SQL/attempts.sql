/* attempt bulk grab */
select u.student_id, u.firstname, u.lastname, gm.title, cm.course_id,
       a.attempt_date, a.score, a.student_submission, a.status
from attempt a
inner join gradebook_grade gg on a.gradebook_grade_pk1 = gg.pk1
inner join gradebook_main gm on gg.gradebook_main_pk1 = gm.pk1
inner join course_main cm on cm.pk1 = gm.crsmain_pk1
    inner join course_users cu on cm.pk1 = cu.crsmain_pk1 and gg.course_users_pk1 = cu.pk1
inner join users u on cu.users_pk1 = u.pk1
where cm.course_id like 'S-MRS432_2020%'
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
where cm.course_id like 'S-BMS171_201930_A_I%'
  and cu.role = 'S'
order by user_id, attempt_date

select t.name as "session",
       cm.course_id as "subject_site_code",
       cm.course_name as "subject_name",
       concat(u.lastname, ', ', u.firstname) as "student_name",
       u.student_id as "id",
       gm.title as "title",
       gm.due_date,
       gm.weight,
       gm.visible_in_book_ind,
       gm.visible_ind,
       gm.aggregation_model,
       gg.last_attempt_date,
       gg.up_average_score as "attempt",
       gg.average_score as "score",
       gg.pk1, gg.highest_attempt_pk1,
       gg.manual_grade as "manual_grade",
       gg.manual_score as "manual_score"
from course_main cm inner join course_users cu on cm.pk1 = cu.crsmain_pk1
  inner join course_term ct on ct.crsmain_pk1 = cm.pk1
  inner join term t on t.pk1 = ct.term_pk1
inner join users u on u.pk1 = cu.users_pk1
inner join gradebook_main gm on cm.pk1 = gm.crsmain_pk1
inner join gradebook_grade gg on gm.pk1 = gg.gradebook_main_pk1 and gg.course_users_pk1 = cu.pk1
where t.name like '2020%' --and
--      cu.role like 'S' and cu.row_status = 0 and
  /*    (cm.course_id like 'S-COM173%%' or
       cm.course_id like 'S-EED173%' or
       cm.course_id like 'S-ESL172%' or
       cm.course_id like 'S-STA172%') */

/*
 This is used for the R-data package
 */
select t.name as "session",
       replace(cm.course_id, 'S-', '') as "offering",
       u.student_id as "id",
       gm.title as "title",
       ggc.score,
       ggc.possible
from course_main cm inner join course_users cu on cm.pk1 = cu.crsmain_pk1
inner join course_term ct on ct.crsmain_pk1 = cm.pk1
inner join term t on t.pk1 = ct.term_pk1
inner join users u on u.pk1 = cu.users_pk1
inner join gradebook_main gm on cm.pk1 = gm.crsmain_pk1
inner join gradebook_grade_calc ggc on gm.pk1 = ggc.gradebook_main_pk1 and ggc.course_users_pk1 = cu.pk1
where t.name like any(array[
    '201830', '201860', '201890',
    '201930', '201960', '201990',
    '202030', '202060', '202090',
    '202130', '202160'
    ]) and
      --gm.title = 'Cumulative Mark' and
      u.student_id is not null and
      score is not null
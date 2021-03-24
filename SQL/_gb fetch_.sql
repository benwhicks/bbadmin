/*
Basic mark fetch from the grade book / centre.

Run on the public schema.
*/

select u.student_id as id, u.user_id,
       cm.course_id as subject_code,
       cm.course_name as subject,
       gm.title as assessment,
       gm.due_date, gm.position,
       ggc.score, ggc.possible
from gradebook_grade_calc ggc
    inner join gradebook_main gm on ggc.gradebook_main_pk1 = gm.pk1
    inner join course_users cu on ggc.course_users_pk1 = cu.pk1
    inner join course_main cm on cu.crsmain_pk1 = cm.pk1
    inner join users u on cu.users_pk1 = u.pk1
where cm.course_id like 'S-%202090%'


/*
 Fetch on the gradebook grade table - one level of aggregation down
 */
select distinct cm.course_id, gm.title
from attempt att
inner join gradebook_grade gg on att.gradebook_grade_pk1 = gg.pk1
    inner join gradebook_main gm on gg.gradebook_main_pk1 = gm.pk1
inner join course_main cm on gm.crsmain_pk1 = cm.pk1
where cm.course_id like 'S-BMS171_202030_A_D'

select distinct gm.title
from gradebook_main gm
inner join course_main cm on gm.crsmain_pk1 = cm.pk1

where cm.course_id like 'S-BMS171_202030_A_D'

 select u.student_id as id, u.user_id,
       cm.course_id as subject_code,
       cm.course_name as subject,
       gm.title as assessment,
       gm.due_date, gm.position,
       ggc.score, ggc.possible
from gradebook_grade_calc ggc
    inner join gradebook_main gm on ggc.gradebook_main_pk1 = gm.pk1
    inner join course_users cu on ggc.course_users_pk1 = cu.pk1
    inner join course_main cm on cu.crsmain_pk1 = cm.pk1
    inner join users u on cu.users_pk1 = u.pk1
where cm.course_id like 'S-%202030%'

 /*
  Fetch on the attempt table, even less aggrregated
  */
select u.student_id, u.firstname, u.lastname, gm.title, cm.course_id,
       a.attempt_date, a.score, gm.possible, a.status, gm.pk1
from attempt a
inner join gradebook_grade gg on a.gradebook_grade_pk1 = gg.pk1
inner join gradebook_main gm on gg.gradebook_main_pk1 = gm.pk1
inner join course_main cm on cm.pk1 = gm.crsmain_pk1
    inner join course_users cu on cm.pk1 = cu.crsmain_pk1 and gg.course_users_pk1 = cu.pk1
inner join users u on cu.users_pk1 = u.pk1
where cm.course_id like 'S-%202130%'

select u.student_id as id,
       cm.course_id as subject_code,
       cm.course_name as subject,
       gm.title as assessment,
       ggc.score, ggc.possible
       --, gf.jsonformula
from gradebook_grade_calc ggc
    inner join gradebook_main gm on ggc.gradebook_main_pk1 = gm.pk1
    --inner join gradebook_formula gf on gf.gradebook_main_pk1 = gm.pk1
    inner join course_users cu on ggc.course_users_pk1 = cu.pk1
    inner join course_main cm on cu.crsmain_pk1 = cm.pk1
    inner join users u on cu.users_pk1 = u.pk1
where cm.course_id like 'S-%201930%' and
      gm.title like '%xam%'


/* Individual gb fetch */
select u.student_id as id,
       u.firstname, u.lastname,
       cm.course_id as subject_code,
       cm.course_name as subject,
       gm.title as assessment,
       ggc.score, ggc.possible
       --, gf.jsonformula
from gradebook_grade_calc ggc
    inner join gradebook_main gm on ggc.gradebook_main_pk1 = gm.pk1
    --inner join gradebook_formula gf on gf.gradebook_main_pk1 = gm.pk1
    inner join course_users cu on ggc.course_users_pk1 = cu.pk1
    inner join course_main cm on cu.crsmain_pk1 = cm.pk1
    inner join users u on cu.users_pk1 = u.pk1
where u.firstname like 'Samuel' and u.lastname like 'Compton'


/* Bulk grab of gradecentre */
select distinct u.student_id, u.firstname, u.lastname, cm.course_id,
                gm.title, gm.aggregation_model, gm.possible,
       gm.calculated_ind,
       ggc.score as score, ggc.possible as possible,
       gt.calculated_ind
from gradebook_grade_calc ggc inner join
    gradebook_main gm on ggc.gradebook_main_pk1 = gm.pk1 inner join
    gradebook_type gt on gm.gradebook_type_pk1 = gt.pk1 inner join
    course_main cm on gm.crsmain_pk1 = cm.pk1 inner join
    course_users cu on cm.pk1 = cu.crsmain_pk1 and ggc.course_users_pk1 = cu.pk1  inner join
    users u on cu.users_pk1 = u.pk1
where cm.course_id like 'S-%_2020%'
limit 100



/* Gradebook logs */
select distinct cm.course_id, gm.title, gm.possible, u.student_id,
                gl.event_key, gl.grade, gl.modifier_role,
                mu.user_id as modifier_id, gl.modifier_ipaddress, gl.date_logged
from gradebook_log gl inner join
    gradebook_main gm on gl.gradebook_main_pk1 = gm.pk1 inner join
    course_main cm on gm.crsmain_pk1 = cm.pk1 inner join
    users u on gl.user_pk1 = u.pk1 inner join
    users mu on gl.modifier_pk1 = mu.pk1
where cm.course_id like 'S-%_2020%' and
      gl.grade is not null
order by gl.date_logged
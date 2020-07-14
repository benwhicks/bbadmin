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

/*
This query attempts to find what past DoGS did (grade wise, if anything) in any
continued subjects at CSU.



This is run on the public schema.
*/

select u.student_id,
       u.firstname, u.lastname,
       left(t_dogs.name, 4) as DoGS_cohort,
       cm.course_name, cm.course_id,
       gm.title,
       ggc.score,
       ggc.possible

       --cm.course_id, cm.course_name,
       --ggc.score, ggc.possible

from term t_dogs
     inner join course_term ct_dogs
        on t_dogs.pk1 = ct_dogs.term_pk1
    inner join course_main cm_dogs
        on cm_dogs.pk1 = ct_dogs.crsmain_pk1
    inner join course_users cu_dogs
        on cu_dogs.crsmain_pk1 = cm_dogs.pk1
    inner join users u
        on u.pk1 = cu_dogs.users_pk1
    left join course_users cu
        on cu.users_pk1 = u.pk1
    left join course_main cm
        on cu.crsmain_pk1 = cm.pk1
    left join gradebook_main gm
        on cm.pk1 = gm.crsmain_pk1
    left join gradebook_grade_calc ggc
        on ggc.gradebook_main_pk1 = gm.pk1 and ggc.course_users_pk1 = cu.pk1
    /*left join gradebook_main gm_dogs
        on gm_dogs.crsmain_pk1 = cm_dogs.pk1
    left join gradebook_grade_calc ggc_dogs
        on gm_dogs.pk1 = ggc_dogs.gradebook_main_pk1 and ggc_dogs.course_users_pk1 = cu_dogs.pk1
    left join course_users cu
        on cu.pk1 = cu_dogs.pk1
    left join course_main cm
        on cm.pk1 = cu.crsmain_pk1
    left join gradebook_main gm
        on gm.crsmain_pk1 = cu.crsmain_pk1
    left join gradebook_grade_calc ggc
        on cu.users_pk1 = ggc.course_users_pk1 and gm.pk1 = ggc.gradebook_main_pk1
      */
where t_dogs.name like '2016%' and
      cu_dogs.role like 'S' and
      (cm_dogs.course_id like 'S-COM173%%' or
       cm_dogs.course_id like 'S-EED173%' or
       cm_dogs.course_id like 'S-ESL172%' or
       cm_dogs.course_id like 'S-STA172%' or
       cm_dogs.course_id like 'S-GEN173%' or
       cm_dogs.course_id like 'S-MTH173%' or
       cm_dogs.course_id like 'S-ITC174%' or
       cm_dogs.course_id like 'S-MTH174%' or
       cm_dogs.course_id like 'S-IKC107%' or
       cm_dogs.course_id like 'S-POL112%' or
       cm_dogs.course_id like 'S-SCI174%' or
       cm_dogs.course_id like 'S-SCI175%')
--group by u.student_id, u.firstname, u.lastname,
 --        cm.course_id, cm.course_name, ggc.score, ggc.possible, t_dogs.name


select u.student_id,
       u.firstname, u.lastname,
       left(t_dogs.name, 4) as DoGS_cohort,
       cm_dogs.course_name, cm_dogs.course_id,
       gm.title,
       ggc.score,
       ggc.possible

       --cm.course_id, cm.course_name,
       --ggc.score, ggc.possible

from term t_dogs
     inner join course_term ct_dogs
        on t_dogs.pk1 = ct_dogs.term_pk1
    inner join course_main cm_dogs
        on cm_dogs.pk1 = ct_dogs.crsmain_pk1
    inner join course_users cu_dogs
        on cu_dogs.crsmain_pk1 = cm_dogs.pk1
    inner join users u
        on u.pk1 = cu_dogs.users_pk1
    left join gradebook_main gm
        on cm_dogs.pk1 = gm.crsmain_pk1
    left join gradebook_grade_calc ggc
        on ggc.gradebook_main_pk1 = gm.pk1 and ggc.course_users_pk1 = cu_dogs.pk1
where t_dogs.name like '2018%' and
      cu_dogs.role like 'S' and
      (cm_dogs.course_id like 'S-COM173%%' or
       cm_dogs.course_id like 'S-EED173%' or
       cm_dogs.course_id like 'S-ESL172%' or
       cm_dogs.course_id like 'S-STA172%' or
       cm_dogs.course_id like 'S-GEN173%' or
       cm_dogs.course_id like 'S-MTH173%' or
       cm_dogs.course_id like 'S-ITC174%' or
       cm_dogs.course_id like 'S-MTH174%' or
       cm_dogs.course_id like 'S-IKC107%' or
       cm_dogs.course_id like 'S-POL112%' or
       cm_dogs.course_id like 'S-SCI174%' or
       cm_dogs.course_id like 'S-SCI175%')

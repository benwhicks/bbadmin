/* For collecting historical data on Bachelor of Nursing course
*/
select concat(firstname, ' ', lastname) as student_name, lastname, firstname, id,
       term_name, subject_name, subject_code, subject_main, subject_name_child,
       position, title, weight, description,
       score, possible,
       gt_des, gt_weight, grade_type, jsonformula, score_provider_handle
from (  select t.name as term_name, u.lastname, u.firstname, u.student_id as id, u.user_id,
             cm.course_id AS subject_code,
             cm.course_name AS subject_name,
             cmchild.course_id as subject_name_child,
             (case when cmchild.course_id is null then cm.course_id else cmchild.course_id end) subject_main,
             cu.row_status as row_status,
             ggc.score as score, ggc.possible as possible,
             gm.description, gm.weight, gm.title, gm.position, gm.score_provider_handle,
               gt.description as gt_des, gt.weight as gt_weight, gt.name as grade_type,
               gf.jsonformula
        from users u left join course_users cu on cu.users_pk1 = u.pk1
            left join course_course cc on cc.crsmain_pk1 = cu.crsmain_pk1
            left join course_main cm on cm.pk1 = cu.crsmain_pk1
            left join course_main cmchild on cmchild.pk1 = cu.child_crsmain_pk1
            left join course_main cmparent on cmparent.pk1 = cc.crsmain_parent_pk1
            left join course_term ct on ct.crsmain_pk1 = cu.crsmain_pk1
            left join term t on t.pk1 = ct.term_pk1
            left join gradebook_grade_calc ggc on cu.pk1 = ggc.course_users_pk1
            left join gradebook_main gm on ggc.gradebook_main_pk1 = gm.pk1
            left join gradebook_type gt on gm.gradebook_type_pk1 = gt.pk1
            left join gradebook_formula gf on gm.pk1 = gf.gradebook_main_pk1
        where cmparent.pk1 is null and cu.role = 'S'
    )
    SQ1
where (subject_code like 'S-NRS%' or
       subject_code like 'S-BMS191%' or
       subject_code like 'S-BMS192%' or
       subject_code like 'S-BMS291%' or
       subject_code like 'S-BMS292%')
  and id is not null
  and term_name like '2019%'
and row_status = 0 -- means students are definitely enrolled in a subject. 2 means they were previously enrolled.
order by lastname, firstname

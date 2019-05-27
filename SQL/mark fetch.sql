select term.name as session,
       course_main.course_id,
       course_main.course_name as subject_name,
       concat(users.lastname, ', ', users.firstname) as student,
	   users.pk1 as id,
       gradebook_main.title,
       gt.name, gt.description, gt.weight, gt.scorable_ind,
       attempt.score as score,
	   gradebook_main.possible as possible,
	   gradebook_main.weight as weight,
       gradebook_main.score_provider_handle,
	   attempt.attempt_date as timestamp,
       gradebook_grade.manual_grade manual_grade,
       gradebook_grade.manual_score manual_score
from   term inner join course_term on term.pk1 = course_term.term_pk1
                   inner join course_main on course_term.crsmain_pk1 = course_main.pk1
                   inner join course_users on course_main.pk1 = course_users.crsmain_pk1
                   inner join users on course_users.users_pk1 = users.pk1
                   inner join gradebook_main on course_main.pk1 = gradebook_main.crsmain_pk1
                   inner join gradebook_grade on gradebook_main.pk1 = gradebook_grade.gradebook_main_pk1 and
                                                        course_users.pk1 = gradebook_grade.course_users_pk1
                   left outer join attempt on gradebook_grade.pk1 = attempt.gradebook_grade_pk1
inner join gradebook_type gt on course_main.pk1 = gt.crsmain_pk1 and gt.pk1 = gradebook_main.gradebook_type_pk1
where  --term.name in ('201760')
       course_main.available_ind =  'Y'
and    (course_main.course_id like 'S-NRS%' or
       course_main.course_id like 'S-BMS191%' or
       course_main.course_id like 'S-BMS192%' or
       course_main.course_id like 'S-BMS291%' or
       course_main.course_id like 'S-BMS292%')
and    course_users.available_ind = 'Y'
and    course_users.row_status = 0
and    course_users.role = 'S'
order by 1, 4, 5, 2, 3, 6
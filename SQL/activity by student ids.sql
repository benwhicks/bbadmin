/* Getting big picture activity by student, from a list of student ids.
   Initially designed to be used with the exit survey data.
   One row per student - subject enrolment.

   Run on stats schema
 */



 select u.student_id as id, u.firstname, u.lastname,
        cm.course_id, cm.course_name,
        act.logins, act.minutes,
        cu.last_access_date, cu.enrollment_date, cu.row_status
from users u
    inner join course_users cu on u.pk1 = cu.users_pk1
    inner join course_main cm on cu.crsmain_pk1 = cm.pk1
    inner join (
        select user_pk1, course_pk1, sum(course_access_minutes) as minutes, count(initial_datetime_access) as logins
        from ods_aa_course_activity
            inner join users u on u.pk1 = ods_aa_course_activity.user_pk1
        where student_id = any(array[ -- paste student id's below, in single quotes
       '11763322','11630584','11449365B','11765624','11757759','11750745','11157608','11718917','11736439','11767262','11702052','11539646A','11734984','11686452','11292951A','11766892','11627997','11726047','11610099','11583119','11750459','11716304','11767731','11764550','11720695','11747532','11715321','11703067','11738721','11762804','11751189','11739325','11744886','11768251','11539464','11585929A','95056272','11768970','11769782','11736060','11433048','11544498','11736253','11763440','11763363'

                 ])
        group by user_pk1, course_pk1
    ) act
        on act.user_pk1 = u.pk1 and act.course_pk1 = cm.pk1
where role = 'S' and u.student_id is not null and course_id like 'S-%'


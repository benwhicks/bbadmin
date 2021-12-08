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
        '11726333','11562626','11730598','11743447','11745233','11536946','11232890','11758946','11749377','11505349','11746470','11767683','11768776','11724115','11714819','11736261','11594814','11733809','11762897','11702131','11723406','11738187','11698068','11540268','11616730','11712863','11766450','11670630','11590063','11708177','11765878','11752385','11763635','11740747','11608588','11768499','11762337','11757575','11768226','11754644','11740897','11757382','11411446','11730857','11707010','11742948','11689155','11759562','11752597','11734462','11460991','11658752','11754392','11757365','11752430','11763496','11763449','11365884','11720618','11736301','11712839','11370481B','11767541','94058756','11763233','11734802','11769775','11746102','11558442','11703067','11616574B','11756526','11730270','11721654','11746227','11638046','11763394','11717020','11413505','11767477','11718738','11708982','11756996','11624255','11754818','11762761','11765621','11770247','11701018','11763909','11769376','11758605','11750699','11747995','11717574','11749505'
          ])
        group by user_pk1, course_pk1
    ) act
        on act.user_pk1 = u.pk1 and act.course_pk1 = cm.pk1
where role = 'S' and u.student_id is not null and course_id like 'S-%'


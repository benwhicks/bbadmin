/*
Needs to be run on stats db to catch historical data. This means course_contents is not available

Might be better to use the ods_aa_content_activity table?
*/
select u.student_id as id,
       aa.timestamp, cm.course_id as subject_code, cm.course_name as subject,
       cu.role,
       cu.row_status,
       aa.session_id as session_id,
       aa.content_pk1, cc.title
from activity_accumulator aa
  inner join course_main cm on aa.course_pk1 = cm.pk1
  inner join course_users cu on cu.crsmain_pk1 = aa.course_pk1 and cu.users_pk1 = aa.user_pk1
  inner join users u on cu.users_pk1 = u.pk1
  inner join course_contents cc on cm.pk1 = cc.crsmain_pk1
  where u.student_id like '11736765' and cm.course_id like 'S-EEP427_202130_B_D'
order by timestamp desc

        /*cm.course_id like 'S-A%202060%' and
        u.student_id is not null and
        cu.role = 'S' and
        aa.timestamp > make_date(2020, 8, 16) and
        aa.timestamp < make_date(2020, 8, 22) */
/*        (cm.course_id like '%_2016%' or
         cm.course_id like '%_2017%' or
         cm.course_id like '%_2018%' or
         cm.course_id like '%_2019%')
    and */

    /* Pre HECS filter
    and aa.timestamp < make_date(2018, 3, 1)
    and aa.timestamp > make_date(2018, 2, 1)
       */
/*  and u.user_id is not null
  and cu.role like 'S'-- and cu.row_status = 0 -- getting only enrolled students

 */
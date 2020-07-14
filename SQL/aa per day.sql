/*
Fetches basic activity data for the first 4 weeks of term.

Weeks returned as an integer from the beginning of year, will need to be adjusted later.

Run on the stats schema. Change the cm.course_id to catch different terms.
*/

select
  u.lastname, u.firstname, u.student_id as id,
  cm.course_name as subject,
  coalesce(cmchild.course_id, cm.course_id) AS subject_code,
  coalesce(cm.course_id) AS subject_site_code, -- will be different to subject_code only if site merged
  cu.role,
  max(cu.row_status) as row_status_max,
  --extract('week' from oaca.initial_datetime_access) as week,
  date(oaca.initial_datetime_access) as date,
  sum(oaca.access_minutes) as minutes,
  sum(oaca.content_access_starts) as views,
  count(distinct oaca.content_pk1) as items_viewed,
  count(distinct oaca.session_pk1) as logins
from users u
  inner join course_users cu on cu.users_pk1 = u.pk1
  inner join course_main cm on cm.pk1 = cu.crsmain_pk1
    left join course_main cmchild on cmchild.pk1 = cu.child_crsmain_pk1
  left join ods_aa_content_activity oaca on oaca.user_pk1 = u.pk1 and oaca.course_pk1 = cm.pk1

where (cm.course_id like 'S-%202030_A%')
  /*(cm.course_id like 'S-%202030_P%' or
      cm.course_id like 'S-%202030_Q%' or
      cm.course_id like 'S-%202030_R%' or
      cm.course_id like 'S-%202030_S%' or
      cm.course_id like 'S-%202030_T%' or
      cm.course_id like 'S-%202030_U%' OR
      cm.course_id like 'S-%202030_V%' or
      cm.course_id like 'S-%202030_X%' or
      cm.course_id like 'S-%202030_Y%' or
      cm.course_id like 'S-%202030_Z%')*/

    /*(cm.course_id like 'S-%202030_E%' or
      cm.course_id like 'S-%202030_F%' or
      cm.course_id like 'S-%202030_G%' or
      cm.course_id like 'S-%202030_H%' or
      cm.course_id like 'S-%202030_I%' or
      cm.course_id like 'S-%202030_J%' OR
      cm.course_id like 'S-%202030_K%' or
      cm.course_id like 'S-%202030_L%' or
      cm.course_id like 'S-%202030_M%' or
      cm.course_id like 'S-%202030_N%')*/

  and u.lastname not like '%PreviewUser'

group by date, id, subject_site_code, lastname, firstname, subject, subject_code, role
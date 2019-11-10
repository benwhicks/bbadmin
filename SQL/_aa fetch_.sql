/*
Fetches basic activity data.

Run on the stats schema. Change the cm.course_id to catch different terms.
*/

select
  u.lastname, u.firstname, u.student_id as id,
  cm.course_name as subject,
  coalesce(cmchild.course_id, cm.course_id) AS subject_code,
  coalesce(cm.course_id) AS subject_site_code, -- will be different to subject_code only if site merged
  cu.row_status as status, -- might omit to connect with other sources (i.e. banner)
  cu.role,
  oaca.content_pk1,
  oaca.access_minutes,
  oaca.initial_datetime_access,
  oaca.content_access_starts
from users u
  inner join course_users cu on cu.users_pk1 = u.pk1
  inner join course_main cm on cm.pk1 = cu.crsmain_pk1

  left join course_main cmchild on cmchild.pk1 = cu.child_crsmain_pk1
  left join ods_aa_content_activity oaca on oaca.user_pk1 = u.pk1 and oaca.course_pk1 = cm.pk1

where cm.course_id like 'S-%201990%'
  and u.lastname not like '%PreviewUser'
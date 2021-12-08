
/* This runs on the Learn STATS Schema.
*/
select
  u.lastname, u.firstname, u.student_id as id,
  cm.course_name as subject,
  cm.course_id as subject_code, -- child / parent codes to be worked out elsewhere
  cu.row_status as status, -- might omit to connect with other sources (i.e. banner)
  oaca.content_pk1,
  oaca.access_minutes,
  oaca.initial_datetime_access
from users u
  inner join course_users cu on cu.users_pk1 = u.pk1
  inner join course_main cm on cm.pk1 = cu.crsmain_pk1
  left join ods_aa_content_activity oaca on oaca.user_pk1 = u.pk1 and oaca.course_pk1 = cm.pk1

where cm.course_id like 'S-MGT100_202160%'
  and u.lastname not like '%PreviewUser'
  and u.student_id is not null -- maybe also include a content_pk1 is not null
  and cu.role = 'S'
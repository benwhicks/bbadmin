
/* This runs on the Learn STATS Schema, and collects the data on minutes accessed
This is to then be joined with the *academic health check.sql* query on
all fields except the last three. Both queries should be run fairly closely in time.
*/
SELECT
       firstname, lastname, id,
       subject_name, subject_code,
       status,
       total_access_minutes,
       avg_access_minutes,
       accesses
FROM (SELECT
  u.lastname, u.firstname, u.student_id as id,
  cm.course_id AS subject_code,
  cm.course_name AS subject_name,
  cu.row_status as status,
  sum(oaca.access_minutes) as total_access_minutes,
  avg(oaca.access_minutes) as avg_access_minutes,
  count(oaca.access_minutes) as accesses
  FROM users u
  LEFT JOIN course_users cu ON cu.users_pk1 = u.pk1
 LEFT JOIN course_main cm ON cm.pk1 = cu.crsmain_pk1


  LEFT JOIN ods_aa_content_activity oaca on oaca.user_pk1 = u.pk1 and oaca.course_pk1 = cm.pk1

WHERE cu.role = 'S'
  group by firstname, lastname, id, subject_code, subject_name, status) SQ1

WHERE subject_code like 'S-%201930%' and status = 0 and lastname not like '%PreviewUser' and id is not null

ORDER BY subject_code
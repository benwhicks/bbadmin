
/* This runs on the Learn STATS Schema.
*/
SELECT
       firstname, lastname, id,
       subject_name, subject_code,
       child_subject_code,
       status,
       total_access_minutes,
       avg_access_minutes,
       accesses
FROM (SELECT
  u.lastname, u.firstname, u.student_id as id,
  cm.course_id AS subject_code,
  cm.course_name AS subject_name,
  cmchild.course_id AS child_subject_code,
  cu.row_status as status,
  sum(oaca.access_minutes) as total_access_minutes,
  avg(oaca.access_minutes) as avg_access_minutes,
  count(oaca.access_minutes) as accesses
  FROM users u
  LEFT JOIN course_users cu ON cu.users_pk1 = u.pk1
  LEFT JOIN course_main cm ON cm.pk1 = cu.crsmain_pk1
  LEFT JOIN course_main cmchild ON cmchild.pk1 = cu.child_crsmain_pk1
  LEFT JOIN ods_aa_content_activity oaca on oaca.user_pk1 = u.pk1 and oaca.course_pk1 = cm.pk1

WHERE cu.role = 'S'
  group by firstname, lastname, id, subject_code, subject_name, status, child_subject_code) SQ1

WHERE subject_code like 'S-%201930_W%' and status = 0 and lastname not like '%PreviewUser' and id is not null
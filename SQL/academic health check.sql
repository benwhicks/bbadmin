
/* This runs on the Learn Schema, and collects the data on grades and accesses */
SELECT
       concat(firstname, ' ', lastname) as student_name, lastname, firstname, id,
       subject_name, subject_code,
       lastaccess_course,
       date_part('day',  date_trunc('day', now() -max(lastaccess_course) ))  as days_since_last_access_course,
       max(score / (
           case
               when possible <= 0 then
                   -1
               else
                   possible
           end
           )
           )
        as max_grade_so_far,

       lastaccess_overall,
       date_part('day', date_trunc('day', now() - max(lastaccess_overall) ))  as days_since_last_access_overall,
       childcourse,
       timestamp
FROM (SELECT

  t.name term_name,
  u.lastname, u.firstname, u.student_id as id,
  cm.course_id AS subject_code,
  cm.course_name AS subject_name,
  cu.last_access_date AS lastaccess_course,
  u.last_login_date as lastaccess_overall,
  cmchild.course_id AS childcourse,
  cu.row_status as row_status,
  ggc.score as score,
  ggc.possible as possible,
  (CASE WHEN cmchild.course_id IS NULL THEN cm.course_id ELSE cmchild.course_id END) LORACOURSE,
  localtimestamp as timestamp
  --(CASE WHEN cmchild.course_id IS NULL THEN cm.course_id || u.user_id ELSE cmchild.course_id || u.user_id END) SEARCHKEY
  FROM users u
  LEFT JOIN course_users cu ON cu.users_pk1 = u.pk1
  LEFT JOIN course_course cc ON cc.crsmain_pk1 = cu.crsmain_pk1
  LEFT JOIN course_main cm ON cm.pk1 = cu.crsmain_pk1
  LEFT JOIN course_main cmchild ON cmchild.pk1 = cu.child_crsmain_pk1
  LEFT JOIN course_main cmparent ON cmparent.pk1 = cc.crsmain_parent_pk1
  LEFT JOIN course_term ct ON ct.crsmain_pk1 = cu.crsmain_pk1
  LEFT JOIN term t ON t.pk1 = ct.term_pk1
  LEFT JOIN gradebook_grade_calc ggc on cu.pk1 = ggc.course_users_pk1

  WHERE cmparent.pk1 IS NULL and cu.role = 'S') SQ1

WHERE subject_code like 'S-%201960%' and id is not null
and row_status = 0 -- means students are definitely enrolled in a subject. 2 means they were previously enrolled.
group by student_name, lastname, firstname, id,
       subject_name, subject_code,
       lastaccess_course,
            lastaccess_overall,
        childcourse, loracourse, timestamp
ORDER BY subject_code, lastname, firstname

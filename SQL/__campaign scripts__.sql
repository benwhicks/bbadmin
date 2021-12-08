/*
 generic subject info
 */
 select distinct replace(cm.course_id, 'S-', '') as offering,
                 cm.course_name
from course_main cm


/*
 gb submissions 202190
 */

select replace(cm.course_id, 'S-', '') as offering,
       gm.title,
       gm.pk1,
       u.student_id as id,
       a.attempt_date, a.score, gm.possible
        --,u.firstname, u.lastname,
from attempt a
inner join gradebook_grade gg on a.gradebook_grade_pk1 = gg.pk1
inner join gradebook_main gm on gg.gradebook_main_pk1 = gm.pk1
inner join course_main cm on cm.pk1 = gm.crsmain_pk1
    inner join course_users cu on cm.pk1 = cu.crsmain_pk1 and gg.course_users_pk1 = cu.pk1
inner join users u on cu.users_pk1 = u.pk1
where gm.pk1 in
     (
555995,
553696,
554681,
556348,
556608,
556472,
552112,
554142,
556467,
550724,
556500,
553743,
541296,
556402,
554367,
554490,
496896
    )
    /* testing previous session
    (503643, 503645, 514275, 515142, 515740, 516226)
    */
order by offering, u.lastname


/*
 academic health check. run on public schema
 */

 set TIMEZONE = 'Australia/Sydney'
 SELECT
       id, subject_code,  firstname, lastname, timestamp,
       lastaccess_course, lastaccess_overall,
       date_part('day',  date_trunc('day', now() -max(lastaccess_course) ))  as days_since_last_access_course,
       date_part('day', date_trunc('day', now() - max(lastaccess_overall) ))  as days_since_last_access_overall,
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
       childcourse, row_status,
       subject_name,
       replace(coalesce(childcourse, subject_code), 'S-', '') as offering
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

WHERE subject_code like 'S-%202190%' and id is not null
--and row_status = 0 -- means students are definitely enrolled in a subject. 2 means they were previously enrolled.
group by id, firstname, lastname,
       subject_name, subject_code, row_status,
       lastaccess_course,
            lastaccess_overall,
        childcourse, loracourse, timestamp
ORDER BY subject_code


 /*
 Fetch assessment attempts
  */
select u.student_id,
       --u.firstname, u.lastname,
       gm.title, cm.course_id,
       a.attempt_date, a.score, gm.possible, a.status, gm.pk1
from attempt a
inner join gradebook_grade gg on a.gradebook_grade_pk1 = gg.pk1
inner join gradebook_main gm on gg.gradebook_main_pk1 = gm.pk1
inner join course_main cm on cm.pk1 = gm.crsmain_pk1
    inner join course_users cu on cm.pk1 = cu.crsmain_pk1 and gg.course_users_pk1 = cu.pk1
inner join users u on cu.users_pk1 = u.pk1
where cm.course_id like 'S-%202160%'
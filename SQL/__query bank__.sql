/*
 Collection of queries to be used someday
 https://researchguides.loyno.edu/bbddaqueries
 */

 /*
 Dates of Work Submitted by Student and Course
For students with the Institution Role 'Online Student', the query finds discussion board posts,
 submissions recorded in a course gradebook, and the date of last access to the course.
 The query is limited to work submitted within the last 61 days.
 Submissions recorded in a gradebook include a file uploaded by the student to an assignment,
 text written by the student in an assignment, results of an online test, or work that leaves a
 link references in the linkrefid column of the attempt table.
 */
WITH
   online_student_pk1s AS (
      SELECT DISTINCT pk1
      FROM users
      WHERE institution_roles_pk1 IN
         (SELECT pk1 from institution_roles
          WHERE role_name = 'Online Student')
   ),
   db_posts AS (
      SELECT
      u.lastname, u.firstname, u.user_id, cm.course_id,
   TO_CHAR(msgm.dtcreated, 'YYYY-MM-DD HH24:MI') AS submit_date,
      'DB Post'::TEXT AS submit_type,
      fm.name AS title
      FROM online_student_pk1s
      LEFT JOIN users u on u.pk1 = online_student_pk1s.pk1
      LEFT JOIN msg_main msgm on msgm.users_pk1 = u.pk1
      LEFT JOIN forum_main fm on fm.pk1 = msgm.forummain_pk1
      LEFT JOIN conference_main confmain on confmain.pk1 = fm.confmain_pk1
      LEFT JOIN course_main cm on cm.pk1 = confmain.crsmain_pk1
   WHERE AGE(msgm.dtcreated) < INTERVAL '61 Days'
   ),
   gb_submissions AS (
      SELECT
      u.lastname, u.firstname, u.user_id, cm.course_id,
   TO_CHAR(att.attempt_date, 'YYYY-MM-DD HH24:MI') AS submit_date,
      (CASE WHEN atf.files_pk1 IS NOT NULL THEN 'UPLOADED FILE'
            WHEN att.student_submission IS NOT NULL THEN 'WRITTEN TEXT'
            WHEN att.qti_result_data_pk1 IS NOT NULL THEN 'ONLINE TEST'
            WHEN att.linkrefid IS NOT NULL THEN 'EXTERNAL WORK' ELSE '**UNKNOWN TYPE**' END)::TEXT
   AS submit_type,
      gm.title
      FROM online_student_pk1s
      LEFT JOIN users u on u.pk1 = online_student_pk1s.pk1
      LEFT JOIN course_users cu on cu.users_pk1 = u.pk1
      LEFT JOIN course_main cm on cm.pk1 = cu.crsmain_pk1
      LEFT JOIN gradebook_grade gg on gg.course_users_pk1 = cu.pk1
      LEFT JOIN gradebook_main gm on gm.pk1 = gg.gradebook_main_pk1
      LEFT JOIN attempt att on att.pk1 = gg.last_attempt_pk1
      LEFT JOIN attempt_files atf on atf.attempt_pk1 = att.pk1
      WHERE (atf.files_pk1 IS NOT NULL OR att.student_submission IS NOT NULL
          OR att.qti_result_data_pk1 IS NOT NULL OR att.linkrefid IS NOT NULL)
   AND AGE(att.attempt_date) < INTERVAL '61 Days'
   ),
   max_act_accum AS (
    SELECT online_student_pk1s.pk1, aa.course_pk1,
    TO_CHAR(MAX(aa.timestamp), 'YYYY-MM-DD HH24:MI') AS maxtime
    FROM online_student_pk1s
    JOIN activity_accumulator aa on aa.user_pk1 = online_student_pk1s.pk1
    WHERE aa.course_pk1 IS NOT NULL
    AND AGE(aa.timestamp) < INTERVAL '61 DAYS'
    GROUP BY online_student_pk1s.pk1, aa.course_pk1
   ),
   last_course_access AS (
    SELECT
       u.lastname, u.firstname, u.user_id, cm.course_id,
       max_act_accum.maxtime AS submit_date,
       'ACCESS'::TEXT AS submit_type,
       'Last Course Access'::TEXT AS title
    FROM max_act_accum
    LEFT JOIN users u on u.pk1 = max_act_accum.pk1
    LEFT JOIN course_main cm on cm.pk1 = max_act_accum.course_pk1
   )
SELECT
   lastname, firstname, user_id, submit_date, course_id, submit_type, title
FROM
   (SELECT * FROM db_posts
    UNION
    SELECT * FROM gb_submissions
    UNION
    SELECT * FROM last_course_access) SUBQ
ORDER BY lastname, firstname, user_id, course_id, submit_date DESC, submit_type


/*
Parent-Child Course Relationships
A simple query listing "merged enrollments,"  parent-child relationships between Blackboard courses,
   for a single semester. The parent-child relationship is recorded in the course_course table.
*/
SELECT
parent.course_id Parent_Course, child.course_id Child_Course, parent.course_name,
       t.name as session
FROM course_course cc
JOIN course_main parent on parent.pk1 = cc.crsmain_parent_pk1
JOIN course_main child on child.pk1 = cc.crsmain_pk1
LEFT JOIN course_term ct on ct.crsmain_pk1 = parent.pk1
LEFT JOIN term t on t.pk1 = ct.term_pk1
WHERE parent.course_id like 'S-%'
ORDER BY parent.course_id, child.course_id


/*
Parent-Child Course Relationships
As above, but getting all courses and returning same parent for non-merged
*/
with q1 as (
    select cm.course_id as subject_code
    from course_main cm
    where cm.course_id like 'S-%'
), q2 as (
    select cmchild.course_id as child_code,
           cmparent.course_id as parent_code
    from course_course cc
        inner join course_main cmchild on cc.crsmain_pk1 = cmchild.pk1
        inner join course_main cmparent on cc.crsmain_parent_pk1 = cmparent.pk1
    )
select *
from q1 left outer join q2 on subject_code = child_code

SELECT
       cm.course_id as subject_code
       ,coalesce(cmparent.course_id, cm.course_id) AS subject_site_code
FROM course_main cm
    JOIN course_course cc on cm.pk1 = cc.crsmain_pk1
    LEFT JOIN course_main cmparent on cmparent.pk1 = cc.crsmain_parent_pk1
WHERE cm.course_id like 'S-%'
ORDER BY subject_code

/*
Selected Student Submissions
For students who are members of a named hierarchy node (domain), lists submitted work (attempts) by due date.
Gradebook columns with no due date are excluded. An attempt that was made after the due date is labeled 'LATE'
and an attempt never made is labeled 'MISSING' if the due date has passed.
*/
SELECT
u.user_id,
u.lastname,
cm.course_id,
gm.due_date,
attfirst.attempt_date,
(CASE WHEN attfirst.attempt_date IS NOT NULL and attfirst.attempt_date > gm.due_date THEN 'LATE'
   WHEN attfirst.attempt_date IS NULL and gm.due_date < NOW() THEN 'MISSED' ELSE ' ' END) status,
gm.title gradebook_title,
gm.pk1 gradebook_id,
gm.possible point_value,
(CASE WHEN gm.multiple_attempts = 1 THEN 'SINGLE' ELSE 'MULTIPLE' END) attempts
FROM course_users cu
JOIN course_main cm on cm.pk1 = cu.crsmain_pk1
JOIN users u on u.pk1 = cu.users_pk1
JOIN gradebook_main gm on gm.crsmain_pk1 = cu.crsmain_pk1
LEFT JOIN gradebook_grade gg on gg.course_users_pk1 = cu.pk1 AND gg.gradebook_main_pk1 = gm.pk1
LEFT JOIN attempt attfirst on attfirst.pk1 = gg.first_attempt_pk1
WHERE cu.users_pk1 IN
   /* Select keys of users associated with a named hierarchy node */
   (SELECT duc.user_pk1
    FROM domain_user_coll duc
    JOIN domain dom on dom.pk1 = duc.domain_pk1
    WHERE dom.name = 'HigherEd2018F')
AND cm.course_id LIKE '18F-%'
AND gm.deleted_ind = 'N'
AND gm.scorable_ind = 'Y'
AND gm.due_date IS NOT NULL
ORDER BY u.user_id, cm.course_id, gm.due_date, gm.title, gm.pk1
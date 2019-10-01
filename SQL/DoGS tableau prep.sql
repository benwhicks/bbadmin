/* Student List */
select t.name as "Session",
       cm.course_id as "Subject Id",
       cm.course_name as "Subject Name",
       u.student_id as "id",
       cu.row_status,
       concat(u.lastname, ', ', u.firstname) as "Student",
       substring(course_id,  17, length(course_id) - 18) as "Cohort"
from course_main cm inner join course_users cu on cm.pk1 = cu.crsmain_pk1
  inner join course_term ct on ct.crsmain_pk1 = cm.pk1
  inner join term t on t.pk1 = ct.term_pk1
inner join users u on u.pk1 = cu.users_pk1
where t.name like '2019%' and
      cu.role like 'S' and
      (cm.course_id like 'S-COM173%%' or
       cm.course_id like 'S-EED173%' or
       cm.course_id like 'S-ESL172%' or
       cm.course_id like 'S-STA172%' or
       cm.course_id like 'S-GEN173%' or
       cm.course_id like 'S-MTH173%' or
       cm.course_id like 'S-ITC174%' or
       cm.course_id like 'S-MTH174%' or
       cm.course_id like 'S-IKC107%' or
       cm.course_id like 'S-POL112%' or
       cm.course_id like 'S-SCI174%' or
       cm.course_id like 'S-SCI175%')


/* Marks */
select t.name as "Session",
       cm.course_id as "Subject Id",
       cm.course_name as "Subject Name",
       u.student_id as "id",
       concat(u.lastname, ', ', u.firstname) as "Student",
       gm.title as "GC Column",
       gm.possible as Possible,
       a.score as "Score", -- taking the highest score, currently
       (a.score / gm.possible) as "Percentage",
       current_date as "timestamp"
       /*,
       gg.up_average_score as "Attempt",
       gg.manual_grade as "Manual Grade",
       gg.manual_score as "Manual Score",
       gg.average_score as "Average Score",
       ggc.score as "Final_Score",
       ggc.possible as "Final_Possible",
       (ggc.score / ggc.possible) as "Final_Percentage"
        */

from course_main cm inner join course_users cu on cm.pk1 = cu.crsmain_pk1
  inner join course_term ct on ct.crsmain_pk1 = cm.pk1
  inner join term t on t.pk1 = ct.term_pk1
inner join users u on u.pk1 = cu.users_pk1
inner join gradebook_main gm on cm.pk1 = gm.crsmain_pk1
inner join gradebook_grade gg on gm.pk1 = gg.gradebook_main_pk1 and gg.course_users_pk1 = cu.pk1
    inner join attempt a on gg.highest_attempt_pk1 = a.pk1
left join gradebook_grade_calc ggc on cu.pk1 = ggc.course_users_pk1 and gm.pk1 = ggc.gradebook_main_pk1
where t.name like '2019%' and
--      cu.role like 'S' and cu.row_status = 0 and
      (cm.course_id like 'S-COM173%%' or
       cm.course_id like 'S-EED173%' or
       cm.course_id like 'S-ESL172%' or
       cm.course_id like 'S-STA172%' or
       cm.course_id like 'S-GEN173%' or
       cm.course_id like 'S-MTH173%' or
       cm.course_id like 'S-ITC174%' or
       cm.course_id like 'S-MTH174%' or
       cm.course_id like 'S-IKC107%' or
       cm.course_id like 'S-POL112%' or
       cm.course_id like 'S-SCI174%' or
       cm.course_id like 'S-SCI175%')

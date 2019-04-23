/* Student List */
select t.name as "Session",
       cm.course_id as "Subject Id",
       cm.course_name as "Subject Name",
       concat(u.lastname, ', ', u.firstname) as "Student",
       substring(course_id,  17, length(course_id) - 18) as "Cohort"
from course_main cm inner join course_users cu on cm.pk1 = cu.crsmain_pk1
  inner join course_term ct on ct.crsmain_pk1 = cm.pk1
  inner join term t on t.pk1 = ct.term_pk1
inner join users u on u.pk1 = cu.users_pk1
where t.name like '2019%' and
      cu.role like 'S' and cu.row_status = 0 and
      (cm.course_id like 'S-COM173%_W_%' or
       cm.course_id like 'S-EED173%' or
       cm.course_id like 'S-ESL172%' or
       cm.course_id like 'S-STA172%')


/* Marks */
select t.name as "Session",
       cm.course_id as "Subject Id",
       cm.course_name as "Subject Name",
       concat(u.lastname, ', ', u.firstname) as "Student",
       gm.title as "GC Column",
       gg.up_average_score as "Attempt",
       gg.manual_grade as "Manual Grade",
       gg.manual_score as "Manual Score",
       gg.average_score as "Score"
from course_main cm inner join course_users cu on cm.pk1 = cu.crsmain_pk1
  inner join course_term ct on ct.crsmain_pk1 = cm.pk1
  inner join term t on t.pk1 = ct.term_pk1
inner join users u on u.pk1 = cu.users_pk1
inner join gradebook_main gm on cm.pk1 = gm.crsmain_pk1
inner join gradebook_grade gg on gm.pk1 = gg.gradebook_main_pk1 and gg.course_users_pk1 = cu.pk1
where t.name like '2019%' and
      cu.role like 'S' and cu.row_status = 0 and
      (cm.course_id like 'S-COM173%_W_%' or
       cm.course_id like 'S-EED173%' or
       cm.course_id like 'S-ESL172%' or
       cm.course_id like 'S-STA172%')
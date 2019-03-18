select  concat(users.firstname, ' ', users.lastname) as student_name,
       users.user_id as id,
       max(users.last_login_date) as overall_last_access,

       /* Using max function to deal with odd date duplicates*/
       date_part('day', current_date - date_trunc('day', max(users.last_login_date) ))  as overal_days_since_last_access,
       /* Subject specific */
       cm.course_name as subject,
       cu.available_ind as subject_available,
       cu.roster_ind as roster_ind,
       max(cm.course_id) as subject_id, -- very stupid addition to deal with merged courses, which have two subject_id's for the one user
       cu.child_crsmain_pk1 as child_course_id,

       /* Merged courses have strange behaviour*/
       max(cu.last_access_date) as last_access,
       date_part('day',current_date - date_trunc('day',max(cu.last_access_date))) as days_since_last_access,
       max(ggc.score / ggc.possible) as max_grade_so_far,

from course_users cu inner join users on cu.users_pk1 = users.pk1
left join course_main cm on cu.crsmain_pk1= cm.pk1
left join gradebook_grade_calc ggc on cu.pk1 = ggc.course_users_pk1

where cu.role = 'S' and
      cm.course_id like 'S-???1%201930%' -- ??? for MS SQL Server or ___ for PostgreSQL (DDA)

group by student_name, id, subject, subject_available, roster_ind, child_course_id

select  concat(users.firstname, ' ', users.lastname) as student_name,
       users.user_id as id,
       users.last_login_date as overall_last_access,

       /* Using max function to deal with odd date duplicates*/
       date_part('day', current_date - date_trunc('day', max(users.last_login_date) ))  as overal_days_since_last_access,

       /* Subject specific */
       cm.course_name as subject,
       cu.row_status as status,
       max(cm.course_id) as subject_id,

       /* Merged courses have strange behaviour*/
       max(cu.last_access_date) as last_access,
       date_part('day',current_date - date_trunc('day',max(cu.last_access_date))) as days_since_last_access,
       max(ggc.score / ggc.possible) as max_grade_so_far,

       /*retention centre  - Currently not Working */
       rcso.course_access_minutes as total_minutes

from course_users cu inner join users on cu.users_pk1 = users.pk1
left join course_main cm on cu.crsmain_pk1= cm.pk1
left join gradebook_grade_calc ggc on cu.pk1 = ggc.course_users_pk1
left join retention_center_stage_ods rcso on rcso.users_pk1 = users.pk1 and rcso.crsmain_pk1 = cm.pk1

where cu.role = 'S' and
      cu.child_crsmain_pk1 is NULL and -- this should exclude courses that are inactive due to being merged with something else
      cm.course_id like 'S-___1%201930%'

group by student_name, id, overall_last_access, subject, total_minutes, status
select u.user_id as id, u.student_id as s_id, aa.timestamp, cm.course_id as subject_code,
       cm.course_name as subject,
       u.firstname, u.lastname, cu.role, aa.event_type as event, aa.internal_handle as handle, aa.data as data
from activity_accumulator aa
  left join course_main cm on aa.course_pk1 = cm.pk1
  left join course_users cu on cu.crsmain_pk1 = aa.course_pk1 and cu.users_pk1 = aa.user_pk1
  left join users u on cu.users_pk1 = u.pk1
where
      cm.course_id like 'S-PSY203_201760%' or cm.course_id like 'S-PSY453_201760%'
      --cm.course_id like 'S-PSY208_201760%' or cm.course_id like 'S-PSY458_201760%'
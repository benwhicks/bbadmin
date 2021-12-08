

select cm.course_id as "subject_code",
       cm.course_name as "subject",
       u.student_id as "id",
       cu.row_status,
       cu.role,
       u.firstname,
       u.lastname
from course_main cm inner join course_users cu on cm.pk1 = cu.crsmain_pk1
  inner join course_term ct on ct.crsmain_pk1 = cm.pk1
  inner join term t on t.pk1 = ct.term_pk1
inner join users u on u.pk1 = cu.users_pk1
where --t.name like '202015' and
      --cm.course_id like 'S-%202015%'
    -- (cm.course_id like 'S-AHT101_202130%')
u.student_id like '11715493'
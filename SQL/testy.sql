select *
from users u join course_users cu on u.pk1 = cu.users_pk1
  left join course_main cm on cu.crsmain_pk1 = cm.pk1
left join ods_aa_content_activity odaca on u.pk1 = odaca.user_pk1 and cm.pk1 = odaca.course_pk1
where cm.course_id like 'S-%PSY203_2018%'
or cm.course_id like 'S-%PSY208%'
or cm.course_id like 'S-%PSY458%'
or cm.course_id like 'S-%PSY453%'
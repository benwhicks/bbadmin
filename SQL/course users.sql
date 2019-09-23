select u.firstname, u.lastname, u.student_id, u.user_id as id,
cu.role, cu.row_status, cm.course_name, cm.course_id
from course_users cu inner join course_main cm on cu.crsmain_pk1 = cm.pk1
inner join users u on cu.users_pk1 = u.pk1
where (cm.course_id like 'S-HRM502_201930%_D' or
cm.course_id like 'S-HRM514_201860%_D' or
cm.course_id like 'S-HRM528_201930%_D' or
cm.course_id like 'S-HRM534_201930%_D' or
cm.course_id like 'S-HRM550_201860%_D' or
cm.course_id like 'S-HRM563_201890%_D' or
cm.course_id like 'S-LAW515_201890%_D' or
cm.course_id like 'S-MGT540_201890%_D'
)
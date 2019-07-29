/* For checking forum contributions on assessed items */
select *
from course_main cm
    inner join course_users cu on cm.pk1 = cu.crsmain_pk1
    inner join users u on cu.users_pk1 = u.pk1
    inner join forum_main
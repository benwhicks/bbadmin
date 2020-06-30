/* grabbing session login data from stats public schema */
select u.student_id,
       max(oasa.login_time) as last_login,
       max(oasa.logout_time) as last_logout,
       now() - max(oasa.login_time) as time_since_last_login
from ods_aa_session_activity oasa inner join
    users u on oasa.user_pk1 = u.pk1
group by u.student_id

/* From session table in public schema */
select u.student_id,
       max(s.timestamp) as last_login_time,
       date_part('day', now()) - date_part('day', max(s.timestamp)) as days_since_last_access
from users u inner join
    sessions s on u.pk1 = s.user_id_pk1
group by u.student_id

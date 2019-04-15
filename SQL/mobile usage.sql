/* Fetching relevant data from aa to examine mobile logins */
select distinct cm.course_id, cm.course_name,
    aa.user_pk1,
       aa.session_id, aa.data,
                min(aa.timestamp) as timestamp_begin
from activity_accumulator aa
    left join sessions s on aa.session_id = s.session_id and aa.user_pk1 = s.user_id_pk1
    left join course_main cm on aa.course_pk1 = cm.pk1
    left join course_users cu on cu.crsmain_pk1 = aa.course_pk1 and cu.users_pk1 = aa.user_pk1
where (cm.course_id like '%S-HRM502_201930%' or cm.course_id like '%S-MGT510_201930%' or cm.course_id like '%S-PSY201_201930%')
and cu.role = 'S' and cu.row_status = 0 -- Fetches only students who are currently enrolled
group by course_id, course_name, user_pk1, aa.session_id, data


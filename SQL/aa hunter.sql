select u.lastname, u.firstname,aa.event_type, aa.internal_handle, aa.content_pk1, aa.data, aa.timestamp
from activity_accumulator aa inner join course_main cm on aa.course_pk1 = cm.pk1
inner join users u on aa.user_pk1 = u.pk1
where cm.course_id like 'S-IKC101_2019%' and u.lastname like 'McKinney'
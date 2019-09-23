/* Needs to be run on stats db to catch historical data. This means course_contents is not available */
select u.student_id as id,
       aa.timestamp, cm.course_id as subject_code,
       cm.course_name as subject,
       u.firstname, u.lastname, --cu.role,
       cu.row_status,
       aa.session_id as session_id,
       aa.event_type as event,
       aa.internal_handle as handle, aa.data as data,
       aa.content_pk1
       --cc.title
       --,cc.cnthndlr_handle, cc.content_type, cc.web_url
from activity_accumulator aa
  left join course_main cm on aa.course_pk1 = cm.pk1
  left join course_users cu on cu.crsmain_pk1 = aa.course_pk1 and cu.users_pk1 = aa.user_pk1
  left join users u on cu.users_pk1 = u.pk1
  --left join course_contents cc on cm.pk1 = cc.crsmain_pk1
  where --cm.course_id like 'S-NRS%_201790%'
        (cm.course_id like 'S-HCS111_201930_W_I'
    or
       cm.course_id like 'S-WEL427_201930_W_D'
    or
       cm.course_id like 'S-FDS305_201930_W_D'
    or
       cm.course_id like 'S-HCS111_201930_W_D'
    or
       cm.course_id like 'S-MGT100_201930_PT_I'

    )
    /* Pre HECS filter
    and aa.timestamp < make_date(2018, 3, 1)
    and aa.timestamp > make_date(2018, 2, 1) */
  --and u.user_id is not null
  and cu.role like 'S'-- and cu.row_status = 0 -- getting only enrolled students
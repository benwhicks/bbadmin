/*  Testing custom ods. Run on stats for historical data */

-- took too long to grab, maybe try splitting out the minutes into another sep
-- problem / query? And then maybe grad offering as well

/* activity by-day */
select id                                                           as id,
       replace(coalesce(child_course_id, course_id), 'S-', '')      as offering,
       date                                                         as date,
       count(distinct session_id)                                   as logins,
       count(session_id)                                            as clicks,
       count(distinct content_pk1)                                  as views

from (select u.student_id                       as id,
             cm.course_id                       as course_id,
             cmchild.course_id                  as child_course_id,
             aa.session_id                      as session_id,
             aa.timestamp::date                 as date,
             aa.content_pk1                     as content_pk1
      from activity_accumulator aa
               inner join users u on u.pk1 = aa.user_pk1
               inner join course_main cm on aa.course_pk1 = cm.pk1
               inner join course_users cu on cu.crsmain_pk1 = cm.pk1 and u.pk1 = cu.users_pk1
               left join course_main cmchild on cmchild.pk1 = cu.child_crsmain_pk1
      where u.student_id is not null
        and cu.role = 'S'
        and u.lastname not like '%PreviewUser'
        and aa.event_type != 'SESSION_TIMEOUT'
        and cm.course_id similar to 'S-%202190%' -- groups A, B, (C-O, P-V), W-Z
        and aa.timestamp::date >= make_date(2021, 11, 1) --
        and aa.timestamp::date < make_date(2021, 12,  1)
        ) as tab1
group by id, offering, date;

/*
/* code calculating minutes as well - needs work */
select id, subject_site_code,
       /* hack to push the session_id to exclude large chunks of non-activity
          Would probably be too computationally intensive to detect the gaps
          explicitly, but stamping by hour or day might work */
       concat(timestamp::date, '_' ,
           round(date_part('hour', timestamp)/8), '_', -- splits the day into thirds
           session_id) as session_id_day,
       min(timestamp)::date as date_start,
       date_part('hour', max(timestamp) - min(timestamp))*60 +
           date_part('minute', max(timestamp) - min(timestamp) ) +
           date_part('second', max(timestamp) - min(timestamp))/60 as minutes,
       count(event_type) as clicks,
       count(distinct content_pk1) as views
from
    (select u.student_id as id,
       cm.course_id as subject_site_code,
        aa.session_id, aa.event_type, aa.timestamp, aa.content_pk1
from activity_accumulator aa
    inner join users u on u.pk1 = aa.user_pk1
    inner join course_main cm on aa.course_pk1 = cm.pk1
where u.student_id is not null and
      aa.event_type != 'SESSION_TIMEOUT' and
      cm.course_id like 'S-[V-Z]%201990%') as tab1
group by id, subject_site_code, session_id_day


select u.student_id as id,
       cm.course_id as subject_site_code,
        aa.session_id, aa.event_type, aa.timestamp, aa.content_pk1
from activity_accumulator aa
    inner join users u on u.pk1 = aa.user_pk1
    inner join course_main cm on aa.course_pk1 = cm.pk1
where u.student_id is not null and
      aa.event_type != 'SESSION_TIMEOUT' and
      aa.session_id = 71025713
order by timestamp

 */
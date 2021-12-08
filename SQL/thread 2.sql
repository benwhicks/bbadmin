select id,
       replace(coalesce(child_course_id, course_id), 'S-', '')         as offering,
       date,
       count(distinct session_id)  as logins,
       count(session_id)           as clicks,
       count(distinct content_pk1) as views
from (select u.student_id                                                 as id,
             cm.course_id as course_id,
             cmchild.course_id as child_course_id,
             aa.session_id,
             aa.timestamp::date                                           as date,
             aa.content_pk1
      from activity_accumulator aa
               inner join users u on u.pk1 = aa.user_pk1
               inner join course_main cm on aa.course_pk1 = cm.pk1
               inner join course_users cu on cu.crsmain_pk1 = cm.pk1 and u.pk1 = cu.users_pk1
               left join course_main cmchild on cmchild.pk1 = cu.child_crsmain_pk1
      where u.student_id is not null
        and cu.role = 'S'
        and u.lastname not like '%PreviewUser'
        and aa.event_type != 'SESSION_TIMEOUT'
        and cm.course_id like 'S-B%201830_B%') as tab1
group by id, offering, date;

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
        and cm.course_id like 'S-%201860%'
        and aa.timestamp::date >= make_date(2018, 7, 1)
        and aa.timestamp::date < make_date(2018, 7, 5)
        ) as tab1
group by id, offering, date;
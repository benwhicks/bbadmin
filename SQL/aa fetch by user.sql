/*
Needs to be run on stats db to catch historical data. This means course_contents is not available

Might be better to use the ods_aa_content_activity table?
*/
select u.student_id as id,
       aa.timestamp, cm.course_id as subject_code, cm.course_name as subject,
       cu.role,
       cu.row_status,
       aa.session_id as session_id,
       aa.content_pk1, cc.title
from activity_accumulator aa
  inner join course_main cm on aa.course_pk1 = cm.pk1
  inner join course_users cu on cu.crsmain_pk1 = aa.course_pk1 and cu.users_pk1 = aa.user_pk1
  inner join users u on cu.users_pk1 = u.pk1
  inner join course_contents cc on cm.pk1 = cc.crsmain_pk1
  where u.student_id like '11715493' and cm.course_id like 'S-%*'
order by timestamp desc

        /*cm.course_id like 'S-A%202060%' and
        u.student_id is not null and
        cu.role = 'S' and
        aa.timestamp > make_date(2020, 8, 16) and
        aa.timestamp < make_date(2020, 8, 22) */
/*        (cm.course_id like '%_2016%' or
         cm.course_id like '%_2017%' or
         cm.course_id like '%_2018%' or
         cm.course_id like '%_2019%')
    and */

    /* Pre HECS filter
    and aa.timestamp < make_date(2018, 3, 1)
    and aa.timestamp > make_date(2018, 2, 1)
       */
/*  and u.user_id is not null
  and cu.role like 'S'-- and cu.row_status = 0 -- getting only enrolled students

 */

/* same on stats schema for older data */
select u.student_id as id,
       aa.timestamp, cm.course_id as subject_code, cm.course_name as subject,
       cu.role,
       cu.row_status,
       aa.session_id as session_id, aa.content_pk1
from activity_accumulator aa
  inner join course_main cm on aa.course_pk1 = cm.pk1
  inner join course_users cu on cu.crsmain_pk1 = aa.course_pk1 and cu.users_pk1 = aa.user_pk1
  inner join users u on cu.users_pk1 = u.pk1
  where
        u.student_id like '11644179' and
        cm.course_id like 'S-INF321_201930_W_D'
order by timestamp desc

/* attempting to get better minutes data */
select id, offering, date,
       sum(minutes) as minutes,
       sum(clicks) as clicks,
       count(distinct session_start) as logins
from (select u.student_id as id,
       replace(coalesce(cmchild.course_id, cm.course_id), 'S-', '') as offering,
       concat(aa.timestamp::date, '_', aa.session_id) as session_id_day,
       timestamp::date as date,
       min(aa.timestamp) as session_start,
       count(distinct timestamp) as clicks,
       date_part('seconds',max(timestamp) - min(timestamp))/60 as minutes
from activity_accumulator aa
    inner join course_main cm on aa.course_pk1 = cm.pk1
    inner join course_users cu on cm.pk1 = cu.crsmain_pk1
    inner join users u on cu.users_pk1 = u.pk1
    left join course_main cmchild on cmchild.pk1 = cu.child_crsmain_pk1
where u.student_id like '11644179' and
      cm.course_id like 'S-INF321_201930_W_D'
group by id, session_id_day, offering, date
)
    as agg_aa
group by id, offering, date

select *
from ods_aa_session_activity ods_sess
where ods_sess.session_pk1 = 72863360

select *
from ods_aa_content_activity ods
where ods.session_pk1 = 71025713;


select user_pk1,
       course_pk1,
       event_type,
       session_id,
       timestamp,
       internal_handle,
       content_pk1,
       data
from activity_accumulator aa
         inner join users u on u.pk1 = aa.user_pk1
where u.student_id = '11644179' and
      aa.timestamp >= date('2019-04-17') and
aa.timestamp < date('2019-04-18')
order by timestamp;


/*  Testing custom ods  */
select id, subject_site_code, session_id,
       min(timestamp)::date as date_start,
       max(timestamp) - min(timestamp) as ts_diff,
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
where u.user_id is not null and
      aa.event_type != 'SESSION_TIMEOUT' and
      session_id = 72863360) as tab1
group by id, subject_site_code, session_id


/* code calculating without minutes */
select id,
       offering,
       date,
       count(distinct session_id)  as logins,
       count(session_id)           as clicks,
       count(distinct content_pk1) as views
from (select u.student_id                                                 as id,
             replace(coalesce(cmchild.course_id, cm.course_id), 'S-', '') as offering,
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
        and cm.course_id similar to 'S-[V-Z]%202060%') as tab1
group by id, offering, date;
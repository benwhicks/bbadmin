/*
Fetches basic activity data, aggregated by day.

day returned a difference between start date, which must be entered into the code manually.

Run on the stats schema. Change the cm.course_id to catch different terms.
*/

select
  u.student_id as id,
  replace(coalesce(cmchild.course_id, cm.course_id), 'S-', '') as offering,
  oaca.initial_datetime_access::date as date,
  sum(oaca.access_minutes) as minutes,
  sum(oaca.content_access_starts) as views,
  count(distinct oaca.content_pk1) as items_viewed
from users u
  inner join course_users cu on cu.users_pk1 = u.pk1
  inner join course_main cm on cm.pk1 = cu.crsmain_pk1
    left join course_main cmchild on cmchild.pk1 = cu.child_crsmain_pk1
  inner join ods_aa_content_activity oaca on oaca.user_pk1 = u.pk1 and oaca.course_pk1 = cm.pk1

where  u.lastname not like '%PreviewUser' and
      u.student_id is not null and
      cu.role = 'S'  and
      cm.course_id like 'S-%201890%'

group by date, id, offering


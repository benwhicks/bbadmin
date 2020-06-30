/*
--- Blackboard outages ---
Services affected start:
2020-04-07 11:27AM AEST
Services restored:
2020-04-07 11:47AM AEST

Services affected start:
2020-05-06 10:42AM AEST
Services restored:
2020-05-06 11:00AM AEST

Likely subject sites to cause harm:
course_id: A-0001, A-0002, A-0003, A-0005


*/

select course_name, tbl1.course_id, Enrollments, Disabled_Users from (
-- Course users
                  select cm.course_name, cm.course_id, count(cu.*) Enrollments
                  from course_main cm,
                       course_users cu
                  where cm.pk1 = cu.crsmain_pk1
                    and cm.pk1 in (299, 3003, 16412, 36146)
                  group by cm.course_id, cm.course_name
              ) tbl1
    join  (
-- Disabled course users
select cm.course_id, count(cu.*) Disabled_Users from course_main cm, course_users cu
where cm.pk1=cu.crsmain_pk1 and cu.row_status = 2 and cm.pk1 in (299,3003,16412,36146) group by cm.course_id

    ) tbl2
        on tbl1.course_id = tbl2.course_id
order by course_id

-- Getting bulk activity accumulator data
select
  u.lastname, u.firstname,
  cm.course_name as subject,
  cu.row_status as status, -- might omit to connect with other sources (i.e. banner)
  cu.role,
  aa.event_type, aa.content_pk1, aa.timestamp,
       cc.title
from users u
  inner join course_users cu on cu.users_pk1 = u.pk1
  inner join course_main cm on cm.pk1 = cu.crsmain_pk1
  inner join activity_accumulator aa on cm.pk1 = aa.course_pk1 and u.pk1 = aa.user_pk1
  left join course_contents cc on cm.pk1 = cc.crsmain_pk1 and aa.content_pk1 = cc.pk1
where cm.pk1 in (299,3003,16412,36146)
  and u.lastname not like '%PreviewUser'
  and role not like 'S'
  and timestamp between '2020-04-05' and '2020-04-08'

-- Getting 'announcements'
select cm.course_id, cm.course_name,
       a.end_date, a.subject, a.start_date,
       a.push_notify, a.announcement, a.announcement_type
from announcements a
  inner join course_main cm on a.crsmain_pk1 = cm.pk1
where cm.pk1 in (299,3003,16412,36146)
  and a.start_date between '2020-01-02' and '2020-04-10'

 -- Getting gradebook logs
 select cm.course_name, cm.course_id,
        gm.title,
        gl.firstname, gl.lastname, gl.username, gl.attempt_creation,
        gl.modifier_firstname, gl.modifier_lastname,
        gl.event_key, gl.date_logged, gl.numeric_grade,
         gl.instructor_comments, gl.deletion_event_ind, gl.exempt_ind
from gradebook_log gl
  inner join gradebook_main gm on gl.gradebook_main_pk1 = gm.pk1
  inner join course_main cm on gm.crsmain_pk1 = cm.pk1
where cm.pk1 in (299,3003,16412,36146)
  and gl.date_logged between '2020-01-02' and '2020-04-10'


 -- course contents logs
 select cm.course_name, cm.course_id,
        cc.dtmodified, cc.title, cc.pk1
from course_contents cc
  inner join course_main cm on cc.crsmain_pk1 = cm.pk1
where cm.pk1 in (299,3003,16412,36146)
  and cc.dtmodified between '2020-01-05' and '2020-04-10'


-- course messages (none in window)
 select cm.course_name, cm.course_id,
        cmsg.sent_date, cmsg.subject,  cmsg.type, cmsg.receivers
from course_msg cmsg
  inner join course_main cm on cmsg.crsmain_pk1 = cm.pk1
where cm.pk1 in (299,3003,16412,36146)
  and cmsg.sent_date between '2020-01-01' and '2020-04-10'

-- course registry (none in window)
select cm.course_name, cm.course_id,
       cr.dtmodified, cr.dtcreated, cr.row_status, cr.registry_value, cr.registry_key
from course_main cm
inner join course_registry cr on cm.pk1 = cr.crsmain_pk1
where cm.pk1 in (299,3003,16412,36146)
  and cr.dtmodified between '2020-01-01' and '2020-04-10'


-- gradebook settings (none in window)
select cm.course_name, cm.course_id,
  gs.date_grade_modified, gs.default_grading_period_pk1, gs.fl_ind, gs.lf_ind
from course_main cm
inner join gradebook_settings gs on cm.pk1 = gs.crsmain_pk1
where cm.pk1 in (299,3003,16412,36146)
  and gs.date_grade_modified between '2020-01-01' and '2020-04-10'


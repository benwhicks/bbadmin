/* This contains a collection of queries for exploring engagement */

/*
Fetches basic course contents data.

Run on the public schema.
*/

select t.name as "session",
       t.start_date,
       cm.course_id as subject_site_code,
       cm.course_name as subject,
       cm.batch_uid, cm.pk1,
       cc.pk1 as content_pk1, -- to match with the activity accumulator
       cc.cnthndlr_handle as handle,
       cc.content_type as type,
       cc.extended_data,
       cc.position,
       cc.title,
       cc.parent_pk1,
       ccpt.title as title_parent -- could maybe go to parents parent, or further.
from course_contents cc
    inner join course_main cm on cc.crsmain_pk1 = cm.pk1
    left join course_contents ccpt on cc.parent_pk1 = ccpt.pk1
    inner join course_term ct on ct.crsmain_pk1 = cm.pk1
    inner join term t on ct.term_pk1 = t.pk1
where
      cm.course_id like 'S-IKC101_2020%'


/* Course users */
select cm.course_id as "subject_code",
       cm.course_name as "subject",
       u.student_id as "id",
       cu.row_status, cu.row_status_crs_disable, cu.dtmodified,
       cu.role,
       u.firstname,
       u.lastname
from course_main cm inner join course_users cu on cm.pk1 = cu.crsmain_pk1
  inner join course_term ct on ct.crsmain_pk1 = cm.pk1
  inner join term t on t.pk1 = ct.term_pk1
inner join users u on u.pk1 = cu.users_pk1
where cm.course_id like 'S-ACC100_202090%' and
      u.student_id like '11333016';

/*
Fetches basic activity data.

Run on the stats schema. Change the cm.course_id to catch different terms.
*/

select
  u.lastname, u.firstname, u.student_id as id,
  cm.course_name as subject,
  coalesce(cmchild.course_id, cm.course_id) AS subject_code,
  coalesce(cm.course_id) AS subject_site_code, -- will be different to subject_code only if site merged
  cu.row_status as status, -- might omit to connect with other sources (i.e. banner)
  cu.role,
  oaca.content_pk1,
  oaca.access_minutes,
  oaca.initial_datetime_access,
  oaca.content_access_starts
from users u
  inner join course_users cu on cu.users_pk1 = u.pk1
  inner join course_main cm on cm.pk1 = cu.crsmain_pk1

  left join course_main cmchild on cmchild.pk1 = cu.child_crsmain_pk1
  left join ods_aa_content_activity oaca on oaca.user_pk1 = u.pk1 and oaca.course_pk1 = cm.pk1

where cm.course_id like 'S-IKC101_2020%'
  and u.lastname not like '%PreviewUser';

/*
Fetches basic forum data. Run on public schema.
*/

select distinct
    coalesce(childcm.course_id, cm.course_id) AS subject_code,
    coalesce(cm.course_id) AS subject_site_code, -- will be different to subject_code only if site merged
    fm.name as forum,
    u.user_id as poster_user_id, u.student_id,
    cu.role as poster_role,
    concat(u.firstname, ' ', u.lastname) as poster,
    in_reply_to.user_id as reply_to_user_id,
    concat(in_reply_to.firstname, ' ', in_reply_to.lastname) as reply_to,
    mm.hit_count, mm.posted_date

from forum_main fm
    inner join msg_main mm on fm.pk1 = mm.forummain_pk1
    inner join users u on mm.users_pk1 = u.pk1
    inner join conference_main cfm on fm.confmain_pk1 = cfm.pk1
    inner join course_main cm on cfm.crsmain_pk1 = cm.pk1
    inner join course_users cu on mm.users_pk1 = cu.users_pk1 and cm.pk1 = cu.crsmain_pk1
    left join course_main childcm on childcm.pk1 = cu.child_crsmain_pk1
    left outer join msg_main as msg_main_reply_to on mm.msgmain_pk1 = msg_main_reply_to.pk1
    left outer join msg_main as msg_main_thread on mm.thread_pk1 = msg_main_thread.pk1
    left outer join users as in_reply_to on msg_main_reply_to.users_pk1 = in_reply_to.pk1
    left outer join users as threader on msg_main_thread.users_pk1 = threader.pk1

where cm.course_id like 'S-IKC101_2020%';

/*
Basic mark fetch from the grade book / centre.

Run on the public schema.
*/

select u.student_id as id, u.user_id,
       cm.course_id as subject_code,
       cm.course_name as subject,
       gm.title as assessment,
       gm.due_date, gm.position,
       ggc.score, ggc.possible
from gradebook_grade_calc ggc
    inner join gradebook_main gm on ggc.gradebook_main_pk1 = gm.pk1
    inner join course_users cu on ggc.course_users_pk1 = cu.pk1
    inner join course_main cm on cu.crsmain_pk1 = cm.pk1
    inner join users u on cu.users_pk1 = u.pk1
where cm.course_id like 'S-%202060%';

/*
Fetches basic forum data. Run on public schema.
*/

select distinct
     coalesce(childcm.course_id, cm.course_id) AS subject_code,
  coalesce(cm.course_id) AS subject_site_code, -- will be different to subject_code only if site merged
       fm.name as forum,
       u.user_id as poster_user_id,
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

where cm.course_id like 'S-%201945%'

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
where       --cm.course_id like 'S-NRS111%'
     (cm.course_id like 'S-%202090%')
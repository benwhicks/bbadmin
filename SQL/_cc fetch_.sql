/*
Fetches basic course contents data.

Run on the public schema.
*/

select cm.course_id as subject_site_code,
       cm.course_name as subject,
       cc.pk1 as content_pk1, -- to match with the activity accumulator
       cc.cnthndlr_handle as handle,
       cc.content_type as type,
       cc.position,
       cc.crsmain_pk1,
       cc.title,
       cc.parent_pk1
from course_contents cc
    inner join course_main cm on cc.crsmain_pk1 = cm.pk1
where cm.course_id like 'S-%201945%'
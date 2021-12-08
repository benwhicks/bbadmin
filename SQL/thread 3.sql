select
       replace(cm.course_id, 'S-', '') as offering,
       regexp_replace(regexp_replace(cm.course_id, 'S-.{6}_', ''), '_.*$', '') as session,
       cm.course_name as subject_name
from course_main cm
where course_id like 'S-%'
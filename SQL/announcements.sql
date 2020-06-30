/* Fetching announcements from a course */

select cm.course_id, subject, announcement, ann.dtcreated, ann.dtmodified
from announcements ann inner join
    course_main cm on ann.crsmain_pk1 = cm.pk1
where cm.course_id like '%ENM109_2020%'
select cm_child.course_id as subject_code,
       cm_child.course_name as subject,
       cm_parent.course_id as parent_subject_code,
       cm_parent.course_name as parent_subject
from course_course cc
inner join course_main cm_child on cc.crsmain_pk1 = cm_child.pk1
left join course_main cm_parent on cc.crsmain_parent_pk1 = cm_parent.pk1
where cm_child.course_id like 'S-%'
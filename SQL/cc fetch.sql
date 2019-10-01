select cc.pk1, cc.cnthndlr_handle as handle, cc.content_type as type, cc.position,
       cc.main_data, cc.crsmain_pk1, cc.title, cc.parent_pk1
from course_contents cc inner join course_main cm on cc.crsmain_pk1 = cm.pk1
where cm.course_id like 'S%201930%'
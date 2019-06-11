select *
from course_contents cc inner join course_main cm on cc.crsmain_pk1 = cm.pk1
where cm.course_id like 'S-OCC104_201930_PT_I'
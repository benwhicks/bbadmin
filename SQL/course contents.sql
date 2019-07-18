/* The following extracts relevant static course information */

select cm.course_name, cm.course_id,
       --cc.pk1, cc.parent_pk1,
       cc.title, cc.description,cc.cnthndlr_handle,
       cc.content_type, -- URL, LINK (course link), REG (regular), FILE (single file)
       cc.description, cc.dtmodified, cc.start_date, cc.position,
       cc.lesson_ind -- a Y indicates that this is a learning module
       /*cc.sequential_ind, -- indicates if the user must view the content within this learning module sequentially (Y)
       cc.tracking_ind, -- Y if tracked
       cc.folder_ind, -- Y if this is a folder of content, N for content itself
       cc.folder_type, --F BB_FOLDER, P BB_PAGE
       cc.is_group_content,*/
   --    cc.web_url, cc.web_url_host

      -- cc.main_data
       --cc.extended_data
from course_contents cc
    inner join course_main cm on cc.crsmain_pk1 = cm.pk1
where cm.course_id like 'S-LAW504_201930_W_D'

/*
where (course_id like 'S-NRS%' or
       course_id like 'S-BMS191%' or
       course_id like 'S-BMS192%' or
       course_id like 'S-BMS291%' or
       course_id like 'S-BMS292%')

/* The following extracts relevant static gradebook information */
select cm.course_name, cm.course_id,
       gm.title, gm.due_date, gm.possible,
       gm.position, gm.course_contents_pk1, gm.description, gm.aggregation_model, gm.calculated_ind, gm.single_attempt_ind,
       gm.score_provider_handle, gm.anonymous_grading_ind
from gradebook_main gm inner join course_main cm on gm.crsmain_pk1 = cm.pk1
where  (course_id like 'S-NRS%' or
       course_id like 'S-BMS191%' or
       course_id like 'S-BMS192%' or
       course_id like 'S-BMS291%' or
       course_id like 'S-BMS292%')

*/
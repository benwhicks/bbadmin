/*
Extracting activity for a specify student
*/

select u.firstname, u.lastname,
       u.user_id as user_id,
       u.student_id as student_id,
       cm.course_name, cm.course_id,
       aa.timestamp as timestamp,
       aa.event_type as event_type,
       aa.data, aa.internal_handle


from activity_accumulator aa
left join course_main cm on cm.pk1 = aa.course_pk1
left join course_users cu on cm.pk1 = cu.crsmain_pk1
left join users u on cu.users_pk1 = u.pk1
where  cm.course_id = 'S-EHR329_201930_PT_I' and -- choosing the subject

      /*
      The following line selects the student. You can change this to match for other fields,
      including firstname / lastname or their student number, which is called student_id
      */
      u.user_id like 'jvogel03' and

      -- Choosing the time period
      aa.timestamp <= to_date('2019-03-11', 'YYYY-MM-DD') and
      aa.timestamp >= to_date('2019-03-08', 'YYYY-MM-DD')

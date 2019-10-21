select cm.course_name, cm.course_id, u.firstname, u.lastname, u.student_id, u.user_id,
       gt.name, gm.position, gm.title,
       a.score, a.grade, a.attempt_date
from gradebook_type gt
    inner join gradebook_main gm on gt.pk1 = gm.gradebook_type_pk1
    inner join gradebook_grade gg on gm.pk1 = gg.gradebook_main_pk1
    inner join course_main cm on gm.crsmain_pk1 = cm.pk1
    inner join attempt a on a.gradebook_grade_pk1 = gg.pk1
    inner join course_users cu on cm.pk1 = cu.crsmain_pk1
    inner join users u on cu.users_pk1 = u.pk1
where cm.course_id like 'S-BMS171_201930_A_I%'
  and cu.role = 'S'
order by user_id, attempt_date

select t.name as "Session",
       cm.course_id as "Subject Id",
       cm.course_name as "Subject Name",
       concat(u.lastname, ', ', u.firstname) as "Student",
       gm.title as "GC Column",
       gg.up_average_score as "Attempt",
       gg.manual_grade as "Manual Grade",
       gg.manual_score as "Manual Score",
       gg.average_score as "Score"
from course_main cm inner join course_users cu on cm.pk1 = cu.crsmain_pk1
  inner join course_term ct on ct.crsmain_pk1 = cm.pk1
  inner join term t on t.pk1 = ct.term_pk1
inner join users u on u.pk1 = cu.users_pk1
inner join gradebook_main gm on cm.pk1 = gm.crsmain_pk1
inner join gradebook_grade gg on gm.pk1 = gg.gradebook_main_pk1 and gg.course_users_pk1 = cu.pk1
where t.name like '201930%' --and
--      cu.role like 'S' and cu.row_status = 0 and
  /*    (cm.course_id like 'S-COM173%%' or
       cm.course_id like 'S-EED173%' or
       cm.course_id like 'S-ESL172%' or
       cm.course_id like 'S-STA172%') */
  /*  (cm.course_id like '%SCI101%' or
cm.course_id like '%BIO100%' or
cm.course_id like '%AHT101%' or
cm.course_id like '%AGB165%' or
cm.course_id like '%AGB110%' or
cm.course_id like '%PSC102%' or
cm.course_id like '%PSC103%' or
cm.course_id like '%CHM108%' or
cm.course_id like '%CHM104%' or
cm.course_id like '%ASC110%' or
cm.course_id like '%VSC112%' or
cm.course_id like '%ASC180%' or
cm.course_id like '%ASC148%' or
cm.course_id like '%ASC106%' or
cm.course_id like '%ENM109%' or
cm.course_id like '%PKM208%' or
cm.course_id like '%REC167%' or
cm.course_id like '%REC110%' or
cm.course_id like '%SCI103%' or
cm.course_id like '%ENM163%' or
cm.course_id like '%BIO203%' or
cm.course_id like '%SCI102%' or
cm.course_id like '%PHC101%' or
cm.course_id like '%CLS105%' or
cm.course_id like '%BMS191%' or
cm.course_id like '%BMS105%' or
cm.course_id like '%BMS129%' or
cm.course_id like '%PHM101%' or
cm.course_id like '%BMS291%' or
cm.course_id like '%EHR101%' or
cm.course_id like '%EHR119%' or
cm.course_id like '%EHR221%' or
cm.course_id like '%BMS171%' or
cm.course_id like '%BMS126%' or
cm.course_id like '%EHR109%' or
cm.course_id like '%HIP100%' or
cm.course_id like '%BMS161%' or
cm.course_id like '%NRS112%' or
cm.course_id like '%NRS113%' or
cm.course_id like '%NRS211%' or
cm.course_id like '%MHP105%' or
cm.course_id like '%MHP109%' or
cm.course_id like '%MHP111%' or
cm.course_id like '%MHP112%' or
cm.course_id like '%JST301%' or
cm.course_id like '%ITC105%' or
cm.course_id like '%LAW113%' or
cm.course_id like '%JST123%' or
cm.course_id like '%LAW110%' or
cm.course_id like '%EMG100%' or
cm.course_id like '%ITC161%' or
cm.course_id like '%MGT100%' or
cm.course_id like '%EMG101%' or
cm.course_id like '%LAW116%' or
cm.course_id like '%ECO130%' or
cm.course_id like '%ITC106%' or
cm.course_id like '%PSY111%' or
cm.course_id like '%JST110%' or
cm.course_id like '%MKT110%' or
cm.course_id like '%ACC100%' or
cm.course_id like '%CCI102%' or
cm.course_id like '%VPA104%' or
cm.course_id like '%COM114%' or
cm.course_id like '%CCI101%' or
cm.course_id like '%COM127%' or
cm.course_id like '%EEB309%' or
cm.course_id like '%EML102%' or
cm.course_id like '%EED110%' or
cm.course_id like '%EPT126%' or
cm.course_id like '%EMM209%' or
cm.course_id like '%EPI105%' or
cm.course_id like '%EMS441%' or
cm.course_id like '%ESC407%' or
cm.course_id like '%ELN402%' or
cm.course_id like '%EEP417%' or
cm.course_id like '%EML440%' or
cm.course_id like '%SOC101%' or
cm.course_id like '%HCS102%' or
cm.course_id like '%LIT101%' or
cm.course_id like '%WEL118%' or
cm.course_id like '%COM120%' or
cm.course_id like '%HCS111%' or
cm.course_id like '%LIT107%' or
cm.course_id like '%HST101%' or
cm.course_id like '%LIT124%' or
cm.course_id like '%WEL218%' or
cm.course_id like '%IKC101%' or
cm.course_id like '%IKC100%' or
cm.course_id like '%INF111%'
) */
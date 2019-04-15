# TOL help

# Examining mobile use

# SQL Query:


# /* Fetching relevant data from aa to examine mobile logins */
# 
# select distinct cm.course_id, cm.course_name,
# aa.user_pk1,
# aa.session_id, aa.data,
# min(aa.timestamp) as timestamp_begin
# from activity_accumulator aa
# left join sessions s on aa.session_id = s.session_id and aa.user_pk1 = s.user_id_pk1
# left join course_main cm on aa.course_pk1 = cm.pk1
# left join course_users cu on cu.crsmain_pk1 = aa.course_pk1 and cu.users_pk1 = aa.user_pk1
# where (cm.course_id like '%HRM502_201930%' or cm.course_id like '%MGT510_201930%' or cm.course_id like '%PSY201_2019%')
# and cu.role = 'S' and cu.row_status = 0 -- Fetches only students who are currently enrolled
# group by course_id, course_name, user_pk1, aa.session_id, data

library(tidyverse)
df <- read_csv(file.choose())
df2 <- df %>% mutate(mobile = str_detect(data, "mobile."))
df2$user_pk1 <- factor(df2$user_pk1)
df3 <- df2 %>% group_by(course_name, user_pk1, session_id) %>% summarise(mobile = factor(max(mobile)), timestamp = min(timestamp_begin))


# plotting
g2 <- df3 %>% 
  filter(timestamp > as.Date('2019-02-28')) %>% 
  ggplot(aes(x = timestamp, y = mobile, color = mobile)) + geom_point(alpha = 0.05, size = 7) + facet_grid(course_name ~ .) + scale_color_brewer(palette = "Dark2") + theme_minimal()
g2

# summary
df_sum <- df3 %>% group_by(course_name, mobile) %>% tally()
knitr::kable(df_sum)

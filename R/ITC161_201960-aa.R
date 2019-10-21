library(tidyverse)
# reading data
aa <- read_csv(file.path('~', 'Data', 'ad hoc', 'aa ITC161 20191008.csv')) %>% 
  rename(pk1 = content_pk1)
cc <- read_csv(file.path('~', 'Data', 'ad hoc', 'cc all 201930.csv'))

aa <- aa %>% 
  filter(subject_code == 'S-ITC161_201930_W_D') %>% 
  inner_join(cc %>% 
               select(pk1, parent_pk1, title, description, web_url),
             by = 'pk1')

aa_grp_d <- aa %>%
  mutate(day = lubridate::yday(timestamp)) %>% 
  group_by(day, title) %>% 
  summarise(students = length(unique(id)),
            accesses = n())

aa_grp_d %>% ggplot(aes(x = day, y = students)) + geom_line()+ geom_smooth()

aa_grp_w <- aa %>%
  mutate(week = lubridate::week(timestamp)) %>% 
  group_by(week, title) %>% 
  summarise(students = length(unique(id)),
            clicks = n())

aa_grp_w %>% 
  ggplot(aes(x = week, y = clicks, size = students, color = log(clicks))) +
  scale_color_gradient(guide = FALSE, low = "darkblue", high = "red") +
  geom_point(alpha = 0.5) + 
  facet_wrap(~ title) +
  scale_y_log10() 

aa_table <- aa %>% 
  group_by(title) %>% 
  summarise(students = length(unique(id)),
            clicks = n())

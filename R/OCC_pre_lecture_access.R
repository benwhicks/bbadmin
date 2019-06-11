# Question: How long are students accessing pre-lecture materials 
# particularly in week 4 or 5

# file called aa S-OCC104_2019... in ad hoc folder
library(tidyverse)
library(lubridate)
library(lakit)
aa <- read_csv(file.path('~', 'Data', 'ad hoc', 'aa S-OCC104_201930_PT_I 20190603.csv'))
cc_full <- read_csv(file.path('~', 'Data', 'ad hoc', 'cc S-OCC104_201930_PT_I 20190603.csv'))

cc <- cc_full %>% select(pk1, parent_pk1, 
                         position, title, description, folder_ind)

prep_titles <- unique(cc$title[str_detect(cc$title, "Lecture Pre")])
cc <- cc %>% mutate(prep = if_else(title %in% prep_titles, T, F))

aa_sum <- aa %>% 
  select(s_id, timestamp, role, session_id, content_pk1) %>% 
  inner_join(cc %>% 
          select(content_pk1 = pk1, title, folder_ind, prep)) %>% 
  filter(role == 'S')

aa_timer <- aa %>% arrange(id, session_id, timestamp)
aa_timer$duration <- intervals(aa_timer$timestamp)
aa_timer$s_id_to <- c(aa_timer$s_id[2 : nrow(aa_timer)] , NA)
aa_timer$session_id_to <- c(aa_timer$session_id[2 : nrow(aa_timer)], NA)
aa_timer <- aa_timer %>% 
  mutate(duration = if_else(session_id == session_id_to & s_id == s_id_to,
                            duration, 0))
aa_timer <- aa_timer %>%
  filter(role == 'S') %>% 
  select(s_id, content_pk1, duration, timestamp) %>% 
  inner_join(cc %>% 
               select(content_pk1 = pk1, title, folder_ind, prep))

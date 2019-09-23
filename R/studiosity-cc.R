library(tidyverse)
# cc <- read_csv(file.choose())

# Looking at activity

aa <- read_csv(file.path('~', 'Data', 'ad hoc', 'aa studiosity explore.csv'))

aa$studiosity_related <- str_detect(aa$data, "tudiosity")

aa %>% group_by(studiosity_related, subject) %>% 
  tally()

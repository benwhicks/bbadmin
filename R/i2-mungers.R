# For pre processing aa, fm, gb, cc tables prior to tableau dashboard prep.

library(tidygraph)
library(tidyverse)
library(lubridate)

SESSIONSTART <- as_datetime('2019-03-01')

# Aggregate aa to weekly
aa <- read_csv(file = file.choose())

# Augment cc
cc <- read_csv(file.choose())
cc_nest <- cc %>% 
  group_by(subject, subject_site_code) %>% 
  nest()

# TODO: Impute discussion forum content

# TODO: Possible scrap some of the unused stuff - the COURSE_DEFAULT.. garbage

# TODO: Generate x,y coordinates for graph

# fm Graph

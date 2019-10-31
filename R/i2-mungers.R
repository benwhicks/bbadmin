# For pre processing aa, fm, gb, cc tables prior to tableau dashboard prep.

library(tidygraph)
library(tidyverse)
library(lubridate)


# Session dates -----------------------------------------------------------

# 201930 : 2019-03-04 to 2019-06-21
# 201945 : 2019-05-27 to 2019-08-16
# 201960 : 2019-07-15 to 2019-11-01
# 201975 : 2019-09-02 to 2019-12-20

SESSIONSTART <- as_datetime('2019-05-27')

# Aggregate aa to weekly
aa <- read_csv(file = file.choose(),
               col_types = "ccccccncnT")
aa$week_dbl <- (yday(aa$initial_datetime_access) - yday(SESSIONSTART))/7
aa$week <- ceiling(aa$week_dbl)

aa_weekly <- aa %>% 
  group_by(lastname, firstname, id, 
           subject, subject_code, subject_site_code,
           status, content_pk1, week) %>% 
  summarise(access_minutes = sum(access_minutes, na.rm = T),
            clicks = n(),
            last_access = max(initial_datetime_access))

# Augment cc
cc_all <- read_csv(file.choose())
pages_to_hide <- c("* For academics",
                   "COURSE_DEFAULT.Information.CONTENT_LINK.label",
                   "COURSE_DEFAULT.Content.CONTENT_LINK.label",
                   #"CSU Library",
                   "Important Forms", 
                   "Individual Support", 
                   "Interact2 Help and Support", # Assuming this is help for academics in design?
                   "Learning Opportunities",
                   "Making sure your site meets accessibility guidelines",
                   "Making the most of your home page",
                   "Most Accessed Student Policies",
                   #"Student Calendar",                     
                   "Student Central",                                   
                   "Study Guides",                                    
                   "The Student Portal",
                   "Useful Links",                                 
                   "Using icons",                                       
                   "Using images",                                        
                   "Using this Faculty Template",
                   "Using your mobile device for study and research",
                   "Workshops")
cc_filt <- cc_all %>% filter(!(cc_all$title %in% pages_to_hide))
cc_nest <- cc_filt %>% 
  group_by(subject, subject_site_code) %>% 
  nest()

cc_make_graph <- function(cc) {
  edges <- cc %>% 
    mutate(
      from = as.character(parent_pk1),
      to = as.character(content_pk1)
    ) %>% 
    select(from, to) %>% 
    filter(!is.na(from))
  nodes <- cc %>% 
    mutate(id = as.character(content_pk1)) %>% 
    select(id, title)
  # Completing nodes
  nodes_filler <- tibble(
    id = c(setdiff(edges$from, nodes$id),
           setdiff(edges$to, nodes$id)),
    title = ""
  )
  nodes <- bind_rows(nodes, nodes_filler)
  g <- tidygraph::tbl_graph(nodes = nodes, edges = edges)
  return(g)
}

graph_xy_fetch <- function(g, layout = "fr") {
  # To be joined with course contents under id and title fields.
  # id will need to be converted back to course_pk1
  lyt <- create_layout(g, layout = layout)
  lyt <- lyt %>% 
    mutate(content_pk1 = as.numeric(id)) %>% 
    select(-id, -.ggraph.orig_index, -circular, -.ggraph.index)
  return(lyt)
}

graph_path_fetch <- function(new_data) {
  to_df <- new_data %>% 
    select(parent_pk1 = content_pk1,
           x2 = x, y2 = y)
  df <- new_data %>% 
    select(content_pk1, parent_pk1,
           x1 = x, y1 = y) %>% 
    left_join(to_df, by = "parent_pk1") %>% 
    na.omit()
  # Changing to path list
  df <- df %>% 
    mutate(path_id = paste("path", row_number()))
  df_paths <- tibble(path_id = rep(df$path_id, 2),
                     path_order = c(rep(1, nrow(df)), rep(2, nrow(df))),
                     x = c(df$x1, df$x2),
                     y = c(df$y1, df$y2)) %>% 
  arrange(path_id, path_order)
  return(df_paths)
}

cc_nest <- cc_nest %>% 
  mutate(graph = map(data, cc_make_graph))

cc_nest <- cc_nest %>% 
  mutate(layout = map(graph, graph_xy_fetch))

cc_nest <- cc_nest %>% 
  mutate(new_data = map2(.x = data, 
                            .y = layout, 
                            .f = ~left_join(.x, .y)))

cc_nest <- cc_nest %>% 
  mutate(pathlist = map(new_data, graph_path_fetch))

cc_new <- cc_nest %>% 
  select(subject_site_code, subject, new_data) %>% 
  unnest(cols = c(new_data))

cc_pathlist <- cc_nest %>% 
  select(subject_site_code, subject, pathlist) %>% 
  unnest(cols = c(pathlist))

# Writing out cc new data
write_csv(cc_new, path = file.path('~', 'Data', 'i2 Dashboard PoC', 'test_cc.csv'))
write_csv(cc_pathlist, path = file.path('~', 'Data', 'i2 Dashboard PoC', 'test_cc_pathlist.csv'))

# TODO: Impute discussion forum content - - - this may require changing the aa SQL query to include title or data or something

# fm Graph

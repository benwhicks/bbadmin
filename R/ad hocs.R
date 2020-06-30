# HEPPP ad hoc
library(tidyverse)
library(tidygraph)
library(ggraph)
# 1 deep dive from week 3 4 or 5, also maybe total minutes per student. Want to know
# if students are actually using the material, and how much. Theory is that there
# might be more content than what the students are actually using
aa <- read_csv(file.path("~","Data", "ad hoc", "aa S-OCC104_201930_PT_I 20190415.csv"))
cc <- read_csv(file.path("~","Data", "ad hoc", "cc S-OCC104_201930_PT_I 20190415.csv"))

aa2 <- aa %>% filter(!is.na(id)) %>% arrange(lastname, firstname, session_id, timestamp)
aa2$seconds <- c(aa2$timestamp[2:nrow(aa2)] - aa2$timestamp[1:(nrow(aa2)-1)], 0)
aa2$samesess <- c(aa2$session_id[2:nrow(aa2)] == aa2$session_id[1:(nrow(aa2)-1)], FALSE)
aa2 <- aa2 %>% mutate(seconds = seconds * samesess)

cc_times <- aa2 %>% group_by(content_pk1) %>% summarise(minutes = as.numeric(sum(seconds)/60))
cc_times$content_pk1 <- factor(cc_times$content_pk1)

cc_edgeprep <- cc %>% filter(!is.na(parent_pk1)) %>% select(parent_pk1, pk1)
cc_edges <- data.frame(from = factor(cc_edgeprep$parent_pk1), 
                       to = factor(cc_edgeprep$pk1))
cc_nodes <- data.frame(id = factor(cc$pk1), site = cc$title)
cc_node_hits_aa <- aa %>% group_by(content_pk1) %>% tally()
names(cc_node_hits_aa) <- c("id", "hits")
cc_nodes <- merge(cc_nodes, cc_node_hits_aa, all.x = T)
cc_nodes <- merge(cc_nodes, cc_times, all.x = T)
cc_graph <- tbl_graph(nodes = cc_nodes, edges = cc_edges)
ggraph(cc_graph, layout = "nicely") + 
  geom_node_point(aes(color = minutes, size = hits)) +
  scale_size(guide = "none") +
  scale_color_gradient2(low = "Blue", mid = "Green", high = "Red", guide = "none") +
  geom_edge_link() + 
  geom_node_text(aes(label = site, alpha = hits), repel = T) +
  scale_alpha(guide = "none") +
  theme_graph()


# Request for Schoon
library(tidyverse)
s <- "{\"handler\":\"resource/x-bb-document\",\"title\":\"CT Abdomen Prac/Study resource\",\"parent\":\"_2933127_1\",\"synthetic\":false}"
trim_data <- function(s) {
  return(s %>% 
           str_remove('^\\{.*title":"') %>% 
           str_remove('",.*\\}$'))
}
trim_data(s)
aa_all <- read_csv(file.path('~', 'Data', 'ad hoc', 'aa MRS 2019.csv'),
               col_types = 'cTccccnncccn')
aa <- aa_all %>% 
  mutate(data = trim_data(data))

aa_summary <- aa %>% 
  group_by(subject_code, subject, data) %>% 
  summarise(
    accesses = n(),
    users = n_distinct(id)
  )

write_csv(aa_summary, file.path('~', 'Data', 'ad hoc', 'MRS 2019 activity summary.csv'))

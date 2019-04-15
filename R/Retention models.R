# Baysian network analysis on grade data, trying to predict FW for retention
library(tidyverse)
library(bnlearn)

datdir <- file.path("~", "Data", "Retention")
grade_df <- read_csv(file.path(datdir, "1830 grades cross tab.csv"))
grade_data <- grade_df %>% select(Grade, 
                                  `No of Accesses pre HECS Date`,
                                  `No of Clicks pre HECS Date`,
                                  `No of Minutes pre HECS Date`)
grade_data$Grade <- factor(grade_data$Grade, levels = c("FW", "FL", "SY", "PS", "CR", "DI", "HD"))
pf_data <- grade_data %>% mutate(PF = factor(ifelse(str_detect(Grade, "FW|FL"), "F", "P"))) %>%
  plyr::rename(replace = c("No of Accesses pre HECS Date" = "Accesses", 
                           "No of Clicks pre HECS Date" = "Clicks",
                           "No of Minutes pre HECS Date" = "Minutes"))
pf_data$Grade <- NULL

g <- pf_data %>% ggpairs(aes(color = PF, alpha = 0.01)) + theme_minimal()
g

g3 <- grade_data %>% ggpairs(aes(color = Grade, alpha = 0.01)) + theme_minimal()
g3

g4 <- grade_data %>% select(`No of Accesses pre HECS Date`, Grade) %>% filter(`No of Accesses pre HECS Date` < 100) %>% ggpairs(aes(color = Grade, alpha = 0.01)) + theme_minimal()
g4

# Baysian model
res <- hc(pf_data)
plot(res)
fit.bay <- bn.fit(res, data = pf_data)

# Logistic model
fit.logit <- glm(PF ~ Accesses + Clicks + Minutes, 
                 data = pf_data,
                 family = binomial(link = "logit"))



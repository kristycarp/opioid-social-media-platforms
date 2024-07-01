library(tidyverse)
library(visR)

# Pull in evaluatation
platforms_df = read.csv(here::here("platform_list.csv")) 
google_queries = readRDS("google_search_results.RDS")
platforms_df = platforms_df %>% left_join(google_queries, by = c("URL" = "sites"))

# Create cleaned version of platform list, with indicator of if they were kept or what criteria they were eliminate at
platforms_df %>% 
  mutate(criteria1 = active_site != 'No',
         criteria2 = criteria1 & meets_social_media_def == 'Yes',
         criteria3 = criteria1 & criteria2 & private_messages != 'Yes',  
         criteria4 = criteria1 & criteria2 & criteria3 & default_lang_not_english != 'Yes' & primary_country_us != 'No',
         criteria5 = criteria1 & criteria2 & criteria3 & criteria4 & n_hits > 25000) %>% 
  arrange(-criteria1, -criteria2, -criteria3, -criteria4, -criteria5, -n_hits) %>% 
  mutate(dropped_at = rowSums(across(starts_with("criteria"))) + 1,
         dropped_at = glue::glue("Criteria {dropped_at}"), 
         dropped_at = ifelse(dropped_at == "Criteria 6", "Kept for future assessment", dropped_at)) %>% 
  select(Platform, dropped_at, n_hits) %>% 
  write.csv("filtered_platforms.csv", row.names = F)
    
# Create visualization of how many platforms were eliminated at each criteria
attrition = visR::get_attrition(
  platforms_df,
  criteria_descriptions = c("1. Active domain",
                            "2. Meets definition of social media", 
                            "3. Not a private messaging platform", 
                            "4. Default language in English or based in the US",
                            "5. Sufficient discussion of opioids (>25,000 search hits)"),
  criteria_conditions = c(
                      "active_site != 'No'", 
                      "meets_social_media_def == 'Yes'",
                      "private_messages != 'Yes'", 
                      "default_lang_not_english != 'Yes' & primary_country_us != 'No'", 
                      "n_hits > 25000"),
  subject_column_name = "Platform"
)


attrition %>% visR::visr("Criteria", "Remaining N")

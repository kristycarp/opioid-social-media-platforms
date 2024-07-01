## Some quick skeleton code on how to ping the Google Custom Search API:
##  https://developers.google.com/custom-search/v1/introduction/
##  More parameters: https://developers.google.com/custom-search/v1/reference/rest/v1/cse/list
##  Don't forget that you'll need to make your own API key (up to 100 queries per day for free)
##  and you'll need to make a search engine: https://programmablesearchengine.google.com/controlpanel/all

## Imports ----
library(httr)
library(tidyverse)
library(dotenv)

# Load evaluation of each platform, filter to those that were kept after prior criteria were applied
platforms_df = read.csv(here::here("platform_list.csv")) %>% 
  filter(active_site != 'No',
         meets_social_media_def == 'Yes',
         private_messages != 'Yes',
         default_lang_not_english != 'Yes',
         primary_country_us != 'No',
         top11 == 'Yes') %>% 
  select(Platform, URL)

# load terms
algospeak_df = read.csv(here::here("all-algospeak-terms.csv")) %>%
  filter(include == 'yes') %>%
  filter(n > 4)

informal_df = read.csv(here::here("informal_with_freqs.csv")) %>%
  filter(max_freq > 90)

household_noun_df = read.csv(here::here("household-terms.csv"))

formal_df = read.csv(here::here("formal-terms.csv"))

csv_name = "google_search_results_household.csv"
term_df = household_noun_df


## Constants ----
## THESE CONSTANTS ARE PERSON-SPECIFIC. You need to make your own API key
## and your own search engine. See notes up top. 

# load in secret info
dotenv::load_dot_env()

email1 <- Sys.getenv("EMAIL1")
api1 <- Sys.getenv("API_KEY1")
engine1 <- Sys.getenv("ENGINE_ID1")
email2 <- Sys.getenv("EMAIL2")
api2 <- Sys.getenv("API_KEY2")
engine2 <- Sys.getenv("ENGINE_ID2")


# List of API keys
API_keys = 
  list(email1 = c(api_key = api1, search_engine_id = engine1),
       email2 = c(api_key = api2, search_engine_id = engine2))


## Helper functions ----
query_google <- function(search_term, 
                         search_site = NULL,
                         api_key, 
                         search_engine_id,
                         lang = "lang_en") {
  url <- "https://www.googleapis.com/customsearch/v1"
  
  site_search_file <- ifelse(is.null(search_site), NULL, "i")
  
  query <- list(
    key = api_key,
    cx = search_engine_id, 
    q = search_term,
    lr = NULL, 
    siteSearch = search_site, 
    siteSearchFilter = site_search_file
  )
  
  x <- httr::GET(url, query = query)
  
  if (x$status_code == 200) {
    return(x)
  } else {
    stop("Invalid API response.")
  }
}

parse_results <- function(response_object) {
  temp_x <- httr::parsed_content(response_object)
  list(n_response = as.integer(temp_x$searchInformation$totalResults), 
       date = as.Date(format(response_object$date, tz = "us/pacific", origin ='GMT', usetz=TRUE)))
}

## Create a table with all your queries and sites of interest ----
query_grid  <- expand.grid(
  queries = unique(term_df$term),
  sites = platforms_df$URL,
  stringsAsFactors = FALSE
)
query_grid$n_response <- NA
query_grid$date <- NA

## Loop through the query grid and SAVE THE RESPONSE OBJECTS so you don't
## need to do it again if it already exists
api_key_index = 1

for (i in 1:nrow(query_grid)) {
  search_term <- query_grid$queries[i]
  print(search_term)
  site <- query_grid$sites[i]
  
  f_name <- sprintf("response_%s_%s.RDS",
                    search_term,
                    sub(".com", "", site, fixed = TRUE))
  
  if (!file.exists(here::here("query_outputs", f_name))) {
  
    temp_x = 
      tryCatch(
        expr = 
          query_google(
            search_term = search_term,
            search_site = site,
            api_key = API_keys[[api_key_index]] %>% pluck("api_key"),
            search_engine_id = API_keys[[api_key_index]] %>% pluck("search_engine_id")), 
        error = function(e) {
          if((api_key_index + 1) > length(API_keys)) stop("No more valid API keys")
          api_key_index = api_key_index + 1
          query_google(
            search_term = search_term,
            search_site = site,
            api_key = API_keys[[api_key_index]] %>% pluck("api_key"),
            search_engine_id = API_keys[[api_key_index]] %>% pluck("search_engine_id"))
          }
        )
    
    saveRDS(temp_x, here::here("query_outputs", f_name))
  } else {
    temp_x <- readRDS(here::here("query_outputs", f_name))
  }
  parsed_results = parse_results(temp_x)

  query_grid$n_response[i] <- parsed_results$n_response
  query_grid$date[i] <- parsed_results$date
}

agg_queries = query_grid %>% group_by(sites) %>% summarize(n_hits = sum(n_response)) %>% arrange(-n_hits)
write.csv(agg_queries, csv_name, row.names = F)

library(tidyverse)
library(jsonlite)
library(ggraph)
library(stringr)

na_if_null <- function(x) {
    x[is.null(x)] <- NA
    x
}

get_bills_rows <-  function(x) {
    initiators <- map_dfr(x$initiators, function(y) {
        if ("official" %in% names(y)) {
            data.frame(
                init_id = na_if_null(y$official$person$id),
                init_fullname = str_trim(paste(y$official$person$surname, y$official$person$firstname, y$official$person$patronymic)))
        } else {
            if ("outer" %in% names(y)) {
                data.frame(
                    init_id = na_if_null(y$outer$person$id),
                    init_fullname = str_trim(paste(y$outer$person$surname, y$outer$person$firstname, y$outer$person$patronymic)))
            } else {
                data.frame(
                    init_id = na_if_null(y$person$id),
                    init_fullname = str_trim(paste(y$person$surname, y$person$firstname, y$person$patronymic)))
            }
        }
    })
    initiators %>% 
        mutate(
            number = as.character(x$number),
            department = na_if_null(x$mainExecutives$executive$department),
            type = x$type
        )
}

change_if_contains <- function(x, pattern, replacement = NULL) {
    if (is.null(replacement)) {
        replacement <- pattern
    }
    x <- as.character(x)
    x[grepl(pattern, x, fixed = TRUE)] <- replacement
    x
}

bills_json <- fromJSON("bills-skl8.json", simplifyDataFrame = FALSE)
all_init <- map_dfr(bills_json, get_bills_rows)


initiators.y <- all_init %>% 
    filter(type == "Проект Закону") %>% 
    select(number, init_fullname)

init <-  all_init %>% 
    inner_join(y = initiators.y, by = "number") %>% 
    filter(init_fullname.x != init_fullname.y) %>% 
    group_by(init_fullname.x, init_fullname.y) %>% 
    count() %>% 
    mutate(pair = (
        sort(c(init_fullname.x, init_fullname.y)) %>% paste0(collapse = "|")
        )) %>% 
    group_by(pair) %>% 
    mutate(order = seq_along(pair)) %>% 
    filter(order == 1) %>% 
    ungroup() %>% 
    select(-pair, -order)

mps_posts <- fromJSON("mp-posts.json")

bills_number <- all_init %>% 
    group_by(init_id, init_fullname) %>% 
    count() %>% 
    rename(bills_number = n)


mps <- mps_posts %>% 
    select(full_name, mp_id) %>% 
    distinct() %>% 
    left_join(mps_posts %>% 
                  filter(unit_type %in% c("fra", "grp")) %>% 
                  select(mp_id, full_name, unit_name) %>% 
                  distinct()) %>% 
    mutate(unit_name = case_when(
        is.na(unit_name) ~ "Позафракційні",
        TRUE ~ unit_name)) %>% 
    mutate(full_name = str_trim(full_name)) %>% 
    left_join(bills_number, by=c("mp_id" = "init_id", "full_name" = "init_fullname")) %>% 
    arrange(full_name)
    
save(mps, file =  "mps.Rda")
save(init, file =  "init.Rda")